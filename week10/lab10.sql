/* ============================================================
   DBMS LAB – TASK 10
   PL/SQL / STORED PROGRAMS
   DATABASE: TaxationDB
   ============================================================ */

-- Select database/schema as required
-- ALTER SESSION SET CURRENT_SCHEMA = TaxationDB;


/* ============================================================
   PART A – FUNCTION: calculate_tax
   ============================================================ */

CREATE OR REPLACE FUNCTION calculate_tax (
    p_income NUMBER
)
RETURN NUMBER
IS
    v_tax NUMBER := 0;
BEGIN
    IF p_income <= 500000 THEN
        v_tax := 0;

    ELSIF p_income <= 1000000 THEN
        v_tax := (p_income - 500000) * 0.10;

    ELSIF p_income <= 1500000 THEN
        v_tax := 50000 + (p_income - 1000000) * 0.20;

    ELSE
        v_tax := 150000 + (p_income - 1500000) * 0.30;
    END IF;

    RETURN v_tax;
END;
/
 

/* TEST calculate_tax */

SELECT calculate_tax(400000) AS tax FROM dual;
SELECT calculate_tax(750000) AS tax FROM dual;
SELECT calculate_tax(1200000) AS tax FROM dual;
SELECT calculate_tax(1800000) AS tax FROM dual;


/* ============================================================
   PART C – FUNCTION: income_category
   ============================================================ */

