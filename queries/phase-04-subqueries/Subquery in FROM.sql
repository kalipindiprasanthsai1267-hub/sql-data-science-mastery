/* Q33. Find the top 5 customers by total spending. 
Use a derived table to calculate spending first, then select from it. 
Show full name and total spending.
  */

SELECT full_name, total_spending
FROM (SELECT c.full_name, SUM(oi.quantity * oi.unit_price) AS total_spending
	  FROM customers c
      INNER JOIN orders o
      ON c.Customer_ID = o.customer_Id
      INNER JOIN order_items oi
      ON o.Order_Id = oi.Order_Id
      GROUP BY c.Customer_ID, c.Full_Name
      ORDER BY total_spending 
      LIMIT 5
)AS a;


/* Q34. Find all stores where the total number of orders is above the average number of orders per store.
 Use a derived table.
 Show store ID and order count.
  */

-- Step 1: Derived table calculates order count per store
-- Step 2: Outer query filters where count exceeds average

SELECT Store_Id, Order_Count
FROM (
    SELECT o.Store_Id,
           COUNT(*) AS Order_Count
    FROM CO.Orders o
    GROUP BY o.Store_Id
) AS Store_Orders
WHERE Order_Count > (
    SELECT AVG(Order_Count)
    FROM (
        SELECT COUNT(*) AS Order_Count
        FROM CO.Orders
        GROUP BY Store_Id
    ) AS Avg_Calc
)
ORDER BY Order_Count DESC;



	/*  Q35. Find the average revenue per order, then show all orders that exceed that average. 
	Use a derived table for the per-order revenue first. 
	Show order ID and order revenue.
	 */

	SELECT 
    order_id, order_revenue
FROM
    (SELECT 
        o.order_id,
            SUM(oi.quantity * oi.unit_price) AS order_revenue
    FROM
        orders o
    INNER JOIN order_items oi ON o.Order_Id = oi.Order_Id
    GROUP BY order_id) AS a
WHERE
    order_revenue > (SELECT 
            AVG(order_revenue)
        FROM
            (SELECT 
                SUM(oi1.quantity * oi1.unit_price) AS order_revenue
            FROM
                order_items oi1
            GROUP BY Order_Id) AS b);



/*  Q36. Find all products where the total quantity ordered is above the average quantity ordered per product. 
Use a derived table. Show product ID and total quantity.
 */

SELECT 
    product_id, total_quantity
FROM
    (SELECT 
        p.product_id, SUM(oi.Quantity) AS total_quantity
    FROM
        products p
    INNER JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY oi.product_id) AS a
WHERE
    total_quantity > (SELECT 
            AVG(total_quantity)
        FROM
            (SELECT 
                SUM(oi1.Quantity) AS total_quantity
            FROM
                products p1
            INNER JOIN order_items oi1 ON p1.product_id = oi1.product_id
            GROUP BY oi1.product_id) AS b);


/* Q37. Find the top 3 products by total revenue generated. 
Use a derived table to calculate revenue per product first. 
Show product name and total revenue.
  */
  
  SELECT 
    product_name, total_revenue
FROM
    (SELECT 
        p.product_name,
            SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM
        products p
    INNER JOIN order_items oi ON p.Product_Id = oi.Product_Id
    GROUP BY p.Product_Id , p.Product_Name) AS a
WHERE
    total_revenue > (SELECT 
            AVG(total_revenue)
        FROM
            (SELECT 
                SUM(oi1.quantity * oi1.unit_price) AS total_revenue
            FROM
                products p1
            INNER JOIN order_items oi1 ON p1.Product_Id = oi1.Product_Id
            GROUP BY p1.Product_Id , p1.Product_Name) AS c)
ORDER BY total_revenue DESC;
