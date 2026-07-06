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

