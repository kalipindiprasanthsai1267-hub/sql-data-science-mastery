/* Q25. Find all pairs of customers who share the same email domain. 
Show Customer 1 name, Customer 2 name, and the shared domain. Use SELF JOIN on the Customers table. */

SELECT c1.Full_Name AS Customer_1,
       c2.Full_Name AS Customer_2,
       SUBSTRING_INDEX(c1.Email_Address, '@', -1) AS Shared_Domain
FROM CO.Customers c1
INNER JOIN CO.Customers c2
ON SUBSTRING_INDEX(c1.Email_Address, '@', -1)
 = SUBSTRING_INDEX(c2.Email_Address, '@', -1)
AND c1.Customer_ID < c2.Customer_ID
ORDER BY Shared_Domain;

/* Q26. Find all pairs of products that have the same unit price. Show Product 1 name, Product 2 name, and the shared price. 
Avoid duplicates and self matches. */

SELECT p1.Product_Id, p1.Product_Name, p1.Unit_Price
FROM products p1
INNER JOIN products p2
ON p1.Unit_Price = p2.Unit_Price
AND p1.Product_Id < p2.Product_Id;

/* Q27. Find all pairs of orders placed by the same customer. 
Show the customer ID, Order 1 ID, Order 2 ID, and Order 1 status and Order 2 status. 
Avoid duplicate pairs. */

SELECT o1.Customer_ID,
       o1.Order_Id AS Order_1_ID,
       o2.Order_Id AS Order_2_ID,
       o1.Order_Status AS Order_1_Status,
       o2.Order_Status AS Order_2_Status
FROM CO.Orders o1
INNER JOIN CO.Orders o2
ON o1.Customer_ID = o2.Customer_ID
AND o1.Order_Id < o2.Order_Id
ORDER BY o1.Customer_ID;

/* Q28. Find all products where one product's unit price is exactly double another product's unit price. 
Show the cheaper product name, the expensive product name, and both prices. */

SELECT p1.Product_Name AS Cheaper_Product,
       p1.Unit_Price AS Cheaper_Price,
       p2.Product_Name AS Expensive_Product,
       p2.Unit_Price AS Expensive_Price
FROM CO.Products p1
INNER JOIN CO.Products p2
ON p2.Unit_Price = p1.Unit_Price * 2
ORDER BY p1.Unit_Price;
