/* ============================================================================
   02_business_queries_part1.sql        
   Questions 1-6: demand, buyer profile and product preferences
   ============================================================================ */
USE TataSUV;
GO

/* Q1. Which Tata SUV models generate the most interest, and how concentrated is demand? */
SELECT 1 AS Q_No,'Which Tata SUV models generate the most interest, and how concentrated is demand?' AS QUESTION;
SELECT Model_Interest AS model,
       COUNT(*) AS respondents,
       CAST(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS DECIMAL(5,1)) AS pct_of_total,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS demand_rank
FROM dbo.vw_survey_enriched
GROUP BY Model_Interest
ORDER BY respondents DESC, model;

/* Q2. What is the most popular model within each age group? */
SELECT 2 AS Q_No,'What is the most popular model within each age group?'AS QUESTION;
WITH model_by_age AS (
    SELECT Age_Sort, Age_Group, Model_Interest, COUNT(*) AS respondents
    FROM dbo.vw_survey_enriched
    GROUP BY Age_Sort, Age_Group, Model_Interest
), ranked AS (
    SELECT Age_Sort, Age_Group, Model_Interest, respondents,
           SUM(respondents) OVER (PARTITION BY Age_Group) AS age_group_total,
           RANK() OVER (PARTITION BY Age_Group ORDER BY respondents DESC) AS rnk
    FROM model_by_age
)
SELECT Age_Group AS age_group,
       Model_Interest AS top_model,
       respondents,
       age_group_total,
       CAST(ROUND(100.0 * respondents / age_group_total, 1) AS DECIMAL(5,1)) AS pct_of_age_group
FROM ranked
WHERE rnk = 1
ORDER BY Age_Sort;

/* Q3. How does EV preference change with age and income? */
SELECT 3 AS Q_No,'How does EV preference change with age and income? ' AS QUESTION;
SELECT 'Age group' AS dimension, Age_Group AS segment, Age_Sort AS sort_key,
       COUNT(*) AS respondents,
       SUM(is_ev) AS ev_choosers,
       CAST(ROUND(100.0 * SUM(is_ev) / COUNT(*), 1) AS DECIMAL(5,1)) AS ev_pct
FROM dbo.vw_survey_enriched
GROUP BY Age_Group, Age_Sort
UNION ALL
SELECT 'Income band', Income_Band, Income_Sort,
       COUNT(*), SUM(is_ev),
       CAST(ROUND(100.0 * SUM(is_ev) / COUNT(*), 1) AS DECIMAL(5,1))
FROM dbo.vw_survey_enriched
GROUP BY Income_Band, Income_Sort
ORDER BY dimension, sort_key;

/* Q4. Which powertrain does each model attract? (model x powertrain matrix) */
SELECT 4 AS Q_No,'Which powertrain does each model attract? (model x powertrain matrix)' AS QUESTION;
SELECT Model_Interest AS model,
       SUM(CASE WHEN Powertrain = 'EV'     THEN 1 ELSE 0 END) AS ev,
       SUM(CASE WHEN Powertrain = 'Petrol' THEN 1 ELSE 0 END) AS petrol,
       SUM(CASE WHEN Powertrain = 'Diesel' THEN 1 ELSE 0 END) AS diesel,
       SUM(CASE WHEN Powertrain = 'CNG'    THEN 1 ELSE 0 END) AS cng,
       COUNT(*) AS total,
       CAST(ROUND(100.0 * SUM(is_ev) / COUNT(*), 1) AS DECIMAL(5,1)) AS ev_pct
FROM dbo.vw_survey_enriched
GROUP BY Model_Interest
ORDER BY total DESC, model;

/* Q5. Do higher-income households move up the model ladder (Entry > Compact > Premium)? */
SELECT 5 AS Q_No,'Do higher-income households move up the model ladder (Entry > Compact > Premium)? 'AS QUESTION;
SELECT Income_Band AS income_band,
       model_tier,
       COUNT(*) AS respondents,
       CAST(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Income_Band), 1) AS DECIMAL(5,1)) AS pct_of_income_band
FROM dbo.vw_survey_enriched
GROUP BY Income_Band, Income_Sort, model_tier
ORDER BY Income_Sort,
         CASE model_tier WHEN 'Entry' THEN 1 WHEN 'Compact' THEN 2 ELSE 3 END;

/* Q6. Is automatic-transmission demand driven by city commuting or by age? */
SELECT 6 AS Q_No,'Is automatic-transmission demand driven by city commuting or by age?' AS QUESTION;
SELECT 'Purpose' AS dimension, Purpose AS segment, 0 AS sort_key,
       COUNT(*) AS respondents,
       SUM(is_automatic) AS automatic_choosers,
       CAST(ROUND(100.0 * SUM(is_automatic) / COUNT(*), 1) AS DECIMAL(5,1)) AS automatic_pct
FROM dbo.vw_survey_enriched
GROUP BY Purpose
UNION ALL
SELECT 'Age group', Age_Group, Age_Sort,
       COUNT(*), SUM(is_automatic),
       CAST(ROUND(100.0 * SUM(is_automatic) / COUNT(*), 1) AS DECIMAL(5,1))
FROM dbo.vw_survey_enriched
GROUP BY Age_Group, Age_Sort
ORDER BY dimension DESC, sort_key, segment;
