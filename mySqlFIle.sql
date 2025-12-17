use medical;

-- BASIC DATA CHECK
SELECT COUNT(*) AS Total_Patients FROM healthcare;
-- AGE GROUP vs HEART DISEASE RISK
SELECT
    CASE
        WHEN Age < 30 THEN 'Young (0-29)'
        WHEN Age BETWEEN 30 AND 45 THEN 'Adult (30-45)'
        WHEN Age BETWEEN 46 AND 60 THEN 'Middle Age (46-60)'
        ELSE 'Senior (60+)'
    END AS Age_Group,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS Risk_Percentage
FROM healthcare
GROUP BY Age_Group
ORDER BY Total_Patients DESC;
-- GENDER VS HEART DISEASE RISK
SELECT
    Gender,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS Risk_Percentage
FROM healthcare
GROUP BY Gender;
-- HIGH RISK PATIENT
SELECT *
FROM healthcare
WHERE
    Systolic_BP >= 140
    and Diastolic_BP >= 90
    and Test_Results = 'Abnormal'
    and Cholesterol = 'Severe'
    and Glucose = 'Severe'
    and Lifestyle_Index >= 8;

-- CHOLESTEROL + GLUCOSE IMPACT
SELECT
    Cholesterol,
    Glucose,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count
FROM healthcare
GROUP BY Cholesterol, Glucose
ORDER BY High_Risk_Count DESC;

-- LIFESTYLE INDEX vs RISK
SELECT
    Lifestyle_Index,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count
FROM healthcare
GROUP BY Lifestyle_Index
ORDER BY Lifestyle_Index;
-- TOP 10 DOCTORS WITH HIGH-RISK PATIENTS
SELECT
    Doctor,
    COUNT(*) AS High_Risk_Patients
FROM healthcare
WHERE Heart_Disease_Risk = 'True'
GROUP BY Doctor
ORDER BY High_Risk_Patients DESC
LIMIT 10;
-- BILLING AMOUNT vs HEART DISEASE RISK
SELECT
    Heart_Disease_Risk,
    ROUND(AVG(Billing_Amount), 2) AS Avg_Billing_Amount
FROM healthcare
GROUP BY Heart_Disease_Risk;
-- LENGTH OF STAY ANALYSIS
SELECT
    DATEDIFF(Discharge_Date, Date_of_Admission) AS Length_Of_Stay,
    COUNT(*) AS Patient_Count
FROM healthcare
GROUP BY DATEDIFF(Discharge_Date, Date_of_Admission)
ORDER BY Patient_Count DESC;
-- HEART DISEASE RISK DISTRIBUTION
SELECT
    Heart_Disease_Risk,
    COUNT(*) AS Total_Patients,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM healthcare),
        2
    ) AS Percentage
FROM healthcare
GROUP BY Heart_Disease_Risk;

-- BMI CATEGORY vs HEART DISEASE RISK
SELECT
    BMI_Category,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count
FROM healthcare
GROUP BY BMI_Category
ORDER BY High_Risk_Count DESC;

-- BLOOD PRESSURE CATEGORY
SELECT
    CASE
        WHEN Systolic_BP < 120 THEN 'Normal'
        WHEN Systolic_BP BETWEEN 120 AND 139 THEN 'Prehypertension'
        WHEN Systolic_BP BETWEEN 140 AND 159 THEN 'Hypertension Stage 1'
        ELSE 'Hypertension Stage 2'
    END AS BP_Category,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Heart_Disease_Risk = 'True' THEN 1 ELSE 0 END) AS High_Risk_Count
FROM healthcare
GROUP BY BP_Category;


-- POWER BI VIEW: HIGH RISK PATIENTS
CREATE OR REPLACE VIEW vw_high_risk_patients AS
SELECT
    Name, Age, Gender, Hospital, Doctor,
    Systolic_BP, Diastolic_BP, Cholesterol, Glucose,
    Lifestyle_Index, Billing_Amount
FROM healthcare
WHERE Heart_Disease_Risk = 'True';

