--Who are our customers and where are they located?

SELECT
  c.customer_id,
  c.first_name,
  ci.city_name,
  r.region_name,
  co.country_name
FROM analytics.customers c
JOIN analytics.cities ci
  ON c.city_id=ci.city_id  
JOIN analytics.regions r
  ON ci.region_id = r.region_id
JOIN analytics.countries co
  ON r.country_id = co.country_id; 


--Do we have customers who have never placed an order? -No

SELECT
  c.customer_id,
  c.first_name,
  o.order_id
FROM analytics.customers c
LEFT JOIN analytics.orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id is NULL;


--Why does joining orders to order items increase row count?

--"The row count increases because of a One-to-Many relationship. One order can contain multiple items. When joined, SQL creates a separate row for every item belonging to that order."  
  

--What products were sold, to whom, and where?

SELECT
  p.product_name,
  c.first_name,
  ci.city_name
FROM analytics.order_items oi  
JOIN analytics.products p
  ON p.product_id = oi.product_id
JOIN analytics.orders o 
  ON oi.order_id = o.order_id  
JOIN analytics.customers c 
  ON o.customer_id = c.customer_id  
JOIN analytics.cities ci 
  ON c.city_id = ci.city_id;  


--Total revenue per country.

SELECT
  SUM(oi.quantity*p.price) AS total_revenue,
  co.country_name
FROM analytics.order_items oi
JOIN analytics.products p
  ON oi.product_id = p.product_id
JOIN analytics.orders o
  ON oi.order_id = o.order_id
JOIN analytics.customers c
  ON o.customer_id= c.customer_id
JOIN analytics.cities ci
  ON c.city_id=ci.city_id
JOIN analytics.regions r
  ON ci.region_id = r.region_id
JOIN analytics.countries co
  ON r.country_id = co.country_id
GROUP BY co.country_name ;   




--Are there customers without a city? No

SELECT 
  first_name
FROM analytics.customers
WHERE city_id is NULL ;  
  