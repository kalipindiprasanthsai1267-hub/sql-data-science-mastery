/* Q24. Find all products whose unit price is greater than ANY unit price in the Order_Items table. 
Show product name and unit price.
  */

SELECT Product_Name, Unit_Price
FROM CO.Products
WHERE Unit_Price > ANY (
    SELECT Unit_Price
    FROM CO.Order_Items
)
ORDER BY Unit_Price;


/*  Q25. Find all products whose unit price is greater than ALL unit prices in the Order_Items table. 
Show product name and unit price.
 */

SELECT Product_Name, Unit_Price
FROM CO.Products
WHERE Unit_Price > ALL (
    SELECT Unit_Price
    FROM CO.Order_Items
)
ORDER BY Unit_Price;


/* Q26. Find all products whose unit price is less than ALL unit prices charged in Order_Items for product ID 1. 
Show product name and unit price.
  */

SELECT Product_Name, Unit_Price
FROM CO.Products
WHERE Unit_Price < ALL (
    SELECT Unit_Price
    FROM CO.Order_Items
    WHERE Product_ID = 1
)
ORDER BY Unit_Price;


/*  Q27. Find all order items where the quantity ordered is greater than ANY quantity ordered for product ID 5. 
Show order ID, product ID and quantity.
 */
 
 SELECT order_id, product_id, quantity
 FROM order_items
 where quantity > ANY (Select quantity from order_items WHERE Product_Id  = 5);