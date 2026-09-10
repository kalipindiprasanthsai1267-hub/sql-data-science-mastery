/*  Q1. Show each product alongside the total count of all products in the table. 
Use a window function with OVER(). 
Show product name, unit price and total product count.   */


SELECT product_name, unit_price, COUNT(*) OVER()
FROM products;


/*  Q2. Show each order alongside the total number of orders in the entire Orders table. 
Use OVER(). 
Show order ID, customer ID and total order count.   */

SELECT order_id, customer_id, COUNT(*) OVER() as total_order_count
FROM orders;


/*  Q3. Show each product alongside the maximum unit price across all products. 
Use MAX() OVER(). 
Show product name, unit price and max price.  */

SELECT product_name, unit_price, MAX(unit_price) OVER() as max_price
FROM products;


/*  Q4. Show each order item alongside the minimum unit price across all order items.
 Use MIN() OVER(). 
 Show order ID, product ID, unit price and min price.   */

SELECT order_id, product_id, unit_price, MIN(unit_price) OVER() as Min_price
FROM order_items;


/*   Q5. Show each product alongside the sum of all product unit prices and the average unit price across all products. 
Use SUM() OVER() and AVG() OVER(). 
Show product name, unit price, total price sum and average price.  */


SELECT product_name, unit_price, SUM(unit_price) OVER() AS total_price_sum, AVG(unit_price) over() as Avg_price
FROM products;

