/*
PHASE 2 — AGGREGATIONS
Practice File: COUNT, SUM, AVG, MIN, MAX and GROUP BY
*/

/*
Q1. Count the total number of customers.
*/
SELECT COUNT(*) AS Total_Customers
FROM CO.Customers;


/*
Q2. Count the total number of orders.
*/
SELECT COUNT(*) AS Total_Orders
FROM CO.Orders;


/*
Q3. Find the total revenue from all order items.
*/
SELECT SUM(Quantity * Unit_Price) AS Total_Revenue
FROM CO.Order_Items;


/*
Q4. Find the average product price.
*/
SELECT AVG(Unit_Price) AS Average_Product_Price
FROM CO.Products;


/*
Q5. Find the cheapest and most expensive products.
*/
SELECT MIN(Unit_Price) AS Cheapest_Price,
       MAX(Unit_Price) AS Most_Expensive_Price
FROM CO.Products;


/*
Q6. Count the number of orders for each order status.
*/
SELECT Order_Status,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY Order_Status;


/*
Q7. Count the number of orders for each store.
*/
SELECT Store_Id,
       COUNT(*) AS Order_Count
FROM CO.Orders
GROUP BY Store_Id
ORDER BY Order_Count DESC;


/*
Q8. Calculate revenue per order.
*/
SELECT Order_Id,
       SUM(Quantity * Unit_Price) AS Order_Revenue
FROM CO.Order_Items
GROUP BY Order_Id
ORDER BY Order_Revenue DESC;


/*
Q9. Calculate total quantity sold per product.
*/
SELECT Product_Id,
       SUM(Quantity) AS Total_Quantity_Sold
FROM CO.Order_Items
GROUP BY Product_Id
ORDER BY Total_Quantity_Sold DESC;


/*
Q10. Calculate average unit price per product.
*/
SELECT Product_Id,
       AVG(Unit_Price) AS Average_Unit_Price
FROM CO.Order_Items
GROUP BY Product_Id
ORDER BY Average_Unit_Price DESC;


/*
Q11. Count how many inventory records each store has.
*/
SELECT Store_Id,
       COUNT(*) AS Inventory_Record_Count
FROM CO.Inventory
GROUP BY Store_Id
ORDER BY Store_Id;


/*
Q12. Calculate total inventory quantity per store.
*/
SELECT Store_Id,
       SUM(Inventory_Qty) AS Total_Inventory
FROM CO.Inventory
GROUP BY Store_Id
ORDER BY Total_Inventory DESC;


/*
Q13. Find the maximum inventory quantity for each product.
*/
SELECT Product_Id,
       MAX(Inventory_Qty) AS Max_Inventory
FROM CO.Inventory
GROUP BY Product_Id
ORDER BY Max_Inventory DESC;


/*
Q14. Count the number of orders per customer.
*/
SELECT Customer_ID,
       COUNT(*) AS Total_Orders
FROM CO.Orders
GROUP BY Customer_ID
ORDER BY Total_Orders DESC;


/*
Q15. Calculate total order value per customer using order items.
*/
SELECT o.Customer_ID,
       SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM CO.Orders o
INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
GROUP BY o.Customer_ID
ORDER BY Total_Revenue DESC;
