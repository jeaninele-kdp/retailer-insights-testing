# Test cases — OnHandBeginning reprocessing

| Test case | Scenario | SQL | Records / outcome | Status |
|-----------|----------|-----|-------------------|--------|
| TC-OHB-KRO-0925-01 | OHB-KRO-0925-01 | [kroger/0925/onhand-beginning-population-validation.sql](sql/kroger/0925/onhand-beginning-population-validation.sql) | Chain-wide; `BusDate >= 2025-09-01` | Passed |
| TC-OHB-KRO-0925-02 | OHB-KRO-0925-02 | [kroger/0925/velocity-sample-evidence.sql](sql/kroger/0925/velocity-sample-evidence.sql) | 30 velocity samples | Passed |
| TC-OHB-KRO-0925-03 | OHB-KRO-0925-03 | [kroger/0925/regression-field-stability.sql](sql/kroger/0925/regression-field-stability.sql) | Regression vs backup | Passed |
| TC-OHB-KRO-01 | OHB-KRO-01 | [kroger/onhand-beginning-population-validation.sql](sql/kroger/onhand-beginning-population-validation.sql) | 0 rule mismatches (staging) | Passed |
| TC-OHB-KRO-02 | OHB-KRO-02 | [kroger/velocity-sample-evidence.sql](sql/kroger/velocity-sample-evidence.sql) | 90 samples; PASS + ChangeDetected YES | Passed |
| TC-OHB-KRO-03 | OHB-KRO-03 | [kroger/regression-field-stability.sql](sql/kroger/regression-field-stability.sql) | Non-OHB fields stable | Passed |
| TC-OHB-ALB-01 | OHB-ALB-01 | [albertsons/onhand-beginning-population-validation.sql](sql/albertsons/onhand-beginning-population-validation.sql) | 0 rule mismatches | Passed |
| TC-OHB-ALB-02 | OHB-ALB-02 | [albertsons/velocity-sample-evidence.sql](sql/albertsons/velocity-sample-evidence.sql) | 60 samples | Passed |
| TC-OHB-ALB-03 | OHB-ALB-03 | [albertsons/regression-field-stability.sql](sql/albertsons/regression-field-stability.sql) | Regression clean | Passed |
| TC-OHB-TGT-01 | OHB-TGT-01 | [target/onhand-beginning-population-validation.sql](sql/target/onhand-beginning-population-validation.sql) | Low velocity; 0 mismatches | Passed |
| TC-OHB-TGT-02 | OHB-TGT-02 | [target/velocity-sample-evidence.sql](sql/target/velocity-sample-evidence.sql) | 30 Low velocity samples | Passed |

## TC-OHB-KRO-0925-02 — execution notes

- **30 records:** 10 High, 10 Med, 10 Low (`BusDate >= 2025-09-01`).
- **Pass:** `ValidationResult = PASS`, `Expected_OnHandBeginning = OnHand_Begining`.
- `ChangeDetected` is validated via regression (action 3) and branch-wave sample SQL where backup joins apply; the 0925 velocity script is current-only.
- **Evidence:** [velocity-samples.csv](../../../evidence/onhand-beginning-reprocessing/kroger-0925/velocity-samples.csv)

## TC-OHB-KRO-02 — execution notes

**Expected:**

- `Expected_OnHandBeginning = OnHand_Begining`
- `ValidationResult = PASS`
- `ChangeDetected = YES` for sampled reprocessed rows

**Branches:** 1020 Northlake, 1077 Columbus, 1115 Irving Century.

## TC-OHB-TGT-02 — execution notes

- Only **Low Velocity** categories exist for in-scope Target branches.
- `OnHand_Begining_Backup` and `ChangeDetected` are **N/A** on staging (no Target rows in staging backup).
