/*Retrieve the full name and email address of all customers along with their order ID and order status. 
 Only show customers who have placed at least one order.*/
 
SELECT c.Full_Name, c.Email_Address,
       o.Order_Id, o.Order_Status
FROM Customers c
INNER JOIN Orders o
ON c.Customer_ID = o.Customer_ID
ORDER BY c.Full_Name;

/* Q2. Retrieve the order ID, order timestamp, and the store name for every order.
 Only show orders that have a matching store. */

SELECT o.Order_Id, o.Order_Tms, s.Store_Name
FROM orders o
INNER JOIN stores s ON
o.Store_Id = s.Store_Id;

/* Q3. Retrieve the order ID, line item number, product name, and unit price from order items. 
Only show items that have a matching product in the products table.*/

SELECT oi.Order_Id, oi.Line_Item_Id, p.Product_Name, oi.Unit_Price
FROM order_items oi
JOIN products p
ON oi.Product_Id = p.Product_Id;

/* Q4. Retrieve the shipment ID, delivery address, shipment status, and the store name where the shipment was dispatched from. 
Only show shipments with a matching store. */

SELECT s.Shipment_Id, s.Delivery_Address, s.Shipment_Status, st.Store_Name
FROM shipments s
JOIN stores st
ON s.Store_Id = st.Store_Id;

/* Q5. Retrieve the store name, product name, and inventory quantity for all store-product combinations that have inventory records. */

SELECT 
    s.Store_Name, 
    p.Product_Name, 
    i.Product_Inventory
FROM CO.INVENTORY i
INNER JOIN CO.STORES s 
    ON i.Store_Id = s.Store_Id
INNER JOIN CO.PRODUCTS p 
    ON i.Product_Id = p.Product_Id;

/* Q6. Retrieve the customer full name, order ID, order status, and store name for all complete orders. 
Only show complete orders with matching customers and stores. */

SELECT c.Full_Name, o.Order_Id, o.Order_Status, s.Store_Name
FROM customers c
INNER JOIN orders o 
ON c.customer_id = o.Customer_ID
INNER JOIN stores s 
ON o.Store_Id = s.Store_Id
WHERE LOWER(Order_Status) = 'complete'
ORDER BY c.Full_Name;

/* Q7. Retrieve the order ID, product name, quantity ordered, and the unit price charged — for all order items. 
Calculate a total price column as well. */

SELECT 
    oi.Order_Id, 
    p.Product_Name, 
    oi.Quantity, 
    oi.Unit_Price AS Charged_Price,
    (oi.Quantity * oi.Unit_Price) AS Total_Line_Price
FROM CO.ORDER_ITEMS oi
INNER JOIN CO.PRODUCTS p 
    ON oi.Product_Id = p.Product_Id;


/* Q8. Retrieve the full name of the customer, the store name they ordered from, the product name they ordered, 
and the quantity — for every order item. 
This requires joining 4 tables — Customers, Orders, Order_Items and Products. */

SELECT 
    c.Full_Name, 
    s.Store_Name, 
    p.Product_Name, 
    oi.Quantity
FROM CO.ORDER_ITEMS oi
INNER JOIN CO.ORDERS o 
    ON oi.Order_Id = o.Order_Id
INNER JOIN CO.CUSTOMERS c 
    ON o.Customer_ID = c.Customer_ID
INNER JOIN CO.STORES s 
    ON o.Store_Id = s.Store_Id
INNER JOIN CO.PRODUCTS p 
    ON oi.Product_Id = p.Product_Id;