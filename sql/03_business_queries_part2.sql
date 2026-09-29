/* ============================================================================
   03_business_queries_part2.sql        
   Questions 7-12: financing, research channels, dealer and complaint analysis, segments
   ============================================================================ */
USE TataSUV;
GO

/* Q7. How dependent are buyers on loans, and does it change with income or age? */
SELECT 7 AS Q_No,'How dependent are buyers on loans, and does it change with income or age?'AS QUESTION;
SELECT 'Income band' AS dimension, Income_Band AS segment, Income_Sort AS sort_key,
       COUNT(*) AS respondents,
       SUM(CASE WHEN Finance_Mode = 'Loan'    THEN 1 ELSE 0 END) AS loan,
       SUM(CASE WHEN Finance_Mode = 'Digital' THEN 1 ELSE 0 END) AS digital,
       SUM(CASE WHEN Finance_Mode = 'Cheque'  THEN 1 ELSE 0 END) AS cheque,
       CAST(ROUND(100.0 * SUM(is_loan) / COUNT(*), 1) AS DECIMAL(5,1)) AS loan_pct
FROM dbo.vw_survey_enriched
GROUP BY Income_Band, Income_Sort
UNION ALL
SELECT 'Age group', Age_Group, Age_Sort,
       COUNT(*),
       SUM(CASE WHEN Finance_Mode = 'Loan'    THEN 1 ELSE 0 END),
       SUM(CASE WHEN Finance_Mode = 'Digital' THEN 1 ELSE 0 END),
       SUM(CASE WHEN Finance_Mode = 'Cheque'  THEN 1 ELSE 0 END),
       CAST(ROUND(100.0 * SUM(is_loan) / COUNT(*), 1) AS DECIMAL(5,1))
FROM dbo.vw_survey_enriched
GROUP BY Age_Group, Age_Sort
ORDER BY dimension, sort_key;

/* Q8. Which research channel does each age group rely on most? */
SELECT 8 AS Q_No,'Which research channel does each age group rely on most?'AS QUESTION;
WITH src AS (
    SELECT Age_Sort, Age_Group,
           COUNT(*) AS respondents,
           SUM(CASE WHEN Info_Source = 'Website'       THEN 1 ELSE 0 END) AS website,
           SUM(CASE WHEN Info_Source = 'YouTube'       THEN 1 ELSE 0 END) AS youtube,
           SUM(CASE WHEN Info_Source = 'Word of Mouth' THEN 1 ELSE 0 END) AS word_of_mouth
    FROM dbo.vw_survey_enriched
    GROUP BY Age_Sort, Age_Group
)
SELECT Age_Group AS age_group, respondents, website, youtube, word_of_mouth,
       CASE WHEN website >= youtube AND website >= word_of_mouth THEN 'Website'
            WHEN youtube >= word_of_mouth                        THEN 'YouTube'
            ELSE 'Word of Mouth' END AS top_channel,
       CAST(ROUND(100.0 * CASE WHEN website >= youtube AND website >= word_of_mouth THEN website
                               WHEN youtube >= word_of_mouth THEN youtube
                               ELSE word_of_mouth END / respondents, 1) AS DECIMAL(5,1)) AS top_channel_pct
FROM src
ORDER BY Age_Sort;

