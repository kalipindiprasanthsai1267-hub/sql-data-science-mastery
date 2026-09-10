
/* ============================================================
   SECTION A — BASIC STRING FUNCTIONS
   Q1 TO Q6
   ============================================================ */


/*
Q1. Show each customer's full name in uppercase.
*/

SELECT Customer_ID,
       Full_Name,
       UPPER(Full_Name) AS Upper_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q2. Show each customer's full name in lowercase.
*/

SELECT Customer_ID,
       Full_Name,
       LOWER(Full_Name) AS Lower_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q3. Show the length of every customer's full name.
*/

SELECT Customer_ID,
       Full_Name,
       LENGTH(Full_Name) AS Name_Length
FROM CO.Customers
ORDER BY Name_Length DESC;


/*
Q4. Show both LENGTH() and CHAR_LENGTH() for customer names.
*/

SELECT Customer_ID,
       Full_Name,
       LENGTH(Full_Name) AS Byte_Length,
       CHAR_LENGTH(Full_Name) AS Character_Length
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q5. Remove leading and trailing spaces from customer names.
*/

SELECT Customer_ID,
       Full_Name,
       TRIM(Full_Name) AS Clean_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q6. Replace spaces in customer names with underscores.
*/

SELECT Customer_ID,
       Full_Name,
       REPLACE(Full_Name, ' ', '_') AS Name_With_Underscore
FROM CO.Customers
ORDER BY Customer_ID;


/* ============================================================
   SECTION B — CONCATENATION
   Q7 TO Q11
   ============================================================ */


/*
Q7. Create a customer label using Customer_ID and Full_Name.

Example:
1 - Tammy Bryant
*/

SELECT Customer_ID,
       CONCAT(
           Customer_ID,
           ' - ',
           Full_Name
       ) AS Customer_Label
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q8. Create a sentence showing the customer's ID and name.

Example:
Customer 1 is Tammy Bryant
*/

SELECT Customer_ID,
       CONCAT(
           'Customer ',
           Customer_ID,
           ' is ',
           Full_Name
       ) AS Customer_Description
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q9. Combine store ID and store name into one column.
*/

SELECT Store_Id,
       Store_Name,
       CONCAT(
           Store_Id,
           ' - ',
           Store_Name
       ) AS Store_Label
FROM CO.Stores
ORDER BY Store_Id;


/*
Q10. Create a product description by combining product name
     and unit price.

Example:
Laptop - 45000
*/

SELECT Product_Id,
       Product_Name,
       Unit_Price,
       CONCAT(
           Product_Name,
           ' - ',
           Unit_Price
       ) AS Product_Description
FROM CO.Products
ORDER BY Product_Id;


/*
Q11. Use CONCAT_WS() to combine customer ID, full name and
     email address using ' | ' as the separator.
*/

SELECT Customer_ID,
       CONCAT_WS(
           ' | ',
           Customer_ID,
           Full_Name,
           Email_Address
       ) AS Customer_Info
FROM CO.Customers
ORDER BY Customer_ID;


/* ============================================================
   SECTION C — LEFT, RIGHT AND SUBSTRING
   Q12 TO Q17
   ============================================================ */


/*
Q12. Show the first 5 characters of every customer's name.
*/

SELECT Customer_ID,
       Full_Name,
       LEFT(Full_Name, 5) AS First_5_Characters
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q13. Show the last 5 characters of every customer's name.
*/

SELECT Customer_ID,
       Full_Name,
       RIGHT(Full_Name, 5) AS Last_5_Characters
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q14. Extract the first 3 characters of each product name.
*/

SELECT Product_Id,
       Product_Name,
       LEFT(Product_Name, 3) AS Product_Prefix
FROM CO.Products
ORDER BY Product_Id;


/*
Q15. Extract characters 1 through 5 from each store name.
*/

SELECT Store_Id,
       Store_Name,
       SUBSTRING(Store_Name, 1, 5) AS Store_Prefix
FROM CO.Stores
ORDER BY Store_Id;


/*
Q16. Extract the first name from a customer's full name,
     assuming names contain a single space between first
     and last name.
*/

SELECT Customer_ID,
       Full_Name,
       SUBSTRING_INDEX(
           Full_Name,
           ' ',
           1
       ) AS First_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q17. Extract the last name from a customer's full name.
*/

SELECT Customer_ID,
       Full_Name,
       SUBSTRING_INDEX(
           Full_Name,
           ' ',
           -1
       ) AS Last_Name
FROM CO.Customers
ORDER BY Customer_ID;


/* ============================================================
   SECTION D — SEARCHING WITHIN STRINGS
   Q18 TO Q22
   ============================================================ */


/*
Q18. Find the position of the first space in each customer's
     full name.
*/

SELECT Customer_ID,
       Full_Name,
       LOCATE(
           ' ',
           Full_Name
       ) AS Space_Position
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q19. Find customers whose names contain the letter 'a'.
*/

SELECT Customer_ID,
       Full_Name
