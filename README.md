## 1. Problem Statement

A healthcare organization wants to transition from spreadsheet-based reporting to a database-driven reporting system. The available patient records were collected from multiple hospitals across Kenya but contain inconsistent formats, missing values, duplicates, and invalid entries.

The organization requires reliable data to understand:

- Hospital workload
- County-level healthcare demand
- Doctor workload
- Treatment cost distribution
- Payment reconciliation
- Follow-up pressure

This project demonstrates how SQL can be used to clean, standardize, transform, and analyze healthcare data to support operational and financial decision-making.

## 2. Project Objectives

The objectives of this project are to:

- Import raw healthcare data into PostgreSQL.
- Preserve the original dataset without modification.
- Validate data quality using SQL.
- Clean and standardize inconsistent data.
- Create reusable reporting views.
- Build SQL queries to answer operational and financial questions.
- Support reporting, analytics, and business decision-making.

## 3. Tools Used

- PostgreSQL
- SQL
- DBeaver
- Git
- GitHub

## 4. Database Design

The project follows a layered ETL (Extract, Transform, Load) approach to ensure data integrity while preserving the original source data.

```text
CSV Dataset
      │
      ▼
raw_patient_records
      │
      ▼
clean_patient_records
      │
      ▼
standardized_patient_records
      │
      ▼
Reporting Views
      │
      ▼
Analysis Queries
```

This architecture protects the raw dataset while allowing repeatable cleaning, standardization, and reporting without modifying the original data.


## 5. Data Loading

The healthcare dataset was imported into a PostgreSQL database named **healthcare_operations**.

A staging table named **raw_patient_records** was created to preserve the original CSV exactly as received.

## Import Summary

| Metric | Value |
|---------|------:|
| Database | healthcare_operations |
| Source File | Patient Records CSV |
| Raw Table | raw_patient_records |
| Total Records Imported | 6,400 |

The raw table serves as the source for all validation, cleaning, standardization, reporting, and analytical processes.

## 6. Data Validation

Before applying any transformations, SQL validation queries were executed to assess the quality of the raw dataset.

The validation process identified records containing:

- Missing patient identifiers
- Missing hospital names
- Missing county names
- Missing doctor identifiers
- Duplicate patient records
- Invalid numeric values
- Invalid admission and discharge dates
- Records requiring manual review

Identifying these issues before cleaning helps ensure that subsequent transformations are applied to well-understood data quality problems.

## 7. Data Cleaning

After validation, a cleaned dataset was created in a separate table named **clean_patient_records**.

Cleaning activities included:

- Removing duplicate patient records.
- Replacing invalid values with NULL where appropriate.
- Correcting inconsistent text values.
- Preserving the original raw dataset.
- Preparing data for standardization.

Creating a separate cleaned table ensures that the raw data remains unchanged while providing a reliable dataset for further processing.

## 8. Data Standardization

To improve consistency across the dataset, a new table named **standardized_patient_records** was created from the cleaned data.

The standardization process included:

### a) Gender Standardization

Standardized gender values into consistent categories.

Examples:

- male → Male
- FEMALE → Female
- Missing values → Unknown

### b) Age Validation

Validated age values and retained only numeric entries.

Examples:

- 45 → 45
- NA → NULL

### c) Treatment Cost Cleaning

Removed currency symbols, commas, and non-numeric characters.

Examples:

- KES 25,000 → 25000
- 43,036 → 43036

### d) Mobile Money Payment Cleaning

Standardized payment amounts into numeric values.

Examples:

- KES 1,500 → 1500
- 5,300 → 5300

### e) Temperature Standardization

Removed non-numeric characters.

Examples:

- 38C → 38
- 37.5 → 37.5

### f) Follow-up Standardization

Standardized follow-up indicators.

Examples:

- Y → Yes
- YES → Yes
- N → No

### g) Date Standardization

Admission and discharge dates were converted into the ISO standard format (**YYYY-MM-DD**) where possible.

Supported formats included:

- DD/MM/YYYY
- Mon-YYYY
- YYYY.MM.DD
- YYYY-MM-DD

Standardizing these fields ensures that date calculations, aggregations, and reporting queries can be performed consistently.

## 9. Dimension Tables

To support relational analysis and reporting, separate dimension tables were created after cleaning and standardization.

The following dimension tables were created:

- **dim_hospital** – Stores unique hospitals and their associated counties.
- **dim_county** – Stores unique county names.
- **dim_doctor** – Stores unique doctor identifiers.
- **dim_disease** – Stores unique disease categories.

These dimension tables reduce redundancy, simplify joins, and demonstrate dimensional modeling concepts commonly used in data warehouses and business intelligence solutions.

## 10. Reporting Layer

Views

- vw_patient_reporting
- vw_hospital_summary
- vw_county_summary
- vw_doctor_summary
- vw_payment_summary
- vw_follow_up_summary

These views provide reusable datasets for reporting and dashboards.

## 11. Project Structure


      SQL-End-to-End-Data-project/

            │


            │

            ├── 01 create_database.sql

            ├── 02create_raw_table.sql 

            ├── 03 cleaned_patient_records.sql

            ├── 04 create_dimension_tables.sql

            ├── 05 data_validation.sql

            ├── 06_standardised_patient_records.sql

            ├── 07_reporting_views.sql

            └── 08_analysis_queries.sql

            │

            └── README.md

## Business Questions Answered

The `analysis_queries.sql file` answers about 80 business questions including:

## 1. Hospital Operations

- Which hospital has the highest workload?
- Which hospitals are above average workload?
- Which hospitals have the longest patient stays?

## 2. County Analysis

- Which counties have the highest healthcare demand?
- Which counties have the highest treatment costs?

## 3. Doctor Analysis

- Which doctors have the highest workload?
- Which doctors manage the most follow-up cases?

## 4. Finance

- Outstanding payment balances
- Payment reconciliation
- Hospitals with highest unpaid balances

## 5. Reporting

- Hospital Summary
- County Summary
- Doctor Summary
- Payment Summary

## Key Insights

Example insights generated from the analysis include:

- Hospitals with the highest patient volumes experience greater operational pressure.
- Counties with fewer hospitals but high patient counts may require additional healthcare investment.
- Some doctors manage significantly larger workloads than others, indicating potential staffing imbalances.
- Outstanding payment balances vary considerably across hospitals and counties.
- Standardized reporting enables consistent operational monitoring and financial reconciliation.

## Recommendations

## 1. Operational Recommendations

- Rebalance doctor workloads across hospitals.
- Increase staffing in high-demand hospitals.
- Monitor long-stay patients to improve bed utilization.
- Strengthen follow-up processes for high-risk patients.

## 2. Financial Recommendations

- Prioritize collection efforts for hospitals with large outstanding balances.
- Investigate records with payments exceeding treatment costs.
- Improve payment reconciliation using standardized reporting views.

## 3. Data Engineering Recommendations

- Automate the ETL process using scheduled SQL jobs or Apache Airflow.
- Implement database constraints and validation rules to improve data quality.
- Add logging and monitoring for future data pipelines.
- Store raw, cleaned, and reporting datasets separately to preserve data lineage.



