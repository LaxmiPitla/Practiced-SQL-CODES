--- DATA ENGINEERING CONCEPTUAL QUESTIONS
---------------------------------------------------------------------DAY 5 
--------------------------------------QUESTION 50 (DEDUPLICATION)
---Write a query to keep only the latest record for each order_id based on updated_at.
WITH CTE AS (
select 
order_id , customer_id , order_date , order_status , updated_at
from orders
)
select * from (
select 
*,
ROW_NUMBER() over(partition by order_id order by updated_at desc ) as rn 
from CTE  )
where rn =1 ;
-------------------------------------------QUESTION 51 (INCREMENTAL LOAD)
--Write a query to identify records from source_orders
--that are new or have been updated compared with target_orders.
select order_id, customer_id, updated_at 
from source_orders s
left join target_orders t 
on s.order_id = t.order_id
where t.order_id is NULL or s.updated_at >t.updated_at
-------------------------QUESTION 52 Data Engineering: Data Quality
----Find all invalid orders where any of the following is true:
select 
order_id,customer_id,order_date,order_status
from orders
where order_id is null or customer_id is null or order_date is null or order_status
-------------------------QUESTION 53 Data Engineering: Reconciliation
--Find: source_sales, target_sales 
--1. Orders present in source but missing in target
select order_id, source_amount, target_amount 
from source_sales s 
left join target_sales t 
on s.order_id = t.order_id 
where t.order_id is null

--2. Orders present in target but missing in source
select order_id, source_amount, target_amount 
from target_sales t 
left join source_sales s 
on t.order_id = s.order_id 
where s.order_id is null

--3. Orders present in both but with different amounts
select order_id, source_amount, target_amount 
from target_sales t 
 join source_sales s 
on t.order_id = s.order_id 
where s.amount <>t.amount

--------------------------------QUESTION 55 Data Engineering: Duplicate Records
--Find all duplicate email addresses and show how many times each email appears.
select email, count(email) 
from customers 
group by email
having count(email)>1
------------------------------QUESTION 56 Data Engineering: Duplicate Detection
--Return only the latest record for each customer_id.
select * from (
select customer_id,
row_number() over(partition by customer_id order by created_date desc) as rn
from customers )t 
where rn = 1;
----------------------------Question 57 — Data Engineering: NULL Handling
--Calculate the total order amount for each customer, treating NULL order_amount as 0.
select customer_id, sum(order_amount) from (
select 
customer_id ,
case when order_amount is NULL THEN 0 
ELSE order_amount
end as order_amount
from customers
) t 
group by customer_id
----------------------------------------Q58 — Conditional Aggregation
--For each customer, calculate the number of Delivered orders and Cancelled orders.
select customer_id,
SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END ) as delivered_status,
SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END ) as cancelled_status
from orders
group by customer_id

-------------------------Question 59 — Data Engineering: ETL Validation/reconciliation
--Find orders where the customer_id or order_amount is different between source and target.
select order_id, s.customer_id,t.customer_id, s.amount,t.amount
from source_orders s 
full join  target_orders t 
on s.order_id =t.order_id 
where s.customer_id<>t.customer_id or 
s.amount<>t.amount
group by order_id
********************************************************************************************************************************
------------------------------------------------------------------------DAY 6
********************************************************************************************************************************
----------------------------------------------------QUESTION 60 Data Engineering: Incremental Data
--Write a query to extract only the records 
--that were newly created or updated after the last successful pipeline run.2026-08-26 23:59:59
select * from orders 
where updated_at >'2026-08-26 23:59:59' ;

-----------------Question 61 — Data Engineering: SCD Type 2
----A customer's city has changed from Hyderabad to Bangalore.
--Write a SQL query to expire the existing current record for that customer.


