# Requirements — NDT POG shelf capacity

| ID | Requirement | Status |
|----|-------------|--------|
| REQ-SOC-001 | POG capacity flows to Perfect Order `Max_ShelfCapacityQty` for 10 chains | Passed (population) |
| REQ-SOC-002 | Unit-to-case conversion applied consistently | Passed |
| REQ-SOC-003 | `Capacity = 0` → use 3 before conversion (in-scope only) | Passed |
| REQ-SOC-004 | Population pass rates documented per retailer | Passed |
| REQ-SOC-005 | Six Snowflake samples align with Power BI store capacity | Passed |
| REQ-SOC-006 | Out-of-scope chains do not receive in-scope formula | Passed (NEG) |
| REQ-SOC-007 | Zero-to-3 rule does not leak to out-of-scope POG rows | Passed (NEG) |
| REQ-SOC-008 | Late-delivery / ranking edge cases investigated | Open |

## Expected output (product)

Perfect Order uses **MaxShelfCapacity** from NDT POG Source as capacity for the 10 chains so capacity is visible and used in order recommendations and Power BI.
