# Feature overview — OnHandBeginning reprocessing (Kroger, Albertsons, Target)

| Field | Value |
|-------|--------|
| **Feature name** | OnHandBeginning reprocessing |
| **Initiative** | Business Validation — OnHandBeginning Reprocessing (Kroger, Albertsons, Target) |
| **Validation status** | Complete (reference package) |
| **Framework** | [Business validation framework](../../../docs/business-validation-framework.md) |

## Summary

Retailer inventory history was reprocessed to support updated **OnHandBeginning** logic:

```text
OnHandBeginning = CEILING(MaxShelfCapacity × 0.5)
```

(applied across in-scope velocity categories per retailer.)

This package documents independent business validation: population rule checks, stratified sample evidence (current vs backup), and regression on non-reprocessed fields.

## Retailers in scope

| Retailer | NationalChainID | Branches | Velocity categories validated |
|----------|-----------------|----------|------------------------------|
| Kroger | `0001000889` | 1020 Northlake, 1077 Columbus, 1115 Irving Century | Low, Medium, High |
| Albertsons | `0001001169` | 1020 Northlake, 1115 Irving Century | Low, Medium, High |
| Target | `0001000312` | 1020, 1077, 1115 | Low only |

## Objects validated

**Current**

- `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"`
- `RETAILER_QA.INVENTORY."Fact_DailyInventory"`

**Backup (08 Oct 2026)**

- `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"`
- `RETAILER_QA.INVENTORY."Fact_DailyInventory_bkp_08Oct26_V2"`

**Branch mapping**

- `RETAILER_QA.TECHNICAL."V_Load_Stg_InventoryAdjustmentsAuto"`

> **Target note:** Target is not present in the staging backup table; sample evidence is current-only with `ChangeDetected = N/A`. See `sql/target/velocity-sample-evidence.sql` header.

## Package contents

| Artifact | File |
|----------|------|
| Requirements | `requirements.md` |
| Business rules | `business-rules.md` |
| Scenarios | `scenarios.md` |
| Test cases | `test-cases.md` |
| Traceability | `traceability-matrix.md` |
| Defects | `defects.md` |
| Sign-off | `validation-summary.md` |
| SQL | `sql/` (by retailer) |

## Evidence attachments (external)

CSV exports referenced in Jira (e.g. Kroger, Albertsons, Target population and sample workbooks) can be stored under repo `evidence/onhand-beginning-reprocessing/` when archived.
