/*
Q25. Calculate monthly revenue with a 3-month moving average.
*/

WITH Monthly_Revenue AS (
    SELECT
        DATE_FORMAT(
            o.Order_Tms,
            '%Y-%m'
        ) AS Month,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY DATE_FORMAT(
                 o.Order_Tms,
                 '%Y-%m'
             )
)

SELECT
    Month,
    Revenue,

    ROUND(
        AVG(Revenue) OVER (
            ORDER BY Month
            ROWS BETWEEN 2 PRECEDING
                     AND CURRENT ROW
        ),
        2
    ) AS Moving_Avg_3Month

FROM Monthly_Revenue

ORDER BY Month;


/*
Q26. Calculate monthly revenue and compare it with the
     previous month.
*/

WITH Monthly_Revenue AS (
    SELECT
        DATE_FORMAT(
            o.Order_Tms,
            '%Y-%m'
        ) AS Month,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY DATE_FORMAT(
                 o.Order_Tms,
                 '%Y-%m'
             )
)

SELECT
    Month,
    Revenue,

    LAG(Revenue) OVER (
        ORDER BY Month
    ) AS Previous_Month_Revenue,

    Revenue
    - LAG(Revenue) OVER (
        ORDER BY Month
      ) AS Revenue_Change

FROM Monthly_Revenue

ORDER BY Month;


/*
Q27. Calculate the percentage change in revenue month over month.
*/

WITH Monthly_Revenue AS (
    SELECT
        DATE_FORMAT(
            o.Order_Tms,
            '%Y-%m'
        ) AS Month,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY DATE_FORMAT(
                 o.Order_Tms,
                 '%Y-%m'
             )
),

Monthly_Comparison AS (
    SELECT
        Month,
        Revenue,

        LAG(Revenue) OVER (
            ORDER BY Month
        ) AS Previous_Revenue

    FROM Monthly_Revenue
)

SELECT
    Month,
    Revenue,
    Previous_Revenue,

    ROUND(
        (
            Revenue - Previous_Revenue
        ) * 100.0
        / NULLIF(
            Previous_Revenue,
            0
        ),
        2
    ) AS MoM_Growth_Pct

FROM Monthly_Comparison

ORDER BY Month;


/*
Q28. Calculate yearly revenue and year-over-year growth.
*/

WITH Yearly_Revenue AS (
    SELECT
        YEAR(o.Order_Tms) AS Yr,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY YEAR(o.Order_Tms)
),

Yearly_Comparison AS (
    SELECT
        Yr,
        Revenue,

        LAG(Revenue) OVER (
            ORDER BY Yr
        ) AS Previous_Revenue

    FROM Yearly_Revenue
)

SELECT
    Yr,
    Revenue,
    Previous_Revenue,

    ROUND(
        (
            Revenue - Previous_Revenue
        ) * 100.0
        / NULLIF(
            Previous_Revenue,
            0
        ),
        2
    ) AS YoY_Growth_Pct

FROM Yearly_Comparison

ORDER BY Yr;


/*
Q29. Find the month with the highest revenue in each year.
*/

WITH Monthly_Revenue AS (
    SELECT
        YEAR(o.Order_Tms) AS Yr,
        MONTH(o.Order_Tms) AS Mth,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        YEAR(o.Order_Tms),
        MONTH(o.Order_Tms)
),

Ranked_Months AS (
    SELECT
        Yr,
        Mth,
        Revenue,

        ROW_NUMBER() OVER (
            PARTITION BY Yr
            ORDER BY Revenue DESC
        ) AS Revenue_Rank

    FROM Monthly_Revenue
)

SELECT
    Yr,
    Mth,
    Revenue

FROM Ranked_Months

WHERE Revenue_Rank = 1

ORDER BY Yr;


/*
Q30. Find the best-performing day of each month based on revenue.
*/

WITH Daily_Revenue AS (
    SELECT
        DATE(o.Order_Tms) AS Order_Date,
        YEAR(o.Order_Tms) AS Yr,
        MONTH(o.Order_Tms) AS Mth,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        DATE(o.Order_Tms),
        YEAR(o.Order_Tms),
        MONTH(o.Order_Tms)
),

Ranked_Days AS (
    SELECT
        Order_Date,
        Yr,
        Mth,
        Revenue,

        ROW_NUMBER() OVER (
            PARTITION BY Yr, Mth
            ORDER BY Revenue DESC
        ) AS Revenue_Rank

    FROM Daily_Revenue
)

SELECT
    Order_Date,
    Yr,
    Mth,
    Revenue

FROM Ranked_Days

WHERE Revenue_Rank = 1

ORDER BY
    Yr,
    Mth;
