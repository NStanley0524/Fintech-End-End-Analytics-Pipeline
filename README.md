# Fintech End-End Analytics Pipeline

## Overview

This project implements an end-to-end analytics platform for a fintech system, designed to model and analyze user transactions, revenue generation, retention, and loan performance.

The platform transforms raw operational data into analytics-ready datasets that support business decision-making across growth, product, and risk teams.

---

## Architecture

S3 → Airbyte → BigQuery → dbt → BI Dashboard

* **Amazon S3**: Data storage layer
* **Airbyte**: Data ingestion into the warehouse
* **BigQuery**: Central data warehouse
* **dbt**: Transformation and modeling layer
* **Metabase / Redash**: Business intelligence and visualization

---

## Data Modeling Approach

The warehouse follows a layered modeling structure:

### Staging Layer

Standardizes and cleans raw data:

* `stg_transactions`
* `stg_users`
* `stg_loans`
* `stg_repayments`

---

### Core Models

#### Fact Table

* `fact_transactions`

  * Central source of transaction activity
  * Defines a consistent `primary_user_id` for user-level analysis

#### Dimension Table

* `dim_users`

  * Aggregated user-level metrics
  * Includes transaction activity, inflow/outflow, and revenue contribution

---

### Metrics Layer

* `fct_daily_metrics`

  * Daily performance metrics (GMV, revenue, active users)

* `fct_revenue_by_channel`

  * Revenue and transaction performance by acquisition channel

* `fct_user_cohorts`

  * Cohort-based retention analysis

* `fct_loan_performance`

  * Loan repayment tracking and risk metrics (repayment ratio, outstanding balance)

---

## Dashboard

The dashboard provides a unified view of platform performance:

* Transaction volume and revenue trends
* User acquisition and engagement
* Retention behavior across cohorts
* Loan performance and repayment patterns

📸 *Dashboard Screenshots*

![Overview](dashboards/overview.png)
![Revenue](dashboards/revenue.png)
![Cohorts](dashboards/cohorts.png)
![Loans](dashboards/loans.png)

---

## Key Insights

* Acquisition channels contribute differently to revenue, with certain channels driving higher-value users
* User retention declines significantly after initial signup, indicating opportunities to improve onboarding
* Transaction activity is unevenly distributed, with a subset of users contributing a large share of volume
* Loan repayment patterns reveal both fully repaid and partially repaid segments, highlighting varying risk profiles

---

## Data Quality & Reliability

* Implemented dbt tests (`not_null`, `unique`, `accepted_values`) to enforce data integrity
* Applied defensive transformations using `safe_cast` and `safe_divide`
* Maintained consistent model grain and metric definitions

---

## Historical Tracking

* Implemented dbt snapshots to track changes in user attributes over time
* Enables longitudinal analysis of user behavior and lifecycle changes

---

## Capabilities

This platform supports:

* Revenue and growth analysis
* User segmentation and engagement tracking
* Retention and cohort analysis
* Lending performance and risk monitoring

---

## Future Enhancements

* Incremental modeling for large-scale data processing
* Real-time data ingestion
* Advanced fraud detection models
* Customer lifetime value (LTV) modeling

---
