# Business rules — Dynamic On-Hand Inventory Logic

| Rule ID | Name | Condition | Expected behavior | Business meaning |
|---------|------|-----------|-------------------|------------------|
| BR-001 | No feedback scenario | `Feedback_ShelfCapacity IS NULL` | `Dynamic_OnHandQty = OnHand_Ending` | Dynamic inventory defaults to system-calculated ending inventory when Account Manager feedback does not exist. |
| BR-002 | Out of stock feedback | `Feedback_ShelfCapacity = 0` | `OnHand_Ending = 0`; `Dynamic_OnHandQty` continues independently | Feedback impacts only the override inventory path; dynamic inventory rolls forward independently. |
| BR-003 | 50% full shelf | `Feedback_ShelfCapacity = 0.5` | `OnHand_Ending = ROUND(Max_ShelfCapacityQty * 0.5)`; dynamic remains independent | Override reflects half shelf; dynamic path unchanged in dependency. |
| BR-004 | 100% full shelf | `Feedback_ShelfCapacity = 1.0` | `OnHand_Ending = ROUND(Max_ShelfCapacityQty * 1.0)`; dynamic remains independent | Override reflects full shelf capacity. |
| BR-005 | Full shelf plus | `Feedback_ShelfCapacity = 1.5` | `OnHand_Ending = ROUND(Max_ShelfCapacityQty * 1.5)`; dynamic remains independent | Override allows above-capacity feedback; dynamic path still independent. |

## Rule detail

### BR-001 — No feedback scenario

**Condition:**

```sql
Feedback_ShelfCapacity IS NULL
```

**Expected behavior:**

```text
Dynamic_OnHandQty = OnHand_Ending
```

**Business meaning:** Dynamic inventory should default directly to system-calculated ending inventory when Account Manager feedback does not exist.

---

### BR-002 — Out of stock feedback

**Condition:**

```sql
Feedback_ShelfCapacity = 0
```

**Expected behavior:**

```text
OnHand_Ending = 0
```

However:

```text
Dynamic_OnHandQty continues independently
```

**Business meaning:** Feedback should impact only the override inventory path. Dynamic inventory should continue rolling forward independently.

---

### BR-003 — 50% full shelf

**Condition:**

```sql
Feedback_ShelfCapacity = 0.5
```

**Expected behavior:**

```text
OnHand_Ending = ROUND(Max_ShelfCapacityQty * 0.5)
```

Dynamic inventory remains independent.

---

### BR-004 — 100% full shelf

**Condition:**

```sql
Feedback_ShelfCapacity = 1.0
```

**Expected behavior:**

```text
OnHand_Ending = ROUND(Max_ShelfCapacityQty * 1.0)
```

Dynamic inventory remains independent.

---

### BR-005 — Full shelf plus

**Condition:**

```sql
Feedback_ShelfCapacity = 1.5
```

**Expected behavior:**

```text
OnHand_Ending = ROUND(Max_ShelfCapacityQty * 1.5)
```

Dynamic inventory remains independent.
