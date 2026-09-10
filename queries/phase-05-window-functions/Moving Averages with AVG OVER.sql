/*   Q44. Calculate a 3-row moving average of unit prices across all products ordered by unit price. 
Show product name, unit price and 3-row moving average. 
Use ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.  */

SELECT product_Name, unit_price, AVG(unit_price) OVER(ORDER BY unit_price ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Mov_Avg
FROM products;


/*  Q45. Calculate a 3-order moving average revenue per customer ordered by timestamp. 
Show customer ID, order ID, order revenue and 3-order moving average revenue.   */

SELECT Customer_ID, Order_Id, Order_Revenue,
       ROUND(AVG(Order_Revenue) OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Tms
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS Moving_Avg_Revenue
FROM (
    SELECT o.Customer_ID, o.Order_Id, o.Order_Tms,
           SUM(oi.Unit_Price * oi.Quantity) AS Order_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Customer_ID, o.Order_Id, o.Order_Tms
) AS Order_Totals
ORDER BY Customer_ID, Order_Tms;

/*   Q46. Calculate the average unit price of the current product and the two products before it ordered by product ID. 
Show product ID, product name, unit price and moving average.  */

SELECT product_id, Product_Name, unit_price, AVG(Unit_price)OVER(ORDER BY Product_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Mov_Avg
FROM Products;


/*  Q47. Calculate a 5-row moving average of inventory quantities across all inventory records ordered by inventory ID. 
Show inventory ID, store ID, product inventory and 5-row moving average.   */

SELECT inventory_id, store_id, product_inventory, AVG(product_inventory) OVER(ORDER BY inventory_id ROWS BETWEEN CURRENT ROW AND 4	 FOLLOWING) AS MOV_AVG
FROM inventory;


/*   Q48. Calculate the moving average of order item unit prices within each order — using the current row and all previous rows in the order. 
Show order ID, line item, unit price and running average price within order.  */

SELECT order_id, Line_Item_Id, unit_price, AVG(unit_price) OVER(PARTITION BY order_Id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM order_Items;