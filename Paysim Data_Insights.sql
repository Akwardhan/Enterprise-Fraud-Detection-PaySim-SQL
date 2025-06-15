-- Exploratory Data Analysis

--1. How many transactions are there in total?
-- This gives us a baseline — every percentage and insight will be based on this.
select count(*) as total_transactions from paysim_working

--2. If you're a fraud team at a fintech company, you must know
--   Which transaction types are being used the most? Are fraudsters targeting specific ones?
select 
	transactions_type,
	count (*) as total_count,
	ROUND(100.0* count(*)/(Select count(*) from paysim_working),2) as percentage
from paysim_working
Group By transactions_type
order by total_count DESC;

-- 3. How Many Fraud Transactions Happened?
-- How many transactions were marked as fraud?
--What is the overall fraud rate in the system?

select 
count(*) as total_frauds,
ROUND(100.0* Count(*) /(select count(*) from paysim_working),4) as fraud_percentage
from paysim_working
where "isFraud" = 1;

-- 4. Which types of transactions are more likely to be fraudulent?”
-- This helps us identify:
   -- High-risk transaction types (e.g., TRANSFER, CASH_OUT)
   --Safe transaction types (e.g., PAYMENT, DEBIT)

 select 
 transactions_type,
 count(*) as total_txns,
 sum(CASE when "isFraud" = 1 then 1
 ELSE 0
 END) as fraud_txns,
round(100.0* sum(case when "isFraud" = 1 then 1 else 0 END)/ count(*),4) as fraud_rate_pct
from paysim_working
group by transactions_type
order by fraud_txns;
 
--5. How much money was involved in fraudulent transactions? And how does that compare across 
  -- transaction types?

select
transactions_type,
count(*) as fraud_count,
Round(sum(amount),2) as total_fraud_amount,
Round(avg(amount),2) as avg_fraud_amount
from paysim_working
where "isFraud" = 1
group by transactions_type
order by total_fraud_amount DESC;

--6.Determine who is initiating fraud — customers or merchants — to identify risky users
-- segments and supports better KYC (Know Your Customer) & fraud prevention strategies.

Select 
LEFT("nameOrig",1) as sender_type,
count(*) as fraud_count
from paysim_working
where "isFraud" = 1
group by sender_type;

--7. Understand when frauds are happening the most, by analyzing hourly trends —
--   to help detect fraud faster and design real-time fraud alert systems.
-- Fraud Count by Hour of the Day

SELECT 
(step % 24) as hour_of_day,
count(*) as fraud_count
from paysim_working
where "isFraud" = 1
group by hour_of_day;

select 
CASE 
WHEN (step % 24) BETWEEN 0 AND 5 THEN '0-5 (Early Morning)'
when (step % 24) between 6 and 11 then '0-6 (Morning)'
when (step % 24) between 12 and 17 then '11-16 (Afternoon)'
when (step % 24) between 18 and 23 then '18-23 (Evening)'
END as time_block,
count(*) as fraud_count
from paysim_working
where "isFraud" = 1
group by time_block
order by time_block;

--8. User-Level Risk Analysis: Fraud by Sender & Receiver
-- Step 8A: Fraud by Sender (nameOrig)
-- Step 8B: Fraud by Receiver (nameDest)
-- Step 8A
select 
"nameOrig" as senders_account,
count(*) as total_fraud_txns,
sum(amount) as total_fraud_amt,
sum(CASE WHEN is_suspicious THEN 1 ELSE 0 END) as suspicous_fraud_count,
sum(CASE When is_zero_balance THEN 1 ELSE 0 END) as zero_balance_fraud_count	
from paysim_working
where "isFraud" = 1
group by "nameOrig"
ORDER BY total_fraud_amt DESC
Limit 10;

-- STEP 8B
select
"nameDest" as receivers_account,
count(*) as total_fraud_txns,
sum(amount) as total_fraud_amt,
sum(CASE WHEN is_suspicious THEN 1 ELSE 0 END) as suspicious_fraud_count,
sum(CASE WHEN is_zero_balance THEN 1 ELSE 0 END) as zero_balance_fraud_count
from paysim_working
where "isFraud" = 1
group by receivers_account
order by total_fraud_amt DESC
LIMIT 10;

-- 9 Total Fraud Amount by Hour
-- Find which hours of the day see the highest total fraud amount

select 
CASE 
WHEN (step % 24) BETWEEN 0 AND 5 Then '0-5 (Early Morning)'
when (step % 24) BETWEEN 6 AND 11 then '6-11(Morning)'
when (step % 24) BETWEEN 12 AND 17 then '12-17 (Afternoon)'
when (step % 24) Between 18 AND 23 THEN '18-23 (Evening)'
END as time_block,
count(*) as total_fraud,
round(sum(amount),2) as total_fraud_amt
from paysim_working
where "isFraud" = 1
group by time_block
order by total_fraud_amt DESC;

-- Final EDA: Top-Risk Fraud Profile
-- gives us a priority list of transactions that are both high-risk 
-- and rule-breaking — perfect for fraud prevention systems.
select 
transactions_type,
count(*) as total_fraud,
ROUND(sum(amount),2) as total_fraud_amt,
ROUND(avg(amount),2) as avg_fraud_amt
from paysim_working
where "isFraud" = 1	
and amount >= 1000000
and is_suspicious = TRUE or is_zero_balance = TRUE
AND transactions_type IN ('TRANSFER', 'CASH_OUT')s
group by transactions_type 
order by total_fraud_amt desc;
