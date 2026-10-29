# Feature overview — Walmart purchase order data validation

| Field | Value |
|-------|--------|
| **Feature name** | Walmart Purchase Order Data Validation |
| **Retailer** | Walmart US |
| **Branch in scope (SOQ enhancement)** | Irving Trinity (`BranchID` **1225**) |
| **Validation status** | Complete (reference package) |
| **Framework** | [Business validation framework](../../../docs/business-validation-framework.md) |
| **Lineage context** | [Walmart PO lineage](../../../docs/walmart-po-lineage.md) |

## Summary

Business validation of Walmart PO-related data movement and scenarios across the PO pipeline, including:

- Source-to-domain PO presence and lineage tracing
- Comparison of PO **suggested order quantities** vs Walmart store order / vendor-pack quantities
- Unusually high Walmart quantity review
- Cancelled PO handling on subsequent loads
- Duplicate checks
- Missing delivery / received quantity investigations

This package centers on the **completed validation report** for **SuggestedOrderQtySource** / **SuggestedOrderQty** in `SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"`, with Snowflake ↔ Power BI sample checks.

## Test environment (report)

| Field | Value |
|-------|--------|
| Power BI | QA_Comm_data |
| Snowflake view | `SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"` |

## Package contents

| Artifact | File |
|----------|------|
| Requirements | `requirements.md` |
| Business rules | `business-rules.md` |
| Scenarios | `scenarios.md` |
| Test cases | `test-cases.md` |
| Traceability | `traceability-matrix.md` |
| Defects | `defects.md` |
| Sign-off | `validation-summary.md` |
| SQL | `sql/` |
| Report (Word) | [evidence/.../Business-Validation-Report-Walmart-PO.docx](../../../evidence/walmart-purchase-order-data-validation/Business-Validation-Report-Walmart-PO.docx) |

## Related repo assets

- Source-shaped rule fixtures: `validation/rules/` and `fixtures/purchase-orders/` (scaffold)
- PO lineage investigation template: `investigations/_template-lineage.md`
