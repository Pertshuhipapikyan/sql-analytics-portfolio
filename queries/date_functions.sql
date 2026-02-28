--evaluate sales performance over time for management.

SELECT
  *
FROM sales_analysis;  


--build monthly, quarterly, and yearly aggregations

SELECT
  DATE_TRUNC('month', order_date_date) AS month,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('month', order_date_date)
ORDER BY month;

SELECT
  DATE_TRUNC('quarter', order_date_date) AS quarter,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date)
ORDER BY quarter;

SELECT
  DATE_TRUNC('year', order_date_date) AS year,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('year', order_date_date)
ORDER BY year;

--The interpretation of sales performance significantly depends on the chosen time grain.
--Monthly data reveals high volatility and short-term shocks,
--while quarterly aggregation smooths fluctuations and highlights momentum.
--Yearly aggregation hides seasonal drops and emphasizes structural recovery.


SELECT
  DATE_TRUNC('month', order_date_date) AS month,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('month', order_date_date)
--ORDER BY total_revenue DESC;
ORDER BY total_revenue ASC;



SELECT
  DATE_TRUNC('quarter', order_date_date) AS quarter,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date)
--ORDER BY total_revenue DESC;
ORDER BY total_revenue ASC;



SELECT
  DATE_TRUNC('year', order_date_date) AS year,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('year', order_date_date)
--ORDER BY total_revenue DESC;
ORDER BY total_revenue ASC;


--Strongest Growth Period
--Monthly → Aug 2021 
--Quarterly → 2023 Q2
--Yearly → 2021

--Weakest Period
--Monthly → Sep 2023
--Quarterly → 2023 Q3
--Yearly → 2022



--days since last transaction per customer

SELECT 
  customer_name,
  current_date - order_date_date AS days_since_order
FROM sales_analysis
ORDER BY days_since_order;  


--describe customer recency in calendar terms

SELECT
  customer_name,
  MAX(order_date_date) AS last_transaction_date,
  AGE(CURRENT_DATE, MAX(order_date_date)) AS order_age
FROM  sales_analysis
GROUP BY customer_name;




--Over time, sales have experienced significant fluctuations. Monthly data shows sharp peaks and troughs, revealing short-term volatility and operational shocks. Quarterly aggregation smooths these fluctuations, highlighting momentum and seasonal patterns, while yearly aggregation emphasizes long-term growth and structural trends.
--The choice of time grain matters because it changes how performance is perceived: monthly shows instability, quarterly shows cyclical patterns, and yearly shows overall direction.
--Conclusions about strongest growth periods, weakest periods, and recency insights all depend on the selected time aggregation.
