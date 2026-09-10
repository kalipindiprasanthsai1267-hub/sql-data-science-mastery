/*
Q7. Write a CTE called Order_Revenue that calculates total revenue
per order using Order_Items.
Then in the main query show only orders where revenue exceeds 50000.
*/

WITH Order_Revenue AS(
SELECT
Order_id,
SUM(Unit_Price * Quantity) AS Total_Revenue
FROM Order_items
Group by order_id
)
SELECT * FROM Order_Revenue 
WHERE Total_Revenue > 50000;

/*
Q8. Write a CTE called Customer_Spending that calculates total
spending per customer.
Then show only customers who spent more than 100000.
*/

WITH Customer_Spending AS(
SELECT c.Customer_Id,
Sum(oi.quantity * oi.unit_price) AS Total_spending 
From customers c 
Join orders o on 
c.customer_id = o.customer_id
Join order_items oi
On o.order_id = oi.order_id
)
Select customer_id, Total_spending 
From Customer_Spending
Where total_spending > 100000;


/*
Q9. Write a CTE called Store_Order_Count that counts orders per store.
Then show only stores with more than 20 orders.
*/

WITH Store_Order_Count AS (
Select store_id, count(*) as order_per_store
From orders
Group by store_id
)
Select store_id, order_per_store
From store_order_count
Where order_per_store > 20;

/*
Q10. Write a CTE called Product_Revenue that calculates total revenue
per product.
Then show only products that generated more than 10000 in revenue.
*/
WITH Product_Revenue AS (
SELECT p.Product_id, 
Sum(oi.quantity * unit_price) as revenue
From Products p
Join order_items oi
On p.product_id = oi.product_id
Group by product_id
)
Select product_id, revenue 
From product_revenue
Where revenue > 10000;


/*
Q11. Write a CTE called Customer_Order_Count that counts orders
per customer.
Then show only customers who placed exactly 3 orders.
*/

WITH Customer_Order_Count AS (
SELECT Customer_id, COUNT(*) As order_count
From orders 
Group by customer_id
) 
Select customer_id, order_count
From Customer_Order_Count
Where order_count = 3;