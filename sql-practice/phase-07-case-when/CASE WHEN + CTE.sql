/*Q17. CUSTOMER REVENUE SEGMENTATION

Create a CTE that calculates total revenue
for every customer.

Classify customers:

- >= 200000       → 'Platinum'
- 100000–199999   → 'Gold'
- 50000–99999     → 'Silver'
- < 50000         → 'Bronze'

Return:
- Customer_ID
- Full_Name
- Total_Revenue
- Customer_Tier
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
    GROUP BY
        c.Customer_ID,
        c.Full_Name
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Revenue,
    CASE
        WHEN Total_Revenue >= 200000 THEN 'Platinum'
        WHEN Total_Revenue >= 100000 THEN 'Gold'
        WHEN Total_Revenue >= 50000 THEN 'Silver'
        ELSE 'Bronze'
    END AS Customer_Tier
FROM Customer_Revenue
ORDER BY Total_Revenue DESC;


/*
Q18. STORE PERFORMANCE CLASSIFICATION

Create a CTE containing total revenue per store.

Classify stores into:

- Excellent
- Good
- Average
- Poor

Use CASE WHEN to perform the classification.

Return:
- Store_Id
- Store_Name
- Total_Revenue
- Performance_Category
*/

/*
Q18. STORE PERFORMANCE CLASSIFICATION

Create a CTE containing total revenue per store.

Classify stores into:

- Excellent
- Good
- Average
- Poor

Use CASE WHEN.
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
    GROUP BY
        s.Store_Id,
        s.Store_Name
),
Store_Stats AS (
    SELECT
        Store_Id,
        Store_Name,
        Total_Revenue,
        AVG(Total_Revenue) OVER () AS Average_Revenue
    FROM Store_Revenue
)
SELECT
    Store_Id,
    Store_Name,
    Total_Revenue,
    Average_Revenue,
    CASE
        WHEN Total_Revenue >= Average_Revenue * 1.5
            THEN 'Excellent'

        WHEN Total_Revenue >= Average_Revenue
            THEN 'Good'

        WHEN Total_Revenue >= Average_Revenue * 0.5
            THEN 'Average'

        ELSE 'Poor'
    END AS Performance_Category
FROM Store_Stats
ORDER BY Total_Revenue DESC;


/*
Q19. CUSTOMER PURCHASE FREQUENCY

Create a CTE that calculates order count
for every customer.

Classify customers:

- 0 orders       → 'No Activity'
- 1–2 orders     → 'Low Frequency'
- 3–5 orders     → 'Medium Frequency'
- More than 5    → 'High Frequency'

Return:
- Customer_ID
- Full_Name
- Order_Count
- Frequency_Category
*/

WITH Customer_Orders AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COUNT(DISTINCT o.Order_Id) AS Order_Count
    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Full_Name
)
SELECT
    Customer_ID,
    Full_Name,
    Order_Count,
    CASE
        WHEN Order_Count = 0 THEN 'No Activity'
        WHEN Order_Count BETWEEN 1 AND 2 THEN 'Low Frequency'
        WHEN Order_Count BETWEEN 3 AND 5 THEN 'Medium Frequency'
        ELSE 'High Frequency'
    END AS Frequency_Category
FROM Customer_Orders
ORDER BY Order_Count DESC;



/*
Q20. PRODUCT PERFORMANCE CLASSIFICATION

Create a CTE containing:

- Total Revenue
- Total Quantity Sold
- Average Unit Price

Then classify products into:

- Star Product
- High Revenue
- High Volume
- Low Performer

Use multiple CASE WHEN conditions.

Return:
- Product_Id
- Product_Name
- Total_Revenue
- Total_Quantity
- Average_Unit_Price
- Performance_Category
*/


/*
Q20. PRODUCT PERFORMANCE CLASSIFICATION

Create a CTE containing:

- Total Revenue
- Total Quantity Sold
- Average Unit Price

Then classify products into:

- Star Product
- High Revenue
- High Volume
- Low Performer

Use multiple CASE WHEN conditions.
*/

