-- WAL #1
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0012116691'
  AND f."MaterialNumber" = '000000000020038833'
  AND f."DeliveryDate" = '2026-11-02';

-- WAL #2
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0012090623'
  AND f."MaterialNumber" = '000000000010175563'
  AND f."DeliveryDate" = '2026-10-23';

-- WAL #3
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0011291898'
  AND f."MaterialNumber" = '000000000010000836'
  AND f."DeliveryDate" = '2026-10-22';

-- PO #1
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0011988264'
  AND f."MaterialNumber" = '000000000010123485'
  AND f."DeliveryDate" = '2026-10-30';
  
-- PO #2
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0011277545'
  AND f."MaterialNumber" = '000000000010000829'
  AND f."DeliveryDate" = '2026-11-11';
  
-- PO #3
SELECT
    f."RetailerName",
    b."BranchName"     AS "Branch",
    f."CustomerNumber",
    f."MaterialNumber",
    m."MaterialID"     AS "SKUNumber",
    m."MaterialDesc"   AS "SKUDescription",
    f."DeliveryDate",
    f."BusDate",
    f."SuggestedOrderQtySource",
    f."SuggestedOrderQty"
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder" f
LEFT JOIN SOLUTIONS_QA.DSD."V_Dim_Material" m
       ON m."MaterialNumber" = f."MaterialNumber"
LEFT JOIN SOLUTIONS_PROD.COMMERCIALS."V_Dim_Branch" b
       ON b."BranchID" = f."BranchID"
WHERE f."CustomerNumber" = '0011277308'
  AND f."MaterialNumber" = '000000000010000187'
  AND f."DeliveryDate" = '2026-11-11';
