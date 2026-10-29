# Traceability matrix — NDT POG shelf capacity

| Requirement | Rule | Scenario | Test case | Evidence |
|-------------|------|----------|-----------|----------|
| REQ-SOC-001 | BR-SOC-001 | SOC-POP-01, SOC-POP-02 | TC-SOC-POP-* | Population SQL + report §2 |
| REQ-SOC-002 | BR-SOC-001 | SOC-POP-* | TC-SOC-POP-* | Conversion columns in sample SQL |
| REQ-SOC-003 | BR-SOC-002 | SOC-POP-*, SOC-NEG-02 | TC-SOC-POP-*, TC-SOC-NEG-02 | Zero→3 in SQL |
| REQ-SOC-004 | BR-SOC-001 | SOC-POP-* | TC-SOC-POP-* | Pass rate table in report |
| REQ-SOC-005 | BR-SOC-001 | SOC-SMP | TC-SOC-SMP-01 | 6samplerecords.sql + PBI |
| REQ-SOC-006 | BR-SOC-003 | SOC-NEG-01 | TC-SOC-NEG-01 | socnegativeimpacttesting.sql |
| REQ-SOC-007 | BR-SOC-002 | SOC-NEG-02 | TC-SOC-NEG-02 | Leakage summary in report §5.2 |
| REQ-SOC-008 | BR-SOC-005 | — | — | Report late delivery note |
