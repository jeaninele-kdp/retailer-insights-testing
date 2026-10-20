# Kroger OnHandBeginning 0925 — execution evidence

Snowflake query exports linked to [validation SQL](../../../business-validation/features/onhand-beginning-reprocessing/sql/kroger/0925/).

| File | SQL script | Exported |
|------|------------|----------|
| [population-by-velocity.csv](population-by-velocity.csv) | `onhand-beginning-population-validation.sql` (velocity summary) | KrogerOnHandBeginning0925.csv |
| [velocity-samples.csv](velocity-samples.csv) | `velocity-sample-evidence.sql` | 2026-10-14 |
| [regression-field-stability.csv](regression-field-stability.csv) | `regression-field-stability.sql` | 2026-10-16 |

## Population summary (`population-by-velocity.csv`)

| Velocity | Records checked | Rule mismatches | Date range |
|----------|-----------------|-----------------|------------|
| High Velocity | 42,236,701 | 0 | 2025-09-01 – 2026-10-14 |
| Med Velocity | 40,146,333 | 0 | 2025-09-01 – 2026-10-14 |
| Low Velocity | 487,231,675 | 0 | 2025-09-01 – 2026-10-14 |

## Velocity samples (`velocity-samples.csv`)

30 rows (10 per velocity category); all `VALIDATIONRESULT = PASS`.

## Regression (`regression-field-stability.csv`)

| Column | % changed | Notes |
|--------|-----------|--------|
| SalesQty | 0.10% | Substantially unchanged |
| Max_ShelfCapacityQty | 3.98% | Review context |
| OnHand_Begining | 34.53% | Expected reprocessing impact |
| OnHand_Ending | 53.76% | Expected downstream inventory impact |
| DeliveredQtyAdj | 0.12% | Substantially unchanged |
