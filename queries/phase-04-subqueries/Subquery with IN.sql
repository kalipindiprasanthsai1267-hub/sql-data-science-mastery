/* Q7. Find all products that have been ordered at least once. Use a subquery with IN. 
Show product name and unit price.
  */

SELECT Product_Name, Unit_Price
FROM CO.Products
WHERE Product_Id IN (
    SELECT DISTINCT Product_ID
    FROM CO.Order_Items
)
ORDER BY Unit_Price DESC;


/*  Q8. Find all customers who have placed at least one order with status COMPLETE. 
Use a subquery with IN. Show customer full name and email.
 */

select full_name, email_address
FROm customers
WHERE customer_id IN (select DISTINCT Customer_ID FROM orders WHERE upper(Order_Status) = 'COMPLETE');


/*  Q9. Find all stores that have at least one shipment with status DELIVERED. 
Use a subquery with IN. Show store name.
 */

SELECT store_Name 
FROM Stores
WHERE store_id IN (select distinct store_id FROM shipments WHERE upper(shipment_status) = 'DELIVERED');


/*  Q10. Find all order items that belong to orders placed in the year 2023. 
Use a subquery with IN. Show order ID, product ID and quantity.
 */

SELECT order_id, product_id, quantity  FROM order_items
WHERE Order_Id IN (SELECT order_id FROM orders WHERE YEAR(Order_Tms) = 2021);


/* Q11. Find all products that are currently stocked in store ID 1.
 Use a subquery with IN on the Inventory table. Show product name and unit price.
  */
  
  SELECT product_name, unit_price 
  FROM products
  WHERE product_id IN (SELECT Product_Id FROM inventory WHERE store_id = 1);