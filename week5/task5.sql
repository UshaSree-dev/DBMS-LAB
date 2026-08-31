USE taxation_db;

-- ============================================
-- PART A – VERIFY PREVIOUS DATABASE
-- ============================================

SHOW TABLES;

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;


-- ============================================
-- PART B – AGGREGATE FUNCTIONS
-- ============================================

-- LEVEL 1 – UNDERSTANDING

-- Task 1: Total number of income records
SELECT COUNT(*) AS total_income_records
FROM Income_Record;

-- Task 2: Total income amount
SELECT SUM(income_amount) AS total_income
FROM Income_Record;

-- Task 3: Average income amount
SELECT AVG(income_amount) AS average_income
FROM Income_Record;

-- Task 4: Highest income amount
SELECT MAX(income_amount) AS highest_income
FROM Income_Record;

-- Task 5: Lowest income amount
SELECT MIN(income_amount) AS lowest_income
FROM Income_Record;


-- ============================================
-- LEVEL 2 – APPLICATION
-- ============================================

-- Task 1: Number of income records for each category
SELECT category_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY category_id;

-- Task 2: Total income for each category
SELECT category_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id;

-- Task 3: Average income for each category
SELECT category_id, AVG(income_amount) AS average_income
FROM Income_Record
GROUP BY category_id;

-- Task 4: Highest income in each category
SELECT category_id, MAX(income_amount) AS highest_income
FROM Income_Record
GROUP BY category_id;

-- Task 5: Lowest income in each category
SELECT category_id, MIN(income_amount) AS lowest_income
FROM Income_Record
GROUP BY category_id;

-- Task 6: Total income for each financial year
SELECT year_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY year_id;

-- Task 7: Number of income records for each financial year
SELECT year_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY year_id;

-- Task 8: Total income for each category in each financial year
SELECT category_id, year_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id, year_id;


-- ============================================
-- LEVEL 3 – MEDIUM TO ADVANCED
-- ============================================

-- Task 1: Categories whose total income > ₹10,00,000
SELECT category_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id
HAVING SUM(income_amount) > 1000000;

-- Task 2: Categories whose average income > ₹5,00,000
SELECT category_id, AVG(income_amount) AS average_income
FROM Income_Record
GROUP BY category_id
HAVING AVG(income_amount) > 500000;

-- Task 3: Financial years having more than 3 income records
SELECT year_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY year_id
HAVING COUNT(*) > 3;

-- Task 4: Categories in descending order of total income
SELECT category_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id
ORDER BY SUM(income_amount) DESC;

-- Task 5: Categories with total income > ₹10,00,000,
-- arranged from highest to lowest
SELECT category_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id
HAVING SUM(income_amount) > 1000000
ORDER BY SUM(income_amount) DESC;

-- Task 6: Total income and average income for each category
SELECT category_id,
       SUM(income_amount) AS total_income,
       AVG(income_amount) AS average_income
FROM Income_Record
GROUP BY category_id;

-- Task 7: Category and financial year combination
-- having the highest total income
SELECT category_id,
       year_id,
       SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id, year_id
ORDER BY SUM(income_amount) DESC
LIMIT 1;

-- Task 8: Number of taxpayers having income records
-- in each financial year
SELECT year_id,
       COUNT(DISTINCT taxpayer_id) AS number_of_taxpayers
FROM Income_Record
GROUP BY year_id;


-- ============================================
-- PART C – REAL-WORLD TAXATION ANALYSIS
-- ============================================

-- Task 1: Income category generating highest total income
SELECT category_id,
       SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY category_id
ORDER BY SUM(income_amount) DESC
LIMIT 1;

-- Task 2: Financial year having highest total income
SELECT year_id,
       SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY year_id
ORDER BY SUM(income_amount) DESC
LIMIT 1;

-- Task 3: Income category having highest average income
SELECT category_id,
       AVG(income_amount) AS average_income
FROM Income_Record
GROUP BY category_id
ORDER BY AVG(income_amount) DESC
LIMIT 1;

-- Task 4: Income categories having more than 2 records
SELECT category_id,
       COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY category_id
HAVING COUNT(*) > 2;

-- Task 5: Financial years having total income > ₹10,00,000
SELECT year_id,
       SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY year_id
HAVING SUM(income_amount) > 1000000;

-- Task 6: Complete summary report
SELECT category_id,
       COUNT(*) AS number_of_records,
       SUM(income_amount) AS total_income,
       AVG(income_amount) AS average_income,
       MAX(income_amount) AS highest_income,
       MIN(income_amount) AS lowest_income
FROM Income_Record
GROUP BY category_id;