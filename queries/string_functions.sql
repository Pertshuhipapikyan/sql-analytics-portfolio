DROP TABLE IF EXISTS transactions_text_demo;

CREATE TABLE transactions_text_demo (
  transaction_id INTEGER,
  customer_id    INTEGER,
  raw_phone      TEXT,
  category_raw   TEXT,
  quantity       INTEGER,
  price          NUMERIC(10,2)
);

INSERT INTO transactions_text_demo
SELECT
  gs AS transaction_id,
  (RANDOM() * 200)::INT + 1 AS customer_id,

  CASE (gs % 6)
    WHEN 0 THEN '   077600945  '
    WHEN 1 THEN '077-600-045'
    WHEN 2 THEN '(374)-77-600-945'
    WHEN 3 THEN '37477600945'
    WHEN 4 THEN '77600945'
    ELSE '077600945'
  END AS raw_phone,

  CASE (gs % 5)
    WHEN 0 THEN 'Accessories (Promo)'
    WHEN 1 THEN 'Accessories (Test)'
    WHEN 2 THEN 'Electronics (Old)'
    WHEN 3 THEN 'Electronics (Promo)'
    ELSE 'Accessories'
  END AS category_raw,

  (RANDOM() * 5)::INT + 1 AS quantity,
  (RANDOM() * 500 + 10)::NUMERIC(10,2) AS price
FROM generate_series(1, 1000) AS gs;

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT raw_phone) AS distinct_raw_phones,
  COUNT(DISTINCT category_raw) AS distinct_categories
FROM transactions_text_demo;

--TASK 1
--phone number format diversity

SELECT 
  COUNT(DISTINCT raw_phone)
FROM transactions_text_demo;

SELECT
  raw_phone,
  LENGTH(raw_phone) AS phone_length
FROM transactions_text_demo
GROUP BY raw_phone; 

SELECT
  raw_phone
FROM transactions_text_demo
WHERE raw_phone ~ '[^0-9]';


--category fragmentation

SELECT 
  COUNT(DISTINCT category_raw)
FROM transactions_text_demo;

SELECT
  category_raw ,
  COUNT(DISTINCT category_raw) AS number_category_raw
FROM transactions_text_demo
GROUP BY category_raw;

SELECT 
  category_raw,
  SPLIT_PART(category_raw, '(', 1) AS base_category
FROM transactions_text_demo
GROUP BY category_raw;  

SELECT
  COUNT(DISTINCT category_raw) AS raw_categories,
  COUNT(DISTINCT SPLIT_PART(category_raw, ' (', 1) ) AS base_categories
FROM transactions_text_demo; 

--raw = 5, base = 2 → fragmentation կա։


--Case A – Raw GROUP BY
SELECT
  category_raw,
  SUM(quantity*price) AS revenue
FROM transactions_text_demo
GROUP BY category_raw;

--Case B - Clean GROUP BY
SELECT
  SPLIT_PART(category_raw, ' (', 1 ) AS base_category,
  SUM(quantity*price) AS revenue
FROM transactions_text_demo
GROUP BY SPLIT_PART(category_raw, ' (', 1 );



--TASK 2

--standardized phone number (last 8 digits)

SELECT
  raw_phone,
  REPLACE(raw_phone, '-', '') AS phone_no_hyphen
FROM   transactions_text_demo ;


SELECT
  raw_phone,
  REPLACE(
    REPLACE(
      REPLACE(TRIM(raw_phone), '-', ''),
	'(', ''),
 ')','' ) AS phone_partial_clean
FROM  transactions_text_demo;

--OR

SELECT
  raw_phone,
  REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g') AS digits_only
FROM transactions_text_demo;

--Last 8 digits

SELECT
    raw_phone,
    SUBSTRING(
        REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')
        FROM LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')) - 7
        FOR 8
    ) AS last_8_digits
FROM transactions_text_demo;


--cleaned category (no annotations, trimmed)

SELECT
 category_raw,
 TRIM(SPLIT_PART(category_raw, '(', 1 )) AS first_part
FROM  transactions_text_demo;

--revenue per transaction

quantity*price


--
SELECT

  transaction_id,
  customer_id,
  
  SUBSTRING(
        REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')
        FROM LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')) - 7
        FOR 8
    ) AS last_8_digits,
  	
  TRIM(SPLIT_PART(category_raw, '(', 1 )) AS first_part,

  quantity * price AS revenue

FROM transactions_text_demo;	


--TASK 3

--revenue by raw category

SELECT
    category_raw,
    SUM(quantity * price) AS total_revenue
FROM transactions_text_demo
GROUP BY category_raw
ORDER BY total_revenue DESC;

--revenue by cleaned category
SELECT
    TRIM(SPLIT_PART(category_raw, '(', 1)) AS category_cleaned,
    SUM(quantity * price) AS total_revenue
FROM transactions_text_demo
GROUP BY TRIM(SPLIT_PART(category_raw, '(', 1))
ORDER BY total_revenue DESC;

--unique customers (raw vs cleaned phone)

-- Raw phone
SELECT
    COUNT(DISTINCT raw_phone) AS unique_customers_raw
FROM transactions_text_demo;

-- Cleaned phone (վերջի 8 թվանշանները)
SELECT
    COUNT(DISTINCT SUBSTRING(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g') 
                             FROM LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')) - 7 FOR 8)) 
        AS unique_customers_cleaned
FROM transactions_text_demo;

--TASK 4

--Part 4 | Analytical Explanation

--Why KPIs changed: Cleaned categories combined similar categories, and cleaned phone numbers showed the actual number of unique customers.

--Biggest impact: Phone cleaning had the biggest effect on unique customers.

--Assumptions: The last 8 digits are enough to identify a customer, category text before parentheses is correct, no duplicate transactions.

--What could silently break: If new or different formats appear, cleaning could fail and KPIs could change without any errors.


