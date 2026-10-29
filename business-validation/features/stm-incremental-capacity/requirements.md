# Requirements — STM incremental capacity

| ID | Requirement | Status |
|----|-------------|--------|
| REQ-STM-001 | Top7 allocation completes before STM IC replacement logic | Confirmed |
| REQ-STM-002 | Qualifying STM takes precedence over calculated promotion IC | Confirmed |
| REQ-STM-003 | One STM matching multiple promotions replaces **only** the promotion with minimum \|Calculated IC − STM quantity\| | Confirmed |
| REQ-STM-004 | Equal distance → **FIFO** by promotion start date among tied promotions | Confirmed |
| REQ-STM-005 | One STM replaces **at most one** promotion ID; all other promotion IC values unchanged | Confirmed |
| REQ-STM-006 | Replacement at promotion-ID level **before** aggregation to bus date, customer, material | Confirmed |
| REQ-STM-007 | If no promotion is associated with the STM, **final IC = STM amount** | Confirmed |
| REQ-STM-008 | Multiple active STMs for same customer, material, date — selection rule | **Open** |
| REQ-STM-009 | Which STM measure drives replacement (TotalOrderedQty, ProposedQty, NetDeliveredQty) | **Open** |
| REQ-STM-010 | STM with TotalOrderedQty = 0 — still override promotion IC? | **Open** |
| REQ-STM-011 | FIFO tie when tied promotions share the same start date — final tie-breaker | **Open** |

## Out of scope (until decided)

- Full regression across all retailers (define in test data strategy)
- Downstream Perfect Order / SOQ impact (link when SQL available)
