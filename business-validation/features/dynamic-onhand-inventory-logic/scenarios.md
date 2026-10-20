# Scenarios — Dynamic On-Hand Inventory Logic

SQL for each scenario: see [sql/README.md](sql/README.md).

| Scenario ID | Title | Population | Expected result | Behavior | Validation outcome |
|-------------|-------|------------|-----------------|----------|-------------------|
| DOH-01 | No feedback | `Feedback_ShelfCapacity IS NULL` | `Dynamic_OnHandQty` equals `OnHand_Ending` | No feedback | PASS (Dynamic = OHE) |
| DOH-02 | Out of stock feedback | `Feedback_ShelfCapacity = 0` | `OnHand_Ending = 0`; dynamic independent | Post feedback rolling | PASS (Rolling) |
| DOH-03 | 50% full shelf feedback | `Feedback_ShelfCapacity = 0.5` | Override = `ROUND(Max_ShelfCapacityQty × 0.5)`; dynamic independent | Post feedback rolling | PASS (Rolling) |
| DOH-04 | 100% full shelf feedback | `Feedback_ShelfCapacity = 1.0` | Override = `ROUND(Max_ShelfCapacityQty × 1.0)`; dynamic independent | Post feedback rolling | OnHand_Result = PASS; Dynamic_Result = PASS |
| DOH-05 | Full shelf plus feedback | `Feedback_ShelfCapacity = 1.5` | Override = `ROUND(Max_ShelfCapacityQty × 1.5)`; dynamic independent | Post feedback rolling | OnHand_Result = PASS; Dynamic_Result = PASS |

---

## DOH-01 — No feedback

**Population:**

```sql
Feedback_ShelfCapacity IS NULL
```

**Retailers:**

- Target
- Dollar General
- Kroger
- Albertsons
- Family Dollar
- Meijer
- Brookshire Grocery
- Giant Eagle

**Date range:** 2026-09-01 through 2026-09-30

**Expected result:** `Dynamic_OnHandQty` equals `OnHand_Ending`.

**Behavior:** No feedback

**Validation:** PASS (Dynamic = OHE)

---

## DOH-02 — Out of stock feedback

**Population:**

```sql
Feedback_ShelfCapacity = 0
```

**Expected result:**

```text
OnHand_Ending = 0
```

Dynamic inventory remains independent.

**Behavior:** Post feedback rolling

**Validation:** PASS (Rolling)

---

## DOH-03 — 50% full shelf feedback

**Population:**

```sql
Feedback_ShelfCapacity = 0.5
```

**Expected result:** Override inventory equals:

```text
ROUND(Max_ShelfCapacityQty × 0.5)
```

Dynamic inventory continues independently.

**Behavior:** Post feedback rolling

**Validation:** PASS (Rolling)

---

## DOH-04 — 100% full shelf feedback

**Population:**

```sql
Feedback_ShelfCapacity = 1.0
```

**Expected result:** Override inventory equals:

```text
ROUND(Max_ShelfCapacityQty × 1.0)
```

Dynamic inventory remains independent.

**Validation:** OnHand_Result = PASS; Dynamic_Result = PASS

---

## DOH-05 — Full shelf plus feedback

**Population:**

```sql
Feedback_ShelfCapacity = 1.5
```

**Expected result:** Override inventory equals:

```text
ROUND(Max_ShelfCapacityQty × 1.5)
```

Dynamic inventory remains independent.

**Validation:** OnHand_Result = PASS; Dynamic_Result = PASS
