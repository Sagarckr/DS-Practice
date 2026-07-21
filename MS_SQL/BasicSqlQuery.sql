/*
- And, or, not(!), between, in, like
*/

-- String Functions
---------------------------
-- Concat Function and Concat Operator (+)
-- Left, Right, Substring

select * from sales.customers;

-- Extract full name of customers;
select
	CONCAT(first_name, ' ', last_name) as full_name, -- alias
	-- cannot concat string with integer using operator.
	first_name + ' ' + last_name as full_name_op
from sales.customers;

-- Substring (column_name, length, no_of_letters)
-- Extract specific letters/digits from a word.
select
	last_name,
	SUBSTRING(last_name, 2,3) as extracted_last_name
from sales.customers;

-- Substring / Left
-- Extract first 3 letters from last_nameselect
select
	last_name,
	SUBSTRING(last_name, 1,3) as extracted_last_name,
	LEFT(last_name,3) as left_3,
	RIGHT(last_name,4) as right_4
from sales.customers;

-- Date Functions
select * from sales.orders; 

select 
	order_date,
	-- SSMS / Tableau / Powerbi / Excel
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	DAY(order_date) as order_day,

	-- Date Name -->SSMS / Tableau
	DATENAME(MONTH, order_date) as month_name,
	DATENAME(DAY, order_date) as day_name,
	DATENAME(WEEKDAY, order_date) as day_name1,

	-- Format --> SSMS / Powerbi
	FORMAT(order_date, 'MMM') as month_name_fmt,
	FORMAT(order_date, 'd') as day_name_fmt,
	DATEPART(WEEKDAY, order_date) as weekday_num

from sales.orders;


-- Date analysis function
-- Datetime analysis, cohort analysis, order segmentation analysis
-- Date Difference

select
	order_date, shipped_date,
	DATEDIFF(day, order_date, shipped_date) as no_of_days_to_deliver,
	DATEADD(day, 2, required_date) as date_added
from sales.orders;

-- Date Add
-- To fill null values in sql -> isnull(), Coalesce()

select 
	shipped_date,
	ISNULL(shipped_date, GETDATE()) as data,
	Coalesce(shipped_date, Getdate()) as coalesce_date
from sales.orders;

select
	phone,
	ISNULL(phone, 'No Phone Number')
from sales.customers;

-- SQL Case

/* select	
		case	
			when condition then value
			when condition then value
			when condition then value
			-- Else value
		END
	from table_name;
*/

-- From, Join, Where, Group by, Having, Select, Order by, Limit/Top/Offset-Fetch

select distinct order_status from sales.orders;

select
	order_id, customer_id, order_date, required_date, 
	shipped_date,order_status,
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Value'
	End as order_status_label
from sales.orders
order by order_status_label

-- Find the total price of each order items.
-- price less than 3000 -> low price purchase
-- price between 3000 to 8000 -> average price purchase
-- price higher than 8000 -> high price purchase

-- Relational Algebra
-- Projection(Pie) Join(X), selection(sigma)

SELECT
    order_id,
    item_id,
    product_id,
    quantity,
    list_price,
    discount,
    (quantity * list_price) * (1 - discount) AS total_price,
    CASE
        WHEN (quantity * list_price) * (1 - discount) < 3000 THEN 'Low Price Purchase'
        WHEN (quantity * list_price) * (1 - discount) BETWEEN 3000 AND 8000 THEN 'Average Price Purchase'
        ELSE 'High Price Purchase'
    END AS purchase_category
FROM sales.order_items;


WITH order_total AS
(
    SELECT
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount,
        (quantity * list_price) * (1 - discount) AS total_price
    FROM sales.order_items
)
SELECT *,
    CASE
        WHEN total_price < 3000 THEN 'Low Price Purchase'
        WHEN total_price BETWEEN 3000 AND 8000 THEN 'Average Price Purchase'
        ELSE 'High Price Purchase'
    END AS purchase_category
FROM order_total
order by total_price desc;



select * from sales.customers;

-- Group by and Having
-- if we use group by function then aggregate function must be used.
-- Aggregate function -> Avg, sum, count, min, max
-- Aggregate Column -> if we use agg function in column that column is named as agg column.
-- Non-Aggregate Column -> if we haven't used agg function in columns then those columns are named as non - agg column.
-- if we have non agg column with an agg column then non agg column must be in group by clause.


-- Find total customers from each state.
select 
	state, city, COUNT(customer_id) as total_customers
from sales.customers
where state = 'TX'
group by state, city
order by state desc;

select 
	state, city, COUNT(customer_id) as total_customers
from sales.customers
group by state, city
having state = 'TX'
order by state desc;

select 
	state, city, COUNT(customer_id) as total_customers
from sales.customers
group by state, city
having count(customer_id) > 10
order by state desc;

-- 1. Pending, 2.Processing, 3.Rejected, 4.Completed
-- Find total no. of pending, processing, rejected and completed orders

select 
	*
from sales.orders

select
	customer_id, count(order_status) as order_status
from sales.orders
group by customer_id



select
	case	
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
	End as order_label,
	count(order_id) as total_orders
from sales.orders
group by 
case	
	when order_status = 1 then 'Pending'
	when order_status = 2 then 'Processing'
	when order_status = 3 then 'Rejected'
	when order_status = 4 then 'Completed'
	End;


select
	sum(case when order_status = 1 then 1 else 0 end) as total_pending,
	sum(case when order_status = 2 then 1 else 0 end) as total_processing,
	sum(case when order_status = 3 then 1 else 0 end) as total_rejected,
	sum(case when order_status = 4 then 1 else 0 end) as total_completed
from sales.orders

select
	customer_id,
	sum(case when order_status = 1 then 1 else 0 end) as total_pending,
	sum(case when order_status = 2 then 1 else 0 end) as total_processing,
	sum(case when order_status = 3 then 1 else 0 end) as total_rejected,
	sum(case when order_status = 4 then 1 else 0 end) as total_completed
from sales.orders
group by customer_id
having sum(case when order_status = 2 then 1 else 0 end)>0;


-- Find customer id and its order status and total_orders and also show exactly 
-- how many days required to deliver an order.

select
	customer_id,
	order_status,
	count(order_id) as total_orders,
	DATEDIFF(day, order_date, shipped_date) as total_delivery_days
from sales.orders
where order_status = 4
group by customer_id, order_status, DATEDIFF(day, order_date, shipped_date)

-- SQL Join
