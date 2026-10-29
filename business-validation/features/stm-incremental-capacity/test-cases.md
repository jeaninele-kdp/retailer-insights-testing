# Test cases — STM incremental capacity

| Test case | Scenario | Rules | SQL | Status |
|-----------|----------|-------|-----|--------|
| TC-STM-IC-01 | STM-IC-01 | BR-STM-003, BR-STM-005, BR-STM-006 | `sql/` TBD | Draft |
| TC-STM-IC-02 | STM-IC-02 | BR-STM-004, BR-STM-003 | `sql/` TBD | Draft |
| TC-STM-IC-03 | STM-IC-03 | TBD | — | Blocked |
| TC-STM-IC-04 | STM-IC-04 | TBD | — | Blocked |
| TC-STM-IC-05 | STM-IC-05 | TBD | — | Blocked |
| TC-STM-IC-06 | STM-IC-06 | TBD | — | Blocked |
| TC-STM-IC-07 | STM-IC-07 | — | — | Discovery |

---

## TC-STM-IC-01 — Closest promotion replacement

**Preconditions:** Top7 complete; qualifying STM 3392 qty 4 on 2026-09-08.

**Steps:**

1. Load promotion-level calculated IC for customer `0012509760`, material `000000000010000852`.
2. Apply STM replacement at promotion ID grain.
3. Compare IC after to expected matrix in [scenarios.md](scenarios.md#stmic-01--closest-promotion-wins).

**Expected:** Single promotion IC 3 → 4; others unchanged.

**Evidence:** _Pending SQL / export_

---

## TC-STM-IC-02 — FIFO tie-break

**Preconditions:** STM 3141 qty 48 on 2026-07-14.

**Steps:**

1. Identify promotions with equal \|Calculated IC − 48\|.
2. Verify FIFO by promotion start date selects 7UP Endless Summer LTO.
3. Confirm only that promotion IC changes 52 → 48.

**Expected:** Per BR-STM-004 and scenario STM-IC-02.

**Evidence:** _Pending_

---

## Blocked test cases (STM-IC-03 – STM-IC-06)

Do not execute until REQ-STM-008, REQ-STM-009, REQ-STM-010 resolved and scenarios marked **Ready**.
