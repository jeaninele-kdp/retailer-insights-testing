# SQL assets — Dynamic On-Hand Inventory Logic

Row-level validation queries for scenarios DOH-01 through DOH-05. Run in Snowflake against **RETAILER_QA** (staging objects below).

## Source objects

| Object | Role |
|--------|------|
| `RETAILER_QA.TECHNICAL."Stg_Retailers_OnhandCalcFromDelvry"` | Retailer on-hand calc staging |
| `RETAILER_QA.TECHNICAL."Stg_Circana_OnhandCalcFromDelvry"` | Circana on-hand calc staging (e.g. Giant Eagle, Brookshire) |

**Date range:** `BusDate` between `2026-09-01` and `2026-09-30` (unless noted in script header).

## Test scripts

| File | Scenario | Test case | Key population |
|------|----------|-----------|----------------|
| [doh-01-no-feedback.sql](doh-01-no-feedback.sql) | DOH-01 | TC-DOH-01 | `Feedback_ShelfCapacity IS NULL` |
| [doh-02-oos-feedback.sql](doh-02-oos-feedback.sql) | DOH-02 | TC-DOH-02 | `Feedback_ShelfCapacity = 0` |
| [doh-03-half-shelf-feedback.sql](doh-03-half-shelf-feedback.sql) | DOH-03 | TC-DOH-03 | `Feedback_ShelfCapacity = 0.5` |
| [doh-04-full-shelf-feedback.sql](doh-04-full-shelf-feedback.sql) | DOH-04 | TC-DOH-04 | `Feedback_ShelfCapacity = 1.0` |
| [doh-05-full-shelf-plus-feedback.sql](doh-05-full-shelf-plus-feedback.sql) | DOH-05 | TC-DOH-05 | `Feedback_ShelfCapacity = 1.5` |

Each script uses a **candidates** CTE (store `CustomerNumber` + `EAN11` pairs) per retailer chain, dedupes by latest `seq_num`, and emits PASS/FAIL columns for override and/or dynamic rolling logic.

## Regression SQL (not yet in repo)

| Suggested file | Requirement |
|----------------|-------------|
| `regression-soq-impact.sql` | REQ-005 |
| `regression-alerts.sql` | REQ-006 |
| `regression-perfect-order-downstream.sql` | REQ-007 |

## Provenance

Original working copies: `DOH-1_Tests.sql` … `DOH-5_Tests.sql` (local OneDrive Documents).
