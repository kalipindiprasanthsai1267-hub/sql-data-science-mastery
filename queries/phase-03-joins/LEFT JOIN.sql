/* Q9. Retrieve all customers along with their order ID and order status. 
Include customers who have never placed any order — show NULL for order details where no order exists.
 */

SELECT c.Customer_ID, c.Full_Name, o.Order_Id, o.Order_Status
FROM customers c
LEFT JOIN orders o 
ON c.Customer_ID = o.Customer_ID;

/* Q10. Retrieve all products along with the quantity ordered from Order_Items. 
Include products that have never been ordered — show NULL for quantity where no order exists.
 */

SELECT p.product_Id, p.Product_Name, COALESCE(oi.Quantity, 0) AS Quantity
FROM products p
LEFT JOIN order_items oi
ON p.Product_Id = oi.Product_Id
ORDER BY quantity;

/* Q11. Retrieve all stores along with the orders placed through them. Include stores that have no orders at all. */

SELECT s.Store_Id, s.Store_Name,COUNT(o.Order_Id) AS Total_Orders  -- coalesce(o.Order_Id, 'Not Placed') AS Order_Id
FROM stores s 
LEFT JOIN orders o
ON s.store_Id = o.Store_Id
GROUP BY s.Store_Id, s.Store_Name
ORDER BY Total_Orders DESC;

/* Q12. Retrieve all customers who have never placed any order. Show only their full name and email address. */

SELECT c.Full_Name, c.Email_Address
FROM customers c 
LEFT JOIN orders o 
ON c.Customer_ID = o.Customer_ID
WHERE Order_Id IS NULL;

-- OR

-- Using NOT EXISTS (safest approach -- handles NULLs correctly)
SELECT c.Full_Name, c.Email_Address
FROM CO.Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM CO.Orders o
    WHERE o.Customer_ID = c.Customer_ID
);


/* Q13. Retrieve all products that have never been ordered. Show product name and unit price. */

SELECT p.product_id,p.product_name, p.unit_price
FROM Products p
LEFT JOIN order_items oi
ON p.product_Id = oi.Product_Id
WHERE Order_Id IS NULL;

-- OR

SELECT p.product_id, p.unit_price
FROM Products p
WHERE  NOT EXISTS (SELECT 1 FROM order_items oi WHERE p.product_id = oi.product_id);

/* Q14. Retrieve all customers along with the total number of orders they have placed. 
Include customers with zero orders — show 0 instead of NULL for their order count.
 */

SELECT c.Customer_ID, c.Full_Name,
       COALESCE(COUNT(o.Order_Id), 0) AS Total_Orders
FROM CO.Customers c
LEFT JOIN CO.Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Full_Name;

/* Q15. Retrieve all stores along with their total revenue from orders. 
Include stores with no revenue — show 0 instead of NULL. Revenue is unit price multiplied by quantity from Order_Items.
 */

SELECT s.Store_Id, s.Store_Name, COALESCE(SUM(oi.Quantity * oi.Unit_Price), 0) AS Revenue
FROM stores s
LEFT JOIN orders o 
ON s.store_id = o.store_id
LEFT JOIN order_items oi 
ON  o.Order_Id = oi.Order_Id
GROUP BY s.Store_Id, s.Store_Name
ORDER BY Revenue DESC;



/* Q16. Retrieve all products along with the total quantity ordered and total revenue generated. 
Include products never ordered — show 0 for both. Sort by total revenue descending.
 */
 
 SELECT p.Product_Id, p.Product_Name, SUM(oi.Quantity) AS Total_Orders, coalesce(SUM(oi.quantity * oi.unit_price),0) AS Total_revenue
 FROM products p
 LEFT JOIN order_items oi
 ON p.Product_Id = oi.Product_Id
 GROUP BY p.Product_Id, p.Product_Name
 ORDER BY Total_revenue DESC;
 