
-- Cleaning
UPDATE transactionbase SET Transaction_date = str_to_date(Transaction_date, '%d-%b-%y') ;

==================================================================================================================================================================================================

-- Q.1.Find customers whose average transaction value exceeds their customer segment's
--  average by at least 30%. Show the customer details and by what percentage they outperform
WITH customer_metrics AS (
    SELECT 
        c.Cust_ID,
        c.Customer_Segment,
        AVG(t.Transaction_Value) as customer_avg,
        AVG(AVG(t.Transaction_Value)) OVER (PARTITION BY c.Customer_Segment) as segment_avg
    FROM transactionbase t
    JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID
    JOIN customerbase c ON c.Cust_ID = cb.Cust_ID
    GROUP BY c.Cust_ID, c.Customer_Segment
)
SELECT 
    Cust_ID,
    Customer_Segment,
    customer_avg,
    segment_avg,
    ROUND(((customer_avg / segment_avg - 1) * 100), 2) as outperform_pct
FROM customer_metrics
WHERE customer_avg > segment_avg * 1.30;

==================================================================================================================================================================================================

-- Q.2. Rank customers by total transaction value within their segment
-- . Also show what percentile they fall into. Top 10% get VIP status."-- 
WITH rnktable as (
    SELECT 
        c.cust_id,
        c.customer_segment,
        SUM(t.transaction_value) as total_value,
        RANK() OVER (PARTITION BY c.Customer_Segment ORDER BY SUM(t.transaction_value) DESC) as segment_rank,
        ROUND(PERCENT_RANK() OVER (PARTITION BY c.Customer_Segment ORDER BY SUM(t.transaction_value) DESC)*100,2) as percentile_rank
    FROM transactionbase t
    JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID
    JOIN customerbase c ON c.Cust_ID = cb.Cust_ID
    GROUP BY c.Cust_ID, c.Customer_Segment
)
SELECT 
    *,
    CASE 
        WHEN percentile_rank <= 10.0 THEN 'VIP'  -- Top 10%!
        ELSE 'Regular'
    END as vip_status
FROM rnktable;

==================================================================================================================================================================================================

-- Q.3. Calculate monthly transaction totals and their growth rate compared to previous month.
--  Flag months with negative growth
WITH monthly_total as (
SELECT 
	MONTH(transaction_date) as mon,
   SUM(transaction_value) as total 
FROM transactionbase 
GROUP BY  mon
),
final_tab as(
SELECT 
	 *,
	 SUM(total) OVER(order by mon ROWS UNBOUNDED PRECEDING ) as monthly_total_rolling,
     LAG(total,1) OVER(order by mon) as prev_month,
     ((total - LAG(total,1)OVER(order BY mon ))/ LAG(total,1) OVER(order by mon))*100  as growth_rate
FROM monthly_total
)
SELECT *,
	CASE when growth_rate<0 then  '-ve' 
    WHEN growth_rate IS NULL then NULL
    ELSE   '+ve' end as flag 
FROM final_tab;

==================================================================================================================================================================================================

-- Q.4. For each transaction, show what number transaction this is for that customer (1st, 2nd, etc.) 
-- and the running average transaction value.

SELECT 
    c.cust_id,
    t.Transaction_ID,
    t.Transaction_Date,
    t.Credit_Card_ID,
    t.Transaction_Value,

    ROW_NUMBER() OVER (
        PARTITION BY t.Credit_Card_ID 
        ORDER BY t.Transaction_Date 
    ) as transaction_num,

    ROUND(AVG(t.Transaction_Value) OVER (
        PARTITION BY t.Credit_Card_ID  
        ORDER BY t.Transaction_Date    
        ROWS UNBOUNDED PRECEDING      
    ), 2) as running_avg
FROM transactionbase t
JOIN cardbase cb on cb.Card_Number=t.Credit_Card_ID
JOIN customerbase c on c.Cust_ID = cb.Cust_ID
ORDER BY t.Credit_Card_ID, t.Transaction_Date;

==================================================================================================================================================================================================
  
-- Q.5. For each customer, show how their total spending ranks within their age group (create age brackets: 18-25, 26-35, 36-45, 45+)

WITH cte1 as 
( SELECT 
	c.cust_id,
    c.age,
	SUM(t.transaction_value) as total_spending,
    CASE WHEN age BETWEEN 18 and 25 then '18-25'
    WHEN age between 26 and 35 then '26-35'
    WHEN AGE between 36 and 45 then '36-45'
    WHEN age > 45 then '>45' END as age_bracket
    
FROM transactionbase t 
JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID
JOIN customerbase c ON cb.cust_id= c.Cust_ID
GROUP BY c.cust_id,c.Age
ORDER BY c.age 
)
SELECT * , 
RANK() OVER(partition by age_bracket order by total_spending desc)  as ranking
FROM cte1;