/* Q9. Which complaint themes sit behind each dealer? */
SELECT 9 AS Q_No,'Which complaint themes sit behind each dealer?'AS QUESTION;
SELECT Dealer AS dealer,
       COUNT(*) AS respondents,
       SUM(CASE WHEN Complaint_Theme = 'Software Instability'          THEN 1 ELSE 0 END) AS software,
       SUM(CASE WHEN Complaint_Theme = 'Service Competence & Capacity' THEN 1 ELSE 0 END) AS service,
       SUM(CASE WHEN Complaint_Theme = 'Fit & Finish'                  THEN 1 ELSE 0 END) AS fit_finish,
       CAST(ROUND(100.0 * SUM(CASE WHEN Complaint_Theme = 'Software Instability'          THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1)) AS software_pct,
       CAST(ROUND(100.0 * SUM(CASE WHEN Complaint_Theme = 'Service Competence & Capacity' THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1)) AS service_pct,
       CAST(ROUND(100.0 * SUM(CASE WHEN Complaint_Theme = 'Fit & Finish'                  THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1)) AS fit_finish_pct
FROM dbo.vw_survey_enriched
GROUP BY Dealer
ORDER BY respondents DESC;

/* Q10. Which few complaints account for most of the dissatisfaction? (Pareto) */
SELECT 10 AS Q_No,'Which few complaints account for most of the dissatisfaction? (Pareto) 'AS QUESTION;
WITH c AS (
    SELECT Ownership_Complaint AS complaint, Complaint_Theme AS theme, COUNT(*) AS respondents
    FROM dbo.vw_survey_enriched
    GROUP BY Ownership_Complaint, Complaint_Theme
)
SELECT complaint, theme, respondents,
       CAST(ROUND(100.0 * respondents / SUM(respondents) OVER (), 1) AS DECIMAL(5,1)) AS pct_of_total,
       CAST(ROUND(100.0 * SUM(respondents) OVER (ORDER BY respondents DESC, complaint
                                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                        / SUM(respondents) OVER (), 1) AS DECIMAL(5,1)) AS cumulative_pct
FROM c
ORDER BY respondents DESC, complaint;

/* Q11. Who relies on brand trust instead of service information? */
SELECT 11 AS Q_No,'Who relies on brand trust instead of service information?'AS QUESTION;
SELECT 'Age group' AS dimension, Age_Group AS segment, Age_Sort AS sort_key,
       COUNT(*) AS respondents,
       SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END) AS no_service_info,
       CAST(ROUND(100.0 * SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1)) AS no_info_pct
FROM dbo.vw_survey_enriched
GROUP BY Age_Group, Age_Sort
UNION ALL
SELECT 'Dealer', Dealer, 0,
       COUNT(*),
       SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END),
       CAST(ROUND(100.0 * SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1))
FROM dbo.vw_survey_enriched
GROUP BY Dealer
UNION ALL
SELECT 'Model tier', model_tier,
       CASE model_tier WHEN 'Entry' THEN 1 WHEN 'Compact' THEN 2 ELSE 3 END,
       COUNT(*),
       SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END),
       CAST(ROUND(100.0 * SUM(CASE WHEN Service_Info_Known = 'No' THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1))
FROM dbo.vw_survey_enriched
GROUP BY model_tier
ORDER BY dimension, sort_key, segment;

/* Q12. Segment scorecard: how do the five life-stage segments compare? */
SELECT 12 AS Q_No,'Segment scorecard: how do the five life-stage segments compare?'AS QUESTION;
SELECT life_stage,
       COUNT(*) AS respondents,
       CAST(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS DECIMAL(5,1)) AS pct_of_total,
       CAST(ROUND(100.0 * SUM(is_ev) / COUNT(*), 1) AS DECIMAL(5,1)) AS ev_pct,
       CAST(ROUND(100.0 * SUM(is_automatic) / COUNT(*), 1) AS DECIMAL(5,1)) AS automatic_pct,
       CAST(ROUND(100.0 * SUM(is_loan) / COUNT(*), 1) AS DECIMAL(5,1)) AS loan_pct,
       CAST(ROUND(100.0 * SUM(CASE WHEN model_tier = 'Premium' THEN 1 ELSE 0 END) / COUNT(*), 1) AS DECIMAL(5,1)) AS premium_pct,
       CAST(ROUND(AVG(Budget_Sort * 1.0), 2) AS DECIMAL(4,2)) AS avg_budget_index
FROM dbo.vw_survey_enriched
GROUP BY life_stage, Age_Sort
ORDER BY Age_Sort;