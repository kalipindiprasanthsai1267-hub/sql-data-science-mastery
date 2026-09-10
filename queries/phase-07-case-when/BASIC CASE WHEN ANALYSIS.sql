//*Q1. ORDER STATUS CLASSIFICATION

Classify each order based on Order_Status.

Categories:
- SHIPPED    → 'Completed'
- CANCELLED  → 'Cancelled'
- All other statuses → 'Pending'

Return:
- Order_Id
- Order_Status
- Status_Category
*/


SELECT order_id, order_status,
CASE WHEN lower(order_status) = 'cancelled' THEN 'Cancelled'
	 WHEN lower(order_status) = 'complete' THEN 'Shipped'
     ELSE 'Pending'
END AS Status_category
FROM orders;

/*
Q2. PRODUCT PRICE CLASSIFICATION

Classify every product based on Unit_Price.

Categories:
- Less than 1000        → 'Low'
- 1000 to 10000         → 'Medium'
- Greater than 10000    → 'High'

Return:
- Product_Id
- Product_Name
- Unit_Price
- Price_Category
*/

SELECT product_id, Product_name, unit_price,
CASE WHEN unit_price < 1000 THEN 'Low'
	 WHEN unit_price BETWEEN 1000 AND 10000 THEN 'Medium'
     WHEN unit_price > 10000 THEN 'High'
END AS Price_Category
FROM products;

/*
Q3. ORDER QUANTITY CLASSIFICATION

For every order item, classify the Quantity.

Categories:
- Quantity <= 2 → 'Small'
- Quantity 3–5  → 'Medium'
- Quantity > 5  → 'Large'

Return:
- Order_Id
- Line_Item_Id
- Quantity
- Quantity_Category
*/

SELECT
    Order_Id,
    Line_Item_Id,
    Quantity,
    CASE
        WHEN Quantity <= 2 THEN 'Small'
        WHEN Quantity BETWEEN 3 AND 5 THEN 'Medium'
        ELSE 'Large'
    END AS Quantity_Category
FROM CO.Order_Items;


/*
Q4. INVENTORY STOCK CLASSIFICATION

Classify every inventory record based on Product_Inventory.

Categories:
- 0          → 'Out of Stock'
- 1–10       → 'Low Stock'
- 11–50      → 'Medium Stock'
- Greater 50 → 'High Stock'

Return:
- Store_Id
- Product_Id
- Product_Inventory
- Stock_Category
*/
select * from inventory;

SELECT store_id, product_id, product_inventory,
CASE WHEN product_inventory = 0 THEN 'Low Stock'
	 WHEN product_inventory < 10 THEN 'Medium Stock'
     WHEN product_inventory BETWEEN 11 AND 50  THEN 'Medium Stock'
     WHEN product_inventory > 50 THEN 'High Stock'
END AS Stock_Category
FROM inventory;

/*
Q5. ORDER ITEM VALUE CLASSIFICATION

Calculate:

Item_Value = Unit_Price * Quantity

Classify each order item:

- Less than 5000       → 'Low Value'
- 5000–9999.99         → 'Medium Value'
- 10000 or more        → 'High Value'

Return:
- Order_Id
- Product_Id
- Unit_Price
- Quantity
- Item_Value
- Value_Category
*/

SELECT order_id, product_id, unit_price,quantity, (quantity * unit_price) as Item_value,
CASE WHEN (quantity * unit_price) < 5000 THEN 'Low Value'
	 WHEN (quantity * unit_price) BETWEEN 5000 AND 9999.99 THEN 'Medium Value'
     WHEN (quantity * unit_price) > 10000 THEN 'High Value'
END AS Value_category
FROM order_items;


/*
Q6. CUSTOMER NAME LENGTH CLASSIFICATION

Classify customers based on the length of Full_Name.

Categories:
- Less than 10 characters → 'Short Name'
- 10–20 characters       → 'Medium Name'
- Greater than 20        → 'Long Name'

Return:
- Customer_ID
- Full_Name
- Name_Length
- Name_Category
*/

SELECT
    Customer_ID,
    Full_Name,
    LENGTH(Full_Name) AS Name_Length,
    CASE
        WHEN LENGTH(Full_Name) < 10 THEN 'Short Name'
        WHEN LENGTH(Full_Name) <= 20 THEN 'Medium Name'
        ELSE 'Long Name'
    END AS Name_Category
FROM customers;


/*
Q7. SHIPMENT STATUS CLASSIFICATION

Classify shipments based on Shipment_Status.

Categories:
- Delivered
- In Transit
- Pending
- Other

Map the actual Shipment_Status values into these
four categories using CASE WHEN.

Return:
- Shipment_Id
- Shipment_Status
- Shipment_Category
*/

SELECT * FROM shipments;

/*
Q8. PRODUCT PRICE + QUANTITY CLASSIFICATION

For every order item, classify the purchase using
BOTH Unit_Price and Quantity.

Create four categories:

- Premium Bulk
- Premium Single
- Budget Bulk
- Budget Single

Define appropriate conditions using CASE WHEN.

Return:
- Order_Id
- Product_Id
- Unit_Price
- Quantity
- Purchase_Category
*/

SELECT
    Order_Id,
    Product_Id,
    Unit_Price,
    Quantity,
    CASE
        WHEN Unit_Price >= 10000 AND Quantity > 2
            THEN 'Premium Bulk'

        WHEN Unit_Price >= 10000 AND Quantity <= 2
            THEN 'Premium Single'

        WHEN Unit_Price < 10000 AND Quantity > 2
            THEN 'Budget Bulk'

        ELSE 'Budget Single'
    END AS Purchase_Category
FROM CO.Order_Items;
