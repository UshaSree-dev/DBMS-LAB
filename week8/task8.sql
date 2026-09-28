USE taxation_db;

SHOW TABLES;


-- =========================
-- PART A: TCL
-- =========================

-- TASK 1: Disable AUTOCOMMIT
SET AUTOCOMMIT = 0;

SELECT @@AUTOCOMMIT;


-- TASK 2: UPDATE and COMMIT
START TRANSACTION;

UPDATE Income_Record
SET income_amount = 850000
WHERE income_record_id = 3;

SELECT *
FROM Income_Record
WHERE income_record_id = 3;

COMMIT;


-- TASK 3: UPDATE and ROLLBACK
START TRANSACTION;

UPDATE Income_Record
SET income_amount = 950000
WHERE income_record_id = 3;

SELECT *
FROM Income_Record
WHERE income_record_id = 3;

ROLLBACK;

SELECT *
FROM Income_Record
WHERE income_record_id = 3;


-- TASK 4: DELETE and ROLLBACK
START TRANSACTION;

DELETE FROM Income_Record
WHERE income_record_id = 1001;

SELECT *
FROM Income_Record
WHERE income_record_id = 1001;

ROLLBACK;

SELECT *
FROM Income_Record
WHERE income_record_id = 1001;


-- TASK 5: INSERT and ROLLBACK
START TRANSACTION;

INSERT INTO Income_Record
VALUES
(1010, 101, 'Temporary Income', 1, 500000, '2026-03-31', 6);

SELECT *
FROM Income_Record
WHERE income_record_id = 1010;

ROLLBACK;

SELECT *
FROM Income_Record
WHERE income_record_id = 1010;


-- TASK 6: Two DML operations and COMMIT
START TRANSACTION;

UPDATE Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1001;

INSERT INTO Income_Record
VALUES
(1011, 101, 'Additional Income', 1, 250000, '2026-03-31', 6);

COMMIT;

SELECT *
FROM Income_Record
WHERE income_record_id IN (1001, 1011);


-- =========================
-- PART B: SAVEPOINTS
-- =========================

-- TASK 1: SAVEPOINT
START TRANSACTION;

UPDATE Taxpayer
SET annual_income = annual_income + 10000
WHERE taxpayer_id = 101;

SAVEPOINT income_update;

UPDATE Taxpayer
SET annual_income = annual_income + 20000
WHERE taxpayer_id = 102;

ROLLBACK TO SAVEPOINT income_update;

SELECT taxpayer_id, annual_income
FROM Taxpayer
WHERE taxpayer_id IN (101, 102);

COMMIT;


-- TASK 2: INSERT + SAVEPOINT
START TRANSACTION;

INSERT INTO Income_Record
VALUES
(1012, 101, 'New Income', 1, 200000, '2026-03-31', 6);

SAVEPOINT income_insert;

UPDATE Income_Record
SET income_amount = income_amount + 5000
WHERE income_record_id = 1002;

ROLLBACK TO SAVEPOINT income_insert;

COMMIT;


-- TASK 3: Multiple SAVEPOINTS
START TRANSACTION;

UPDATE Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1001;

SAVEPOINT sp1;

UPDATE Income_Record
SET income_amount = income_amount + 2000
WHERE income_record_id = 1002;

SAVEPOINT sp2;

UPDATE Income_Record
SET income_amount = income_amount + 3000
WHERE income_record_id = 1003;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;


-- TASK 4: INSERT + UPDATE + DELETE + SAVEPOINT
START TRANSACTION;

INSERT INTO Income_Record
VALUES
(1013, 101, 'New Income', 1, 300000, '2026-03-31', 6);

UPDATE Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1002;

SAVEPOINT before_delete;

DELETE FROM Income_Record
WHERE income_record_id = 1003;

ROLLBACK TO SAVEPOINT before_delete;

COMMIT;


-- TASK 5: RELEASE SAVEPOINT
START TRANSACTION;

UPDATE Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1001;

SAVEPOINT income_update;

RELEASE SAVEPOINT income_update;

ROLLBACK;


-- TASK 6: ROLLBACK vs ROLLBACK TO SAVEPOINT
START TRANSACTION;

