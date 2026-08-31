USE taxation_db
SHOW TABLES;
SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

SELECT COUNT(*) AS Total_Income_Records
FROM Income_Record;

SELECT SUM(income_amount) AS Total_income 
FROM Income_Record;

SELECT AVG(income_amount) AS Average_Income FROM Icome_Record;

SELECT MAX(income_amount) AS Highest_Income FROM Income_Record;

SELECT MIN(income_amount) AS Lowest_Income FROM Income_Record;

SELECT category_id,
COUNT(*) AS Number_of_Records
FROM Income_Record
GROUP BY category_id;

SELECT category_id,
SUM(income_amount) AS Total_income
FROM Income_Record
GROUP BY category_id;

SELECT category_id,
AVG(income_amount) AS Average_Income
FROM Income_Record
GROUP BY category_id;

SELECT category_id,
MAX(income_amount) AS Highest_Income
FROM Income_Record
GROUP BY category_id;

SELECT category_id,
MIN(income_amount) AS Lowest_Income
FROM Income_Record
GROUP BY category_id;

SELECT year_id,
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY year_id;


SELECT year_id,
COUNT(*) AS Number_of_Records
FROM Income_Record
GROUP BY year_id;

SELECT category_id,
year_id
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY category_id,year_id;

SELECT category_id,
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY category_id
HAVING SUM(income_amount)>1000000;

SELECT category_id,
AVG(income_amount) AS Average_Income
FROM Income_Record
GROUP BY category_id
HAVING AVG(income_amount)>500000;

SELECT year_id,
COUNT(*) AS Total_Income_Records
FROM Income_Record
GROUP BY year_id
HAVING COUNT(*)>3;

SELECT category_id,
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY category_id
ORDER BY Total_income DESC;


SELECT category_id,
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY category_id
HAVING SUM(income_amount)>1000000
ORDER BY Total_income DESC;


SELECT category_id,
SUM(income_amount) AS Total_Income,
AVG(income_amount) AS Average_Income
FROM Income_Record
GROUP BY category_id;

SELECT category_id,
year_id,
SUM(income_amount) AS Total_Income
FROM Income_Record
GROUP BY cateory_id,year_id
ORDER BY Total_Income DESC
LIMIT 1;

SELECT year_id,
COUNT(DISTINCT taxpayer_id) AS
Number_of_taxpayers
FROM Income_Record
GROUP BY year_id;

SELECT C.category_name,
SUM(I.income_amount) AS Total_Income
FROM Income_Record I
JOIN Income_category C
ON I.category_id = C.category_id
GROUP BY C.category_name
ORDER BY Total_Income DESC

SELECT F.financial_year,
SUM(I.income_amount) AS Total_Income
FROM Income_Record I
JOIN Financial_Year F
ON I.year_id = F.year_id
GROUP BY f.financial_year
ORDER BY Total_Income DESC
LIMIT 1;

SELECT C.category_name,
AVG(I.income_amount) AS Average_Income
FROM Income_Record I
JOIN Income_category C
ON I.category_id = C.category_id
GROUP BY C.category_name
ORDER BY Average_Income DESC


SELECT C.category_name,
COUNT(*) AS Number_of_Records
FROM Income_Record I
JOIN Income_category C
ON I.category_id = C.category_id
GROUP BY C.category_name
HAVING COUNT(*)>2;


SELECT F.financial_year,
SUM(I.income_amount) AS Total_Income
FROM Income_Record I
JOIN Financial_Year F
ON I.year_id = F.year_id
GROUP BY f.financial_year
HAVING SUM(I.income_amount)>1000000;


SELECT C.category_name,
COUNT(*) AS Number_of_Records
SUM(I.income_amount) AS Total_Income,
AVG(I.income_amount) AS Average_Income,
MAX(I.income_amount) AS  Highest_Income,
MIN(I.income_amount) AS Lowest_Income
FROM Income_Record I
JOIN Income_Category C 
ON I.category_id = C.category_id
GROUP BY C.category_name
