SELECT ship_mode, AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_delivery_days
FROM SuperStore_Orders
GROUP BY ship_mode
ORDER BY avg_delivery_days ASC;
--------------------------------------------------------------------------------------

SELECT sub_category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY sub_category
ORDER BY total_profit DESC;
---------------------------------------------------------------------------------------

SELECT TOP 10 state, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY state
ORDER BY total_sales DESC;
---------------------------------------------------------------------------------------

SELECT YEAR(order_date) AS year, SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY YEAR(order_date)
ORDER BY year;
----------------------------------------------------------------------------------------

SELECT 
    YEAR(order_date) AS year, 
    MONTH(order_date) AS month, 
    SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
------------------------------------------------------------------------------------------

SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month_year, 
    SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month_year;
---------------------------------------------------------------------------------------------

SELECT 
    discount, 
    COUNT(order_id) AS total_orders, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY discount
ORDER BY discount;
----------------------------------------------------------------------------------------------

SELECT 
    discount, 
    AVG(profit) AS avg_profit
FROM SuperStore_Orders
GROUP BY discount
ORDER BY discount;
-----------------------------------------------------------------------------------------------

SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount BETWEEN 0.01 AND 0.1 THEN 'Low Discount (0-10%)'
        WHEN discount BETWEEN 0.11 AND 0.3 THEN 'Medium Discount (11-30%)'
        ELSE 'High Discount (31% +)'
    END AS discount_category,
    COUNT(order_id) AS total_orders
FROM SuperStore_Orders
GROUP BY 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount BETWEEN 0.01 AND 0.1 THEN 'Low Discount (0-10%)'
        WHEN discount BETWEEN 0.11 AND 0.3 THEN 'Medium Discount (11-30%)'
        ELSE 'High Discount (31% +)'
    END
ORDER BY total_orders DESC;
---------------------------------------------------------------------------------------------------

SELECT 
    category, 
    discount, 
    COUNT(order_id) AS total_orders, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY category, discount
ORDER BY category, discount;
---------------------------------------------------------------------------------------------------

SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month_year, 
    AVG(discount) AS avg_discount, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM SuperStore_Orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month_year;
--------------------------------------------------------------------------------------------------

SELECT TOP 10
    customer_name, 
    COUNT(order_id) AS total_orders, 
    AVG(discount) AS avg_discount_used, 
    SUM(sales) AS total_spent
FROM SuperStore_Orders
GROUP BY customer_name
ORDER BY avg_discount_used DESC;
-----------------------------------------------------------------------------------------------------

SELECT customer_name, SUM(sales) AS total_spent
FROM SuperStore_Orders
GROUP BY customer_name
HAVING SUM(sales) > (
    SELECT AVG(total_spent) 
    FROM (
        SELECT customer_name, SUM(sales) AS total_spent
        FROM SuperStore_Orders
        GROUP BY customer_name
    ) AS customer_avg
)
ORDER BY total_spent DESC;
----------------------------------------------------------------------------------------------------

SELECT  TOP 10 product_name, SUM(sales) AS total_sales
FROM SuperStore_Orders
GROUP BY product_name
HAVING SUM(sales) > (
    SELECT AVG(total_sales) 
    FROM (
        SELECT product_name, SUM(sales) AS total_sales
        FROM SuperStore_Orders
        GROUP BY product_name
    ) AS product_avg
)
ORDER BY total_sales DESC;
------------------------------------------------------------------------------------------------------------

SELECT category, AVG(profit) AS avg_category_profit
FROM SuperStore_Orders
GROUP BY category
HAVING AVG(profit) > (
    SELECT AVG(profit) FROM SuperStore_Orders
)
ORDER BY avg_category_profit DESC;
------------------------------------------------------------------------------------------------------------

SELECT  TOP 10 customer_name, COUNT(order_id) AS total_orders
FROM SuperStore_Orders
GROUP BY customer_name
HAVING COUNT(order_id) > (
    SELECT AVG(total_orders)
    FROM (
        SELECT customer_name, COUNT(order_id) AS total_orders
        FROM SuperStore_Orders
        GROUP BY customer_name
    ) AS avg_orders
)
ORDER BY total_orders DESC;
------------------------------------------------------------------------------------------------------------------

WITH RankedCustomers AS (
    SELECT 
        region, 
        customer_name, 
        SUM(sales) AS total_sales,
        RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS sales_rank
    FROM SuperStore_Orders
    GROUP BY region, customer_name
)
SELECT region, customer_name, total_sales
FROM RankedCustomers
WHERE sales_rank <= 5
ORDER BY region, sales_rank;
------------------------------------------------------------------------------------------------------------------

WITH MonthlySales AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS month_year, 
        SUM(sales) AS total_sales
    FROM SuperStore_Orders
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT 
    month_year, 
    total_sales, 
    AVG(total_sales) OVER (ORDER BY month_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM MonthlySales
ORDER BY month_year;
------------------------------------------------------------------------------------------------------------------

WITH CustomerOrders AS (
    SELECT 
        customer_name, 
        COUNT(order_id) AS total_orders,
        DENSE_RANK() OVER (ORDER BY COUNT(order_id) DESC) AS order_rank
    FROM SuperStore_Orders
    GROUP BY customer_name
)
SELECT customer_name, total_orders
FROM CustomerOrders
WHERE order_rank <= 10
ORDER BY total_orders DESC;
----------------------------------------------------------------------------------------------------------------------

WITH ShippingDelays AS (
    SELECT 
        product_name, 
        ship_mode,
        AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_delivery_days,
        LAG(AVG(DATEDIFF(DAY, order_date, ship_date))) OVER (PARTITION BY ship_mode ORDER BY AVG(DATEDIFF(DAY, order_date, ship_date))) AS previous_avg
    FROM SuperStore_Orders
    GROUP BY product_name, ship_mode
)
SELECT product_name, ship_mode, avg_delivery_days, previous_avg
FROM ShippingDelays
WHERE avg_delivery_days > previous_avg
ORDER BY avg_delivery_days DESC;