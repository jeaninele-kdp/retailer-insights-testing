# SQL assets — STM incremental capacity

SQL validation scripts are **not** in the repository yet.

## Suggested scripts (when available)

| Suggested file | Purpose | Test case |
|----------------|---------|-----------|
| `stm-ic-01-closest-promotion.sql` | Promotion-level IC before/after for STM-IC-01 keys | TC-STM-IC-01 |
| `stm-ic-02-fifo-tie.sql` | Tie distance + FIFO ordering for STM-IC-02 | TC-STM-IC-02 |
| `stm-top7-precedence-check.sql` | Confirm Top7 completed before STM replacement | REQ-STM-001 |
| `stm-no-promotion-ic-equals-stm.sql` | BR-STM-007 population | TBD |

## Grain

Queries should return **promotion ID** level rows (customer, material, bus date, promotion, calculated IC, STM qty, final IC) before any aggregation.

## Evidence

Store result CSVs under `evidence/stm-incremental-capacity/` and link from `test-cases.md` and `traceability-matrix.md`.
