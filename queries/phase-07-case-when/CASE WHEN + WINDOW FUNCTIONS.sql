/*
Q25. Customer Revenue Rank Category

Calculate total revenue for each customer and rank customers
by revenue.

Classify customers:
- Rank 1–5   → 'Top Customer'
- Rank 6–10  → 'High Value'
- Rank 11–20 → 'Medium Value'
- Others     → 'Low Value'
*/

WITH Customer_Revenue AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY c.Customer_ID, c.Full_Name
),
Ranked_Customers AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Revenue,
        RANK() OVER (
            ORDER BY Total_Revenue DESC
        ) AS Revenue_Rank
    FROM Customer_Revenue
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Revenue,
    Revenue_Rank,
    CASE
        WHEN Revenue_Rank <= 5 THEN 'Top Customer'
        WHEN Revenue_Rank <= 10 THEN 'High Value'
        WHEN Revenue_Rank <= 20 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Category
FROM Ranked_Customers
ORDER BY Revenue_Rank;


/*
Q26. Store Revenue Ranking

Calculate total revenue for each store and rank stores
using DENSE_RANK().

Classify:
- Rank 1      → 'Best Store'
- Rank 2–3    → 'Top Performer'
- Others      → 'Standard'
*/

WITH Store_Revenue AS (
    SELECT
        s.Store_Id,
        s.Store_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM stores s
    LEFT JOIN orders o
        ON s.Store_Id = o.Store_Id
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY s.Store_Id, s.Store_Name
),
Ranked_Stores AS (
    SELECT
        Store_Id,
        Store_Name,
        Total_Revenue,
        DENSE_RANK() OVER (
            ORDER BY Total_Revenue DESC
        ) AS Revenue_Rank
    FROM Store_Revenue
)
SELECT
    Store_Id,
    Store_Name,
    Total_Revenue,
    Revenue_Rank,
    CASE
        WHEN Revenue_Rank = 1 THEN 'Best Store'
        WHEN Revenue_Rank <= 3 THEN 'Top Performer'
        ELSE 'Standard'
    END AS Store_Category
FROM Ranked_Stores
ORDER BY Revenue_Rank;


/*
Q27. Product Revenue Quartiles

Calculate total revenue for each product.

Divide products into four revenue groups using NTILE(4):
- Quartile 1 → 'Top 25%'
- Quartile 2 → 'High'
- Quartile 3 → 'Medium'
- Quartile 4 → 'Low'
*/

WITH Product_Revenue AS (
    SELECT
        p.Product_Id,
        p.Product_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM products p
    LEFT JOIN order_items oi
        ON p.Product_Id = oi.Product_Id
    GROUP BY p.Product_Id, p.Product_Name
),
Product_Quartiles AS (
    SELECT
        Product_Id,
        Product_Name,
        Total_Revenue,
        NTILE(4) OVER (
            ORDER BY Total_Revenue DESC
        ) AS Revenue_Quartile
    FROM Product_Revenue
)
SELECT
    Product_Id,
    Product_Name,
    Total_Revenue,
    Revenue_Quartile,
    CASE
        WHEN Revenue_Quartile = 1 THEN 'Top 25%'
        WHEN Revenue_Quartile = 2 THEN 'High'
        WHEN Revenue_Quartile = 3 THEN 'Medium'
        ELSE 'Low'
    END AS Revenue_Category
FROM Product_Quartiles
ORDER BY Revenue_Quartile, Total_Revenue DESC;


/*
Q28. Customer Revenue vs Average

Calculate total revenue for each customer and compare it
with the overall average customer revenue.

Classify:
- Revenue >= 2 × average → 'Very High'
- Revenue >= average     → 'Above Average'
- Revenue < average      → 'Below Average'
*/

WITH Customer_Revenue AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY c.Customer_ID, c.Full_Name
),
Customer_Average AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Revenue,
        AVG(Total_Revenue) OVER () AS Average_Revenue
    FROM Customer_Revenue
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Revenue,
    Average_Revenue,
    CASE
        WHEN Total_Revenue >= Average_Revenue * 2
            THEN 'Very High'
        WHEN Total_Revenue >= Average_Revenue
            THEN 'Above Average'
        ELSE 'Below Average'
    END AS Revenue_Category
FROM Customer_Average
ORDER BY Total_Revenue DESC;


/*
Q29. Store Revenue Comparison

Calculate revenue for each store.

Use LAG() to compare the current store's revenue with
the previous store's revenue when stores are ordered
by revenue.

Classify:
- Increase → 'Growing'
- Decrease → 'Declining'
- No previous store → 'First Store'
- Same revenue → 'Same Revenue'
*/

