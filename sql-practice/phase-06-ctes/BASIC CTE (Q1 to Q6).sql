/*
Q1. Write a CTE called Customer_List that selects all customers.
Then in the main query select all columns from it.
*/
With Customer_List AS(
SELECT * From Customers
)

SELECT * FROM customer_List;

/*
Q2. Write a CTE called Expensive_Products that selects all products
with unit price above 10000.
Then show product name and unit price from it.
*/


With Expensive_Products AS(
SELECT * FROM products
Where unit_price >10000
)
SELECT Product_Name, Unit_price
From Expensive_Products;

/*
Q3. Write a CTE called Complete_Orders that selects all orders
with status COMPLETE.
Then count the total number of complete orders from it.
*/


With Complete_orders AS (
SELECT * From orders
Where LOWER(order_status)='complete'
)

SELECT COUNT(*) as orders_completed
From Complete_orders;


/*
Q4. Write a CTE called Delivered_Shipments that selects all shipments
with status DELIVERED.
Then show shipment ID, customer ID and delivery address from it.
*/

WITH Delivered_shipments AS(
SELECT * FROM Shipments
WHERE LOWER(Shipment_Status) = 'delivered'
)
SELECT shipment_id, customer_id, delivery_address
From Delivered_shipments;

/*
Q5. Write a CTE called High_Inventory that selects all inventory records
where product inventory is above 200.
Then show store ID, product ID and inventory quantity from it
ordered by inventory descending.
*/

WITH High_inventory AS (
SELECT * FROM Inventory
Where product_inventory >200
)
Select store_id, product_id, inventory_quantity
From High_inventory
Order by inventory_quantity DESC;


/*
Q6. Write a CTE called Recent_Orders that selects all orders placed after 2022.
Then show order ID, customer ID and order timestamp from it
ordered by timestamp descending.
*/

WITH Recent_Orders AS (
	SELECT *
    FROM Orders
    WHERE YEAR(Order_Tms) > 2022
)
SELECT Order_Id, Customer_ID, Order_Tms
FROM Recent_Orders
ORDER BY Order_Tms DESC;