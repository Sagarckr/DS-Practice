/*
SQL Join
---------
Inner Join -> Extracts matching/common records between tables.

Left Join -> Extracts all data from left table matching records from right table
				remaining unmatched records shows null.

Right Join -> Extracts all data from right table matching records from left table
				remaining unmatched records shows null.

Full Outer Join -> Combination of all 3 join.

Self Join
*/


-- Find details of customers and their order details.

select
	sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, sc.city,
	so.order_id, so.order_status, so.order_date, so.shipped_date
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id;


-- Find total orders orderd by each customer name. 
-- Display customer name and total orders.

select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name,
	COUNT(so.order_id) as total_orders
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
group by CONCAT(sc.first_name, ' ', sc.last_name)
having count(so.order_id)>2;


select 
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name, pp.product_name,
	pp.model_year,
	((soi.quantity * soi.list_price)*(1-soi.discount)) as total_price,
	DATEDIFF(day, so.order_date, so.shipped_date) as deliver_days
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on pp.product_id = soi.product_id
where so.order_status = 4
order by total_price desc;


-- Find total orders and customers handled by each staff members.
select
	CONCAT(ss.first_name, ' ', ss.last_name) as staff_name,
	COUNT(distinct sc.customer_id) as total_customers,
	COUNT(distinct so.order_id) as total_orders
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.staffs ss
on ss.staff_id = so.staff_id
group by CONCAT(ss.first_name, ' ', ss.last_name);



-- left join
-- find all records of customers and their order details whether customer has ordered or not.

select 
	*
from sales.customers sc
left join sales.orders so
on sc.customer_id = so.customer_id;

select 
	* 
from sales.customers sc
right join sales.orders so
on sc.customer_id = so.customer_id;

select 
	* 
from sales.customers sc
full outer join sales.orders so
on sc.customer_id = so.customer_id;


-- Find manager names and their associate staff members.
select 
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	CONCAT(s2.first_name, ' ', s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

select 
	*
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;


-- Find name of stores and its staff names, number of products stored in store
-- and number of customers handled by each staff members.

select 
	ss.store_name,
	CONCAT(sss.first_name, ' ', sss.last_name) as staff_name,
	COUNT(distinct ps.product_id) as total_products,
	COUNT(distinct so.customer_id) as total_customers
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.stores ss
on so.store_id = ss.store_id
join sales.staffs sss
on ss.store_id = sss.store_id
join production.stocks ps
on ps.store_id = ss.store_id
group by ss.store_name,
	CONCAT(sss.first_name, ' ', sss.last_name);


