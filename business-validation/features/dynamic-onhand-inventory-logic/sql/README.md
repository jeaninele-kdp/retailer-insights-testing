# SQL assets — Dynamic On-Hand Inventory Logic

SQL files are **not** checked in yet. When scripts are provided, add them here and update links in `test-cases.md` and `traceability-matrix.md`.

## Planned placeholders

| Placeholder file (suggested name) | Purpose | Test case |
|-----------------------------------|---------|-----------|
| `doh-01-no-feedback-population.sql` | `Feedback_ShelfCapacity IS NULL`; Sep 2026; in-scope retailers | TC-DOH-01 |
| `doh-02-oos-feedback.sql` | `Feedback_ShelfCapacity = 0` | TC-DOH-02 |
| `doh-03-half-shelf-feedback.sql` | `Feedback_ShelfCapacity = 0.5` | TC-DOH-03 |
| `doh-04-full-shelf-feedback.sql` | `Feedback_ShelfCapacity = 1.0` | TC-DOH-04 |
| `doh-05-full-shelf-plus-feedback.sql` | `Feedback_ShelfCapacity = 1.5` | TC-DOH-05 |
| `regression-soq-impact.sql` | Suggested Order regression checks | REQ-005 |
| `regression-alerts.sql` | Alert regression checks | REQ-006 |
| `regression-perfect-order-downstream.sql` | Downstream Perfect Order checks | REQ-007 |

## Linking convention

When adding a script:

1. Save under this folder with the name above (or document renames here).
2. Update the **SQL** column in `../test-cases.md`.
3. Update the **Evidence** column in `../traceability-matrix.md`.
4. Attach or reference result exports under `../../../evidence/` if stored at repo level.
