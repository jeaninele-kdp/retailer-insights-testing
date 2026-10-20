# Business validation framework

## Purpose

This document captures the standard business testing and validation process used within Retailer Insights initiatives, including:

- Retailer Data
- Data Products
- Perfect Order 
- Downstream reporting solutions

Treat this framework as the **authoritative testing lifecycle** for business validation activities.

Related references:

- Lineage investigations: `docs/walmart-po-lineage.md`
- Layer-specific focus: `docs/testing-by-layer.md`
- Requirement-to-evidence mapping: `docs/traceability-matrix.md`
- Investigation write-ups: `investigations/_template-lineage.md`
- Feature packages (example): `business-validation/features/dynamic-onhand-inventory-logic/`

---

## Business validation philosophy

The Business Validation process exists to ensure implemented solutions satisfy business requirements, align with approved business logic, and produce expected outputs throughout the Retailer Insights ecosystem.

Business validation is **not** limited to verifying individual table values.

The objective is to validate:

- Business requirements
- Business logic
- End-to-end data lineage
- Edge case handling
- Reporting impacts
- Consumer impacts

The tester serves as the bridge between:

- Business stakeholders
- Product owners
- Developers
- Retailer Data teams
- Perfect Order teams

---

## Business validation lifecycle

### Phase 1: Requirement discovery

#### Step 1: Review epic

**Objective:** Understand:

- Business objective
- Scope
- Expected outcomes
- Impacted users
- Impacted datasets
- Upstream dependencies
- Downstream dependencies

**Questions:**

- What problem are we solving?
- What business process is changing?
- What data products are impacted?
- Who consumes the output?

**Deliverables:**

- Requirement summary
- Initial questions list

#### Step 2: Meet with business team

**Objective:** Gather requirements directly from business stakeholders.

**Activities:**

- Clarify business rules
- Clarify expected outcomes
- Understand operational workflows
- Capture assumptions

**Deliverables:**

- Business notes
- Business rules inventory

---

### Phase 2: Solution review

#### Step 3: Technical review with developer

**Objective:** Review implementation approach and technical design.

**Activities:**

- Review current logic
- Review impacted systems
- Review data flow
- Review implementation approach

**Deliverables:**

- Logic understanding document
- Initial validation strategy

#### Step 4: Create business scenarios

**Objective:** Translate business requirements into testable scenarios.

All features should have:

**Happy path scenarios**

Examples:

- Valid purchase order
- Expected delivery confirmation
- Expected forecast generation

**Negative scenarios**

Examples:

- Missing purchase order
- Missing delivery confirmation
- Invalid material
- Invalid store

**Edge cases**

Examples:

- Closed PO
- Cancelled PO
- Duplicate PO
- Late delivery
- Missing inventory
- Material mapping failure
- Future-dated records

**Deliverables:**

- Scenario matrix

---

### Phase 3: Business review

#### Step 5: Present in Tech Connect

**Objective:** Review logic and scenarios with:

- Business stakeholders
- Product owners
- Developers

**Activities:**

- Walk through logic
- Review business scenarios
- Review edge cases
- Review assumptions

**Deliverables:**

- Feedback log
- Updated scenarios

#### Step 6: Refine logic

**Objective:** Incorporate business feedback.

**Activities:**

- Adjust scenarios
- Add uncovered cases
- Clarify requirements
- Resolve disagreements

This cycle repeats until alignment is reached.

**Deliverables:**

- Approved validation coverage

#### Step 7: Business sign-off

**Objective:** Obtain formal approval on:

- Logic, Rules, Scenarios

**Deliverable:** Approved business logic

No implementation should begin without agreed requirements.

---

### Phase 4: Development

#### Step 8: Development and engineering validation

Developers implement approved requirements.

**Developer responsibilities:**

- Unit testing
- Integration testing
- Engineering validation
- Technical defect correction

**Deliverables:**

- Completed feature
- Engineering validation results

---

### Phase 5: Test preparation

#### Step 9: Test data strategy

Define validation datasets.

Coverage should include:

| Category | Intent |
|----------|--------|
| Happy path data | Expected successful processing |
| Negative data | Expected rejection or exclusion |
| Boundary conditions | First date, last date, null conditions, zero quantities |
| Historical data | Validate retroactive impacts |

**Deliverable:** Testing dataset plan

---

### Phase 6: Business validation

#### Step 10: Execute tests

Perform business validation testing.

Validation may include:

- Source validation
- Acquisition validation
- Domain validation
- Data product validation
- Forecast validation
- Reporting validation

**Examples:**

- Walmart PO validation
- Perfect Order forecast validation
- SOQ validation
- Power BI validation

**Deliverable:** Test execution results

#### Step 11: Defect investigation and root cause analysis

**Objective**

When validation uncovers unexpected behavior, the tester is responsible for identifying the most likely source of the issue before engaging development teams.

The goal is not simply to report a failure but to accelerate defect resolution by providing business context, lineage analysis, and supporting evidence.

**Investigation process**

For each defect:

1. **Confirm defect**  
   Validate that:
   - The issue is reproducible
   - Business logic is understood correctly
   - Expected results were approved by stakeholders

2. **Gather evidence**  
   Collect:
   - SQL results
   - Screenshots
   - Record counts
   - Sample records
   - Business examples
   - Impact analysis

3. **Develop root cause hypothesis**  
   Document the most likely cause (use lineage thinking in `docs/walmart-po-lineage.md`).

4. **Communicate findings**  
   Provide developers with:
   - Defect description
   - Expected result
   - Actual result
   - Supporting evidence
   - Root cause hypothesis
   - Business impact

#### Step 12: Defect resolution validation

After a fix is implemented:

**Activities**

- Re-execute failed test cases
- Validate root cause is resolved
- Confirm no regression introduced
- Validate downstream impacts

---

### Phase 7: Validation sign-off

#### Step 13: Validation summary

Create final validation package.

**Include:**

- Feature name
- Epic
- Test cases executed
- Passed tests
- Failed tests
- Defects found
- Defects resolved
- Risks
- Supporting evidence

**Deliverable:** Validation sign-off document

---

## Retailer Insights specific testing principles

Business validation should always evaluate:

| Principle | Question |
|-----------|----------|
| Requirement accuracy | Did we build the correct solution? |
| Logic accuracy | Does implementation match approved business rules? |
| Data lineage integrity | Can outputs be traced to their source? |
| Edge case coverage | Have exceptions been validated? |
| Consumer impact | Are downstream users receiving expected results? |

**Consumer impact examples:**

- MyDay
- Power BI
- Retailer reporting
- Forecast consumers
