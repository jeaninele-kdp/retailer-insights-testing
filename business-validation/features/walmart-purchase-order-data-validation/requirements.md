# Requirements — Walmart purchase order data validation

## Pipeline and data quality (initiative scope)

| ID | Requirement | Evidence in this package |
|----|-------------|---------------------------|
| REQ-WPO-001 | Source-to-domain PO presence and traceability | Lineage docs; extend with SQL as added |
| REQ-WPO-002 | PO suggested qty vs Walmart store order / vendor-pack qty | SOQ source rules + samples |
| REQ-WPO-003 | Review unusually high Walmart quantities | Sample WAL #3 (qty 179) |
| REQ-WPO-004 | Cancelled PO behavior on subsequent loads | Document in future SQL / investigations |
| REQ-WPO-005 | Duplicate PO checks | Document in future SQL |
| REQ-WPO-006 | Missing delivery / received quantity investigation | Lineage template |

## Suggested order source enhancement (validated in report)

| ID | Requirement | Status |
|----|-------------|--------|
| REQ-WPO-010 | Walmart SOQ logic applies only to **Walmart US** / **Branch 1225** | Passed (NEG-02 – NEG-05) |
| REQ-WPO-011 | `SuggestedOrderQtySource` uses only values **0** (PO) and **1** (Walmart) | Passed (NEG-01) |
| REQ-WPO-012 | Full Irving Trinity population covered (520,937 rows) | Passed (PV-01, PV-02) |
| REQ-WPO-013 | PO-selected + Walmart-selected counts reconcile to population | Passed (PV-02) |
| REQ-WPO-014 | Non-scope retailers/branches remain Source = 0 | Passed (NEG-04, NEG-05) |
| REQ-WPO-015 | Segment reconciliation equals full view row count | Passed (NEG-06) |
| REQ-WPO-016 | Snowflake `SuggestedOrderQty` / source flag match Power BI for sample keys | Passed (WPO-PO/WAL samples) |
