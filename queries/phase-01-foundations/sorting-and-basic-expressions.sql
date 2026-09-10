/*
PHASE 1 — FOUNDATIONS
Practice File: Sorting, aliases, arithmetic and logical conditions
*/

/*
Q19. Show products from highest price to lowest price.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
ORDER BY Unit_Price DESC;


/*
Q20. Show customers in alphabetical order.
*/
SELECT Customer_ID,
       Full_Name
FROM CO.Customers
ORDER BY Full_Name ASC;


/*
Q21. Show products sorted first by price descending and then by name.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
ORDER BY Unit_Price DESC,
         Product_Name;


/*
Q22. Display product price with a new column name.
*/
SELECT Product_Name,
       Unit_Price AS Price
FROM CO.Products;


/*
Q23. Show order item revenue for every order item.
*/
SELECT Order_Id,
       Product_Id,
       Quantity,
       Unit_Price,
       Quantity * Unit_Price AS Line_Revenue
FROM CO.Order_Items;


/*
Q24. Show order items where line revenue is greater than 5000.
*/
SELECT Order_Id,
       Product_Id,
       Quantity,
       Unit_Price,
       Quantity * Unit_Price AS Line_Revenue
FROM CO.Order_Items
WHERE Quantity * Unit_Price > 5000;


/*
Q25. Find products above 5000 that are not marked inactive.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price,
       Active
FROM CO.Products
WHERE Unit_Price > 5000
  AND Active = 1;


/*
Q26. Find products that are either below 1000 or above 20000.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
WHERE Unit_Price < 1000
   OR Unit_Price > 20000;


/*
Q27. Show orders that are completed and belong to store 1.
*/
SELECT Order_Id,
       Customer_ID,
       Store_Id,
       Order_Status,
       Order_Tms
FROM CO.Orders
WHERE Order_Status = 'Completed'
  AND Store_Id = 1;


/*
Q28. Show order IDs and order dates, with the timestamp column
     renamed for easier reading.
*/
SELECT Order_Id,
       Order_Tms AS Order_Timestamp
FROM CO.Orders;


/*
Q29. Find inventory records where quantity is zero.
*/
SELECT *
FROM CO.Inventory
WHERE Inventory_Qty = 0;


/*
Q30. Show all physical stores.
*/
SELECT Store_Id,
       Store_Name,
       Web_Address
FROM CO.Stores
WHERE Web_Address IS NULL;


/*
Q31. Show stores that have a web address.
*/
SELECT Store_Id,
       Store_Name,
       Web_Address
FROM CO.Stores
WHERE Web_Address IS NOT NULL;


/*
Q32. Show the 5 highest-value order items.
*/
SELECT Order_Id,
       Product_Id,
       Quantity,
       Unit_Price,
       Quantity * Unit_Price AS Line_Revenue
FROM CO.Order_Items
ORDER BY Line_Revenue DESC
LIMIT 5;
