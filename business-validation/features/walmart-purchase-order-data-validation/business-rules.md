# Business rules — Walmart purchase order data validation

## SOQ source selection (validated)

### BR-WPO-001 — Source value meanings

| `SuggestedOrderQtySource` | Business meaning |
|---------------------------|------------------|
| **0** | Suggested order quantity from **PO** (Perfect Order / PO-selected path) |
| **1** | Suggested order quantity from **Walmart** store order / vendor-pack quantity |

Only **0** and **1** are valid; no NULL or other values in scope view.

### BR-WPO-002 — In-scope population

Walmart-sourced quantity (`SuggestedOrderQtySource = 1`) is allowed **only** when:

```text
RetailerName = 'WALMART US'
AND BranchID = '1225'   -- Irving Trinity (text comparison)
```

All other retailer/branch combinations must remain `SuggestedOrderQtySource = 0`.

### BR-WPO-003 — Population reconciliation

Business segments must partition the full view without gaps or double-count:

1. Walmart US / Branch 1225 (in-scope SOQ)
2. Walmart US / other branches
3. All other retailers

Segment row counts must sum to total view population.

## Pipeline rules (broader initiative — reference)

These align with [Walmart PO lineage](../../../docs/walmart-po-lineage.md) and standard PO validation patterns:

- PO records must be traceable from source through domain fact tables
- Cancelled POs must not produce incorrect open quantities on reload
- Duplicate PO lines must be detectable at source or domain grain
- Delivery / received quantities must reconcile where business expects confirmation

Add rule IDs and SQL as those validations are archived in this repo.
