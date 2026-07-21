/*
SubQuery
------------

1. Single Row Subquery
- If inner query provides with singe data.
- comparison Operator (=, <,>, <=, >=, !=)

2. Multi Row Subquery
- If inner query provides with multiple row data.
- In (Categorical / Discrete), Any(or), All(and) (Continuous) -> comparison operator

syntax
-----------
select * from table where id = ( -- outer query
	select * from table -- inner query
);
*/

-- Find all the details of products whose list price is less than its average list price.
select
	AVG(list_price)
from production.products;

select * from production.products where list_price < 1520.591401
order by list_price desc;



select * from production.products where list_price < (
	select AVG(list_price) from production.products
) order by list_price desc;



-- Find second highest list price among all prices in products.
select * from production.products where list_price = (
	select MAX(list_price) from production.products where list_price < (
		select max(list_price) from production.products where list_price < (
			select max(list_price) from production.products
		)
	)
);



select
	sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, sc.city, sc.state, sc.zip_code
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where order_status = 3;


select
	customer_id, first_name, last_name, email, street, city, state, zip_code
from sales.customers where customer_id in (
	select customer_id from sales.orders where order_status = 3
);

select
	so.order_id, so.order_status, DATEDIFF(day, order_date, shipped_date) as delivered_days
from production.products pp
join sales.order_items soi
on pp.product_id = soi.product_id
join sales.orders so
on so.order_id = soi.order_id
where pp.model_year = 2018 and pp.category_id in (3, 6) and so.order_status = 4;


select
	order_id, order_status, DATEDIFF(day, order_date, shipped_date) as delivered_days
from sales.orders where order_id in (
	select order_id from sales.order_items where product_id in (
		select product_id from production.products where model_year = 2018 and category_id in (3, 6)
	)
) and order_status = 4;



-- 229.99,279.99
-- Find details of products whose list price is less than any of those price.

select * from production.products where list_price < any (
	select list_price from production.products where list_price in (229.99,279.99)
) order by list_price;

select * from production.categories where category_id in (
	select category_id from production.products where list_price < all (
		select list_price from production.products where list_price in (229.99,279.99)
	) 
);



-- Find the top 5 customers who have spent the most money across all their completed orders.
select * from sales.orders where exists (
	select order_id, ((quantity * list_price) * (1-discount)) from sales.order_items
);


SELECT SUM(total_spent) AS total_amount
FROM
(
    SELECT TOP 5
        customer_name,
        SUM(total_price) AS total_spent
    FROM
    (
        SELECT
            CONCAT(sc.first_name, ' ', sc.last_name) AS customer_name,
            (quantity * list_price) * (1 - discount) AS total_price
        FROM sales.customers sc
        JOIN sales.orders so
            ON sc.customer_id = so.customer_id
        JOIN sales.order_items soi
            ON soi.order_id = so.order_id
        WHERE so.order_status = 4
    ) AS data
    GROUP BY customer_name
    ORDER BY total_spent DESC
) AS top5;