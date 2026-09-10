/*  Q1. Find all products whose unit price is greater than the average unit price of all products. 
Show product name and unit price.
 */
 
 SELECT p.Product_Id, p.Unit_Price
 FROM products p
 WHERE p.Unit_Price > (SELECT AVG(p1.Unit_Price) FROM products p1);
 

/* Q2. Find all order items where the unit price charged is greater than the average unit price in the Products table. 
Show order ID, product ID and unit price charged.
  */

SELECT oi.Order_Id, oi.Product_ID, oi.Unit_Price
FROM CO.Order_Items oi
WHERE oi.Unit_Price > (
    SELECT AVG(unit_price)
    FROM CO.Products
);
                        

/* Q3. Find all customers whose customer ID is greater than the average customer ID. Show full name and email address.
  */

SELECT Full_Name, Email_Address
FROM CO.Customers
WHERE Customer_ID > (
    SELECT AVG(Customer_ID)
    FROM CO.Customers
);

/* Q4. Find all orders placed after the most recent order placed by Customer ID 1. 
Show order ID, customer ID and order timestamp.
  */

SELECT c.customer_id ,o.order_id, o.order_Tms
From customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.Order_Tms > (SELECT MAX(Order_Tms) FROM orders WHERE Customer_ID = 1);


/*  Q5. Find all products whose unit price is between the minimum and maximum unit price of items in Order_Items. 
Show product name and unit price.
 */

SELECT p.Product_Name, p.Unit_Price
FROM CO.Products p
WHERE p.Unit_Price BETWEEN (
    SELECT MIN(Unit_Price)
    FROM CO.Order_Items
) AND (
    SELECT MAX(Unit_Price)
    FROM CO.Order_Items
)
ORDER BY p.Unit_Price;


/*  Q6. Find all inventory records where the product inventory quantity is below the average inventory quantity across all records. 
Show store ID, product ID and inventory quantity.
 */
 
 SELECT store_id, product_id, product_inventory
 FROM inventory
 WHERE Product_Inventory < (SELECT AVG(Product_Inventory)FROM inventory);
 
 