/*   

Q74. You write RANK() OVER(ORDER BY Revenue DESC) and get ranks 1, 2, 2, 4. Your manager says rank 3 is missing. How do you explain this and how would you fix it if they want no gaps?





Q75. You use LAST_VALUE(Revenue) OVER(PARTITION BY Customer_ID ORDER BY Order_Date) and the result looks wrong — it returns the current row's value instead of the last value. Why and how do you fix it?





Q76. What is the difference between these two queries?

sql
-- Query 1
SUM(Revenue) OVER(PARTITION BY Customer_ID)

-- Query 2
SUM(Revenue) OVER(PARTITION BY Customer_ID ORDER BY Order_Date)





Q77. You write ROW_NUMBER() OVER(ORDER BY Revenue DESC) and want to get only the top 3 rows. You add WHERE ROW_NUMBER() = 1 but get an error. Why and how do you fix it?





Q78. What happens when you use AVG() OVER(ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) on the first two rows where there are fewer than 2 preceding rows?





Q79. What is the difference between these two?

sql
COUNT(*) OVER()
COUNT(*) OVER(PARTITION BY Customer_ID)





Q80. You need to find the second highest revenue per store. Someone suggests using RANK() OVER(PARTITION BY Store_Id ORDER BY Revenue DESC) = 2. What is the problem with this approach directly in WHERE and how do you correctly implement it?




Q81. Can you use PARTITION BY without ORDER BY inside OVER()? Can you use ORDER BY without PARTITION BY? What does each produce?



  */