# Tata SUV Consumer Insights — Business/Data Analyst Portfolio Project

End-to-end analysis of a 135-respondent Tata SUV buyer survey (Hyderabad): data cleaning, SQL analysis, an Excel workbook, a 3-page Power BI dashboard, and a business case with recommendations and user stories.

**Author:** Vijay Kumar Vaddanolu · [LinkedIn](https://linkedin.com/in/vaddanolu-vijay-kumar) · vijayk8326@gmail.com

---

## Problem

Tata SUV buyers in Hyderabad were surveyed on purchase preferences, financing, research behaviour, and post-purchase service experience. The goal: find patterns a regional service/sales team could act on — not just describe the sample.

## What this project shows

| Stage | Tool | What it demonstrates |
|---|---|---|
| Data cleaning & validation | Excel (formulas) | Splitting merged fields, standardising labels, an 18-point logic/domain check, a full data dictionary |
| Business analysis | SQL (T-SQL / SQL Server) | 12 business questions using JOINs, CTEs, window functions, CASE, and a reusable analysis view |
| Reporting workbook | Excel | 6 formula-driven analysis sheets, an executive summary with dynamic findings, conditional-format heatmaps |
| Dashboard | Power BI | 3 pages (Executive Overview, Customer Segments, Service & Ownership), DAX measures, synced slicers, drill-through |
| Business Analyst layer | Word/PDF | Problem statement, stakeholders, KPIs, impact-vs-effort recommendations, current/future service journey, 6 user stories with acceptance criteria |

## Key findings

- **Demand is concentrated:** Nexon and Punch together account for 45.9% of model interest.
- **EV interest is age- and model-specific:** it peaks at 50.0% in the 26–35 age group and reaches 62.9% among Nexon-interested buyers, but only 11.1% for Punch.
- **Premium-tier interest rises with income:** 67.7% in the Above-2L income band vs. 23.1% in the 50K–1L band.
- **74.1% of buyers finance through a loan**, rising to 85.7% in the 26–35 group.
- **15.6% of buyers report no service information at purchase — entirely concentrated at one dealer** (50% of that dealer's buyers), a clear point-of-sale gap.
- **Complaint themes cluster distinctly by dealer** with no overlap between them, which likely reflects how the sample was fielded (see Limitations).

## Repository structure

```
tata-suv-consumer-insights/
├── README.md
├── data/
│   └── Cleaned_Data.csv                     # 135 rows, cleaned & documented
├── sql/
│   ├── 01_setup_and_validation.sql          # table DDL, load, 18 validation checks, analysis view
│   ├── 02_business_queries_part1.sql        # Q1–Q6: demand & buyer profile
│   └── 03_business_queries_part2.sql        # Q7–Q12: financing, research, service, segments
├── excel/
│   ├── Tata_SUV_Cleaned_Dataset.xlsx        # cleaning, data dictionary, reconciliation, quality log
│   └── Tata_SUV_Analysis.xlsx               # executive summary + 5 analysis sheets, charts
├── powerbi/
│   ├── TataSUV_Dashboard.pbix               
│   ├── PowerBI_Measures_Page1.dax
│   ├── PowerBI_Measures_Page2.dax
│   ├── PowerBI_Measures_Page3.dax
│   └── TataSUV_theme.json
├── business-case/
│   └── Tata_SUV_Business_Case.pdf           # problem, stakeholders, KPIs, recommendations, user stories
└── screenshots/
    
```

## How to reproduce

1. **SQL:** open `sql/01_setup_and_validation.sql` in SQL Server Management Studio and run it top to bottom (creates the `TataSUV` database, loads `data/Cleaned_Data.csv`, runs validation). Then run `02_business_queries_part1.sql` and `03_business_queries_part2.sql`.
2. **Excel:** open either workbook in `excel/` — all figures are live formulas, not pasted values.
3. **Power BI:** open Power BI Desktop, connect to the `TataSUV` database (`dbo.vw_survey_enriched`), paste in the measures from the three `.dax` files, apply `TataSUV_theme.json`, then save as `TataSUV_Dashboard.pbix` in this folder.
4. **Business case:** `business-case/Tata_SUV_Business_Case.pdf` is a standalone read.

## Limitations

- Convenience sample of 135 respondents, one city, one point in time — findings are directional, not market-wide.
- Dealer-level patterns (complaint theme, service-info gap, choice of dealer) show no overlap between dealers, which is unusually clean for survey data and may partly reflect how the survey was fielded rather than true quality differences. Treat dealer comparisons as indicative.
- Segments under ~30 respondents (e.g. the 55+ age group, n=16) are indicative only.
- Model tiers (Entry/Compact/Premium) and life-stage segments are analyst-defined groupings, documented in each file.

## Contact

Vijay Kumar Vaddanolu — vijayk8326@gmail.com — [linkedin.com/in/vaddanolu-vijay-kumar](https://linkedin.com/in/vaddanolu-vijay-kumar)
