# Traceability matrix — Walmart purchase order data validation

| Requirement | Rule | Scenario | Test case | Evidence |
|-------------|------|----------|-----------|----------|
| REQ-WPO-010 | BR-WPO-002 | NEG-02, NEG-03 | TC-WPO-NEG-02, TC-WPO-NEG-03 | NEG.sql |
| REQ-WPO-011 | BR-WPO-001 | NEG-01 | TC-WPO-NEG-01 | NEG.sql |
| REQ-WPO-012 | BR-WPO-002 | PV-01 | TC-WPO-PV-01 | PV.sql |
| REQ-WPO-013 | BR-WPO-003 | PV-02 | TC-WPO-PV-02 | PV.sql |
| REQ-WPO-014 | BR-WPO-002 | NEG-04, NEG-05 | TC-WPO-NEG-04, TC-WPO-NEG-05 | NEG.sql |
| REQ-WPO-015 | BR-WPO-003 | NEG-06 | TC-WPO-NEG-06 | NEG.sql |
| REQ-WPO-016 | BR-WPO-001 | WPO-PO-*, WPO-WAL-* | TC-WPO-PO-*, TC-WPO-WAL-* | WPOSample.sql + PBI |
| REQ-WPO-002 | BR-WPO-001 | WPO-WAL-* | TC-WPO-WAL-* | Samples |
| REQ-WPO-003 | — | WPO-WAL-03 | TC-WPO-WAL-03 | High qty 179 |
| REQ-WPO-001 | — | Pipeline | — | Future SQL |

Report: [Business-Validation-Report-Walmart-PO.docx](../../../evidence/walmart-purchase-order-data-validation/Business-Validation-Report-Walmart-PO.docx)
