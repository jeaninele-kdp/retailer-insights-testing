# SQL — NDT POG shelf capacity

| File | Source download | Purpose |
|------|-----------------|---------|
| [population-results-shipment-chains.sql](population-results-shipment-chains.sql) | `populationresults.sql` | Funnel + PASS/FAIL by retailer (store-match POG path) |
| [population-results-account-pog-chains.sql](population-results-account-pog-chains.sql) | `populationresults2.sql` | Casey's, Maverik, Murphy, Pilot, Yesway (account on POG) |
| [sample-records-snowflake-pbi.sql](sample-records-snowflake-pbi.sql) | `6samplerecords.sql` | Six fixed examples + PASS/FAIL vs expected case capacity |
| [negative-impact-scope-containment.sql](negative-impact-scope-containment.sql) | `socnegativeimpacttesting.sql` | Out-of-scope containment + zero→3 leakage controls |

## Expected capacity formula (all scripts)

```sql
IFF("Capacity" = 0, 3, "Capacity") * ConvFactorToBase
```

Compare to `Max_ShelfCapacityQty` with tolerance `ABS(diff) <= 0.0001`.

## Environments

- POG: `RETAILER_PROD`
- Perfect Order targets: `DATA_PRODUCT_QA.RETAILER_INSIGHTS`
- Negative tests may reference `SOLUTIONS_QA` / `SALES_PROD` order facts for delivery ranking logic in populationresults2
