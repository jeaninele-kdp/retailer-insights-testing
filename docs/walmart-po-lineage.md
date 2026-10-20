# Walmart PO lineage investigation guide

When validating Walmart purchase orders, trace defects along the pipeline instead of stopping at a single table.

```text
Source PO Data
      ↓
Acquisition Load
      ↓
Domain Fact Tables
      ↓
Data Product Logic
      ↓
Retailer Order Dataset
      ↓
Forecast Pipeline
      ↓
SOQ Output
```

## Ten questions (in order)

1. Is the source PO record present?
2. Did acquisition load it correctly (row counts, keys, no truncation)?
3. Did domain logic exclude it (filters, status rules)?
4. Did status logic remove or reclassify it (`Active` / `Closed` / `Cancelled`)?
5. Did delivery / must-arrive logic apply correctly?
6. Are store and item validity flags (`IsStoreValid`, `IsItemValid`, `IsRecordValid`) expected?
7. Did the data product layer include it in forecast inputs?
8. Did the Retailer Order ML dataset contain the expected grain and dates?
9. Did forecasting consume the signal?
10. Did SOQ calculation change the quantity—and is that expected business logic?

## Evidence table (copy per investigation)

| Layer | Object / job | Key identifiers | Expected | Actual | Pass? | Notes |
|-------|----------------|-----------------|----------|--------|-------|-------|
| Source | | PO#, store, item | | | | |
| Acquisition | | load date, file | | | | |
| Domain | `Fact_PurchaseOrderDaily` | | | | | |
| Data product | | | | | | |
| ML dataset | | | | | | |
| Forecast | | | | | | |
| SOQ | | | | | | |

Use `investigations/_template-lineage.md` for a full write-up.

## Typical Walmart validations

- Source → domain reconciliation
- Missing delivery confirmations
- PO status handling
- Must-arrive date alignment
- Store order quantity calculations
- Duplicate record prevention
- Retailer Order dataset population
- SOQ vs Walmart suggested quantity comparison
- High-variance investigations
