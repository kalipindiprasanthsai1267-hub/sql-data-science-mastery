/*  Q28. Find all products whose unit price is above the average unit price of products in the same price range bucket
 — Budget below 1000, Mid Range 1000 to 10000, Premium above 10000. 
 Show product name, unit price and price bucket.
 */

SELECT p.Product_Name,
       p.Unit_Price,
       CASE WHEN p.Unit_Price < 1000 THEN 'Budget'
            WHEN p.Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range'
            ELSE 'Premium'
       END AS Price_Bucket
FROM CO.Products p
WHERE p.Unit_Price > (
    SELECT AVG(p2.Unit_Price)
    FROM CO.Products p2
    WHERE CASE WHEN p2.Unit_Price < 1000 THEN 'Budget'
               WHEN p2.Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range'
               ELSE 'Premium'
          END
        =
          CASE WHEN p.Unit_Price < 1000 THEN 'Budget'
               WHEN p.Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range'
               ELSE 'Premium'
          END
)
ORDER BY Price_Bucket, p.Unit_Price DESC;


/* Q29. Find the most recent order placed by each customer. 
Show customer ID and order timestamp. 
Use a correlated subquery.
  */

SELECT customer_id, order_tms
FROM orders o
WHERE order_tms IN (SELECT MAX(order_tms) FROM orders o1 WHERE o.customer_id = o1.Customer_ID);



/* Q30. Find all orders where the total order value (sum of unit price times quantity in order items)
 is above the average order value across all orders. 
 Show order ID and total value.
  */

SELECT oi.Order_Id,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Value
FROM CO.Order_Items oi
GROUP BY oi.Order_Id
HAVING SUM(oi.Quantity * oi.Unit_Price) > (
    SELECT AVG(Order_Total)
    FROM (
        SELECT SUM(oi1.Quantity * oi1.Unit_Price) AS Order_Total
        FROM CO.Order_Items oi1
        GROUP BY oi1.Order_Id
    ) AS Order_Totals
);


/* Q31. Find all customers who have spent more than the average spending of all customers. 
Show full name and total spending.
  */

SELECT c.Full_Name,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Spending
FROM CO.Customers c
INNER JOIN CO.Orders o
ON c.Customer_ID = o.Customer_ID
INNER JOIN CO.Order_Items oi
ON o.Order_Id = oi.Order_Id
GROUP BY c.Customer_ID, c.Full_Name
HAVING SUM(oi.Quantity * oi.Unit_Price) > (
    SELECT AVG(Total_Spending)
    FROM (
        SELECT o1.Customer_ID,
               SUM(oi1.Quantity * oi1.Unit_Price) AS Total_Spending
        FROM CO.Orders o1
        INNER JOIN CO.Order_Items oi1
        ON o1.Order_Id = oi1.Order_Id
        GROUP BY o1.Customer_ID
    ) AS Customer_Spending
)
ORDER BY Total_Spending DESC;


/* Q32. For each product, find whether its unit price is above or 
below the average unit price of all products — label it Above Average or Below Average. 
Show product name, unit price and label.
  */
  
SELECT p.Product_Name,
       p.Unit_Price,
       CASE WHEN p.Unit_Price > (SELECT AVG(Unit_Price) FROM CO.Products)
            THEN 'Above Average'
            WHEN p.Unit_Price < (SELECT AVG(Unit_Price) FROM CO.Products)
            THEN 'Below Average'
            ELSE 'At Average'
       END AS Label
FROM CO.Products p
ORDER BY p.Unit_Price DESC;
   
  