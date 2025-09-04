-- Problem 1: Calculate total revenue per product category exceeding 5000 in 2025

SELECT p.category, SUM(p.price * o.quantity) AS total_revenue
FROM Products AS p
JOIN Orders AS o ON p.product_id = o.product_id
WHERE YEAR(o.order_date) = 2025
GROUP BY p.category
HAVING SUM(p.price * o.quantity) > 5000
ORDER BY total_revenue DESC;
