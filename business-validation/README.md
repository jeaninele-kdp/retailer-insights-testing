# Business validation packages

Completed and in-progress feature validations live under `features/`, structured per [docs/business-validation-framework.md](../docs/business-validation-framework.md).

## Reference example

| Feature | Path |
|---------|------|
| Dynamic On-Hand Inventory Logic | [features/dynamic-onhand-inventory-logic/](features/dynamic-onhand-inventory-logic/feature-overview.md) |
| OnHandBeginning reprocessing (Kroger, Albertsons, Target) | [features/onhand-beginning-reprocessing/](features/onhand-beginning-reprocessing/feature-overview.md) |
| STM incremental capacity | [features/stm-incremental-capacity/](features/stm-incremental-capacity/feature-overview.md) |
| Walmart purchase order data validation | [features/walmart-purchase-order-data-validation/](features/walmart-purchase-order-data-validation/feature-overview.md) |
| NDT POG shelf capacity (Perfect Order) | [features/ndt-pog-shelf-capacity/](features/ndt-pog-shelf-capacity/feature-overview.md) |

Each feature folder should include: overview, requirements, business rules, scenarios, test cases, traceability matrix, defects, validation summary, and `sql/` (scripts linked when available).
