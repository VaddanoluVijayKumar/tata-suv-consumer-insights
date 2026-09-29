/* ============================================================================
   01_setup_and_validation.sql          
   Project : Tata SUV consumer behaviour - Business Analyst portfolio
   Source  : Cleaned_Data.csv (135 rows, 28 columns) from a structurized questionnaire
   ============================================================================ */

/* ---------- SECTION 1: database and table ---------- */
IF DB_ID('TataSUV') IS NULL CREATE DATABASE TataSUV;
GO
USE TataSUV;
GO
IF OBJECT_ID('dbo.vw_survey_enriched', 'V') IS NOT NULL DROP VIEW dbo.vw_survey_enriched;
IF OBJECT_ID('dbo.tata_suv_survey', 'U') IS NOT NULL DROP TABLE dbo.tata_suv_survey;
GO
CREATE TABLE dbo.tata_suv_survey (
    Respondent_ID         INT NOT NULL PRIMARY KEY,
    Gender                VARCHAR(30) NOT NULL,
    Age_Group             VARCHAR(30) NOT NULL,
    Age_Sort              TINYINT NOT NULL,
    Occupation            VARCHAR(30) NOT NULL,
    Income_Band           VARCHAR(30) NOT NULL,
    Income_Sort           TINYINT NOT NULL,
    Model_Interest        VARCHAR(30) NOT NULL,
    Powertrain            VARCHAR(30) NOT NULL,
    Transmission          VARCHAR(30) NOT NULL,
    Budget_Band           VARCHAR(30) NOT NULL,
    Budget_Sort           TINYINT NOT NULL,
    Purpose               VARCHAR(30) NOT NULL,
    Motivation_1          VARCHAR(30) NOT NULL,
    Motivation_2          VARCHAR(30) NOT NULL,
    Motivation_3          VARCHAR(30) NOT NULL,
    Tech_Must_Have        VARCHAR(30) NOT NULL,
    Info_Source           VARCHAR(30) NOT NULL,
    Finance_Mode          VARCHAR(30) NOT NULL,
    Purchase_Occasion     VARCHAR(30) NOT NULL,
    Dealer                VARCHAR(30) NOT NULL,
    Dealer_Area           VARCHAR(30) NOT NULL,
    Dealer_Choice_Reason  VARCHAR(30) NOT NULL,
    Resale_Expectation    VARCHAR(30) NOT NULL,
    Service_Info_Known    VARCHAR(30) NOT NULL,
    No_Info_Reason        VARCHAR(20) NULL,
    Ownership_Complaint   VARCHAR(30) NOT NULL,
    Complaint_Theme       VARCHAR(40) NOT NULL
);
GO

/* ---------- SECTION 2: load the CSV ----------
   BULK INSERT from file location C:\Data\Cleaned_Data.csv  */
BULK INSERT dbo.tata_suv_survey
FROM 'C:\Data\Cleaned_Data.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a',
      KEEPNULLS, CODEPAGE = '65001');
GO

/* ---------- SECTION 3: validation checks ----------*/ 

-- V1. Row count and ID integrity.   EXPECT: 135 | 1 | 135 | 135
SELECT COUNT(*)                    AS row_count,
       MIN(Respondent_ID)          AS min_id,
       MAX(Respondent_ID)          AS max_id,
       COUNT(DISTINCT Respondent_ID) AS distinct_ids
FROM dbo.tata_suv_survey;

