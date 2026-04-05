
CREATE OR REPLACE FUNCTION analytics.fn_nationality (
    p_country TEXT
)
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT
        CASE
            WHEN p_country = 'Armenia' THEN 'Hay'
            WHEN p_country = 'Georgia' THEN 'Vraci'
            ELSE 'other'
        END;
$$;

SELECT * FROM analytics.customers 
SELECT * FROM analytics.countries
SELECT * FROM analytics.cities
SELECT * FROM analytics.regions

SELECT
  customer_id,
  co.country_name,
  analytics.fn_nationality(co.country_name) AS nationality
FROM analytics.customers c
LEFT JOIN analytics.cities ci ON c.city_id=ci.city_id
LEFT JOIN analytics.regions r ON ci.region_id=r.region_id
LEFT JOIN analytics.countries co ON r.country_id=co.country_id




CREATE OR REPLACE FUNCTION analytics.fn_number_of_customer_by_nationality (
    p_nationality TEXT
)
RETURNS TABLE (
   num_of_customers INT
)
LANGUAGE sql
AS $$
    SELECT
        COUNT(*) AS num_of_customers
	FROM analytics.customers c
    LEFT JOIN analytics.cities ci ON c.city_id=ci.city_id
    LEFT JOIN analytics.regions r ON ci.region_id=r.region_id
    LEFT JOIN analytics.countries co ON r.country_id=co.country_id
	WHERE analytics.fn_nationality (country_name) = p_nationality
   
$$;



SELECT
  *
FROM analytics.fn_number_of_customer_by_nationality ('Hay')


-------------------------------------------------

CREATE OR REPLACE FUNCTION function_name (
    parameter_name data_type,
    ...
)
RETURNS return_data_type
LANGUAGE sql
AS $$
    SELECT expression;
$$;



--Age Categorization Function

CREATE OR REPLACE FUNCTION fn_age_group(
  p_age INT  
)
RETURNS TEXT
LANGUAGE SQL
AS $$
    SELECT
	     CASE
		     WHEN p_age< 25 THEN 'Under 25'
			 WHEN p_age BETWEEN 25 AND 39 THEN '25-39'
			 WHEN p_age BETWEEN 40 AND 59 THEN '40-59'
			 ELSE '60+'
		 END;	 
$$;


SELECT
  customer_id,
  age,
  fn_age_group(age) AS age_group
FROM analytics.customers;


--Customer Tenure Classification


CREATE OR REPLACE FUNCTION analytics.fn_customer_tenure(
  p_signup_date DATE
)
RETURNS TEXT
LANGUAGE SQL
AS $$
    SELECT
	     CASE
		     WHEN CURRENT_DATE - p_signup_date < 180 THEN 'NEW'
			 WHEN CURRENT_DATE - p_signup_date <365 THEN 'ESTABLISHED'
			 ELSE 'LOYAL'
	      END;
$$;

SELECT
 customer_id,
 signup_date,
 analytics.fn_customer_tenure(signup_date) AS tenure_group
FROM analytics.customers;




--Table-Valued User Defined Functions


CREATE OR REPLACE FUNCTION function_name (
    parameter_name data_type,
    ...
)
RETURNS TABLE (
    column_name data_type,
    ...
)
LANGUAGE sql
AS $$
    SELECT ...
$$;


--Recent Orders for a Customer

CREATE OR REPLACE FUNCTION analytics.fn_order_activity(
   p_customer_id INT,
   p_limit       INT
)
RETURNS TABLE (
    order_id    INT,
    order_date  DATE,
    status      TEXT,
    order_total NUMERIC
	
LANGUAGE SQL

AS $$
    SELECT
        o.order_id,
        o.order_date,
        o.status,
        COALESCE(SUM(oi.quantity * p.price), 0) AS order_total
 FROM analytics.orders o
    JOIN analytics.order_items oi ON oi.order_id = o.order_id
    JOIN analytics.products p     ON p.product_id = oi.product_id
    WHERE o.customer_id = p_customer_id
    GROUP BY o.order_id, o.order_date, o.status
    ORDER BY o.order_date DESC
    LIMIT GREATEST(p_limit, 0);
$$;		