FROM CO.Customers
WHERE LOCATE(
          'a',
          LOWER(Full_Name)
      ) > 0
ORDER BY Full_Name;


/*
Q20. Find the position of the '@' symbol in each email address.
*/

SELECT Customer_ID,
       Email_Address,
       LOCATE(
           '@',
           Email_Address
       ) AS At_Position
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q21. Use INSTR() to find customers whose email contains
     the word 'internal'.
*/

SELECT Customer_ID,
       Email_Address
FROM CO.Customers
WHERE INSTR(
          LOWER(Email_Address),
          'internal'
      ) > 0
ORDER BY Customer_ID;


/*
Q22. Find products whose names contain the word 'Pro'.
*/

SELECT Product_Id,
       Product_Name
FROM CO.Products
WHERE LOCATE(
          'pro',
          LOWER(Product_Name)
      ) > 0
ORDER BY Product_Name;


/* ============================================================
   SECTION E — EMAIL ANALYSIS
   Q23 TO Q27
   ============================================================ */


/*
Q23. Extract the part of each email address before '@'.
*/

SELECT Customer_ID,
       Email_Address,
       SUBSTRING_INDEX(
           Email_Address,
           '@',
           1
       ) AS Email_Username
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q24. Extract the domain from each customer's email address.
*/

SELECT Customer_ID,
       Email_Address,
       SUBSTRING_INDEX(
           Email_Address,
           '@',
           -1
       ) AS Email_Domain
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q25. Count customers by email domain.
*/

SELECT SUBSTRING_INDEX(
           Email_Address,
           '@',
           -1
       ) AS Email_Domain,
       COUNT(*) AS Customer_Count
FROM CO.Customers
GROUP BY SUBSTRING_INDEX(
             Email_Address,
             '@',
             -1
         )
ORDER BY Customer_Count DESC;


/*
Q26. Find all customers using the 'internalmail' email domain.
*/

SELECT Customer_ID,
       Full_Name,
       Email_Address
FROM CO.Customers
WHERE LOWER(
          SUBSTRING_INDEX(
              Email_Address,
              '@',
              -1
          )
      ) = 'internalmail'
ORDER BY Full_Name;


/*
Q27. Create a masked version of each customer's email.

Example:
tammy.bryant@internalmail
becomes
t***@internalmail
*/

SELECT Customer_ID,
       Email_Address,

       CONCAT(
           LEFT(
               SUBSTRING_INDEX(
                   Email_Address,
                   '@',
                   1
               ),
               1
           ),
           '***@',
           SUBSTRING_INDEX(
               Email_Address,
               '@',
               -1
           )
       ) AS Masked_Email

FROM CO.Customers
ORDER BY Customer_ID;


/* ============================================================
   SECTION F — CLEANING AND NORMALIZATION
   Q28 TO Q32
   ============================================================ */


/*
Q28. Show customer names after removing leading/trailing spaces
     and converting them to proper lowercase text.
*/

SELECT Customer_ID,
       Full_Name,
       LOWER(
           TRIM(Full_Name)
       ) AS Clean_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q29. Replace multiple hyphens in product names with spaces.
*/

SELECT Product_Id,
       Product_Name,
       REPLACE(
           Product_Name,
           '-',
           ' '
       ) AS Clean_Product_Name
FROM CO.Products
ORDER BY Product_Id;


/*
Q30. Remove all spaces from customer names.
*/

SELECT Customer_ID,
       Full_Name,
       REPLACE(
           Full_Name,
           ' ',
           ''
       ) AS Name_Without_Spaces
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q31. Convert customer names to uppercase and replace spaces
     with underscores.
*/

SELECT Customer_ID,
       Full_Name,
       REPLACE(
           UPPER(Full_Name),
           ' ',
           '_'
       ) AS Standardized_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q32. Create a cleaned email address using TRIM() and LOWER().
*/

SELECT Customer_ID,
       Email_Address,
       LOWER(
           TRIM(Email_Address)
       ) AS Clean_Email
FROM CO.Customers
ORDER BY Customer_ID;


/* ============================================================
   SECTION G — PADDING, REVERSING AND STRING FORMATTING
   Q33 TO Q37
   ============================================================ */


/*
Q33. Display every customer ID padded with leading zeros
     to a width of 5 characters.

Example:
1 -> 00001
*/

SELECT Customer_ID,
       LPAD(
           Customer_ID,
           5,
           '0'
       ) AS Formatted_Customer_ID
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q34. Display every store ID padded with leading zeros
     to a width of 3 characters.
*/

SELECT Store_Id,
       LPAD(
           Store_Id,
           3,
           '0'
       ) AS Formatted_Store_ID
FROM CO.Stores
ORDER BY Store_Id;


/*
Q35. Display product names padded with '*' on the right
     to a width of 20 characters.
*/

SELECT Product_Id,
       Product_Name,
       RPAD(
           Product_Name,
           20,
           '*'
       ) AS Padded_Product_Name
