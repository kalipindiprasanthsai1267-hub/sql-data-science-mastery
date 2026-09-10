/*   Q12. Assign a row number to each product ordered by unit price descending. 
Show product name, unit price and row number.  */

SELECT p.Product_Name, p.Unit_Price, ROW_NUMBER() OVER(order by p.Unit_Price DESC)
FROM products p;


/*   Q13. Assign a row number to each order within each customer — ordered by order timestamp. 
Show customer ID, order ID, order timestamp and row number within customer.  */

SELECT o.Customer_ID, o.Order_Id, o.Order_Tms AS Order_TimeStamp, 
ROW_NUMBER() OVER(Partition By o.customer_id ORDER BY o.order_tms) as NUM
FROM orders o;


/*  Q14. Find the most recent order placed by each customer using ROW_NUMBER.
 Show customer ID, order ID and order timestamp. Only show the first row per customer.   */

SELECT Customer_ID, Order_Id, Order_Tms
FROM (
    SELECT o.Customer_ID, o.Order_Id, o.Order_Tms,
           ROW_NUMBER() OVER(
               PARTITION BY o.Customer_ID
               ORDER BY o.Order_Tms DESC
           ) AS Row_Num
    FROM CO.Orders o
) ranked
WHERE Row_Num = 1
ORDER BY Customer_ID;

/*  Q15. Assign a row number to each order item within each order — ordered by unit price descending.
 Show order ID, product ID, unit price and row number within order.   */

SELECT order_id, product_id, unit_price, ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY unit_price DESC) ROW_NUM_EACH_ORDER
FROM order_items;


/*  Q16. Find the most expensive item in each order using ROW_NUMBER. 
Show order ID, product ID, unit price. Only show the first row per order.   */

SELECT order_id, product_id, unit_price
FROM ( SELECT order_id, product_id, unit_price, ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY unit_price DESC) AS ROW_NUM_EACH_ORDER FROM order_items) as rnk
WHERE ROW_NUM_EACH_ORDER = 1;
