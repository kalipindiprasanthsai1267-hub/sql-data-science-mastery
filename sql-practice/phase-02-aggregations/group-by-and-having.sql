/*
PHASE 2 — AGGREGATIONS
Practice File: GROUP BY, HAVING and business summaries
*/

/*
Q16. Find customers who placed more than 5 orders.
*/
SELECT Customer_ID,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY Customer_ID
HAVING COUNT(*) > 5
ORDER BY Order_Count DESC;


/*
Q17. Find stores with more than 100 orders.
*/
SELECT Store_Id,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY Store_Id
HAVING COUNT(*) > 100
ORDER BY Order_Count DESC;


/*
Q18. Find products with total quantity sold above 50.
*/
SELECT Product_Id,
       SUM(Quantity) AS Total_Quantity
FROM CO.Order_Items
GROUP BY Product_Id
HAVING SUM(Quantity) > 50
ORDER BY Total_Quantity DESC;


/*
Q19. Find products whose average selling price is above 5000.
*/
SELECT Product_Id,
       AVG(Unit_Price) AS Average_Selling_Price
FROM CO.Order_Items
GROUP BY Product_Id
HAVING AVG(Unit_Price) > 5000
ORDER BY Average_Selling_Price DESC;


/*
Q20. Find customers whose total revenue is above 50000.
*/
SELECT o.Customer_ID,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY o.Customer_ID
HAVING SUM(oi.Quantity * oi.Unit_Price) > 50000
ORDER BY Total_Revenue DESC;


/*
Q21. Find stores with total inventory above 1000 units.
*/
SELECT Store_Id,
       SUM(Inventory_Qty) AS Total_Inventory
FROM CO.Inventory
GROUP BY Store_Id
HAVING SUM(Inventory_Qty) > 1000
ORDER BY Total_Inventory DESC;


/*
Q22. For each order, calculate total quantity and total revenue.
*/
SELECT Order_Id,
       SUM(Quantity) AS Total_Items,
       SUM(Quantity * Unit_Price) AS Order_Revenue
FROM CO.Order_Items
GROUP BY Order_Id
ORDER BY Order_Revenue DESC;


/*
Q23. Show the top 10 orders by revenue.
*/
SELECT Order_Id,
       SUM(Quantity * Unit_Price) AS Order_Revenue
FROM CO.Order_Items
GROUP BY Order_Id
ORDER BY Order_Revenue DESC
LIMIT 10;


/*
Q24. Count completed orders per store.
*/
SELECT Store_Id,
       COUNT(*) AS Completed_Orders
FROM CO.Orders
WHERE Order_Status = 'Completed'
GROUP BY Store_Id
ORDER BY Completed_Orders DESC;


/*
Q25. Calculate total revenue per store.
*/
SELECT o.Store_Id,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY o.Store_Id
ORDER BY Total_Revenue DESC;


/*
Q26. Find stores with total revenue above 100000.
*/
SELECT o.Store_Id,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY o.Store_Id
HAVING SUM(oi.Quantity * oi.Unit_Price) > 100000
ORDER BY Total_Revenue DESC;


/*
Q27. Calculate minimum, maximum and average order-item price
     for each product.
*/
SELECT Product_Id,
       MIN(Unit_Price) AS Min_Price,
       MAX(Unit_Price) AS Max_Price,
       AVG(Unit_Price) AS Avg_Price
FROM CO.Order_Items
GROUP BY Product_Id
ORDER BY Product_Id;


/*
Q28. Find customers with at least 3 orders and total revenue
     above 20000.
*/
SELECT o.Customer_ID,
       COUNT(DISTINCT o.Order_Id) AS Total_Orders,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY o.Customer_ID
HAVING COUNT(DISTINCT o.Order_Id) >= 3
   AND SUM(oi.Quantity * oi.Unit_Price) > 20000
ORDER BY Total_Revenue DESC;
