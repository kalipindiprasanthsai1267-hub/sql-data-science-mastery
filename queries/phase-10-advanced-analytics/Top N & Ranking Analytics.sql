/*
Q7. Find the top 3 products by revenue within each store.
*/

WITH Product_Store_Revenue AS (
    SELECT
        o.Store_Id,
        oi.Product_Id,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Store_Id,
        oi.Product_Id
),

Ranked_Products AS (
    SELECT
        Store_Id,
        Product_Id,
        Revenue,

        ROW_NUMBER() OVER (
            PARTITION BY Store_Id
            ORDER BY Revenue DESC
        ) AS Product_Rank

    FROM Product_Store_Revenue
)

SELECT
    Store_Id,
    Product_Id,
    Revenue,
    Product_Rank

FROM Ranked_Products

WHERE Product_Rank <= 3

ORDER BY
    Store_Id,
    Product_Rank;


/*
Q8. Find the highest-revenue product for each store.
*/

WITH Product_Store_Revenue AS (
    SELECT
        o.Store_Id,
        oi.Product_Id,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Store_Id,
        oi.Product_Id
),

Ranked_Products AS (
    SELECT
        Store_Id,
        Product_Id,
        Revenue,

        RANK() OVER (
            PARTITION BY Store_Id
            ORDER BY Revenue DESC
        ) AS Product_Rank

    FROM Product_Store_Revenue
)

SELECT
    Store_Id,
    Product_Id,
    Revenue

FROM Ranked_Products

WHERE Product_Rank = 1

ORDER BY Store_Id;


/*
Q9. Find the second-highest revenue-generating customer.
*/

WITH Customer_Revenue AS (
    SELECT
        o.Customer_ID,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY o.Customer_ID
),

Ranked_Customers AS (
    SELECT
        Customer_ID,
        Revenue,

        DENSE_RANK() OVER (
            ORDER BY Revenue DESC
        ) AS Revenue_Rank

    FROM Customer_Revenue
)

SELECT
    Customer_ID,
    Revenue

FROM Ranked_Customers

WHERE Revenue_Rank = 2;


/*
Q10. Find the top 5 customers by order frequency.
*/

WITH Customer_Order_Count AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Order_Count

    FROM CO.Orders

    GROUP BY Customer_ID
),

Ranked_Customers AS (
    SELECT
        Customer_ID,
        Order_Count,

        DENSE_RANK() OVER (
            ORDER BY Order_Count DESC
        ) AS Order_Rank

    FROM Customer_Order_Count
)

SELECT
    Customer_ID,
    Order_Count,
    Order_Rank

FROM Ranked_Customers

WHERE Order_Rank <= 5

ORDER BY Order_Rank;


/*
Q11. Find the top 2 stores by revenue for each year.
*/

WITH Store_Year_Revenue AS (
    SELECT
        YEAR(o.Order_Tms) AS Yr,
        o.Store_Id,

        SUM(
            oi.Quantity * oi.Unit_Price
        ) AS Revenue

    FROM CO.Orders o

    INNER JOIN CO.Order_Items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        YEAR(o.Order_Tms),
        o.Store_Id
),

Ranked_Stores AS (
    SELECT
        Yr,
        Store_Id,
        Revenue,

        DENSE_RANK() OVER (
            PARTITION BY Yr
            ORDER BY Revenue DESC
        ) AS Store_Rank

    FROM Store_Year_Revenue
)

SELECT
    Yr,
    Store_Id,
    Revenue,
    Store_Rank

FROM Ranked_Stores

WHERE Store_Rank <= 2

ORDER BY
    Yr,
    Store_Rank;


/*
Q12. Find products that rank in the top 10% of products
     based on revenue.
*/

WITH Product_Revenue AS (
    SELECT
        Product_Id,

        SUM(
            Quantity * Unit_Price
        ) AS Revenue

    FROM CO.Order_Items

    GROUP BY Product_Id
),

Ranked_Products AS (
    SELECT
        Product_Id,
        Revenue,

        PERCENT_RANK() OVER (
            ORDER BY Revenue DESC
        ) AS Revenue_Percent_Rank

    FROM Product_Revenue
)

SELECT
    Product_Id,
    Revenue,

    ROUND(
        Revenue_Percent_Rank * 100,
        2
    ) AS Percentile_Rank

FROM Ranked_Products

WHERE Revenue_Percent_Rank <= 0.10

ORDER BY Revenue DESC;
