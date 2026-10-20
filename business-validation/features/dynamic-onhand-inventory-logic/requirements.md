# Requirements — Dynamic On-Hand Inventory Logic

Requirements derived from the Jira story **PO: Business Validation & Testing for Dynamic On-Hand Inventory Logic**.

| ID | Requirement | Validation focus |
|----|-------------|------------------|
| REQ-001 | `Dynamic_OnHandQty` is calculated correctly across feedback and no-feedback paths | DOH-01–DOH-05 |
| REQ-002 | `Dynamic_OnHandQty` remains independent from Account Manager feedback | BR-002–BR-005; rolling behavior |
| REQ-003 | `Dynamic_OnHandQty` is used when inventory overrides are not present | BR-001; DOH-01 |
| REQ-004 | Existing inventory feedback functionality continues operating correctly | BR-002–BR-005; override `OnHand_Ending` |
| REQ-005 | Suggested Order calculations are not negatively impacted | Regression / downstream checks (see validation summary) |
| REQ-006 | Alerts continue functioning correctly | Regression / downstream checks |
| REQ-007 | Downstream Perfect Order functionality remains intact | Regression / downstream checks |

## Acceptance criteria (business)

1. When `Feedback_ShelfCapacity` is null, dynamic on-hand equals system ending inventory (`OnHand_Ending`).
2. When feedback is present, override inventory follows shelf-capacity rules; dynamic on-hand continues on its own path.
3. Feedback levels 0, 0.5, 1.0, and 1.5 produce expected override quantities per business rules BR-002–BR-005.

## Assumptions

- `OnHand_Ending` override logic applies only on the feedback-driven inventory path.
- `Dynamic_OnHandQty` rolling logic is evaluated independently after feedback is applied.
- `Max_ShelfCapacityQty` is available where shelf-percent feedback applies.

## Open questions (resolved for this initiative)

All scenarios in this package were executed and signed off; see `validation-summary.md`.
