# Ecommerce Sales Analysis — Google Analytics Data (BigQuery)

## Overview
Analysis of Google Merchandise Store session and transaction data using
BigQuery SQL. Covers revenue analysis, product performance, traffic channel
conversion rates, cart abandonment patterns, and monthly revenue trends.

## Tools Used
- **Google BigQuery** (cloud SQL engine)
- **Dataset:** `data-to-insights.ecommerce.all_sessions` (Public BigQuery dataset)

## Dataset
| Detail | Info |
|---|---|
| Source | BigQuery Public Data — data-to-insights |
| Table | ecommerce.all_sessions |
| Size | ~2,00,00,000 total rows |
| Period | August 2016 — August 2017 |
| Access | Free — 1TB/month query limit on BigQuery free tier |

---

## Business Questions Answered

### 1. Which cities generated the highest total revenue?
- New York led all cities with **$57.95M** in revenue
- Mountain View and San Francisco followed at **$41.7M** and **$25.2M**
- Toronto was the top Canadian city at **$4.5M**
- Window function used to rank cities within each country

📄 [`queries/01_city_revenue.sql`](queries/01_city_revenue.sql)

---

### 2. Top 10 products by units sold
- Identified top-selling products by SKU and product name
- Flagged data quality anomaly: some `productQuantity` values are abnormally
  large (known issue in this public demo dataset)
- Avg units per session calculated alongside total units

📄 [`queries/02_top_products.sql`](queries/02_top_products.sql)

---

### 3. Conversion rate by traffic channel
- Referral and Display channels showed conversion rates above 100%
- This is a **data modelling artifact** — the all_sessions table has
  multiple product rows per session, inflating the denominator
- Organic Search had the highest volume of converting sessions (478,985)

📄 [`queries/03_conversion_by_channel.sql`](queries/03_conversion_by_channel.sql)

---

### 4. Cart abandonment by channel
- **44.7%** of all abandoned sessions came from Organic Search
- Referral (25.3%) and Direct (19.8%) followed
- Used CTE to classify sessions before aggregating by channel

📄 [`queries/04_cart_abandonment.sql`](queries/04_cart_abandonment.sql)

---

### 5. Monthly revenue trend
- Peak revenue month: **August 2016 ($85.1M)**
- Revenue declined through Oct 2016, recovered Nov–Dec (holiday season)
- August 2017 shows only partial month data ($2M)
- Demonstrates PARSE_DATE usage for STRING-to-DATE conversion in BigQuery

📄 [`queries/05_monthly_revenue_trend.sql`](queries/05_monthly_revenue_trend.sql)

---

## SQL Concepts Demonstrated
| Concept | Used In |
|---|---|
| GROUP BY + aggregations | All queries |
| COUNTIF (BigQuery-specific) | Q3, Q5 |
| CTEs (WITH clause) | Q1 extended, Q4 |
| Window functions (RANK, SUM OVER PARTITION BY) | Q1 extended, Q4 |
| PARSE_DATE / FORMAT_DATE | Q5 |
| CASE WHEN inside MAX() | Q4 |
| Data quality identification | Q2, Q3 |

---

## Key Findings
1. US cities dominate revenue — top 13 revenue cities are all American
2. Organic Search drives the most traffic but also most abandonment by volume
3. Revenue follows a seasonal pattern with November–December spikes
4. The public demo dataset contains known data quality issues in
   `productQuantity` and session-level transaction counting

---

## BigQuery vs PostgreSQL — Syntax Notes
| Task | BigQuery | PostgreSQL |
|---|---|---|
| Conditional count | `COUNTIF(col > 0)` | `SUM(CASE WHEN col > 0 THEN 1 ELSE 0 END)` |
| Parse string to date | `PARSE_DATE('%Y%m%d', col)` | `TO_DATE(col, 'YYYYMMDD')` |
| Format date | `FORMAT_DATE('%Y-%m', date_col)` | `TO_CHAR(date_col, 'YYYY-MM')` |

---

## How to Run These Queries
1. Go to [console.cloud.google.com/bigquery](https://console.cloud.google.com/bigquery)
2. Create a free Google Cloud account (1TB free queries/month)
3. Click **Add Data** → **Star a project by name** → enter `data-to-insights`
4. Open any `.sql` file from the `queries/` folder and run in BigQuery Studio

---

## Other Projects in This Portfolio
| Project | Skills | Link |
|---|---|---|
| Olist Brazilian E-commerce | Multi-table JOINs, PostgreSQL,Python,Tableau · Machine Learning() | https://github.com/P568848382/olist-ecommerce-intelligence |
| Dairy Sales & Finance Analysis | Python 3.11 — Pandas, NumPy,PostgreSQL 15 — Star Schema,Tabular Model — DAX,Tableau Desktop / Tableau Public,All operational funnels, Tableau dashboards | https://github.com/P568848382/msrb_dairy_analytics |
|Superstore Analysis project|Python, SQL, and Tableau | https://github.com/P568848382/superstore-analytics-project |
| Customer Churn Analysis | Cohort analysis, CTEs | Coming soon |
| Employee Performance Dashboard | Window functions, HR analytics | Coming soon |
| Fraud Detection | Rule engine, CTEs, self-joins | Coming soon |
