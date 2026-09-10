/*
Q39. Find customers who placed orders in 2023 but not in 2024 using CTEs.
Write CTE1 for 2023 customers and CTE2 for 2024 customers.
Then use LEFT JOIN to find those in CTE1 but not in CTE2.
*/

WITH Orders_2023 AS ( 
SELECT DISTINCT Customer_ID 
FROM CO.Orders 
WHERE YEAR(Order_Tms) = 2023 ),
 Orders_2024 AS ( SELECT DISTINCT Customer_ID FROM CO.Orders WHERE YEAR(Order_Tms) = 2024 ) 
 SELECT c.Full_Name, c.Customer_ID FROM CO.Customers c 
 JOIN Orders_2023 o23 
 ON c.Customer_ID = o23.Customer_ID 
 LEFT JOIN Orders_2024 o24 
 ON c.Customer_ID = o24.Customer_ID 
 WHERE o24.Customer_ID IS NULL 
 ORDER BY c.Full_Name;

/*
Q40. Find the month with the highest revenue in each year using CTEs.
Write CTE1 for monthly revenue.
Write CTE2 for ranking months within each year by revenue.
Then show only rank 1 per year.
*/

WITH Monthly_Revenue AS ( 
SELECT EXTRACT(YEAR FROM o.Order_Tms) AS Yr, 
EXTRACT(MONTH FROM o.Order_Tms) AS Mth, SUM(oi.Unit_Price * oi.Quantity) AS Revenue 
FROM CO.Orders o 
 JOIN CO.Order_Items oi 
 ON o.Order_Id = oi.Order_Id 
 GROUP BY EXTRACT(YEAR FROM o.Order_Tms), EXTRACT(MONTH FROM o.Order_Tms) ), 
 Month_Ranked AS ( SELECT Yr, Mth, Revenue, RANK() OVER( PARTITION BY Yr ORDER BY Revenue DESC ) AS Mth_Rank FROM Monthly_Revenue ) 
 SELECT Yr, Mth, Revenue FROM Month_Ranked WHERE Mth_Rank = 1 ORDER BY Yr;

/*
Q41. Find customers whose spending increased from their first order
to their most recent order using CTEs.
Write CTE1 for first order revenue per customer.
Write CTE2 for last order revenue per customer.
Then show customers where last revenue is greater than first.
*/

WITH First_Order AS ( 
SELECT Customer_ID, Order_Id, Order_Tms 
FROM ( SELECT Customer_ID, Order_Id, Order_Tms, ROW_NUMBER() OVER( PARTITION BY Customer_ID ORDER BY Order_Tms ) AS Rn FROM CO.Orders ) r WHERE Rn = 1 ), 
Last_Order AS ( SELECT Customer_ID, Order_Id, Order_Tms 
FROM ( SELECT Customer_ID, Order_Id, Order_Tms, ROW_NUMBER() OVER( PARTITION BY Customer_ID ORDER BY Order_Tms DESC ) AS Rn FROM CO.Orders ) r WHERE Rn = 1 ), 
Order_Revenue AS ( SELECT Order_Id, SUM(Unit_Price * Quantity) AS Revenue FROM CO.Order_Items GROUP BY Order_Id ) 
SELECT c.Full_Name, fr.Revenue AS First_Revenue, lr.Revenue AS Last_Revenue FROM CO.Customers c 
 JOIN First_Order fo 
 ON c.Customer_ID = fo.Customer_ID 
 JOIN Last_Order lo 
 ON c.Customer_ID = lo.Customer_ID 
 JOIN Order_Revenue fr 
 ON fo.Order_Id = fr.Order_Id 
 JOIN Order_Revenue lr ON lo.Order_Id = lr.Order_Id 
 WHERE lr.Revenue > fr.Revenue ORDER BY (lr.Revenue - fr.Revenue) DESC;

