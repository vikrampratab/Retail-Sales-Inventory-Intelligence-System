
--CREATING SCHEMA
CREATE SCHEMA retail;





--CREATING TABLE 1 @CUSTOMERS
CREATE TABLE retail.customers(
customer_id INT,
first_name VARCHAR(50),
last_name VARCHAR(50),
phone VARCHAR(20),
email VARCHAR(100),
street VARCHAR(100),
city VARCHAR(50),
state VARCHAR(50),
zip_code VARCHAR(10));

--CHECKING TABLE 1 @CUSTOMERS
SELECT * FROM retail.customers
LIMIT 10;




--CREATING TABLE 2 @ORDERS
CREATE TABLE retail.orders(
order_id INT,
customer_id INT,
order_status INT,
order_date DATE,
required_date DATE,
shipped_date DATE,
store_id INT,
staff_id INT
);
-- CHECKING TABLE 2 @ORDERS
SELECT * FROM retail.orders
LIMIT 10;



--CREATING TABLE 3 @order_ITEMS
CREATE TABLE retail.order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price NUMERIC(10,2),
    discount NUMERIC(4,2)
);

--CHECKING TABLE 3 @order_ITEMS
SELECT * FROM retail.order_items
LIMIT 10;





--CREATING TABLE 4 @PRODUCTS
CREATE TABLE retail.products (
product_id INT,
product_name VARCHAR(255),
brand_id INT,
category_id INT,
model_year INT,
list_price NUMERIC(10,2)
);

--CHECKING TABLE 4 @PRODUCTS
SELECT * FROM retail.products
LIMIT 10;




--CREATING TABLE 5 @BRANDS
CREATE TABLE retail.brands(
brand_id INT,
brand_name VARCHAR(100)
);
--CHECKING TABLE 5 @BRANDS
SELECT * FROM retail.brands
LIMIT 10;







--CREATING TABLE 6 @CATEGORIES
CREATE TABLE retail.categories(
category_id INT,
category_name VARCHAR(100)
);
--CHECKING TABLE 6 @CATEGORIES
SELECT * FROM retail.categories
LIMIT 10;





--CREATING TABLE 7 @STORES
CREATE TABLE retail.stores (
    store_id TEXT,
    store_name TEXT,
    phone TEXT,
    email TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);
--CHECKING TABLE 7 @STORES
SELECT * FROM retail.stores
LIMIT 10;





--CREATING TABLE 8 @STAFFS
CREATE TABLE retail.staffs (
staff_id INT,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
phone VARCHAR(20),
active INT,
store_id INT,
manager_id INT
);
--CHECKING TABLE 8 @STAFFS
SELECT * FROM retail.staffs
LIMIT 10;




--CREATING TABLE 9 @stocks
CREATE TABLE retail.stocks (
store_id INT,
product_id INT,
quantity INT
);
--CHECKING TABLE 9 @STOCKS
SELECT * FROM retail.stocks
LIMIT 10;










---------------------TOTAL REVINEW-----------------------------
SELECT 
ROUND(SUM(quantity * list_price * (1-discount)),2) AS total_revenue
FROM retail.order_items;

----------------------TOP SELLING PRODUCTS-------------------------
SELECT 
p.product_name,
SUM(oi.quantity) AS total_quantity
FROM retail.order_items oi
JOIN retail.products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;



--------------------------------HIGHEST REVINEW PRODUCTS---------------
SELECT 
p.product_name,
ROUND(
SUM(oi.quantity * oi.list_price * (1-oi.discount)),2
) AS revenue
FROM retail.order_items oi
JOIN retail.products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;




----------------------MONTHELY SALES TRENDS-----------------------------
SELECT 
EXTRACT(YEAR FROM o.order_date) AS year,
EXTRACT(MONTH FROM o.order_date) AS month,
ROUND(
SUM(oi.quantity * oi.list_price * (1-oi.discount)),2
) AS sales
FROM retail.orders o
JOIN retail.order_items oi
ON o.order_id = oi.order_id
GROUP BY year, month
ORDER BY year, month;



---------------------------BEST CUSTOMERS---------------------------------------------
SELECT 
c.first_name,
c.last_name,
COUNT(o.order_id) AS total_orders
FROM retail.customers c
JOIN retail.orders o
ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_orders DESC
LIMIT 10;



-----------------------STORE WISE REVENUE-------------------------------------------------------
SELECT 
o.store_id,
ROUND(
SUM(oi.quantity * oi.list_price * (1-oi.discount)),2
) AS revenue
FROM retail.orders o
JOIN retail.order_items oi
ON o.order_id = oi.order_id
GROUP BY o.store_id
ORDER BY revenue DESC;




--------------------------------CATEGORY-WISE REVENUE----------------------------
SELECT 
c.category_name,
ROUND(
SUM(oi.quantity * oi.list_price * (1-oi.discount)),2
) AS revenue
FROM retail.order_items oi
JOIN retail.products p
ON oi.product_id = p.product_id
JOIN retail.categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;

------------------------------BRAND-WISE SALES---------------------------

SELECT 
b.brand_name,
SUM(oi.quantity) AS total_sales
FROM retail.order_items oi
JOIN retail.products p
ON oi.product_id = p.product_id
JOIN retail.brands b
ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_sales DESC;



----------------------------STAFF PERFORMANCE------------------------------------
SELECT 
s.first_name,
s.last_name,
COUNT(o.order_id) AS orders_handled
FROM retail.staffs s
JOIN retail.orders o
ON s.staff_id = o.staff_id
GROUP BY s.first_name, s.last_name
ORDER BY orders_handled DESC;



----------------------LOW STOCKS PRODUCTS-------------------------------------------
SELECT 
product_id,
quantity
FROM retail.stocks
ORDER BY quantity ASC
LIMIT 10;

--==--==--==--==--==--==--==--==END==--==--==--==--==--==--==--==--==--==--==--==--==--==--









