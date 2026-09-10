/*
Q31. Find the longest gap between consecutive orders for each
     customer.
*/

WITH Customer_Order_Gaps AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,

        LAG(Order_Tms) OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Previous_Order

    FROM CO.Orders
)

SELECT
    Customer_ID,

    MAX(
        DATEDIFF(
            Order_Tms,
            Previous_Order
        )
    ) AS Longest_Gap_Days

FROM Customer_Order_Gaps

WHERE Previous_Order IS NOT NULL

GROUP BY Customer_ID

ORDER BY Longest_Gap_Days DESC;


/*
Q32. Find the customer with the longest single gap between
     consecutive orders.
*/

WITH Customer_Order_Gaps AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,

        LAG(Order_Tms) OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Previous_Order

    FROM CO.Orders
),

Order_Gaps AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,
        Previous_Order,

        DATEDIFF(
            Order_Tms,
            Previous_Order
        ) AS Gap_Days

    FROM Customer_Order_Gaps

    WHERE Previous_Order IS NOT NULL
)

SELECT
    Customer_ID,
    Order_Id,
    Previous_Order,
    Order_Tms,
    Gap_Days

FROM Order_Gaps

ORDER BY Gap_Days DESC

LIMIT 1;


/*
Q33. Find customers whose order frequency increased over time.

     Compare the first half of their orders with the second half.
*/

WITH Customer_Orders AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Order_Number,

        COUNT(*) OVER (
            PARTITION BY Customer_ID
        ) AS Total_Orders

    FROM CO.Orders
),

Customer_Halves AS (
    SELECT
        Customer_ID,

        SUM(
            CASE
                WHEN Order_Number <=
                     CEIL(Total_Orders / 2)
                    THEN 1
                ELSE 0
            END
        ) AS First_Half_Orders,

        SUM(
            CASE
                WHEN Order_Number >
                     CEIL(Total_Orders / 2)
                    THEN 1
                ELSE 0
            END
        ) AS Second_Half_Orders

    FROM Customer_Orders

    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    First_Half_Orders,
    Second_Half_Orders

FROM Customer_Halves

WHERE Second_Half_Orders >
      First_Half_Orders

ORDER BY
    Second_Half_Orders DESC;


/*
Q34. Find consecutive orders for each customer where the gap
     between purchases was less than 7 days.
*/

WITH Customer_Order_Gaps AS (
    SELECT
        Customer_ID,
        Order_Id,
        Order_Tms,

        LAG(Order_Tms) OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Previous_Order

    FROM CO.Orders
)

SELECT
    Customer_ID,
    Order_Id,
    Previous_Order,

    DATEDIFF(
        Order_Tms,
        Previous_Order
    ) AS Gap_Days

FROM Customer_Order_Gaps

WHERE Previous_Order IS NOT NULL

  AND DATEDIFF(
          Order_Tms,
          Previous_Order
      ) < 7

ORDER BY
    Customer_ID,
    Order_Tms;


/*
Q35. Calculate each customer's average number of days between
     purchases and classify their purchase frequency.

     <= 30 days  -> Frequent
     31-90 days  -> Regular
     > 90 days   -> Infrequent
*/

WITH Customer_Gaps AS (
    SELECT
        Customer_ID,
        Order_Tms,

        LAG(Order_Tms) OVER (
            PARTITION BY Customer_ID
            ORDER BY Order_Tms
        ) AS Previous_Order

    FROM CO.Orders
),

Customer_Average_Gap AS (
    SELECT
        Customer_ID,

        AVG(
            DATEDIFF(
                Order_Tms,
                Previous_Order
            )
        ) AS Avg_Gap_Days

    FROM Customer_Gaps

    WHERE Previous_Order IS NOT NULL

    GROUP BY Customer_ID
)

SELECT
    Customer_ID,

    ROUND(
        Avg_Gap_Days,
        2
    ) AS Avg_Gap_Days,

    CASE
        WHEN Avg_Gap_Days <= 30
            THEN 'Frequent'

        WHEN Avg_Gap_Days <= 90
            THEN 'Regular'

        ELSE 'Infrequent'
    END AS Purchase_Frequency

FROM Customer_Average_Gap

ORDER BY Avg_Gap_Days;