FROM CO.Products
ORDER BY Product_Id;


/*
Q36. Reverse every customer name.
*/

SELECT Customer_ID,
       Full_Name,
       REVERSE(Full_Name) AS Reversed_Name
FROM CO.Customers
ORDER BY Customer_ID;


/*
Q37. Show each product name together with its first and
     last character.
*/

SELECT Product_Id,
       Product_Name,
       LEFT(Product_Name, 1) AS First_Character,
       RIGHT(Product_Name, 1) AS Last_Character
FROM CO.Products
ORDER BY Product_Id;


/* ============================================================
   SECTION H — STRING + BUSINESS ANALYSIS
   Q38 TO Q42
   ============================================================ */


/*
Q38. Classify customers based on the length of their name:

    0-10 characters   -> Short Name
    11-20 characters -> Medium Name
    Over 20          -> Long Name
*/

SELECT Customer_ID,
       Full_Name,

       CASE
           WHEN CHAR_LENGTH(Full_Name) <= 10
               THEN 'Short Name'

           WHEN CHAR_LENGTH(Full_Name) <= 20
               THEN 'Medium Name'

           ELSE 'Long Name'
       END AS Name_Category

FROM CO.Customers
ORDER BY CHAR_LENGTH(Full_Name) DESC;


/*
Q39. Find the 10 customers with the longest names.
*/

SELECT Customer_ID,
       Full_Name,
       CHAR_LENGTH(Full_Name) AS Name_Length
FROM CO.Customers
ORDER BY Name_Length DESC
LIMIT 10;


/*
Q40. Count products by the first letter of their product name.
*/

SELECT UPPER(
           LEFT(Product_Name, 1)
       ) AS First_Letter,

       COUNT(*) AS Product_Count

FROM CO.Products

GROUP BY UPPER(
             LEFT(Product_Name, 1)
         )

ORDER BY First_Letter;


/*
Q41. Find the average product-name length by product category.

Note:
This query assumes the Products table contains a Category column.
*/

SELECT Category,
       ROUND(
           AVG(
               CHAR_LENGTH(Product_Name)
           ),
           2
       ) AS Avg_Name_Length
FROM CO.Products
GROUP BY Category
ORDER BY Avg_Name_Length DESC;


/*
Q42. Find customers whose first name starts with 'A'.
*/

SELECT Customer_ID,
       Full_Name,
       SUBSTRING_INDEX(
           Full_Name,
           ' ',
           1
       ) AS First_Name
FROM CO.Customers
WHERE UPPER(
          LEFT(
              SUBSTRING_INDEX(
                  Full_Name,
                  ' ',
                  1
              ),
              1
          )
      ) = 'A'
ORDER BY Full_Name;


/* ============================================================
   SECTION I — ADVANCED STRING PATTERNS
   Q43 TO Q45
   ============================================================ */


/*
Q43. Create a customer username from the customer's full name.

Example:
Tammy Bryant
becomes
tammy.bryant
*/

SELECT Customer_ID,
       Full_Name,

       LOWER(
           REPLACE(
               TRIM(Full_Name),
               ' ',
               '.'
           )
       ) AS Customer_Username

FROM CO.Customers
ORDER BY Customer_ID;


/*
Q44. Create a customer code using:

    First 3 characters of first name
    +
    Last 3 characters of last name
    +
    Customer ID padded to 4 digits

Example:
Tammy Bryant, ID 1
might become
tamrant0001
*/

SELECT Customer_ID,
       Full_Name,

       CONCAT(
           LOWER(
               LEFT(
                   SUBSTRING_INDEX(
                       Full_Name,
                       ' ',
                       1
                   ),
                   3
               )
           ),

           LOWER(
               RIGHT(
                   SUBSTRING_INDEX(
                       Full_Name,
                       ' ',
                       -1
                   ),
                   3
               )
           ),

           LPAD(
               Customer_ID,
               4,
               '0'
           )
       ) AS Customer_Code

FROM CO.Customers
ORDER BY Customer_ID;


/*
Q45. Create a customer summary containing:

    Customer ID
    Full Name
    First Name
    Last Name
    Email Username
    Email Domain
    Name Length
    Cleaned Username
*/

SELECT
    Customer_ID,

    Full_Name,

    SUBSTRING_INDEX(
        Full_Name,
        ' ',
        1
    ) AS First_Name,

    SUBSTRING_INDEX(
        Full_Name,
        ' ',
        -1
    ) AS Last_Name,

    SUBSTRING_INDEX(
        Email_Address,
        '@',
        1
    ) AS Email_Username,

    SUBSTRING_INDEX(
        Email_Address,
        '@',
        -1
    ) AS Email_Domain,

    CHAR_LENGTH(
        Full_Name
    ) AS Name_Length,

    LOWER(
        REPLACE(
            TRIM(Full_Name),
            ' ',
            '.'
        )
    ) AS Cleaned_Username

FROM CO.Customers

ORDER BY Customer_ID;


