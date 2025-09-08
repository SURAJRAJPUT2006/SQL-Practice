--1.List top 3 customers residing in key sales regions with high loyalty .
SELECT customer_id , customer_name , city , MAX(loyalty_points) as HighLoyalty
FROM Customers 
group by customer_id , customer_name , city 
ORDER BY HighLoyalty DESC
Limit 3
;
 
--2.Retrieve the names and prices of products currently in stock more than 50 (stock > 50).
SELECT product_name, price , stock 
FROM Products 
WHERE stock > 50
ORDER BY stock 
;

--3.Find customers who joined the loyalty program within the last 6 months(Today is 2023-08-10).
SELECT customer_id,customer_name,join_date,loyalty_points 
FROM Customers
WHERE join_date >= date_add('2023-08-10', INTERVAL -6 MONTH)
;

--4.Get all products with a price higher than $100 in the Electronics category.
SELECT product_id, product_name as Electronic_product, price 
FROM Products
WHERE price >100 AND category = 'Electronics';

--5.Extract distinct product categories available in inventory.
SELECT DISTINCT category  FROM Products;

--6.Count total orders placed up to date.
SELECT COUNT(Order_id) as total_orders FROM Orders;

--7.Get the emails of customers with loyalty points above 200.
SELECT  email FROM Customers
WHERE loyalty_points>200;
  
--8.Retrieve orders placed in the current fiscal quarter.
SELECT 
    order_id,
    customer_id,
    order_date,
    total_amount,
    status,
    EXTRACT(QUARTER FROM order_date) AS calendar_quarter
FROM orders
WHERE order_date >= '2025-07-01' AND order_date < '2025-09-01';  

--9.Find customers from cities starting with ‘S’.
SELECT * FROM Customers 
WHERE city like 'S%';

--10.List products with stock levels between 30 and 100 units.
SELECT * FROM Products 
WHERE stock BETWEEN 30 AND 100;

--11.Find all products whose names contain 'rt' (using LIKE).
SELECT * FROM Products
WHERE product_name like '%rt%';

--12.Find all products in a specific category(e.g. electronic products only)
SELECT * FROM Products
WHERE category = 'Electronics';
 
--13.List all orders placed by a certain customer ID(e.g. customer_id =1 )
SELECT * FROM Orders 
WHERE customer_id = 1;

--14.Retrieve customers with no recorded loyalty points (e.g., loyalty_points is null or 0).
SELECT * FROM Customers
WHERE loyalty_points is null OR loyalty_points = 0

--15.Display orders where status is 'Pending'.
SELECT * FROM Orders 
WHERE status ='Pending';
