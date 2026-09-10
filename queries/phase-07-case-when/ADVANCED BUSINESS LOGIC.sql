/*
Q33. Customer Value Matrix

Calculate for every customer:
- Total Orders
- Total Revenue
- Average Order Value

Create a two-dimensional customer classification:

High Revenue + High Frequency → 'VIP'
High Revenue + Low Frequency  → 'Big Spender'
Low Revenue + High Frequency  → 'Loyal Customer'
Low Revenue + Low Frequency   → 'Low Value'

Use:
- Revenue >= average customer revenue → High Revenue
- Orders >= average customer orders → High Frequency
*/

WITH Customer_Metrics AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COUNT(DISTINCT o.Order_Id) AS Total_Orders,
        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity), 0
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
        END AS Average_Order_Value,
        AVG(Total_Revenue) OVER () AS Avg_Customer_Revenue,
        AVG(Total_Orders) OVER () AS Avg_Customer_Orders
    FROM Customer_Metrics
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Orders,
    Total_Revenue,
    Average_Order_Value,
    CASE
        WHEN Total_Revenue >= Avg_Customer_Revenue
             AND Total_Orders >= Avg_Customer_Orders
            THEN 'VIP'

        WHEN Total_Revenue >= Avg_Customer_Revenue
             AND Total_Orders < Avg_Customer_Orders
            THEN 'Big Spender'

        WHEN Total_Revenue < Avg_Customer_Revenue
             AND Total_Orders >= Avg_Customer_Orders
            THEN 'Loyal Customer'

        ELSE 'Low Value'
    END AS Customer_Category
FROM Customer_Averages
ORDER BY Total_Revenue DESC;


/*
Q34. Product Performance vs Average

Calculate total revenue and total quantity sold for every product.

Compare each product with the average product revenue
and average quantity sold.

Classify:
- Revenue >= average AND quantity >= average
    → 'Star Product'
- Revenue >= average AND quantity < average
    → 'Premium Product'
- Revenue < average AND quantity >= average
    → 'High Volume Low Revenue'
- Otherwise
    → 'Low Performer'
*/

WITH Product_Metrics AS (
    SELECT
        p.Product_Id,
        p.Product_Name,
        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity), 0
        ) AS Total_Revenue,
        COALESCE(
            SUM(oi.Quantity), 0
        ) AS Total_Quantity
    FROM products p
    LEFT JOIN order_items oi
        ON p.Product_Id = oi.Product_Id
    GROUP BY
        p.Product_Id,
        p.Product_Name
),
Product_Averages AS (
    SELECT
        Product_Id,
        Product_Name,
        Total_Revenue,
        Total_Quantity,
        AVG(Total_Revenue) OVER () AS Avg_Revenue,
        AVG(Total_Quantity) OVER () AS Avg_Quantity
    FROM Product_Metrics
)
SELECT
    Product_Id,
    Product_Name,
    Total_Revenue,
    Total_Quantity,
    Avg_Revenue,
    Avg_Quantity,
    CASE
        WHEN Total_Revenue >= Avg_Revenue
             AND Total_Quantity >= Avg_Quantity
            THEN 'Star Product'

        WHEN Total_Revenue >= Avg_Revenue
             AND Total_Quantity < Avg_Quantity
            THEN 'Premium Product'

        WHEN Total_Revenue < Avg_Revenue
             AND Total_Quantity >= Avg_Quantity
            THEN 'High Volume Low Revenue'

        ELSE 'Low Performer'
    END AS Product_Category
FROM Product_Averages
ORDER BY Total_Revenue DESC;


/*
Q35. Store Inventory vs Sales

For each store calculate:
- Total Inventory
- Total Revenue

Classify stores:

High Inventory + Low Revenue
    → 'Inventory Risk'

Low Inventory + High Revenue
    → 'Stock Risk'

High Inventory + High Revenue
    → 'Healthy High Performer'

Low Inventory + Low Revenue
    → 'Low Activity'

Use the average inventory and average revenue across stores
as the comparison points.
*/