CREATE OR REPLACE FUNCTION income_category (
    p_income NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'Low Income';

    ELSIF p_income <= 1000000 THEN
        RETURN 'Medium Income';

    ELSIF p_income <= 1500000 THEN
        RETURN 'High Income';

    ELSE
        RETURN 'Very High Income';
    END IF;
END;
/
 

/* Display category for all taxpayers */

SELECT
    taxpayer_name,
    annual_income,
    income_category(annual_income) AS income_category
FROM Taxpayer;


/* ============================================================
   PART B – PROCEDURE: generate_tax_assessment
   ============================================================ */

CREATE OR REPLACE PROCEDURE generate_tax_assessment (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS
    v_name       Taxpayer.taxpayer_name%TYPE;
    v_pan        Taxpayer.pan_number%TYPE;
    v_income     Taxpayer.annual_income%TYPE;
    v_occupation Taxpayer.occupation%TYPE;
    v_tax        NUMBER;
    v_net_income NUMBER;
BEGIN

    SELECT taxpayer_name,
           pan_number,
           annual_income,
           occupation
    INTO   v_name,
           v_pan,
           v_income,
           v_occupation
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_tax := calculate_tax(v_income);
    v_net_income := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('TAX ASSESSMENT');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Taxpayer Name : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number    : ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Annual Income : ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Occupation    : ' || v_occupation);
    DBMS_OUTPUT.PUT_LINE('Tax Amount    : ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income    : ' || v_net_income);
    DBMS_OUTPUT.PUT_LINE('------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* Execute */

SET SERVEROUTPUT ON;

BEGIN
    generate_tax_assessment(1);
END;
/
 

/* ============================================================
   LEVEL 1 – QUESTION 1
   taxpayer_summary
   ============================================================ */

CREATE OR REPLACE PROCEDURE taxpayer_summary (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS
    v_name       Taxpayer.taxpayer_name%TYPE;
    v_income     Taxpayer.annual_income%TYPE;
    v_category   VARCHAR2(50);
    v_tax        NUMBER;
    v_net_income NUMBER;
BEGIN

    SELECT taxpayer_name,
           annual_income
    INTO v_name,
         v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_category := income_category(v_income);
    v_tax := calculate_tax(v_income);
    v_net_income := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('TAXPAYER SUMMARY');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Taxpayer Name : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income : ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_category);
    DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income    : ' || v_net_income);
    DBMS_OUTPUT.PUT_LINE('------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* Execute */

BEGIN
    taxpayer_summary(1);
END;
/
 

/* ============================================================
   LEVEL 1 – QUESTION 2
   Income Record Processing
   ============================================================ */

CREATE OR REPLACE PROCEDURE income_record_processing (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS
    v_name           Taxpayer.taxpayer_name%TYPE;
    v_annual_income  Taxpayer.annual_income%TYPE;
    v_total_income   NUMBER;
    v_difference     NUMBER;
BEGIN

    SELECT taxpayer_name,
           annual_income
    INTO v_name,
         v_annual_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT NVL(SUM(amount), 0)
    INTO v_total_income
    FROM Income_Record
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_total_income = 0 THEN

        DBMS_OUTPUT.PUT_LINE(
            'No income records exist for this taxpayer.'
        );

    ELSE

        v_difference := v_annual_income - v_total_income;

        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('INCOME RECORD PROCESSING');
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('Taxpayer Name       : ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Total Recorded Income: ' ||
                             v_total_income);
        DBMS_OUTPUT.PUT_LINE('Annual Income       : ' ||
                             v_annual_income);
        DBMS_OUTPUT.PUT_LINE('Difference          : ' ||
                             v_difference);
        DBMS_OUTPUT.PUT_LINE('------------------------------');

    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* Execute */

BEGIN
    income_record_processing(1);
END;
/
 

/* ============================================================
   LEVEL 1 – QUESTION 3
   Conditional Assessment
   ============================================================ */

CREATE OR REPLACE PROCEDURE conditional_assessment (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS
    v_name   Taxpayer.taxpayer_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
    v_status VARCHAR2(50);
BEGIN

    SELECT taxpayer_name,
           annual_income
    INTO v_name,
         v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income <= 500000 THEN
        v_status := 'No Tax Assessment';

    ELSIF v_income <= 1000000 THEN
        v_status := 'Standard Assessment';

    ELSE
        v_status := 'High Income Assessment';
    END IF;

    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('CONDITIONAL ASSESSMENT');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('Taxpayer Name : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income : ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Assessment Status: ' || v_status);
    DBMS_OUTPUT.PUT_LINE('------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* Execute */

BEGIN
    conditional_assessment(1);
END;
/
 

/* ============================================================
   LEVEL 2 – QUESTION 1
   CURSOR-BASED TAX ASSESSMENT
   Explicit Cursor
   ============================================================ */

DECLARE

    CURSOR taxpayer_cursor IS
        SELECT taxpayer_name,
               annual_income
        FROM Taxpayer
        WHERE status = 'ACTIVE';

    v_name       Taxpayer.taxpayer_name%TYPE;
    v_income     Taxpayer.annual_income%TYPE;
    v_category   VARCHAR2(50);
    v_tax        NUMBER;
    v_net_income NUMBER;

BEGIN

    OPEN taxpayer_cursor;

    LOOP

        FETCH taxpayer_cursor
        INTO v_name,
             v_income;

        EXIT WHEN taxpayer_cursor%NOTFOUND;

        v_category := income_category(v_income);
        v_tax := calculate_tax(v_income);
        v_net_income := v_income - v_tax;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || v_name ||
            ' | Income: ' || v_income ||
            ' | Category: ' || v_category ||
            ' | Tax: ' || v_tax ||
            ' | Net Income: ' || v_net_income
        );

    END LOOP;

    CLOSE taxpayer_cursor;

EXCEPTION
    WHEN OTHERS THEN
        IF taxpayer_cursor%ISOPEN THEN
            CLOSE taxpayer_cursor;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* ============================================================
   LEVEL 2 – QUESTION 1
   Cursor FOR LOOP version
   ============================================================ */

BEGIN

    FOR rec IN
    (
        SELECT taxpayer_name,
               annual_income
        FROM Taxpayer
        WHERE status = 'ACTIVE'
    )
    LOOP

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || rec.taxpayer_name ||
            ' | Income: ' || rec.annual_income ||
            ' | Category: ' ||
            income_category(rec.annual_income) ||
            ' | Tax: ' ||
            calculate_tax(rec.annual_income) ||
            ' | Net Income: ' ||
            (rec.annual_income -
             calculate_tax(rec.annual_income))
        );

    END LOOP;

END;
/
 

/* ============================================================
   LEVEL 2 – QUESTION 2
   CURSOR WITH CONDITIONAL PROCESSING
   ============================================================ */

DECLARE

    CURSOR c_taxpayer IS
        SELECT taxpayer_name,
               annual_income
        FROM Taxpayer
        WHERE status = 'ACTIVE';

    v_tax      NUMBER;
    v_category VARCHAR2(50);

BEGIN

    FOR rec IN c_taxpayer
    LOOP

        IF rec.annual_income <= 500000 THEN

            v_tax := 0;
            v_category := 'NO TAX';

        ELSIF rec.annual_income <= 1000000 THEN

            v_tax := (rec.annual_income - 500000) * 0.10;
            v_category := 'STANDARD ASSESSMENT';

        ELSE

            v_tax := calculate_tax(rec.annual_income);
            v_category := 'HIGH INCOME ASSESSMENT';

        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || rec.taxpayer_name ||
            ' | Income: ' || rec.annual_income ||
            ' | Tax: ' || v_tax ||
            ' | Assessment Category: ' || v_category
        );

    END LOOP;

END;
/
 

/* ============================================================
   LEVEL 2 – QUESTION 3
   update_taxpayer_income
   ============================================================ */

CREATE OR REPLACE PROCEDURE update_taxpayer_income (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE,
    p_new_income  IN NUMBER
)
IS
    v_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_count = 0 THEN

        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');

    ELSIF p_new_income < 0 THEN

        DBMS_OUTPUT.PUT_LINE(
            'Income cannot be negative'
        );

    ELSE

        UPDATE Taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Income updated successfully'
        );

        FOR rec IN
        (
            SELECT taxpayer_id,
                   taxpayer_name,
                   annual_income
            FROM Taxpayer
            WHERE taxpayer_id = p_taxpayer_id
        )
        LOOP

            DBMS_OUTPUT.PUT_LINE(
                'ID: ' || rec.taxpayer_id
            );

            DBMS_OUTPUT.PUT_LINE(
                'Name: ' || rec.taxpayer_name
            );

            DBMS_OUTPUT.PUT_LINE(
                'Updated Income: ' || rec.annual_income
            );

        END LOOP;

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
 

/* Execute */

BEGIN
    update_taxpayer_income(1, 800000);
END;
/
 

/* ============================================================
   LEVEL 2 – QUESTION 4
   Exception Handling
   ============================================================ */

CREATE OR REPLACE PROCEDURE exception_tax_assessment (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS
    v_income Taxpayer.annual_income%TYPE;
    v_tax NUMBER;
BEGIN

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_tax := calculate_tax(v_income);

    DBMS_OUTPUT.PUT_LINE(
        'Annual Income: ' || v_income
    );

    DBMS_OUTPUT.PUT_LINE(
        'Calculated Tax: ' || v_tax
    );

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'Taxpayer not found'
        );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Unexpected error: ' || SQLERRM
        );

END;
/
 

/* ============================================================
   LEVEL 3 – QUESTION 1
   COMPLETE TAX ASSESSMENT SYSTEM
   ============================================================ */

CREATE OR REPLACE PROCEDURE complete_tax_assessment (
    p_taxpayer_id IN Taxpayer.taxpayer_id%TYPE
)
IS

    v_name       Taxpayer.taxpayer_name%TYPE;
    v_pan        Taxpayer.pan_number%TYPE;
    v_occupation Taxpayer.occupation%TYPE;
    v_income     Taxpayer.annual_income%TYPE;

    v_category   VARCHAR2(50);
    v_tax        NUMBER;
    v_net_income NUMBER;

BEGIN

    SELECT taxpayer_name,
           pan_number,
           occupation,
           annual_income
    INTO v_name,
         v_pan,
         v_occupation,
         v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_category := income_category(v_income);

    v_tax := calculate_tax(v_income);

    v_net_income := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE(
        '--------------------------------'
    );

    DBMS_OUTPUT.PUT_LINE(
        'TAX ASSESSMENT REPORT'
    );

    DBMS_OUTPUT.PUT_LINE(
        '--------------------------------'
    );

    DBMS_OUTPUT.PUT_LINE(
        'Taxpayer Name : ' || v_name
    );

    DBMS_OUTPUT.PUT_LINE(
        'PAN Number    : ' || v_pan
    );

    DBMS_OUTPUT.PUT_LINE(
        'Occupation    : ' || v_occupation
    );

    DBMS_OUTPUT.PUT_LINE(
        'Annual Income : ' || v_income
    );

    DBMS_OUTPUT.PUT_LINE(
        'Income Category: ' || v_category
    );

    DBMS_OUTPUT.PUT_LINE(
        'Tax Amount    : ' || v_tax
    );

    DBMS_OUTPUT.PUT_LINE(
        'Net Income    : ' || v_net_income
    );

    DBMS_OUTPUT.PUT_LINE(
        '--------------------------------'
    );

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'Taxpayer not found'
        );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: ' || SQLERRM
        );

