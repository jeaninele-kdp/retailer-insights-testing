# Feature overview — STM incremental capacity

| Field | Value |
|-------|--------|
| **Feature name** | STM (Truck-to-Shelf) incremental capacity |
| **Initiative** | STM incremental capacity business validation |
| **Validation status** | In progress (scenarios & rules confirmed; open decisions documented) |
| **Framework** | [Business validation framework](../../../docs/business-validation-framework.md) |
| **Source scenarios** | `STM Business Scenarios.docx` (Copilot/Created) — summarized in [scenarios.md](scenarios.md) |

## Summary

Validate **incremental capacity (IC)** when **STM** orders interact with promotion-level calculated IC after **Top7** allocation. STM takes precedence for qualifying STMs; replacement logic runs at **promotion ID** grain before aggregation to date, customer, and material.

## Business objective

Confirm implemented logic matches confirmed business rules for:

- STM vs promotion IC replacement (closest match, FIFO tie-break)
- Single STM → single promotion replacement; other promotions unchanged
- STM-only IC when no promotion association exists
- Top7 running before STM precedence

Document edge cases still under business review (multiple active STMs, multi-STM + multi-promotion).

## Package contents

| Artifact | File |
|----------|------|
| Requirements | `requirements.md` |
| Business rules | `business-rules.md` |
| Scenarios | `scenarios.md` |
| Test cases | `test-cases.md` |
| Traceability | `traceability-matrix.md` |
| Defects / gaps | `defects.md` |
| Sign-off | `validation-summary.md` |
| SQL (future) | `sql/README.md` |

## Key entities (validation language)

| Term | Meaning |
|------|---------|
| **Calculated IC** | Promotion-level incremental capacity before STM replacement |
| **STM quantity** | Quantity from qualifying STM (field for replacement TBD — see open decisions) |
| **Final IC** | IC after STM replacement at promotion ID |
| **Top7** | Upstream allocation that runs before STM precedence |
