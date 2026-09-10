/* Q17. Retrieve all orders along with customer details. 
Include orders even if the customer record is missing from the Customers table. 
Show customer name as 'Unknown Customer' if missing.*/

SELECT c.Customer_ID, COALESCE(c.Full_Name, 'Unknown Customer') AS Full_Name, o.Order_Id
FROM customers c
RIGHT JOIN orders o
ON c.Customer_ID = o.Customer_ID;

/* Q18. Retrieve all order items along with their product details. 
Include order items even if the product doesn't exist in the Products table. 
Show product name as 'Product Not Found' if missing.*/



/* Q19. Rewrite Q17 using a LEFT JOIN instead of RIGHT JOIN and produce the exact same result. */

SELECT 
    oi.Order_Id,
    oi.Line_Item_Id,
    oi.Product_Id,
    COALESCE(p.Product_Name, 'Product Not Found') AS Product_Name,
    oi.Quantity,
    oi.Unit_Price
FROM CO.ORDER_ITEMS oi
LEFT JOIN CO.PRODUCTS p 
    ON oi.Product_Id = p.Product_Id;

/* Q20. Retrieve all shipments along with store details. 
Include shipments even if the store record is missing. 
Show store name as 'Store Not Found' if missing. Then rewrite it as a LEFT JOIN.
 */

-- RIght Join 

SELECT 
    s.Shipment_Id,
    s.Store_Id,
    s.Delivery_Address,
    s.Shipment_Status,
    COALESCE(st.Store_Name, 'Store Not Found') AS Store_Name
FROM CO.STORES st
RIGHT JOIN CO.SHIPMENTS s 
    ON st.Store_Id = s.Store_Id;
    
-- Left Join 

SELECT 
    s.Shipment_Id,
    s.Store_Id,
    s.Delivery_Address,
    s.Shipment_Status,
    COALESCE(st.Store_Name, 'Store Not Found') AS Store_Name
FROM CO.SHIPMENTS s
LEFT JOIN CO.STORES st 
    ON s.Store_Id = st.Store_Id;
