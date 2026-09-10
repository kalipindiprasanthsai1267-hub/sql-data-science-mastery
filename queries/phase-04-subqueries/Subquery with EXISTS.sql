/* Q16. Find all customers who have placed at least one order. 
Use EXISTS. Show full name and email.
  */

SELECT full_name, email_address
from customers c
WHERE EXISTS (SELECT 1 FROM orders o where c.Customer_ID = o.Customer_ID);


/* Q17. Find all products that have been ordered at least once. 
Use EXISTS. Show product name and unit price.
  */

SELECT product_name, unit_price
from products p
where exists (select 1 from order_items oi WHERE p.Product_Id = oi.Product_Id);

/*  Q18. Find all stores that have at least one COMPLETE order. 
Use EXISTS. Show store name.
 */

SELECT store_name 
FROM stores s
where exists (Select 1 from orders o WHERE s.Store_Id = o.Store_Id);


/* Q19. Find all customers who have at least one shipment with status DELIVERED. 
Use EXISTS. Show full name and email.
  */
  
  SELECT full_name, email_address
  from customers c
  WHERE exists (select 1 from shipments s where c.Customer_ID = s.Customer_ID AND UPPER(Shipment_Status) = 'DELIVERED');