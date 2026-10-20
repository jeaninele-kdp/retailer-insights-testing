# Scenarios — OnHandBeginning reprocessing

SQL index: [sql/README.md](sql/README.md).

## Kroger (`0001000889`)

| ID | Action | Description | Branches | Result summary |
|----|--------|-------------|----------|----------------|
| OHB-KRO-01 | Population rule | Counts by branch/velocity; mismatch count = 0 | 1020, 1077, 1115 | PASS — rule applied |
| OHB-KRO-02 | Velocity samples | 10 High + 10 Med + 10 Low per branch (90 rows) | 1020, 1077, 1115 | PASS — all `ChangeDetected = YES` |
| OHB-KRO-03 | Regression | Changed vs unchanged for SalesQty, Max shelf, DeliveredQtyAdj | 1020, 1077, 1115 | PASS — no unexpected regression |

## Albertsons (`0001001169`)

| ID | Action | Description | Branches | Result summary |
|----|--------|-------------|----------|----------------|
| OHB-ALB-01 | Population rule | CEIL rule validation; exceptions documented | 1020, 1115 | PASS |
| OHB-ALB-02 | Velocity samples | 10 per velocity per branch (60 rows) | 1020, 1115 | PASS — `ChangeDetected = YES` |
| OHB-ALB-03 | Regression | Field stability vs backup | 1020, 1115 | PASS |

## Target (`0001000312`)

| ID | Action | Description | Branches | Result summary |
|----|--------|-------------|----------|----------------|
| OHB-TGT-01 | Population rule | Low velocity only; mismatch count = 0 | 1020, 1077, 1115 | PASS |
| OHB-TGT-02 | Low velocity samples | 10 Low per branch (30 rows) | 1020, 1077, 1115 | PASS — backup N/A on staging |

---

## OHB-KRO-01 — Kroger population validation

Compare current vs backup for branches **1020, 1077, 1115**. Confirm:

- Record counts by `BranchID` and velocity category
- Count where `OnHand_Begining <> CEIL(Max_ShelfCapacityQty * 0.5)` is **0**
- Mismatch samples include BranchID, velocity, material keys, capacities, expected vs actual

**SQL:** [sql/kroger/onhand-beginning-population-validation.sql](sql/kroger/onhand-beginning-population-validation.sql)

---

## OHB-KRO-02 — Kroger velocity sample evidence

90 records total (3 branches × 3 velocities × 10). Columns include `Expected_OnHandBeginning`, `OnHand_Begining`, `OnHand_Begining_Backup`, `ChangeDetected`, `ValidationResult`.

**SQL:** [sql/kroger/velocity-sample-evidence.sql](sql/kroger/velocity-sample-evidence.sql)

---

## OHB-KRO-03 — Kroger regression

**SQL:** [sql/kroger/regression-field-stability.sql](sql/kroger/regression-field-stability.sql)

---

## OHB-ALB-01 / OHB-ALB-02 / OHB-ALB-03

Same pattern as Kroger for **1020** and **1115** only. Albertsons sample count: **60** records (2 branches × 3 velocities × 10).

**SQL:** `sql/albertsons/`

---

## OHB-TGT-01 / OHB-TGT-02

Target validates **Low Velocity** only. **30** sample records. Staging backup not available for Target — population Q2 omitted in SQL; fact backup used where documented in script headers.

**SQL:** `sql/target/`
