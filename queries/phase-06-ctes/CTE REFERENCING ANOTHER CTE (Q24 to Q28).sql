/*
Q24. Write three CTEs —
CTE1: Order_Revenue calculating revenue per order.
CTE2: Customer_Order_Revenue joining CTE1 to Orders to get customer ID.
CTE3: Customer_Total summing revenue per customer from CTE2.
Then show the final customer totals.
*/

WITH Order_Revenue AS (
SELECT order_id, SUM(unit_price * quantity) as rev
FROM order_items
GROUP BY order_id
),
Customer_Order_Revenue AS (
SELECT o.customer_id, o.order_id, r.rev
FROM orders o 
JOIN order_revenue r
ON o.Order_Id = r.Order_Id
),
customer_total AS (
SELECT customer_id, SUM(rev) as total_rev
FROM Customer_Order_Revenue
group by customer_id
)

SELECT * FROM customer_total;


/*
Q25. Write three CTEs —
CTE1: Store_Orders counting orders per store.
CTE2: Store_Revenue calculating revenue per store.
CTE3: Store_Summary joining CTE1 and CTE2 together.
Then show the final summary with store ID, order count and revenue.
*/

WITH Store_Orders AS (
SELECT store_id, count(*) AS count_ord
FROM orders
GROUP BY store_id
),
Store_Revenue AS (
SELECT o.store_id, SUM(oi.quantity * oi.unit_price) as rev
FROM orders o
JOIN order_items oi
ON o.Order_Id = oi.Order_Id
GROUP BY o.Store_Id
),
Store_Summary AS (
SELECT so.store_id,so.count_ord,sr.rev
FROM  Store_Orders so
JOIN Store_Revenue sr
on so.store_id = sr.store_id
)
SELECT * FROM Store_Summary;

/*
Q26. Write two CTEs —
CTE1: Product_Sales calculating total quantity sold and revenue per product.
CTE2: Product_Ranked ranking products from CTE1 by total revenue.
Then show top 5 products.
*/

WITH Product_Sales AS (
SELECT product_id, SUM(quantity) as product_count, SUM(quantity * unit_price) as rev
FROM order_items
GROUP by product_id
),
Product_Ranked AS (
SELECT product_id, product_count, rev,
RANK() OVER(order by rev DESC) AS ranking
FROM product_sales
)
SELECT * FROM Product_Ranked;



/*
Q27. Write three CTEs —
CTE1: Customer_Orders joining Customers and Orders.
CTE2: Customer_Items joining CTE1 to Order_Items.
CTE3: Customer_Revenue aggregating total revenue per customer from CTE2.
Then show customers with revenue above 50000.
*/

WITH Customer_Orders AS (
SELECT c.customer_id, o.order_id
FROM customers c 
JOIN orders o 
ON c.Customer_ID = o.Customer_ID
),
Customer_Items AS (
SELECT co.customer_id, oi.unit_price, oi.quantity
FROM Customer_Orders co
JOIN order_items oi
ON co.order_id = oi.Order_Id
),
Customer_Revenue AS (
SELECT customer_id, SUM(unit_price * quantity) as rev
FROM Customer_Items
GROUP by customer_id
)
SELECT * FROM Customer_Revenue
ORDER BY rev;



/*
Q28. Write two CTEs —
CTE1: Daily_Revenue calculating revenue per day.
CTE2: Running_Daily adding a running total to CTE1 using SUM OVER.
Then show all days where running total crossed 100000 for the first time.
*/

WITH Daily_Revenue AS ( SELECT CAST(o.Order_Tms AS DATE) AS Order_Date, SUM(oi.Unit_Price *
oi.Quantity) AS Daily_Rev FROM CO.Orders o INNER JOIN CO.Order_Items oi ON o.Order_Id =
oi.Order_Id GROUP BY CAST(o.Order_Tms AS DATE) ), Running_Daily AS ( SELECT Order_Date,
Daily_Rev, SUM(Daily_Rev) OVER( ORDER BY Order_Date ROWS BETWEEN UNBOUNDED PRECEDING AND
CURRENT ROW ) AS Running_Total, LAG(SUM(Daily_Rev) OVER( ORDER BY Order_Date ROWS BETWEEN
UNBOUNDED PRECEDING AND CURRENT ROW )) OVER(ORDER BY Order_Date) AS Prev_Running FROM
Daily_Revenue ) SELECT Order_Date, Daily_Rev, Running_Total FROM Running_Daily WHERE
Running_Total >= 100000 AND (Prev_Running < 100000 OR Prev_Running IS NULL) ORDER BY
Order_Date;



