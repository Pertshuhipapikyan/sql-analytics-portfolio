DROP TABLE IF EXISTS sales_analysis;

CREATE TABLE sales_analysis AS
SELECT
    s.transaction_id,

    o.order_date,
    DATE(o.order_date) AS order_date_date,
    o.year,
    o.quarter,
    o.month,

    c.customer_name,
    c.city,
    c.zip_code,

    p.product_name,
    p.category,
    p.price,

    e.first_name AS employee_first_name,
    e.last_name  AS employee_last_name,
    e.salary     AS employee_salary,

    s.quantity,
    s.discount,
    s.total_sales
FROM sales AS s
JOIN orders AS o
    ON s.order_id = o.order_id
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_id;

	CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);

	SELECT
    transaction_id,
    order_date_date,
    category,
    total_sales
FROM sales_analysis
WHERE total_sales > 100000;

SELECT
    transaction_id,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda';

SELECT
    transaction_id,
    year,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE year = 2023
  AND category = 'Electronics'
  AND total_sales > 100000;

  SELECT
    transaction_id,
    total_sales,
    CASE
        WHEN total_sales >= 100000 THEN 'High Value'
        WHEN total_sales >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_segment
FROM sales_analysis;

SELECT
  *
FROM total_sales
LIMI



SELECT
  customer_name,
  CASE
      WHEN AVG(total_sales) > 252  THEN 'Above Average'
	  WHEN AVG(total_sales) = 252  THEN 'Average'
      WHEN AVG(total_sales) < 252  THEN 'Below Average'
	  ELSE 'Warning'
  END as segment

FROM sales_analysis
GROUP BY customer_name


SELECT avg(total_sales) as average_sales
FROM sales;
	  