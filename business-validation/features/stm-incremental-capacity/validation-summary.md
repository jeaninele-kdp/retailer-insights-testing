# Validation summary — STM incremental capacity

| Field | Value |
|-------|--------|
| **Feature** | STM incremental capacity |
| **Overall status** | **In progress** — rules confirmed; executable tests not yet run |
| **Sign-off** | Not started |

## Confirmed scope

Seven business rules (BR-STM-001 – BR-STM-007) documented and traced to scenarios **STM-IC-01** and **STM-IC-02**.

## Test execution

| Metric | Count |
|--------|-------|
| Test cases defined | 7 |
| Ready to execute | 2 (TC-STM-IC-01, TC-STM-IC-02) |
| Blocked | 4 |
| Discovery | 1 |
| Passed | 0 |
| Failed | 0 |

## Next steps

1. Obtain business answers for GAP-STM-001 – GAP-STM-004 (`defects.md`).
2. Add Snowflake / pipeline SQL under `sql/` for promotion-level IC before/after STM.
3. Execute TC-STM-IC-01 and TC-STM-IC-02; attach exports to `evidence/stm-incremental-capacity/`.
4. Add scenario for BR-STM-007 (no promotion → final IC = STM amount).
5. Complete Tech Connect / business sign-off per [business validation framework](../../../docs/business-validation-framework.md).

## Sign-off

| Role | Name | Date | Approval |
|------|------|------|----------|
| Business | | | |
| Product | | | |
| QA / Validation | | | |
