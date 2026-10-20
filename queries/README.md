# Snowflake validation queries (placeholders)

Bind real database, schema, and object names from your environment (for example `NDT_QA` and domain tables such as `Fact_PurchaseOrderDaily`).

Suggested files to add:

- `acquisition_staging_rowcount.sql` — compare file control totals to staging
- `domain_po_reconciliation.sql` — source keys vs `Fact_PurchaseOrderDaily`
- `ml_dataset_po_presence.sql` — PO signals on Retailer Order ML grain
- `soq_variance.sql` — SOQ vs retailer suggested quantity

Keep parameterized filters (PO number, store, business date) at the top of each script.
