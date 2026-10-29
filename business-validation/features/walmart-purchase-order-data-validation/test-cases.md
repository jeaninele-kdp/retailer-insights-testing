# Test cases — Walmart purchase order data validation

| Test case | Scenario | SQL | Status |
|-----------|----------|-----|--------|
| TC-WPO-PV-01 | PV-01 | [pv-population-and-distribution.sql](sql/pv-population-and-distribution.sql) | Passed |
| TC-WPO-PV-02 | PV-02 | [pv-population-and-distribution.sql](sql/pv-population-and-distribution.sql) | Passed |
| TC-WPO-NEG-01 | NEG-01 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-NEG-02 | NEG-02 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-NEG-03 | NEG-03 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-NEG-04 | NEG-04 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-NEG-05 | NEG-05 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-NEG-06 | NEG-06 | [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) | Passed |
| TC-WPO-PO-01 | WPO-PO-01 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |
| TC-WPO-PO-02 | WPO-PO-02 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |
| TC-WPO-PO-03 | WPO-PO-03 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |
| TC-WPO-WAL-01 | WPO-WAL-01 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |
| TC-WPO-WAL-02 | WPO-WAL-02 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |
| TC-WPO-WAL-03 | WPO-WAL-03 | [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) | Passed |

## Execution notes

- Run NEG queries in order; embedded comments document actual counts at time of validation.
- Power BI checks performed in **QA_Comm_data** per validation report.
- Full narrative: [Business-Validation-Report-Walmart-PO.docx](../../../evidence/walmart-purchase-order-data-validation/Business-Validation-Report-Walmart-PO.docx)
