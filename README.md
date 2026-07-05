# SQL-End-to-End-Data-Project
This repository showcase how I used SQL to work on Health Dataset. The dataset contains patient records from different hospitals in Kenya.

# 1. Problem Statement

A healthcare organization wants to move from spreadsheet-based reporting to database-driven reporting. The organization has patient records from different hospitals, but the data is dirty and inconsistent.

The organization wants to understand hospital workload, county-level service demand, doctor workload, treatment cost distribution, payment gaps, and follow-up pressure.

In this project, I used SQL to clean the data and answer important operational questions.

## 2. Objectives
- Import raw healthcare data into SQL.
- Preserve original data source.
- Create a cleaned  reporting dataset.
- Build a reusable SQL queries.
- Create a reporting views.
- Support operational and financial decision-making.

## 3. Tools
- PostgreSQL
- SQL
- Github

## 4. Database Design
The project follows a staging approach.

      CSV

        ↓

    raw_patient_records

        ↓

    clean_patient_records

        ↓

    Reporting Views

This approach protects raw data while enabling repeatable cleaning and reporting.

## 5. Data Loading

The raw healthcare dataset was imported into a PostgreSQL database named `healthcare_operations`.

A staging table called `raw_patient_records` was created to preserve the original CSV without modifications.

### Import Summary

| Metric | Value |
|---------|------:|
| Database | healthcare_operations |
| Table | raw_patient_records |
| Total Records Imported | 6,400 |

The raw table serves as the source for all subsequent validation, cleaning, transformation and reporting tasks.

---

## 6. Data Validation

Before cleaning the dataset, SQL validation queries were executed to assess data quality.

The validation process focuses on:

- Missing patient identifiers
- Missing hospital names
- Missing county names
- Missing doctor identifiers
- Duplicate patient records
- Invalid numeric values
- Invalid dates
- Records requiring manual review

This approach ensures that data quality issues are identified before any transformations are applied.
