-- ============================================
-- BUSINESS ANALYSIS QUERIES
-- ============================================

-- 1. Total loans
SELECT COUNT(*) AS total_loans
FROM credit_data;

-- 2. Default rate
SELECT 
    ROUND(
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS default_rate_percentage
FROM credit_data;

-- 3. Loan status distribution
SELECT 
    loan_status,
    COUNT(*) AS total_loans
FROM credit_data
GROUP BY loan_status;

-- 4. Averages
SELECT 
    AVG(person_age) AS avg_age,
    AVG(person_income) AS avg_income,
    AVG(loan_amnt) AS avg_loan
FROM credit_data;

-- 5. Income group analysis
SELECT 
    income_group,
    COUNT(*) AS total_loans,
    AVG(loan_amnt) AS avg_loan
FROM credit_data
GROUP BY income_group;

-- 6. Default rate by income
SELECT 
    income_group,
    ROUND(
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS default_rate
FROM credit_data
GROUP BY income_group
ORDER BY default_rate DESC;

-- 7. Employment length vs default
SELECT 
    person_emp_length,
    COUNT(*) AS total_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS default_rate
FROM credit_data
GROUP BY person_emp_length
ORDER BY default_rate DESC;

-- 8. Loan amount by status
SELECT 
    loan_status,
    AVG(loan_amnt) AS avg_loan
FROM credit_data
GROUP BY loan_status;

-- 9. Loan-to-income ratio
SELECT 
    loan_status,
    AVG(loan_income_ratio) AS avg_ratio
FROM credit_data
GROUP BY loan_status;

-- 10. High risk financial behavior
SELECT *
FROM credit_data
WHERE loan_income_ratio > 0.5
ORDER BY loan_income_ratio DESC;