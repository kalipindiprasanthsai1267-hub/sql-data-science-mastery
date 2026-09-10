/*  Q12. Find all products that have never been ordered. Use NOT IN. 
Show product name and unit price.
 */

SELECT Product_Name, Unit_Price
FROM CO.Products
WHERE Product_Id NOT IN (
    SELECT DISTINCT Product_ID
    FROM CO.Order_Items
    WHERE Product_ID IS NOT NULL
);


/* Q13. Find all customers who have never placed any order. 
Use NOT IN. Show full name and email.
  */

SELECT full_name, email_address
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id from orders WHERE Customer_ID IS NOT NULL);


/*  Q14. Find all stores that have never had any shipment. 
Use NOT IN. Show store name.
 */

SELECT store_name
FROM stores
WHERE Store_Id NOT IN (select store_id from shipments WHERE store_id IS NOT NULL);


/* Q15. Find all products that are not stocked in store ID 1. 
Use NOT IN on the Inventory table. Show product name and unit price.
  */
  
  SELECT product_name, unit_price 
  FROM products
  WHERE product_id NOT IN (SELECT Product_Id FROM inventory WHERE store_id = 1);