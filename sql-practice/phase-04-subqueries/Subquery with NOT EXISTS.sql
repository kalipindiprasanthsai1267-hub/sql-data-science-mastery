/*  Q20. Find all customers who have never placed any order. 
Use NOT EXISTS. Show full name and email.
 */

SELECT c.full_name, c.email_address
FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o where c.Customer_ID = o.Customer_ID);

/*  Q21. Find all products that have never been ordered. 
Use NOT EXISTS. Show product name and unit price.
 */

SELECT p.product_name, p.unit_price
from products p 
Where not exists (SELECT 1 from order_items oi WHERE p.Product_Id = oi.Product_Id);

/*  Q22. Find all stores that have never dispatched any shipment. 
Use NOT EXISTS. Show store name.
 */

SELECT store_name 
FROM stores s
where not exists (select 1 from shipments ship Where s.Store_Id = ship.Store_Id);


/*  Q23. Find all customers who have never received a DELIVERED shipment. 
Use NOT EXISTS. Show full name and email.
 */

SELECT c.full_Name, c.email_address
FROM customers c
WHERE NOT exists (select 1 from shipments s Where c.Customer_ID = s.Customer_Id AND upper(s.shipment_status)= 'DELIVERED');