==================================================================================================================================================================================================

-- Q.6. Classify customers into spending tiers (High/Medium/Low) based on total value, then show the distribution across customer segments.
WITH stage1 AS
(SELECT 
	c.cust_id,
    c.Customer_Segment,
    SUM(t.transaction_value) as total_spends,
    CASE WHEN SUM(t.transaction_value) BETWEEN 140000 AND 580000 THEN 'Low' 
    WHEN SUM(t.transaction_value) BETWEEN 580000 AND 1020000 THEN 'Medium'
    WHEN SUM(t.transaction_value) > 1020000 THEN 'High' END as Spending_lvl
FROM transactionbase t
JOIN cardbase cb on cb.Card_Number = t.Credit_Card_ID 
JOIN customerbase c on c.Cust_ID = cb.Cust_ID
GROUP BY c.Cust_ID,c.Customer_Segment
),
stage2 as 
(SELECT 
	customer_segment,
	SUM(CASE WHEN Spending_lvl = 'High' THEN 1 else 0 end ) as High_spenders,
    SUM(CASE WHEN Spending_lvl = 'Medium' THEN 1 else 0 end ) as Mid_spenders,
    SUM(CASE WHEN Spending_lvl = 'Low' THEN 1 else 0 end ) as Low_spenders
FROM stage1 GROUP BY customer_segment
)
SELECT * FROM stage2;

==================================================================================================================================================================================================
    
-- Q.7. Calculate average days between transactions for each customer. Flag those transacting more frequently than their segment's average
-- # nice and high quality question but i could not solve , took AI's help

WITH transaction_gaps AS (
    SELECT 
        c.cust_id,
        c.customer_segment,
        t.transaction_date,
        LAG(t.transaction_date) OVER (PARTITION BY c.cust_id ORDER BY t.transaction_date) as prev_date,
        DATEDIFF(t.transaction_date, LAG(t.transaction_date) OVER (PARTITION BY c.cust_id ORDER BY t.transaction_date)) as days_between
    FROM transactionbase t 
    JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID 
    JOIN customerbase c ON c.Cust_ID = cb.Cust_ID
),
customer_averages AS (
    SELECT 
        cust_id,
        customer_segment,
        AVG(days_between) as avg_days_between  -- Average per customer
    FROM transaction_gaps
    WHERE days_between IS NOT NULL  -- ← The fix! Filter the column that HAS nulls, not the calculated AVG
    GROUP BY cust_id, customer_segment
),
segment_averages AS (
    SELECT
        customer_segment,
        AVG(avg_days_between) as segment_avg_days  -- Average of customer averages
    FROM customer_averages
    GROUP BY customer_segment
)
SELECT 
    ca.cust_id,
    ca.customer_segment,
    ROUND(ca.avg_days_between, 2) as customer_avg_days,
    ROUND(sa.segment_avg_days, 2) as segment_avg_days,
    ROUND(ca.avg_days_between - sa.segment_avg_days, 2) as difference,
    CASE 
        WHEN ca.avg_days_between < sa.segment_avg_days THEN 'High_Frequency ⚡'
        WHEN ca.avg_days_between > sa.segment_avg_days THEN 'Low_Frequency 🐌'
        ELSE 'Normal'
    END as frequency_flag
FROM customer_averages ca
JOIN segment_averages sa ON ca.customer_segment = sa.customer_segment
ORDER BY ca.customer_segment, ca.avg_days_between;

==================================================================================================================================================================================================

