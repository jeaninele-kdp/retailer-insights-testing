# Defects and open items — STM incremental capacity

No production **defects** logged yet. The following are **open business decisions** (not implementation bugs until rules are fixed).

| ID | Type | Summary | Scenario | Status |
|----|------|---------|----------|--------|
| GAP-STM-001 | Open decision | Multiple active STMs — which STMID wins? | STM-IC-03 – STM-IC-06 | Open |
| GAP-STM-002 | Open decision | STM quantity field: TotalOrderedQty vs ProposedQty vs NetDeliveredQty | STM-IC-03 – STM-IC-06 | Open |
| GAP-STM-003 | Open decision | TotalOrderedQty = 0 — override promotion IC? | STM-IC-04, STM-IC-05 | Open |
| GAP-STM-004 | Open decision | FIFO tie when promotion start dates are equal | STM-IC-02 | Open |
| GAP-STM-005 | Doc clarity | Example 2 title “smallest IC” vs FIFO narrative | STM-IC-02 | Clarify with business |

When a decision is approved, update `requirements.md`, `business-rules.md`, and move the linked scenario from **Blocked** to **Ready**.
