# Testing focus by layer (Walmart PO)

## Acquisition

- File received on schedule
- Row counts vs control totals
- No truncation; types valid
- Incremental loads and late-arriving files
- Source keys land in staging

## Domain

- Transformation and status interpretation
- Inclusion / exclusion rules
- Duplicate prevention
- Source-to-domain reconciliation
- Population of `Fact_PurchaseOrderDaily`, `Dim_Store`, `Dim_Product`

## Data product

- Feature calculations and aggregations
- Completeness and business metrics
- Forecast input readiness

## Retailer Order ML dataset

- Feature population and date alignment
- Grain consistency (store × SKU × business date)
- Missing values within tolerance

## Perfect Order

- Model-specific inputs (Fully Automated, NPS, Shipment, UDS)
- Predicted vs suggested order quantities
- Monitoring and historical forecast results
- Downstream: MyDay and Power BI

Link layer checks to rule prefixes in `validation/rules/README.md` and rows in `docs/traceability-matrix.md`.