END;
/
 

/* Execute */

BEGIN
    complete_tax_assessment(1);
END;
/
 

/* ============================================================
   LEVEL 3 – QUESTION 2
   INCOME RECORD CURSOR PROCESSING
   ============================================================ */

DECLARE

    CURSOR income_cursor IS
        SELECT income_id,
               taxpayer_id,
               income_source,
               category,
               amount,
               received_date,
               financial_year
        FROM Income_Record;

    v_record_category VARCHAR2(50);

BEGIN

    FOR rec IN income_cursor
    LOOP

        IF rec.amount <= 50000 THEN

            v_record_category :=
                'Small Income Record';

        ELSIF rec.amount <= 200000 THEN

            v_record_category :=
                'Medium Income Record';

        ELSE

            v_record_category :=
                'Large Income Record';

        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Income ID: ' || rec.income_id ||
            ' | Taxpayer ID: ' || rec.taxpayer_id ||
            ' | Source: ' || rec.income_source ||
            ' | Category: ' || rec.category ||
            ' | Amount: ' || rec.amount ||
            ' | Received Date: ' || rec.received_date ||
            ' | Financial Year: ' || rec.financial_year ||
            ' | Record Classification: ' ||
            v_record_category
        );

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: ' || SQLERRM
        );
END;
/
 

