CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale FLOAT
);
select * from retail_sales
limit 10

select 
count(*)
from retail_sales

-- Data Cleaning 

select * from retail_sales 
where
 	 transactions_id is null
 	 or
 	 sale_date is null
 	 or
 	 sale_time is null
 	 or
 	 customer_id is null
 	 or
 	 gender is null
 	 or
 	 category is null
 	 or
 	 quantiy is null
 	 or
 	 price_per_unit is null
 	 or
 	 cogs is null
 	 or
 	 total_sale is null
 	 

-- Data Exploration 
-- how many sales are there ? 

select count(*) as total_sales from retail_sales 
 	
-- How many unique customers are there ? 
select count(distinct(customer_id)) as total_sale  from retail_sales

-- Categories we have 
select distinct(category) from retail_sales 

-- Sales made on 2022-11-05
select * from retail_sales 
where sale_date = '2022-11-05'

-- category = clothing 
select * from retail_sales 
where
	category = 'Clothing' -- case sensitive 
	and quantiy >= 4 
	and TO_CHAR(sale_date, 'YYYY-MM') = '2023-11'
	
-- total sales from each category
select category , sum(total_sale) from retail_sales 
group by category

-- average age of customers from beauty 
select round(avg(age), 2) as Average_age from retail_sales 
where category = 'Beauty'

-- total sale > 1000
select * from retail_sales
where total_sale >= 1000

-- total transactions made by each gender in each category 
select category , gender , count(transactions_id) as sale_gender from retail_sales
group by category , gender
order by 1
 	 
-- best selling month in each year 
select year , month , avg_sale from 
( 
	select 
		extract(year from sale_date) as year, 
		extract(month from sale_date) as month, 
		avg(total_sale) as Avg_sale, 
		RANK() OVER (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
		from retail_sales
	group by 1,2 ) 
as t1 where rank=1

-- top 5 customers based on highest total sales 
select customer_id , sum(total_sale) as total_sales 
from retail_sales 
group by 1
order by 2 desc 
limit 5

-- unique customers who bought from each catrgory 
select category , count(distinct(customer_id)) as unique_customers 
from retail_sales 
group by category 

-- shift depending on timings 
with Hourly_sales as (
select * ,
case 
	when extract(hour from sale_time) < 12  then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as shift
from retail_sales ) 
select shift , count(*)
from Hourly_sales
group by shift 

--profit margin percentage for each category to see which one is the most efficient at making money.

SELECT 
    category,
    SUM(total_sale - cogs) as total_profit,
    ROUND((SUM(total_sale - cogs) / SUM(total_sale) * 100)::numeric, 2) as profit_margin_percentage
FROM retail_sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;

--Low Volume Categories (Average Quantity < 3)

SELECT 
    category,
    AVG(quantiy) as avg_quantity_sold
FROM retail_sales
GROUP BY category
HAVING AVG(quantiy) < 3;

--Weekend vs Weekday Analysis
WITH daily_sales AS (
    SELECT *,
        CASE 
            WHEN TO_CHAR(sale_date, 'Day') IN ('Saturday ', 'Sunday ') THEN 'Weekend'
            ELSE 'Weekday'
        END as day_type
    FROM retail_sales
)
SELECT 
    day_type,
    COUNT(*) as total_orders,
    SUM(total_sale) as total_revenue
FROM daily_sales
GROUP BY day_type;
