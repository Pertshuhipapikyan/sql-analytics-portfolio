SELECT
  order_date_date,
    (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', order_date_date)) * 12
  + (DATE_PART('month', CURRENT_DATE) - DATE_PART('month', order_date_date))
  - CASE
      WHEN DATE_PART('day', CURRENT_DATE)
        < DATE_PART('day', order_date_date)
      THEN 1 ELSE 0
  END AS full_months
FROM sales_analysis
ORDER BY order_date_date DESC
LIMIT 10;


--aggregate total sales by
SELECT
  DATE_TRUNC('month', order_date_date) AS month,
  sum(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('month', order_date_date)
ORDER BY total_revenue DESC;

SELECT
    DATE_TRUNC('quarter', order_date_date) AS quarter,
    SUM(total_sales) AS total_sales
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date)
ORDER BY quarter;

--identify
SELECT
    DATE_TRUNC('month', order_date_date) AS month,
    SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('month', order_date_date)
ORDER BY total_revenue DESC
LIMIT 3;

SELECT
    DATE_TRUNC('quarter', order_date_date) AS quarter,
    SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date)
ORDER BY total_revenue DESC
LIMIT 1;


--compute
--days since each transaction

SELECT
    transaction_id,
    order_date_date,
    CURRENT_DATE - order_date_date AS days_since_transaction
FROM sales_analysis
ORDER BY order_date_date DESC;


--filter
SELECT 
  *
FROM sales_analysis
WHERE CURRENT_DATE - order_date_date <= 60 ;
