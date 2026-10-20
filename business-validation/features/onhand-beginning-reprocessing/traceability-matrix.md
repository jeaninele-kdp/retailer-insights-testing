# Traceability matrix — OnHandBeginning reprocessing

| Requirement | Business rule | Scenario | Test case | Evidence |
|-------------|---------------|----------|-----------|----------|
| REQ-OHB-001 | BR-OHB-001, BR-OHB-004 | OHB-KRO-0925-01 | TC-OHB-KRO-0925-01 | [kroger/0925/onhand-beginning-population-validation.sql](sql/kroger/0925/onhand-beginning-population-validation.sql) |
| REQ-OHB-003 | BR-OHB-004 | OHB-KRO-0925-02 | TC-OHB-KRO-0925-02 | [kroger/0925/velocity-sample-evidence.sql](sql/kroger/0925/velocity-sample-evidence.sql) |
| REQ-OHB-005 | BR-OHB-003 | OHB-KRO-0925-03 | TC-OHB-KRO-0925-03 | [kroger/0925/regression-field-stability.sql](sql/kroger/0925/regression-field-stability.sql) |
| REQ-OHB-001 | BR-OHB-001 | OHB-KRO-01 | TC-OHB-KRO-01 | [kroger/onhand-beginning-population-validation.sql](sql/kroger/onhand-beginning-population-validation.sql) |
| REQ-OHB-001 | BR-OHB-001 | OHB-ALB-01 | TC-OHB-ALB-01 | [albertsons/onhand-beginning-population-validation.sql](sql/albertsons/onhand-beginning-population-validation.sql) |
| REQ-OHB-001 | BR-OHB-001 | OHB-TGT-01 | TC-OHB-TGT-01 | [target/onhand-beginning-population-validation.sql](sql/target/onhand-beginning-population-validation.sql) |
| REQ-OHB-003 | BR-OHB-002 | OHB-KRO-02 | TC-OHB-KRO-02 | [kroger/velocity-sample-evidence.sql](sql/kroger/velocity-sample-evidence.sql) |
| REQ-OHB-003 | BR-OHB-002 | OHB-ALB-02 | TC-OHB-ALB-02 | [albertsons/velocity-sample-evidence.sql](sql/albertsons/velocity-sample-evidence.sql) |
| REQ-OHB-003 | BR-OHB-002 | OHB-TGT-02 | TC-OHB-TGT-02 | [target/velocity-sample-evidence.sql](sql/target/velocity-sample-evidence.sql) |
| REQ-OHB-004 | BR-OHB-002 | OHB-KRO-02, OHB-ALB-02 | TC-OHB-KRO-02, TC-OHB-ALB-02 | Sample output — ChangeDetected |
| REQ-OHB-005 | BR-OHB-003 | OHB-KRO-03, OHB-ALB-03 | TC-OHB-KRO-03, TC-OHB-ALB-03 | Regression SQL + summaries |
| REQ-OHB-006 | BR-OHB-001 | All population Q4 / fact sections | TC-OHB-*-01 | Fact backup comparison in population scripts |
| REQ-OHB-007 | — | All | All | `validation-summary.md` |
