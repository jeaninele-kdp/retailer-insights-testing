/*=================================================================
  Epic 4A: Dynamic On-Hand Inventory Logic
  Test Case: DOH-03 — 50% Full Shelf Feedback
  
  Precondition: Feedback_ShelfCapacity = 0.5
  Expected:
    1. Override: OnHand_Ending = ROUND(Max_ShelfCapacityQty * 0.5)
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
    SELECT '0011196189' AS cn, '07800003389' AS ean UNION ALL
    SELECT '0011196189', '07800002945' UNION ALL
    SELECT '0011196189', '07800003373' UNION ALL
    -- Dollar General (0001000465)
    SELECT '0011293197', '07800003528' UNION ALL
    SELECT '0011293155', '07800008216' UNION ALL
    SELECT '0011293155', '07800005316' UNION ALL
    -- Kroger (0001000889)
    SELECT '0012553524', '07800002657' UNION ALL
    SELECT '0011239520', '07800000531' UNION ALL
    SELECT '0012553524', '60491300016' UNION ALL
    -- Albertsons (0001001169)
    SELECT '0011337261', '85300400402' UNION ALL
    SELECT '0012337086', '84259513646' UNION ALL
    SELECT '0011337261', '81369402669' UNION ALL
    -- Family Dollar (0001001286)
    SELECT '0011306507', '07800000386' UNION ALL
    SELECT '0011306475', '07800008216' UNION ALL
    SELECT '0012530541', '07800008216' UNION ALL
    -- Meijer (0001014835)
    SELECT '0012283915', '07800005346' UNION ALL
    SELECT '0012283915', '84259514137' UNION ALL
    SELECT '0012283915', '84259513509' UNION ALL
    -- Brookshire Grocery (0001014797) — Circana
    SELECT '0011984301', '07800003390' UNION ALL
    SELECT '0012091717', '84259512175' UNION ALL
    SELECT '0011984301', '07800015288' UNION ALL
    -- Giant Eagle (0001014823) — Circana
    SELECT '0011242796', '07800014816' UNION ALL
    SELECT '0011242796', '07929860007' UNION ALL
    SELECT '0011242796', '07800015216'
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

    -- Override validation columns
    CASE
        WHEN "Feedback_ShelfCapacity" = 0.5
            THEN ROUND("Max_ShelfCapacityQty" * 0.5, 0)
        ELSE NULL
    END AS "Expected_OnHand_Ending",

    "OnHand_Ending",

    CASE
        WHEN "Feedback_ShelfCapacity" = 0.5
            THEN "OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 0.5, 0)
        ELSE NULL
    END AS "Variance",

    -- Dynamic validation columns
    "Previous_Dynamic_OnHandQty",
    "Dynamic_OnHandQty",
    "SalesQty",
    "DeliveredQty",

    -- Dynamic calculation result
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL
            THEN 'N/A (first day)'
        WHEN (first_feedback_date IS NULL OR "BusDate" < first_feedback_date)
         AND ABS("Dynamic_OnHandQty" - "OnHand_Ending") < 1
            THEN 'PASS'
        WHEN first_feedback_date IS NOT NULL
         AND "BusDate" >= first_feedback_date
         AND ABS("Dynamic_OnHandQty"
             - GREATEST(COALESCE("Previous_Dynamic_OnHandQty", 0)
               + "DeliveredQty" - "SalesQty", 0)) < 1
            THEN 'PASS'
        ELSE 'FAIL'
    END AS "Dynamic_Result",

    -- Override result
    CASE
        WHEN "Feedback_ShelfCapacity" = 0.5
         AND ABS("OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 0.5, 0)) < 1
            THEN 'PASS'
        WHEN "Feedback_ShelfCapacity" = 0.5
            THEN 'FAIL'
        ELSE 'N/A'
    END AS "Override_Result",

    -- Combined PASS/FAIL
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL THEN 'N/A (first day)'
        WHEN "Feedback_ShelfCapacity" = 0.5
         AND ABS("OnHand_Ending" - ROUND("Max_ShelfCapacityQty" * 0.5, 0)) < 1
         AND ABS("Dynamic_OnHandQty"
             - GREATEST(COALESCE("Previous_Dynamic_OnHandQty", 0)
               + "DeliveredQty" - "SalesQty", 0)) < 1
            THEN 'PASS'
        WHEN "Feedback_ShelfCapacity" != 0.5 OR "Feedback_ShelfCapacity" IS NULL
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
