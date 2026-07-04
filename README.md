# SQL-End-to-End-Data-Project
This repository showcase how I used SQL to work on Health Dataset. The dataset contains patient records from different hospitals in Kenya.

# Problem Statement

A healthcare organization wants to move from spreadsheet-based reporting to database-driven reporting. The organization has patient records from different hospitals, but the data is dirty and inconsistent.

The organization wants to understand hospital workload, county-level service demand, doctor workload, treatment cost distribution, payment gaps, and follow-up pressure.

In this project, I used SQL to clean the data and answer important operational questions.

## Objectives
- Import raw healthcare data into SQL.
- Preserve original data source.
- Create a cleaned  reporting dataset.
- Build a reusable SQL queries.
- Create a reporting views.
- Support operational and financial decision-making.

## Tools
- PostgreSQL
- SQL
- Github

## Database Design
The project follows a staging approach.

      CSV

        ↓

    raw_patient_records

        ↓

    clean_patient_records

        ↓

    Reporting Views

This approach protects raw data while enabling repeatable cleaning and reporting.
