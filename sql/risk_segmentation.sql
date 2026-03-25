-- ============================================
-- RISK SEGMENTATION ANALYSIS
-- ============================================

-- 1. Create risk view
CREATE VIEW risk_analysis AS
SELECT *,
    CASE 
        WHEN person_income < 30000 AND loan_amnt > 15000 THEN 'High Risk'
        WHEN loan_income_ratio > 0.5 THEN 'High Risk'
        WHEN person_income BETWEEN 30000 AND 70000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment
FROM credit_data;

-- 2. Preview
SELECT * FROM risk_analysis LIMIT 10;

-- 3. Distribution
SELECT 
    risk_segment,
    COUNT(*) AS total_loans
FROM risk_analysis
GROUP BY risk_segment;

-- 4. Default rate by segment
SELECT 
    risk_segment,
    COUNT(*) AS total_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS default_rate
FROM risk_analysis
GROUP BY risk_segment
ORDER BY default_rate DESC;

-- 5. Income vs risk
SELECT 
    risk_segment,
    AVG(person_income) AS avg_income,
    AVG(loan_amnt) AS avg_loan
FROM risk_analysis
GROUP BY risk_segment;

-- 6. High-risk customers
SELECT *
FROM risk_analysis
WHERE risk_segment = 'High Risk'
ORDER BY loan_income_ratio DESC;

-- 7. Contribution to defaults
SELECT 
    risk_segment,
    SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) * 100.0 /
        (SELECT COUNT(*) FROM credit_data WHERE loan_status = 'Default'),
        2
    ) AS contribution_percentage
FROM risk_analysis
GROUP BY risk_segment;