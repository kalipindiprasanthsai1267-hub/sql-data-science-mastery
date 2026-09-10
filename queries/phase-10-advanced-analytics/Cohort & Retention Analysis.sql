/*
Q19. Determine the first order month (cohort month)
     for each customer.
*/

SELECT
    Customer_ID,

    DATE_FORMAT(
        MIN(Order_Tms),
        '%Y-%m'
    ) AS Cohort_Month

FROM CO.Orders

GROUP BY Customer_ID

ORDER BY Cohort_Month;


/*
Q20. Calculate the number of customers acquired in each
     cohort month.
*/

WITH Customer_Cohort AS (
    SELECT
        Customer_ID,

        DATE_FORMAT(
            MIN(Order_Tms),
            '%Y-%m'
        ) AS Cohort_Month

    FROM CO.Orders

    GROUP BY Customer_ID
)

SELECT
    Cohort_Month,
    COUNT(*) AS Customers_Acquired

FROM Customer_Cohort

GROUP BY Cohort_Month

ORDER BY Cohort_Month;


/*
Q21. Find customers from each cohort who returned and
     placed another order after their first order.
*/

WITH Customer_First_Order AS (
    SELECT
        Customer_ID,
        MIN(Order_Tms) AS First_Order
    FROM CO.Orders
    GROUP BY Customer_ID
)

SELECT
    c.Customer_ID,

    DATE_FORMAT(
        c.First_Order,
        '%Y-%m'
    ) AS Cohort_Month

FROM Customer_First_Order c

WHERE EXISTS (
    SELECT 1
    FROM CO.Orders o
    WHERE o.Customer_ID = c.Customer_ID
      AND o.Order_Tms > c.First_Order
)

ORDER BY Cohort_Month;


/*
Q22. Calculate the number of days between each customer's
     first order and subsequent orders.
*/

WITH Customer_First_Order AS (
    SELECT
        Customer_ID,
        MIN(Order_Tms) AS First_Order

    FROM CO.Orders

    GROUP BY Customer_ID
)

SELECT
    o.Customer_ID,
    o.Order_Id,
    o.Order_Tms,
    f.First_Order,

    DATEDIFF(
        o.Order_Tms,
        f.First_Order
    ) AS Days_From_First_Order

FROM CO.Orders o

INNER JOIN Customer_First_Order f
    ON o.Customer_ID = f.Customer_ID

ORDER BY
    o.Customer_ID,
    o.Order_Tms;


/*
Q23. Find customers who made their second order within
     30 days of their first order.
*/

WITH Ranked_Orders AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Order_Number

    FROM CO.Orders
),

First_Orders AS (
    SELECT
        Customer_ID,
        Order_Tms AS First_Order

    FROM Ranked_Orders

    WHERE Order_Number = 1
),

Second_Orders AS (
    SELECT
        Customer_ID,
        Order_Tms AS Second_Order

    FROM Ranked_Orders

    WHERE Order_Number = 2
)

SELECT
    f.Customer_ID,
    f.First_Order,
    s.Second_Order,

    DATEDIFF(
        s.Second_Order,
        f.First_Order
    ) AS Days_To_Second_Order

FROM First_Orders f

INNER JOIN Second_Orders s
    ON f.Customer_ID = s.Customer_ID

WHERE DATEDIFF(
          s.Second_Order,
          f.First_Order
      ) <= 30

ORDER BY Days_To_Second_Order;


/*
Q24. Calculate the percentage of customers who placed
     more than one order.
*/

WITH Customer_Order_Count AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Order_Count

    FROM CO.Orders

    GROUP BY Customer_ID
)

SELECT

    COUNT(
        CASE
            WHEN Order_Count > 1
            THEN 1
        END
    ) * 100.0
    / NULLIF(
        COUNT(*),
        0
    ) AS Repeat_Customer_Pct

FROM Customer_Order_Count;
