# Test cases — NDT POG shelf capacity

| Test case | Scenario | SQL | Status |
|-----------|----------|-----|--------|
| TC-SOC-POP-01 | SOC-POP-01 | population-results-shipment-chains.sql | Passed |
| TC-SOC-POP-02 | SOC-POP-02 | population-results-account-pog-chains.sql | Passed |
| TC-SOC-SMP-01 | SOC-SMP (6 examples) | sample-records-snowflake-pbi.sql | Passed |
| TC-SOC-NEG-01 | SOC-NEG-01 | negative-impact-scope-containment.sql (Test 1) | Passed |
| TC-SOC-NEG-02 | SOC-NEG-02 | negative-impact-scope-containment.sql (Tests 3–4) | Passed |

## TC-SOC-POP-01 — execution

Run funnel query in `population-results-shipment-chains.sql`. Compare `first_pass` / `first_fail` to report pass rates. Investigate non-pass with POG-own-account + first upcoming delivery grain.

## TC-SOC-SMP-01 — execution

Run `sample-records-snowflake-pbi.sql`; confirm `Result = PASS` and reconcile `ExpectedMaxShelf` to Power BI **QA_Comm_data** store capacity (rounding display acceptable per report).

## Evidence

[Business-Validation-Report-Shelf-Capacity-Logic.docx](../../../evidence/ndt-pog-shelf-capacity/Business-Validation-Report-Shelf-Capacity-Logic.docx)
