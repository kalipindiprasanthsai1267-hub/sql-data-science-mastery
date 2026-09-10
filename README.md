\# SQL Data Science Mastery



A structured SQL learning and practice repository documenting my journey from SQL fundamentals to advanced analytical problem-solving.



\## About



As a recent graduate aspiring to build a career in Data Science, I am strengthening my SQL skills through structured, hands-on practice.



This repository contains SQL exercises covering data retrieval, filtering, aggregations, multi-table analysis, subqueries, window functions, CTEs, conditional logic, and date/time analysis.



The goal is not only to learn SQL syntax, but also to apply SQL to practical business and analytical questions.



\## Learning Progress



| Phase | Topic | Status |

|------|------|------|

| Phase 1 | SQL Foundations | ✅ Completed |

| Phase 2 | Aggregations | ✅ Completed |

| Phase 3 | JOINs | ✅ Completed |

| Phase 4 | Subqueries | ✅ Completed |

| Phase 5 | Window Functions | ✅ Completed |

| Phase 6 | Common Table Expressions (CTEs) | ✅ Completed |

| Phase 7 | CASE WHEN \& Business Logic | ✅ Completed |

| Phase 8 | Date \& Time Functions | ✅ Completed |

| Phase 9 | String Functions | 🔄 Pending |

| Phase 10 | Advanced Analytics | 🔄 Pending |



\## Database



The practice queries use the `CO` database and work with tables including:



\- Customers

\- Orders

\- Order\_Items

\- Products

\- Stores

\- Inventory

\- Shipments



The database structure and sample data are included in the `database/` directory.



\## SQL Topics Covered



\### Foundations

\- SELECT

\- WHERE

\- DISTINCT

\- ORDER BY

\- LIMIT

\- LIKE

\- BETWEEN

\- IN

\- NULL handling

\- Basic expressions



\### Aggregations

\- COUNT

\- SUM

\- AVG

\- MIN

\- MAX

\- GROUP BY

\- HAVING



\### JOINs

\- INNER JOIN

\- LEFT JOIN

\- RIGHT JOIN

\- CROSS JOIN

\- SELF JOIN

\- Non-Equi JOINs

\- Multi-table JOINs



\### Subqueries

\- Scalar subqueries

\- Subqueries in WHERE

\- Subqueries in SELECT

\- Subqueries in FROM

\- Subqueries in HAVING

\- IN / NOT IN

\- EXISTS / NOT EXISTS

\- ANY / ALL

\- Correlated subqueries

\- Nested subqueries



\### Window Functions

\- OVER()

\- PARTITION BY

\- ROW\_NUMBER()

\- RANK()

\- DENSE\_RANK()

\- LAG()

\- LEAD()

\- NTILE()

\- Running totals

\- Moving averages

\- ROWS BETWEEN

\- RANGE BETWEEN

\- Multiple window functions



\### CTEs

\- Basic CTEs

\- Multiple CTEs

\- CTEs with filtering

\- CTEs with GROUP BY

\- CTEs with window functions

\- Chained CTEs

\- Deduplication

\- Top-N analysis

\- Recursive CTEs

\- Business-oriented analytical queries



\### CASE WHEN \& Business Logic

\- Customer classification

\- Revenue segmentation

\- Product performance analysis

\- Store analysis

\- Conditional aggregation

\- CASE WHEN with CTEs

\- CASE WHEN with window functions



\### Date \& Time Analysis

\- CURDATE()

\- NOW()

\- EXTRACT()

\- YEAR()

\- MONTH()

\- DAY()

\- QUARTER()

\- DATE\_FORMAT()

\- DATE\_ADD()

\- DATE\_SUB()

\- DATEDIFF()

\- TIMESTAMPDIFF()

\- CAST()

\- STR\_TO\_DATE()

\- LAST\_DAY()

\- Date filtering

\- Month-over-month analysis

\- Year-over-year analysis

\- Recency analysis

\- Cohort-style analysis

\- Moving averages



\## Example Business Questions



Some of the analytical questions explored in this repository include:



\- Which customers generate the most revenue?

\- Which products perform above or below average?

\- Which stores have high sales activity?

\- Which customers may be becoming inactive?

\- What is the revenue trend over time?

\- What is the month-over-month revenue change?

\- What is the year-over-year revenue growth?

\- Which stores are active across all months?

\- What is the average gap between customer orders?

\- How can customers and products be segmented using business rules?



\## Repository Structure



```text

sql-data-science-mastery/

│

├── database/

│   ├── schema.sql

│   └── data.sql

│

├── datasets/

│

├── notes/

│

├── queries/

│   ├── phase-01-foundations/

│   ├── phase-02-aggregations/

│   ├── phase-03-joins/

│   ├── phase-04-subqueries/

│   ├── phase-05-window-functions/

│   ├── phase-06-ctes/

│   ├── phase-07-case-when/

│   └── phase-08-date-time/

│

└── README.md

