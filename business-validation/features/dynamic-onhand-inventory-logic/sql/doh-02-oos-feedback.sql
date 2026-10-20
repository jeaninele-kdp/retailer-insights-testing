/*=================================================================
  Epic 4A: Dynamic On-Hand Inventory Logic
  Test Case: DOH-02 — Out of Stock Feedback
  
  Precondition: Feedback_ShelfCapacity = 0
  Expected:
    1. Override inventory (OnHand_Ending) = 0 when fb = 0
    2. Dynamic_OnHandQty remains independent (not reset by feedback)
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
    SELECT '0011299689' AS cn, '89899901200' AS ean UNION ALL
    SELECT '0011229742', '81016960419' UNION ALL
    SELECT '0013300619', '07800005440' UNION ALL
    -- Dollar General (0001000465)
    SELECT '0012002015', '84259513507' UNION ALL
    SELECT '0012433715', '88772500218' UNION ALL
    SELECT '0012002015', '07800011340' UNION ALL
    -- Kroger (0001000889)
    SELECT '0012031236', '81016960861' UNION ALL
    SELECT '0012326353', '07618300804' UNION ALL
    SELECT '0012326353', '81985802002' UNION ALL
    -- Albertsons (0001001169)
    SELECT '0011337282', '88772500217' UNION ALL
    SELECT '0012645756', '60491300542' UNION ALL
    SELECT '0012645681', '07800001154' UNION ALL
    -- Family Dollar (0001001286)
    SELECT '0012197355', '07800002040' UNION ALL
    SELECT '0012227753', '07800002374' UNION ALL
    SELECT '0012176003', '07181780009' UNION ALL
    -- Meijer (0001014835)
    SELECT '0011194918', '81985802002' UNION ALL
    SELECT '0012283915', '84259513821' UNION ALL
    SELECT '0011194918', '07800000531' UNION ALL
    -- Brookshire Grocery (0001014797) — Circana
    SELECT '0011279399', '07800000161' UNION ALL
    SELECT '0012177574', '88772500005' UNION ALL
    SELECT '0011279399', '07800003823' UNION ALL
    -- Giant Eagle (0001014823) — Circana
    SELECT '0011244230', '07800001214' UNION ALL
    SELECT '0011244230', '07800012240' UNION ALL
    SELECT '0011344865', '07800002659'
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
    "OnHand_Ending",
    "Dynamic_OnHandQty",
    "Previous_Dynamic_OnHandQty",
    "SalesQty",
    "DeliveredQty",

    -- Expected effective inventory (override when fb=0, else OHE)
    CASE
        WHEN "Feedback_ShelfCapacity" = 0
            THEN 0
        ELSE "OnHand_Ending"
    END AS "Expected_Effective_Inventory",

    -- Variance: actual OHE vs expected
    CASE
        WHEN "Feedback_ShelfCapacity" = 0
            THEN "OnHand_Ending" - 0
        ELSE 0
    END AS "Variance",

    -- PASS/FAIL: Override check (OHE=0 when fb=0)
    CASE
        WHEN "Feedback_ShelfCapacity" = 0 AND ABS("OnHand_Ending") < 1
            THEN 'PASS'
        WHEN "Feedback_ShelfCapacity" = 0
            THEN 'FAIL'
        ELSE 'N/A (no fb=0)'
    END AS "Override_Result",

    -- PASS/FAIL: Dynamic independence (not reset by feedback)
    CASE
        WHEN "Feedback_ShelfCapacity" = 0 AND "Dynamic_OnHandQty" > 0
            THEN 'PASS (Dynamic > 0)'
        WHEN "Feedback_ShelfCapacity" = 0 AND "Dynamic_OnHandQty" = 0
         AND GREATEST(COALESCE("Previous_Dynamic_OnHandQty", 0)
             + "DeliveredQty" - "SalesQty", 0) = 0
            THEN 'PASS (rolling = 0)'
        WHEN "Feedback_ShelfCapacity" = 0 AND "Dynamic_OnHandQty" = 0
         AND COALESCE("Previous_Dynamic_OnHandQty", 0) > 0
            THEN 'FAIL (reset to 0)'
        ELSE 'N/A'
    END AS "Independence_Result",

    -- PASS/FAIL: Dynamic calculation continuity
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL
            THEN 'N/A (first day)'
        WHEN (first_feedback_date IS NULL OR "BusDate" < first_feedback_date)
         AND ABS("Dynamic_OnHandQty" - "OnHand_Ending") < 1
            THEN 'PASS (pre-fb)'
        WHEN first_feedback_date IS NOT NULL
         AND "BusDate" >= first_feedback_date
         AND ABS("Dynamic_OnHandQty"
             - GREATEST(COALESCE("Previous_Dynamic_OnHandQty", 0)
               + "DeliveredQty" - "SalesQty", 0)) < 1
            THEN 'PASS (rolling)'
        ELSE 'FAIL'
    END AS "Dynamic_Calc_Result"

FROM with_lag
ORDER BY "Retailer", "CustomerNumber", "EAN11", "BusDate";
