/*  Q27. For each order placed by a customer, show the previous order's timestamp using LAG. 
Show customer ID, order ID, current order timestamp and previous order timestamp. 
Show NULL for the first order.   */

SELECT customer_id, order_id, order_tms as current_order_timestamp, LAG(order_tms, 1, NULL) OVER(PARTITION BY customer_id ORDER BY order_tms) as previous_order_stamp
FROM orders;

/*   Q28. For each order placed by a customer, show the next order's timestamp using LEAD. 
Show customer ID, order ID, current order timestamp and next order timestamp. 
Show NULL for the last order.  */

SELECT customer_id, order_id, order_tms as current_order_timestamp, LEAD(order_tms, 1, NULL) OVER(PARTITION BY customer_id ORDER BY order_tms) as next_order_stamp
FROM orders;


/*  Q29. Calculate the number of days between each order and the customer's previous order using LAG and DATEDIFF. 
Show customer ID, order ID, order timestamp, previous timestamp and days since last order.   */

SELECT customer_id, order_id, order_tms, LAG(order_tms,1,NULL) OVER(PARTITION BY customer_id ORDER BY order_tms) as previous_timestamp, DATEDIFF(order_tms,LAG(order_tms) OVER(PARTITION BY customer_id)) AS days_since_last_order
FROM orders;


/*  Q30. Calculate the revenue difference between each order item's unit price and the previous item's unit price within the same order using LAG. 
Show order ID, product ID, unit price and price difference from previous item.   */

SELECT order_id, product_id, unit_price, unit_price - LAG(unit_price,1,0) OVER(PARTITION BY order_id) as price_diff_from_prev
FROM order_items;


/*   Q31. Find all orders where the current order's timestamp is more than 90 days after the customer's previous order. 
Show customer ID, order ID, current timestamp and days since last order.  */

SELECT customer_id, order_id, order_tms, days_diff
FROM(SELECT customer_id, order_id, order_tms, DATEDIFF(order_tms , LAG(order_tms,1,NULL) OVER(PARTITION BY customer_id)) as days_diff FROM orders) a
WHERE days_diff > 90;


/*   Q32. Calculate month over month revenue change using LAG. 
First calculate monthly revenue, then compare each month to the previous month. 
Show month, revenue, previous month revenue and change amount.  */

SELECT Yr, Mth, Monthly_Revenue,
       LAG(Monthly_Revenue, 1, NULL) OVER(ORDER BY Yr, Mth) AS Prev_Month_Revenue,
       Monthly_Revenue - LAG(Monthly_Revenue, 1, NULL) OVER(ORDER BY Yr, Mth) AS Revenue_Change,
       ROUND(
           (Monthly_Revenue - LAG(Monthly_Revenue, 1, NULL) OVER(ORDER BY Yr, Mth))
           * 100.0
           / LAG(Monthly_Revenue, 1, NULL) OVER(ORDER BY Yr, Mth),
           2
       ) AS Revenue_Change_Pct
FROM (
    SELECT
           EXTRACT(YEAR FROM o.Order_Tms)  AS Yr,
           EXTRACT(MONTH FROM o.Order_Tms) AS Mth,
           SUM(oi.Unit_Price * oi.Quantity) AS Monthly_Revenue
    FROM CO.Orders o
    INNER JOIN CO.Order_Items oi
    ON o.Order_Id = oi.Order_Id
    GROUP BY EXTRACT(YEAR FROM o.Order_Tms),
             EXTRACT(MONTH FROM o.Order_Tms)
) AS Monthly_Data
ORDER BY Yr, Mth;

/*  Q33. Using LEAD, show each order alongside the next order's status for the same customer. 
Show customer ID, order ID, current status and next order status.   */

SELECT customer_id, order_id, order_status, LEAD(order_status,1,0) OVER(PARTITION BY customer_id)
FROM orders;
