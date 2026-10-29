# Feature overview — NDT POG shelf capacity (Perfect Order)

| Field | Value |
|-------|--------|
| **Feature name** | NDT POG shelf capacity for Perfect Order |
| **Initiative** | Use `MaxShelfCapacity` from NDT POG Source for in-scope chains |
| **Validation status** | Complete (reference package) |
| **Framework** | [Business validation framework](../../../docs/business-validation-framework.md) |

## Business objective

Ten national chains already have capacity in **NDT POG Source**, but Perfect Order was not using it. After enhancement, **Perfect Order `Max_ShelfCapacityQty`** should reflect POG-derived shelf capacity (with unit-to-case conversion) so capacity appears in order recommendations and **Power BI** store capacity.

## In-scope chains

| NationalChainName | NationalChainID |
|-------------------|-----------------|
| BP OIL | 0001000555 |
| CASEY'S GENERAL STORE | 0001014819 |
| CIRCLE K | 0001001363 |
| CVS/PHARMACY | 0001000133 |
| MAVERIK COUNTRY STORE | 0001014910 |
| MURPHY OIL USA | 0001000532 |
| PILOT FLYING J | 0001000399 |
| RACETRAC | 0001001626 |
| WAWA | 0001016110 |
| YESWAY | 0001016096 |

## Validation flow

```text
RETAILER_PROD.POG."V_Fact_POG" (capacity)
        ↓
Business rules (incl. Capacity = 0 → 3)
        ↓
Unit-to-case conversion (SU / PC / EA)
        ↓
Perfect Order Max_ShelfCapacityQty (prediction facts)
        ↓
Power BI QA_Comm_data store capacity
```

## Related logic (Walmart suggested order)

When validating Walmart PO suggested quantities (separate feature):

- If **Walmart suggested order > PO suggested** → use **Walmart**
- If **Walmart suggested order ≤ PO suggested** → use **PO suggested**

See [Walmart PO data validation](../walmart-purchase-order-data-validation/feature-overview.md).

## Sources & targets

| Layer | Object |
|-------|--------|
| POG | `RETAILER_PROD.POG."V_Fact_POG"` |
| Shipment model | `DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderShpmntPredicted"` |
| UDS | `Fact_CustItemOrderUDSPredicted` |
| NPS | `Fact_CustItemOrderNPSalesPredicted_SF` |
| Product / UoM | `SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod"`, `MD_PROD.SAP."Dim_AltUnit"` |
| Accounts | `SOLUTIONS_PROD.COMMERCIALS."V_Dim_Account"` |

## Package & evidence

| Artifact | Location |
|----------|----------|
| Validation report (Word) | [evidence/.../Business-Validation-Report-Shelf-Capacity-Logic.docx](../../../evidence/ndt-pog-shelf-capacity/Business-Validation-Report-Shelf-Capacity-Logic.docx) |
| SQL | `sql/` |
