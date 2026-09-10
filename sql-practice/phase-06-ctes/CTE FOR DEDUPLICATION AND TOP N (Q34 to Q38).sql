/*
Q34. Write a CTE that assigns ROW_NUMBER to customers
partitioned by email domain ordered by customer ID.
Then keep only the first customer per email domain —
one representative per domain.
*/

WITH Domain_Ranked AS ( 
SELECT Customer_ID, Full_Name, Email_Address, SUBSTRING_INDEX(Email_Address, '@', -1) AS Domain, 
ROW_NUMBER() OVER( PARTITION BY SUBSTRING_INDEX(Email_Address, '@', -1) ORDER BY Customer_ID ) AS Rn 
FROM CO.Customers )
 SELECT Customer_ID, Full_Name, Email_Address, Domain FROM Domain_Ranked WHERE Rn = 1 ORDER BY Domain;


/*
Q35. Write a CTE that assigns ROW_NUMBER to order items
within each order ordered by unit price descending.
Then show only the top 2 most expensive items per order.
*/

WITH Item_Ranked AS ( 
SELECT Order_Id, Line_Item_Id, Product_Id, Unit_Price, 
ROW_NUMBER() OVER( PARTITION BY Order_Id ORDER BY Unit_Price DESC ) AS Rn 
FROM CO.Order_Items ) 
SELECT ir.Order_Id, p.Product_Name, ir.Unit_Price FROM Item_Ranked ir 
JOIN CO.Products p ON ir.Product_Id = p.Product_Id 
WHERE ir.Rn <= 2 
ORDER BY ir.Order_Id, ir.Rn;

/*
Q36. Write a CTE that assigns ROW_NUMBER to orders within each store
ordered by order timestamp descending.
Then show only the 3 most recent orders per store.
*/

WITH Store_Orders_Ranked AS ( 
SELECT Order_Id, Store_Id, Order_Tms, Customer_ID, 
ROW_NUMBER() OVER( PARTITION BY Store_Id ORDER BY Order_Tms DESC ) AS Rn 
FROM CO.Orders ) 
SELECT s.Store_Name, sor.Order_Id, sor.Order_Tms, sor.Customer_ID 
FROM Store_Orders_Ranked sor 
JOIN CO.Stores s 
ON sor.Store_Id = s.Store_Id 
WHERE sor.Rn <= 3 
ORDER BY s.Store_Name, sor.Order_Tms DESC;

/*
Q37. Write a CTE that ranks products within each price bucket
by unit price using DENSE_RANK.
Then show only the most expensive product in each bucket — rank 1 per bucket.
*/

WITH Bucket_Ranked AS ( 
SELECT Product_Name, Unit_Price, 
CASE WHEN Unit_Price < 1000 THEN 'Budget' 
	WHEN Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range' 
    ELSE 'Premium' 
END AS Price_Bucket, 
DENSE_RANK() OVER( PARTITION BY CASE WHEN Unit_Price < 1000 THEN 'Budget' WHEN Unit_Price BETWEEN 1000 AND 10000 THEN 'Mid Range' ELSE 'Premium' END 
ORDER BY Unit_Price DESC ) AS Bucket_Rank FROM CO.Products ) 
SELECT Product_Name, Unit_Price, Price_Bucket FROM Bucket_Ranked WHERE Bucket_Rank = 1 ORDER BY Price_Bucket;

/*
Q38. Write a CTE that assigns ROW_NUMBER to inventory records
within each store ordered by product inventory descending.
Then show only the top 3 products by inventory for each store.
*/

WITH Inventory_Ranked AS ( 
SELECT Store_Id, Product_Id, Product_Inventory, 
ROW_NUMBER() OVER( PARTITION BY Store_Id ORDER BY Product_Inventory DESC ) AS Rn 
FROM CO.Inventory ) 
SELECT s.Store_Name, p.Product_Name, ir.Product_Inventory 
FROM Inventory_Ranked ir 
JOIN CO.Stores s 
ON ir.Store_Id = s.Store_Id 
JOIN CO.Products p 
ON ir.Product_Id = p.Product_Id 
WHERE ir.Rn <= 3 
ORDER BY s.Store_Name, ir.Product_Inventory DESC;