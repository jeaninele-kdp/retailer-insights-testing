-- 1. Changed vs unchanged counts
WITH cur AS (
    SELECT
        "CustomerNumber",
        "EAN11",
        "BusDate",
        "SalesQty",
        "Max_ShelfCapacityQty",
        "OnHand_Begining",
        "OnHand_Ending",
        "DeliveredQtyAdj"
    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
    WHERE "NationalChainID" = '0001000889'
      AND "BusDate" BETWEEN '2025-09-01' AND '2026-10-07'
),

bkp AS (
    SELECT
        "CustomerNumber",
        "EAN11",
        "BusDate",
        "SalesQty",
        "Max_ShelfCapacityQty",
        "OnHand_Begining",
        "OnHand_Ending",
        "DeliveredQtyAdj"
    FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"
    WHERE "NationalChainID" = '0001000889'
      AND "BusDate" BETWEEN '2025-09-01' AND '2026-10-07'
),

cmp AS (
    SELECT
        c."SalesQty"
            IS DISTINCT FROM b."SalesQty"
            AS chg_sales,

        c."Max_ShelfCapacityQty"
            IS DISTINCT FROM b."Max_ShelfCapacityQty"
            AS chg_maxshelf,

        c."OnHand_Begining"
            IS DISTINCT FROM b."OnHand_Begining"
            AS chg_beg,

        c."OnHand_Ending"
            IS DISTINCT FROM b."OnHand_Ending"
            AS chg_end,

        c."DeliveredQtyAdj"
            IS DISTINCT FROM b."DeliveredQtyAdj"
            AS chg_delv

    FROM cur c
    INNER JOIN bkp b
      ON  b."CustomerNumber" = c."CustomerNumber"
      AND b."EAN11"          = c."EAN11"
      AND b."BusDate"        = c."BusDate"
),

agg AS (
    SELECT
        COUNT(*) AS rows_in_both,

        COUNT_IF(chg_sales)
            AS "SalesQty",

        COUNT_IF(chg_maxshelf)
            AS "Max_ShelfCapacityQty",

        COUNT_IF(chg_beg)
            AS "OnHand_Begining",

        COUNT_IF(chg_end)
            AS "OnHandQty (OnHand_Ending)",

        COUNT_IF(chg_delv)
            AS "DeliveredQtyAdj"

    FROM cmp
)

SELECT
    column_name,
    changed_count,
    rows_in_both - changed_count AS unchanged_count,
    ROUND(
        100 * changed_count / NULLIF(rows_in_both, 0),
        2
    ) AS pct_changed

FROM agg

UNPIVOT (
    changed_count
    FOR column_name IN (
        "SalesQty",
        "Max_ShelfCapacityQty",
        "OnHand_Begining",
        "OnHandQty (OnHand_Ending)",
        "DeliveredQtyAdj"
    )
);