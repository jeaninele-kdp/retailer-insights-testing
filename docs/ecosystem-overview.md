# Retailer Insights & Perfect Order ecosystem

## Business purpose

The Retailer Insights platform transforms raw retailer data into machine-learning-ready datasets that drive order forecasting and suggested order generation.

## Teams

### Retailer Data Team (upstream)

- Retailer data acquisition, ingestion, quality validation, standardization
- Feature engineering and forecast-ready dataset preparation
- **Technologies:** UC4, Snowflake

### Perfect Order Team (downstream)

- Vertex AI forecasting, model training/retraining, monitoring, publication
- MyDay support and Power BI reporting
- **Technologies:** UC4, Snowflake, GCP, Vertex AI, Power BI

Without Retailer Data outputs, forecasting, SOQ generation, Power BI refreshes, and MyDay recommendations cannot run.

## End-to-end data flow

```text
Retailer Source Systems
        │
        ▼
Acquisition Layer
        │
        ▼
Domain Layer
        │
        ▼
Data Product Layer
        │
        ▼
Retailer Order ML Dataset
        │
        ▼
Vertex AI Forecasting Pipelines
        │
        ▼
Perfect Order Outputs
        │
        ▼
MyDay / Power BI / Business Consumers
```

## Layer summary

| Layer | Purpose | Walmart PO touchpoint |
|-------|---------|------------------------|
| Acquisition | Ingest with minimal transformation | Raw PO files → staging |
| Domain | Standardize retailer formats | `Fact_PurchaseOrderDaily`, validity flags |
| Data product | Curated analytics / ML inputs | Forecast feature sets |
| ML dataset | Vertex AI input grain | Store × SKU × date signals |
| Perfect Order | Forecasts and SOQ | SOQ vs retailer suggested qty |

See `docs/testing-by-layer.md` for validation focus by layer.
