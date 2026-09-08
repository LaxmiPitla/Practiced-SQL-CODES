------------------------------------QUESTION 41
--Find customers who have placed more orders than
--the average number of orders placed by a customer.
 WITH CTE AS 
 (
select c.customer_id as customername,count(order_id) as ordercounts
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_id )
select * from (
select 
customername,
ordercounts,
avg(ordercounts) over() as avgcountts
from CTE)t where 
ordercounts>avgcountts
----------------------------------------Question 42
---Find the month with the highest total revenue.
select top 1 year(order_date), month(order_date),
sum(price *quantity*(1-discount)) as reveune
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by year(order_date),month(order_date)
order by reveune desc
----------------------------------------Question 43 
---Find the customer who placed the highest number of orders
select top 1 
c.customer_id as customername,count(order_id) as ordercounts
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_id
order by count(order_id) desc 
------------------------------------Question 44
--Find customers who have never placed an order.
select  
c.customer_id 
from customers c
left join orders o 
on c.customer_id = o.customer_id
where o.customer_id is null
--------------------------------------QUESTION 45 
---Find products that have never been ordered.
select p.product_id
from products p 
left join order_items oi 
on p.product_id = oi.product_id 
where oi.product_id is null
--------------------------------------QUESTION 46
--Find the top 3 products by total quantity sold.
select top 3 p.product_id,sum(quantity) 
from products p 
 join order_items oi 
on p.product_id = oi.product_id 
group by p.product_id
order by sum(quantity) DESC
-------------------------------------QUESTION 47 
--Find the customer who spent the most money on a single order.
select top 1  o.customer_id,
sum(price*quantity*(1-discount)) as amount
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id= p.product_id
group by o.order_id,o.customer_id
order by amount desc
----------------------------------QUESTION 48 
---Find customers whose total spending is higher than the total spending of customer ID 101.
WITH CTE AS 
(select  o.customer_id as custid,
sum(price*quantity*(1-discount)) as amount
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id= p.product_id
group by o.customer_id
)
select custid from CTE 
where amount> (select amount from CTE where custid = 101)
-----------------------------------------QUESTION 49 
--- Find the top 2 customers by total spending in each year.
WITH CTE AS 
(
select  
c.customer_id as custid, year(order_date) as yearr ,
sum(price* quantity * (1-discount)) as total_spent
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id= p.product_id
group by c.customer_id,year(order_date)
)
select * from (
select 
custid,yearr ,total_spent,
DENSE_RANK() over (partition by yearr order by total_spent DESC) as rn 
from CTE)t 
where rn <=2;
-------------------------------------------QUESTION 50 
--Find the month-over-month revenue growth for each month.
WITH CTE AS 
(
select year(order_date) as yearr, month(order_date) as monthh,
sum(price* quantity *(1-discount)) as revenue  
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id= p.product_id
group by year(order_date),month(order_date)
)
select 
yearr,monthh, revenue,
lag(revenue) over(order by yearr,monthh) as previousmonth,
(revenue-lag(revenue) over(order by yearr,monthh))
/lag(revenue) over(order by yearr,monthh) *100 as revgrowth
from CTE;








