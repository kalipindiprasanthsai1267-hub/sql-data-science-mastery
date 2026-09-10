/* Q21. Retrieve all customers and all orders — matched where possible. 
Show NULLs where no match exists on either side. Show customer name and order ID. */


SELECT c.Customer_ID, c.Full_Name, o.Order_Id
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
UNION
SELECT c.Customer_ID, c.Full_Name, o.Order_Id
FROM Customers c
RIGHT JOIN Orders o
ON c.Customer_ID = o.Customer_ID;

/* Q22. Retrieve all products and all order items — matched where possible. 
Include products never ordered and order items with no matching product. */

SELECT p.Product_Id, p.Product_Name, oi.Quantity
FROM products p
LEFT JOIN order_items oi
ON p.Product_Id = oi.Product_Id
UNION
SELECT p.Product_Id, p.Product_Name, oi.Quantity
FROM products p
RIGHT JOIN order_items oi
ON p.Product_Id = oi.Product_Id;

/* Q23. Retrieve all stores and all shipments — matched where possible. 
Include stores with no shipments and shipments with no matching store. */

SELECT st.Store_Id, st.Store_Name, s.Shipment_Id
FROM stores st
LEFT JOIN shipments s
ON st.Store_Id = s.Store_Id
UNION
SELECT st.Store_Id, st.Store_Name, s.Shipment_Id
FROM stores st
RIGHT JOIN shipments s
ON st.Store_Id = s.Store_Id;

/* Q24. From Q21 result — identify which rows are unmatched on either side. Show:
Customers with no orders
Orders with no matching customer
All in a single query. */

-- Half 1: Customers with no orders
SELECT c.Customer_ID, c.Full_Name,
       o.Order_Id,
       'Customer with No Order' AS Unmatched_Type
FROM CO.Customers c
LEFT JOIN CO.Orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Id IS NULL

UNION

-- Half 2: Orders with no matching customer
SELECT c.Customer_ID, c.Full_Name,
       o.Order_Id,
       'Order with No Customer' AS Unmatched_Type
FROM CO.Customers c
RIGHT JOIN CO.Orders o
ON c.Customer_ID = o.Customer_ID
WHERE c.Customer_ID IS NULL;