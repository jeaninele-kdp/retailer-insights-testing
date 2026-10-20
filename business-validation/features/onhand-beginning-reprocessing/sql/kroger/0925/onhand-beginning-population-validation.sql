-- =====================================================================
-- Kroger (NationalChainID = '0001000889') OnHandBeginning reprocessing validation
-- Rule : OnHand_Begining = ROUND(Max_ShelfCapacityQty * 0.5)
-- Scope: BusDate >= '2025-09-01'; current tables only
-- Notes: CustomerNumber is the store key (no BranchID column exists).
--        Fact_DailyInventory has no OnHand_Begining column; it is used for row-count context only.
-- =====================================================================

-- 1 + 3. Records checked and rule mismatches by velocity category
SELECT "velocity_flag" AS velocity_category,
       COUNT(*)        AS records_checked,
       COUNT_IF("OnHand_Begining" IS DISTINCT FROM ROUND("Max_ShelfCapacityQty" * 0.5)) AS rule_mismatches,
       MIN("BusDate")  AS min_busdate,
       MAX("BusDate")  AS max_busdate
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01'
GROUP BY 1 ORDER BY 1;

-- 2 + 3. Records checked and rule mismatches by BusDate
SELECT "BusDate",
       COUNT(*) AS records_checked,
       COUNT_IF("velocity_flag" = 'Low Velocity')  AS low_velocity_records,
       COUNT_IF("velocity_flag" = 'Med Velocity')  AS med_velocity_records,
       COUNT_IF("velocity_flag" = 'High Velocity') AS high_velocity_records,
       COUNT_IF("OnHand_Begining" IS DISTINCT FROM ROUND("Max_ShelfCapacityQty" * 0.5)) AS rule_mismatches
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01'
GROUP BY 1 ORDER BY 1;

-- 2a. BusDate roll-up summary
WITH by_date AS (
    SELECT "BusDate",
           COUNT(*) AS records_checked,
           COUNT_IF("OnHand_Begining" IS DISTINCT FROM ROUND("Max_ShelfCapacityQty" * 0.5)) AS rule_mismatches
    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
    WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01'
    GROUP BY 1
)
SELECT COUNT(*)                   AS busdates_checked,
       SUM(records_checked)       AS total_records_checked,
       MIN(records_checked)       AS min_records_per_day,
       MAX(records_checked)       AS max_records_per_day,
       SUM(rule_mismatches)       AS total_rule_mismatches,
       COUNT_IF(rule_mismatches > 0) AS busdates_with_mismatches
FROM by_date;

-- 2b. Fact_DailyInventory record count in scope (context)
SELECT COUNT(*) AS fact_records_in_scope,
       COUNT(DISTINCT "BusDate") AS fact_busdates
FROM RETAILER_QA.INVENTORY."Fact_DailyInventory"
WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01';

-- 4. Sample rule mismatches (expected: 0 rows)
SELECT "BusDate",
       "CustomerNumber",
       "EAN11",
       "velocity_flag"                          AS velocity_category,
       "Max_ShelfCapacityQty",
       "OnHand_Begining"                        AS onhand_beginning_current,
       ROUND("Max_ShelfCapacityQty" * 0.5)      AS expected_onhand_beginning
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01'
  AND "OnHand_Begining" IS DISTINCT FROM ROUND("Max_ShelfCapacityQty" * 0.5)
QUALIFY ROW_NUMBER() OVER (PARTITION BY "velocity_flag" ORDER BY "BusDate", "CustomerNumber", "EAN11") <= 10;

-- 5 + 6. PASS/FAIL by velocity category
SELECT "velocity_flag" AS velocity_category,
       COUNT(*)        AS records_checked,
       COUNT_IF("OnHand_Begining" IS DISTINCT FROM ROUND("Max_ShelfCapacityQty" * 0.5)) AS rule_mismatches,
       IFF(rule_mismatches = 0, 'PASS', 'FAIL') AS status
FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
WHERE "NationalChainID" = '0001000889' AND "BusDate" >= '2025-09-01'
  AND "velocity_flag" IN ('Low Velocity', 'Med Velocity', 'High Velocity')
GROUP BY 1 ORDER BY 1;
