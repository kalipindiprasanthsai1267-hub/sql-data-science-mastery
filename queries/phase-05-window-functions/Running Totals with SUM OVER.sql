/*   Q38. Calculate the running total of orders placed over time — ordered by order timestamp. 
Show order ID, order timestamp and cumulative order count.  */

SELECT order_id, order_tms, COUNT(Order_Id) OVER(ORDER BY Order_Tms) AS Cumulative_Order_Count
FROM CO.Orders
ORDER BY Order_Tms;

/*  Q39. Calculate the running total revenue across all orders ordered by timestamp.
 Show order ID, order timestamp, order revenue and cumulative revenue. 
 Join Orders and Order_Items.   */

SELECT Order_Id, Order_Tms, Order_Revenue,
       SUM(Order_Revenue) OVER(ORDER BY Order_Tms) AS Cumulative_Revenue
FROM (
    SELECT o.Order_Id, o.Order_Tms,
           SUM(oi.Unit_Price * oi.Quantity) AS Order_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Order_Id, o.Order_Tms
) AS Order_Totals
ORDER BY Order_Tms;


/*   Q40. Calculate the running total revenue per customer ordered by order timestamp. 
Show customer ID, order ID, order timestamp, order revenue and customer cumulative revenue.  */

SELECT o.customer_id, o.order_id, o.order_tms, 
SUM(oi.unit_price * oi.Quantity) OVER(PARTITION BY o.order_id ORDER BY order_tms) AS Order_revenue,
SUM(oi.unit_price * oi.Quantity) OVER(PARTITION BY o.customer_id ORDER BY order_tms) AS Cusst_cum_rev
FROM orders o 
JOIN order_items oi ON
o.Order_Id=oi.order_id;


/*  Q41. Calculate the running count of orders per store ordered by timestamp. 
Show store ID, order ID, order timestamp and store cumulative order count.   */

SELECT store_id, order_id, order_tms,
COUNT(order_id) OVER(PARTITION BY store_id ORDER BY order_tms) as st_cum_oc
from orders;


/*  Q42. Calculate the running maximum unit price seen so far across all products ordered by product ID. 
Show product ID, product name, unit price and running max price.   */

SELECT Product_Id, Product_Name, Unit_Price,
       MAX(Unit_Price) OVER(
           ORDER BY Product_Id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Running_Max_Price
FROM CO.Products
ORDER BY Product_Id;


/*  Q43. Calculate the running total inventory per store across products ordered by product ID. 
Show store ID, product ID, product inventory and store running inventory total.   */

SELECT store_id, product_id, product_inventory, SUM(product_inventory) OVER(PARTITION BY store_id ORDER BY product_id) AS st_run_tot
FROM inventory;