/* ============================================================
   LEVEL 3 – QUESTION 3
   COMBINED FUNCTION AND CURSOR
   ============================================================ */

DECLARE

    CURSOR c_taxpayer IS
        SELECT taxpayer_name,
               annual_income
        FROM Taxpayer
        WHERE status = 'ACTIVE';

    v_category   VARCHAR2(50);
    v_tax        NUMBER;
    v_net_income NUMBER;

BEGIN

    FOR rec IN c_taxpayer
    LOOP

        v_category :=
            income_category(rec.annual_income);

        v_tax :=
            calculate_tax(rec.annual_income);

        v_net_income :=
            rec.annual_income - v_tax;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || rec.taxpayer_name
        );

        DBMS_OUTPUT.PUT_LINE(
            'Annual Income: ' || rec.annual_income
        );

        DBMS_OUTPUT.PUT_LINE(
            'Income Category: ' || v_category
        );

        DBMS_OUTPUT.PUT_LINE(
            'Tax Amount: ' || v_tax
        );

        DBMS_OUTPUT.PUT_LINE(
            'Net Income: ' || v_net_income
        );

        DBMS_OUTPUT.PUT_LINE(
            '------------------------------'
        );

    END LOOP;

END;
/
 

/* ============================================================
   CHALLENGE QUESTION
   TAXPAYER ASSESSMENT SUMMARY
   ============================================================ */

DECLARE

    CURSOR c_taxpayer IS
        SELECT taxpayer_name,
               annual_income
        FROM Taxpayer
        WHERE status = 'ACTIVE';

    v_tax              NUMBER;
    v_category         VARCHAR2(50);
    v_assessment_status VARCHAR2(50);

    v_total_taxpayers  NUMBER := 0;
    v_total_income     NUMBER := 0;
    v_total_tax        NUMBER := 0;

BEGIN

    DBMS_OUTPUT.PUT_LINE(
        '=========================================='
    );

    DBMS_OUTPUT.PUT_LINE(
        'TAXPAYER ASSESSMENT SUMMARY'
    );

    DBMS_OUTPUT.PUT_LINE(
        '=========================================='
    );

    FOR rec IN c_taxpayer
    LOOP

        v_total_taxpayers :=
            v_total_taxpayers + 1;

        v_total_income :=
            v_total_income + rec.annual_income;

        v_category :=
            income_category(rec.annual_income);

        v_tax :=
            calculate_tax(rec.annual_income);

        v_total_tax :=
            v_total_tax + v_tax;

        IF rec.annual_income <= 500000 THEN

            v_assessment_status :=
                'No Tax Assessment';

        ELSIF rec.annual_income <= 1000000 THEN

            v_assessment_status :=
                'Standard Assessment';

        ELSE

            v_assessment_status :=
                'High Income Assessment';

        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Taxpayer Name: