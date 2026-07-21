-- CTE (Common Table Expressions)
-- Temporary Data Table

--with cte_name as (
--	query..
--) select * from cte_name;


with customer_orders as (
	select
		CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
		((quantity * list_price) * (1 - discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on soi.order_id = so.order_id
	where so.order_status = 4
),
customer_price as (
	select top 5 customer_name, SUM(total_price) as total_spent from customer_orders
	group by customer_name order by total_spent desc
)
select sum(total_spent) as price from customer_price;


--Create a CTE that calculates the total order value 
--(accounting for quantity, list price, and discount) for each order_id. Use it to find the 
--average order value across the entire company. 

with avg_price as(
	select
		order_id,
		sum(((quantity * list_price) * (1 - discount))) as total_price
	from sales.order_items
	group by order_id
) select avg(total_price) as price from avg_price;

with price_details as (
	select order_id, sum(total_price) as price from (
		select
			order_id,
			((quantity * list_price) * (1 - discount)) as total_price
		from sales.order_items
	) as price_data
	group by order_id
) select avg(price) as avg_order_price from price_details;


select sum(total_spent) as total_amount from (
	select top 5
		customer_name, sum(total_price) as total_spent
	from (
		select
			CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
			((quantity * list_price) * (1 - discount)) as total_price
		from sales.customers sc
		join sales.orders so
		on sc.customer_id = so.customer_id
		join sales.order_items soi
		on soi.order_id = so.order_id
		where so.order_status = 4
	) as data
	group by customer_name
	order by total_spent desc
) as price_data;

