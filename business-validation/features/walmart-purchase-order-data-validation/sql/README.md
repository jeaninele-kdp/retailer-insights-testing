# SQL — Walmart purchase order data validation

Object: `SOLUTIONS_QA.COMML_SALES."V_Fact_RetailerSalesOrder"`

| File | Source download | Purpose |
|------|-----------------|---------|
| [pv-population-and-distribution.sql](pv-population-and-distribution.sql) | `PV.sql` | PV-01 / PV-02 population and source counts (Branch 1225) |
| [neg-suggested-order-source-scope.sql](neg-suggested-order-source-scope.sql) | `NEG.sql` | NEG-01 – NEG-06 scope and reconciliation |
| [wpo-sample-snowflake-queries.sql](wpo-sample-snowflake-queries.sql) | `WPOSample.sql` | Store/SKU-level samples — WAL #1–3, PO #1–3 |

## Branch ID note

Use text `'1225'` for `BranchID` in scope filters (see NEG.sql header). `PV.sql` uses numeric `1225` in some queries — align with view column type when executing.

## Pipeline SQL (future)

Add cancelled PO, duplicate, source-to-domain, and delivery/received scripts under `sql/pipeline/` and link from `scenarios.md`.
