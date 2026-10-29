-- walmart irving trinity population --> 520,937
SELECT COUNT(*)
FROM "SOLUTIONS_QA"."COMML_SALES"."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" = 'WALMART US'
  AND "BranchID" = 1225;

-- affected rows --> 296,792
SELECT
    COUNT(*)
FROM "SOLUTIONS_QA"."COMML_SALES"."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" = 'WALMART US'
  AND "BranchID" = 1225
  AND "SuggestedOrderQty" IS NOT NULL
  AND "SuggestedOrderQtySource" IS NOT NULL;

-- po selected rows --> 517568
SELECT COUNT(*)
FROM "SOLUTIONS_QA"."COMML_SALES"."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" = 'WALMART US'
  AND "BranchID" = 1225
  AND "SuggestedOrderQtySource" = 0;

-- walmart selected rows --> 3369
SELECT COUNT(*)
FROM "SOLUTIONS_QA"."COMML_SALES"."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" = 'WALMART US'
  AND "BranchID" = 1225
  AND "SuggestedOrderQtySource" = 1;