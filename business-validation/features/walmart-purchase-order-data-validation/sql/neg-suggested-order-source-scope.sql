/* =====================================================================
   NEGATIVE IMPACT TESTING - SuggestedOrderQtySource enhancement
   Object : SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
   Rule   : SuggestedOrderQtySource = 1 (Walmart SOQ) allowed ONLY for
            RetailerName = 'WALMART US' AND BranchID = '1225' (Irving Trinity).
            All other records must be SuggestedOrderQtySource = 0 (Perfect Order Qty).
   Note   : BranchID is TEXT - compare to string literals ('1225').
   ===================================================================== */


/* =====================================================================
   SECTION A - POPULATION-LEVEL
   ===================================================================== */

/* NEG-01 | Overall source distribution
   Objective : Only valid source values (0, 1) exist in the view.
   Expected  : Two rows (0, 1); no NULL or other values.
   Actual    : 0 = 652,312,517 | 1 = 3,369 | no NULL/other   --> PASS */
SELECT
    COALESCE(TO_VARCHAR("SuggestedOrderQtySource"), 'NULL') AS source_value,
    COUNT(*)                                                AS record_count,
    IFF(source_value IN ('0', '1'), 'PASS', 'FAIL')         AS test_result
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
GROUP BY 1
ORDER BY 1;


/* NEG-02 | No Source = 1 outside the approved scope
   Objective : Every Walmart SOQ record belongs to WALMART US / Branch 1225.
   Expected  : 0 violating records.
   Actual    : 0                                               --> PASS */
SELECT
    COUNT(*)                          AS violating_records,
    IFF(COUNT(*) = 0, 'PASS', 'FAIL') AS test_result
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
WHERE "SuggestedOrderQtySource" = 1
  AND NOT ("RetailerName" = 'WALMART US' AND "BranchID" = '1225');


/* NEG-03 / NEG-04 | Source = 1 by retailer and branch
   Objective : Walmart SOQ appears for exactly one retailer/branch combination.
   Expected  : Single row - WALMART US / 1225.
   Actual    : WALMART US / 1225 = 3,369 (only row)            --> PASS */
SELECT
    "RetailerName",
    "BranchID",
    COUNT(*) AS source_1_records,
    IFF("RetailerName" = 'WALMART US' AND "BranchID" = '1225', 'PASS', 'FAIL') AS test_result
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
WHERE "SuggestedOrderQtySource" = 1
GROUP BY 1, 2
ORDER BY 3 DESC;


/* NEG-04 | Non-Walmart retailers unaffected
   Objective : Every other retailer still uses Perfect Order Qty.
   Expected  : total_records = source_0 for every retailer.
   Actual    : 40 retailers, 637,263,665 records, all Source = 0 --> PASS */
SELECT
    "RetailerName",
    COUNT(*)                                     AS total_records,
    COUNT_IF("SuggestedOrderQtySource" = 0)      AS source_0,
    COUNT_IF("SuggestedOrderQtySource" = 1)      AS source_1,
    COUNT_IF("SuggestedOrderQtySource" IS NULL
          OR "SuggestedOrderQtySource" NOT IN (0, 1)) AS source_other,
    IFF(total_records = source_0, 'PASS', 'FAIL') AS test_result
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" <> 'WALMART US'
   OR "RetailerName" IS NULL
GROUP BY 1
ORDER BY 2 DESC;


/* NEG-05 | Walmart branches other than 1225 unaffected
   Objective : Other Walmart branches still use Perfect Order Qty.
   Expected  : total_records = source_0 for every branch.
   Actual    : 87 branches, 14,531,284 records, all Source = 0
               (incl. 1115 Irving Century, 1226)                --> PASS */
SELECT
    "BranchID",
    COUNT(*)                                     AS total_records,
    COUNT_IF("SuggestedOrderQtySource" = 0)      AS source_0,
    COUNT_IF("SuggestedOrderQtySource" = 1)      AS source_1,
    COUNT_IF("SuggestedOrderQtySource" IS NULL
          OR "SuggestedOrderQtySource" NOT IN (0, 1)) AS source_other,
    IFF(total_records = source_0, 'PASS', 'FAIL') AS test_result
FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
WHERE "RetailerName" = 'WALMART US'
  AND ("BranchID" <> '1225' OR "BranchID" IS NULL)
GROUP BY 1
ORDER BY 2 DESC;


/* NEG-06 | Segment reconciliation + NULL/unexpected values
   Objective : Segments are complete (no records lost or double-counted) and
               no segment holds NULL/unexpected source values.
   Expected  : segment_sum = view_total; null_or_unexpected = 0; source_1 > 0 only in segment 1.
   Actual    : 520,937 + 14,531,284 + 637,263,665 = 652,315,886 = view total;
               null_or_unexpected = 0 in all segments          --> PASS */
WITH seg AS (
    SELECT
        CASE
            WHEN "RetailerName" = 'WALMART US' AND "BranchID" = '1225' THEN '1_IN_SCOPE_WMT_1225'
            WHEN "RetailerName" = 'WALMART US'                         THEN '2_WMT_OTHER_BRANCHES'
            ELSE '3_OTHER_RETAILERS'
        END                       AS segment,
        "SuggestedOrderQtySource" AS src
    FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"
)
SELECT
    segment,
    COUNT(*)                                       AS total_records,
    COUNT_IF(src = 0)                              AS source_0,
    COUNT_IF(src = 1)                              AS source_1,
    COUNT_IF(src IS NULL OR src NOT IN (0, 1))     AS null_or_unexpected,
    SUM(COUNT(*)) OVER ()                          AS segment_sum,
    (SELECT COUNT(*) FROM SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder") AS view_total,
    IFF(null_or_unexpected = 0
        AND segment_sum = view_total
        AND (segment = '1_IN_SCOPE_WMT_1225' OR source_1 = 0), 'PASS', 'FAIL') AS test_result
FROM seg
GROUP BY 1
ORDER BY 1;
