/*  Q44. Find all customers who have ordered the single most expensive product in the entire catalog 
— based on the unit price in Order_Items. Show customer full name. 
Use nested subqueries — no JOINs allowed for the price lookup.
 */


SELECT DISTINCT c.Full_Name
FROM CO.Customers c
WHERE c.Customer_ID IN (
    SELECT o.Customer_ID
    FROM CO.Orders o
    WHERE o.Order_Id IN (
        SELECT oi.Order_Id
        FROM CO.Order_Items oi
        WHERE oi.Unit_Price = (
            SELECT MAX(Unit_Price)
            FROM CO.Order_Items
        )
    )
)
ORDER BY c.Full_Name;


/*  Q45. Find the store that generated the highest total revenue. 
Show store ID and total revenue. Use nested subqueries — no window functions or RANK.
 */
 
 
SELECT Store_Id,
       ROUND(Total_Revenue, 2) AS Total_Revenue
FROM (
    SELECT o.Store_Id,
           SUM(oi.Unit_Price * oi.Quantity) AS Total_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Store_Id
) AS Store_Revenue
WHERE Total_Revenue = (
    SELECT MAX(Total_Revenue)
    FROM (
        SELECT SUM(oi1.Unit_Price * oi1.Quantity) AS Total_Revenue
        FROM CO.Orders o1
        INNER JOIN CO.Order_Items oi1
        ON o1.Order_Id = oi1.Order_Id
        GROUP BY o1.Store_Id
    ) AS Revenue_Calc
);
 