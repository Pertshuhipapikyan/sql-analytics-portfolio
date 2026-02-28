# SQL Practice & Sales Analysis

This repository contains SQL queries, exercises, and visualizations following a structured learning path from introductory relational databases to advanced SQL date functions. The work focuses on sales performance, customer recency, data cleaning, and trend analysis using PostgreSQL (pgAdmin).

---

##  01: Intro to Relational Databases

- Basics of tables, columns, rows, and primary/foreign keys  
- Understanding the relational model and data relationships  

---

##  02: Intro to PostgreSQL

- Connecting to PostgreSQL and pgAdmin  
- Executing basic queries: `SELECT`, `FROM`, `WHERE`  
- Exploring table schemas and metadata  

---

##  03: DA with SQL | Data Types & Constraints

- Understanding numeric, string, date/time data types  
- Using constraints: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`  
- Example: Standardizing raw phone numbers
```sql
SELECT raw_phone,
       REPLACE(REPLACE(REPLACE(TRIM(raw_phone), '-', ''), '(', ''), ')', '') AS phone_clean
FROM transactions_text_demo;
```

##  04: DA with SQL | Filtering

- Filtering rows using `WHERE`, `BETWEEN`, `IN`, `LIKE`

**Example: Filtering transactions from the last 60 days**

```sql
SELECT *
FROM sales_analysis
WHERE order_date_date >= CURRENT_DATE - INTERVAL '60 days';
```

**Using DISTINCT to remove duplicates**

```sql
SELECT
  DISTINCT customer_id, order_id
FROM sales_analysis;
```
##  05: DA with SQL | Numeric Functions

- Aggregations: `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `MIN()`  
- Grouping data by time periods

**Example: Monthly revenue, average order, and order counts**

```sql
SELECT 
    DATE_TRUNC('month', order_date_date) AS month,
    SUM(total_sales) AS total_revenue,        -- total revenue per month
    AVG(total_sales) AS average_order,        -- average order value per month
    COUNT(order_id) AS number_of_orders,      -- number of orders per month
    MAX(total_sales) AS largest_order,        -- largest order in the month
    MIN(total_sales) AS smallest_order        -- smallest order in the month
FROM sales_analysis
GROUP BY month
ORDER BY month;
```


## Session 06: DA with SQL | String Functions

- Cleaning and transforming text fields  
- Using `REPLACE()`, `TRIM()`, `REGEXP_REPLACE()`

**Example: Cleaning text data**

```sql
SELECT REGEXP_REPLACE(raw_text, '[^0-9A-Za-z]+', '', 'g') AS cleaned_text
FROM transactions_text_demo;
```
**Example: Standardizing raw phone numbers**
```sql
SELECT 
  raw_phone,
  REPLACE(REPLACE(REPLACE(TRIM(raw_phone), '-', ''), '(', ''), ')', '') AS phone_clean
FROM transactions_text_demo;
```
## Session 07: DA with SQL | Date Functions

- Using `DATE_TRUNC()` to aggregate by month, quarter, year  
- Calculating days since last transaction

**Example: Days since last transaction**

```sql
SELECT customer_name,
       order_date_date,
       CURRENT_DATE - order_date_date AS days_since_transaction
FROM sales_analysis;
```

**Example: Customer recency in calendar terms using AGE()**
```sql
SELECT customer_name,
       MAX(order_date_date) AS last_transaction_date,
       AGE(CURRENT_DATE, MAX(order_date_date)) AS recency_calendar
FROM sales_analysis
GROUP BY customer_name
ORDER BY last_transaction_date DESC;
```