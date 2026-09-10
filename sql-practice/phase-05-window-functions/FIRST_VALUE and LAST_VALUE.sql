/*  Q34. For each order item, show the product name of the most expensive item in the same order using FIRST_VALUE ordered by unit price descending. 
Show order ID, product ID, unit price and most expensive product name in that order.   */

SELECT oi.order_id, oi.product_id,p.Product_Name, oi.unit_price, FIRST_VALUE(p.product_Name) OVER(PARTITION BY order_id ORDER BY Unit_Price DESC) AS Expensive_prod_name
FROM order_items oi
JOIN products p
ON oi.Product_Id = p.Product_Id;


/*  Q35. For each order placed by a customer, show the timestamp of their very first order using FIRST_VALUE. 
Show customer ID, order ID, current order timestamp and first order timestamp.   */

SELECT customer_id, order_id, order_tms, FIRST_VALUE(order_tms) OVER(PARTITION BY customer_id ORDER BY order_tms) as first_order_tms
FROM orders;


/*   Q36. For each order placed by a customer, show the timestamp of their most recent order using LAST_VALUE. 
Show customer ID, order ID, current order timestamp and last order timestamp. 
Remember to use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.  */

SELECT customer_id, order_id, order_tms, LAST_VALUE(order_tms) OVER(PARTITION BY Customer_id ORDER BY order_tms ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_tmsp
FROM orders;



/*  Q37. For each product in inventory, show the store with the highest inventory for that product using FIRST_VALUE ordered by product inventory descending.
 Show product ID, store ID, inventory quantity and max inventory store ID.   */
 
 SELECT product_id, store_id, product_inventory, FIRST_VALUE(store_id) OVER(PARTITION BY product_id ORDER BY product_inventory DESC) as Max_inven_store_id
 FROM inventory;	
 