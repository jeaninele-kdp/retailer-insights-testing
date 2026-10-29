# Scenarios — Walmart purchase order data validation

SQL index: [sql/README.md](sql/README.md).

## Positive validation — Irving Trinity population (PV)

| ID | Objective | Expected | Result |
|----|-----------|----------|--------|
| **PV-01** | Walmart US / Branch 1225 population present in QA view | 520,937 rows | PASS |
| **PV-02** | Source distribution reconciles to population | Source 0: 517,568; Source 1: 3,369; Total: 520,937 | PASS |

**SQL:** [pv-population-and-distribution.sql](sql/pv-population-and-distribution.sql)

---

## Negative impact — scope containment (NEG)

| ID | Objective | Actual | Result |
|----|-----------|--------|--------|
| **NEG-01** | Only source values 0 and 1 | 652,312,517 @ 0; 3,369 @ 1 | PASS |
| **NEG-02** | No Source = 1 outside WMT US / 1225 | 0 violations | PASS |
| **NEG-03** | Source = 1 only for Walmart US / 1225 | 3,369 records | PASS |
| **NEG-04** | Non-Walmart retailers all Source = 0 | 40 retailers; 637,263,665 rows | PASS |
| **NEG-05** | Other Walmart branches all Source = 0 | 87 branches; 14,531,284 rows | PASS |
| **NEG-06** | Segments sum to view total | 520,937 + 14,531,284 + 637,263,665 = 652,315,886 | PASS |

**SQL:** [neg-suggested-order-source-scope.sql](sql/neg-suggested-order-source-scope.sql)

---

## Snowflake ↔ Power BI samples (WPO)

### PO quantity selected (`SuggestedOrderQtySource = 0`)

| ID | Customer | Material | Delivery date | SOQ | Result |
|----|----------|----------|---------------|-----|--------|
| **WPO-PO-01** | 0011988264 | 000000000010123485 | 2026-10-30 | 0 | PASS |
| **WPO-PO-02** | 0011277545 | 000000000010000829 | 2026-11-11 | 19 | PASS |
| **WPO-PO-03** | 0011275503* | 000000000010000228 | 2026-11-11 | 1 | PASS (report) |

\*Report example 3; SQL file uses customer `0011277308` / material `000000000010000187` for PO #3 query — re-run either key set as needed.

### Walmart quantity selected (`SuggestedOrderQtySource = 1`)

| ID | Customer | Material | Delivery date | SOQ | Result |
|----|----------|----------|---------------|-----|--------|
| **WPO-WAL-01** | 0012116691 | 000000000020038833 | 2026-11-02 | 1 | PASS |
| **WPO-WAL-02** | 0012090623 | 000000000010175563 | 2026-10-23 | 3 | PASS |
| **WPO-WAL-03** | 0011291898 | 000000000010000836 | 2026-10-22 | 179 | PASS (high qty review) |

**SQL:** [wpo-sample-snowflake-queries.sql](sql/wpo-sample-snowflake-queries.sql)

Each sample validates: Snowflake source flag, Snowflake SOQ, Power BI SOQ alignment.

---

## Pipeline scenarios (documented scope — extend with SQL)

| Theme | Status |
|-------|--------|
| Source-to-domain PO presence | Covered in initiative; add SQL to `sql/pipeline/` when archived |
| Cancelled PO on subsequent load | Planned |
| Duplicate PO | Planned |
| Missing delivery / received qty | Planned |
