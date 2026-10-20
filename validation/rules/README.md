# Validation rule catalog

Rule IDs use layer prefixes as the Walmart PO program grows beyond source fixtures:

| Prefix | Layer | Examples |
|--------|--------|----------|
| `ACQ-` | Acquisition | File receipt, row counts, staging load |
| `DOM-` | Domain | `Fact_PurchaseOrderDaily`, status logic, validity flags |
| `DP-` | Data product | Feature sets, aggregations |
| `ML-` | Retailer Order ML dataset | Grain, date alignment, feature population |
| `POUT-` | Perfect Order outputs | SOQ variance, forecast consumption |
| `PO-` | Source-shaped PO fixtures | Rules in `rules.json` (local validator) |

## Source rules (`PO-*`)

Run `python scripts/validate.py --list-rules` for the current catalog.

Extend `rules.json` and `docs/traceability-matrix.md` together so requirements, fixtures, and test cases stay aligned.
