/* Q38. Show each product alongside the overall average unit price of all products and
 the difference between the product price and that average. 
 Show product name, unit price, average price and difference.
  */

SELECT 
product_name, 
unit_price, 
(SELECT AVG (unit_price) FROM products) AS Average_Price, 
(unit_price - (SELECT AVG (unit_price) FROM products)) AS difference
FROM products
GROUP BY Product_Id, Product_Name;

/* Q39. Show each order alongside the total number of orders placed by the same customer. 
Show order ID, customer ID and customer order count.
  */

SELECT o.Order_Id,
       o.Customer_ID,
       (SELECT COUNT(*)
        FROM CO.Orders o1
        WHERE o1.Customer_ID = o.Customer_ID) AS Customer_Order_Count
FROM CO.Orders o
ORDER BY o.Customer_ID;


/*  Q40. Show each store alongside the total number of stores in the database 
and each store's percentage share of total orders. 
Show store ID, store order count, total stores and percentage.
 */
 
 SELECT o.Store_Id,
       COUNT(o.Order_Id) AS Store_Order_Count,
       (SELECT COUNT(*) FROM CO.Stores) AS Total_Stores,
       ROUND(COUNT(o.Order_Id) * 100.0 /
           (SELECT COUNT(*) FROM CO.Orders), 2) AS Order_Percentage
FROM CO.Orders o
GROUP BY o.Store_Id
ORDER BY Order_Percentage DESC;
 