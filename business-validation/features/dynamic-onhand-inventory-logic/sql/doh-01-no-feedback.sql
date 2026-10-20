/*=================================================================
  Epic 4A: Dynamic On-Hand Inventory Logic
  Test Case: DOH-01 — No Account Manager Feedback
  
  Precondition: Feedback_ShelfCapacity IS NULL for all rows
  Expected: Dynamic_OnHandQty = OnHand_Ending (within rounding
            tolerance for Circana decimal OHE)
  
  Sources:
    RETAILER_QA.TECHNICAL.Stg_Retailers_OnhandCalcFromDelvry
    RETAILER_QA.TECHNICAL.Stg_Circana_OnhandCalcFromDelvry
  
  Retailers: Albertsons, Kroger, Dollar General, Family Dollar,
             Meijer, Target, Giant Eagle, Brookshire Grocery
  Date range: September 2026
  =================================================================*/

-- ═══════════════════════════════════════════════════════════════
-- QUERY 1: Full DOH-01 Row-Level Validation Evidence
-- ═══════════════════════════════════════════════════════════════

WITH candidates AS (
    -- Target (0001000312)
    SELECT '0011528343' AS cn, '07800015246' AS ean UNION ALL
    SELECT '0011535044', '07800002945' UNION ALL
    SELECT '0011528343', '07800015216' UNION ALL
    -- Dollar General (0001000465)
    SELECT '0012079171', '07800023040' UNION ALL
    SELECT '0012079171', '07800008240' UNION ALL
    SELECT '0012079171', '07800000337' UNION ALL
    -- Kroger (0001000889)
    SELECT '0012326353', '07800008246' UNION ALL
    SELECT '0012323156', '84259514137' UNION ALL
    SELECT '0012325971', '84259513821' UNION ALL
    -- Albertsons (0001001169)
    SELECT '0012645718', '07800008246' UNION ALL
    SELECT '0012642788', '07800008246' UNION ALL
    SELECT '0012642788', '07800005246' UNION ALL
    -- Family Dollar (0001001286)
    SELECT '0012701284', '07800008216' UNION ALL
    SELECT '0011900813', '07181700037' UNION ALL
    SELECT '0012068806', '07800008216' UNION ALL
    -- Meijer (0001014835)
    SELECT '0011264052', '07800008216' UNION ALL
    SELECT '0011270689', '07800005342' UNION ALL
    SELECT '0011270689', '07800001181' UNION ALL
    -- Brookshire Grocery (0001014797) — Circana
    SELECT '0011279514', '07800008316' UNION ALL
    SELECT '0011278614', '07800008216' UNION ALL
    SELECT '0011276693', '07800003526' UNION ALL
    -- Giant Eagle (0001014823) — Circana
    SELECT '0012276570', '07153730134' UNION ALL
    SELECT '0011478693', '07153702020' UNION ALL
    SELECT '0011344865', '07800002945'
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

with_lag AS (
    SELECT
        d.*,
        cm.cname AS "Retailer",
        LAG(d."Dynamic_OnHandQty") OVER (
            PARTITION BY d."CustomerNumber", d."EAN11"
            ORDER BY d."BusDate"
        ) AS "Previous_Dynamic_OnHandQty"
    FROM deduped d
    LEFT JOIN chain_map cm ON cm.cid = d."NationalChainID"
)

SELECT
    "Retailer",
    "NationalChainID",
    "CustomerNumber",
    "EAN11",
    "BusDate",
    "OnHand_Ending",
    "Dynamic_OnHandQty",
    "SalesQty",
    "DeliveredQty",
    "Feedback_ShelfCapacity",

    -- Previous day Dynamic for inventory progression
    "Previous_Dynamic_OnHandQty",

    -- Expected: Dynamic should equal OnHand_Ending for DOH-01
    "OnHand_Ending" AS "Expected_Dynamic_OnHandQty",

    -- Variance
    "Dynamic_OnHandQty" - "OnHand_Ending" AS "Variance",

    -- PASS/FAIL (tolerance <1 for Circana decimal OHE)
    CASE
        WHEN "Previous_Dynamic_OnHandQty" IS NULL
            THEN 'N/A (first day)'
        WHEN ABS("Dynamic_OnHandQty" - "OnHand_Ending") < 1
            THEN 'PASS'
        ELSE 'FAIL'
    END AS "Result",

    -- Confirm no override applied
    CASE
        WHEN "Feedback_ShelfCapacity" IS NULL
            THEN 'Confirmed NULL'
        ELSE 'UNEXPECTED FEEDBACK'
    END AS "Feedback_Check"

FROM with_lag
ORDER BY "Retailer", "CustomerNumber", "EAN11", "BusDate";
