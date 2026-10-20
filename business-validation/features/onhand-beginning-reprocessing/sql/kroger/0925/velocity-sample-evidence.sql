-- Kroger (NationalChainID = '0001000889') OnHandBeginning business validation evidence
-- 10 sample records per velocity category, BusDate >= '2025-09-01'
WITH base AS (
    SELECT "velocity_flag"        AS VelocityCategory,
           "BusDate",
           "CustomerNumber",
           "EAN11",
           "Max_ShelfCapacityQty",
           CASE WHEN MOD("Max_ShelfCapacityQty", 2) <> 0
                THEN ROUND("Max_ShelfCapacityQty" * 0.5)
                ELSE "Max_ShelfCapacityQty" * 0.5
           END                    AS Expected_OnHandBeginning,
           "OnHand_Begining"
    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
    WHERE "NationalChainID" = '0001000889'
      AND "BusDate" >= '2025-09-01'
      AND "velocity_flag" IN ('High Velocity', 'Med Velocity', 'Low Velocity')
)
SELECT VelocityCategory,
       "BusDate",
       "CustomerNumber",
       "EAN11",
       "Max_ShelfCapacityQty",
       Expected_OnHandBeginning,
       "OnHand_Begining",
       IFF(Expected_OnHandBeginning IS NOT DISTINCT FROM "OnHand_Begining", 'PASS', 'FAIL') AS ValidationResult
FROM base
QUALIFY ROW_NUMBER() OVER (PARTITION BY VelocityCategory ORDER BY "BusDate", "CustomerNumber", "EAN11") <= 10
ORDER BY CASE VelocityCategory WHEN 'High Velocity' THEN 1 WHEN 'Med Velocity' THEN 2 ELSE 3 END,
         "BusDate", "CustomerNumber", "EAN11";
