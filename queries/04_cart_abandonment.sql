-- ============================================================
-- Query 4: Cart Abandonment — Sessions with Events but No Purchase
-- Project: Ecommerce Sales Analysis (Google Analytics - BigQuery)
-- Author: Pradeep Kumar
-- ============================================================

/*
Business Question: Which traffic channels have the highest cart abandonment?
Logic: A session "abandoned" if it had at least one EVENT action
(indicating engagement/add-to-cart intent) but no completed transaction.
Uses CTE to first classify each session, then aggregates by channel.
*/

WITH cart_sessions AS (
    SELECT
        visitId,
        fullVisitorId,
        city,
        country,
        channelGrouping,
        MAX(CASE WHEN type = 'EVENT' THEN 1 ELSE 0 END)                          AS had_event,
        MAX(CASE WHEN transactions IS NOT NULL AND transactions > 0 THEN 1
                 ELSE 0 END)                                                       AS completed_purchase
    FROM `data-to-insights.ecommerce.all_sessions`
    GROUP BY visitId, fullVisitorId, city, country, channelGrouping
)
SELECT
    channelGrouping,
    COUNT(*)                                                                       AS abandoned_sessions,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2), '%')                AS pct_of_all_abandons
FROM cart_sessions
WHERE
    had_event = 1
    AND completed_purchase = 0
GROUP BY channelGrouping
ORDER BY abandoned_sessions DESC;
