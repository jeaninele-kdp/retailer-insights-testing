# Validation summary — Walmart purchase order data validation

| Field | Value |
|-------|--------|
| **Feature** | Walmart Purchase Order Data Validation |
| **Retailer / branch** | Walmart US — Irving Trinity (1225) |
| **Environment** | Snowflake QA view + Power BI QA_Comm_data |
| **Overall result** | **Passed** |

## Scope validated (report)

- Positive population and `SuggestedOrderQtySource` distribution (PV-01, PV-02)
- Negative impact / scope containment across retailers and branches (NEG-01 – NEG-06)
- Six Snowflake sample keys with Power BI reconciliation (3 PO-source, 3 Walmart-source)

## Test execution

| Metric | Count |
|--------|-------|
| Test cases executed | 14 |
| Passed | 14 |
| Failed | 0 |

## Business conclusion

Walmart suggested order quantity logic is **contained** to Walmart US, Branch 1225. All **3,369** Source = 1 records are in-scope; **517,568** Source = 0 records represent PO-selected quantities within the same branch population. Non-scope Walmart branches and other retailers remain on Perfect Order quantity (Source = 0).

## Broader PO pipeline work

Initiative also covered source-to-domain presence, high Walmart quantities, cancelled PO reload behavior, duplicates, and missing delivery/received investigations — extend this package with additional SQL under `sql/pipeline/` as artifacts are archived.

## Evidence

| Artifact | Location |
|----------|----------|
| Validation report (Word) | [evidence/walmart-purchase-order-data-validation/Business-Validation-Report-Walmart-PO.docx](../../../evidence/walmart-purchase-order-data-validation/Business-Validation-Report-Walmart-PO.docx) |
| PV.sql | [sql/pv-population-and-distribution.sql](sql/pv-population-and-distribution.sql) |
| NEG.sql | [sql/neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql) |
| WPOSample.sql | [sql/wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql) |

## Sign-off

| Role | Name | Date | Approval |
|------|------|------|----------|
| Business | | | |
| Product | | | |
| QA / Validation | | | |
