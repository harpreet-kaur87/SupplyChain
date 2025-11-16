create database supply_chain;
use supply_chain;

select * from shipments;
select * from suppliers;
select * from products;
select * from inventory;
select * from customers;
select * from orders;

-- shipments

-- total count of shipments
select count(*) as total_shipments from shipments;

-- Calculate the number of days taken for each shipment to be delivered by finding the difference between the delivery date and the ship date. Additionally, classify each shipment based on its delivery performance by creating a new column:
-- ‘Early Delivery’ if the delivery date is earlier than the expected date,
-- ‘On-Time Delivery’ if it matches the expected date, and
-- ‘Late Delivery’ if it is delivered after the expected date.
select *,
datediff(delivery_date,ship_date) as time_taken_in_days,
(case 
	when delivery_date < expected_date then 'Early Delivery'
    when delivery_date = expected_date then 'On-time Delivery'
    else 'Late Delivery'
end) as delivery_status
from shipments;

-- Determine the total number of shipments delivered early, on time, and late based on their delivery performance status.
with delivery_status_cte as(
select *,
(case 
	when delivery_date < expected_date then 'Early Delivery'
    when delivery_date = expected_date then 'On-time Delivery'
    else 'Late Delivery'
end) as delivery_status
from shipments)
select delivery_status, count(*) as cnt from delivery_status_cte group by delivery_status;

-- For each carrier, calculate the average time taken (in days) to deliver shipments. Additionally, determine the number of shipments delivered early, on time, and late by each carrier.
select carrier,
round(avg(datediff(delivery_date,ship_date)),0) as avg_time,
count(case when delivery_date < expected_date then 1 end) as Early_Delivery,
count(case when delivery_date = expected_date then 1 end) as On_Time_Delivery,
count(case when delivery_date > expected_date then 1 end) as Late_Delivery
from shipments
group by carrier;

-- suppliers

-- total count of suppliers
select count(*) as total_suppliers from suppliers;

-- Determine the total number of suppliers and calculate how many suppliers operate in each region. Additionally, identify which region has the maximum number of suppliers.
select region, count(*) as cnt from suppliers group by region order by cnt desc;

-- Identify the top five suppliers with the highest ratings based on supplier performance data.
select supplier_id, supplier_name, rating from suppliers order by rating desc limit 5;

-- For each region, identify the top three suppliers based on their ratings.
with supplier_report as(
select *,
dense_rank() over(partition by region order by rating desc) as supplier_rating_rank
from suppliers)
select region, supplier_id, supplier_name, rating from supplier_report where supplier_rating_rank <= 3;

-- Identify the top three suppliers who supply the highest number of distinct products.
select s.supplier_id, s.supplier_name, count(p.product_id) as product_cnt
from suppliers as s left join products as p on s.supplier_id = p.supplier_id
group by s.supplier_id order by product_cnt desc limit 3;

-- customers

-- total count of customers
select count(*) as total_customers_cnt from customers;

-- Determine the number of customers in each region to understand the geographical distribution of the customer base.
select region, count(*) as cnt from customers group by region order by cnt desc;

-- Analyze customer acquisition over time by calculating the number of new customers added each year, based on their registration date.
select year(registration_date) as yy, count(*) as customer_cnt from customers group by yy order by yy;

-- Identify the top five customers based on their total order value, calculated using the quantity ordered and the product’s selling price.

with customer_report as(
select c.customer_id, c.customer_name, count(o.order_id) as total_orders, round(sum(o.quantity* p.selling_price),0) as total_sales
from customers as c left join orders as o on c.customer_id  = o.customer_id inner join products as p on p.product_id = o.product_id
group by 1,2),
top_customers_rank as(
select *,
dense_rank() over(order by total_sales desc, total_orders desc) as top_rn
from customer_report)
select * from top_customers_rank where top_rn <= 5;

-- Write an SQL query to find the top 5 cities that generate the maximum revenue based on sales.

select c.city, round(sum(o.quantity * p.selling_price),0) as total_revenue
from customers as c inner join orders as o on c.customer_id = o.customer_id
inner join products as p on o.product_id = p.product_id
group by city order by total_revenue desc limit 5;

-- products

-- count of total distinct products available
select count(*) as total_products from products;

-- Determine the number of products in each category to analyze the product mix and category diversity.
select category, count(distinct product_id) as product_cnt from products group by category;

-- Write an SQL query to identify top 5 products with the highest demand based on the quantity sold.
with product_quantity_sold as(
select p.product_id, p.product_name, sum(o.quantity) as total_quantity
from products as p inner join orders as o on p.product_id = o.product_id
group by p.product_id, p.product_name),
product_report as(
select *,
dense_rank() over(order by total_quantity desc) as product_quantity_rank
from product_quantity_sold)
select product_id, product_name, total_quantity from product_report where product_quantity_rank <= 5;

