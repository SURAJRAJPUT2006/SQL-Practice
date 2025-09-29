
-- Cleaning
UPDATE transactionbase SET transaction_date =  STR_TO_DATE(transaction_date, '%d-%b-%y');   

-- Q1.What is the maximum transaction value each card family has processed?
SELECT card_family , max(transaction_value) as maxTransactionVal FROM transactionbase t
JOIN cardbase c
ON c.Card_Number = t.Credit_Card_ID
GROUP BY Card_Family;

-- Q2.Retrieve the number of cards per customer sorted in descending order.
SELECT COUNT(cb.Card_Number) as cnt , c.Cust_ID FROM cardbase cb
JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
GROUP BY c.cust_id
ORDER BY cnt DESC;

-- Q3.Find the earliest and latest transaction dates per customer.
SELECT
    cb.Cust_ID,
    MIN(tb.Transaction_Date) AS Earliest_Transaction,
    MAX(tb.Transaction_Date) AS Latest_Transaction
FROM
    transactionbase tb
    JOIN cardbase cdb ON tb.Credit_Card_ID = cdb.Card_Number
    JOIN customerbase cb ON cdb.Cust_ID = cb.Cust_ID
GROUP BY cb.cust_id
HAVING MONTH(Earliest_transaction) = 01 and MONTH(latest_transaction) = 12  

ORDER BY  MIN(tb.Transaction_Date) ,MAX(tb.Transaction_Date) desc;

-- Q4.Which card families have no associated transactions?
SELECT c.card_family FROM cardbase c
LEFT JOIN transactionbase t
ON t.Credit_Card_ID =c.Card_Number 
WHERE t.Credit_Card_ID IS NULL ;

-- Q5.List all transactions flagged as fraudulent and their corresponding customer.
SELECT c.* ,t.*, f.* FROM customerbase c
JOIN cardbase cb
ON cb.Cust_ID = c.Cust_ID
JOIN transactionbase t
ON t.Credit_Card_ID = cb.Card_Number
LEFT JOIN fraudbase f
ON f.Transaction_ID = t.Transaction_ID
WHERE f.Transaction_ID IS NOT NULL;

-- Q6.Show cards with the lowest and highest credit limit per customer segment.
SELECT c.customer_segment , MIN(cb.credit_limit) as lowest_cred_lim , MAX(cb.credit_limit) as Highest_cred_lim FROM cardbase cb
JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
GROUP BY c.Customer_Segment;

-- Q7.Identify customers whose average transaction value exceeds their card's credit limit.
SELECT c.Cust_ID,t.Transaction_Value , cb.credit_limit FROM cardbase cb
JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
JOIN transactionbase t
ON t.Credit_Card_ID = cb.Card_Number
GROUP BY c.Cust_ID ,t.Transaction_Value, cb.credit_limit
HAVING AVG(t.Transaction_Value) > cb.Credit_Limit;

-- Q8.Identify any cards that are not linked to any customer.
SELECT cb.* FROM cardbase cb
LEFT JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
WHERE c.Cust_ID  IS NULL;

-- Q9.Calculate the total transaction value per customer segment in the last 6 months.
SELECT c.customer_segment , sum(t.transaction_value) as total_transaction FROM customerbase c
JOIN cardbase cb
ON cb.Cust_ID = c.Cust_ID
JOIN transactionbase t
ON t.Credit_Card_ID = cb.Card_Number 
WHERE t.Transaction_Date = DATE_SUB("2016-12-31", INTERVAL 6 MONTH)
GROUP BY c.Customer_Segment;

-- Q10.List customers who have used more than one card family.
SELECT c.Cust_ID, c.Age, c.Customer_Segment, c.Customer_Vintage_Group FROM customerbase c
JOIN cardbase cb
ON cb.Cust_ID = c.Cust_ID
GROUP BY c.Cust_ID, c.Age, c.Customer_Segment, c.Customer_Vintage_Group
HAVING COUNT(DISTINCT cb.Card_Family)>1;

-- Q11.Find the card families with no transactions in the past month.
SELECT DISTINCT cb.Card_Family
FROM cardbase cb
LEFT JOIN transactionbase t
ON cb.Card_Number = t.Credit_Card_ID
AND MONTH(t.Transaction_Date) = 11 
WHERE  t.Transaction_ID IS NULL;

-- Q12.Get the minimum, maximum, and average transaction values for each customer segment.
SELECT c.customer_segment , MIN(t.transaction_value) , MAX(t.transaction_value) , avg(t.transaction_value) FROM customerbase c
JOIN cardbase cb
ON cb.Cust_ID = c.Cust_ID
JOIN transactionbase t
ON t.Credit_Card_ID  = cb.Card_Number
GROUP BY c.Customer_Segment;

-- Q13.Find cards with a credit limit above the average credit limit.
SELECT credit_limit as avgcredlim FROM cardbase 
WHERE Credit_Limit > (SELECT AVG(Credit_Limit) FROM cardbase);

-- Q14.Find customers who belong to the  vintage group with age 40  but have a credit limit below 10000
SELECT c.customer_vintage_group , c.age , cb.credit_limit FROM customerbase c
JOIN cardbase cb 
ON cb.Cust_ID = c.Cust_ID
WHERE age = 40 AND cb.Credit_Limit < 10000
GROUP BY c.Customer_vintage_group , c.age , cb.credit_limit;

-- Q15.Count distinct transaction segments and total transactions per customer segment.
SELECT DISTINCT  c.Customer_Segment, COUNT(DISTINCT t.Transaction_Segment) AS Distinct_Transaction_Segments, 
COUNT(t.Transaction_ID) AS Total_Transactions FROM transactionbase t
JOIN cardbase cb
ON cb.Card_Number = t.Credit_Card_ID
JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
GROUP by  c.customer_segment;

-- Q16.Calculate the monthly average transaction value per card family for the last 12 months.
SELECT cb.card_family , MONTH(t.transaction_date) as months , avg(t.transaction_value) as avg_transactions FROM transactionbase t
JOIN cardbase cb
ON cb.Card_Number = t.Credit_Card_ID
JOIN customerbase c
ON c.Cust_ID = cb.Cust_ID
GROUP BY cb.card_family  , months
ORDER BY months , cb.Card_Family , avg_transactions DESC;




