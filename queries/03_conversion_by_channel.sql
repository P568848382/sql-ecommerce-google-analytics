-- ============================================================
-- Query 3: Session-to-Transaction Conversion Rate by Traffic Channel
-- Project: Ecommerce Sales Analysis (Google Analytics - BigQuery)
-- Author: Pradeep Kumar
-- ============================================================

/*
Business Question: Which traffic channel converts visitors into buyers most effectively?
Key Insight: Referral shows unusually high conversion (>100%) which indicates
multiple transaction rows per session in the dataset — a data modelling artifact
of the all_sessions table structure where one session can have multiple product rows.
This is a data quality flag worth noting in a real analyst role.
*/

SELECT
    channelGrouping,
    COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING))) AS unique_sessions,
    COUNTIF(transactions IS NOT NULL AND transactions > 0)         AS converting_sessions,
    ROUND(
        COUNTIF(transactions IS NOT NULL AND transactions > 0) * 100.0
        / COUNT(DISTINCT visitId),
        2
    )                                                              AS conversion_rate_pct
FROM `data-to-insights.ecommerce.all_sessions`
GROUP BY channelGrouping
ORDER BY conversion_rate_pct DESC;