-- Identify the top three products in each product category based on total revenue generated;
with product_report as(
select p.category, p.product_id, p.product_name, round(sum(o.quantity * p.selling_price),0) as total_revenue
from products as p left join orders as o on p.product_id = o.product_id
group by p.category, p.product_id, p.product_name),
product_report_ranking as(
select *,
dense_rank() over(partition by category order by total_revenue desc) as product_rank
from product_report)
select category, product_id, product_name, total_revenue from product_report_ranking where product_rank <= 3 order by category;

-- Calculate the total revenue and total profit for each product category.
select p.category, round(sum(o.quantity * p.selling_price),0) as total_revenue,
round(sum(o.quantity * (p.selling_price - p.cost_price)),0) as total_profit,
concat(round((sum(o.quantity * (p.selling_price - p.cost_price))/sum(o.quantity * p.selling_price))*100,0),'%') as profit_percentage
from products as p join orders as o on p.product_id = o.product_id
group by p.category;

-- inventory

-- total count of warehouses
select count(distinct warehouse_id) as warehouse_cnt from inventory;

-- Identify all products whose current stock levels have fallen below their reorder level to determine which items need restocking.
select * from inventory where stock_quantity < reorder_level;

-- Generate a warehouse-level stock summary showing the total stock quantity available in each warehouse along with the most recent restock date.
select warehouse_id, sum(stock_quantity) as total_stock_quantity,
max(last_restock_date) as recent_restock_date
from inventory group by warehouse_id order by total_stock_quantity desc;

-- orders

-- total number of orders
select count(order_id) as total_orders from orders;

-- Calculate the average order value
with cte as(
select order_id, 
sum(o.quantity * p.selling_price)  as total_value
from orders as o inner join products as p on o.product_id = p.product_id group by order_id)
select round(sum(total_value) / count(order_id),0) as avg_order_value from cte;

-- Determine the number of orders placed each year. 
select year(order_date) as yy, count(order_id) as order_count from orders group by yy order by yy;

-- Calculate the total sales for each year and analyze the year-on-year sales growth percentage to measure business performance and revenue trends over time.
with current_year_sales as(
select year(order_date) as yy, round(sum(o.quantity * p.selling_price),0) as total_sales
from orders as o inner join products as p on p.product_id = o.product_id
group by yy),
previous_year as(
select *,
lag(total_sales,1) over(order by yy) as previous_year_sales
from current_year_sales)
select yy, total_sales, coalesce(previous_year_sales,0) as previous_year_sales,
coalesce(concat(round(((total_sales - previous_year_sales)/previous_year_sales)*100,0),'%'),0) 
as yoy_growth
from previous_year;

-- Identify the month in each year that generated the maximum total revenue to understand seasonal sales peaks and determine when business performance was strongest during the year.
with monthly_report as(
select year(order_date) as yy, month(order_date) as mnth, round(sum(o.quantity * p.selling_price),0) as total_sales
from orders as o inner join products as p on p.product_id = o.product_id
group by yy,mnth),
month_with_maximum_revenue as(
select *,
dense_rank() over(partition by yy order by total_sales desc) as monthly_sales_rank
from monthly_report),
maximum_month_revenue_cte as(
select * from month_with_maximum_revenue where monthly_sales_rank = 1)
select yy as year, mnth as month, total_sales from maximum_month_revenue_cte;

-- Calculate the average delivery lead time (in days) for each product category to identify whether certain categories consistently take longer to deliver, which may indicate supply chain inefficiencies or carrier performance issues.
with shipment_report as(
select *, datediff(delivery_date,ship_date) as diff_in_days from shipments)
select p.category, round(avg(s.diff_in_days),0) as avg_delivery_time_in_days
from shipment_report as s inner join orders as o on s.order_id = o.order_id inner join products as p on p.product_id = o.product_id
group by p.category;

-- Calculate the total sales revenue generated from each region to understand the geographic distribution of revenue and identify high-performing and underperforming regions.
select c.region, round(sum(o.quantity * p.selling_price),0) as total_sales
from customers as c inner join orders as o on c.customer_id = o.customer_id inner join products as p on p.product_id = o.product_id
group by c.region order by total_sales desc;

-- Analyze whether regions with faster average delivery times also demonstrate higher sales performance. This helps determine if delivery efficiency influences customer satisfaction, repeat orders, and overall revenue contribution.
with shipment_report as(
select *, datediff(delivery_date,ship_date) as diff_in_days from shipments)
select c.region, round(avg(diff_in_days),0) as avg_delivery_lead_time
from shipment_report as s inner join orders as o on o.order_id = s.order_id inner join customers as c on c.customer_id = o.customer_id
group by c.region;
