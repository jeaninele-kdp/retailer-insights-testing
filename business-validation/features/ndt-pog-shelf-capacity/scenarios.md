# Scenarios — NDT POG shelf capacity

## Population validation (SOC-POP)

**Objective:** Map POG → customer/material → expected case capacity vs actual `Max_ShelfCapacityQty`.

| ID | SQL | Retailers covered |
|----|-----|-------------------|
| SOC-POP-01 | [population-results-shipment-chains.sql](sql/population-results-shipment-chains.sql) | AMPM/BP OIL, Circle K, Racetrac, Wawa, CVS (store match path) |
| SOC-POP-02 | [population-results-account-pog-chains.sql](sql/population-results-account-pog-chains.sql) | Casey's, Maverik, Murphy, Pilot, Yesway (account on POG) |

### Reported pass rates (first upcoming delivery)

| Retailer | Pass rate (initial) | Notes |
|----------|----------------------|--------|
| BP OIL / AMPM | 98.4% | Non-pass investigated; no formula defect |
| CIRCLE K | 98.8% | Many POG Capacity = 0 |
| RACETRAC | 99.7% | |
| WAWA | 99.5% | |
| CVS/PHARMACY | 99.9% | |
| MAVERIK | 100.0% | |
| YESWAY | 100.0% | |
| CASEY'S | 99.1% | Positive + zero→3 |
| MURPHY USA INC | 99.4% | |
| PILOT FLYING J | 98.7% | |

---

## Sample validation — Snowflake ↔ Power BI (SOC-SMP)

**SQL:** [sample-records-snowflake-pbi.sql](sql/sample-records-snowflake-pbi.sql) — six picked keys (one per chain mix).

| Example | Chain | Account | Delivery | Result |
|---------|-------|---------|----------|--------|
| 1 | YESWAY | 0012860156 | 2026-10-27 | PASS (PBI ≈ 0.125 cases) |
| 2 | CASEY'S | 0013032630 | 2026-10-27 | PASS (PBI ≈ 6.5 cases) |
| 3 | CVS | 0011333906 | 2026-11-06 | PASS (PBI ≈ 4 cases) |
| 4 | BP OIL | 0011977343 | 2026-10-27 | PASS (PBI ≈ 0.38 cases) |
| 5 | Maverik | 12098470 | 2026-11-03 | PASS (in SQL pick list) |
| 6 | Racetrac | 12003848 | 2026-10-27 | PASS (in SQL pick list) |

Report section 4 documents four PBI examples; SQL validates six including Maverik/Racetrac/Casey's picks.

---

## Negative impact (SOC-NEG)

**SQL:** [negative-impact-scope-containment.sql](sql/negative-impact-scope-containment.sql)

| ID | Objective | Result |
|----|-----------|--------|
| SOC-NEG-01 | Out-of-scope chains: rows matching POG formula = 0 | PASS |
| SOC-NEG-02 | Zero→3 rule not applied out-of-scope (EG Group, UDS, Spartan Nash, Loves controls) | PASS |

Notable out-of-scope chains with POG data but **not** using formula (report “C”): Love's, Euro Garages, Spartan Nash, All Other, IBC, Chevron Non Corporate, ExxonMobil.

---

## Passing retailer examples (report §3)

Detailed store/SKU examples for all 10 retailers are in the validation report Word doc (section 6.x).
