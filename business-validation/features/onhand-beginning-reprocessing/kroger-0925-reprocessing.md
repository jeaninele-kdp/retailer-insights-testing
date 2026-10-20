# Kroger OnHandBeginning reprocessing — September 2025 onward

Extension to the [OnHandBeginning reprocessing](feature-overview.md) package for **Kroger** chain-wide history reprocessed from **2025-09-01** forward.

| Field | Value |
|-------|--------|
| **Retailer** | Kroger |
| **NationalChainID** | `0001000889` |
| **Effective scope** | `BusDate >= '2025-09-01'` |
| **Velocity** | Low, Medium (`Med Velocity`), High |
| **Status** | Complete (reference) |

## Business rule

Approved narrative:

```text
OnHandBeginning = CEILING(MaxShelfCapacity × 0.5)
```

**Validation SQL** for population counts uses `ROUND(Max_ShelfCapacityQty * 0.5)` on staging (see [sql/kroger/0925/onhand-beginning-population-validation.sql](sql/kroger/0925/onhand-beginning-population-validation.sql)). Sample evidence uses:

```sql
Expected_OnHandBeginning =
CASE
    WHEN MOD(Max_ShelfCapacityQty, 2) <> 0
        THEN ROUND(Max_ShelfCapacityQty * 0.5)
    ELSE Max_ShelfCapacityQty * 0.5
END
```

> **Note:** Kroger staging has **CustomerNumber** as the store key (no `BranchID` on this object). Branch-level validation for Irving Century / Northlake / Columbus is documented separately under `sql/kroger/` (October reprocessing wave).

## Objects validated

- `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static"`
- `RETAILER_QA.INVENTORY."Fact_DailyInventory"` (row-count context; no `OnHand_Begining` on fact)

**Regression backup:** `RETAILER_QA.TECHNICAL."Stg_OnhandCalcFromDelvry_Static_BKP_08Oct26"` (and fact backup where referenced).

## Validation actions

| Action | Objective | SQL | Outcome |
|--------|-----------|-----|---------|
| 1 | Population rule + counts by velocity / BusDate; exception samples | [0925/onhand-beginning-population-validation.sql](sql/kroger/0925/onhand-beginning-population-validation.sql) | Rule mismatches = 0 |
| 2 | 10 High + 10 Med + 10 Low samples (30 rows) | [0925/velocity-sample-evidence.sql](sql/kroger/0925/velocity-sample-evidence.sql) | `ValidationResult = PASS` |
| 3 | Regression: `SalesQty`, `Max_ShelfCapacityQty`, `DeliveredQtyAdj` vs backup | [0925/regression-field-stability.sql](sql/kroger/0925/regression-field-stability.sql) | No unexpected regression |

## Test cases

| ID | Scenario |
|----|----------|
| TC-OHB-KRO-0925-01 | OHB-KRO-0925-01 — population |
| TC-OHB-KRO-0925-02 | OHB-KRO-0925-02 — velocity samples |
| TC-OHB-KRO-0925-03 | OHB-KRO-0925-03 — regression |

## Evidence

**Repository exports:** [evidence/onhand-beginning-reprocessing/kroger-0925/](../../../evidence/onhand-beginning-reprocessing/kroger-0925/README.md)

| Export | File |
|--------|------|
| Population by velocity (0 mismatches) | [population-by-velocity.csv](../../../evidence/onhand-beginning-reprocessing/kroger-0925/population-by-velocity.csv) |
| 30 velocity samples (all PASS) | [velocity-samples.csv](../../../evidence/onhand-beginning-reprocessing/kroger-0925/velocity-samples.csv) |
| Regression changed vs unchanged | [regression-field-stability.csv](../../../evidence/onhand-beginning-reprocessing/kroger-0925/regression-field-stability.csv) |

SQL provenance: `Kroger0925.sql` (aka `KrogerOnHandBeginning0925.sql`), `KrogerVelocitySamples0925.sql`, `Kroger0925Regression.sql`

## Relation to branch reprocessing package

| Track | Scope | SQL folder |
|-------|--------|------------|
| **0925 chain-wide** | All Kroger stores, `BusDate >= 2025-09-01` | `sql/kroger/0925/` |
| **Branch reprocessing** | Branches 1020, 1077, 1115; backup diff samples (90 rows) | `sql/kroger/*.sql` (parent folder) |

Both validate the same business intent; timing, grain, and backup comparisons differ.
