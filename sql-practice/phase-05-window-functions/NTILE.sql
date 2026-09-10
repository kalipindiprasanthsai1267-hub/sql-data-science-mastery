/*   Q23. Divide all products into 4 quartiles based on unit price. 
Show product name, unit price and quartile number. 
Quartile 1 is most expensive.  */

SELECT product_name, unit_price, ntile(4) OVER(ORDER BY unit_price DESC) as Quart_Num
FROM products;


/*  Q24. Divide all customers into 3 tiers based on total spending — Top, Mid, Bottom. 
Show customer ID, total spending and tier number.   */

SELECT Customer_ID, Total_Amount, Tier_Number,
       CASE Tier_Number
           WHEN 1 THEN 'Top'
           WHEN 2 THEN 'Mid'
           WHEN 3 THEN 'Bottom'
       END AS Tier_Label
FROM (
    SELECT o.Customer_ID,
           SUM(oi.Unit_Price * oi.Quantity) AS Total_Amount,
           NTILE(3) OVER(
               ORDER BY SUM(oi.Unit_Price * oi.Quantity) DESC
           ) AS Tier_Number
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY o.Customer_ID
) AS Customer_Tiers
ORDER BY Tier_Number, Total_Amount DESC;

/*  Q25. Divide all orders into 10 deciles based on order timestamp. 
Show order ID, order timestamp and decile number.   */

SELECT order_id, order_tms, ntile(10) OVER(ORDER BY order_tms) as decile_number
FROM orders;


/*   Q26. Divide all products into 5 equal groups based on unit price. 
Show product name, unit price and group number. 
Then label each group — Group 1 as Highest, Group 5 as Lowest using CASE WHEN.  */

SELECT Product_Name, Unit_Price, Group_Num,
       CASE Group_Num
           WHEN 1 THEN 'Highest'
           WHEN 2 THEN 'High'
           WHEN 3 THEN 'Mid'
           WHEN 4 THEN 'Low'
           WHEN 5 THEN 'Lowest'
       END AS Group_Label
FROM (
    SELECT Product_Name, Unit_Price,
           NTILE(5) OVER(ORDER BY Unit_Price DESC) AS Group_Num
    FROM CO.Products
) AS Product_Groups
ORDER BY Group_Num;