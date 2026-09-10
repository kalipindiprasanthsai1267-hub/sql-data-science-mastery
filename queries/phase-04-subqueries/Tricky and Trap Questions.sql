/* 

Q56. You write WHERE Product_Id NOT IN (SELECT Product_ID FROM Order_Items). 
Your Order_Items table has 500 rows and 3 of them have NULL in Product_ID. 
How many rows does your query return and why?



Q57. What is the difference between these two queries and which one is faster?
-- Query 1
WHERE Customer_ID IN (SELECT Customer_ID FROM Orders WHERE Order_Status = 'COMPLETE')
-- Query 2
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.Customer_ID = c.Customer_ID AND o.Order_Status = 'COMPLETE')


Q58. You write a scalar subquery in the SELECT clause. At runtime it returns 3 rows instead of 1. What happens and how do you fix it?


Q59. Can a subquery reference a column from the outer query in its FROM clause? Explain with an example.


Q60. You write a derived table subquery in FROM without an alias. What happens?


Q61. What is the difference between these two?
sql-- Query 1
WHERE Unit_Price > ANY (SELECT Unit_Price FROM Order_Items)

-- Query 2
WHERE Unit_Price > ALL (SELECT Unit_Price FROM Order_Items)


Q62. You have a correlated subquery that runs once per row for a table with 1 million rows.
 What is the performance risk and what are two ways to rewrite it to be faster?


  */