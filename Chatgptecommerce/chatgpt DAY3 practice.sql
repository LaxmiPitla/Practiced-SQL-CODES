-------------------------------Question 28 
----Find the top 3 customers by total spending in 2025.
select top 3 c.customer_name,
sum(price *quantity *(1-discount)) as total_spent 
from customers c 
join orders o 
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
where year(order_date) = 2025
group by c.customer_name,c.customer_id
order by total_spent desc

-------------------------------Question 29 
--Find the second-highest revenue-generating product category.
select top 1  * from (
select top 2 p.category,
sum(price* quantity *(1-discount)) as productrevenue
from customers c 
join orders o 
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by p.category
order by productrevenue desc)t
order by productrevenue asc

-------------------------------Question 30 
----Find each customer's total number of orders and total amount spent,
--showing only customers who spent more than ₹10,000.
select c.customer_name, count(order_id),
sum(price *quantity * (1-discount)) as total_spent
from customers c 
join orders o 
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
where total_spent>10000
group by c.customer_id