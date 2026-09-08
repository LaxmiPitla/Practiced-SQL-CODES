/*
							Day 7 — New Topics
	Gaps and Islands
	Consecutive dates
	Top N per group — advanced
	Running balances
	Self joins
	Recursive CTE basics
	SQL performance / query optimization
*/
-----------------------------QUESTION 1 : Consecutive Orders
--Find customers who placed orders on 3 or more consecutive days.
--Hint: This is a classic gaps-and-islands problem.
--You can solve it using LAG() or ROW_NUMBER().
WITH cte1 AS
(
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS prev_date
    FROM customer_orders
),
cte2 AS
(
    SELECT
        customer_id,
        order_date,
        prev_date,
        CASE
            WHEN prev_date IS NULL
                 OR DATEDIFF(day, prev_date, order_date) > 1
            THEN 1
            ELSE 0
        END AS new_group
    FROM cte1
),
cte3 AS
(
    SELECT
        customer_id,
        order_date,
        SUM(new_group) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS grp
    FROM cte2
),
cte4 AS
(
    SELECT
        customer_id,
        grp,
        COUNT(*) AS consecutive_days
    FROM cte3
    GROUP BY customer_id, grp
)
SELECT
    customer_id,
    consecutive_days
FROM cte4
WHERE consecutive_days >= 3;
---------------------------------QUESTION 2 :
--Find every record where an employee's salary changed compared with their previous salary.
select * from (
select * ,
lag(salary) over (partition by employee_id order by effective_date ) as previous
from employee_salary)t 
where salary<>previous
---------------------------------QUESTION 3 : 
/*For each customer, calculate:

1.Current order amount
2.Previous order amount
3.Difference between current and previous order
*/
select *,
previous- salary as difference 
from(
select *,
lag(amount) over(partition by customer_id order by order_date ) as previous
from customer_orders )t
group by customer_id
------------------------------------QUESTION 4 :
--: Find the largest order for each customer.
select * from 
(select 
*,
row_number() over(partion by customer_id order by amount desc ) as rn 
from orders)t 
where rn = 1
---------------------------------QUESTION 5 :
--Calculate the running total of amount for each customer, ordered by order_date.
select *,
sum(amount) over(partition by customer_id order by order_date) as running_total
from orders

-----------------------------------QUESTION 6 :
---Find the top 2 customers based on total amount spent.
SELECT TOP 2
       customer_id,
       SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id
ORDER BY SUM(amount) DESC;
-----------------------------------QUESTION 7 : 
--Find the top 2 customers based on total spending,
--but return ALL customers tied at the 2nd position.
select * from(
select *,
dense_rank() over( order by total_amount desc) as rn 
from (
SELECT
       customer_id,
       SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id
ORDER BY SUM(amount) DESC)t)p
where rn<=2
;
-----------------------------------QUESTION 8 : 
--Find each employee's:
/*employee_name
manager_name
salary*/
select e.employee_name, 
m.manager_name,
e.salary
from employee e 
left join employee m 
on e.manager_id = m.employee_id
---------------------------------QUESTION 9: 
---Return only the latest record for each order_id based on updated_at.
select * from (select * ,
row_number() over(partition by order_id order by updated_at desc) as rn 
from orders)t 
where rn = 1
--------------------------------QUESTION 10 : 
--First get the latest record for each order_id.
--Then calculate the total amount spent by each customer.
select *,
sum(amount) as customeramount
from(
select * from (select * ,
row_number() over(partition by order_id order by updated_at desc) as rn 
from orders)t 
where rn =1)p
group by customer_id
-------------------------Question 10 — Find customers with increasing order amounts
----Find the orders where the current order amount
--is greater than the customer's previous order amount.
select * from (
select *,
lag(amount) over(partition by customer_id order by updated_at ) as previous
from orders ) t
where amount>previous
-----------------------Day 7 — Question 11
----Find each customer's order-to-order amount growth.
select *,
amount- previous as growth 
from (
select *,
lag(amount) over(partition by customer_id order by updated_at ) as previous
from orders ) t
---------------------------Day 7 — Question 12 🔥
/*Find the customers whose order amount increased 
compared with their previous order at least twice consecutively
*/

WITH CTE1 AS
(
    SELECT *,
           LAG(amount) OVER (
               PARTITION BY customer_id
               ORDER BY order_date
           ) AS previous
    FROM orders
),
CTE2 AS
(
    SELECT *,
           CASE
               WHEN amount > previous THEN 1
               ELSE 0
           END AS increase
    FROM CTE1
),
CTE3 AS
(
    SELECT *,
           LAG(increase) OVER (
               PARTITION BY customer_id
               ORDER BY order_date
           ) AS previous_increase
    FROM CTE2
)
SELECT *
FROM CTE3
WHERE increase = 1
  AND previous_increase = 1;
----------------------------Day 7 — Question 13 🔥
----Calculate the running total of amount for each customer, ordered by order_date.
select *,
sum(amount) over(partition by customer_id order by order_date) as running_total
from orders
------------------------------Day 7 — Question 14 🔥
--ask
/*For each order, calculate:
1. Customer's total spending
2. What percentage of that customer's total spending this order represents*/
select * ,
CAST(amount as decimal(10,2))/total_amount * 100 as percentchange
from(
select * ,
sum(amount) over(partition by customer_id) as total_amount
from orders
)t 
---------------------------------Day 7 — Question 15 🔥
--Find the second-highest order amount for each customer
select * from (
select *,
dense_rank() over(partition by customer_id order by amount desc) as rn
from orders)
where rn = 2
----------------------------------Day 7 — Question 16 🔥
--Find the monthly revenue and the previous month's revenue for each month.
SELECT
    monthh,
    revenue,
    LAG(revenue) OVER (
        ORDER BY monthh
    ) AS previous_month_revenue
FROM (
    SELECT
        MONTH(order_date) AS monthh,
        SUM(amount) AS revenue
    FROM orders
    GROUP BY MONTH(order_date)
) t;
-----------------------------------