
SELECT
*
FROM analytics.orders

SELECT
*
FROM analytics.order_items

SELECT
*
FROM analytics.products

CREATE TEMP TABLE tmp_oredr_products AS
SELECT
  o.order_id,
  --oi.product_id,
  oi.quantity,
  p.product_name,
  p.category,
  p.price
FROM analytics.orders o
LEFT JOIN analytics.order_items oi ON (o.order_id = oi.order_id)
LEFT JOIN analytics.products p ON (oi.product_id = p.product_id);

SELECT
  *
FROM tmp_oredr_products


SELECT
  product_name,
  SUM(quantity*price) AS total_revenue
FROM tmp_oredr_products
GROUP BY product_name
ORDER BY total_revenue DESC;


SELECT
  product_name,
  SUM (quantity)
FROM tmp_oredr_products
GROUP BY product_name
ORDER BY SUM (quantity) DESC;

SELECT
  category,
  SUM(quantity*price) AS total_revenue
FROM tmp_oredr_products
GROUP BY category
ORDER BY total_revenue DESC;

SELECT
  category,
  SUM (quantity)
FROM tmp_oredr_products
GROUP BY category
ORDER BY SUM (quantity) DESC;


CREATE TEMP TABLE tmp_order_revenue AS
SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.quantity * p.price) AS order_revenue
FROM analytics.orders o
JOIN analytics.order_items oi ON (o.order_id = oi.order_id)
JOIN analytics.products p ON (oi.product_id = p.product_id)
GROUP BY o.order_id, o.customer_id;


SELECT
  *
FROM tmp_order_revenue





SELECT
  AVG(order_revenue)
FROM tmp_order_revenue


SELECT
  customer_id,
  AVG(order_revenue)
FROM tmp_order_revenue
GROUP BY customer_id
HAVING AVG(order_revenue) > (
  SELECT
  AVG(order_revenue)
  FROM tmp_order_revenue
)
  





