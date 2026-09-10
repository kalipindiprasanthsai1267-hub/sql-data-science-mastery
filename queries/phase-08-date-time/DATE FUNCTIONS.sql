
/* ============================================================
   SECTION A — CURRENT DATE FUNCTIONS
   ============================================================ */


/*
Q1. Show each order alongside today's date, the current timestamp,
    and the current time.
*/

SELECT Order_Id,
       Order_Tms,
       CURDATE() AS Today,
       NOW() AS Current_Timestamp,
       CURTIME() AS Current_Time
FROM CO.Orders
ORDER BY Order_Id;


/*
Q2. Find all orders placed today. Show order ID, customer ID
    and order timestamp.
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms
FROM CO.Orders
WHERE CAST(Order_Tms AS DATE) = CURDATE()
ORDER BY Order_Tms;


/* Alternative:
SELECT Order_Id,
       Customer_ID,
       Order_Tms
FROM CO.Orders
WHERE DATE(Order_Tms) = CURDATE();
*/


/*
Q3. Show each order alongside the number of days since it was
    placed using CURDATE().
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms,
       DATEDIFF(CURDATE(), Order_Tms) AS Days_Since_Order
FROM CO.Orders
ORDER BY Days_Since_Order DESC;


/*
Q4. Find all orders placed in the last 365 days from today.
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms,
       Order_Status
FROM CO.Orders
WHERE Order_Tms >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY Order_Tms DESC;


/*
Q5. Show the current year, current month number and current
    month name together in a single row.
*/

SELECT YEAR(CURDATE()) AS Current_Year,
       MONTH(CURDATE()) AS Current_Month_Num,
       MONTHNAME(CURDATE()) AS Current_Month_Name,
       QUARTER(CURDATE()) AS Current_Quarter;


/* ============================================================
   SECTION B — EXTRACT AND DATE PART FUNCTIONS
   ============================================================ */


/*
Q6. Extract the year, month, day, hour and minute from every
    order timestamp. Show alongside order ID.
*/

SELECT Order_Id,
       EXTRACT(YEAR FROM Order_Tms) AS Yr,
       EXTRACT(MONTH FROM Order_Tms) AS Mth,
       EXTRACT(DAY FROM Order_Tms) AS Dy,
       EXTRACT(HOUR FROM Order_Tms) AS Hr,
       EXTRACT(MINUTE FROM Order_Tms) AS Min
FROM CO.Orders
ORDER BY Order_Id;


/*
Q7. Count the total number of orders placed in each year.
    Show year and order count ordered by year.
*/

SELECT YEAR(Order_Tms) AS Order_Year,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY YEAR(Order_Tms)
ORDER BY Order_Year;


/*
Q8. Count orders per month across all years.
    Show month number, month name and order count.
*/

SELECT MONTH(Order_Tms) AS Month_Num,
       MONTHNAME(Order_Tms) AS Month_Name,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY MONTH(Order_Tms),
         MONTHNAME(Order_Tms)
ORDER BY Month_Num;


/*
Q9. Find the day of week with the most orders.
    Show day name, day number and order count.
*/

SELECT DAYNAME(Order_Tms) AS Day_Name,
       DAYOFWEEK(Order_Tms) AS Day_Num,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY DAYOFWEEK(Order_Tms),
         DAYNAME(Order_Tms)
ORDER BY Order_Count DESC
FETCH FIRST 1 ROW ONLY;


/*
Q10. Show each order alongside which quarter of the year it was
     placed in. Label Q1 through Q4.
*/

SELECT Order_Id,
       Order_Tms,
       QUARTER(Order_Tms) AS Quarter_Num,
       CONCAT('Q', QUARTER(Order_Tms)) AS Quarter_Label
FROM CO.Orders
ORDER BY Order_Tms;


/*
Q11. Calculate total revenue per quarter per year.
     Show year, quarter and revenue ordered by year and quarter.
*/

SELECT YEAR(o.Order_Tms) AS Yr,
       QUARTER(o.Order_Tms) AS Qtr,
       SUM(oi.Unit_Price * oi.Quantity) AS Quarterly_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY YEAR(o.Order_Tms),
         QUARTER(o.Order_Tms)
