# Feature overview — Dynamic On-Hand Inventory Logic

| Field | Value |
|-------|--------|
| **Feature name** | Dynamic On-Hand Inventory Logic |
| **Jira story** | PO: Business Validation & Testing for Dynamic On-Hand Inventory Logic |
| **Validation status** | Complete (reference package) |
| **Framework** | [Business validation framework](../../../docs/business-validation-framework.md) |

## Summary

This folder documents a **completed** business validation initiative. Use it as a reference for how Retailer Insights packages requirement traceability, business rules, scenarios, test execution, and sign-off.

## Business objective

Perform independent business validation of the Dynamic On-Hand Inventory Logic enhancement.

Confirm that:

- `Dynamic_OnHandQty` is calculated correctly.
- `Dynamic_OnHandQty` remains independent from Account Manager feedback.
- `Dynamic_OnHandQty` is used when inventory overrides are not present.
- Existing inventory feedback functionality continues operating correctly.
- Suggested Order calculations are not negatively impacted.
- Alerts continue functioning correctly.
- Downstream Perfect Order functionality remains intact.

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
| SQL | `sql/` (DOH-01–DOH-05 validation scripts) |

## Scope notes

- Primary validation window: **2026-09-01** through **2026-09-30** (scenario DOH-01).
- Retailers in scope for no-feedback coverage: Target, Dollar General, Kroger, Albertsons, Family Dollar, Meijer, Brookshire Grocery, Giant Eagle.
