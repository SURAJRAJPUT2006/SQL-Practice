--'cleaning' 
SELECT * FROM cards_data WHERE card_brand NOT IN ('Visa', 'Mastercard', 'Discover', 'Amex');
UPDATE finance.cards_data SET card_brand = 'UNKNOWN' WHERE card_brand = "1577";
COMMIT;
--============================================================================================================================================================================================

-- Q1.Count total credit cards issued per card brand.
SELECT card_brand,COUNT(id) FROM cards_data
GROUP BY card_brand;
--============================================================================================================================================================================================

-- Q2.List card_types and count of cards for each.
SELECT  card_type , count(card_brand) FROM cards_data
GROUP BY card_type;
--============================================================================================================================================================================================

-- Q3.Find average, minimum, and maximum credit_limit by card_type.
SELECT card_type,
	AVG(CAST(REPLACE(credit_limit,'$','') AS DECIMAL(10, 2))) AS avg_credit_limit,
	MIN(CAST(REPLACE(credit_limit , '$','')AS DECIMAL(10, 2))) AS min_credit_limit,
	MAX(CAST(REPLACE(credit_limit,'$','') AS DECIMAL(10, 2))) AS max_credit_limit
FROM cards_data
GROUP BY card_type
LIMIT 3;
--============================================================================================================================================================================================

-- Q4.Count users with more than one credit card.
SELECT COUNT(id)  FROM users_data
WHERE num_credit_cards >1
;
--============================================================================================================================================================================================

-- Q5.Count transactions done with chip vs without.
SELECT
		COUNT( CASE WHEN has_chip ='YES' THEN 1 ELSE NULL END ) as yescount,
        COUNT( CASE WHEN has_chip ='NO'  THEN 1 ELSE NULL END ) as nocount
FROM cards_data;
--============================================================================================================================================================================================

-- Q6.List users with yearly_income less than 2 lakhs.
SELECT * FROM users_data
WHERE CAST(replace(yearly_income,'$','') AS decimal (10,2) )< 200000;
--============================================================================================================================================================================================

-- Q7.Show users whose credit_score is below 650.
SELECT * FROM users_data
WHERE credit_score < 650;
--============================================================================================================================================================================================

-- Q8.Find number of cards reported on dark web, grouped by card_brand.
SELECT card_brand,(card_on_dark_web) FROM cards_data
WHERE card_on_dark_web = 'Yes'
GROUP BY card_brand;
--============================================================================================================================================================================================

-- Q9.Count unique merchant_cities and states in transactions.
SELECT  merchant_city,merchant_state ,COUNT(merchant_city) as cities, COUNT(merchant_state) as states FROM transactions
GROUP BY merchant_state,merchant_city;
--============================================================================================================================================================================================

-- Q10.Report the top 5 merchant cities by transaction amount.
SELECT merchant_city, amount FROM transactions
ORDER BY amount DESC
LIMIT 5;
--============================================================================================================================================================================================

-- Q11.Find transactions with errors and their merchant details.
SELECT * FROM transactions
WHERE errors  not IN('');
--============================================================================================================================================================================================

-- Q12.List number of users per zip code.
SELECT COUNT(id) as usersperzip, substring_index(address,' ',1) as zipcode FROM users_data
GROUP BY zipcode;
--============================================================================================================================================================================================

-- Q13.Find clients above retirement_age who have made at least one transaction.
SELECT * FROM users_data
WHERE retirement_age < current_age;
--============================================================================================================================================================================================

-- Q14.Show total debt aggregated by merchant_city.
SELECT merchant_city, SUM(total_debt) FROM users_data
GROUP BY merchant_city;
--============================================================================================================================================================================================

-- Q15.List cards where year_pin_last_changed older than 5 years.
SELECT * FROM cards_data
WHERE year_pin_last_changed <= (2020-5);
--============================================================================================================================================================================================


