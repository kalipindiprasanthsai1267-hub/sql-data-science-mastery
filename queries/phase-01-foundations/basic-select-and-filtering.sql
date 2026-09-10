/*
PHASE 1 — FOUNDATIONS
Practice File: Basic SELECT, WHERE, DISTINCT and NULL checks

Note:
These are reconstructed practice exercises using the same CO database
tables as the later SQL practice files.
*/

/*
Q1. Display all columns and rows from the Customers table.
*/
SELECT *
FROM CO.Customers;


/*
Q2. Show only customer ID and full name.
*/
SELECT Customer_ID,
       Full_Name
FROM CO.Customers;


/*
Q3. Show customer ID, full name and email for customers whose
    email is available.
*/
SELECT Customer_ID,
       Full_Name,
       Email
FROM CO.Customers
WHERE Email IS NOT NULL;


/*
Q4. Find all orders with the status 'Completed'.
*/
SELECT Order_Id,
       Customer_ID,
       Store_Id,
       Order_Tms,
       Order_Status
FROM CO.Orders
WHERE Order_Status = 'Completed';


/*
Q5. Find orders with a unit order value above 10000.

    First inspect the table to identify the appropriate column.
*/
SELECT *
FROM CO.Orders
WHERE Order_Value > 10000;


/*
Q6. Show all products priced above 1000.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
WHERE Unit_Price > 1000;


/*
Q7. Find products priced between 1000 and 10000.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
WHERE Unit_Price BETWEEN 1000 AND 10000;


/*
Q8. Find products whose name starts with 'A'.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
WHERE Product_Name LIKE 'A%';


/*
Q9. Find customers whose full name contains 'an'.
*/
SELECT Customer_ID,
       Full_Name
FROM CO.Customers
WHERE Full_Name LIKE '%an%';


/*
Q10. Show orders placed by a specific store.
*/
SELECT Order_Id,
       Customer_ID,
       Store_Id,
       Order_Tms
FROM CO.Orders
WHERE Store_Id = 1;


/*
Q11. Find orders from either store 1, 2 or 3.
*/
SELECT Order_Id,
       Customer_ID,
       Store_Id,
       Order_Tms
FROM CO.Orders
WHERE Store_Id IN (1, 2, 3);


/*
Q12. Find orders that are not cancelled.
*/
SELECT Order_Id,
       Customer_ID,
       Order_Status,
       Order_Tms
FROM CO.Orders
WHERE Order_Status <> 'Cancelled';


/*
Q13. Show distinct order statuses.
*/
SELECT DISTINCT Order_Status
FROM CO.Orders;


/*
Q14. Show distinct store IDs that have orders.
*/
SELECT DISTINCT Store_Id
FROM CO.Orders;


/*
Q15. Find customers whose name is missing.
*/
SELECT *
FROM CO.Customers
WHERE Full_Name IS NULL;


/*
Q16. Show the first 10 orders.
*/
SELECT *
FROM CO.Orders
LIMIT 10;


/*
Q17. Show the 10 most expensive products.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
ORDER BY Unit_Price DESC
LIMIT 10;


/*
Q18. Show the 10 cheapest products.
*/
SELECT Product_Id,
       Product_Name,
       Unit_Price
FROM CO.Products
ORDER BY Unit_Price
LIMIT 10;