UPDATE Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1001;

SAVEPOINT sp1;

UPDATE Income_Record
SET income_amount = income_amount + 2000
WHERE income_record_id = 1002;

ROLLBACK TO SAVEPOINT sp1;

SELECT income_record_id, income_amount
FROM Income_Record
WHERE income_record_id IN (1001, 1002);

COMMIT;


-- =========================
-- PART C: DCL
-- =========================

-- TASK 1: Create tax_clerk1
CREATE USER 'tax_clerk1'@'localhost'
IDENTIFIED BY 'Tax@123';

SELECT User, Host
FROM mysql.user
WHERE User = 'tax_clerk1';


-- TASK 2: Grant SELECT on Taxpayer
GRANT SELECT
ON taxation_db.Taxpayer
TO 'tax_clerk1'@'localhost';

SHOW GRANTS
FOR 'tax_clerk1'@'localhost';


-- TASK 3: Grant INSERT on Income_Record
GRANT INSERT
ON taxation_db.Income_Record
TO 'tax_clerk1'@'localhost';

SHOW GRANTS
FOR 'tax_clerk1'@'localhost';


-- TASK 4: Attempt UPDATE without UPDATE privilege
UPDATE taxation_db.Income_Record
SET income_amount = income_amount + 1000
WHERE income_record_id = 1001;


-- TASK 5: Grant SELECT on taxation summary View
GRANT SELECT
ON taxation_db.taxpayer_total_income
TO 'tax_clerk1'@'localhost';

SHOW GRANTS
FOR 'tax_clerk1'@'localhost';


-- TASK 6: Revoke INSERT
REVOKE INSERT
ON taxation_db.Income_Record
FROM 'tax_clerk1'@'localhost';

SHOW GRANTS
FOR 'tax_clerk1'@'localhost';


-- =========================
-- PART D: SECURITY AND
-- LEAST PRIVILEGE
-- =========================

-- TASK 1: Create tax_data_entry
CREATE USER 'tax_data_entry'@'localhost'
IDENTIFIED BY 'Tax@123';

GRANT SELECT, INSERT
ON taxation_db.Income_Record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS
FOR 'tax_data_entry'@'localhost';


-- TASK 2: Create tax_officer
CREATE USER 'tax_officer'@'localhost'
IDENTIFIED BY 'Tax@123';

GRANT SELECT, INSERT, UPDATE
ON taxation_db.Income_Record
TO 'tax_officer'@'localhost';

SHOW GRANTS
FOR 'tax_officer'@'localhost';

-- Test DELETE
DELETE FROM taxation_db.Income_Record
WHERE income_record_id = 1001;


-- TASK 3: Grant SELECT on taxation summary View
GRANT SELECT
ON taxation_db.taxpayer_total_income
TO 'tax_officer'@'localhost';

SHOW GRANTS
FOR 'tax_officer'@'localhost';
-- TASK 4: Grant multiple privileges and revoke UPDATE
GRANT SELECT, INSERT, UPDATE
ON taxation_db.Income_Record
TO 'tax_officer'@'localhost';

REVOKE UPDATE
ON taxation_db.Income_Record
FROM 'tax_officer'@'localhost';

SHOW GRANTS
FOR 'tax_officer'@'localhost';


-- TASK 5: Compare privileges
SHOW GRANTS
FOR 'tax_data_entry'@'localhost';

SHOW GRANTS
FOR 'tax_officer'@'localhost';


-- TASK 6: Minimum privilege test
GRANT SELECT, INSERT
ON taxation_db.Income_Record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS
FOR 'tax_data_entry'@'localhost';


-- =========================
-- FINAL VERIFICATION
-- =========================

USE taxation_db;

SHOW TABLES;

SELECT * FROM Taxpayer;

SELECT * FROM Income_Category;

SELECT * FROM Financial_Year;

SELECT * FROM Income_Record;

SELECT @@AUTOCOMMIT;

SET AUTOCOMMIT = 1;

SELECT CURRENT_USER();

SHOW GRANTS
FOR 'tax_clerk1'@'localhost';


-- Optional cleanup if these were created only for the lab
DROP USER IF EXISTS 'tax_clerk1'@'localhost';