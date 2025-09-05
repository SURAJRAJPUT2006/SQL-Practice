
Retail Domain – SELECT Queries Practice
Overview
This folder contains SQL queries focused on the SELECT keyword applied to a simulated retail business dataset. The dataset models core retail operations: customer management, product catalog, and order processing.

The purpose is to practice foundational data retrieval and filtering operations common in daily analyst tasks within retail or e-commerce domains.

Dataset Description
The dataset consists of three tables with the following structures:

customers
Column	Description
customer_id	Unique identifier for each customer
customer_name	Full name of the customer
city	City where the customer resides
country	Country of the customer
email	Contact email of the customer
loyalty_points	Loyalty program points accumulated by customer
join_date	Date the customer joined the loyalty program
orders
Column	Description
order_id	Unique order identifier
customer_id	Identifier of the customer who placed the order
order_date	Date when the order was placed
total_amount	Total dollar amount of the order
status	Status of the order (e.g., Completed, Pending)
products
Column	Description
product_id	Unique product identifier
product_name	Name of the product
category	Product category (e.g., Electronics, Apparel)
price	Unit price of the product
stock	Number of units currently in stock
Business Context
Retail analysts use these tables daily to answer business questions such as:

Who are the most valuable and active customers?

Which products are in demand or need restocking?

How are sales performing this quarter?

What orders require follow-up or attention?

This exercise set enables practice around these critical questions, improving SQL SELECT expertise in a realistic setting.

How to Use
Load the provided CSV files (customers.csv, orders.csv, products.csv) into your SQL database environment with the respective table names.

Open and read the SQL query files in this folder, focusing on queries using the SELECT statement.

Run the queries against the loaded data to see results.

Review inline comments in queries for explanations of logic and business purpose.

Modify and experiment with queries to deepen understanding.

When ready, submit your query solutions for review and feedback.

Insights Expected
By running these queries you will:

Identify active and high-loyalty customers for retention campaigns.

Filter and sort high-value orders for sales prioritization.

Extract product and order information for inventory management.

Practice real-world syntax for data filtering and retrieval with SQL SELECT.

