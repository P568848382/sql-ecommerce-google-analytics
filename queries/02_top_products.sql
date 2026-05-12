-- ============================================================
-- Query 2: Top 10 Products by Units Sold
-- Project: Ecommerce Sales Analysis (Google Analytics - BigQuery)
-- Author: Pradeep Kumar
-- ============================================================

/*
Business Question: Which products are selling the most units?
Note: Some productQuantity values are abnormally large (data quality issue
in the public demo dataset). In production, these would be investigated
and filtered. Retained here to document the data quality observation.
*/

SELECT
    v2ProductName                                                        AS product_name,
    productSKU                                                           AS sku,
    SUM(productQuantity)                                                 AS total_units_sold,
    COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING)))       AS unique_sessions_with_product,
    ROUND(SUM(productQuantity) / COUNT(DISTINCT visitId), 2)             AS avg_units_per_session
FROM `data-to-insights.ecommerce.all_sessions`
WHERE
    productQuantity IS NOT NULL
    AND v2ProductName IS NOT NULL
GROUP BY v2ProductName, productSKU
ORDER BY total_units_sold DESC
LIMIT 10;
