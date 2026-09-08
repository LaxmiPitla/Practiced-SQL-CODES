---------------------------Day 8 — Question 1: Gaps & Islands
---Find the longest consecutive login streak for each user.
WITH CTE1 AS
(
    SELECT *,
           LAG(login_date) OVER (
               PARTITION BY user_id
               ORDER BY login_date
           ) AS previous_date
    FROM user_logins
),
CTE2 AS
(
    SELECT *,
           SUM(
               CASE
                   WHEN previous_date IS NULL
                        OR DATEDIFF(day, previous_date, login_date) > 1
                   THEN 1
                   ELSE 0
               END
           ) OVER (
               PARTITION BY user_id
               ORDER BY login_date
           ) AS streak_group
    FROM CTE1
),
CTE3 AS
(
    SELECT
        user_id,
        streak_group,
        COUNT(*) AS streak_length
    FROM CTE2
    GROUP BY user_id, streak_group
),
CTE4 AS
(
    SELECT
        user_id,
        MAX(streak_length) AS longest_streak
    FROM CTE3
    GROUP BY user_id
)
SELECT *
FROM CTE4;
-------------------------------------------------------------------
-----------------------------------------------------------------
/* Let's move to a completely different product-company concept: Funnel Analysis. 🔥

-----Day 8 — Question 2: User Conversion Funnel*/
----------Find how many unique users reached each stage.
SELECT
    COUNT(DISTINCT CASE
        WHEN event_name = 'signup' THEN user_id
    END) AS signup_users,

    COUNT(DISTINCT CASE
        WHEN event_name = 'view_product' THEN user_id
    END) AS view_product_users,

    COUNT(DISTINCT CASE
        WHEN event_name = 'add_to_cart' THEN user_id
    END) AS add_to_cart_users,

    COUNT(DISTINCT CASE
        WHEN event_name = 'purchase' THEN user_id
    END) AS purchase_users
FROM events;
----------------------------------QUESTION 3: 
---Calculate the signup-to-purchase conversion rate.
WITH CTE AS 
(
select 
count( distinct CASE WHEN event_name = 'signup' THEN user_id  end )as signupusers,
count( distinct CASE WHEN event_name = 'purchase' THEN user_id  end )as purchase
from events
)
select *,
CAST (purchase as decimal(10,2))/signupusers * 100 as conversionrate 
from CTE 
-------------------------------------QUESTION 4 :
----Sequence of events 
SELECT DISTINCT s.user_id
FROM events s
JOIN events v
    ON s.user_id = v.user_id
JOIN events p
    ON s.user_id = p.user_id
WHERE s.event_name = 'signup'
  AND v.event_name = 'view_product'
  AND p.event_name = 'purchase'
  AND s.event_time < v.event_time
  AND v.event_time < p.event_time;
-------------------------------QUESTION 5 : Conversion within 24 hours 
/*
Your task:::::::
Write a query to find the number of users who:
Have a signup
Have a purchase
Purchase happens after signup
Purchase happens within 24 hours
*/
select user_id
from events s
join events p 
on s.user_id = p.user_id
where s.event_name = 'signup'
    and p.event_name = 'purchase'
    and s.event_time< p.event_time
    and datediff(hour,s.event_time,p.event_time) <= 24 
------------------------------------------QUESTION 6 
---Left join, ANTI JOIN, NOT exits 
select c.customer_id, o.order_id, p.payment_id
from 
customers c 
left join orders o 
on c.customer_id = o.customer_id
left join payments p
on o.order_id = p.order_id 
where p.payment_id is null
-----------------------------------QUESTION 7 :
--Calculate the number of unique users at each stage 
--and the drop-off between consecutive stages.
WITH CTE as (
select 
sum(case when event_name = 'singup' then 1 else end ) as singup,
sum(case when event_name = 'view_product' then 1 else end ) as viewedproduct,
sum(case when event_name = 'add_to_cart' then 1 else end ) as addtocart,
sum(case when event_name = 'purchase' then 1 else end ) as purchase,
from events )