WITH Store_Metrics AS (
    SELECT
        s.Store_Id,
        s.Store_Name,
        COALESCE(SUM(i.Product_Inventory), 0) AS Total_Inventory,
        COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) AS Total_Revenue
    FROM stores s
    LEFT JOIN inventory i
        ON s.Store_Id = i.Store_Id
    LEFT JOIN orders o
        ON s.Store_Id = o.Store_Id
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY
        s.Store_Id,
        s.Store_Name
),
Store_Averages AS (
    SELECT
        Store_Id,
        Store_Name,
        Total_Inventory,
        Total_Revenue,
        AVG(Total_Inventory) OVER () AS Avg_Inventory,
        AVG(Total_Revenue) OVER () AS Avg_Revenue
    FROM Store_Metrics
)
SELECT
    Store_Id,
    Store_Name,
    Total_Inventory,
    Total_Revenue,
    Avg_Inventory,
    Avg_Revenue,
    CASE
        WHEN Total_Inventory >= Avg_Inventory
             AND Total_Revenue < Avg_Revenue
            THEN 'Inventory Risk'

        WHEN Total_Inventory < Avg_Inventory
             AND Total_Revenue >= Avg_Revenue
            THEN 'Stock Risk'

        WHEN Total_Inventory >= Avg_Inventory
             AND Total_Revenue >= Avg_Revenue
            THEN 'Healthy High Performer'

        ELSE 'Low Activity'
    END AS Store_Category
FROM Store_Averages
ORDER BY Total_Revenue DESC;


/*
Q36. Customer Loyalty Classification

Calculate for every customer:
- Number of orders
- Total revenue
- Number of completed orders

Classify customers:

- 5+ orders AND 3+ completed orders
    → 'Highly Loyal'

- 3+ orders AND at least 50% completed
    → 'Loyal'

- At least 1 order
    → 'Occasional'

- No orders
    → 'Inactive'
*/

WITH Customer_Metrics AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,
        COUNT(DISTINCT o.Order_Id) AS Total_Orders,

        COUNT(
            DISTINCT CASE
                WHEN LOWER(o.Order_Status) = 'complete'
                THEN o.Order_Id
            END
        ) AS Completed_Orders,

        COALESCE(
            SUM(oi.Unit_Price * oi.Quantity), 0
        ) AS Total_Revenue

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
    Total_Orders,
    Completed_Orders,
    Total_Revenue,

    CASE
        WHEN Total_Orders >= 5
             AND Completed_Orders >= 3
            THEN 'Highly Loyal'

        WHEN Total_Orders >= 3
             AND Completed_Orders * 1.0 /
                 NULLIF(Total_Orders, 0) >= 0.50
            THEN 'Loyal'

        WHEN Total_Orders >= 1
            THEN 'Occasional'

        ELSE 'Inactive'
    END AS Loyalty_Category

FROM Customer_Metrics
ORDER BY Total_Revenue DESC;


/*
Q37. Order Value vs Store Average

Calculate the total value of every order.

Compare each order's value with the average order value
of its store.

Classify:
- Order value >= 2 × store average
    → 'Exceptional Order'

- Order value >= store average
    → 'Above Average'

- Otherwise
    → 'Below Average'
*/

WITH Order_Revenue AS (
    SELECT
        o.Order_Id,
        o.Store_Id,
        o.Customer_ID,
        SUM(
            oi.Unit_Price * oi.Quantity
        ) AS Order_Value
    FROM orders o
    JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY
        o.Order_Id,
        o.Store_Id,
        o.Customer_ID
),
Store_Averages AS (
    SELECT
        Order_Id,
        Store_Id,
        Customer_ID,
        Order_Value,
        AVG(Order_Value) OVER (
            PARTITION BY Store_Id
        ) AS Store_Average_Order_Value
    FROM Order_Revenue
)
SELECT
    Order_Id,
    Store_Id,
    Customer_ID,
    Order_Value,
    Store_Average_Order_Value,

    CASE
        WHEN Order_Value >=
             Store_Average_Order_Value * 2
            THEN 'Exceptional Order'

        WHEN Order_Value >=
             Store_Average_Order_Value
            THEN 'Above Average'

        ELSE 'Below Average'
    END AS Order_Category

