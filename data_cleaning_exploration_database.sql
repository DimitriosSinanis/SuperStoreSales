UPDATE SuperStore_Orders
SET sales = REPLACE(sales, ',', '');

ALTER TABLE SuperStore_Orders 
ALTER COLUMN sales INT;
-----------------------------------------------------

UPDATE SuperStore_Orders
SET quantity = REPLACE(quantity, ',', '');

ALTER TABLE SuperStore_Orders 
ALTER COLUMN quantity INT;
-------------------------------------------------------

SELECT customer_name, COUNT(customer_name) AS orders
FROM SuperStore_Orders
GROUP BY customer_name 
ORDER BY orders DESC;
------------------------------------------------------------

SELECT customer_name, SUM(sales) AS money_spend
FROM SuperStore_Orders
GROUP BY customer_name
ORDER BY money_spend DESC;
-------------------------------------------------------------

SELECT SUM(sales) AS Sales, SUM(profit) AS Profit
FROM SuperStore_Orders 
---------------------------------------------------------------

SELECT TOP 10 product_name, COUNT(*) AS total_sales 
FROM SuperStore_Orders
GROUP BY product_name
ORDER BY total_sales DESC;
------------------------------------------------------------------

SELECT TOP 10 product_name, SUM(sales) AS total_sales 
FROM SuperStore_Orders
GROUP BY product_name
ORDER BY total_sales DESC;
------------------------------------------------------------------

SELECT sub_category, SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY sub_category
ORDER BY total_sales DESC;
---------------------------------------------------------------------

SELECT AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_delivery_days
FROM SuperStore_Orders;
-------------------------------------------------------------------------

SELECT TOP 10 state, SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY state
ORDER BY total_profit DESC;
--------------------------------------------------------------------------

SELECT MONTH(order_date) AS month, SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY MONTH(order_date)
ORDER BY total_sales DESC;
----------------------------------------------------------------------------

SELECT TOP 10 product_name, SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY product_name
ORDER BY total_profit DESC
-----------------------------------------------------------------------------
