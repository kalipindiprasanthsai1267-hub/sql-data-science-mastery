/*  Q63. You write a LEFT JOIN between Customers and Orders. 
You then add a WHERE clause filtering Order_Status = 'COMPLETE'. 
Will customers with no orders still appear in the result? Why or why not?  */



/*  Q64. What is the difference between these two queries — are they identical?
sql-- Query 1
SELECT * FROM A LEFT JOIN B ON A.id = B.id WHERE B.col = 'X'

-- Query 2
SELECT * FROM A LEFT JOIN B ON A.id = B.id AND B.col = 'X' */



/*  Q65. You join Orders to Order_Items. One order has 5 items. 
How many rows appear in the result for that order? What is this called? */




/* Q66. You write SELECT COUNT(*) FROM Customers LEFT JOIN Orders ON .... Will this give you the number of customers or the number of order rows? Explain.	 */




/* Q67. What is the difference between these two?
sqlCOUNT(*) vs COUNT(o.Order_Id) in a LEFT JOIN  */




/*  Q68. You need to find records in Table A that don't exist in Table B. 
You write NOT IN with a subquery. What is the hidden danger and when does it silently return wrong results? */




/* Q69. If Table A has 100 rows and Table B has 50 rows and you do a CROSS JOIN — how many rows do you get? What if Table B has 0 rows?  */




/* Q70. Can you use aggregate functions directly in a JOIN condition? For example ON a.id = MAX(b.id). Why or why not?  */



