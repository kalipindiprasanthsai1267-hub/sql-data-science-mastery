/*
Q29. Write a CTE called Category_Stats that groups products by price bucket —
Budget below 1000, Mid Range 1000 to 10000, Premium above 10000 —
and calculates count and average price per bucket.
Then show the results ordered by average price.
*/

WITH Category_Stats AS 
( SELECT CASE WHEN Unit_Price < 1000 THEN 'Budget' 
			  WHEN Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range' 
              ELSE 'Premium' 
		END AS Price_Bucket, 
        COUNT(*) AS Product_Count, 
        ROUND(AVG(Unit_Price), 2) AS Avg_Price 
        FROM CO.Products 
        GROUP BY CASE WHEN Unit_Price < 1000 THEN 'Budget' 
					  WHEN Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range' 
                      ELSE 'Premium' 
		END ) 
SELECT Price_Bucket, Product_Count, Avg_Price FROM Category_Stats ORDER BY Avg_Price DESC;


/*
Q30. Write a CTE called Monthly_Order_Stats that calculates order count
and total revenue per month.
Then show only months where both order count exceeds 5
and revenue exceeds 50000.
*/

WITH Monthly_Order_Stats AS (EXTRACT(YEAR FROM o.Order_Tms) AS Yr, 
EXTRACT(MONTH FROM o.Order_Tms) AS Mth, 
COUNT(DISTINCT o.Order_Id) AS Order_Count, 
SUM(oi.Unit_Price * oi.Quantity) AS Total_Revenue 
FROM CO.Orders o 
INNER JOIN CO.Order_Items oi 
ON o.Order_Id = oi.Order_Id 
GROUP BY EXTRACT(YEAR FROM o.Order_Tms), EXTRACT(MONTH FROM o.Order_Tms) 
) 
SELECT Yr, Mth, Order_Count, Total_Revenue FROM Monthly_Order_Stats WHERE Order_Count > 5 AND Total_Revenue > 50000 ORDER BY Yr, Mth;


/*
Q31. Write a CTE called Store_Product_Revenue that calculates total
revenue per store per product by joining Stores, Orders and Order_Items.
Then show only store-product combinations where revenue exceeds 5000.
*/

WITH Store_Product_Revenue AS ( 
SELECT o.Store_Id, oi.Product_Id, SUM(oi.Unit_Price * oi.Quantity) AS Revenue 
FROM CO.Orders o 
JOIN CO.Order_Items oi 
ON o.Order_Id = oi.Order_Id 
GROUP BY o.Store_Id, oi.Product_Id 
) 
SELECT s.Store_Name, p.Product_Name, spr.Revenue 
FROM Store_Product_Revenue spr 
JOIN CO.Stores s 
ON spr.Store_Id = s.Store_Id 
JOIN CO.Products p 
ON spr.Product_Id = p.Product_Id 
WHERE spr.Revenue > 5000 
ORDER BY spr.Revenue DESC;


/*
Q32. Write a CTE called Customer_Frequency that calculates order count
and average days between orders per customer.
Then show customers who order more frequently than average —
average days between orders below the overall average.
*/

WITH Customer_Orders AS ( 
SELECT Customer_ID, Order_Tms, LAG(Order_Tms) OVER( PARTITION BY Customer_ID ORDER BY Order_Tms ) AS Prev_Order 
FROM CO.Orders ),
Customer_Frequency AS ( SELECT Customer_ID, COUNT(*) AS Order_Count, ROUND(AVG(DATEDIFF(Order_Tms, Prev_Order)), 1) AS Avg_Days_Between FROM Customer_Orders 
GROUP BY Customer_ID ) 
SELECT c.Full_Name, cf.Order_Count, cf.Avg_Days_Between 
FROM Customer_Frequency cf 
 JOIN CO.Customers c ON cf.Customer_ID = c.Customer_ID 
 WHERE cf.Avg_Days_Between < ( SELECT AVG(Avg_Days_Between) FROM Customer_Frequency ) ORDER BY cf.Avg_Days_Between;


/*
Q33. Write a CTE called Shipment_Summary that counts shipments
per store per status.
Then show only store-status combinations where shipment count exceeds 10.
*/


WITH Shipment_Summary AS (
SELECT Store_Id, Shipment_Status, COUNT(*) AS Shipment_Count 
FROM CO.Shipments 
GROUP BY Store_Id, Shipment_Status ) 
SELECT s.Store_Name, ss.Shipment_Status, ss.Shipment_Count 
FROM Shipment_Summary ss 
JOIN CO.Stores s 
ON ss.Store_Id = s.Store_Id 
WHERE ss.Shipment_Count > 10 
ORDER BY ss.Shipment_Count DESC;