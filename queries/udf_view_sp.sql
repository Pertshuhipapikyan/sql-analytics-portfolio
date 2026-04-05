--UDF

CREATE OR REPLACE FUNCTION analytics.fn_income_tax (
   p_quantity numeric,
   p_price numeric
)
RETURNS NUMERIC 
LANGUAGE sql
AS $$
    SELECT (p_quantity * p_price) * 0.2
$$;




SELECT 
 o.order_id,
 p.product_id,
 oi.quantity,
 p.price,
 analytics.fn_income_tax(oi.quantity, p.price) AS tax
FROM orders o
	JOIN analytics.order_items oi ON o.order_id=oi.order_id
	JOIN products p ON oi.product_id=p.product_id

--VIEW

CREATE OR REPLACE VIEW analytics.v_sales AS
SELECT 
    o.order_id,
    p.product_id,
    oi.quantity,
    p.price,
    oi.quantity * p.price AS revenue,
    analytics.fn_income_tax(oi.quantity, p.price) AS tax
FROM orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;


--STORED PROCEDURES

CREATE OR REPLACE PROCEDURE analytics.sp_sales_summary()
LANGUAGE sql
AS $$
    SELECT 
        order_id,
        SUM(revenue) AS total_revenue,
        SUM(tax) AS total_tax
    FROM analytics.v_sales
    GROUP BY order_id;
$$;

CALL analytics.sp_sales_summary();