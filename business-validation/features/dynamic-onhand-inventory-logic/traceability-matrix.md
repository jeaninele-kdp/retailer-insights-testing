# Traceability matrix — Dynamic On-Hand Inventory Logic

Maps **requirement → business rule → scenario → test case → evidence** per the [business validation framework](../../../docs/business-validation-framework.md).

| Requirement | Business rule | Scenario | Test case | Evidence |
|-------------|---------------|----------|-----------|----------|
| REQ-001 | BR-001 | DOH-01 | TC-DOH-01 | [sql/doh-01-no-feedback.sql](sql/doh-01-no-feedback.sql) |
| REQ-001 | BR-002 | DOH-02 | TC-DOH-02 | [sql/doh-02-oos-feedback.sql](sql/doh-02-oos-feedback.sql) |
| REQ-001 | BR-003 | DOH-03 | TC-DOH-03 | [sql/doh-03-half-shelf-feedback.sql](sql/doh-03-half-shelf-feedback.sql) |
| REQ-001 | BR-004 | DOH-04 | TC-DOH-04 | [sql/doh-04-full-shelf-feedback.sql](sql/doh-04-full-shelf-feedback.sql) |
| REQ-001 | BR-005 | DOH-05 | TC-DOH-05 | [sql/doh-05-full-shelf-plus-feedback.sql](sql/doh-05-full-shelf-plus-feedback.sql) |
| REQ-002 | BR-002–BR-005 | DOH-02–DOH-05 | TC-DOH-02–TC-DOH-05 | Dynamic independence checks in scenario results |
| REQ-003 | BR-001 | DOH-01 | TC-DOH-01 | PASS (Dynamic = OHE) |
| REQ-004 | BR-002–BR-005 | DOH-02–DOH-05 | TC-DOH-02–TC-DOH-05 | OnHand_Result PASS where applicable |
| REQ-005 | — | — | Regression (SOQ) | Validation summary — SOQ not impacted |
| REQ-006 | — | — | Regression (alerts) | Validation summary — alerts OK |
| REQ-007 | — | — | Regression (Perfect Order) | Validation summary — downstream intact |

## Coverage summary

| Business rule | Covered by scenario | Status |
|---------------|---------------------|--------|
| BR-001 | DOH-01 | Validated |
| BR-002 | DOH-02 | Validated |
| BR-003 | DOH-03 | Validated |
| BR-004 | DOH-04 | Validated |
| BR-005 | DOH-05 | Validated |
