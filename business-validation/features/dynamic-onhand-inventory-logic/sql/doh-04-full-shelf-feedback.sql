/*=================================================================
  Epic 4A: Dynamic On-Hand Inventory Logic
  Test Case: DOH-04 — 100% Full Shelf Feedback
  
  Precondition: Feedback_ShelfCapacity = 1.0
  Expected:
    1. Override: OnHand_Ending = ROUND(Max_ShelfCapacityQty * 1.0)
    2. Dynamic_OnHandQty remains independent (not overwritten)
    3. Dynamic continues following rolling formula after feedback
  
  Sources:
    RETAILER_QA.TECHNICAL.Stg_Retailers_OnhandCalcFromDelvry
    RETAILER_QA.TECHNICAL.Stg_Circana_OnhandCalcFromDelvry
  
  Retailers: Albertsons, Kroger, Dollar General, Family Dollar,
             Meijer, Target, Giant Eagle, Brookshire Grocery
  Date range: September 2026
  =================================================================*/

WITH candidates AS (
    -- Target (0001000312)
    SELECT '0011299689' AS cn, '81016960336' AS ean UNION ALL
    SELECT '0011299689', '07800003389' UNION ALL
    SELECT '0011310272', '07800005240' UNION ALL
    -- Dollar General (0001000465)
    SELECT '0012713947', '07800008216' UNION ALL
    SELECT '0012141455', '07800000386' UNION ALL
    SELECT '0012713947', '07800008246' UNION ALL
    -- Kroger (0001000889)
    SELECT '0011196008', '07800005316' UNION ALL
    SELECT '0012031236', '89899901226' UNION ALL
    SELECT '0011196008', '07800003528' UNION ALL
    -- Albertsons (0001001169)
    SELECT '0012650452', '07800002505' UNION ALL
    SELECT '0011996425', '85300400402' UNION ALL
    SELECT '0012650452', '81012852269' UNION ALL
    -- Family Dollar (0001001286)
    SELECT '0012116886', '07181780009' UNION ALL
    SELECT '0011306536', '07800002374' UNION ALL
    SELECT '0011310463', '07800008216' UNION ALL
    -- Meijer (0001014835)
    SELECT '0012266377', '07800000224' UNION ALL
    SELECT '0012433199', '07618364356' UNION ALL
    SELECT '0012433199', '60491300041' UNION ALL
    -- Brookshire Grocery (0001014797) — Circana
    SELECT '0012094734', '07800008346' UNION ALL
    SELECT '0011290051', '07800003914' UNION ALL
    SELECT '0012094734', '07800008213' UNION ALL
    -- Giant Eagle (0001014823) — Circana
    SELECT '0011258397', '07800005288' UNION ALL
    SELECT '0011258397', '07800005246' UNION ALL
    SELECT '0011258397', '07800000676'
),

chain_map(cid, cname) AS (
    SELECT '0001001169', 'Albertsons' UNION ALL
    SELECT '0001000889', 'Kroger' UNION ALL
    SELECT '0001000465', 'Dollar General' UNION ALL
    SELECT '0001001286', 'Family Dollar' UNION ALL
    SELECT '0001014835', 'Meijer' UNION ALL
    SELECT '0001000312', 'Target' UNION ALL
    SELECT '0001014823', 'Giant Eagle' UNION ALL
    SELECT '0001014797', 'Brookshire Grocery'
),

all_stg AS (
    SELECT *
    FROM RETAILER_QA.TECHNICAL."Stg_Retailers_OnhandCalcFromDelvry"
    WHERE "BusDate" BETWEEN '2026-09-01' AND '2026-09-30'
    UNION ALL
    SELECT *
    FROM RETAILER_QA.TECHNICAL."Stg_Circana_OnhandCalcFromDelvry"
    WHERE "BusDate" BETWEEN '2026-09-01' AND '2026-09-30'
),

deduped AS (
    SELECT s.*
    FROM all_stg s
    JOIN candidates c
      ON s."CustomerNumber" = c.cn AND s."EAN11" = c.ean
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY s."CustomerNumber", s."EAN11", s."BusDate"
        ORDER BY s."seq_num" DESC
    ) = 1
),