FROM Store_Averages
ORDER BY Store_Id, Order_Value DESC;


/*
Q38. Top Product Dependency

For each store:

1. Calculate revenue generated by every product.
2. Find the highest-revenue product for each store.
3. Calculate that product's percentage contribution
   to the store's total revenue.

Classify:
- Contribution >= 50% → 'Highly Dependent'
- Contribution >= 30% → 'Moderately Dependent'
- Otherwise → 'Diversified'
*/

WITH Store_Product_Revenue AS (
    SELECT
        o.Store_Id,
        oi.Product_Id,
        SUM(
            oi.Unit_Price * oi.Quantity
        ) AS Product_Revenue
    FROM orders o
    JOIN order_items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY
        o.Store_Id,
        oi.Product_Id
),
Ranked_Products AS (
    SELECT
        Store_Id,
        Product_Id,
        Product_Revenue,

        RANK() OVER (
            PARTITION BY Store_Id
            ORDER BY Product_Revenue DESC
        ) AS Product_Rank,

        SUM(Product_Revenue) OVER (
            PARTITION BY Store_Id
        ) AS Store_Total_Revenue

    FROM Store_Product_Revenue
)
SELECT
    Store_Id,
    Product_Id,
    Product_Revenue,
    Store_Total_Revenue,

    ROUND(
        Product_Revenue * 100.0 /
        NULLIF(Store_Total_Revenue, 0),
        2
    ) AS Revenue_Contribution_Percentage,

    CASE
        WHEN Product_Revenue * 100.0 /
             NULLIF(Store_Total_Revenue, 0) >= 50
            THEN 'Highly Dependent'

        WHEN Product_Revenue * 100.0 /
             NULLIF(Store_Total_Revenue, 0) >= 30
            THEN 'Moderately Dependent'

        ELSE 'Diversified'
    END AS Dependency_Category

FROM Ranked_Products
WHERE Product_Rank = 1
ORDER BY Revenue_Contribution_Percentage DESC;


/*
Q39. Customer Monthly Revenue Change

Calculate monthly revenue for each customer.

Use LAG() to compare the customer's current-month revenue
with the previous month's revenue.

Calculate the percentage change.

Classify:
- Increase >= 20% → 'Strong Growth'
- Increase > 0%  → 'Growing'
- Decrease        → 'Declining'
- No previous month → 'New Customer Period'
*/

WITH Monthly_Customer_Revenue AS (
    SELECT
        o.Customer_ID,
        DATE_FORMAT(
            o.Order_Tms,
            '%Y-%m'
        ) AS Revenue_Month,

        SUM(
            oi.Unit_Price * oi.Quantity
        ) AS Monthly_Revenue

    FROM orders o
    JOIN order_items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        o.Customer_ID,
        DATE_FORMAT(
            o.Order_Tms,
            '%Y-%m'
        )
),
Customer_Revenue_Change AS (
    SELECT
        Customer_ID,
        Revenue_Month,
        Monthly_Revenue,

        LAG(Monthly_Revenue) OVER (
            PARTITION BY Customer_ID
            ORDER BY Revenue_Month
        ) AS Previous_Month_Revenue

    FROM Monthly_Customer_Revenue
)
SELECT
    Customer_ID,
    Revenue_Month,
    Monthly_Revenue,
    Previous_Month_Revenue,

    ROUND(
        (
            Monthly_Revenue -
            Previous_Month_Revenue
        ) * 100.0 /
        NULLIF(Previous_Month_Revenue, 0),
        2
    ) AS Revenue_Change_Percentage,

    CASE
        WHEN Previous_Month_Revenue IS NULL
            THEN 'New Customer Period'

        WHEN Monthly_Revenue >=
             Previous_Month_Revenue * 1.20
            THEN 'Strong Growth'

        WHEN Monthly_Revenue >
             Previous_Month_Revenue
            THEN 'Growing'

        WHEN Monthly_Revenue <
             Previous_Month_Revenue
            THEN 'Declining'

        ELSE 'No Change'
    END AS Growth_Category