WITH Product_Performance AS (
    SELECT
        p.Product_Id,
        p.Product_Name,

        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity),
            0
        ) AS Total_Revenue,

        COALESCE(
            SUM(oi.Quantity),
            0
        ) AS Total_Quantity,

        p.Unit_Price AS Average_Unit_Price

    FROM products p
    LEFT JOIN order_items oi
        ON p.Product_Id = oi.Product_Id

    GROUP BY
        p.Product_Id,
        p.Product_Name,
        p.Unit_Price
),
Product_Averages AS (
    SELECT
        *,
        AVG(Total_Revenue) OVER () AS Avg_Revenue,
        AVG(Total_Quantity) OVER () AS Avg_Quantity
    FROM Product_Performance
)
SELECT
    Product_Id,
    Product_Name,
    Total_Revenue,
    Total_Quantity,
    Average_Unit_Price,

    CASE
        WHEN Total_Revenue >= Avg_Revenue
             AND Total_Quantity >= Avg_Quantity
            THEN 'Star Product'

        WHEN Total_Revenue >= Avg_Revenue
            THEN 'High Revenue'

        WHEN Total_Quantity >= Avg_Quantity
            THEN 'High Volume'

        ELSE 'Low Performer'
    END AS Performance_Category

FROM Product_Averages
ORDER BY Total_Revenue DESC;


/*
Q21. CUSTOMER REVENUE CONTRIBUTION

Calculate total revenue for every customer.

Then calculate each customer's percentage contribution
to total company revenue.

Classify customers:

- >= 10%       → 'Major Contributor'
- 5%–9.99%     → 'Significant Contributor'
- < 5%         → 'Minor Contributor'

Return:
- Customer_ID
- Full_Name
- Total_Revenue
- Revenue_Percentage
- Contribution_Category
*/


/*
Q21. CUSTOMER REVENUE CONTRIBUTION

Calculate total revenue for every customer.

Then calculate each customer's percentage contribution
to total company revenue.

Classify:

- >= 10%       → 'Major Contributor'
- 5%–9.99%     → 'Significant Contributor'
- < 5%         → 'Minor Contributor'
*/

WITH Customer_Revenue AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity),
            0
        ) AS Total_Revenue
    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY
        c.Customer_ID,
        c.Full_Name
),
Revenue_Percentage AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Revenue,
        SUM(Total_Revenue) OVER () AS Company_Revenue
    FROM Customer_Revenue
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Revenue,

    ROUND(
        (Total_Revenue / NULLIF(Company_Revenue, 0)) * 100,
        2
    ) AS Revenue_Percentage,

    CASE
        WHEN (Total_Revenue / NULLIF(Company_Revenue, 0)) * 100 >= 10
            THEN 'Major Contributor'

        WHEN (Total_Revenue / NULLIF(Company_Revenue, 0)) * 100 >= 5
            THEN 'Significant Contributor'

        ELSE 'Minor Contributor'
    END AS Contribution_Category

FROM Revenue_Percentage
ORDER BY Revenue_Percentage DESC;

/*
Q22. STORE ORDER SUCCESS RATE

For every store calculate:

- Total Orders
- Completed Orders
- Completion Percentage

Classify stores:

- >= 90%       → 'Excellent'
- 75%–89.99%   → 'Good'
- < 75%        → 'Needs Improvement'

Return:
- Store_Id
- Store_Name
- Total_Orders
- Completed_Orders
- Completion_Percentage
- Performance_Category
*/

/*
Q22. STORE ORDER SUCCESS RATE

For every store calculate:

- Total Orders
- Completed Orders
- Completion Percentage

Classify:

- >= 90%       → 'Excellent'
- 75%–89.99%   → 'Good'
- < 75%        → 'Needs Improvement'
*/

