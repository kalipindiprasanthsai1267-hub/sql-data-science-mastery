/*  Q49. Calculate the sum of unit prices for the current product and the next 2 products ordered by unit price ascending.
 Use ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING. 
 Show product name, unit price and forward sum.   */

SELECT product_name, unit_Price, SUM(unit_price) OVER(ORDER BY unit_price ASC ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
FROM products;



/*  Q50. Calculate the sum of revenues for the current order and the previous 3 orders using ROWS BETWEEN 3 PRECEDING AND CURRENT ROW.
 Show order ID, order timestamp, revenue and rolling 4-order revenue sum.   */

SELECT order_id, order_tms, revenue, SUM(revenue) OVER(ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
FROM (SELECT o.order_id, o.order_tms,SUM(oi.unit_price * oi.quantity) AS revenue FROM orders o JOIN order_items oi on o.Order_Id = oi.Order_Id GROUP BY order_id) a;



/*  Q51. Calculate the total revenue for the entire partition using ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING. 
Show order ID, store ID, revenue and store total revenue.   */

SELECT Order_Id, Store_Id, Revenue,
       SUM(Revenue) OVER(
           PARTITION BY Store_Id
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS Store_Total_Revenue
FROM (
    SELECT o.Order_Id, o.Store_Id,
           SUM(oi.Quantity * oi.Unit_Price) AS Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Order_Id, o.Store_Id
) AS Order_Revenue
ORDER BY Store_Id, Order_Id;


/*   Q52. Show the difference between ROWS BETWEEN and RANGE BETWEEN by writing two queries
 — one using ROWS and one using RANGE — on order revenues ordered by order timestamp. 
Explain the difference in results.  */



/*  Q53. Calculate a centered moving average
 — average of the previous row, current row and next row — using ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING. 
Show product ID, unit price and centered average.   */

SELECT product_id, unit_price, AVG(unit_price) OVER (ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
From products;