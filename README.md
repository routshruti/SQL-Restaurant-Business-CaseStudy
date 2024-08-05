### Introduction:

Danny loves Japanese cuisine, so at the beginning of 2021, he took a bold step by opening a charming little restaurant that features his top three favorite dishes: sushi, curry, and ramen. Danny’s Diner, though small, is in the early stages of its journey and has gathered some preliminary data from its few months of operations. However, Danny needs assistance in making sense of this data to better understand his customers and optimize his business.

### Problem Statement:

Danny seeks to gain insights into his customers' behaviors, including their visiting patterns, spending habits, and preferences for menu items. By analyzing this information, he hopes to enhance the customer experience and determine whether expanding the current customer loyalty program would be beneficial.

### Goal:

Generate insights that will help him in decision-making about the potential expansion of the loyalty program and improve the overall dining experience. Additionally, Danny needs to produce simple datasets for his team to review, facilitating easier data inspection without relying on SQL.

### Stakeholder(s):
CEO/Founder

### Tables:
- sales: It captures all customer_id level purchases with a corresponding order_date and product_id information for when and what menu items were ordered.
- menu: It maps the product_id to the actual product_name and price of each menu item.
- members: It captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.
  
### Solution:

1. What is the total amount each customer spent at the restaurant?

| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

```Customer A spent the highest amount and Customer C spent the least.```

---

2. How many days has each customer visited the restaurant?

|customer_id|visited_days|
|-----------|------------|
|A          |4           |
|B          |6           |
|C          |2           |

---
   
3. What was the first item from the menu purchased by each customer?

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

```Customer A purchased two products on the same day. Without exact timestamps (like the time of day), we can't tell which product was purchased first. This limitation means that for records on the same day, all we can infer is that the products were purchased on that date, but not the exact order of their purchase.```

---

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

|product_name|order_count|
|------------|-----------|
|ramen       |8          |

```Everyone loves ramen!```

---

5. Which item was the most popular for each customer?

|customer_id |popular_product|
|------------|--------------|
| A          |ramen         |
| B          |sushi, curry, ramen|
| C          |ramen         |

```As inferred, all customers enjoy ramen. However, Customer B also likes sushi and curry equally.```

---

6. Which item was purchased first by the customer after they became a member?

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| B           | sushi        |

---

7. Which item was purchased just before the customer became a member?

| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi, curry |
| B           | sushi        |

---

8. What is the total items and amount spent for each member before they became a member?

| customer_id | total_items  | amount_spent|
| ----------- | ------------ | ----------  |
| A           | 2            | 25          |
| B           | 2            | 40          |

```Both customers purchased two items, but customer B spent more than customer A.```

---

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

| customer_id | points       |
| ----------- | ------------ |
| A           | 860          |
| B           | 940          |
| C           | 360          |

---

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customers A and B have at the end of January?

| customer_id | points       |
| ----------- | ------------ |
| A           | 1370         |
| B           | 820          |

---
#### Bonus Question
- Create a new table having customer_id, order_date, product_name, price. Add a new column to specify if a customer is a member or not w.r.t order_date. Use 'Y' for yes and 'N' for no.
- Add information about the ranking of customer products. However, the client purposely does not need the ranking for non-member purchases, so he expects null ranking values for the records when customers are not yet part of the loyalty program.

| customer_id | order_date | product_name | price | member | ranking |
|-------------|------------|--------------|-------|--------|---------|
| A           | 2021-01-01 | sushi        | 10    | N      |         |
| A           | 2021-01-01 | curry        | 15    | N      |         |
| A           | 2021-01-07 | curry        | 15    | Y      | 1       |
| A           | 2021-01-10 | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01 | curry        | 15    | N      |         |
| B           | 2021-01-02 | curry        | 15    | N      |         |
| B           | 2021-01-04 | sushi        | 10    | N      |         |
| B           | 2021-01-11 | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16 | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01 | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01 | ramen        | 12    | N      |         |
| C           | 2021-01-01 | ramen        | 12    | N      |         |
| C           | 2021-01-07 | ramen        | 12    | N      |         |


### Topics Covered:
- Basic Commands
- Table Joins
- Date-Time Manipulation
- Group By
- Aggregate Functions
- CTE
- Window Functions

### Tools Used:
- PostgreSQL
- pgAdmin