WITH Store_Revenue AS (
    SELECT
        s.Store_Id,
        s.Store_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM stores s
    LEFT JOIN orders o
        ON s.Store_Id = o.Store_Id
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY s.Store_Id, s.Store_Name
),
Store_Comparison AS (
    SELECT
        Store_Id,
        Store_Name,
        Total_Revenue,
        LAG(Total_Revenue) OVER (
            ORDER BY Total_Revenue DESC
        ) AS Previous_Revenue
    FROM Store_Revenue
)
SELECT
    Store_Id,
    Store_Name,
    Total_Revenue,
    Previous_Revenue,
    CASE
        WHEN Previous_Revenue IS NULL
            THEN 'First Store'
        WHEN Total_Revenue > Previous_Revenue
            THEN 'Growing'
        WHEN Total_Revenue < Previous_Revenue
            THEN 'Declining'
        ELSE 'Same Revenue'
    END AS Performance
FROM Store_Comparison
ORDER BY Total_Revenue DESC;


/*
Q30. Product Revenue Contribution

Calculate each product's total revenue and its percentage
contribution to overall product revenue.

Classify:
- >= 10% → 'Major Product'
- >= 5%  → 'Significant Product'
- Otherwise → 'Minor Product'
*/

WITH Product_Revenue AS (
    SELECT
        p.Product_Id,
        p.Product_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM products p
    LEFT JOIN order_items oi
        ON p.Product_Id = oi.Product_Id
    GROUP BY p.Product_Id, p.Product_Name
),
Product_Contribution AS (
    SELECT
        Product_Id,
        Product_Name,
        Total_Revenue,
        SUM(Total_Revenue) OVER () AS Overall_Revenue
    FROM Product_Revenue
)
SELECT
    Product_Id,
    Product_Name,
    Total_Revenue,
    ROUND(
        Total_Revenue * 100.0 /
        NULLIF(Overall_Revenue, 0),
        2
    ) AS Revenue_Percentage,
    CASE
        WHEN Total_Revenue * 100.0 /
             NULLIF(Overall_Revenue, 0) >= 10
            THEN 'Major Product'
        WHEN Total_Revenue * 100.0 /
             NULLIF(Overall_Revenue, 0) >= 5
            THEN 'Significant Product'
        ELSE 'Minor Product'
    END AS Product_Category
FROM Product_Contribution
ORDER BY Revenue_Percentage DESC;


/*
Q31. Customer Cumulative Revenue

Calculate total revenue for each customer.

Sort customers by revenue descending and calculate
cumulative revenue.

Classify:
- Cumulative revenue <= 50% of total → 'Top Revenue Group'
- Cumulative revenue <= 80% of total → 'Core Revenue Group'
- Otherwise → 'Long Tail'
*/

WITH Customer_Revenue AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY c.Customer_ID, c.Full_Name
),
Customer_Cumulative AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Revenue,
        SUM(Total_Revenue) OVER (
            ORDER BY Total_Revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Cumulative_Revenue,
        SUM(Total_Revenue) OVER () AS Overall_Revenue
    FROM Customer_Revenue
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Revenue,
    Cumulative_Revenue,
    ROUND(
        Cumulative_Revenue * 100.0 /
        NULLIF(Overall_Revenue, 0),
        2
    ) AS Cumulative_Percentage,
    CASE
        WHEN Cumulative_Revenue * 100.0 /
             NULLIF(Overall_Revenue, 0) <= 50
            THEN 'Top Revenue Group'
        WHEN Cumulative_Revenue * 100.0 /
             NULLIF(Overall_Revenue, 0) <= 80
            THEN 'Core Revenue Group'
        ELSE 'Long Tail'
    END AS Revenue_Group
FROM Customer_Cumulative
ORDER BY Total_Revenue DESC;


/*
Q32. Store Monthly Revenue Growth

Calculate monthly revenue for each store.

Use LAG() to compare the current month's revenue with
the previous month's revenue.

Classify:
- Increase > 20% → 'High Growth'
- Increase > 0%  → 'Growing'
- Decrease       → 'Declining'
- No previous month → 'New Period'
*/

WITH Monthly_Revenue AS (
    SELECT
        o.Store_Id,
        DATE_FORMAT(o.Order_Tms, '%Y-%m') AS Revenue_Month,
        SUM(oi.Unit_Price * oi.Quantity) AS Total_Revenue
    FROM orders o
    JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY
        o.Store_Id,
        DATE_FORMAT(o.Order_Tms, '%Y-%m')
),
Revenue_Comparison AS (
    SELECT
        Store_Id,
        Revenue_Month,
        Total_Revenue,
        LAG(Total_Revenue) OVER (
            PARTITION BY Store_Id
            ORDER BY Revenue_Month
        ) AS Previous_Month_Revenue
    FROM Monthly_Revenue
)
SELECT
    Store_Id,
    Revenue_Month,
    Total_Revenue,
    Previous_Month_Revenue,
    CASE
        WHEN Previous_Month_Revenue IS NULL
            THEN 'New Period'
        WHEN Total_Revenue >
             Previous_Month_Revenue * 1.20
            THEN 'High Growth'
        WHEN Total_Revenue >
             Previous_Month_Revenue
            THEN 'Growing'
        WHEN Total_Revenue <
             Previous_Month_Revenue
            THEN 'Declining'
        ELSE 'No Growth'
    END AS Growth_Category
FROM Revenue_Comparison
ORDER BY Store_Id, Revenue_Month;