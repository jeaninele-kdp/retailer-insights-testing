# Business rules — STM incremental capacity

**Confirmed** rules from business scenario review (STM incremental capacity).

---

## BR-STM-001 — Top7 first

Top7 allocation runs **first**. STM logic applies only after Top7 completes.

---

## BR-STM-002 — STM precedence

Where a **qualifying STM** exists, STM takes **precedence** over promotion calculated IC for replacement decisions.

---

## BR-STM-003 — Closest promotion wins

If one STM can match **multiple promotion IDs** for the same customer, material, and bus date:

Replace **only** the promotion where:

```text
|Calculated IC − STM quantity|
```

is **minimized**.

---

## BR-STM-004 — FIFO on equal distance

If two or more promotions are **equally close** to the STM quantity, select the promotion using **FIFO** (earliest promotion **start date** among tied promotions).

**Open:** If tied promotions also share the same start date, an additional tie-breaker is required (see `defects.md` / REQ-STM-011).

---

## BR-STM-005 — One STM, one promotion

One STM must replace **no more than one** promotion ID. All other promotion-level IC values **pass through unchanged**.

---

## BR-STM-006 — Promotion grain before aggregation

Replacement occurs at **promotion-ID level** before aggregation to bus date, customer, and material.

---

## BR-STM-007 — No promotion association

If **no promotion** is associated with the STM, **final IC equals the STM amount**.

---

## Processing order (reference)

```text
Top7 allocation
      ↓
Promotion-level calculated IC
      ↓
STM precedence (qualifying STM)
      ↓
Closest-promotion replacement (+ FIFO tie)
      ↓
Aggregate to date / customer / material
```
