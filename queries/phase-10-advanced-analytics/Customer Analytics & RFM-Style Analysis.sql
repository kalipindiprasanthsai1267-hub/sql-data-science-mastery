
/*
Q13. Build a customer RFM-style table containing:

     Recency  = days since last order
     Frequency = number of orders
     Monetary = total revenue
*/

WITH Customer_RFM AS (
    SELECT
        o.Customer_ID,

        DATEDIFF(
            CURDATE(),
            MAX(o.Order_Tms)
        ) AS Recency,

        COUNT(
            DISTINCT o.Order_Id
        ) AS Frequency,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Monetary

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY o.Customer_ID
)

SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary

FROM Customer_RFM

ORDER BY Monetary DESC;


/*
Q14. Assign customers an RFM score from 1 to 5 based on
     recency, frequency and monetary value using NTILE().
*/

WITH Customer_RFM AS (
    SELECT
        o.Customer_ID,

        DATEDIFF(
            CURDATE(),
            MAX(o.Order_Tms)
        ) AS Recency,

        COUNT(
            DISTINCT o.Order_Id
        ) AS Frequency,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Monetary

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY o.Customer_ID
)

SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary,

    NTILE(5) OVER (
        ORDER BY Recency DESC
    ) AS Recency_Score,

    NTILE(5) OVER (
        ORDER BY Frequency
    ) AS Frequency_Score,

    NTILE(5) OVER (
        ORDER BY Monetary
    ) AS Monetary_Score

FROM Customer_RFM;


/*
Q15. Classify customers into:

     Champions
     Loyal Customers
     At Risk
     Lost Customers

     using recency and frequency.
*/

WITH Customer_Metrics AS (
    SELECT
        Customer_ID,

        DATEDIFF(
            CURDATE(),
            MAX(Order_Tms)
        ) AS Days_Inactive,

        COUNT(*) AS Order_Count

    FROM CO.Orders

    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Days_Inactive,
    Order_Count,

    CASE
        WHEN Days_Inactive <= 30
             AND Order_Count >= 5
            THEN 'Champions'

        WHEN Days_Inactive <= 60
             AND Order_Count >= 3
            THEN 'Loyal Customers'

        WHEN Days_Inactive > 60
             AND Days_Inactive <= 180
            THEN 'At Risk'

        ELSE 'Lost Customers'
    END AS Customer_Segment

FROM Customer_Metrics

ORDER BY Days_Inactive;


/*
Q16. Find customers whose latest order value is greater than
     their average order value.
*/

WITH Customer_Order_Value AS (
    SELECT
        o.Customer_ID,
        o.Order_Id,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Order_Value

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Customer_ID,
        o.Order_Id
),

Customer_Averages AS (
    SELECT
        Customer_ID,
        AVG(Order_Value) AS Avg_Order_Value

    FROM Customer_Order_Value

    GROUP BY Customer_ID
),

Latest_Order AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Value,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Id DESC
        ) AS rn

    FROM Customer_Order_Value
)

SELECT
    l.Customer_ID,
    l.Order_Id,
    l.Order_Value,
    a.Avg_Order_Value

FROM Latest_Order l

INNER JOIN Customer_Averages a
    ON l.Customer_ID = a.Customer_ID

WHERE l.rn = 1
  AND l.Order_Value > a.Avg_Order_Value;


/*
Q17. Find customers who have placed at least one order in
     three different calendar years.
*/

SELECT
    Customer_ID,

    COUNT(
        DISTINCT YEAR(Order_Tms)
    ) AS Active_Years

FROM CO.Orders

GROUP BY Customer_ID

HAVING COUNT(
           DISTINCT YEAR(Order_Tms)
       ) >= 3

ORDER BY Active_Years DESC;


/*
Q18. Find customers whose latest order was also their
     highest-value order.
*/

WITH Customer_Orders AS (
    SELECT
        o.Customer_ID,
        o.Order_Id,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Order_Value

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Customer_ID,
        o.Order_Id
),

Latest_Order AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Value,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Id DESC
        ) AS Latest_Rank

    FROM Customer_Orders
),

Highest_Order AS (
    SELECT
        Customer_ID,

        MAX(
            Order_Value
        ) AS Highest_Order_Value

    FROM Customer_Orders

    GROUP BY Customer_ID
)

SELECT
    l.Customer_ID,
    l.Order_Id,
    l.Order_Value

FROM Latest_Order l

INNER JOIN Highest_Order h
    ON l.Customer_ID = h.Customer_ID

WHERE l.Latest_Rank = 1
  AND l.Order_Value = h.Highest_Order_Value;

