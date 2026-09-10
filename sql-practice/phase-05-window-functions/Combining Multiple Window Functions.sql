/*  Q54. For each order item show — product name, unit price, rank by unit price within the order, 
running total revenue within the order and percentage of the order's total revenue. 
Combine RANK, SUM OVER and percentage calculation.   */

SELECT oi.Order_Id, p.Product_Name, oi.Unit_Price,
       RANK() OVER(
           PARTITION BY oi.Order_Id
           ORDER BY oi.Unit_Price DESC
       ) AS Price_Rank,
       SUM(oi.Unit_Price * oi.Quantity) OVER(
           PARTITION BY oi.Order_Id
           ORDER BY oi.Unit_Price DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Running_Total_Revenue,
       ROUND(oi.Unit_Price * oi.Quantity * 100.0 /
           SUM(oi.Unit_Price * oi.Quantity) OVER(PARTITION BY oi.Order_Id), 2
       ) AS Pct_Of_Order_Revenue
FROM CO.Order_Items oi
INNER JOIN CO.Products p
ON oi.Product_Id = p.Product_Id
ORDER BY oi.Order_Id, Price_Rank;


/*   Q55. For each customer's order show — customer ID, order ID, order revenue, running total revenue for that customer, 
rank of that order among all customer orders by revenue and percentage of customer's total revenue. 
Combine SUM OVER, RANK and percentage.  */

SELECT Customer_ID, Order_Id, Order_Revenue,
       SUM(Order_Revenue) OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Revenue DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Customer_Running_Total,
       RANK() OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Revenue DESC
       ) AS Order_Revenue_Rank,
       ROUND(Order_Revenue * 100.0 /
           SUM(Order_Revenue) OVER(PARTITION BY Customer_ID), 2
       ) AS Pct_Of_Customer_Total
FROM (
    SELECT o.Customer_ID, o.Order_Id,
           SUM(oi.Unit_Price * oi.Quantity) AS Order_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Customer_ID, o.Order_Id
) AS Order_Totals
ORDER BY Customer_ID, Order_Revenue_Rank;


/*  Q56. For each product show — product name, unit price, rank by price, quartile by price, 
percentage of total product revenue and difference from average price. 
Combine RANK, NTILE, SUM OVER and AVG OVER.   */

SELECT p.Product_Name,
       p.Unit_Price,
       RANK() OVER(ORDER BY p.Unit_Price DESC) AS Price_Rank,
       NTILE(4) OVER(ORDER BY p.Unit_Price DESC) AS Price_Quartile,
       ROUND(
           COALESCE(SUM(oi.Unit_Price * oi.Quantity), 0) * 100.0 /
           NULLIF(SUM(SUM(oi.Unit_Price * oi.Quantity)) OVER(), 0), 2
       ) AS Pct_Of_Total_Revenue,
       ROUND(p.Unit_Price - AVG(p.Unit_Price) OVER(), 2) AS Diff_From_Avg
FROM CO.Products p
LEFT JOIN CO.Order_Items oi
ON p.Product_Id = oi.Product_ID
GROUP BY p.Product_Id, p.Product_Name, p.Unit_Price
ORDER BY Price_Rank;


/*  Q57. For each order show — order ID, customer ID, order timestamp, revenue, 
previous order revenue using LAG, revenue change from previous order and running total revenue. 
Combine LAG and SUM OVER.   */

SELECT Customer_ID, Order_Id, Order_Tms, Order_Revenue,
       LAG(Order_Revenue, 1, NULL) OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Tms
       ) AS Prev_Order_Revenue,
       Order_Revenue - LAG(Order_Revenue, 1, NULL) OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Tms
       ) AS Revenue_Change,
       SUM(Order_Revenue) OVER(
           PARTITION BY Customer_ID
           ORDER BY Order_Tms
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Customer_Running_Total
FROM (
    SELECT o.Customer_ID, o.Order_Id, o.Order_Tms,
           SUM(oi.Unit_Price * oi.Quantity) AS Order_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Customer_ID, o.Order_Id, o.Order_Tms
) AS Order_Totals
ORDER BY Customer_ID, Order_Tms;


/*  Q58. For each store show total revenue, rank by revenue, 
percentage of grand total revenue and cumulative revenue in rank order. 
Combine RANK, SUM OVER, percentage and running total across stores.   */



SELECT Store_Id, Total_Revenue,
       RANK() OVER(ORDER BY Total_Revenue DESC) AS Revenue_Rank,
       ROUND(Total_Revenue * 100.0 /
           SUM(Total_Revenue) OVER(), 2
       ) AS Pct_Of_Grand_Total,
       SUM(Total_Revenue) OVER(
           ORDER BY Total_Revenue DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Cumulative_Revenue_By_Rank
FROM (
    SELECT o.Store_Id,
           SUM(oi.Unit_Price * oi.Quantity) AS Total_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Store_Id
) AS Store_Revenue
ORDER BY Revenue_Rank;