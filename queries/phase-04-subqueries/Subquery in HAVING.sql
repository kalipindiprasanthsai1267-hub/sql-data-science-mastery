/*  Q41. Find all customers whose total spending is above the average total spending across all customers. 
Use a subquery in HAVING. Show customer ID and total spending.
 */

SELECT o.Customer_ID,
       SUM(oi.Unit_Price * oi.Quantity) AS Total_Spending
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
ON o.Order_Id = oi.Order_Id
GROUP BY o.Customer_ID
HAVING SUM(oi.Unit_Price * oi.Quantity) > (
    SELECT AVG(Customer_Total)
    FROM (
        SELECT SUM(oi1.Unit_Price * oi1.Quantity) AS Customer_Total
        FROM CO.Orders o1
        INNER JOIN CO.Order_Items oi1
        ON o1.Order_Id = oi1.Order_Id
        GROUP BY o1.Customer_ID
    ) AS Customer_Totals
)
ORDER BY Total_Spending DESC;


/* Q42. Find all products whose total quantity ordered is above the average total quantity ordered per product. 
Use a subquery in HAVING. Show product ID and total quantity.
  */

 
SELECT oi.Product_ID,
       SUM(oi.Quantity) AS Total_Quantity
FROM CO.Order_Items oi
GROUP BY oi.Product_ID
HAVING SUM(oi.Quantity) > (
    SELECT AVG(Product_Total)
    FROM (
        SELECT SUM(oi1.Quantity) AS Product_Total
        FROM CO.Order_Items oi1
        GROUP BY oi1.Product_ID
    ) AS Product_Totals
)
ORDER BY Total_Quantity DESC;

/* Q43. Find all stores whose total revenue is above the average store revenue. 
Use a subquery in HAVING. Show store ID and total revenue.
  */
  
  
  SELECT o.Store_Id,
       ROUND(SUM(oi.Unit_Price * oi.Quantity), 2) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
ON o.Order_Id = oi.Order_Id
GROUP BY o.Store_Id
HAVING SUM(oi.Unit_Price * oi.Quantity) > (
    SELECT AVG(Store_Revenue)
    FROM (
        SELECT SUM(oi1.Unit_Price * oi1.Quantity) AS Store_Revenue
        FROM CO.Orders o1
        INNER JOIN CO.Order_Items oi1
        ON o1.Order_Id = oi1.Order_Id
        GROUP BY o1.Store_Id
    ) AS Store_Totals
)
ORDER BY Total_Revenue DESC;