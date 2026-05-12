-- ============================================================
-- Query 1: Which cities generated the highest total revenue?
-- Project: Ecommerce Sales Analysis (Google Analytics - BigQuery)
-- Author: Pradeep Kumar
-- Dataset: data-to-insights.ecommerce.all_sessions
-- ============================================================

/*
Business Question: Which cities are driving the most revenue?
What this shows: Revenue leaderboard by city with data cleaning
for unavailable city values. Uses concat of fullVisitorId + visitId
for accurate unique session count (visitId alone can collide across users).
*/

-- Basic city revenue ranking
SELECT
    city,
    country,
    SUM(totalTransactionRevenue) / 1000000   AS total_revenue,
    COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING))) AS unique_sessions,
    COUNT(transactions)                       AS total_transactions
FROM `data-to-insights.ecommerce.all_sessions`
WHERE
    city IS NOT NULL
    AND city != 'not available in demo dataset'
    AND city != '(not set)'
    AND totalTransactionRevenue IS NOT NULL
GROUP BY city, country
ORDER BY total_revenue DESC
LIMIT 15;


-- ============================================================
-- Extended: Rank cities within each country using Window Functions
-- Shows each city's revenue rank and country total
-- ============================================================

WITH city_revenue AS (
    SELECT
        city,
        country,
        SUM(totalTransactionRevenue) / 1000000                         AS total_revenue,
        COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING))) AS unique_sessions,
        COUNT(transactions)                                             AS total_transactions
    FROM `data-to-insights.ecommerce.all_sessions`
    WHERE
        totalTransactionRevenue IS NOT NULL
        AND city != 'not available in demo dataset'
        AND city != '(not set)'
        AND city IS NOT NULL
    GROUP BY country, city
)
SELECT
    city,
    country,
    total_revenue,
    unique_sessions,
    total_transactions,
    RANK()       OVER (PARTITION BY country ORDER BY total_revenue DESC) AS rank_in_country,
    ROUND(SUM(total_revenue) OVER (PARTITION BY country), 2)             AS country_total_revenue
FROM city_revenue
ORDER BY country, rank_in_country;
