# Retailer Insights Test Repository

## Purpose

This repository serves as a centralized knowledge base for business validation, regression testing, SQL validation queries, and testing learnings across Retailer Insights initiatives.

The goal is to reduce duplicate testing effort, improve coverage consistency, and create a reusable library of test cases and validation patterns.

---

## Objectives

- Store reusable SQL validation queries
- Document completed test cases
- Capture business rules and assumptions
- Track edge cases discovered during testing
- Identify overlaps between existing and new test scenarios
- Build a searchable testing knowledge base for future projects

---

## Current Focus Areas

### Walmart Purchase Order (Perfect Order lineage)

Source PO validation, lineage investigations, and planned E2E coverage from acquisition through SOQ.

- **Completed validation package:** [business-validation/features/walmart-purchase-order-data-validation/](business-validation/features/walmart-purchase-order-data-validation/feature-overview.md)
- **Validation lifecycle:** `docs/business-validation-framework.md`
- **Lineage guide:** `docs/walmart-po-lineage.md`
- **Ecosystem context:** `docs/ecosystem-overview.md`
- **Source rule catalog:** `validation/rules/rules.json` (run `python scripts/validate.py`)
- **Traceability:** `docs/traceability-matrix.md`

### Dynamic On Hand
Business validation and regression testing for inventory calculations, beginning inventory logic, and downstream impacts.

- **Completed example package:** [business-validation/features/dynamic-onhand-inventory-logic/](business-validation/features/dynamic-onhand-inventory-logic/feature-overview.md)

### STM (Truck-to-Shelf)
Validation of STM logic, calculations, and integration requirements.

- **STM incremental capacity (in progress):** [business-validation/features/stm-incremental-capacity/](business-validation/features/stm-incremental-capacity/feature-overview.md)

### Incremental Capacity
Testing and validation of incremental capacity calculations and business rules.

- **NDT POG shelf capacity (10 chains):** [business-validation/features/ndt-pog-shelf-capacity/](business-validation/features/ndt-pog-shelf-capacity/feature-overview.md)

### Ad Hoc Display
Validation of display metrics, retailer submissions, and related calculations.

### Retailer Reprocessing
Regression validation following retailer data reprocessing activities.

- **OnHandBeginning reprocessing (Kroger, Albertsons, Target):** [business-validation/features/onhand-beginning-reprocessing/](business-validation/features/onhand-beginning-reprocessing/feature-overview.md)

---

## Repository Structure

```text
business-validation/  Feature validation packages (requirements → sign-off)
docs/                 Ecosystem, lineage, traceability, scope
test-cases/           Documented test scenarios and outcomes
fixtures/             Source-shaped JSON samples (Walmart PO)
validation/rules/     Business rule catalog (PO-*, ACQ-*, DOM-*, …)
scripts/              Lightweight validators (validate.py)
schemas/              JSON Schema for fixtures and rules
queries/              Snowflake validation SQL (placeholders)
investigations/       Production-style lineage write-ups
sql/                  Alias / additional SQL (see queries/)
requirements/         Business requirements and acceptance criteria
learnings/            Testing discoveries, lessons learned, and edge cases
evidence/             Validation results and supporting documentation
```

---

## Test Case Standard

Each test case should contain:

- Test ID
- Feature/Epic
- Business Requirement
- Test Scenario
- SQL Used
- Expected Result
- Actual Result
- Status
- Edge Cases
- Notes/Learnings

---

## Using Cursor

Before creating a new test case or validation query:

1. Search existing test cases for similar coverage.
2. Identify overlapping business scenarios.
3. Reuse existing validation patterns where possible.
4. Document any new edge cases discovered.
5. Link related SQL queries and requirements.

Example prompts:

```text
Search the repository for similar test coverage.

Compare this SQL to existing validation queries.

Identify duplicate test cases.

Suggest edge cases not currently covered.

What regression tests should be run if this logic changes?
```

---

## Long-Term Vision

Build a reusable testing knowledge base that:

- Preserves testing knowledge across projects
- Improves consistency of business validation
- Reduces duplicate work
- Accelerates onboarding to new features
- Provides traceability between requirements, SQL, and test outcomes