WITH Store_Orders AS (
    SELECT
        s.Store_Id,
        s.Store_Name,

        COUNT(DISTINCT o.Order_Id) AS Total_Orders,

        COUNT(
            DISTINCT CASE
                WHEN LOWER(o.Order_Status) = 'complete'
                THEN o.Order_Id
            END
        ) AS Completed_Orders

    FROM stores s

    LEFT JOIN orders o
        ON s.Store_Id = o.Store_Id

    GROUP BY
        s.Store_Id,
        s.Store_Name
)
SELECT
    Store_Id,
    Store_Name,
    Total_Orders,
    Completed_Orders,

    ROUND(
        (Completed_Orders / NULLIF(Total_Orders, 0)) * 100,
        2
    ) AS Completion_Percentage,

    CASE
        WHEN (Completed_Orders / NULLIF(Total_Orders, 0)) * 100 >= 90
            THEN 'Excellent'

        WHEN (Completed_Orders / NULLIF(Total_Orders, 0)) * 100 >= 75
            THEN 'Good'

        ELSE 'Needs Improvement'
    END AS Performance_Category

FROM Store_Orders
ORDER BY Completion_Percentage DESC;


/*
Q23. INVENTORY RISK CLASSIFICATION

Create a CTE calculating inventory information
for every store.

Classify stores as:

- Critical
- At Risk
- Healthy

Use CASE WHEN based on the inventory levels.

Return:
- Store_Id
- Store_Name
- Inventory information
- Risk_Category
*/


WITH Store_Inventory AS (
    SELECT
        s.Store_Id,
        s.Store_Name,

        COALESCE(SUM(i.Product_Inventory), 0)
            AS Total_Inventory,

        COUNT(
            CASE
                WHEN i.Product_Inventory = 0
                THEN 1
            END
        ) AS Out_of_Stock_Products,

        COUNT(
            CASE
                WHEN i.Product_Inventory BETWEEN 1 AND 10
                THEN 1
            END
        ) AS Low_Stock_Products

    FROM stores s

    LEFT JOIN inventory i
        ON s.Store_Id = i.Store_Id

    GROUP BY
        s.Store_Id,
        s.Store_Name
)
SELECT
    Store_Id,
    Store_Name,
    Total_Inventory,
    Out_of_Stock_Products,
    Low_Stock_Products,

    CASE
        WHEN Out_of_Stock_Products >= 5
            THEN 'Critical'

        WHEN Out_of_Stock_Products > 0
             OR Low_Stock_Products >= 5
            THEN 'At Risk'

        ELSE 'Healthy'
    END AS Risk_Category

FROM Store_Inventory
ORDER BY Out_of_Stock_Products DESC;


/*
Q24. CUSTOMER ORDER VALUE SEGMENTATION

Create a CTE containing:

- Customer_ID
- Total_Orders
- Total_Revenue
- Avera	ge_Order_Value

Use CASE WHEN with multiple conditions to classify
customers based on BOTH:

1. Order frequency
2. Average order value

Create meaningful categories.

Return all calculated metrics and the category.
*/


WITH Customer_Metrics AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,

        COUNT(DISTINCT o.Order_Id) AS Total_Orders,

        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity),
            0
        ) AS Total_Revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID

    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        c.Customer_ID,
        c.Full_Name
),
Customer_Averages AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Orders,
        Total_Revenue,

        CASE
            WHEN Total_Orders > 0
                THEN Total_Revenue / Total_Orders
            ELSE 0
        END AS Average_Order_Value

    FROM Customer_Metrics
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Orders,
    Total_Revenue,
    Average_Order_Value,

    CASE
        WHEN Total_Orders >= 5
             AND Average_Order_Value >= 10000
            THEN 'VIP'

        WHEN Total_Orders >= 5
             AND Average_Order_Value < 10000
            THEN 'Frequent Buyer'

        WHEN Total_Orders < 5
             AND Average_Order_Value >= 10000
            THEN 'Big Ticket Buyer'

        WHEN Total_Orders > 0
             AND Average_Order_Value < 10000
            THEN 'Occasional Buyer'

        ELSE 'No Orders'
    END AS Customer_Segment

FROM Customer_Averages
ORDER BY Total_Revenue DESC;