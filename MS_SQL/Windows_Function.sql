/*
	Window Functions
	----------------
	1. Row Number
	2. Rank
	3. Dense Rank
	4. NTile
	5. Lead
	6. Lag

	select
		column1, column2, column3, Window_Function() Over(partition by column order by column)
	from table_name;

	partition by -> advanced group by
*/

-- Row Number
select
	CONCAT(sc.first_name, ' ', sc.last_name) as full_name, order_status, order_date, shipped_date,
	Row_Number() Over(partition by CONCAT(sc.first_name, ' ', sc.last_name) order by order_date) as rn
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where order_status = 4

select * from (
	select
		CONCAT(sc.first_name, ' ', sc.last_name) as full_name, order_status, order_date, shipped_date,
		Row_Number() Over(partition by CONCAT(sc.first_name, ' ', sc.last_name) order by order_date) as rn
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
) as data
where rn > 1;


-- Rank
select
	product_id, product_name, brand_id, category_id, list_price, model_year,
	Rank() Over(Order by list_price desc) as rn
from production.products


-- Rank
select * from (
	select
		product_id, product_name, brand_id, category_id, list_price, model_year,
		Dense_Rank() Over(Order by list_price desc) as rn
	from production.products
) as data
where rn = 3;


select * from production.products where list_price = (
	select max(list_price) from production.products where list_price < (
		select max(list_price) from production.products where list_price < (
			select max(list_price) from production.products
		)
	)
)



with product_price as (
	select product_id, product_name, brand_id, category_id, list_price, model_year,
	case 
		when rn = 1 then 'Low Price Product'
		when rn = 2 then 'Medium Price Product'
		when rn = 3 then 'High Price Product'
	end as price_label
	from (
		select 
			product_id, product_name, brand_id, category_id, list_price, model_year,
			NTILE(3) Over(order by list_price desc) as rn
		from production.products
	) as data
)
select price_label, sum(list_price) as total_price from product_price
group by price_label;


-- Lead (Next Value)
select 
	product_id, product_name, brand_id, category_id, list_price, model_year,
	LEAD(product_name) Over(partition by category_id order by list_price desc) as next_product
from production.products;


-- Lag (Next Value)
select 
	product_id, product_name, brand_id, category_id, list_price, model_year,
	LAG(product_name) Over(partition by category_id order by list_price desc) as next_product
from production.products;