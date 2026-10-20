/*=================================================================
  Target Business Validation Evidence (Current-Only)
  NationalChainID: 0001000312
  Rule: OnHand_Begining = Max_ShelfCapacityQty * 0.5
        (with CEILING for odd Max_ShelfCapacityQty values)

  Branches:
    1020 - Northlake
    1077 - Columbus
    1115 - Irving Century

  NOTE: Target is NOT in the backup table
        (Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26).
        ChangeDetected = 'N/A' and OnHand_Begining_Backup = NULL
        for all records. Before/after comparison not possible.

  NOTE: Target only has Low Velocity data for these branches.
        High Velocity and Med Velocity categories have zero records.
        The query returns 10 Low Velocity records per branch (30 total).

  Tables:
    Current:  RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
    Mapping:  RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
  =================================================================*/

WITH branch_map AS (
    SELECT DISTINCT
        "BranchID",
        "BranchName",
        "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020', '1077')
),

base AS (
    SELECT
        bm."BranchID",
        bm."BranchName",
        cur."velocity_flag"           AS VelocityCategory,
        cur."BusDate",
        cur."CustomerNumber",
        cur."EAN11",
        cur."Max_ShelfCapacityQty",

        -- Expected value: CEIL when odd, straight * 0.5 when even
        CASE
            WHEN MOD(cur."Max_ShelfCapacityQty", 2) <> 0
                THEN CEIL(cur."Max_ShelfCapacityQty" * 0.5)
            ELSE cur."Max_ShelfCapacityQty" * 0.5
        END                           AS Expected_OnHandBeginning,

        cur."OnHand_Begining",

        -- No backup data for Target
        NULL                          AS OnHand_Begining_Backup,
        'N/A'                         AS ChangeDetected

    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
    JOIN branch_map bm
        ON  cur."CustomerNumber" = bm."CustomerNumber"
    WHERE cur."NationalChainID" = '0001000312'
      AND cur."seq_num"         = 1
),

ranked AS (
    SELECT
        base.*,

        -- Validation result
        CASE
            WHEN "OnHand_Begining" = Expected_OnHandBeginning
                THEN 'PASS'
            ELSE 'FAIL'
        END                           AS ValidationResult,

        -- Rank by BusDate, CustomerNumber, EAN11
        ROW_NUMBER() OVER (
            PARTITION BY "BranchID", VelocityCategory
            ORDER BY
                "BusDate",
                "CustomerNumber",
                "EAN11"
        )                             AS rn
    FROM base
)

SELECT
    "BranchID",
    "BranchName",
    VelocityCategory,
    "BusDate",
    "CustomerNumber",
    "EAN11",
    "Max_ShelfCapacityQty",
    Expected_OnHandBeginning,
    "OnHand_Begining",
    OnHand_Begining_Backup,
    ChangeDetected,
    ValidationResult
FROM ranked
WHERE rn <= 10
ORDER BY
    "BranchID",
    VelocityCategory,
    "BusDate",
    "CustomerNumber",
    "EAN11";
