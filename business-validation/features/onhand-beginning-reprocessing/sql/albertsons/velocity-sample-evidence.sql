WITH branch_map AS (
    SELECT DISTINCT
        "BranchID",
        "BranchName",
        "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020')
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
        bkp."OnHand_Begining"         AS OnHand_Begining_Backup,

        -- Change detection
        CASE
            WHEN cur."OnHand_Begining" IS DISTINCT FROM bkp."OnHand_Begining"
                THEN 'YES'
            ELSE 'NO'
        END                           AS ChangeDetected

    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
    JOIN RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26" bkp
        ON  cur."CustomerNumber" = bkp."CustomerNumber"
        AND cur."EAN11"          = bkp."EAN11"
        AND cur."BusDate"        = bkp."BusDate"
        AND cur."seq_num"        = bkp."seq_num"
    JOIN branch_map bm
        ON  cur."CustomerNumber" = bm."CustomerNumber"
    WHERE cur."NationalChainID" = '0001001169'
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

        -- Rank: prefer changed records (YES first), then by BusDate
        ROW_NUMBER() OVER (
            PARTITION BY "BranchID", VelocityCategory
            ORDER BY
                CASE WHEN ChangeDetected = 'YES' THEN 0 ELSE 1 END,
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
