# Defects — OnHandBeginning reprocessing

| Defect ID | Retailer | Summary | Status |
|-----------|----------|---------|--------|
| — | — | No business validation defects logged; population mismatch queries returned zero exception rows | Closed |

## Exception review

Population validation queries (Q1 / Q3 in retailer scripts) were used to list any row where `OnHand_Begining` does not match the CEIL half-capacity rule. **No open mismatches** were retained for sign-off.

If new mismatches appear after a subsequent reprocessing run, log:

- BranchID, velocity, CustomerNumber, EAN11, BusDate
- `Max_ShelfCapacityQty`, `OnHand_Begining`, `Expected_OnHandBeginning`
- Link to SQL export under `sql/` and `evidence/`