FROM Customer_Revenue_Change
ORDER BY
    Customer_ID,
    Revenue_Month;


/*
Q40. Executive Customer Segmentation

Create a final executive-level customer segmentation.

Calculate:
- Total Orders
- Total Revenue
- Average Order Value
- Completed Orders
- Completion Rate
- Revenue Rank

Classify customers using multiple business conditions:

1. VIP
   - Revenue rank <= 10
   - 5+ orders
   - Completion rate >= 80%

2. High Value
   - Revenue >= average customer revenue
   - 3+ orders

3. Loyal
   - 5+ orders
   - Completion rate >= 70%

4. At Risk
   - Has orders
   - Completion rate < 50%

5. Occasional
   - 1–2 orders

6. Inactive
   - 0 orders

The conditions should be evaluated in the correct order
so that VIP customers are not incorrectly classified.
*/

WITH Customer_Metrics AS (
    SELECT
        c.Customer_ID,
        c.Full_Name,

        COUNT(DISTINCT o.Order_Id) AS Total_Orders,

        COALESCE(
            SUM(
                oi.Unit_Price * oi.Quantity
            ),
            0
        ) AS Total_Revenue,

        COUNT(
            DISTINCT CASE
                WHEN LOWER(o.Order_Status) = 'complete'
                THEN o.Order_Id
            END
        ) AS Completed_Orders

    FROM customers c
    LEFT JOIN orders o
        ON c.Customer_ID = o.Customer_ID
    LEFT JOIN order_items oi
        ON o.Order_Id = oi.Order_Id

    GROUP BY
        c.Customer_ID,
        c.Full_Name
),
Customer_Analysis AS (
    SELECT
        Customer_ID,
        Full_Name,
        Total_Orders,
        Total_Revenue,
        Completed_Orders,

        CASE
            WHEN Total_Orders > 0
                THEN Total_Revenue / Total_Orders
            ELSE 0
        END AS Average_Order_Value,

        Completed_Orders * 100.0 /
        NULLIF(Total_Orders, 0)
            AS Completion_Rate,

        RANK() OVER (
            ORDER BY Total_Revenue DESC
        ) AS Revenue_Rank,

        AVG(Total_Revenue) OVER ()
            AS Average_Customer_Revenue

    FROM Customer_Metrics
)
SELECT
    Customer_ID,
    Full_Name,
    Total_Orders,
    Total_Revenue,
    Average_Order_Value,
    Completed_Orders,
    ROUND(Completion_Rate, 2)
        AS Completion_Rate,
    Revenue_Rank,

    CASE
        WHEN Revenue_Rank <= 10
             AND Total_Orders >= 5
             AND Completion_Rate >= 80
            THEN 'VIP'

        WHEN Total_Revenue >= Average_Customer_Revenue
             AND Total_Orders >= 3
            THEN 'High Value'

        WHEN Total_Orders >= 5
             AND Completion_Rate >= 70
            THEN 'Loyal'

        WHEN Total_Orders > 0
             AND Completion_Rate < 50
            THEN 'At Risk'

        WHEN Total_Orders BETWEEN 1 AND 2
            THEN 'Occasional'

        ELSE 'Inactive'

    END AS Executive_Segment

FROM Customer_Analysis
ORDER BY
    Revenue_Rank;