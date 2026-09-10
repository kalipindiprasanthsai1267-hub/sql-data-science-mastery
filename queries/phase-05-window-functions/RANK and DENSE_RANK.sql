/*  Q17. Rank all products by unit price descending using RANK().
 Show product name, unit price and rank.
 Observe what happens with ties.   */

SELECT product_name, unit_price, RANK() OVER(ORDER BY unit_price DESC) as rnk
FROM products;
-- The values that have ties will have the same rank but the rank will be skipped when it comes to the next one

/*  Q18. Rank all products by unit price descending using DENSE_RANK().
 Show product name, unit price and dense rank. 
 Compare with Q17.   */

SELECT product_name, unit_price, DENSE_RANK() OVER(ORDER BY unit_price DESC) as rnk
FROM products;

-- The difference between RANK() and DENSE_RANK() is nothing but the numbering system in which they give, in case of RANK() if there are two identical values they both get the same rank but for the next value the rank gets skipped but in case of DENSE_RANK() the number wont be skipped.

/*   Q19. Rank all orders within each store by order timestamp using RANK(). 
Show store ID, order ID, order timestamp and rank within store.  */

SELECT store_id, order_id, order_tms, RANK() OVER(PARTITION BY store_id ORDER BY Order_Tms) AS rnk
FROM orders;



/*  Q20. Find the top 3 products by unit price using DENSE_RANK.
 Show product name, unit price and dense rank. 
 Include ties.   */

SELECT product_name, unit_price
FROM(SELECT product_name, unit_price, DENSE_RANK() OVER(order by unit_price DESC) as rnk FROM products) a
WHERE rnk<=3;


/*   Q21. Rank customers by their total spending using RANK(). 
Join Customers, Orders and Order_Items. 
Show customer name, total spending and rank.  */

SELECT Full_Name, Total_Spending,
       RANK() OVER(ORDER BY Total_Spending DESC) AS Spending_Rank
FROM (
    SELECT c.Full_Name,
           SUM(oi.Unit_Price * oi.Quantity) AS Total_Spending
    FROM CO.Customers c
    INNER JOIN CO.Orders o
    ON c.Customer_ID = o.Customer_ID
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY c.Customer_ID, c.Full_Name
) AS Customer_Spending
ORDER BY Spending_Rank;


/*  Q22. Find all products that share the same rank as the most expensive product using DENSE_RANK. 
Show product name, unit price and dense rank.   */

SELECT Product_Name, Unit_Price, Dense_Rnk
FROM (
    SELECT Product_Name, Unit_Price,
           DENSE_RANK() OVER(ORDER BY Unit_Price DESC) AS Dense_Rnk
    FROM CO.Products
) ranked
WHERE Dense_Rnk = 1;