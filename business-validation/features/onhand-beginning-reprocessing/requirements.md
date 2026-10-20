# Requirements — OnHandBeginning reprocessing

| ID | Requirement | Retailers |
|----|-------------|-----------|
| REQ-OHB-001 | `OnHand_Begining` recalculated per approved rule: 50% of max shelf capacity with ceiling for odd capacities | Kroger, Albertsons, Target |
| REQ-OHB-002 | Population validation: zero rows where stored beginning ≠ expected calculation | All in-scope branches |
| REQ-OHB-003 | Stratified sample evidence by branch and velocity (10 per category where applicable) | Per retailer matrix |
| REQ-OHB-004 | Sample records show `ChangeDetected = YES` where backup exists and reprocessing applied | Kroger, Albertsons |
| REQ-OHB-005 | `SalesQty`, `Max_ShelfCapacityQty`, `DeliveredQtyAdj` substantially unchanged vs backup | Kroger, Albertsons |
| REQ-OHB-006 | Fact inventory impacts understood (`Fact_DailyInventory` vs backup) | All |
| REQ-OHB-007 | Document exceptions, counts by branch/velocity, and readiness recommendation | All |

## Validation objectives

1. Verify OnHandBeginning was recalculated according to the approved business rule.
2. Validate evidence samples across velocity categories (per retailer scope).
3. Compare current vs backup datasets.
4. Confirm expected inventory impacts.
5. Execute regression checks against unaffected measures and downstream outputs.
6. Document validation evidence and readiness recommendation.
