/* Q29. Generate all possible combinations of stores and products. Show store name and product name. */

SELECT store_name, Product_name
FROM stores
CROSS JOIN products;

/* Q30. Generate all possible combinations of customers and order statuses. 
The order statuses are 'COMPLETE', 'PENDING', 'CANCELLED'. Show customer name and status. 
Do this without a separate status table — use CROSS JOIN with a derived table.*/

SELECT c.Full_Name AS Customer_Name,
       s.Order_Status
FROM CO.Customers c
CROSS JOIN (
    SELECT 'COMPLETE'  AS Order_Status
    UNION ALL
    SELECT 'PENDING'
    UNION ALL
    SELECT 'CANCELLED'
) s
ORDER BY c.Full_Name, s.Order_Status;

/* Q31. Find all store-product combinations that are NOT in the
 Inventory table — meaning combinations that exist as possibilities but have no inventory record yet. 
 Show store name and product name.*/
 
 SELECT s.Store_Name, p.Product_Name
FROM CO.Stores s
CROSS JOIN CO.Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM CO.Inventory i
    WHERE i.Store_Id = s.Store_Id
    AND i.Product_Id = p.Product_Id
)
ORDER BY s.Store_Name, p.Product_Name;
 