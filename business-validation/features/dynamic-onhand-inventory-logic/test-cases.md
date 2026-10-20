# Test cases — Dynamic On-Hand Inventory Logic

Test cases map scenarios to executable validation steps. SQL assets will be linked under `sql/` when provided.

| Test case ID | Scenario | Business rules | SQL (placeholder) | Status |
|--------------|----------|----------------|-------------------|--------|
| TC-DOH-01 | DOH-01 | BR-001 | `sql/` — no-feedback population | Passed |
| TC-DOH-02 | DOH-02 | BR-002 | `sql/` — OOS feedback | Passed |
| TC-DOH-03 | DOH-03 | BR-003 | `sql/` — 50% shelf feedback | Passed |
| TC-DOH-04 | DOH-04 | BR-004 | `sql/` — 100% shelf feedback | Passed |
| TC-DOH-05 | DOH-05 | BR-005 | `sql/` — 150% shelf feedback | Passed |

---

## TC-DOH-01 — No feedback dynamic equals ending inventory

- **Scenario:** DOH-01
- **Preconditions:** September 2026 data loaded; listed retailers in scope
- **Steps:**
  1. Select population where `Feedback_ShelfCapacity IS NULL` (2026-09-01 – 2026-09-30).
  2. Compare `Dynamic_OnHandQty` to `OnHand_Ending` by store / item / date grain used in validation.
- **Expected:** `Dynamic_OnHandQty = OnHand_Ending` for all in-scope records
- **Actual:** PASS (Dynamic = OHE)
- **Evidence:** Link SQL and result export in `sql/` when added

---

## TC-DOH-02 — Out of stock feedback with independent dynamic roll

- **Scenario:** DOH-02
- **Steps:**
  1. Select population where `Feedback_ShelfCapacity = 0`.
  2. Confirm `OnHand_Ending = 0` on override path.
  3. Confirm `Dynamic_OnHandQty` continues post-feedback rolling independently.
- **Expected:** Override zeroed; dynamic rolling PASS
- **Actual:** PASS (Rolling)

---

## TC-DOH-03 — 50% shelf feedback

- **Scenario:** DOH-03
- **Steps:**
  1. Select population where `Feedback_ShelfCapacity = 0.5`.
  2. Validate `OnHand_Ending = ROUND(Max_ShelfCapacityQty * 0.5)`.
  3. Validate dynamic inventory independence (rolling).
- **Expected:** Override and dynamic results per scenario
- **Actual:** PASS (Rolling)

---

## TC-DOH-04 — 100% shelf feedback

- **Scenario:** DOH-04
- **Steps:**
  1. Select population where `Feedback_ShelfCapacity = 1.0`.
  2. Validate override quantity.
  3. Validate dynamic path (OnHand_Result and Dynamic_Result).
- **Expected:** OnHand_Result = PASS; Dynamic_Result = PASS
- **Actual:** OnHand_Result = PASS; Dynamic_Result = PASS

---

## TC-DOH-05 — Full shelf plus (150%) feedback

- **Scenario:** DOH-05
- **Steps:**
  1. Select population where `Feedback_ShelfCapacity = 1.5`.
  2. Validate override quantity.
  3. Validate dynamic path.
- **Expected:** OnHand_Result = PASS; Dynamic_Result = PASS
- **Actual:** OnHand_Result = PASS; Dynamic_Result = PASS

## Regression test cases (summary)

| Area | Objective | Result |
|------|-----------|--------|
| Suggested Order | No negative impact from dynamic on-hand enhancement | Passed (see validation summary) |
| Alerts | Continued correct alerting | Passed |
| Perfect Order downstream | No breakage in forecast / SOQ consumption | Passed |
