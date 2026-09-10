# SQL Data Science Mastery

A structured SQL learning and analytics repository documenting my journey from SQL fundamentals to advanced analytical problem-solving.

## About

As a recent graduate aspiring to build a career in Data Science, I created this repository to systematically strengthen my SQL skills through hands-on practice.

The project uses a business/e-commerce style database containing customers, orders, order items, products, stores, inventory, and shipments.

The goal is not only to learn SQL syntax, but also to apply SQL to practical business and analytical problems.

## Project Overview

This repository contains a 10-phase SQL learning journey covering fundamental SQL concepts through advanced analytical techniques.

The progression includes:

- Data retrieval and filtering
- Aggregation and grouping
- Multi-table JOINs
- Subqueries
- Window functions
- Common Table Expressions (CTEs)
- CASE WHEN and business logic
- Date and time analysis
- String functions
- Advanced SQL analytics

## Learning Progress

| Phase | Topic | Status |
|---|---|---|
| Phase 1 | SQL Foundations | ✅ Completed |
| Phase 2 | Aggregations | ✅ Completed |
| Phase 3 | JOINs | ✅ Completed |
| Phase 4 | Subqueries | ✅ Completed |
| Phase 5 | Window Functions | ✅ Completed |
| Phase 6 | Common Table Expressions (CTEs) | ✅ Completed |
| Phase 7 | CASE WHEN & Business Logic | ✅ Completed |
| Phase 8 | Date & Time Functions | ✅ Completed |
| Phase 9 | String Functions | ✅ Completed |
| Phase 10 | Advanced SQL Analytics | ✅ Completed |

## Database

The practice queries use the `CO` database.

### Main Tables

| Table | Description |
|---|---|
| Customers | Customer information |
| Orders | Order-level transaction information |
| Order_Items | Products, quantities and prices associated with orders |
| Products | Product information |
| Stores | Store information |
| Inventory | Inventory records by store and product |
| Shipments | Shipment-related information |

The database structure is available in:

`database/schema.sql`

Sample database data is available in:

`database/data.sql`

The original CSV datasets are available in the `datasets/` directory.

## SQL Skills Demonstrated

### Foundations

- SELECT
- WHERE
- DISTINCT
- ORDER BY
- LIMIT
- LIKE
- BETWEEN
- IN
- NULL handling
- Basic expressions

### Aggregations

- COUNT
- SUM
- AVG
- MIN
- MAX
- GROUP BY
- HAVING

### JOINs

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- CROSS JOIN
- SELF JOIN
- Non-Equi JOINs
- Multi-table JOINs

### Subqueries

- Scalar subqueries
- Nested subqueries
- Correlated subqueries
- Subqueries in SELECT
- Subqueries in FROM
- Subqueries in HAVING
- IN / NOT IN
- EXISTS / NOT EXISTS
- ANY / ALL

### Window Functions

- OVER()
- PARTITION BY
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- NTILE()
- Running totals
- Moving averages
- ROWS BETWEEN
- RANGE BETWEEN
- Multiple window functions

### Common Table Expressions

- Basic CTEs
- Multiple CTEs
- CTEs with WHERE
- CTEs with GROUP BY
- CTEs with window functions
- Multiple/chained CTEs
- Deduplication
- Top-N analysis
- Recursive CTEs

### CASE WHEN & Business Logic

- Customer segmentation
- Revenue classification
- Product performance analysis
- Store analysis
- Conditional aggregation
- Business rule implementation
- CASE WHEN with CTEs
- CASE WHEN with window functions

### Date & Time Functions

- EXTRACT()
- YEAR()
- MONTH()
- DAY()
- QUARTER()
- DATE_FORMAT()
- DATE_ADD()
- DATE_SUB()
- DATEDIFF()
- TIMESTAMPDIFF()
- CAST()
- STR_TO_DATE()
- LAST_DAY()
- Date filtering
- Recency analysis
- MoM analysis
- YoY analysis
- Cohort-style analysis

### String Functions

- UPPER()
- LOWER()
- LENGTH()
- CHAR_LENGTH()
- TRIM()
- REPLACE()
- CONCAT()
- CONCAT_WS()
- LEFT()
- RIGHT()
- SUBSTRING()
- SUBSTRING_INDEX()
- LOCATE()
- INSTR()
- LPAD()
- RPAD()
- REVERSE()
- String cleaning
- Email parsing
- Text-based classification

### Advanced Analytics

- Revenue contribution analysis
- Top-N analysis
- Ranking
- Customer RFM-style analysis
- Cohort analysis
- Retention analysis
- Moving averages
- MoM and YoY comparisons
- Customer purchase behavior
- Gap analysis
- Inventory risk analysis
- Advanced business segmentation

## Example Business Questions

The project explores practical analytical questions such as:

- Which customers generate the highest revenue?
- Which customers are becoming inactive?
- Which products are top performers?
- Which stores generate the most revenue?
- What percentage of revenue comes from the highest-value customers?
- What is the month-over-month revenue growth?
- What is the year-over-year revenue growth?
- Which customers return after their first purchase?
- What is the average gap between customer orders?
- Which products have high sales but low inventory?
- Which stores perform consistently across multiple years?
- How can customers be segmented using business rules?

## Repository Structure

```text
sql-data-science-mastery/
│
├── database/
│   ├── schema.sql
│   └── data.sql
│
├── datasets/
│   ├── customers.csv
│   ├── inventory.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── products.csv
│   ├── shipments.csv
│   └── stores.csv
│
├── queries/
│   ├── phase-01-foundations/
│   ├── phase-02-aggregations/
│   ├── phase-03-joins/
│   ├── phase-04-subqueries/
│   ├── phase-05-window-functions/
│   ├── phase-06-ctes/
│   ├── phase-07-case-when/
│   ├── phase-08-date-time/
│   ├── phase-09-string-functions/
│   └── phase-10-advanced-analytics/
│
├── notes/
├── README.md
└── .gitignore


## How to Run

1. Install MySQL and MySQL Workbench.
2. Create or select the `CO` database.
3. Run `database/schema.sql` to create the database tables.
4. Run `database/data.sql` to load the sample data.
5. Open any SQL file from the `queries/` directory.
6. Execute the queries in MySQL Workbench.

## Tools

- MySQL
- MySQL Workbench
- SQL
- Git
- GitHub

## Current Milestone

All 10 planned SQL learning phases have been completed.

This repository will continue to evolve as I apply SQL skills to larger analytical projects and combine SQL with Python, statistics, data analysis, and machine learning.

## Future Direction

My next focus is to build stronger end-to-end Data Science skills by combining:

**SQL → Python → Statistics → Machine Learning → Data Science Projects**