# Business rules — OnHandBeginning reprocessing

## BR-OHB-001 — Beginning inventory at half shelf capacity

**Approved rule (population):**

```text
OnHand_Begining = CEIL(Max_ShelfCapacityQty × 0.5)
```

All velocity categories in scope for each retailer use this reprocessing rule.

**Field names in staging:** `OnHand_Begining`, `Max_ShelfCapacityQty` (note staging spelling `Begining`).

---

## BR-OHB-002 — Expected value for sample validation (odd/even shelf capacity)

For row-level sample evidence and tie-breaking where integer shelf capacities apply:

```sql
Expected_OnHandBeginning =
CASE
    WHEN MOD(Max_ShelfCapacityQty, 2) <> 0
        THEN CEIL(Max_ShelfCapacityQty * 0.5)
    ELSE Max_ShelfCapacityQty * 0.5
END
```

**Pass criteria (samples):**

- `ValidationResult = PASS` when `Expected_OnHandBeginning = OnHand_Begining`
- `ChangeDetected = YES` when current ≠ backup (where backup exists)
- Odd `Max_ShelfCapacityQty` values use ceiling rounding

---

## BR-OHB-003 — Non-reprocessed fields (regression)

Reprocessing must **not** materially alter:

- `SalesQty`
- `Max_ShelfCapacityQty`
- `DeliveredQtyAdj`

Compare current staging to `Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26` on keys: `CustomerNumber`, `EAN11`, `BusDate`, `seq_num`.
