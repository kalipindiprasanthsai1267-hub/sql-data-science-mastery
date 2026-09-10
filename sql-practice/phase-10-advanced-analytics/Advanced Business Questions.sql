/*
Q41. Find customers who generated revenue in every calendar
     year present in the Orders table.
*/

WITH Customer_Year AS (
    SELECT DISTINCT
        Customer_ID,
        YEAR(Order_Tms) AS Yr
    FROM CO.Orders
),

Total_Years AS (
    SELECT
        COUNT(
            DISTINCT YEAR(Order_Tms)
        ) AS Year_Count
    FROM CO.Orders
)

SELECT
    cy.Customer_ID,
    COUNT(
        DISTINCT cy.Yr
    ) AS Active_Years

FROM Customer_Year cy

GROUP BY cy.Customer_ID

HAVING COUNT(
           DISTINCT cy.Yr
       ) = (
           SELECT Year_Count
           FROM Total_Years
       )

ORDER BY cy.Customer_ID;


/*
Q42. Find customers who generated more revenue in their
     most recent year than in their first year.
*/

WITH Customer_Year_Revenue AS (
    SELECT
        Customer_ID,
        YEAR(Order_Tms) AS Yr,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        Customer_ID,
        YEAR(Order_Tms)
),

Customer_Year_Ranks AS (
    SELECT
        Customer_ID,
        Yr,
        Revenue,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Yr
        ) AS First_Year_Rank,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Yr DESC
        ) AS Latest_Year_Rank

    FROM Customer_Year_Revenue
),

Customer_Comparison AS (
    SELECT
        Customer_ID,

        MAX(
            CASE
                WHEN First_Year_Rank = 1
                    THEN Revenue
            END
        ) AS First_Year_Revenue,

        MAX(
            CASE
                WHEN Latest_Year_Rank = 1
                    THEN Revenue
            END
        ) AS Latest_Year_Revenue

    FROM Customer_Year_Ranks

    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    First_Year_Revenue,
    Latest_Year_Revenue

FROM Customer_Comparison

WHERE Latest_Year_Revenue >
      First_Year_Revenue

ORDER BY
    Latest_Year_Revenue -
    First_Year_Revenue DESC;


/*
Q43. Find stores whose revenue increased every year
     compared with the previous year.

     Example:

     2021 < 2022 < 2023
*/

WITH Store_Year_Revenue AS (
    SELECT
        Store_Id,
        YEAR(Order_Tms) AS Yr,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        Store_Id,
        YEAR(Order_Tms)
),

Store_Changes AS (
    SELECT
        Store_Id,
        Yr,
        Revenue,

        LAG(Revenue) OVER (
            PARTITION BY Store_Id
            ORDER BY Yr
        ) AS Previous_Revenue

    FROM Store_Year_Revenue
),

Store_Summary AS (
    SELECT
        Store_Id,

        SUM(
            CASE
                WHEN Previous_Revenue IS NOT NULL
                     AND Revenue > Previous_Revenue
                    THEN 1
                ELSE 0
            END
        ) AS Increasing_Years,

        COUNT(
            CASE
                WHEN Previous_Revenue IS NOT NULL
                THEN 1
            END
        ) AS Comparable_Years

    FROM Store_Changes

    GROUP BY Store_Id
)

SELECT
    Store_Id,
    Increasing_Years,
    Comparable_Years

FROM Store_Summary

WHERE Increasing_Years =
      Comparable_Years

ORDER BY Store_Id;


/*
Q44. Find the top 20% of customers by total revenue and
     classify everyone else as the remaining 80%.
*/

WITH Customer_Revenue AS (
    SELECT
        Customer_ID,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY Customer_ID
),

Customer_Quartiles AS (
    SELECT
        Customer_ID,
        Revenue,

        NTILE(5) OVER (
            ORDER BY Revenue DESC
        ) AS Revenue_Group

    FROM Customer_Revenue
)

SELECT
    Customer_ID,
    Revenue,

    CASE
        WHEN Revenue_Group = 1
            THEN 'Top 20%'

        ELSE 'Remaining 80%'

    END AS Revenue_Segment

FROM Customer_Quartiles

ORDER BY Revenue DESC;


/*
Q45. Create an executive customer segmentation report containing:

     Customer ID
     Customer Name
     Total Orders
     Total Revenue
     Last Order Date
     Days Inactive
     Average Order Value
     Customer Rank
     Revenue Segment

     Revenue Segment:
       Top 10%
       Top 25%
       Middle 50%
       Bottom 25%
*/

WITH Order_Values AS (
    SELECT
        o.Order_Id,
        o.Customer_ID,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Order_Value

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Order_Id,
        o.Customer_ID
),

Customer_Metrics AS (
    SELECT
        Customer_ID,

        COUNT(*) AS Total_Orders,

        SUM(
            Order_Value
        ) AS Total_Revenue,

        MAX(
            Order_Id
        ) AS Latest_Order_Id,

        AVG(
            Order_Value
        ) AS Average_Order_Value

    FROM Order_Values

    GROUP BY Customer_ID
),

Latest_Order AS (
    SELECT
        o.Customer_ID,
        o.Order_Tms,

        ROW_NUMBER() OVER (
            PARTITION BY o.Customer_ID
            ORDER BY o.Order_Tms DESC
        ) AS rn

    FROM CO.Orders o
),

Customer_Final AS (
    SELECT
        cm.Customer_ID,
        cm.Total_Orders,
        cm.Total_Revenue,
        cm.Average_Order_Value,
        lo.Order_Tms AS Last_Order_Date,

        DATEDIFF(
            CURDATE(),
            lo.Order_Tms
        ) AS Days_Inactive,

        RANK() OVER (
            ORDER BY cm.Total_Revenue DESC
        ) AS Customer_Rank,

        NTILE(4) OVER (
            ORDER BY cm.Total_Revenue DESC
        ) AS Revenue_Quartile,

        COUNT(*) OVER () AS Total_Customers

    FROM Customer_Metrics cm

    INNER JOIN Latest_Order lo
        ON cm.Customer_ID = lo.Customer_ID
       AND lo.rn = 1
)

SELECT
    cf.Customer_ID,
    c.Full_Name AS Customer_Name,

    cf.Total_Orders,

    ROUND(
        cf.Total_Revenue,
        2
    ) AS Total_Revenue,

    cf.Last_Order_Date,

    cf.Days_Inactive,

    ROUND(
        cf.Average_Order_Value,
        2
    ) AS Average_Order_Value,

    cf.Customer_Rank,

    CASE

        WHEN cf.Customer_Rank <=
             CEIL(
                 cf.Total_Customers * 0.10
             )
            THEN 'Top 10%'

        WHEN cf.Revenue_Quartile = 1
            THEN 'Top 25%'

        WHEN cf.Revenue_Quartile IN (2, 3)
            THEN 'Middle 50%'

        ELSE 'Bottom 25%'

    END AS Revenue_Segment

FROM Customer_Final cf

INNER JOIN CO.Customers c
    ON cf.Customer_ID = c.Customer_ID

ORDER BY cf.Customer_Rank;
