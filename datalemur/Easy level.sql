/*===========================EASY TYPE==============================================*/
/1. *Histogram of tweets SQL question */

select tweet_bucket, count(tweet_bucket) as users_num
from
(
SELECT user_id,count(tweet_id) as tweet_bucket
FROM tweets
where date_part('year',tweet_date) = 2022
group by user_id
) as temp 
group by tweet_bucket ;
/*2. =======================DATA SCIENCE SKILLS ========================================*/

SELECT  candidate_id
FROM candidates
where  skill in('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3;

/*3. ============================Page With No Likes=============================*/
SELECT  p.page_id FROM pages as p
left join  page_likes as s
on p.page_id = s.page_id
where s.page_id is NULL
order by p.page_id ASC 
;

/*4. ===========================UNFINISHED PARTS=============================*/
SELECT part, assembly_step
FROM parts_assembly
where finish_date is NULL;

/*5. ===================Laptop vs. Mobile Viewership (NEWYORK TIMES)============================*/
WITH cte_laptop AS (
    SELECT * FROM viewership WHERE device_type = 'laptop'
),
cte_mobile AS (
    SELECT * FROM viewership WHERE device_type IN ('phone', 'tablet')
)
SELECT
    (SELECT COUNT(*) FROM cte_laptop) AS laptop_views,
    (SELECT COUNT(*) FROM cte_mobile) AS mobile_views;

/*6. ====================Average Post Hiatus (Part 1)========================*/

SELECT user_id, 
DATEDIFF(max(post_date),min(post_date)) as days_between
FROM posts
where year(post_date)= 2021
group by user_id
having count(post_id)>=2;
/*7. =========================Teams Power Users==============================================*/

SELECT sender_id,
count(message_id)
FROM messages
where  EXTRACT(year from sent_date)= 2022 AND EXTRACT (MONTH from sent_date) =8
group by sender_id
order by count(message_id) DESC
limit 2;
/*8. =========================Duplicate Job Listings===============================================*/

SELECT count(*)
from 
(SELECT company_id
FROM job_listings
group by company_id
having count(job_id)>1)as t

/*9. =============================Cities With Completed Trades===========================================*/

SELECT u.city ,
count(t.status) FROM trades as t
left join users as u 
on t.user_id = u.user_id
where t.status = 'Completed' 
group by u.city 
order by  count(t.status) desc 
limit 3;

/*10. =============================Average Review Ratings==============================================*/

SELECT EXTRACT(month from submit_date) as MONTH,
product_id, round(avg(stars),2)
FROM reviews
group by EXTRACT(month from submit_date), product_id
order by EXTRACT(month from submit_date),product_id;

/*11. =========================WELL Paid employees=========================================*/
select 
emp.employee_id,
emp.name 
from employee emp
join employee mgr
on  emp.manager_id = mgr.employee_id
where emp.salary>mgr.salary;
/* 12. ======================APP CLICK THROUGH RATE (CTR)========================================================*/

select 
app_id,
round(100.0* max(count) FILTER (where event_type ='click')/
max(count) FILTER (where event_type ='impression'),2) AS ctr
from
(
SELECT 
app_id,
event_type,
count(event_type)
FROM events
where EXTRACT(year from timestamp) = 2022
group by event_type,app_id
) t
group by app_id;
/* 13. ==========================Second Day Confirmation===========================================================*/

SELECT e.user_id
FROM emails e 
inner join texts t 
on e.email_id = t.email_id  
where signup_action = 'Confirmed' AND 
(EXTRACT(day from t.action_date)- EXTRACT(day from e.signup_date)) = 1 ;

/* 14. =============================Final Account Balance  PayPal SQL Interview Question====================================*/

SELECT account_id,
CAST(SUM(CASE
WHEN transaction_type = 'Deposit' THEN amount
WHEN transaction_type = 'Withdrawal' THEN -amount
ELSE 0
END) AS DECIMAL)
AS final_balance
FROM transactions
group by account_id;

/* 15. =============================Pharmacy Analytics (Part 1)CVS Health SQL Interview Question=====================================*/
SELECT drug,
total_sales-cogs as total_profit 
 FROM pharmacy_sales
order by total_sales-cogs desc 
limit  3;

/*=========================================================================================*/




/*=========================================Pharmacy Analytics (Part 3) - CVS Health SQL Interview Question====================*/

SELECT manufacturer,
CONCAT('$',ROUND(sum(total_sales)/1000000,0) , ' million') as sale 
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc,manufacturer;

/*==============================Cards Issued Difference -- JPMorgan SQL Interview Question===========================================*/

SELECT card_name ,
max(issued_amount)-min(issued_amount) FROM monthly_cards_issued
group by card_name
order by max(issued_amount)-min(issued_amount) desc;

/*===========================================Compressed Mean - Alibaba SQL Interview Question=============================================================*/
SELECT 
  ROUND(
    SUM(CAST(item_count AS DECIMAL)*order_occurrences)
    /SUM(order_occurrences)
  ,1) AS mean
FROM items_per_order;

/*=======================================Patient Support Analysis (Part 1) UnitedHealth SQL Interview Question===================================================*/

select count(*) from
(
SELECT policy_holder_id,
count(case_id)
FROM callers
group by policy_holder_id
having count(case_id)>=3)t

/*=====================================================================*/
