CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 'online'),
        (2,  'A', DATE '2024-01-02', 120, 'store'),
        (3,  'A', DATE '2024-01-03', 90,  'online'),
        (4,  'A', DATE '2024-01-04', 130, 'store'),

        
        (5,  'B', DATE '2024-01-01', 180, 'store'),
        (6,  'B', DATE '2024-01-02', 200, 'online'),
        (7,  'B', DATE '2024-01-03', 220, 'online'),
        (8,  'B', DATE '2024-01-04', 200, 'store'),

        
        (9,  'C', DATE '2024-01-01', 150, 'online'),
        (10, 'C', DATE '2024-01-02', 150, 'online'),
        (11, 'C', DATE '2024-01-03', 170, 'online'),

        
        (12, 'D', DATE '2024-01-01', 90,  'store'),
        (13, 'D', DATE '2024-01-02', 110, 'store'),

        
        (14, 'E', DATE '2024-01-01', 140, 'store'),
        (15, 'E', DATE '2024-01-02', 160, 'online'),
        (16, 'E', DATE '2024-01-03', 155, 'store')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
	quantity,
    channel
);

--For each order, compute the average order value of the customer across all their orders.

SELECT
  customer_id,
  AVG(amount)
    OVER(
  PARTITION BY customer_id
  ORDER BY sale_date 
  ) AS avg_amount
FROM tmp_sales
;

--For each customer, determine the percent rank of each order based on order revenue.

CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 'online', 2, 'Yerevan'),
        (2,  'A', DATE '2024-01-02', 120, 'store', 1, 'Gyumri'),
        (3,  'A', DATE '2024-01-03', 90,  'online', 3, 'Yerevan'),
        (4,  'A', DATE '2024-01-04', 130, 'store', 2, 'Vanadzor'),

        (5,  'B', DATE '2024-01-01', 180, 'store', 4, 'Yerevan'),
        (6,  'B', DATE '2024-01-02', 200, 'online', 2, 'Gyumri'),
        (7,  'B', DATE '2024-01-03', 220, 'online', 5, 'Yerevan'),
        (8,  'B', DATE '2024-01-04', 200, 'store', 3, 'Vanadzor'),

        (9,  'C', DATE '2024-01-01', 150, 'online', 2, 'Yerevan'),
        (10, 'C', DATE '2024-01-02', 150, 'online', 2, 'Gyumri'),
        (11, 'C', DATE '2024-01-03', 170, 'online', 3, 'Yerevan'),

        (12, 'D', DATE '2024-01-01', 90,  'store', 1, 'Vanadzor'),
        (13, 'D', DATE '2024-01-02', 110, 'store', 2, 'Yerevan'),

        (14, 'E', DATE '2024-01-01', 140, 'store', 3, 'Gyumri'),
        (15, 'E', DATE '2024-01-02', 160, 'online', 2, 'Yerevan'),
        (16, 'E', DATE '2024-01-03', 155, 'store', 1, 'Vanadzor')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    channel,
    quantity,
    city
);

SELECT
  customer_id,
  amount,
  (quantity*amount) AS order_revenue,
  PERCENT_RANK ()
     OVER ( 
	 PARTITION BY customer_id
	 ORDER BY (quantity*amount) DESC
	) 
FROM tmp_sales

--For each customer, compute the difference between the current order and the previous order in time.
  
SELECT
  customer_id,
  LAG(amount) 
  OVER(
   PARTITION BY customer_id
   ORDER BY sale_date
  ) ,
  amount
  - LAG(amount) 
  OVER(
   PARTITION BY customer_id
   ORDER BY sale_date
  ) as diff_order
FROM tmp_sales

--Within each city, rank customers by their total lifetime spend.

SELECT
  customer_id,
  city,
  SUM(amount) AS total_amount,
  DENSE_RANK() OVER (
    PARTITION BY city 
    ORDER BY SUM(amount) DESC
  ) AS customer_rank
FROM tmp_sales
GROUP BY city, customer_id;



--For each customer, construct a chronological history of product categories they have purchased.

CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        -- sale_id, customer_id, sale_date, amount, channel, quantity, city, product_type
        (1,  'A', DATE '2024-01-01', 100, 'online', 2, 'Yerevan',  'Electronics'),
        (2,  'A', DATE '2024-01-02', 120, 'store',  1, 'Gyumri',   'Electronics'),
        (3,  'A', DATE '2024-01-03', 90,  'online', 3, 'Yerevan',  'Accessories'),
        (4,  'A', DATE '2024-01-04', 130, 'store',  2, 'Vanadzor', 'Electronics'),

        (5,  'B', DATE '2024-01-01', 180, 'store',  4, 'Yerevan',  'Apparel'),
        (6,  'B', DATE '2024-01-02', 200, 'online', 2, 'Gyumri',   'Apparel'),
        (7,  'B', DATE '2024-01-03', 220, 'online', 5, 'Yerevan',  'Apparel'),
        (8,  'B', DATE '2024-01-04', 200, 'store',  3, 'Vanadzor', 'Footwear'),

        (9,  'C', DATE '2024-01-01', 150, 'online', 2, 'Yerevan',  'Home Decor'),
        (10, 'C', DATE '2024-01-02', 150, 'online', 2, 'Gyumri',   'Home Decor'),
        (11, 'C', DATE '2024-01-03', 170, 'online', 3, 'Yerevan',  'Kitchenware'),

        (12, 'D', DATE '2024-01-01', 90,  'store',  1, 'Vanadzor', 'Books'),
        (13, 'D', DATE '2024-01-02', 110, 'store',  2, 'Yerevan',  'Books'),

        (14, 'E', DATE '2024-01-01', 140, 'store',  3, 'Gyumri',   'Beauty'),
        (15, 'E', DATE '2024-01-02', 160, 'online', 2, 'Yerevan',  'Beauty'),
        (16, 'E', DATE '2024-01-03', 155, 'store',  1, 'Vanadzor', 'Personal Care')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    channel,
    quantity,
    city,
    product_type
);

SELECT * FROM tmp_sales

SELECT
  customer_id,
  sale_date,
  STRING_AGG(product_type, ' , ') 
     OVER(
       PARTITION BY customer_id
	   ORDER BY sale_date
	   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	  ) AS product_history

FROM tmp_sales;


--Channel Behavior Pattern (Advanced)

SELECT * FROM tmp_sales

WITH customer_channels AS (
    SELECT
        customer_id,
        STRING_AGG(channel, ' -> ' ORDER BY sale_date) AS channel_pattern
    FROM tmp_sales
    GROUP BY customer_id
)
SELECT
    channel_pattern,
    COUNT(*) AS customer_count
FROM customer_channels
GROUP BY channel_pattern