ORDER BY Yr, Qtr;


/* ============================================================
   SECTION C — DATE_FORMAT
   ============================================================ */


/*
Q12. Format each order timestamp in three different formats:
     YYYY-MM-DD, DD/MM/YYYY, and Month YYYY.
*/

SELECT Order_Id,
       DATE_FORMAT(Order_Tms, '%Y-%m-%d') AS Format_1,
       DATE_FORMAT(Order_Tms, '%d/%m/%Y') AS Format_2,
       DATE_FORMAT(Order_Tms, '%M %Y') AS Format_3
FROM CO.Orders
ORDER BY Order_Id;


/*
Q13. Show total revenue per month formatted as
     'Jan 2023', 'Feb 2023' etc. Order chronologically.
*/

SELECT DATE_FORMAT(o.Order_Tms, '%b %Y') AS Month_Label,
       DATE_FORMAT(o.Order_Tms, '%Y-%m') AS Sort_Key,
       SUM(oi.Unit_Price * oi.Quantity) AS Monthly_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY DATE_FORMAT(o.Order_Tms, '%b %Y'),
         DATE_FORMAT(o.Order_Tms, '%Y-%m')
ORDER BY Sort_Key;


/*
Q14. Show each order with the day of week formatted as full name
     — Monday, Tuesday etc.
*/

SELECT Order_Id,
       Order_Tms,
       DATE_FORMAT(Order_Tms, '%W') AS Day_Of_Week,
       DATE_FORMAT(Order_Tms, '%W %d %M %Y') AS Full_Date_Label
FROM CO.Orders
ORDER BY Order_Tms;


/*
Q15. Format all order timestamps to show only the time part
     as HH:MM AM/PM format.
*/

SELECT Order_Id,
       DATE_FORMAT(Order_Tms, '%h:%i %p') AS Order_Time_12Hr,
       DATE_FORMAT(Order_Tms, '%H:%i') AS Order_Time_24Hr
FROM CO.Orders
ORDER BY Order_Id;


/*
Q16. Group orders by week number and show week number,
     year and order count.
*/

SELECT YEAR(Order_Tms) AS Yr,
       WEEK(Order_Tms) AS Week_Num,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY YEAR(Order_Tms),
         WEEK(Order_Tms)
ORDER BY Yr, Week_Num;


/* ============================================================
   SECTION D — DATE ARITHMETIC
   ============================================================ */


/*
Q17. For each order show the expected delivery date assuming
     7 days from order timestamp.
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms,
       DATE_ADD(Order_Tms, INTERVAL 7 DAY) AS Expected_Delivery
FROM CO.Orders
ORDER BY Order_Tms;


/*
Q18. Find all orders placed more than 6 months ago.
     Show order ID, timestamp and months ago.
*/

SELECT Order_Id,
       Order_Tms,
       TIMESTAMPDIFF(MONTH, Order_Tms, CURDATE()) AS Months_Ago
FROM CO.Orders
WHERE Order_Tms < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY Order_Tms;


/*
Q19. Show each order alongside the first day and last day
     of the month it was placed in.
*/

SELECT Order_Id,
       Order_Tms,
       DATE_FORMAT(Order_Tms, '%Y-%m-01') AS First_Day_Of_Month,
       LAST_DAY(Order_Tms) AS Last_Day_Of_Month,
       DATEDIFF(
           LAST_DAY(Order_Tms),
           DATE_FORMAT(Order_Tms, '%Y-%m-01')
       ) + 1 AS Days_In_Month
FROM CO.Orders
ORDER BY Order_Tms;


/*
Q20. Calculate the number of months between the earliest and
     most recent order in the database.
*/

SELECT MIN(Order_Tms) AS First_Order,
       MAX(Order_Tms) AS Last_Order,
       TIMESTAMPDIFF(
           MONTH,
           MIN(Order_Tms),
           MAX(Order_Tms)
       ) AS Months_Span,
       DATEDIFF(
           MAX(Order_Tms),
           MIN(Order_Tms)
       ) AS Days_Span
FROM CO.Orders;


/*
Q21. For each customer find their first order date,
     most recent order date and total active months.
*/

