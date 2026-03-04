

CREATE TABLE country(
  country_id INT PRIMARY KEY,
  country_name TEXT NOT NULL
);


CREATE TABLE regions(
  region_id INT PRIMARY KEY,
  region_name TEXT NOT NULL,
  country_id INT NOT NULL REFERENCES country(country_id)
);

CREATE TABLE city(
  city_id INT PRIMARY KEY,
  city_name TEXT NOT NULL,
  city_lat DECIMAL(9,6),
  city_lon DECIMAL(9,6),
  region_id INT NOT NULL REFERENCES regions(region_id)
);


CREATE TABLE customers(
  customer_id INT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  cutomer_email TEXT UNIQUE,
  city_id INT NOT NULL REFERENCES city( city_id),
  customer_age INT 
 );


CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name TEXT NOT NULL
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INT NOT NULL REFERENCES categories(category_id),
    unit_price INT
 ) ;


 CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    customer_id INT REFERENCES customers(customer_id),
    payment_method VARCHAR(50),
    order_status VARCHAR(50)
);

CREATE TABLE sale_Items (
    item_id INT PRIMARY KEY ,
    sale_id INT REFERENCES sales(sale_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    price_at_sale INT NOT NULL
);