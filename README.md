## Pizza Hut SQL Analysis Project

### 📌 Project Overview
This project provides an in-depth SQL analysis of a **Pizza Hut** database to extract valuable insights, such as order statistics, revenue generation, pizza popularity, and sales distribution. It consists of various SQL queries categorized into **Basic, Intermediate, and Advanced** levels to explore different aspects of the pizza sales data.

---

### 📂 Database Schema

#### **1. `orders` Table**
Stores details of orders placed.

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);
```

#### **2. `order_details` Table**
Stores details of individual pizzas ordered.

```sql
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL
);
```

---

## 🛠 SQL Queries

### 🔹 Basic Queries

#### **1. Retrieve the total number of orders placed**
```sql
SELECT COUNT(order_id) AS total_orders FROM orders;
```

#### **2. Calculate the total revenue generated from pizza sales**
```sql
SELECT ROUND(SUM(order_details.quantity * pizzas.price), 0) AS total_revenue
FROM order_details 
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;
```

#### **3. Identify the highest-priced pizza**
```sql
SELECT pizza_types.name, MAX(pizzas.price) AS highest_priced_pizza
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name 
ORDER BY highest_priced_pizza DESC 
LIMIT 1;
```

#### **4. Identify the most common pizza size ordered**
```sql
SELECT pizzas.size, COUNT(order_details.order_details_id) AS most_common_pizza_size_ordered
FROM pizzas 
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY most_common_pizza_size_ordered DESC 
LIMIT 1;
```

#### **5. List the top 5 most ordered pizza types along with their quantities**
```sql
SELECT pizza_types.name, SUM(order_details.quantity) AS most_ordered_pizza
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY most_ordered_pizza DESC 
LIMIT 5;
```

---

### 🔹 Intermediate Queries

#### **1. Find the total quantity of each pizza category ordered**
```sql
SELECT pizza_types.category, SUM(order_details.quantity) AS total_quantity
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;
```

#### **2. Determine the distribution of orders by hour of the day**
```sql
SELECT HOUR(orders.order_time) AS order_hour, COUNT(order_id) AS total_orders
FROM orders 
GROUP BY HOUR(orders.order_time);
```

#### **3. Find the category-wise distribution of pizzas**
```sql
SELECT category, COUNT(name) AS pizza_count
FROM pizza_types
GROUP BY category;
```

#### **4. Calculate the average number of pizzas ordered per day**
```sql
SELECT ROUND(AVG(quantity), 0) AS avg_pizzas_per_day
FROM (
    SELECT orders.order_date, SUM(order_details.quantity) AS quantity
    FROM orders 
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;
```

#### **5. Determine the top 3 most ordered pizza types based on revenue**
```sql
SELECT pizza_types.name, ROUND(SUM(order_details.quantity * pizzas.price), 0) AS total_revenue
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC 
LIMIT 3;
```

---

### 🔹 Advanced Queries

#### **1. Calculate the percentage contribution of each pizza type to total revenue**
```sql
SELECT pizza_types.name,
    ROUND(SUM(order_details.quantity * pizzas.price) / 
    (SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2)
     FROM order_details 
     JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100, 2) AS revenue_percentage
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name;
```

#### **2. Analyze the cumulative revenue generated over time**
```sql
SELECT order_date,
       SUM(total_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT orders.order_date, ROUND(SUM(order_details.quantity * pizzas.price), 0) AS total_revenue
    FROM order_details 
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS total_sales;
```

#### **3. Determine the top 3 most ordered pizza types based on revenue for each pizza category**
```sql
WITH ranked_pizza_types AS (
    SELECT pizza_types.name, pizza_types.category,
           SUM(order_details.quantity * pizzas.price) AS total_revenue,
           RANK() OVER (PARTITION BY pizza_types.category ORDER BY SUM(order_details.quantity * pizzas.price) DESC) AS rnk
    FROM order_details 
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    GROUP BY pizza_types.name, pizza_types.category
)
SELECT name, category, total_revenue, rnk
FROM ranked_pizza_types
WHERE rnk <= 3;
```

---

## 📌 Conclusion
This project utilizes **SQL queries** to analyze pizza sales data effectively. By leveraging **JOINs, GROUP BY, aggregate functions, window functions, and ranking**, we uncover valuable insights that can help optimize sales and inventory management.

---

## 📜 Author
**Project by:** Ayonika Dutta