-- V2. Null count per column.        EXPECT: 0 everywhere except No_Info_Reason = 114
SELECT 'Respondent_ID' AS column_name, COUNT(*) - COUNT(Respondent_ID) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Gender' AS column_name, COUNT(*) - COUNT(Gender) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Age_Group' AS column_name, COUNT(*) - COUNT(Age_Group) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Age_Sort' AS column_name, COUNT(*) - COUNT(Age_Sort) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Occupation' AS column_name, COUNT(*) - COUNT(Occupation) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Income_Band' AS column_name, COUNT(*) - COUNT(Income_Band) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Income_Sort' AS column_name, COUNT(*) - COUNT(Income_Sort) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Model_Interest' AS column_name, COUNT(*) - COUNT(Model_Interest) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Powertrain' AS column_name, COUNT(*) - COUNT(Powertrain) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Transmission' AS column_name, COUNT(*) - COUNT(Transmission) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Budget_Band' AS column_name, COUNT(*) - COUNT(Budget_Band) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Budget_Sort' AS column_name, COUNT(*) - COUNT(Budget_Sort) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Purpose' AS column_name, COUNT(*) - COUNT(Purpose) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_1' AS column_name, COUNT(*) - COUNT(Motivation_1) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_2' AS column_name, COUNT(*) - COUNT(Motivation_2) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_3' AS column_name, COUNT(*) - COUNT(Motivation_3) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Tech_Must_Have' AS column_name, COUNT(*) - COUNT(Tech_Must_Have) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Info_Source' AS column_name, COUNT(*) - COUNT(Info_Source) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Finance_Mode' AS column_name, COUNT(*) - COUNT(Finance_Mode) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Purchase_Occasion' AS column_name, COUNT(*) - COUNT(Purchase_Occasion) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer' AS column_name, COUNT(*) - COUNT(Dealer) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer_Area' AS column_name, COUNT(*) - COUNT(Dealer_Area) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer_Choice_Reason' AS column_name, COUNT(*) - COUNT(Dealer_Choice_Reason) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Resale_Expectation' AS column_name, COUNT(*) - COUNT(Resale_Expectation) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Service_Info_Known' AS column_name, COUNT(*) - COUNT(Service_Info_Known) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'No_Info_Reason' AS column_name, COUNT(*) - COUNT(No_Info_Reason) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Ownership_Complaint' AS column_name, COUNT(*) - COUNT(Ownership_Complaint) AS null_count FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Complaint_Theme' AS column_name, COUNT(*) - COUNT(Complaint_Theme) AS null_count FROM dbo.tata_suv_survey;

-- V3. Logic and domain checks.      EXPECT: violations = 0 on every line
SELECT 'Service info = Yes but a reason is filled' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Service_Info_Known = 'Yes' AND No_Info_Reason IS NOT NULL) x
UNION ALL
SELECT 'Service info = No but reason is missing' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Service_Info_Known = 'No' AND No_Info_Reason IS NULL) x
UNION ALL
SELECT 'Age_Group with more than one Age_Sort' AS check_name, COUNT(*) AS violations FROM (SELECT Age_Group FROM dbo.tata_suv_survey GROUP BY Age_Group HAVING COUNT(DISTINCT Age_Sort) > 1) x
UNION ALL
SELECT 'Income_Band with more than one Income_Sort' AS check_name, COUNT(*) AS violations FROM (SELECT Income_Band FROM dbo.tata_suv_survey GROUP BY Income_Band HAVING COUNT(DISTINCT Income_Sort) > 1) x
UNION ALL
SELECT 'Budget_Band with more than one Budget_Sort' AS check_name, COUNT(*) AS violations FROM (SELECT Budget_Band FROM dbo.tata_suv_survey GROUP BY Budget_Band HAVING COUNT(DISTINCT Budget_Sort) > 1) x
UNION ALL
SELECT 'Complaint mapped to more than one theme' AS check_name, COUNT(*) AS violations FROM (SELECT Ownership_Complaint FROM dbo.tata_suv_survey GROUP BY Ownership_Complaint HAVING COUNT(DISTINCT Complaint_Theme) > 1) x
UNION ALL
SELECT 'Dealer mapped to more than one area' AS check_name, COUNT(*) AS violations FROM (SELECT Dealer FROM dbo.tata_suv_survey GROUP BY Dealer HAVING COUNT(DISTINCT Dealer_Area) > 1) x
UNION ALL
SELECT 'Unexpected value in Gender' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Gender NOT IN ('Male', 'Female')) x
UNION ALL
SELECT 'Unexpected value in Age_Group' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Age_Group NOT IN ('18-25', '26-35', '36-45', '46-55', 'Above 55')) x
UNION ALL
SELECT 'Unexpected value in Occupation' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Occupation NOT IN ('Salaried', 'Business', 'Homemaker', 'Retired')) x
UNION ALL
SELECT 'Unexpected value in Income_Band' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Income_Band NOT IN ('Below 50K', '50K-1L', '1L-2L', 'Above 2L')) x
UNION ALL
SELECT 'Unexpected value in Model_Interest' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Model_Interest NOT IN ('Punch', 'Nexon', 'Curvv', 'Harrier', 'Safari', 'Sierra')) x
UNION ALL
SELECT 'Unexpected value in Powertrain' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Powertrain NOT IN ('Petrol', 'Diesel', 'EV', 'CNG')) x
UNION ALL
SELECT 'Unexpected value in Transmission' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Transmission NOT IN ('Manual', 'Automatic')) x
UNION ALL
SELECT 'Unexpected value in Budget_Band' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Budget_Band NOT IN ('Below 10L', '10L-18L', '18L-25L', 'Above 25L')) x
UNION ALL
SELECT 'Unexpected value in Finance_Mode' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Finance_Mode NOT IN ('Loan', 'Cheque', 'Digital')) x
UNION ALL
SELECT 'Unexpected value in Resale_Expectation' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Resale_Expectation NOT IN ('Yes', 'No')) x
UNION ALL
SELECT 'Unexpected value in Service_Info_Known' AS check_name, COUNT(*) AS violations FROM (SELECT 1 AS n FROM dbo.tata_suv_survey WHERE Service_Info_Known NOT IN ('Yes', 'No')) x;

