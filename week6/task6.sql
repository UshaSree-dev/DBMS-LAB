USE taxation_db;

-- ============================================
-- PART A – BASIC SUBQUERIES
-- ============================================

-- Task 1: Income record having the highest income
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);


-- Task 2: Income record having the lowest income
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MIN(income_amount)
    FROM Income_Record
);


-- Task 3: Income records greater than average income
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);


-- Task 4: Income records equal to highest income
SELECT *
FROM Income_Record
WHERE income_amount = (
    SELECT MAX(income_amount)
    FROM Income_Record
);


-- Task 5: Taxpayers whose occupation is Business Owner
SELECT *
FROM Taxpayer
WHERE occupation = 'Business Owner';


-- ============================================
-- LEVEL 2 – APPLICATION
-- ============================================

-- Task 1: Taxpayers who have at least one income record
SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
);


-- Task 2: Taxpayers who have income in Business category
SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);


-- Task 3: Income records belonging to financial year 2025-2026
SELECT *
FROM Income_Record
WHERE financial_year_id IN (
    SELECT financial_year_id
    FROM Financial_Year
    WHERE year_name = '2025-2026'
);


-- Task 4: Income records greater than minimum Business income
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT MIN(income_amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);


-- Task 5: Income records less than maximum Salary income
SELECT *
FROM Income_Record
WHERE income_amount < (
    SELECT MAX(income_amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Salary'
    )
);


-- Task 6: Taxpayers who have income records greater than average income
SELECT DISTINCT taxpayer_id
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);


-- Task 7: Income categories having at least one income record
SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
);


-- Task 8: Taxpayers having no Investment income
SELECT *
FROM Taxpayer
WHERE taxpayer_id NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id = (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- ============================================
-- LEVEL 3 – MEDIUM TO ADVANCED
-- ============================================

-- Task 1: Taxpayer having the highest recorded income
SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE income_amount = (
        SELECT MAX(income_amount)
        FROM Income_Record
    )
);


-- Task 2: Income records greater than average Business income
SELECT *
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);


-- Task 3: Taxpayers whose income is greater than average income
SELECT DISTINCT taxpayer_id
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);


-- Task 4: Income records greater than ANY Investment income
SELECT *
FROM Income_Record
WHERE income_amount > ANY (
    SELECT income_amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- Task 5: Income records greater than ALL Investment income
SELECT *
FROM Income_Record
WHERE income_amount > ALL (
    SELECT income_amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- Task 6: Income category containing the highest income record
SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
    WHERE income_amount = (
        SELECT MAX(income_amount)
        FROM Income_Record
    )
);


-- Task 7: Financial year having the highest total income
SELECT *
FROM Financial_Year
WHERE financial_year_id IN (
    SELECT financial_year_id
    FROM Income_Record
    GROUP BY financial_year_id
    HAVING SUM(income_amount) = (
        SELECT MAX(total_income)
        FROM (
            SELECT SUM(income_amount) AS total_income
            FROM Income_Record
            GROUP BY financial_year_id
        ) AS yearly_income
    )
);

-- Task 8: Taxpayers whose total recorded income is greater than
-- the average total income of taxpayers

SELECT taxpayer_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(income_amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_income
);


-- ============================================
-- REAL-WORLD TAXATION ANALYSIS
-- ============================================

-- Task 1: Identify the taxpayer who has the highest individual income

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE income_amount = (
        SELECT MAX(income_amount)
        FROM Income_Record
    )
);


-- Task 2: Identify taxpayers whose income is above the overall average income

SELECT DISTINCT taxpayer_id
FROM Income_Record
WHERE income_amount > (
    SELECT AVG(income_amount)
    FROM Income_Record
);


-- Task 3: Identify the income category containing the highest income record

SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
    WHERE income_amount = (
        SELECT MAX(income_amount)
        FROM Income_Record
    )
);


-- Task 4: Identify taxpayers who have Business income
-- but no Investment income

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
)
AND taxpayer_id NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- Task 5: Identify income records whose amount is greater
-- than every Investment income record

SELECT *
FROM Income_Record
WHERE income_amount > ALL (
    SELECT income_amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- Task 6: Identify income records whose amount is greater
-- than at least one Investment income record

SELECT *
FROM Income_Record
WHERE income_amount > ANY (
    SELECT income_amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- Task 7: Display the taxpayer(s) having the highest total income

SELECT taxpayer_id, SUM(income_amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(income_amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_totals
);


-- Task 8: Generate a list of income records whose amount is
-- above the average income of their corresponding category

SELECT ir.*
FROM Income_Record ir
JOIN (
    SELECT category_id, AVG(income_amount) AS avg_income
    FROM Income_Record
    GROUP BY category_id
) AS category_average
ON ir.category_id = category_average.category_id
WHERE ir.income_amount > category_average.avg_income;