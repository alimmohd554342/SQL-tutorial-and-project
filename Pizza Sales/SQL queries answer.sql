-- Retrieve the total number of orders placed.
select count(order_id) from orders;


-- Calculate the total revenue generated from pizza sales.

select round(sum(order_detail.quantity * pizzas.price),2) as total_revenue
from order_detail join pizzas
on order_detail.pizza_id = pizzas.pizza_id;


-- Identify the highest-priced pizza.

select pizza_types.name, pizzas.price
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 3;



-- Identify the most common pizza size ordered.

select pizzas.size, count(order_detail.quantity)
from pizzas join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by pizzas.size;





-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, sum(order_detail.quantity) as total
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail
on pizzas.pizza_id = order_detail.pizza_id
group by pizza_types.name 
order by total desc limit 5;





-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_detail.quantity) as total
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_detail on pizzas.pizza_id = order_detail.pizza_id
group by pizza_types.category
order by total desc limit 5;




-- Determine the distribution of orders by hour of the day.

select hour(order_time) as time, count(order_id) from orders
group by time;




-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(quantity)
from
(select orders.order_date, sum(order_detail.quantity) as quantity
from orders join order_detail
on orders.order_id = order_detail.order_id
group by orders.order_date) as order_quantity;





-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, sum(order_detail.quantity * pizzas.price) as revenue
from order_detail join pizzas
on order_detail.pizza_id = pizzas.pizza_id
join pizza_types 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by  pizza_types.name
order by revenue desc
limit 3;




-- Calculate the percentage contribution of each pizza type to total revenue.


select pizza_types.category, round(sum(order_detail.quantity * pizzas.price)/
(select round(sum(order_detail.quantity * pizzas.price),2) as total_revenue
from order_detail join pizzas
on order_detail.pizza_id = pizzas.pizza_id) *100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail on pizzas.pizza_id = order_detail.pizza_id
group by  pizza_types.category;





-- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum
from
(select orders.order_date, sum(quantity * pizzas.price) as revenue 
from order_detail join pizzas
on order_detail.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_detail.order_id
group by orders.order_date) as a;




-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name, revenue,
rank() over(partition by category order by revenue desc) as rnk
from 
(select pizza_types.name, pizza_types.category, 
sum(order_detail.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_detail 
on order_detail.pizza_id = pizzas.pizza_id
group by pizza_types.name, pizza_types.category) as a;