feedback_history AS (
    SELECT "CustomerNumber", "EAN11",
        MIN(CASE WHEN "Feedback_ShelfCapacity" IS NOT NULL THEN "BusDate" END) AS first_feedback_date
    FROM deduped
    GROUP BY "CustomerNumber", "EAN11"
),

with_lag AS (
    SELECT
        d.*,
        cm.cname AS "Retailer",
        fh.first_feedback_date,
        LAG(d."Dynamic_OnHandQty") OVER (
            PARTITION BY d."CustomerNumber", d."EAN11"
            ORDER BY d."BusDate"
        ) AS "Previous_Dynamic_OnHandQty"
    FROM deduped d
    LEFT JOIN feedback_history fh
      ON fh."CustomerNumber" = d."CustomerNumber" AND fh."EAN11" = d."EAN11"
    LEFT JOIN chain_map cm ON cm.cid = d."NationalChainID"
)

SELECT
    "Retailer",
    "NationalChainID",
    "CustomerNumber",
    "EAN11",
    "BusDate",
    "Feedback_ShelfCapacity",
    "Max_ShelfCapacityQty",

    -- Override columns
    CASE WHEN "Feedback_ShelfCapacity" = 1.0
        THEN ROUND("Max_ShelfCapacityQty" * 1.0, 0) ELSE NULL
    END AS "Expected_OnHand_Ending",
    "OnHand_Ending",
    CASE WHEN "Feedback_ShelfCapacity" = 1.0
        THEN "OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 1.0, 0) ELSE NULL
    END AS "Variance",

    -- Dynamic columns
    "Previous_Dynamic_OnHandQty",
    "Dynamic_OnHandQty",
    "SalesQty",
    "DeliveredQty",

    -- Dynamic result
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL THEN 'N/A (first day)'
        WHEN (first_feedback_date IS NULL OR "BusDate" < first_feedback_date)
         AND ABS("Dynamic_OnHandQty" - "OnHand_Ending") < 1 THEN 'PASS'
        WHEN first_feedback_date IS NOT NULL AND "BusDate" >= first_feedback_date
         AND ABS("Dynamic_OnHandQty" - GREATEST(COALESCE("Previous_Dynamic_OnHandQty",0)
           + "DeliveredQty" - "SalesQty", 0)) < 1 THEN 'PASS'
        ELSE 'FAIL'
    END AS "Dynamic_Result",

    -- Override result
    CASE
        WHEN "Feedback_ShelfCapacity" = 1.0
         AND ABS("OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 1.0, 0)) < 1 THEN 'PASS'
        WHEN "Feedback_ShelfCapacity" = 1.0 THEN 'FAIL'
        ELSE 'N/A'
    END AS "Override_Result",

    -- Combined result
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL THEN 'N/A (first day)'
        WHEN "Feedback_ShelfCapacity" = 1.0
         AND ABS("OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 1.0, 0)) < 1
         AND ABS("Dynamic_OnHandQty" - GREATEST(COALESCE("Previous_Dynamic_OnHandQty",0)
           + "DeliveredQty" - "SalesQty", 0)) < 1 THEN 'PASS'
        WHEN "Feedback_ShelfCapacity" != 1.0 OR "Feedback_ShelfCapacity" IS NULL
            THEN CASE
                WHEN (first_feedback_date IS NULL OR "BusDate" < first_feedback_date)
                 AND ABS("Dynamic_OnHandQty" - "OnHand_Ending") < 1 THEN 'PASS'
                WHEN first_feedback_date IS NOT NULL AND "BusDate" >= first_feedback_date
                 AND ABS("Dynamic_OnHandQty" - GREATEST(COALESCE("Previous_Dynamic_OnHandQty",0)
                   + "DeliveredQty" - "SalesQty", 0)) < 1 THEN 'PASS'
                ELSE 'FAIL'
            END
        ELSE 'FAIL'
    END AS "Result"

FROM with_lag
ORDER BY "Retailer", "CustomerNumber", "EAN11", "BusDate";