-- V4. Hidden leading/trailing spaces. EXPECT: 0
SELECT COUNT(*) AS rows_with_extra_spaces
FROM dbo.tata_suv_survey
WHERE Gender <> LTRIM(RTRIM(Gender))
   OR Age_Group <> LTRIM(RTRIM(Age_Group))
   OR Occupation <> LTRIM(RTRIM(Occupation))
   OR Income_Band <> LTRIM(RTRIM(Income_Band))
   OR Model_Interest <> LTRIM(RTRIM(Model_Interest))
   OR Powertrain <> LTRIM(RTRIM(Powertrain))
   OR Transmission <> LTRIM(RTRIM(Transmission))
   OR Budget_Band <> LTRIM(RTRIM(Budget_Band))
   OR Purpose <> LTRIM(RTRIM(Purpose))
   OR Motivation_1 <> LTRIM(RTRIM(Motivation_1))
   OR Motivation_2 <> LTRIM(RTRIM(Motivation_2))
   OR Motivation_3 <> LTRIM(RTRIM(Motivation_3))
   OR Tech_Must_Have <> LTRIM(RTRIM(Tech_Must_Have))
   OR Info_Source <> LTRIM(RTRIM(Info_Source))
   OR Finance_Mode <> LTRIM(RTRIM(Finance_Mode))
   OR Purchase_Occasion <> LTRIM(RTRIM(Purchase_Occasion))
   OR Dealer <> LTRIM(RTRIM(Dealer))
   OR Dealer_Area <> LTRIM(RTRIM(Dealer_Area))
   OR Dealer_Choice_Reason <> LTRIM(RTRIM(Dealer_Choice_Reason))
   OR Resale_Expectation <> LTRIM(RTRIM(Resale_Expectation))
   OR Service_Info_Known <> LTRIM(RTRIM(Service_Info_Known))
   OR Ownership_Complaint <> LTRIM(RTRIM(Ownership_Complaint))
   OR Complaint_Theme <> LTRIM(RTRIM(Complaint_Theme));

-- V5. Distinct values per column (quick profile).
SELECT 'Gender' AS column_name, COUNT(DISTINCT Gender) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Age_Group' AS column_name, COUNT(DISTINCT Age_Group) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Age_Sort' AS column_name, COUNT(DISTINCT Age_Sort) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Occupation' AS column_name, COUNT(DISTINCT Occupation) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Income_Band' AS column_name, COUNT(DISTINCT Income_Band) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Income_Sort' AS column_name, COUNT(DISTINCT Income_Sort) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Model_Interest' AS column_name, COUNT(DISTINCT Model_Interest) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Powertrain' AS column_name, COUNT(DISTINCT Powertrain) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Transmission' AS column_name, COUNT(DISTINCT Transmission) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Budget_Band' AS column_name, COUNT(DISTINCT Budget_Band) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Budget_Sort' AS column_name, COUNT(DISTINCT Budget_Sort) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Purpose' AS column_name, COUNT(DISTINCT Purpose) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_1' AS column_name, COUNT(DISTINCT Motivation_1) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_2' AS column_name, COUNT(DISTINCT Motivation_2) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Motivation_3' AS column_name, COUNT(DISTINCT Motivation_3) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Tech_Must_Have' AS column_name, COUNT(DISTINCT Tech_Must_Have) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Info_Source' AS column_name, COUNT(DISTINCT Info_Source) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Finance_Mode' AS column_name, COUNT(DISTINCT Finance_Mode) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Purchase_Occasion' AS column_name, COUNT(DISTINCT Purchase_Occasion) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer' AS column_name, COUNT(DISTINCT Dealer) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer_Area' AS column_name, COUNT(DISTINCT Dealer_Area) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Dealer_Choice_Reason' AS column_name, COUNT(DISTINCT Dealer_Choice_Reason) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Resale_Expectation' AS column_name, COUNT(DISTINCT Resale_Expectation) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Service_Info_Known' AS column_name, COUNT(DISTINCT Service_Info_Known) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'No_Info_Reason' AS column_name, COUNT(DISTINCT No_Info_Reason) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Ownership_Complaint' AS column_name, COUNT(DISTINCT Ownership_Complaint) AS distinct_values FROM dbo.tata_suv_survey
UNION ALL
SELECT 'Complaint_Theme' AS column_name, COUNT(DISTINCT Complaint_Theme) AS distinct_values FROM dbo.tata_suv_survey;

