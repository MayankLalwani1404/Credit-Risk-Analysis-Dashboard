-- ============================================
-- DATA CLEANING & PREPARATION
-- ============================================

-- 1. Preview raw data
SELECT * FROM credit_data LIMIT 10;

-- 2. Check for NULL values
SELECT 
    SUM(CASE WHEN person_age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN person_income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN loan_amnt IS NULL THEN 1 ELSE 0 END) AS missing_loan
FROM credit_data;

-- 3. Remove rows with critical NULL values (optional)
DELETE FROM credit_data
WHERE person_income IS NULL OR loan_amnt IS NULL;

-- 4. Standardize loan_status values
-- (Example: convert lowercase to proper format)
UPDATE credit_data
SET loan_status = 
    CASE 
        WHEN LOWER(loan_status) = 'default' THEN 'Default'
        WHEN LOWER(loan_status) = 'paid' THEN 'Paid'
        ELSE loan_status
    END;

-- 5. Create income group column (for analysis)
ALTER TABLE credit_data ADD COLUMN income_group TEXT;

UPDATE credit_data
SET income_group = 
    CASE 
        WHEN person_income < 30000 THEN 'Low Income'
        WHEN person_income BETWEEN 30000 AND 70000 THEN 'Medium Income'
        ELSE 'High Income'
    END;

-- 6. Create loan-to-income ratio
ALTER TABLE credit_data ADD COLUMN loan_income_ratio REAL;

UPDATE credit_data
SET loan_income_ratio = loan_amnt * 1.0 / person_income;

-- 7. Create employment category (optional grouping)
ALTER TABLE credit_data ADD COLUMN emp_category TEXT;

UPDATE credit_data
SET emp_category = 
    CASE 
        WHEN person_emp_length < 2 THEN 'New'
        WHEN person_emp_length BETWEEN 2 AND 5 THEN 'Mid'
        ELSE 'Experienced'
    END;

-- 8. Verify cleaned data
SELECT * FROM credit_data LIMIT 10;