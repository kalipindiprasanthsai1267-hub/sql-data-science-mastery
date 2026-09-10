/*
Q12. Write a CTE called Ranked_Products that ranks all products
by unit price descending using RANK().
Then in the main query show only the top 5 ranked products.
*/

WITH Ranked_Products AS (
SELECT product_id, unit_price,
RANK() OVER(Order by Unit_price DESC) As rnk
From products
)
Select * from Ranked_Products 
Where rnk <= 5;

/*
Q13. Write a CTE called Row_Numbered_Orders that assigns ROW_NUMBER
to each order within each customer ordered by timestamp.
Then show only the most recent order per customer
where row number equals 1.
*/

WITH Row_Numbered_Orders AS(
Select customer_id, order_id,
Row_Number() Over(partition by customer id
Order by order_tms) as row_num
From orders
)
Select * from row_numbered_orders
Where row_num = 1;


/*
Q14. Write a CTE called Product_Quartiles that divides all products
into 4 quartiles using NTILE based on unit price.
Then show only products in the top quartile — quartile 1.
*/

WITH Product_Quartiles AS (
SELECT product_id, unit_price,
NTILE(4) over(order by unit_price DESC) as quartile
From Products
)
Select * from Product_quartiles
Where quartile = 1;


/*
Q15. Write a CTE called Running_Revenue that calculates the running
total revenue across all orders ordered by timestamp.
Join Orders and Order_Items inside the CTE.
Then show all orders where the running total has exceeded 500000.
*/

WITH Order_Totals AS (
    SELECT o.Order_Id, o.Order_Tms,
           SUM(oi.Unit_Price * oi.Quantity) AS Order_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Order_Id, o.Order_Tms
),
Running_Revenue AS (
    SELECT Order_Id, Order_Tms, Order_Revenue,
           SUM(Order_Revenue) OVER(
               ORDER BY Order_Tms
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS Running_Total
    FROM Order_Totals
)
SELECT *
FROM Running_Revenue
WHERE Running_Total > 500000
ORDER BY Order_Tms;

/*
Q16. Write a CTE called Customer_Revenue_Rank that calculates total
spending per customer and ranks them using DENSE_RANK.
Then show the top 10 customers by spending rank.
*/

WITH Customer_Revenue_Rank AS(
SELECT o.customer_id,
Sum(oi.quantity * oi.unit_price) As Cust_reven
From orders o
Join order_items oi
On o.order_id = oi.order_id
Group by o.customer_id
),
Cust_rnk AS(
SELECT customer_id, Cust_rev, 
DENSE_RANK() OVER(ORDER BY Cust_rev DESC) AS rnk
From Customer_Revenue_Rank
)
SELECT * FROM Cust_rnk;


/*
Q17. Write a CTE called Order_Price_Stats that shows each order item
alongside the max and min price within that order using window functions.
Then show only items where the unit price equals the max price
in that order — the most expensive item per order.
*/
WITH Order_Price_Stats AS (
    SELECT Order_Id, Line_Item_Id, Product_Id, Unit_Price,
           MAX(Unit_Price) OVER(PARTITION BY Order_Id) AS Order_Max_Price,
           MIN(Unit_Price) OVER(PARTITION BY Order_Id) AS Order_Min_Price
    FROM CO.Order_Items
)
SELECT oi.Order_Id, p.Product_Name,
       oi.Unit_Price, oi.Order_Max_Price
FROM Order_Price_Stats oi
INNER JOIN CO.Products p
ON oi.Product_Id = p.Product_Id
WHERE oi.Unit_Price = oi.Order_Max_Price
ORDER BY oi.Order_Id;