--------------------QUESTION 62 
--1. Existing customer whose city changed
select customer_id 
from source_customers s
join dim_customers d
on s.customer_id = d.customer_id
where s.city<>d.city 
--Identify existing customers whose  city not  changed.
select customer_id 
from source_customers s
join dim_customers d
on s.customer_id = d.customer_id
where s.city = d.city 
--- new customer
select customer_id 
from source_customers s
left join dim_customers d
on s.customer_id = d.customer_id
where d.customer_id id null 
------------------------------------------QUESTION 63 
----Write a query to identify existing customers whose city changed,
--considering only the current dimension record.
select 
s.customer_id,
s.city ,
d.city
from source_customers s
join dim_customers d
on s.customer_id = d.customer_id
where s.city <>d.city and is_current =1;
------------------------------------------------64
---Now that you've identified customer 101 as changed,
--write the SQL to expire the old/current record.
/*
Requirements:
is_current should become 0
end_date should become yesterday
Only customer 101's current record should be updated*/

UPDATE dim_customers 
SET 
is_current = 0
where customer_id = 101 
customer_name = 'Ravi'

INSERT INTO dim_customers
(
customer_id ,
customer_name,
'Pune',
1
)
select 
customer_id
customer_name
city
is_current
from source_customers
------------------------------------- QUESTION 65
----Write a query to find all customers whose city has changed,
--comparing the source with the current dimension record.

select s.customer_id,
s.city,d.city ,
is_current
from source_customers s
join dim_customers d
on s.customer_id =  s.customer_id
where s.city<>d.city

---------------------------------------QUESTION 66
update dim_customer 
set is_current = 0 
where customer_id = 101

INSERT into dim_customers
(
customer_id,
customer_name, 
city,
is_current 
)
select 
customer_id,
customer_name, 
city, 
1
from source_customers
---------------------------------------- QUESTION 67
/* 1. Expire the old records for customers whose city changed.
	2. Insert their new current versions.*/
update  d
set 
d.is_current = 0 
from dim_customers d
join source_customers s 
on d.customer_id = s.customer_id
where d.customer_id = s.customer_id and d.city <> s.city and is_current = 1
--2. 
Insert into dim_customers 
(
customer_id,
city,
is_current
)
select 
customer_id,
city,
1
from source_customers s 
join dim_customers d 
on d.customer_id = s.customer_id
where s.city<>d.city and is_current =0
-------------------------------------- QUESTION 68
---Write a query to find duplicate customer_ids in dim_customers.
select customer_id, count(customer_id) from dim_customers d
group by customer_id 
having count(customer_id)>1
-----------------------------------QUESTION 67
--Find customers who have more than one current record in dim_customers.
select customer_id, 
SUM(
CASE 
WHEN  is_current =1 THEN 1 
else 0 end )as counted
from dim_customers d
group by customer_id 
having SUM(
CASE 
WHEN  is_current =1 THEN 1 
else 0 end ) >1
---------------------------------QUESTION 68
--Find customers who have no current record in dim_customers.
select customer_id, 
SUM(
CASE 
WHEN  is_current =1 THEN 1 
else 0 end )as counted
from dim_customers d
group by customer_id 
having SUM(
CASE 
WHEN  is_current =1 THEN 1 
else 0 end ) =1
------------------------------------DAY 6 
------------------------------------QUESTION 69 
---Write a query to return the latest record for each customer based on updated_at.
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id 
               ORDER BY updated_at DESC
           ) AS rn
    FROM customer_updates
) t
WHERE rn = 1;
------------------------------------QUESTION 70 
--Return the second latest record for each customer.
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY updated_at DESC
           ) AS rn
    FROM customer_updates
) t
WHERE rn = 2;
-----------------------------------QUESTION 71
--Day 6 — Question 3: Deduplication
/*Write a query that removes the duplicate rows logically 
and returns only one copy of each duplicate, 
while keeping the latest record for each customer.*/
select * from (
select *,
row_number() over(partition by customer_id order by updated_at desc) as rn 
from 
customer_updates)t 
where rn = 1

