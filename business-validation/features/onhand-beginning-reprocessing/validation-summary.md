# Validation summary — OnHandBeginning reprocessing

| Field | Value |
|-------|--------|
| **Feature** | OnHandBeginning reprocessing |
| **Retailers** | Kroger, Albertsons, Target |
| **Overall result** | **Passed** — readiness recommended |

## Rule under test

```text
OnHand_Begining = CEIL(Max_ShelfCapacityQty × 0.5)
```

## Execution summary

| Retailer | Population check | Sample records | Regression | Outcome |
|----------|------------------|----------------|------------|---------|
| Kroger (0925 chain-wide) | `BusDate >= 2025-09-01`; 0 rule mismatches | 30 velocity samples | Regression vs backup | Pass |
| Kroger (branch wave) | 3 branches; 0 CEIL mismatches | 90 (H/M/L × 10 × 3 branches) | SalesQty / Max shelf / DeliveredQtyAdj | Pass |
| Albertsons | 2 branches; 0 mismatches | 60 | Field stability | Pass |
| Target | 3 branches; Low velocity only | 30 Low | N/A (staging backup) | Pass |

## Kroger highlights (from SQL execution notes)

- Staging population: **133,716** records reviewed; **0** CEIL rule mismatches.
- ~**34%** of staging rows changed vs backup (expected reprocessing).
- Fact `OnHandQty` change rates ~**92–93%** per branch (documented in script header).

## Target highlights

- Staging: **69,515** records; **0** mismatches (Low velocity).
- Target **not** in staging backup — sample evidence is current-only; fact backup used for impact queries.

## Test counts

| Metric | Value |
|--------|-------|
| Test cases executed | 11 |
| Passed | 11 |
| Failed | 0 |

## Defects

None — see `defects.md`.

## Risks / follow-ups

- Kroger 0925 CSV evidence: [evidence/onhand-beginning-reprocessing/kroger-0925/](../../../evidence/onhand-beginning-reprocessing/kroger-0925/README.md).
- Re-run population scripts after any additional retailer reprocessing waves.

## Sign-off

| Role | Name | Date | Approval |
|------|------|------|----------|
| Business | | | |
| Product | | | |
| QA / Validation | | | |

## Framework

Aligned with [business validation framework](../../../docs/business-validation-framework.md) Phases 5–7 (test preparation, execution, sign-off).
