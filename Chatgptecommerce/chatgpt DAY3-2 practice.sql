-------------
---Find monthly revenue for 2025 and show the previous month's revenue alongside it.
WITH CTE as (
select month(order_date) as month,
sum(price*quantity*(1-discount)) as total_spent
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
where year(order_date) = 2025
group by month(order_date)
)
select *,
LAG(total_spent) over (order by month)
from CTE
---------------------------------------
----Find the customers who placed more than 3 orders in 2025.
select  c.customer_name
from customers c
join orders o 
on c.customer_id = o.customer_id
where year(order_date) = 2025 
group by c.customer_id,c.customer_name
having count(o.order_id)>3

-----------------------------------
----Find the highest-priced product in each category.
select * from (
select  category, product_name,price,
row_number() over (partition by category order by price desc) as rn 
from products )t 
where rn =1
------------------------
-----Find the percentage contribution of each category to total revenue.
WITH CTE AS 
(
select  p.category as category,
sum(price * quantity * (1-discount)) as total_revenue
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by p.category
)
select 
category, total_revenue ,
sum(total_revenue) over() as totrevenue,
total_revenue/ sum(total_revenue) over() *100 as percentt
from CTE
group by category