/*
Q42. Find products that were stocked in every store using CTEs.
Write CTE1 counting distinct stores per product from Inventory.
Write CTE2 getting total store count.
Then show products where their store count equals the total store count.
*/

WITH Product_Store_Count AS ( 
SELECT i.Product_Id, COUNT(DISTINCT i.Store_Id) AS Stores_With_Product 
FROM CO.Inventory i GROUP BY i.Product_Id ), 
Total_Stores AS ( SELECT COUNT(*) AS Store_Count FROM CO.Stores ) 
SELECT p.Product_Name, psc.Stores_With_Product FROM Product_Store_Count psc 
CROSS JOIN Total_Stores ts 
 JOIN CO.Products p 
 ON psc.Product_Id = p.Product_Id 
 WHERE psc.Stores_With_Product = ts.Store_Count 
 ORDER BY p.Product_Name;


/*
Q43. Find the top 3 revenue generating customers per store using CTEs.
Write CTE1 for revenue per customer per store.
Write CTE2 ranking customers within each store by revenue.
Then filter for rank <= 3.
*/

WITH Customer_Store_Revenue AS ( 
SELECT o.Store_Id, o.Customer_ID, SUM(oi.Unit_Price * oi.Quantity) AS Revenue FROM CO.Orders o 
 JOIN CO.Order_Items oi ON o.Order_Id = oi.Order_Id GROUP BY o.Store_Id, o.Customer_ID ), 
 Customer_Store_Ranked AS ( SELECT Store_Id, Customer_ID, Revenue, RANK() OVER( PARTITION BY Store_Id ORDER BY Revenue DESC ) AS Store_Rank FROM Customer_Store_Revenue ) 
 SELECT s.Store_Name, c.Full_Name, csr.Revenue, csr.Store_Rank FROM Customer_Store_Ranked csr 
 JOIN CO.Stores s 
 ON csr.Store_Id = s.Store_Id 
 JOIN CO.Customers c 
 ON csr.Customer_ID = c.Customer_ID 
 WHERE csr.Store_Rank <= 3 
 ORDER BY s.Store_Name, csr.Store_Rank;


/*
Q44. Find stores where revenue grew month over month
for at least 3 consecutive months using CTEs.
Write CTE1 for monthly revenue per store.
Write CTE2 adding LAG for previous month revenue.
Write CTE3 flagging months where revenue increased.
Then filter stores with 3 or more consecutive growth flags.
*/

WITH Monthly_Store_Revenue AS ( 
SELECT o.Store_Id, EXTRACT(YEAR FROM o.Order_Tms) AS Yr, EXTRACT(MONTH FROM o.Order_Tms) AS Mth, SUM(oi.Unit_Price * oi.Quantity) AS Revenue 
FROM CO.Orders o 
 JOIN CO.Order_Items oi 
 ON o.Order_Id = oi.Order_Id 
 GROUP BY o.Store_Id, EXTRACT(YEAR FROM o.Order_Tms), EXTRACT(MONTH FROM o.Order_Tms) ), 
 With_Prev AS ( SELECT Store_Id, Yr, Mth, Revenue, LAG(Revenue) OVER( PARTITION BY Store_Id ORDER BY Yr, Mth ) AS Prev_Revenue FROM Monthly_Store_Revenue ), 
 Growth_Flag AS ( SELECT Store_Id, Yr, Mth, Revenue, CASE WHEN Revenue > Prev_Revenue THEN 1 ELSE 0 END AS Grew FROM With_Prev ), 
 Consecutive_Growth AS ( SELECT Store_Id, SUM(Grew) OVER( PARTITION BY Store_Id ORDER BY Yr, Mth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS Consec_Growth FROM Growth_Flag ) 
 SELECT DISTINCT s.Store_Name FROM Consecutive_Growth cg INNER JOIN CO.Stores s ON cg.Store_Id = s.Store_Id WHERE cg.Consec_Growth = 3 ORDER BY s.Store_Name;