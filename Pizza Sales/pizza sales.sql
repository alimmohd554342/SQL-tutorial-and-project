-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.



select category, name, revenue, 
rank() over (partition by category order by revenue desc) as rnk
from
(select pizza_types.category, pizza_types.name, 
sum(order_detail.quantity * pizzas.price) as revenue
from pizzas join pizza_types 
on pizzas.pizza_type_id =pizza_types.pizza_type_id 
join order_detail on 
order_detail.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a;