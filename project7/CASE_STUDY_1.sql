create database KUNAL_BATCH
USE KUNAL_BATCH

SELECT *FROM FACT
SELECT * FROM LOCATION
SELECT *FROM PRODUCT
--1. DISPLAY THE NO. OF STATESPRESENT IN LOCATION OF THE TABLE
SELECT COUNT(DISTINCT STATE) AS [COUNT OF STATE] FROM LOCATION

--2. HOW MANY PRODUCT ARE OF REGULAR TYPE
SELECT COUNT(PRODUCT) AS [COUNT OF PRODUCT] FROM PRODUCT 
WHERE TYPE= 'REGULAR'

-- 3. HOW MUCH SPENDING
SELECT SUM(MARKETING) AS MARKETING FROM FACT WHERE PRODUCTID = 1;

--4. WHAT IS THE MIN SALES OF A PRODUCT
SELECT MIN(SALES) AS [MINIMUM SALES]FROM FACT

--5. DISPLAY THE MAX COST OF GOOD SOLD (COGS)
SELECT MAX(COGS)AS [MAXIMUM COGS] FROM FACT
--6. Display the details of the product where product tYPE IS COFFEE.
SELECT*FROM PRODUCT WHERE PRODUCT_TYPE = 'COFFEE'
--LIKE operator is use differentLY
--7. Display the details where total expenses are greater than 40.
select *from fact where TOTAL_EXPENSES > 40
--8. What is the average sales in area code 719?
SELECT AVG(SALES) AS [AVERAGE SALES] FROM FACT WHERE Area_Code = 719
-- 9. Find out the total profit generated by Colorado state.
SELECT SUM(PROFIT) AS [TOTAL PROFIT] FROM FACT
INNER JOIN
LOCATION ON FACT.AREA_CODE = LOCATION.AREA_CODE
WHERE STATE = 'COLORADO'
--10. Display the average inventory for each product ID.
SELECT PRODUCTID, AVG(INVENTORY) AS AVG_INVENTORY FROM FACT GROUP BY ProductId ORDER BY ProductId
--11. Display state in a sequential order in a Location Table
SELECT * FROM LOCATION ORDER BY STATE
-- OR
SELECT * FROM LOCATION ORDER BY STATE DESC
-- 12.Display the average budget of the Product where the average budget margin should be greater than 100

SELECT PRODUCTID, AVG(BUDGET_MARGIN) AS AVG_BUDGET_MARGIN FROM FACT GROUP BY ProductId 
HAVING AVG(BUDGET_MARGIN)>100 ---WITH GROUP BY WE NEED TO USE 'HAVING'
--WHERE AVG(BUDGET_MARGIN) >100 -- 'ERROR'
--13.What is the total sales done on date 2010-01-01
SELECT SUM(SALES) AS [TOTAL SALES] FROM FACT WHERE DATE = '2010-01-01'
--14. Display the average total expense of each product ID on an individual date.
SELECT PRODUCTID, DATE, AVG(TOTAL_EXPENSES) AS [AVG TOTAL EXPENSES] FROM FACT GROUP BY PRODUCTID, DATE

 --15. Display the table with the following attributes such as date, productID, product_type, product, sales, profit, state, area_code. 
 SELECT FACT.DATE, FACT.PRODUCTID, PRODUCT.PRODUCT_TYPE, PRODUCT.PRODUCT, FACT.SALES, FACT.PROFIT, LOCATION.STATE,LOCATION.AREA_CODE FROM FACT
 INNER JOIN LOCATION ON
 FACT.AREA_CODE =  LOCATION.AREA_CODE
 INNER JOIN PRODUCT
 ON FACT.PRODUCTID = PRODUCT.PRODUCTID

 --16. Display the rank without any gap to show the sale
 select date, productid, sales, profit,
 dense_RANK() OVER(ORDER BY SALES) AS DENSE_RANK_NO
 FROM FACT

 -- 17. Find the state wise profit and sales.

