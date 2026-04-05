--What is the general statistical summary of movie rental conditions?
SELECT
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS avg_payment,
    MIN(p.amount) AS min_payment,
    MAX(p.amount) AS max_payment,
    AVG(EXTRACT(EPOCH FROM (r.return_date - r.rental_date))/86400)  AS avg_rental_days
FROM analytics.rental r
JOIN analytics.payment p ON p.rental_id = r.rental_id;


-- Interpretation:

-- The core pricing likely centers around the 3.99–4.99 range.
-- 11.99 suggests penalties or late fees.
-- 0.00 likely represents free rentals, promotions, or data anomalies.
-- Average rental duration: 5.03 days

-- This suggests:

-- Most customers keep movies for approximately 5 days.
-- This is slightly above typical 3–4 day rental policies, possibly indicating late returns.


--How many customers are there per country?

SELECT
    co.country_name,
    COUNT(c.customer_id) AS total_customers
FROM analytics.customer c
JOIN analytics.address a   ON a.address_id = c.address_id
JOIN analytics.city ci     ON ci.city_id = a.city_id
JOIN analytics.country co  ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY total_customers DESC;

--How much revenue does each country generate?

SELECT
    co.country_name,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM analytics.payment p
JOIN analytics.rental r     ON r.rental_id = p.rental_id
JOIN analytics.customer c   ON c.customer_id = r.customer_id
JOIN analytics.address a    ON a.address_id = c.address_id
JOIN analytics.city ci      ON ci.city_id = a.city_id
JOIN analytics.country co   ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY total_revenue DESC;

--What is the average revenue per customer by country?

SELECT
    co.country_name,
    SUM(p.amount) / COUNT(DISTINCT c.customer_id) AS avg_revenue_per_customer
FROM analytics.payment p
JOIN analytics.rental r     ON r.rental_id = p.rental_id
JOIN analytics.customer c   ON c.customer_id = r.customer_id
JOIN analytics.address a    ON a.address_id = c.address_id
JOIN analytics.city ci      ON ci.city_id = a.city_id
JOIN analytics.country co   ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY avg_revenue_per_customer DESC;