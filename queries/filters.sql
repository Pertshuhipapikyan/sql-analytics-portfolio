SELECT
 city
FROM sales_analysis;

SELECT
  price
FROM sales_analysis
ORDER BY price DESC

SELECT
  category
FROM sales_analysis
GROUP BY category


--TASK 1

SELECT
  transaction_id,
  city,
  category,
  total_sales,
  CASE
     WHEN category = 'Electronics'
	     AND total_sales >= 400
	     AND discount < 0.10
		 AND city like '%East%'
     THEN 'High-value transactions'
	 
	 WHEN category IN ('Clothing' , 'Toys', 'Books' )
         AND total_sales BETWEEN 200 AND 399
	     AND discount > 0.10
	     AND city not like '%East'
	 THEN 'Mid-value transactions'
	 
	 ELSE 'Standard Transaction'
    END AS transaction_segment
	
FROM sales_analysis
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY total_sales DESC;

--TASK 2

SELECT
  category,
  SUM(total_sales) AS total_sales,
  COUNT(transaction_id) AS number_of_transactions,
  AVG(discount) AS average_discount
FROM sales_analysis  
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY category
HAVING SUM(total_sales) > 500;

--TASK 3

SELECT
   city,
   COUNT(transaction_id) AS number_of_transaction_id,
   CASE
       WHEN COUNT(transaction_id) >= 3 THEN 'High Activity'
	   WHEN COUNT(transaction_id) >= 2 THEN 'Medium Activity'
	   ELSE 'Low Activity'
	END AS activity_level
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING COUNT(transaction_id) > 0 ;


--TASK 4

SELECT
  category,
  COUNT(*) AS num_orders,
  SUM(total_sales) AS total_sales,
  AVG(discount) AS average_discount,
  CASE
      WHEN AVG(discount) > 0.20 THEN 'Discount-Heavy'
	  WHEN AVG(discount) > 0.10 THEN 'Moderate Discount'
      ELSE 'Low or No Discount'
  END AS discount_behavior
FROM sales_analysis
GROUP BY category
HAVING COUNT(*) is not NULL
ORDER BY average_discount DESC;
   
   