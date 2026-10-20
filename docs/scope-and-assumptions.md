# Walmart purchase order — scope and assumptions

## In scope (initial)

- Source-shaped purchase order records prior to acquisition load
- Business rules catalogued as `PO-001` … `PO-005` in `validation/rules/rules.json`
- Lineage-oriented documentation for investigations that span acquisition → Perfect Order

## Out of scope (for now)

- Live Snowflake execution (use `queries/` templates)
- EDI 850 segment-level parsing (fixtures use a normalized JSON shape)

## Assumptions to confirm

| Topic | Working assumption | Owner / notes |
|--------|-------------------|---------------|
| PO source | Retail Link / retailer feed export normalized to JSON | TBD |
| Status values | `Active`, `Closed`, `Cancelled` | Align with domain `Fact_PurchaseOrderDaily` |
| Store key | `storeId` string | Map to `Dim_Store` |
| Item key | `itemNumber` (GTIN/UPC) | Map to `Dim_Product` |
| Dates | ISO `YYYY-MM-DD` in fixtures | Timezone for must-arrive TBD |

Update this table as real object names and source layouts are confirmed.
