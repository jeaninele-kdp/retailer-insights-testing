# SQL — OnHandBeginning reprocessing

Run in Snowflake **RETAILER_QA**. Each retailer folder contains up to three scripts matching validation actions 1–3.

## Shared objects

| Object | Purpose |
|--------|---------|
| `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"` | Current staging |
| `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"` | Staging backup |
| `RETAILER_QA.INVENTORY."Fact_DailyInventory"` | Current fact |
| `RETAILER_QA.INVENTORY."Fact_DailyInventory_bkp_08Oct26_V2"` | Fact backup |
| `RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"` | Branch / customer mapping |

## Kroger (`0001000889`)

| File | Action | Description |
|------|--------|-------------|
| [kroger/onhand-beginning-population-validation.sql](kroger/onhand-beginning-population-validation.sql) | 1 | Q1–Q4: rule counts, backup diff, mismatches, fact impact |
| [kroger/velocity-sample-evidence.sql](kroger/velocity-sample-evidence.sql) | 2 | 90-row stratified sample (provenance: `Kro-1.sql` / KrogerSample) |
| [kroger/regression-field-stability.sql](kroger/regression-field-stability.sql) | 3 | Changed vs unchanged non-OHB fields |

Branches: **1020**, **1077**, **1115**.

## Albertsons (`0001001169`)

| File | Action |
|------|--------|
| [albertsons/onhand-beginning-population-validation.sql](albertsons/onhand-beginning-population-validation.sql) | 1 |
| [albertsons/velocity-sample-evidence.sql](albertsons/velocity-sample-evidence.sql) | 2 |
| [albertsons/regression-field-stability.sql](albertsons/regression-field-stability.sql) | 3 |

Branches: **1020**, **1115**.

## Target (`0001000312`)

| File | Action |
|------|--------|
| [target/onhand-beginning-population-validation.sql](target/onhand-beginning-population-validation.sql) | 1 |
| [target/velocity-sample-evidence.sql](target/velocity-sample-evidence.sql) | 2 |

Branches: **1020**, **1077**, **1115**. **Low velocity only.** No staging-backup regression script (Target absent from staging backup).

## Provenance (OneDrive `Documents`)

| Repo path | Source file |
|-----------|-------------|
| `kroger/onhand-beginning-population-validation.sql` | `KrogerOnHandBeginning.sql` |
| `kroger/velocity-sample-evidence.sql` | `Kro-1.sql` |
| `kroger/regression-field-stability.sql` | `KrogerRegression.sql` |
| `albertsons/onhand-beginning-population-validation.sql` | `AlbertsonsOnHandBeginning.sql` |
| `albertsons/velocity-sample-evidence.sql` | `AlbertsonsSample.sql` |
| `albertsons/regression-field-stability.sql` | `AlbertsonsRegression.sql` |
| `target/onhand-beginning-population-validation.sql` | `TargetOnHandBeginning.sql` |
| `target/velocity-sample-evidence.sql` | `TargetSample.sql` |
