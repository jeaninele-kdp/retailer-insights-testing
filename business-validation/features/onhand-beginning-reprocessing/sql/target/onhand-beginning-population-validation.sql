/*=================================================================
  Target Reprocessing Validation
  NationalChainID: 0001000312
  Rule: OnHand_Begining = CEIL(Max_ShelfCapacityQty * 0.5)

  Branches:
    1020 - Northlake
    1077 - Columbus
    1115 - Irving Century

  NOTE: Target only has LOW VELOCITY data for these branches.
        High Velocity and Med Velocity have zero records.

  NOTE: Target is NOT in the staging backup table
        (Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26).
        Query 2 is omitted — before/after staging comparison
        is not possible. Fact backup IS available.

  Tables:
    Current:  RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
              RETAILER_QA.INVENTORY."Fact_DailyInventory"
    Backup:   RETAILER_QA.INVENTORY."Fact_DailyInventory_bkp_08Oct26_V2"
    Mapping:  RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"

  Results (from execution):
    Q1 — ALL PASS: 0 mismatches across 69,515 staging records
    Q2 — 0 mismatch rows returned
    Q3 — Fact OnHandQty changed: 54–60% per branch

  This file contains 3 queries (run each individually):
    Q1 — Staging: CEIL rule validation by branch/velocity
    Q2 — Staging: sample mismatches (empty if all pass)
    Q3 — Fact:    change detection by branch
  =================================================================*/


-- =============================================================
-- QUERY 1: STAGING — CEIL Rule Validation by Branch & Velocity
-- Checks: OnHand_Begining = CEIL(Max_ShelfCapacityQty * 0.5)
-- Current-only (no staging backup for Target)
-- =============================================================
WITH branch_map AS (
    SELECT DISTINCT "BranchID", "BranchName", "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020', '1077')
)
SELECT
    bm."BranchID",
    bm."BranchName",
    cur."velocity_flag"   AS VelocityCategory,
    COUNT(*)              AS total_records,
    SUM(CASE WHEN cur."OnHand_Begining" = CEIL(cur."Max_ShelfCapacityQty" * 0.5)
        THEN 1 ELSE 0 END)   AS match_count,
    SUM(CASE WHEN cur."OnHand_Begining" <> CEIL(cur."Max_ShelfCapacityQty" * 0.5)
        THEN 1 ELSE 0 END)   AS mismatch_count,
    ROUND(SUM(CASE WHEN cur."OnHand_Begining" = CEIL(cur."Max_ShelfCapacityQty" * 0.5)
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS match_pct,
    CASE WHEN SUM(CASE WHEN cur."OnHand_Begining" <> CEIL(cur."Max_ShelfCapacityQty" * 0.5)
        THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
JOIN branch_map bm ON cur."CustomerNumber" = bm."CustomerNumber"
WHERE cur."NationalChainID" = '0001000312'
  AND cur."seq_num" = 1
GROUP BY bm."BranchID", bm."BranchName", cur."velocity_flag"
ORDER BY bm."BranchID", cur."velocity_flag"


-- =============================================================
-- QUERY 2: STAGING — Sample Mismatches
-- Where OnHand_Begining <> CEIL(Max_ShelfCapacityQty * 0.5)
-- Returns up to 5 per branch per velocity (empty if all pass)
-- =============================================================
;WITH branch_map AS (
    SELECT DISTINCT "BranchID", "BranchName", "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020', '1077')
),
mismatches AS (
    SELECT
        bm."BranchID",
        bm."BranchName",
        cur."velocity_flag"            AS VelocityCategory,
        cur."CustomerNumber",
        cur."EAN11",
        cur."BusDate",
        cur."Max_ShelfCapacityQty",
        CEIL(cur."Max_ShelfCapacityQty" * 0.5) AS expected_onhand,
        cur."OnHand_Begining"          AS actual_onhand,
        cur."OnHand_Begining" - CEIL(cur."Max_ShelfCapacityQty" * 0.5) AS difference,
        ROW_NUMBER() OVER (
            PARTITION BY bm."BranchID", cur."velocity_flag"
            ORDER BY cur."CustomerNumber", cur."EAN11"
        ) AS rn
    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
    JOIN branch_map bm ON cur."CustomerNumber" = bm."CustomerNumber"
    WHERE cur."NationalChainID" = '0001000312'
      AND cur."seq_num" = 1
      AND cur."OnHand_Begining" <> CEIL(cur."Max_ShelfCapacityQty" * 0.5)
)
SELECT * FROM mismatches WHERE rn <= 5
ORDER BY "BranchID", VelocityCategory, rn


-- =============================================================
-- QUERY 3: FACT TABLE — Change Detection by Branch
-- (Fact backup IS available for Target)
-- =============================================================
;WITH branch_map AS (
    SELECT DISTINCT "BranchID", "BranchName", "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020', '1077')
)
SELECT
    bm."BranchID",
    bm."BranchName",
    COUNT(*) AS total_records,

    SUM(CASE WHEN f."OnHandQty" IS DISTINCT FROM b."OnHandQty"
        THEN 1 ELSE 0 END)              AS OnHandQty_changed,
    COUNT(*) - SUM(CASE WHEN f."OnHandQty" IS DISTINCT FROM b."OnHandQty"
        THEN 1 ELSE 0 END)              AS OnHandQty_unchanged,
    ROUND(SUM(CASE WHEN f."OnHandQty" IS DISTINCT FROM b."OnHandQty"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS OnHandQty_pct,

    SUM(CASE WHEN f."Cal_OnHandQty" IS DISTINCT FROM b."Cal_OnHandQty"
        THEN 1 ELSE 0 END)              AS Cal_OnHandQty_changed,
    ROUND(SUM(CASE WHEN f."Cal_OnHandQty" IS DISTINCT FROM b."Cal_OnHandQty"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Cal_OnHandQty_pct,

    SUM(CASE WHEN f."Dynamic_OnHandQty" IS DISTINCT FROM b."Dynamic_OnHandQty"
        THEN 1 ELSE 0 END)              AS Dynamic_OnHandQty_changed,
    ROUND(SUM(CASE WHEN f."Dynamic_OnHandQty" IS DISTINCT FROM b."Dynamic_OnHandQty"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Dynamic_OnHandQty_pct

FROM RETAILER_QA.INVENTORY."Fact_DailyInventory" f
JOIN RETAILER_QA.INVENTORY."Fact_DailyInventory_bkp_08Oct26_V2" b
    ON  f."CustomerNumber" = b."CustomerNumber"
    AND f."EAN11"          = b."EAN11"
    AND f."BusDate"        = b."BusDate"
JOIN branch_map bm ON f."CustomerNumber" = bm."CustomerNumber"
WHERE f."NationalChainID" = '0001000312'
GROUP BY bm."BranchID", bm."BranchName"
ORDER BY bm."BranchID"
