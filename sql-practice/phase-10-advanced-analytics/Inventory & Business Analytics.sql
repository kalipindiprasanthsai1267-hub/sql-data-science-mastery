/*
Q36. Find products that exist in inventory across multiple stores.
*/

SELECT
    Product_Id,

    COUNT(
        DISTINCT Store_Id
    ) AS Store_Count

FROM CO.Inventory

GROUP BY Product_Id

HAVING COUNT(
           DISTINCT Store_Id
       ) > 1

ORDER BY Store_Count DESC;


/*
Q37. Find products whose total inventory is zero across
     all stores.
*/

SELECT
    Product_Id,

    SUM(
        Inventory_Qty
    ) AS Total_Inventory

FROM CO.Inventory

GROUP BY Product_Id

HAVING SUM(
           Inventory_Qty
       ) = 0

ORDER BY Product_Id;


/*
Q38. Find stores where the total inventory is greater than
     the average inventory across all stores.
*/

WITH Store_Inventory AS (
    SELECT
        Store_Id,

        SUM(
            Inventory_Qty
        ) AS Total_Inventory

    FROM CO.Inventory

    GROUP BY Store_Id
),

Average_Inventory AS (
    SELECT
        AVG(Total_Inventory) AS Avg_Inventory

    FROM Store_Inventory
)

SELECT
    si.Store_Id,
    si.Total_Inventory,
    ai.Avg_Inventory

FROM Store_Inventory si

CROSS JOIN Average_Inventory ai

WHERE si.Total_Inventory >
      ai.Avg_Inventory

ORDER BY
    si.Total_Inventory DESC;


/*
Q39. Find products that have high sales but low inventory.

     Define:

     High sales    = above average quantity sold
     Low inventory = below average total inventory
*/

WITH Product_Sales AS (
    SELECT
        Product_Id,

        SUM(
            Quantity
        ) AS Quantity_Sold

    FROM CO.Order_Items

    GROUP BY Product_Id
),

Product_Inventory AS (
    SELECT
        Product_Id,

        SUM(
            Inventory_Qty
        ) AS Total_Inventory

    FROM CO.Inventory

    GROUP BY Product_Id
),

Combined AS (
    SELECT
        s.Product_Id,
        s.Quantity_Sold,
        i.Total_Inventory

    FROM Product_Sales s

    INNER JOIN Product_Inventory i
        ON s.Product_Id = i.Product_Id
),

Benchmarks AS (
    SELECT
        AVG(Quantity_Sold) AS Avg_Sales,
        AVG(Total_Inventory) AS Avg_Inventory

    FROM Combined
)

SELECT
    c.Product_Id,
    c.Quantity_Sold,
    c.Total_Inventory

FROM Combined c

CROSS JOIN Benchmarks b

WHERE c.Quantity_Sold > b.Avg_Sales
  AND c.Total_Inventory < b.Avg_Inventory

ORDER BY
    c.Quantity_Sold DESC;


/*
Q40. Calculate an inventory risk category for each product.

     High Sales + Low Inventory
         -> High Risk

     High Sales + Normal Inventory
         -> Medium Risk

     Low Sales + Low Inventory
         -> Low Risk

     Otherwise
         -> Normal
*/

WITH Product_Sales AS (
    SELECT
        Product_Id,

        SUM(
            Quantity
        ) AS Quantity_Sold

    FROM CO.Order_Items

    GROUP BY Product_Id
),

Product_Inventory AS (
    SELECT
        Product_Id,

        SUM(
            Inventory_Qty
        ) AS Total_Inventory

    FROM CO.Inventory

    GROUP BY Product_Id
),

Combined AS (
    SELECT
        s.Product_Id,
        s.Quantity_Sold,
        i.Total_Inventory

    FROM Product_Sales s

    INNER JOIN Product_Inventory i
        ON s.Product_Id = i.Product_Id
),

Benchmarks AS (
    SELECT
        AVG(Quantity_Sold) AS Avg_Sales,
        AVG(Total_Inventory) AS Avg_Inventory

    FROM Combined
)

SELECT
    c.Product_Id,
    c.Quantity_Sold,
    c.Total_Inventory,

    CASE

        WHEN c.Quantity_Sold > b.Avg_Sales
             AND c.Total_Inventory < b.Avg_Inventory
            THEN 'High Risk'

        WHEN c.Quantity_Sold > b.Avg_Sales
             AND c.Total_Inventory >= b.Avg_Inventory
            THEN 'Medium Risk'

        WHEN c.Quantity_Sold <= b.Avg_Sales
             AND c.Total_Inventory < b.Avg_Inventory
            THEN 'Low Risk'

        ELSE 'Normal'

    END AS Inventory_Risk

FROM Combined c

CROSS JOIN Benchmarks b

ORDER BY Inventory_Risk;