-----------------------------------QUESTION 71
--Day 6 — Question 4: Source vs Target Reconciliation
--Orders where the amount is different between source and target.
select 
s.order_id, s.amount,t.amount
from source_orders s
full join target_orders t 
on s.order_id = t.order_id
where s.amount <>t.amount or s.amount is null or t.amount is null

--Orders that exist in source but not target.
select 
s.order_id, s.amount,t.amount
from source_orders s
left join target_orders t 
on s.order_id = t.order_id
where t.order_id is null
--Orders that exist in target but not source.
select 
s.order_id, s.amount,t.amount
from target_orders t 
left join source_orders s
on s.order_id = t.order_id
where s.order_id is null
----------------------------------------QUESTION 72
/*Write a query to fetch only the records 
that need to be picked up by the next incremental ETL load.
2026-08-27 00:00:00*/
select *
from orders
where updated_at > '2026-08-27 00:00:00'
----------------------------------------QUESTION 73
/*
You need to pick up records where:
--created_at is after the last load OR
--updated_at is after the last load
*/
select *
from orders
where updated_at > '2026-08-27 00:00:00' or created_at > '2026-08-27 00:00:00'
-----------------------------------Day 6 — Question 74: Incremental Load + Duplicates
/*Write a query to return only the latest version of each order that needs to be loaded.
2026-08-28 00:00:00
*/
select * from (
select * ,
row_number() over(partition by order_id order by updated_at desc) as rn
from orders)t 
where rn = 1 and updated_at >'2026-08-28 00:00:00'
--------------------------------Day 6 — Question 75 ETL reconciliation with counts.
--Write a query to find how many orders exist in the source but are missing from the target.
SELECT 
    COUNT(*) AS missing_orders
FROM source_orders s
LEFT JOIN target_orders t
    ON s.order_id = t.order_id
WHERE t.order_id IS NULL;
----------------------------------QUESTION 76
/* Write a query to find orders that exist in target_orders
but are missing from source_orders.

Return the number of missing orders.
*/
select 
count(*) as missing_orders 
from target_orders t 
left join source_orders s 
on t.order_id = s.order_id
where s.order_id is null ;
--------------------------QUESTION 77 Question 10: Amount Mismatch Count
/*Write a query to return the number of orders where the amount is different
between source and target.

Only count orders that exist in both tables.
*/
select
count(*) as nooforders
from source_orders s 
join target_orders t 
ON s.order_id = t.order_id
where s.amount <>t.amount
-------------------------QUESTION 78 Day 6 — Question 11: Find Duplicate Latest Records
/*Find customers who have more than one record with the same latest updated_at timestamp.
*/
WITH ranked AS
(
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY customer_id
               ORDER BY updated_at DESC
           ) AS rn
    FROM customer_updates
)
SELECT customer_id
FROM ranked
WHERE rn = 1
GROUP BY customer_id
HAVING COUNT(*) > 1;
--------------------------QUESTION 79 Question 12: Latest Record + Amount Validation
/* Find the latest record for each order_id, 
but return only orders whose latest amount is greater than 500.
*/
select * from (
select *, 
row_number() over(partition by order_id order by updated_at desc) as rn 
from 
orders)t
where rn = 1 and amount>500
------------------------QUESTION 80 Question 13: Latest Record Per Customer
/*Return all records that have the latest updated_at for each customer.

Because customer 102 has two records with the exact same latest timestamp,
both records should be returned.
*/
select * from (
select *,
DENSE_RANK() over(partition by customer_id order by updated_at desc ) as rn 
from customer_updates)t 
where rn = 1
-----------------------QUESTION 81 Question 14: Find Customers With Increasing Amount
/*Find the orders where 
the current order amount is greater than the customer's previous order amount.
*/
select * from (
select *,
lag(amount) over(partition by customer_id order by order_date) as previousamount
from customer_orders )t 
where amount>previousamount
------------------------QUESTION 82 
/*Find the customers whose latest order amount is the same as their previous order amount.
*/
select * from (
select *,
lag(amount) over(partition by customer_id order by updated_at) as previousamount
from orders )t 
where amount = previousamount











































