# TC-001 — Valid source PO passes catalog rules

- **Feature / epic:** Walmart PO source validation
- **Business requirement:** PO-001 through PO-005
- **Layer:** Source
- **Status:** Draft

## Scenario

Run the fixture validator against `fixtures/purchase-orders/valid-po-001.json`.

## SQL / validator

```bash
python scripts/validate.py fixtures/purchase-orders/valid-po-001.json
```

## Expected result

Exit code 0; no rule failures.

## Actual result

_TBD_

## Edge cases

Extend with real Retail Link / EDI samples once `docs/scope-and-assumptions.md` is confirmed.

## Notes / learnings

Negative fixtures exist for each `PO-*` rule under `fixtures/purchase-orders/`.
