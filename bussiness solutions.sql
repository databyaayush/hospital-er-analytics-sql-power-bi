use hospital_er;

-- 1. How many visits are there, and are there duplicate patient IDs?
SELECT COUNT(*) AS total_visits , COUNT(DISTINCT(patient_id)) AS unique_patient_ID
FROM dataset;

-- 2. What date range does the data cover?
SELECT min(add_date) AS first_day,
       max(add_date) AS last_day,
       DATEDIFF(max(add_date),min(add_date)) AS data_range
FROM dataset;

-- 3. What are the average, minimum and maximum wait times?
SELECT AVG(patient_wait_time) AS Average_wait_time,
       MIN(patient_wait_time) AS minimum_wait_time,
       MAX(patient_wait_time) AS maximum_wait_time
FROM dataset;

-- 4. What is the average satisfaction score, and how many scores are missing?
SELECT
    AVG(satisfaction_score) AS Avg_Satisfaction_score,
    SUM(CASE
            WHEN satisfaction_score IS NULL THEN 1
            ELSE 0
        END) AS Total_missing_values
FROM dataset;

-- 5. What percentage of patients were admitted?
SELECT ROUND(100 * SUM(add_flag) / COUNT(*), 1) AS admission_rate_pct
FROM dataset;

-- 6. What is the gender split?
SELECT gender, COUNT(*) AS visits,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM dataset
GROUP BY gender;

-- 7. How do visits break down by race?
SELECT race,COUNT(*) AS visits
FROM dataset
GROUP BY race
ORDER BY visits DESC;

-- 8.Which departments receive the most referrals?
SELECT referral,COUNT(*) AS total_referalls
FROM dataset
WHERE referral <> 'No Referral'
GROUP BY referral
ORDER BY total_referalls DESC;

-- 9. What share of patients were referred vs. walk-in?
SELECT
	CASE
		WHEN referral = 'No Referral' THEN 'Walk-in'
        ELSE 'reffered'
	END AS PATIENT_TYPE,
    COUNT(*) AS total_patients,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dataset),
        2
    ) AS share_percentage
FROM dataset
GROUP BY patient_type;

-- 10. What percentage of patients were seen within 30 minutes?
SELECT COUNT(*) AS TOTAL_PATIENT,SUM(patient_wait_time<=30) AS SEEN_WITH_IN_30_MIN,ROUND(SUM(patient_wait_time <= 30)*100 / COunt(*) ,2) AS SEEN_WITH_IN_30MIN
FROM dataset;

-- 11. What are the average wait time and satisfaction by department?
SELECT referral AS DEPARTMENT,ROUND(AVG(patient_wait_time),2) AS AVERAGE_WAIT_TIME,ROUND(AVG(satisfaction_score),2) AS AVERAGE_SATISFACTION_SCORE
FROM dataset
GROUP BY referral;

-- 12. How does satisfaction change as wait time increases?
SELECT CASE
       WHEN patient_wait_time <= 15 THEN '0-15'
       WHEN patient_wait_time <= 30 THEN '15-30'
       WHEN patient_wait_time <= 45 THEN '30-45'
       WHEN patient_wait_time <= 60 THEN '45-60'
       ELSE '60+'
       END AS wait_time,
COUNT(*) AS visits,
AVG(satisfaction_score) AS avg_satisfaction
FROM dataset
GROUP BY wait_time
ORDER BY MIN(wait_time);
       
-- 13.  What is the admission rate by age group?
SELECT CASE
		WHEN age<=18 THEN '0-18'
        WHEN age<=35 THEN '18-35'
        WHEN age<=55 THEN '35-55'
        WHEN age<=70 THEN '55-70'
        ELSE '70+'
        END AS age_range,
ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM dataset),2) AS patients
FROM dataset
GROUP BY age_range
ORDER BY MIN(age_range);

-- 14.  Which department is referred to most within each age group?
SELECT
    CASE
        WHEN age<= 18 THEN '0-18'
        WHEN age<= 35 THEN '19-35'
        WHEN age<= 60 THEN '36-60'
        ELSE '60+'
    END AS age_group,
    referral,
    COUNT(*) AS total_referrals
FROM dataset
WHERE age IS NOT NULL
  AND referral <> 'NO Refferal'
GROUP BY
    CASE
        WHEN age<= 18 THEN '0-18'
        WHEN age<= 35 THEN '19-35'
        WHEN age<= 60 THEN '36-60'
        ELSE '60+'
    END,
    referral
ORDER BY age_group, total_referrals DESC;