select state, sum(sales) as TOTAL_SALES, SUM(PROFIT) AS TOTAL_PROFIT 
FROM FACT 
INNER JOIN 
LOCATION ON FACT.AREA_CODE = LOCATION.AREA_CODE 
GROUP BY STATE


--18. Find the state wise profit and sales along  with productname
select PRODUCT, STATE, SUM(SALES) AS SALES, SUM(PROFIT) AS TOTAL_PROFIT 
FROM FACT 
INNER JOIN 
LOCATION ON 
FACT.AREA_CODE = LOCATION.AREA_CODE 
INNER JOIN 
PRODUCT ON 
FACT.PRODUCTID = PRODUCT.PRODUCTID 
GROUP BY STATE, PRODUCT

--19. If there is an increase in sales of 5%, calculate the increasedsales.
SELECT SALES , (SALES * 1.05) 
AS INCREASED_SALES 
FROM FACT

--20. Find the maximum profit along with the product ID and producttype
SELECT  FACT.PRODUCTID, PRODUCT.PRODUCT_TYPE, FACT.PROFIT FROM FACT 
INNER JOIN 
PRODUCT
ON 
FACT.PRODUCTID = PRODUCT.PRODUCTID 
WHERE FACT.PROFIT =  (SELECT MAX(PROFIT) FROM FACT)

--21. Create a stored procedure to fetch the result according to the product type from Product Table.
CREATE PROCEDURE PTYPE @PROD_TYPE VARCHAR(50) AS 
SELECT * FROM PRODUCT WHERE PRODUCT_TYPE  = @PROD_TYPE

EXECUTE PTYPE @PROD_TYPE = 'COFFEE'
EXECUTE PTYPE @PROD_TYPE = 'TEA'

/*22. Write a query by creating a condition in which if the total expenses is less than 60 
then it is a profit or else loss.*/
SELECT TOTAL_EXPENSES,
IIF(TOTAL_EXPENSES<60,'PROFIT','LOSS' ) AS STATUS 
FROM FACT

/*23. Give the total weekly sales value with the date and product ID details. 
Use roll-up to pull the data in hierarchical order.*/

SELECT DATEPART(WEEK, [DATE]) AS [WEEKLY SALES], DATE, PRODUCTID, SUM(SALES) AS TOTAL_SALES
FROM FACT 
GROUP BY ROLLUP(DATEPART(WEEK, [DATE]), DATE, PRODUCTID)

--24. Apply union and intersection operator on the tables which consist of attribute area code.

SELECT AREA_CODE FROM FACT
UNION 
SELECT AREA_CODE FROM LOCATION

SELECT AREA_CODE FROM FACT
INTERSECT 
SELECT AREA_CODE FROM LOCATION

/*25. Create a user-defined function for the product table to fetch a particular product type 
based upon the user�s preference.*/

CREATE FUNCTION PROD_TABLE (@PRODUCT_TYPE VARCHAR(40))
RETURNS TABLE AS 
RETURN 
SELECT * FROM PRODUCT WHERE PRODUCT_TYPE =  @PRODUCT_TYPE

SELECT * FROM PROD_TABLE('COFFEE')

--26. Change the product type from coffee to tea where product ID is 1 and undo it.

SELECT * FROM PRODUCT

BEGIN TRANSACTION
UPDATE PRODUCT 
SET 
PRODUCT_TYPE = 'TEA' 
WHERE PRODUCTID = 1

SELECT * FROM PRODUCT

ROLLBACK TRANSACTION

SELECT * FROM PRODUCT

-- 27. Display the date, product ID and sales where total expenses are between 100 to 200.
SELECT DATE, PRODUCTID, SALES, TOTAL_EXPENSES FROM FACT 
WHERE TOTAL_EXPENSES BETWEEN 100 AND 200

--28. Delete the records in the Product Table for regular type.
SELECT * FROM PRODUCT

DELETE FROM PRODUCT 
WHERE Type = 'Regular'

--29. Display the ASCII value of the fifth character from the column Product

SELECT PRODUCT, (ASCII(SUBSTRING(PRODUCT,5,1))) AS [ASCII VALUE OF FIFTH CHARACTER]
FROM PRODUCT