--Total Rows
SELECT 
  COUNT(*) 
FROM analytics._stg_rockbuster;

--Distinct Customers
SELECT 
  COUNT(DISTINCT customer_email)
FROM analytics._stg_rockbuster;


--Distinct Films
SELECT 
  COUNT(DISTINCT title)
FROM analytics._stg_rockbuster;


--Distinct Actors
SELECT 
  COUNT(DISTINCT actor_first_name || actor_last_name)
FROM analytics._stg_rockbuster;