-- Q.8. Compare each customer's first month spending vs last month spending. Classify as: Growing (last > first by 20%+), Stable (within 20%), Declining (last < first by 20%+). 
-- # Show distribution by customer segment
WITH customer_transactions AS (
    SELECT 
        c.cust_id,
        c.customer_segment,
        DATE_FORMAT(t.transaction_date, '%Y-%m') as year_mmonth,
        t.transaction_value
    FROM transactionbase t 
    JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID 
    JOIN customerbase c ON c.cust_id = cb.Cust_ID
),
customer_periods AS (
    SELECT 
        cust_id,
        customer_segment,
        MIN(year_mmonth) as first_month,
        MAX(year_mmonth) as last_month
    FROM customer_transactions
    GROUP BY cust_id, customer_segment
),
first_month_spending AS (
    SELECT 
        ct.cust_id,
        SUM(ct.transaction_value) as first_total
    FROM customer_transactions ct
    JOIN customer_periods cp ON ct.cust_id = cp.cust_id
    WHERE ct.year_mmonth = cp.first_month
    GROUP BY ct.cust_id
),
last_month_spending AS (
    SELECT 
        ct.cust_id,
        ct.customer_segment,
        SUM(ct.transaction_value) as last_total
    FROM customer_transactions ct
    JOIN customer_periods cp ON ct.cust_id = cp.cust_id
    WHERE ct.year_mmonth = cp.last_month
    GROUP BY ct.cust_id, ct.customer_segment
),
classified AS (
    SELECT 
        l.cust_id,
        l.customer_segment,
        f.first_total,
        l.last_total,
        CASE 
            WHEN l.last_total >= f.first_total * 1.20 THEN 'Growing'
            WHEN l.last_total <= f.first_total * 0.80 THEN 'Declining'
            ELSE 'Stable'
        END as growth_status
    FROM last_month_spending l
    JOIN first_month_spending f ON l.cust_id = f.cust_id
)
SELECT 
    customer_segment,
    SUM(CASE WHEN growth_status = 'Growing' THEN 1 ELSE 0 END) as growing_count,
    SUM(CASE WHEN growth_status = 'Stable' THEN 1 ELSE 0 END) as stable_count,
    SUM(CASE WHEN growth_status = 'Declining' THEN 1 ELSE 0 END) as declining_count,
    COUNT(*) as total_customers
FROM classified
GROUP BY customer_segment;

==================================================================================================================================================================================================

-- Q.9. Count total transactions per customer. Classify as: Occasional (1-5), Regular (6-15), Frequent (16-30), Power User (31+). Show distribution by customer segment
WITH total_transactionss as 
(SELECT 
	c.cust_id,
	c.customer_segment, 
    COUNT(t.transaction_id) as total_transactions
FROM transactionbase t JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID
JOIN customerbase c ON c.Cust_ID = cb.Cust_ID
group by c.cust_id , c.Customer_Segment
)
SELECT 
	customer_segment,
    CASE WHEN total_transactions BETWEEN 1 and 5 THEN 'Occasional' 
    WHEN total_transactions BETWEEN 6 and 15 THEN 'Regular'
    WHEN total_transactions BETWEEN 16 and 30 THEN 'Frequent'
    WHEN total_transactions  > 31 THEN 'Power User' END as classified_Usage
FROM total_transactionss
;

==================================================================================================================================================================================================

-- Q.10. Calculate transaction volume ratio (total transactions/credit limit).Categorize as: Light(<30%), Moderate(30-70%), Heavy(70-100%), Power User(>100%).
-- # Show distribution by card family
WITH utilization_init as 
(SELECT 
	c.cust_id,
    cb.Card_Family,
	cb.credit_limit,
   SUM(t.transaction_value) as total,
   ROUND((SUM(t.transaction_value)/cb.credit_limit )*100,2) as Customer_usage
FROM transactionbase t JOIN cardbase cb ON cb.Card_Number = t.Credit_Card_ID
JOIN customerbase c ON c.Cust_ID = cb.Cust_ID
GROUP BY c.cust_id,
    cb.Card_Family,
	cb.credit_limit
)
SELECT 
	card_family,
    SUM(case WHEN Customer_usage < 30 THEN 1 ELSE 0  END)  AS Low_usage,
    SUM(CASE WHEN Customer_usage <= 70 THEN 1 ELSE 0 END ) as Medium_Usage,
    SUM(CASE WHEN Customer_usage <= 100 THEN 1 ELSE 0 END ) as High_Usage,
    SUM(CASE WHEN Customer_usage > 100 THEN 1 ELSE 0 END) as Over_LimitChurner
FROM utilization_init
GROUP BY card_family

==================================================================================================================================================================================================
  
-- "Show cumulative transaction value by date. Mark when we hit 1M, 5M, and 10M milestones."

WITH totaltransaction as (
SELECT 
    SUM(transaction_value) OVER(order by transaction_date ROWS UNBOUNDED PRECEDING) as cumulative_total
FROM transactionbase
)
SELECT * ,
CASE WHEN cumulative_total = 1000000 THEN '1M'
WHEN cumulative_total = 5000000 THEN '5M'
WHEN cumulative_total = 10000000 THEN '10M' END AS milestones
FROM totaltransaction;

==================================================================================================================================================================================================
