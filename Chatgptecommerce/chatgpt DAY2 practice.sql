select * from customers
where city = 'Hyderabad';
----------
select * from products
where price>5000;

----
select count(*) from orders;
------
select product_id,sum(quantity) from order_items
group by product_id;
---------
select product_id,sum(price) from products
group by product_id;

------
select * from products;
select * from order_items;

select p.product_id, round(sum(p.price * o.quantity * (1-o.discount)),2) as total_revenue
from products p 
join order_items o 
on p.product_id = o.product_id
group by p.product_id
-------------------------
select c.customer_name,count(c.customer_id) as nooforders from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_name 
having count(o.customer_id)>1

----------------
select top 3 c.customer_name,sum(p.price *oi.quantity *(1-oi.discount)) as total_spent
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id
group by c.customer_name,c.customer_id
order by total_spent  desc 

----------------------
--Find the highest priced productt in each category 
select category,product_name,max(price) from
(
select category,max(price) ,
ROW_NUMBER() over(partition by category order by max(price) desc ) as rn 
from products
)t 
where rn=1;
-----------
---Find the number of orders for each month in 2025
SELECT MONTH(order_date) AS month,
       COUNT(order_id) AS no_of_orders
FROM orders
WHERE YEAR(order_date) = 2025
GROUP BY MONTH(order_date);

-----------
--Find customers who have never placed an order.
select c.customer_name,c.customer_id
from customers c 
left join orders o 
on c.customer_id = o.customer_id
where o.customer_id IS null
---------
--Find the product that generated the highest revenue.
select top 1 p.product_name , sum(price *quantity * (1-discount)) as revenue 
from products p 
join order_items oi 
on p.product_id = oi.product_id
group by p.product_name 
order by revenue desc 
--------------------
---Find the average order value.
select  avg(price *quantity * (1-discount)) as avgvalue
from products p 
join order_items oi 
on p.product_id = oi.product_id
---------
select avg(priceofeachorder) as AOV from 
(
select oi.order_id, sum(price * quantity *(1-discount)) as priceofeachorder
from products p 
join order_items oi 
on p.product_id = oi.product_id
group by oi.order_id
)t;
---------
---Find the total revenue by category.
select p.category,sum(price * quantity * (1-discount)) as categoryprice 
from products p 
join order_items oi 
on p.product_id = oi.product_id
group by p.category
---------------
----Find the customer with the highest number of orders.
select top 1 c.customer_id,count(order_id)
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_id
order by count(order_id) desc;
--------------
--Find customers whose total spending is greater than the average spending of all customers.
WITH CTE AS 
(
select c.customer_name as customername, sum(price*quantity *(1-discount)) as totalspending
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by c.customer_name,c.customer_id
)
select * from (select customername, totalspending, 
avg(totalspending) over() as avgofallcustomers
from CTE)t
where totalspending>avgofallcustomers
------------------------
----Find the second-highest priced product.
select  top 1 *  from (
select top 2  product_name, price 
from products
order by price desc)t
order by price asc 
---------------
----Find the top 2 highest-priced products in each category.
select * from (select product_name,
row_number() over(partition by category order by price desc) as rn
from products )t 
where rn<3 
--------------
----Find customers who have placed more than 2 orders.
select customer_id ,count(order_id) 
from orders
group by customer_id 
having count(order_id)>2
-------------
----Find the percentage of orders that were cancelled.
select
CAST(
    (select count(order_id) from orders where order_status = 'Cancelled') AS decimal(10,2)
)
/
(select count(order_id) from orders) *
100 as percentagee;
------------
---Find the total revenue for each month in 2025.
select month(o.order_date) as month,
sum(p.price *oi.quantity *(1-oi.discount)) as totalrevenue
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
where year(o.order_date) = 2025
group by month(o.order_date) 
-------------------
----Find customers whose total spending is greater than ₹50,000.
select c.customer_name ,sum(p.price *oi.quantity *(1-oi.discount)) as total_spent
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by c.customer_name
having sum(p.price *oi.quantity *(1-oi.discount))>50000;
------------
---Find the latest order placed by each customer.
select customer_name ,
max(order_date)
from customers c 
join orders o 
on c.customer_id = o.customer_id
group by customer_name,c.customer_id;
-------------------------------
---Calculate the running total of revenue by order date.
select order_date,totalrevenue,
sum(totalrevenue) over (order by order_date) from 
(select o.order_date as order_date,
sum(price *quantity *(1-discount)) as totalrevenue
from orders o 
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by o.order_date
)t
-------------------------
-----Rank customers based on their total spending, with the highest spender ranked 1.
WITH CTE AS
(
select c.customer_name as customername,
sum(price*quantity *(1-discount)) as totalrevenue
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on o.order_id = oi.order_id
join products p 
on oi.product_id = p.product_id
group by c.customer_name,c.customer_id
)
select 
customername,totalrevenue,
RANK() over( order by totalrevenue desc) as rn
from CTE;








