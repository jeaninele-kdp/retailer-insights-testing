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

### Dynamic On Hand
Business validation and regression testing for inventory calculations, beginning inventory logic, and downstream impacts.

### STM (Truck-to-Shelf)
Validation of STM logic, calculations, and integration requirements.

### Incremental Capacity
Testing and validation of incremental capacity calculations and business rules.

### Ad Hoc Display
Validation of display metrics, retailer submissions, and related calculations.

### Retailer Reprocessing
Regression validation following retailer data reprocessing activities.

---

## Repository Structure

```text
test-cases/
    Documented test scenarios and outcomes

sql/
    Validation and regression SQL queries

requirements/
    Business requirements and acceptance criteria

learnings/
    Testing discoveries, lessons learned, and edge cases

evidence/
    Validation results and supporting documentation
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
