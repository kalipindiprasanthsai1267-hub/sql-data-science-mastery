/*
Q18. Write two CTEs —
CTE1: Order_Revenue calculating revenue per order.
CTE2: High_Revenue_Orders filtering orders above average revenue.
Then show the final result from the second CTE.
*/

with order_revenue AS(
SELECT order_id, SUM(unit_price * quantity) as revenue
FROM order_items
GROUP BY order_id
),
High_Revenue_Orders AS (
SELECT order_id, revenue 
FROM order_revenue
WHERE revenue > (SELECT AVG(revenue) FROM order_revenue) 
)

SELECT * FROM High_Revenue_Orders
ORDER BY revenue DESC;


/*
Q19. Write two CTEs —
CTE1: Customer_Spending calculating total spending per customer.
CTE2: Ranked_Customers ranking customers by spending using RANK().
Then show the top 3 customers.
*/


WITH customer_spending AS (
SELECT o.customer_id, SUM(oi.unit_price * oi.quantity) AS total_spending_per_customer
FROM orders o 
JOIN order_items oi
ON o.order_id = oi.Order_Id
GROUP BY o.Customer_ID
),
Ranked_Customers AS (
SELECT customer_id, total_spending_per_customer,
RANK() OVER(order by total_spending_per_customer) as rnk
FROM customer_spending
)

SELECT customer_id, total_spending_per_customer,rnk FROM Ranked_Customers
WHERE rnk <=3;


/*
Q20. Write three CTEs —
CTE1: Order_Revenue for revenue per order.
CTE2: Store_Revenue for total revenue per store using Order_Revenue.
CTE3: Ranked_Stores ranking stores by revenue.
Then show all stores with their rank.
*/

WITH Order_Revenue AS (
    SELECT
        o.Order_Id,
        o.Store_Id,
        SUM(oi.Quantity * oi.Unit_Price) AS Revenue
    FROM Orders o
    JOIN Order_Items oi
        ON o.Order_Id = oi.Order_Id
    GROUP BY o.Order_Id, o.Store_Id
),

Store_Revenue AS (
    SELECT
        Store_Id,
        SUM(Revenue) AS Revenue
    FROM Order_Revenue
    GROUP BY Store_Id
),

Ranked_Stores AS (
    SELECT
        Store_Id,
        Revenue,
        RANK() OVER (
            ORDER BY Revenue DESC
        ) AS Rnk
    FROM Store_Revenue
)

SELECT
    s.Store_Name,rs.Revenue,rs.Rnk
FROM Ranked_Stores rs
JOIN Stores s
    ON rs.Store_Id = s.Store_Id
ORDER BY rs.Rnk;

/*
Q21. Write two CTEs —
CTE1: Complete_Orders filtering only complete orders.
CTE2: Complete_Order_Revenue calculating revenue for those orders only.
Then show total revenue from complete orders per store.
*/

WITH Complete_Orders AS (
SELECT order_id, store_id
FROM orders
WHERE lower(order_status) = 'complete'
),
Complete_Order_Revenue AS(
SELECT store_id, SUM(oi.quantity * oi.unit_price) as rev
FROM complete_orders co
JOIN order_items oi
ON co.order_id = oi.Order_Id
GROUP BY store_id
)
SELECT s.store_name, cr.rev
FROM complete_order_revenue cr 
JOIN stores s ON 
cr.store_id = s.store_id
ORDER BY cr.rev DESC;


/*
Q22. Write three CTEs —
CTE1: Monthly_Revenue calculating revenue per month.
CTE2: Prev_Month_Revenue adding LAG to get previous month revenue.
CTE3: MoM_Change calculating month over month change.
Then show all months with their revenue change.
*/

WITH Monthly_Revenue AS (
SELECT EXTRACT(YEAR FROM o.Order_Tms) AS Yr, 
EXTRACT(MONTH FROM o.Order_Tms) AS Mth, 
SUM(oi.Unit_Price * oi.Quantity) AS Revenue 
FROM CO.Orders o 
JOIN Order_Items oi 
ON o.Order_Id = oi.Order_Id 
GROUP BY EXTRACT(YEAR FROM o.Order_Tms),
EXTRACT(MONTH FROM o.Order_Tms) ),
Prev_Month_Revenue AS ( SELECT Yr, Mth, Revenue,LAG(Revenue, 1, NULL) OVER( ORDER BY Yr, Mth ) AS Prev_Revenue 
FROM Monthly_Revenue),
MoM_Change AS ( SELECT Yr, Mth, Revenue, Prev_Revenue, Revenue - Prev_Revenue AS Revenue_Change, 
ROUND( (Revenue - Prev_Revenue) * 100.0 / Prev_Revenue, 2 ) AS Change_Pct FROM
Prev_Month_Revenue ) 
SELECT * FROM MoM_Change ORDER BY Yr, Mth;



/*
Q23. Write two CTEs —
CTE1: Product_Order_Count counting how many times each product was ordered.
CTE2: Above_Avg_Products filtering products ordered more than average.
Then show those products with their order count.
*/

WITH Product_Order_Count AS (
SELECT product_id, count(*) as ordered_count
FROM order_items
GROUP BY product_id
),
Above_Avg_Products AS (
SELECT product_id, ordered_count
FROM product_order_count
WHERE ordered_count > (SELECT AVG(ordered_count) FROM Product_Order_Count)
)
SELECT * FROM Above_Avg_Products
ORDER BY ordered_count DESC;
