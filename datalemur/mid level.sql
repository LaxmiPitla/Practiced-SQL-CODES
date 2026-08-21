/*===============================User's Third Transaction - Uber SQL Interview Question===============================*/

SELECT user_id,spend,transaction_date FROM
(
SELECT *,
ROW_NUMBER() OVER(Partition by user_id order by transaction_date) as rn
FROM transactions)t
where rn = 3
/*==============================Second Highest Salary -FAANG SQL Interview Question=======================*/
select 
salary from (SELECT employee_id, salary 
FROM employee
order by salary desc
limit 2)t
order by salary asc limit 1;
===================or======================================
select 
salary from 
(select *,
row_number() over(order by salary desc) as rn 
from employee)t 
where rn = 2;
/*=========================================================================*/
