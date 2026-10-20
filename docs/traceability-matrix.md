# Traceability matrix (starter)

| ID | Layer | Rule / scenario | Fixture or SQL | Test case | Status |
|----|-------|-----------------|----------------|-----------|--------|
| PO-001 | Source | PO number required | `invalid-missing-po-number.json` | TC-001 | Draft |
| PO-002 | Source | Store required | `invalid-missing-store.json` | — | Draft |
| PO-003 | Source | Must-arrive ≥ order date | `invalid-must-arrive-before-order.json` | — | Draft |
| PO-004 | Source | Cancelled → zero open qty | `invalid-cancelled-open-qty.json` | — | Draft |
| PO-005 | Source | Unique line keys | `invalid-duplicate-line.json` | — | Draft |
| E2E-001 | E2E | Happy path source → SOQ (planned) | `queries/` TBD | — | Planned |
| E2E-002 | E2E | Cancelled PO excluded from forecast input | — | — | Planned |
| E2E-003 | E2E | Closed PO quantity handling | — | — | Planned |
| E2E-004 | E2E | Must-arrive misalignment | — | — | Planned |
| E2E-005 | E2E | Duplicate PO lines | — | — | Planned |
| E2E-006 | E2E | SOQ variance vs retailer suggested qty | — | — | Planned |
