/*=================================================================
  Albertsons Reprocessing — Changed vs Unchanged Counts
  SalesQty, Max_ShelfCapacityQty, DeliveredQtyAdj
  Combined into a single query (one table scan)

  NationalChainID: 0001001169
  Branches: 1115 Irving Century, 1020 Northlake

  Current:  RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"
  Backup:   RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"
  Mapping:  RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"

  Join Keys: CustomerNumber + EAN11 + BusDate + seq_num
  Comparison: IS DISTINCT FROM (NULL-safe)
  =================================================================*/

WITH branch_map AS (
    SELECT DISTINCT "BranchID", "BranchName", "CustomerNumber"
    FROM RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"
    WHERE "BranchID" IN ('1115', '1020')
)
SELECT
    bm."BranchID",
    bm."BranchName",
    COUNT(*) AS total_records,

    -- SalesQty
    SUM(CASE WHEN cur."SalesQty" IS DISTINCT FROM bkp."SalesQty"
        THEN 1 ELSE 0 END)              AS SalesQty_changed,
    COUNT(*) - SUM(CASE WHEN cur."SalesQty" IS DISTINCT FROM bkp."SalesQty"
        THEN 1 ELSE 0 END)              AS SalesQty_unchanged,
    ROUND(SUM(CASE WHEN cur."SalesQty" IS DISTINCT FROM bkp."SalesQty"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)              AS SalesQty_changed_pct,
    ROUND((COUNT(*) - SUM(CASE WHEN cur."SalesQty" IS DISTINCT FROM bkp."SalesQty"
        THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 2)             AS SalesQty_unchanged_pct,

    -- Max_ShelfCapacityQty
    SUM(CASE WHEN cur."Max_ShelfCapacityQty" IS DISTINCT FROM bkp."Max_ShelfCapacityQty"
        THEN 1 ELSE 0 END)              AS MaxShelf_changed,
    COUNT(*) - SUM(CASE WHEN cur."Max_ShelfCapacityQty" IS DISTINCT FROM bkp."Max_ShelfCapacityQty"
        THEN 1 ELSE 0 END)              AS MaxShelf_unchanged,
    ROUND(SUM(CASE WHEN cur."Max_ShelfCapacityQty" IS DISTINCT FROM bkp."Max_ShelfCapacityQty"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)              AS MaxShelf_changed_pct,
    ROUND((COUNT(*) - SUM(CASE WHEN cur."Max_ShelfCapacityQty" IS DISTINCT FROM bkp."Max_ShelfCapacityQty"
        THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 2)             AS MaxShelf_unchanged_pct,

    -- DeliveredQtyAdj
    SUM(CASE WHEN cur."DeliveredQtyAdj" IS DISTINCT FROM bkp."DeliveredQtyAdj"
        THEN 1 ELSE 0 END)              AS DeliveredQtyAdj_changed,
    COUNT(*) - SUM(CASE WHEN cur."DeliveredQtyAdj" IS DISTINCT FROM bkp."DeliveredQtyAdj"
        THEN 1 ELSE 0 END)              AS DeliveredQtyAdj_unchanged,
    ROUND(SUM(CASE WHEN cur."DeliveredQtyAdj" IS DISTINCT FROM bkp."DeliveredQtyAdj"
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)              AS DeliveredQtyAdj_changed_pct,
    ROUND((COUNT(*) - SUM(CASE WHEN cur."DeliveredQtyAdj" IS DISTINCT FROM bkp."DeliveredQtyAdj"
        THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 2)             AS DeliveredQtyAdj_unchanged_pct

FROM RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static" cur
JOIN RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26" bkp
    ON  cur."CustomerNumber" = bkp."CustomerNumber"
    AND cur."EAN11"          = bkp."EAN11"
    AND cur."BusDate"        = bkp."BusDate"
    AND cur."seq_num"        = bkp."seq_num"
JOIN branch_map bm
    ON cur."CustomerNumber" = bm."CustomerNumber"
WHERE cur."NationalChainID" = '0001001169'
GROUP BY bm."BranchID", bm."BranchName"
ORDER BY bm."BranchID"
