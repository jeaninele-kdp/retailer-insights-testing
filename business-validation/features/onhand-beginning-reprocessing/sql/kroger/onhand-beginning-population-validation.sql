/*=================================================================
  Kroger Reprocessing Validation
  NationalChainID: 0001000889
  Rule: OnHand_Begining = CEIL(Max_ShelfCapacityQty * 0.5)

  Branches:
    1020 - Northlake
    1077 - Columbus
    1115 - Irving Century

  Tables:
    Current:  RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
              RETAILER_QA.INVENTORY."Fact_DailyInventory"
    Backup:   RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"
              RETAILER_QA.INVENTORY."Fact_DailyInventory_bkp_08Oct26_V2"
    Mapping:  RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"

  Results (from prior execution):
    Q1 — ALL PASS: 0 mismatches across 133,716 staging records
    Q2 — 46,011 of 133,716 records changed from backup (34.4%)
    Q3 — 0 mismatch rows returned
    Q4 — Fact OnHandQty changed: 92.3–93.7% per branch

  This file contains 4 queries (run each individually):
    Q1 — Staging: CEIL rule validation by branch/velocity
    Q2 — Staging: current vs backup comparison
    Q3 — Staging: sample mismatches (empty if all pass)
    Q4 — Fact:    change detection by branch
  =================================================================*/


-- =============================================================
-- QUERY 1: STAGING — CEIL Rule Validation by Branch & Velocity
-- Checks: OnHand_Begining = CEIL(Max_ShelfCapacityQty * 0.5)
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
WHERE cur."NationalChainID" = '0001000889'
  AND cur."seq_num" = 1
GROUP BY bm."BranchID", bm."BranchName", cur."velocity_flag"
ORDER BY bm."BranchID", cur."velocity_flag"


-- =============================================================
-- QUERY 2: STAGING — Current vs Backup (Changed/Unchanged)
-- =============================================================
;WITH branch_map AS (
    SELECT DISTINCT "BranchID", "BranchName", "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020', '1077')
)
SELECT
    bm."BranchID",
    bm."BranchName",
    cur."velocity_flag"   AS VelocityCategory,
    COUNT(*)              AS total_records,
    SUM(CASE WHEN cur."OnHand_Begining" IS DISTINCT FROM bkp."OnHand_Begining"
        THEN 1 ELSE 0 END)   AS records_changed,
    SUM(CASE WHEN NOT (cur."OnHand_Begining" IS DISTINCT FROM bkp."OnHand_Begining")
        THEN 1 ELSE 0 END)   AS records_unchanged,
    ROUND(SUM(CASE WHEN cur."OnHand_Begining" IS DISTINCT FROM bkp."OnHand_Begining"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_changed
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
JOIN RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26" bkp
    ON  cur."CustomerNumber" = bkp."CustomerNumber"
    AND cur."EAN11"          = bkp."EAN11"
    AND cur."BusDate"        = bkp."BusDate"
    AND cur."seq_num"        = bkp."seq_num"
JOIN branch_map bm ON cur."CustomerNumber" = bm."CustomerNumber"
WHERE cur."NationalChainID" = '0001000889'
  AND cur."seq_num" = 1
GROUP BY bm."BranchID", bm."BranchName", cur."velocity_flag"
ORDER BY bm."BranchID", cur."velocity_flag"


-- =============================================================
-- QUERY 3: STAGING — Sample Mismatches
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
    WHERE cur."NationalChainID" = '0001000889'
      AND cur."seq_num" = 1
      AND cur."OnHand_Begining" <> CEIL(cur."Max_ShelfCapacityQty" * 0.5)
)
SELECT * FROM mismatches WHERE rn <= 5
ORDER BY "BranchID", VelocityCategory, rn


-- =============================================================
-- QUERY 4: FACT TABLE — Change Detection by Branch
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
WHERE f."NationalChainID" = '0001000889'
GROUP BY bm."BranchID", bm."BranchName"
ORDER BY bm."BranchID"