SELECT Customer_ID,
       MIN(Order_Tms) AS First_Order,
       MAX(Order_Tms) AS Last_Order,
       TIMESTAMPDIFF(
           MONTH,
           MIN(Order_Tms),
           MAX(Order_Tms)
       ) AS Active_Months,
       COUNT(*) AS Total_Orders
FROM CO.Orders
GROUP BY Customer_ID
ORDER BY Active_Months DESC;


/*
Q22. Find all orders where the order was placed on the
     last day of the month.
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms,
       LAST_DAY(Order_Tms) AS Month_End
FROM CO.Orders
WHERE CAST(Order_Tms AS DATE) = LAST_DAY(Order_Tms)
ORDER BY Order_Tms;


/* ============================================================
   SECTION E — DATEDIFF AND TIMESTAMPDIFF
   ============================================================ */


/*
Q23. Find customers who have not placed any order in the last
     90 days. Show customer ID and days since last order.
*/

SELECT o.Customer_ID,
       MAX(o.Order_Tms) AS Last_Order_Date,
       DATEDIFF(
           CURDATE(),
           MAX(o.Order_Tms)
       ) AS Days_Inactive
FROM CO.Orders o
GROUP BY o.Customer_ID
HAVING DATEDIFF(
           CURDATE(),
           MAX(o.Order_Tms)
       ) > 90
ORDER BY Days_Inactive DESC;


/*
Q24. Calculate the average number of days between consecutive
     orders for each customer using LAG.
*/

WITH Order_Gaps AS (
    SELECT Customer_ID,
           Order_Tms,
           LAG(Order_Tms) OVER (
               PARTITION BY Customer_ID
               ORDER BY Order_Tms
           ) AS Prev_Order
    FROM CO.Orders
)
SELECT Customer_ID,
       ROUND(
           AVG(
               DATEDIFF(Order_Tms, Prev_Order)
           ),
           1
       ) AS Avg_Days_Between_Orders
FROM Order_Gaps
WHERE Prev_Order IS NOT NULL
GROUP BY Customer_ID
ORDER BY Avg_Days_Between_Orders;


/*
Q25. Show total revenue grouped by how many days ago the order
     was placed — 0 to 30, 31 to 90, 91 to 365, over 365.
*/

SELECT
    CASE
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 30
            THEN '0-30 days'
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 90
            THEN '31-90 days'
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 365
            THEN '91-365 days'
        ELSE 'Over 365 days'
    END AS Recency_Bucket,

    COUNT(DISTINCT o.Order_Id) AS Order_Count,

    SUM(
        oi.Unit_Price * oi.Quantity
    ) AS Revenue

FROM CO.Orders o

INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id

GROUP BY
    CASE
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 30
            THEN '0-30 days'
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 90
            THEN '31-90 days'
        WHEN DATEDIFF(CURDATE(), Order_Tms) <= 365
            THEN '91-365 days'
        ELSE 'Over 365 days'
    END

ORDER BY MIN(
    DATEDIFF(CURDATE(), Order_Tms)
);


/*
Q26. Find the order with the longest gap since the previous
     order for each customer.
*/

WITH Order_Gaps AS (
    SELECT Customer_ID,
           Order_Id,
           Order_Tms,
           LAG(Order_Tms) OVER (
               PARTITION BY Customer_ID
               ORDER BY Order_Tms
           ) AS Prev_Order,

           DATEDIFF(
               Order_Tms,
               LAG(Order_Tms) OVER (
                   PARTITION BY Customer_ID
                   ORDER BY Order_Tms
               )
           ) AS Days_Gap

    FROM CO.Orders
),

Max_Gaps AS (
    SELECT Customer_ID,
           MAX(Days_Gap) AS Longest_Gap
    FROM Order_Gaps
    WHERE Days_Gap IS NOT NULL
    GROUP BY Customer_ID
)

SELECT og.Customer_ID,
       og.Order_Id,
       og.Order_Tms,
       og.Prev_Order,
       og.Days_Gap
FROM Order_Gaps og
INNER JOIN Max_Gaps mg
    ON og.Customer_ID = mg.Customer_ID
   AND og.Days_Gap = mg.Longest_Gap
ORDER BY og.Days_Gap DESC;


/*
Q27. Calculate year over year revenue growth percentage.
     Show year, revenue and growth percentage.
*/