-- V6. Full value profile of the categorical columns (about 65 rows; scan it once).
SELECT 'Gender' AS column_name, CAST(Gender AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Gender
UNION ALL
SELECT 'Age_Group' AS column_name, CAST(Age_Group AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Age_Group
UNION ALL
SELECT 'Occupation' AS column_name, CAST(Occupation AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Occupation
UNION ALL
SELECT 'Income_Band' AS column_name, CAST(Income_Band AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Income_Band
UNION ALL
SELECT 'Model_Interest' AS column_name, CAST(Model_Interest AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Model_Interest
UNION ALL
SELECT 'Powertrain' AS column_name, CAST(Powertrain AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Powertrain
UNION ALL
SELECT 'Transmission' AS column_name, CAST(Transmission AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Transmission
UNION ALL
SELECT 'Budget_Band' AS column_name, CAST(Budget_Band AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Budget_Band
UNION ALL
SELECT 'Purpose' AS column_name, CAST(Purpose AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Purpose
UNION ALL
SELECT 'Tech_Must_Have' AS column_name, CAST(Tech_Must_Have AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Tech_Must_Have
UNION ALL
SELECT 'Info_Source' AS column_name, CAST(Info_Source AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Info_Source
UNION ALL
SELECT 'Finance_Mode' AS column_name, CAST(Finance_Mode AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Finance_Mode
UNION ALL
SELECT 'Purchase_Occasion' AS column_name, CAST(Purchase_Occasion AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Purchase_Occasion
UNION ALL
SELECT 'Dealer' AS column_name, CAST(Dealer AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Dealer
UNION ALL
SELECT 'Dealer_Choice_Reason' AS column_name, CAST(Dealer_Choice_Reason AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Dealer_Choice_Reason
UNION ALL
SELECT 'Resale_Expectation' AS column_name, CAST(Resale_Expectation AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Resale_Expectation
UNION ALL
SELECT 'Ownership_Complaint' AS column_name, CAST(Ownership_Complaint AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Ownership_Complaint
UNION ALL
SELECT 'Complaint_Theme' AS column_name, CAST(Complaint_Theme AS VARCHAR(40)) AS value, COUNT(*) AS respondents FROM dbo.tata_suv_survey GROUP BY Complaint_Theme
ORDER BY column_name, respondents DESC;

/* ---------- SECTION 4: analysis view (flags + groupings used by later queries and Power BI) ---------- */
GO
CREATE VIEW dbo.vw_survey_enriched AS
SELECT s.*,
       CASE WHEN s.Powertrain   = 'EV'        THEN 1 ELSE 0 END AS is_ev,
       CASE WHEN s.Transmission = 'Automatic' THEN 1 ELSE 0 END AS is_automatic,
       CASE WHEN s.Finance_Mode = 'Loan'      THEN 1 ELSE 0 END AS is_loan,
       CASE WHEN s.Model_Interest = 'Punch'                 THEN 'Entry'
            WHEN s.Model_Interest IN ('Nexon', 'Curvv')     THEN 'Compact'
            ELSE 'Premium' END AS model_tier,
       CASE s.Age_Group WHEN '18-25' THEN 'Gen Z (18-25)'
                        WHEN '26-35' THEN 'Young professionals (26-35)'
                        WHEN '36-45' THEN 'Family builders (36-45)'
                        WHEN '46-55' THEN 'Pre-retirement (46-55)'
                        ELSE 'Seniors (55+)' END AS life_stage
FROM dbo.tata_suv_survey s;
GO
SELECT TOP 5 * FROM dbo.vw_survey_enriched;   -- sanity check
