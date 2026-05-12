  -- ============================================================
-- Query 5: Monthly Revenue Trend (Aug 2016 — Aug 2017)
-- Project: Ecommerce Sales Analysis (Google Analytics - BigQuery)
-- Author: Pradeep Kumar
-- ============================================================

/*
Business Question: How has revenue trended month over month?
Note: The 'date' column is stored as STRING in YYYYMMDD format.
PARSE_DATE converts it to a proper DATE type before extracting year/month.
BigQuery syntax: PARSE_DATE('%Y%m%d', date)
PostgreSQL equivalent: TO_DATE(date_col, 'YYYYMMDD')
*/

SELECT
    EXTRACT(YEAR  FROM PARSE_DATE('%Y%m%d', date))        AS year,
    EXTRACT(MONTH FROM PARSE_DATE('%Y%m%d', date))        AS month,
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date))      AS year_month,
    ROUND(SUM(totalTransactionRevenue) / 1000000, 2)      AS monthly_revenue,
    COUNT(DISTINCT visitId)                               AS monthly_visits,
    COUNTIF(transactions IS NOT NULL)                     AS monthly_transactions
FROM `data-to-insights.ecommerce.all_sessions`
WHERE totalTransactionRevenue IS NOT NULL
GROUP BY year, month, year_month
ORDER BY year, month;