WITH Yearly_Revenue AS (
    SELECT YEAR(o.Order_Tms) AS Yr,
           SUM(
               oi.Unit_Price * oi.Quantity
           ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY YEAR(o.Order_Tms)
)

SELECT Yr,
       Revenue,

       LAG(Revenue) OVER (
           ORDER BY Yr
       ) AS Prev_Year_Revenue,

       ROUND(
           (
               Revenue
               - LAG(Revenue) OVER (ORDER BY Yr)
           )
           * 100.0
           /
           LAG(Revenue) OVER (ORDER BY Yr),
           2
       ) AS YoY_Growth_Pct

FROM Yearly_Revenue
ORDER BY Yr;


/* ============================================================
   SECTION F — DATE FILTERING PATTERNS
   ============================================================ */


/*
Q28. Find all orders placed in Q1 of any year —
     January, February and March.
     Show order ID and timestamp.
*/

SELECT Order_Id,
       Customer_ID,
       Order_Tms,
       QUARTER(Order_Tms) AS Quarter
FROM CO.Orders
WHERE QUARTER(Order_Tms) = 1
ORDER BY Order_Tms;


/*
Q29. Find all orders placed on weekends —
     Saturday and Sunday.
     Show order ID, day name and timestamp.
*/

SELECT Order_Id,
       Order_Tms,
       DAYNAME(Order_Tms) AS Day_Name
FROM CO.Orders
WHERE DAYOFWEEK(Order_Tms) IN (1, 7)
ORDER BY DAYOFWEEK(Order_Tms),
         Order_Tms;


/*
Q30. Find all orders placed between 2022-06-01 and 2023-05-31
     inclusive. Show count and total revenue.
*/

SELECT COUNT(DISTINCT o.Order_Id) AS Order_Count,
       SUM(
           oi.Unit_Price * oi.Quantity
       ) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
WHERE o.Order_Tms
      BETWEEN '2022-06-01'
          AND '2023-05-31 23:59:59';


/*
Q31. Find the month in 2023 with the highest number of orders.
*/

SELECT MONTH(Order_Tms) AS Mth,
       MONTHNAME(Order_Tms) AS Month_Name,
       COUNT(*) AS Order_Count
FROM CO.Orders
WHERE YEAR(Order_Tms) = 2023
GROUP BY MONTH(Order_Tms),
         MONTHNAME(Order_Tms)
ORDER BY Order_Count DESC
FETCH FIRST 1 ROW ONLY;


/*
Q32. Show order count and revenue for each hour of the day
     across all orders. Show hour 0 through 23.
*/

SELECT HOUR(Order_Tms) AS Hour_Of_Day,
       COUNT(DISTINCT o.Order_Id) AS Order_Count,
       SUM(
           oi.Unit_Price * oi.Quantity
       ) AS Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY HOUR(Order_Tms)
ORDER BY Hour_Of_Day;


/* ============================================================
   SECTION G — ADVANCED DATE PATTERNS
   ============================================================ */


/*
Q33. Calculate month over month revenue for 2023 showing:
     month, revenue, previous month revenue and percentage change.
*/

WITH Monthly_Revenue AS (
    SELECT DATE_FORMAT(
               o.Order_Tms,
               '%Y-%m'
           ) AS Month,

           SUM(
               oi.Unit_Price * oi.Quantity
           ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    WHERE YEAR(o.Order_Tms) = 2023

    GROUP BY DATE_FORMAT(
                 o.Order_Tms,
                 '%Y-%m'
             )
)

SELECT Month,
       Revenue,

       LAG(Revenue) OVER (
           ORDER BY Month
       ) AS Prev_Month,

       ROUND(
           (
               Revenue
               - LAG(Revenue) OVER (ORDER BY Month)
           )
           * 100.0
           /
           LAG(Revenue) OVER (ORDER BY Month),
           2
       ) AS MoM_Change_Pct

FROM Monthly_Revenue
ORDER BY Month;


/*
Q34. Find all customers whose first order was in 2022 and who
     also placed orders in 2023 — retained customers.
*/

WITH First_Order_Year AS (
    SELECT Customer_ID,
           YEAR(MIN(Order_Tms)) AS First_Year
    FROM CO.Orders
    GROUP BY Customer_ID
),

Orders_2023 AS (
    SELECT DISTINCT Customer_ID
    FROM CO.Orders
    WHERE YEAR(Order_Tms) = 2023
)

SELECT c.Full_Name,
       foy.Customer_ID,
       foy.First_Year
FROM First_Order_Year foy

INNER JOIN Orders_2023 o23
    ON foy.Customer_ID = o23.Customer_ID

INNER JOIN CO.Customers c
    ON foy.Customer_ID = c.Customer_ID

WHERE foy.First_Year = 2022
ORDER BY c.Full_Name;


/*
Q35. Show a daily revenue trend for 2023 — one row per day
     with date, revenue and 7-day moving average.
*/

WITH Daily_Revenue AS (
    SELECT CAST(
               o.Order_Tms AS DATE
           ) AS Order_Date,

           SUM(
               oi.Unit_Price * oi.Quantity
           ) AS Daily_Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    WHERE YEAR(o.Order_Tms) = 2023

    GROUP BY CAST(
                 o.Order_Tms AS DATE
             )
)

SELECT Order_Date,
       Daily_Revenue,

       ROUND(
           AVG(Daily_Revenue) OVER (
               ORDER BY Order_Date
               ROWS BETWEEN 6 PRECEDING
                        AND CURRENT ROW
           ),
           2
       ) AS Moving_Avg_7Day

FROM Daily_Revenue
ORDER BY Order_Date;


/*
Q36. For each customer show their order history with cumulative
     days active — days from their first order to each subsequent order.
*/

SELECT Customer_ID,
       Order_Id,
       Order_Tms,

       MIN(Order_Tms) OVER (
           PARTITION BY Customer_ID
       ) AS First_Order,

       DATEDIFF(
           Order_Tms,
           MIN(Order_Tms) OVER (
               PARTITION BY Customer_ID
           )
       ) AS Days_Since_First_Order

FROM CO.Orders
ORDER BY Customer_ID,
         Order_Tms;


/*
Q37. Find stores that had at least one order in every month of 2023.
*/

WITH Store_Monthly AS (
    SELECT Store_Id,
           MONTH(Order_Tms) AS Mth
    FROM CO.Orders
    WHERE YEAR(Order_Tms) = 2023
    GROUP BY Store_Id,
             MONTH(Order_Tms)
),

Store_Month_Count AS (
    SELECT Store_Id,
           COUNT(DISTINCT Mth) AS Active_Months
    FROM Store_Monthly
    GROUP BY Store_Id
)

SELECT s.Store_Name,
       smc.Active_Months

FROM Store_Month_Count smc

INNER JOIN CO.Stores s
    ON smc.Store_Id = s.Store_Id

WHERE smc.Active_Months = 12
ORDER BY s.Store_Name;


/*
Q38. Calculate a running total of orders placed over time per store.
     Show store ID, order date and cumulative order count.
*/

SELECT o.Store_Id,
       CAST(o.Order_Tms AS DATE) AS Order_Date,

       COUNT(*) OVER (
           PARTITION BY o.Store_Id
           ORDER BY CAST(o.Order_Tms AS DATE)
           ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
       ) AS Cumulative_Order_Count

FROM CO.Orders o
ORDER BY o.Store_Id,
         Order_Date;


/* ============================================================
   SECTION H — CAST, STR_TO_DATE AND TYPE CONVERSION
   ============================================================ */


/*
Q39. Show each order with the date part only —
     strip the time component from Order_Tms.
*/

SELECT Order_Id,
       Order_Tms,
       CAST(Order_Tms AS DATE) AS Order_Date,
       DATE(Order_Tms) AS Order_Date_Alt
FROM CO.Orders
ORDER BY Order_Id;


/*
Q40. Convert these string values to proper dates and show them:
     '15/03/2023', '2023-Sep-20', '03-15-2023'.
*/

SELECT
    STR_TO_DATE(
        '15/03/2023',
        '%d/%m/%Y'
    ) AS Date_1,

    STR_TO_DATE(
        '2023-Sep-20',
        '%Y-%b-%d'
    ) AS Date_2,

    STR_TO_DATE(
        '03-15-2023',
        '%m-%d-%Y'
    ) AS Date_3;


/*
Q41. Show each order's timestamp as a Unix timestamp and
     convert it back to confirm.
*/

SELECT Order_Id,
       Order_Tms,

       UNIX_TIMESTAMP(Order_Tms) AS Unix_Ts,

       FROM_UNIXTIME(
           UNIX_TIMESTAMP(Order_Tms)
       ) AS Converted_Back

FROM CO.Orders
ORDER BY Order_Id;


/*
Q42. Group orders by date only and count per day —
     show how CAST affects grouping compared to using
     the raw timestamp.
*/


/* Without CAST — groups by exact timestamp */
SELECT Order_Tms,
       COUNT(*) AS Count_By_Timestamp
FROM CO.Orders
GROUP BY Order_Tms
ORDER BY Order_Tms
FETCH FIRST 5 ROWS ONLY;


/* With CAST — groups by date only */
SELECT CAST(Order_Tms AS DATE) AS Order_Date,
       COUNT(*) AS Count_By_Date
FROM CO.Orders
GROUP BY CAST(Order_Tms AS DATE)
ORDER BY Order_Date;


/* ============================================================
   SECTION I — INTERVIEW THEORY QUESTIONS
   ============================================================ */


/*
Q43. What is the difference between DATEDIFF and TIMESTAMPDIFF?
     When would you use each?
*/


/* DATEDIFF — always returns difference in DAYS */

SELECT DATEDIFF(
    '2023-12-31',
    '2023-01-01'
);


/* TIMESTAMPDIFF — returns difference in any unit */

SELECT TIMESTAMPDIFF(
    MONTH,
    '2023-01-01',
    '2023-12-31'
);


SELECT TIMESTAMPDIFF(
    YEAR,
    '2000-05-15',
    '2023-09-15'
);


SELECT TIMESTAMPDIFF(
    HOUR,
    '2023-01-01 00:00',
    '2023-01-02 06:00'
);


/*
Answer:

DATEDIFF is used when you need the difference in days.

TIMESTAMPDIFF is used when you need the difference in
months, years, hours, minutes, etc.
*/


/*
Q44. What is the performance difference between
     WHERE YEAR(col) = 2023 and WHERE col BETWEEN dates?
     Which is better?
*/


/* Function wraps the column */
SELECT *
FROM CO.Orders
WHERE YEAR(Order_Tms) = 2023;


/* Range comparison */
SELECT *
FROM CO.Orders
WHERE Order_Tms >= '2023-01-01'
  AND Order_Tms < '2024-01-01';


/* Alternative using BETWEEN */
SELECT *
FROM CO.Orders
WHERE Order_Tms
      BETWEEN '2023-01-01'
          AND '2023-12-31 23:59:59';


/*
Answer:

Using a range comparison directly on the date column is preferred
for index-friendly filtering.

Wrapping the column in YEAR() can prevent efficient use of an
index on that column.
*/


/*
Q45. How do you handle NULL dates in calculations?
     Show what happens and how to fix it.
*/


/* NULL date calculations return NULL */

SELECT DATEDIFF(
    CURDATE(),
    NULL
);


SELECT DATE_ADD(
    NULL,
    INTERVAL 7 DAY
);


/* Fix using COALESCE */

SELECT Order_Id,

       COALESCE(
           CAST(Order_Tms AS DATE),
           '1900-01-01'
       ) AS Safe_Date,

       DATEDIFF(
           CURDATE(),
           COALESCE(
               Order_Tms,
               CURDATE()
           )
       ) AS Days_Since

FROM CO.Orders;


/* Fix using IFNULL */

SELECT DATEDIFF(
           CURDATE(),
           IFNULL(
               Order_Tms,
               CURDATE()
           )
       ) AS Days_Since
FROM CO.Orders;


/* Filter out NULLs before calculating */

SELECT AVG(
           DATEDIFF(
               CURDATE(),
               Order_Tms
           )
       ) AS Avg_Days
FROM CO.Orders
WHERE Order_Tms IS NOT NULL;


/*
Answer:

NULL dates propagate through date calculations and result in NULL.

You can handle NULLs using:

1. COALESCE()
2. IFNULL()
3. WHERE ... IS NOT NULL
*/
