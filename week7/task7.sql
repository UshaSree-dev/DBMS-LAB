USE taxation_db;

-- =========================================================
-- PART A – BASIC VIEWS
-- =========================================================

-- Task 1: Income record having the highest income
CREATE OR REPLACE VIEW highest_income_view AS
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM highest_income_view;


-- Task 2: Income record having the lowest income
CREATE OR REPLACE VIEW lowest_income_view AS
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MIN(income_amount)
    FROM Income_Record
);

SELECT * FROM lowest_income_view;


-- Task 3: Income records greater than average income
CREATE OR REPLACE VIEW above_average_income AS
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);

SELECT * FROM above_average_income;


-- Task 4: Income records equal to highest recorded income
CREATE OR REPLACE VIEW highest_recorded_income AS
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM highest_recorded_income;


-- Task 5: Taxpayers whose occupation is Business Owner
CREATE OR REPLACE VIEW business_owner_view AS
SELECT taxpayer_id, taxpayer_name, occupation
FROM Taxpayer
WHERE occupation = 'Business Owner';

SELECT * FROM business_owner_view;


-- =========================================================
-- PART B – APPLICATION
-- =========================================================

-- Task 1: Taxpayers who have at least one income record
CREATE OR REPLACE VIEW taxpayers_with_income AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id;

SELECT * FROM taxpayers_with_income;


-- Task 2: Taxpayers who have income in Business category
CREATE OR REPLACE VIEW business_income_taxpayers AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = 'Business';

SELECT * FROM business_income_taxpayers;


-- Task 3: Income records belonging to financial year 2025-2026
CREATE OR REPLACE VIEW income_2025_2026 AS
SELECT i.*
FROM Income_Record i
INNER JOIN Financial_Year f
ON i.financial_year_id = f.financial_year_id
WHERE f.financial_year = '2025-2026';

SELECT * FROM income_2025_2026;


-- Task 4: Income records greater than minimum Business income
CREATE OR REPLACE VIEW greater_than_min_business_income AS
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT MIN(i.income_amount)
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Business'
);

SELECT * FROM greater_than_min_business_income;


-- Task 5: Income records less than maximum Salary income
CREATE OR REPLACE VIEW less_than_max_salary_income AS
SELECT *
FROM Income_Record
WHERE income_amount < (
    SELECT MAX(i.income_amount)
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Salary'
);

SELECT * FROM less_than_max_salary_income;


-- Task 7: Taxpayers having income greater than average income
CREATE OR REPLACE VIEW taxpayers_above_average_income AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);

SELECT * FROM taxpayers_above_average_income;


-- Task 7: Income categories having at least one income record
CREATE OR REPLACE VIEW categories_with_income AS
SELECT DISTINCT c.*
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id;

SELECT * FROM categories_with_income;


-- Task 8: Taxpayers having no Investment income
CREATE OR REPLACE VIEW taxpayers_without_investment AS
SELECT t.*
FROM Taxpayer t
WHERE t.taxpayer_id NOT IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM taxpayers_without_investment;


-- =========================================================
-- PART C – MEDIUM TO ADVANCED
-- =========================================================

-- Task 1: Taxpayer having the highest recorded income
CREATE OR REPLACE VIEW taxpayer_highest_income AS
SELECT t.taxpayer_id, t.taxpayer_name, i.income_amount
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM taxpayer_highest_income;


-- Task 2: Income records greater than average Business income
CREATE OR REPLACE VIEW greater_than_average_business_income AS
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(i.income_amount)
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Business'
);

SELECT * FROM greater_than_average_business_income;


-- Task 3: Taxpayers whose total income is greater than
-- average total income of all taxpayers
CREATE OR REPLACE VIEW taxpayers_above_average_total AS
SELECT taxpayer_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(income_amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT taxpayer_id, SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS temp
);

SELECT * FROM taxpayers_above_average_total;


-- Task 4: Income records greater than at least one Investment income
CREATE OR REPLACE VIEW greater_than_any_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ANY (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM greater_than_any_investment;


-- Task 5: Income records greater than every Investment income
CREATE OR REPLACE VIEW greater_than_all_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ALL (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM greater_than_all_investment;


-- Task 7: Income category containing the highest income record
CREATE OR REPLACE VIEW category_highest_income AS
SELECT DISTINCT c.category_id, c.category_name
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id
WHERE i.income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM category_highest_income;
-- Task 8: Taxpayers whose total recorded income is
-- greater than average total income
CREATE OR REPLACE VIEW high_total_income_taxpayers AS
SELECT taxpayer_id,
       SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(income_amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT taxpayer_id,
               SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS temp
);

SELECT * FROM high_total_income_taxpayers;


-- =========================================================
-- PART D – REAL-WORLD TAXATION ANALYSIS
-- =========================================================

-- Task 1: Taxpayer having the highest individual income
CREATE OR REPLACE VIEW highest_individual_income_taxpayer AS
SELECT t.taxpayer_id,
       t.taxpayer_name,
       i.income_amount
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM highest_individual_income_taxpayer;


-- Task 2: Taxpayers whose income is above overall average
CREATE OR REPLACE VIEW above_overall_average_taxpayers AS
SELECT DISTINCT t.taxpayer_id,
       t.taxpayer_name,
       i.income_amount
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);

SELECT * FROM above_overall_average_taxpayers;


-- Task 3: Income category containing highest income record
CREATE OR REPLACE VIEW category_containing_highest_income AS
SELECT DISTINCT c.category_id,
       c.category_name
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id
WHERE i.income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);

SELECT * FROM category_containing_highest_income;


-- Task 4: Taxpayers having Business income but no Investment income
CREATE OR REPLACE VIEW business_no_investment_taxpayers AS
SELECT t.*
FROM Taxpayer t
WHERE t.taxpayer_id IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Business'
)
AND t.taxpayer_id NOT IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM business_no_investment_taxpayers;


-- Task 5: Income records greater than every Investment income
CREATE OR REPLACE VIEW income_greater_than_every_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ALL (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM income_greater_than_every_investment;


-- Task 6: Income records greater than at least one Investment income
CREATE OR REPLACE VIEW income_greater_than_any_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ANY (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM income_greater_than_any_investment;


-- Task 7: Taxpayer(s) having the highest total income
CREATE OR REPLACE VIEW highest_total_income_taxpayers AS
SELECT t.taxpayer_id,
       t.taxpayer_name,
       SUM(i.income_amount) AS total_income
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
GROUP BY t.taxpayer_id, t.taxpayer_name
HAVING SUM(i.income_amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT taxpayer_id,
               SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS temp
);

SELECT * FROM highest_total_income_taxpayers;


-- Task 8: Income records above the average income
-- of their corresponding category
CREATE OR REPLACE VIEW above_category_average_income AS
SELECT i.income_id,
       i.taxpayer_id,
       i.category_id,
       i.income_amount
FROM Income_Record i
INNER JOIN (
    SELECT category_id,
           AVG(income_amount) AS average_income
    FROM Income_Record
    GROUP BY category_id
) AS category_avg
ON i.category_id = category_avg.category_id
WHERE i.income_amount > category_avg.average_income;

SELECT * FROM above_category_average_income;


-- =========================================================
-- VIEW MANAGEMENT
-- =========================================================

-- Display all views
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';


-- Example: Replace a view
CREATE OR REPLACE VIEW business_owner_view AS
SELECT taxpayer_id,
       taxpayer_name,
       occupation
FROM Taxpayer
WHERE occupation = 'Business Owner';


-- Example: Drop a view
DROP VIEW IF EXISTS business_owner_view;