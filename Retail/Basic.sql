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

--6.Show employees hired within the last year along with their departments.

--7.Get the emails of customers with loyalty points above 200.
SELECT  email FROM Customers
WHERE loyalty_points>200;

--8.Retrieve orders placed in the current fiscal quarter.

--9.Find customers from cities starting with ‘S’.

--10.List products with stock levels between 20 and 100 units.

--11.Find all products whose names contain 'Pro' (using LIKE).

--12.Show customers who live in postal codes between 90000 and 95000.

--13.List products launched this year if a launch_date column is present.

--14.Retrieve customers with no recorded loyalty points (e.g., loyalty_points is null or 0).

--15.Display orders where status is 'Pending'.
