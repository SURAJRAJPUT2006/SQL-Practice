-- Cleaning
UPDATE transactionbase SET transaction_date =  STR_TO_DATE(transaction_date, '%d-%b-%y');   
--============================================================================================================================================================================================

-- Q1.List all customers who belong to the "Gold" or "Platinum" customer segment.
SELECT * FROM customerbase
WHERE Customer_Segment= 'Gold' or Customer_Segment= 'Platinum';
--============================================================================================================================================================================================

-- Q2.Find the total credit limit available for each card family.
SELECT card_family , SUM(credit_limit ) as totalcreditLimit FROM cardbase
GROUP BY Card_Family;
--============================================================================================================================================================================================

-- Q3.What is the average credit limit per card family?
SELECT card_family , avg(credit_limit) as avgcreditlimit FROM cardbase
GROUP BY Card_Family;
--============================================================================================================================================================================================

-- Q4.Calculate the average transaction value for each transaction segment.
SELECT transaction_segment, AVG(transaction_value) FROM transactionbase
GROUP BY Transaction_Segment;
--============================================================================================================================================================================================

-- Q5.Determine the number of customers in each age group bucket (<25, 25-40, >40).
SELECT
		COUNT(case when age <25 then 1 end) as "<25",
		COUNT(case when age between 25 and 40 then 1 end) as "25-40",
        COUNT(case when age > 40 then 1 end) as ">40"
FROM customerbase ;
--============================================================================================================================================================================================

-- Q6.List the top 5 customers by the number of transactions they have made.
SELECT Credit_Card_ID,COUNT(*) FROM transactionbase
GROUP BY Credit_Card_ID 
ORDER BY COUNT(*) desc
LIMIT 5;
--============================================================================================================================================================================================

-- Q7.List all customer segments and count of customers in each.
SELECT customer_segment , COUNT(customer_segment) FROM customerbase
GROUP BY Customer_Segment;
--============================================================================================================================================================================================

-- Q8.Who are the top 10 youngest customers?
SELECT * FROM customerbase
ORDER BY age
LIMIT 10;
--============================================================================================================================================================================================

-- Q9.List all transactions in the last month.
SELECT * FROM transactionbase
where Month(Transaction_Date)  = 11;
--============================================================================================================================================================================================

-- Q10.What’s the max, min, avg transaction value per segment?
SELECT transaction_segment,max(transaction_value), min(transaction_value), avg(transaction_value) FROM transactionbase
group by Transaction_Segment;
--============================================================================================================================================================================================

-- Q11.How many transactions had a value above 1,000?
SELECT COUNT(*) FROM transactionbase
WHERE transaction_value > 1000;
--============================================================================================================================================================================================

-- Q12.What’s the count of customers per customer vintage group?
SELECT Customer_vintage_group ,COUNT(Cust_id) FROM customerbase
GROUP BY Customer_Vintage_Group;
--============================================================================================================================================================================================

-- Q13.How many unique transaction segments are there?
SELECT COUNT( DISTINCt transaction_segment) as segments FROM transactionbase;
--============================================================================================================================================================================================

-- Q14.What’s the average age of all customers?
SELECT avg(age) as avgage FROM customerbase;
--============================================================================================================================================================================================

-- Q15.Retrieve all Platinum cards with a credit limit above 10,000.
SELECT Card_Family , Credit_Limit FROM cardbase
WHERE Credit_Limit > 10000;
--============================================================================================================================================================================================

-- Q16.Find all customers in the “Senior” (45+) age group.
SELECT *, CASE WHEN age > 45 THEN "SENIOR" END as "SENIOR" FROM customerbase
--============================================================================================================================================================================================

-- Q17.Which customer has the highest total credit limit?
(SELECT Cust_id ,SUM(credit_limit) as totalcredlim FROM cardbase 
GROUP BY cust_id
ORDER BY totalcredlim desc LIMIT 1)
--============================================================================================================================================================================================
