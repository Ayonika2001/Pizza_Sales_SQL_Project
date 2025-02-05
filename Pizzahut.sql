create database pizzahut;
use pizzahut;

create table orders(
order_id int primary key,
order_date date not null,
order_time time not null);

create table order_details(
order_details_id int primary key,
order_id int not null,
pizza_id text not null,
quantity int not null);


-- Basic:
-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity*pizzas.price),0) as total_revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name ,max(pizzas.price) as Highest_priced_pizza
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name 
order by Highest_priced_pizza desc limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size ,count(order_details.order_details_id) as Most_common_pizza_size_orderd
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by Most_common_pizza_size_orderd desc limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as most_order_pizza
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by most_order_pizza desc limit 5;


-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category;

-- Determine the distribution of orders by hour of the day.
select hour(orders.order_time),count(order_id) as total_orders
from orders 
group by hour(orders.order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name)  from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) from
(select orders.order_date,sum(order_details.quantity)as quantity
from orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date) as order_quantity ;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, round(sum(order_details.quantity * pizzas.price),0) as total_revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by total_revenue desc limit 3;
-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.name,round(sum(order_details.quantity * pizzas.price)/
(select round(sum(order_details.quantity * pizzas.price),2)
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id)*100,2) as total_revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name;

-- Analyze the cumulative revenue generated over time.
select order_date,
sum(total_revenue) over(order by order_date) as cum_sum
from
(select orders.order_date,round(sum(order_details.quantity * pizzas.price),0) as total_revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) total_sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

#order by total_revenue desc limit 3;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with ranked_pizza_types as
(select pizza_types.name,pizza_types.category,sum(order_details.quantity * pizzas.price) as total_revenue,
rank() over(partition by pizza_types.category order by sum(order_details.quantity * pizzas.price) desc) as rnk
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.name,pizza_types.category )

select name,category,total_revenue, rnk
from ranked_pizza_types
where rnk<=3;

