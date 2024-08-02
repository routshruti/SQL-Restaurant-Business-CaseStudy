--1. What is the total amount each customer spent at the restaurant?

SELECT customer_id, SUM(price) AS amount_spent
FROM sales AS s
JOIN menu AS m
	ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id

--2. How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) AS no_of_visited_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id

--3. What was the first item from the menu purchased by each customer?
	
WITH cte AS
	(SELECT customer_id, product_name, order_date,
    dense_rank() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rank
    FROM sales AS s
    JOIN menu AS m
	    ON s.product_id = m.product_id)
SELECT customer_id, product_name
FROM cte
WHERE rank=1
GROUP BY customer_id, product_name

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT product_name, COUNT(s.product_id) AS most_purchase_item
FROM sales AS s
JOIN menu AS m
    ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY 2 DESC
LIMIT 1

--5. Which item was the most popular for each customer?

WITH CTE AS
	(SELECT customer_id, product_name, count(s.product_id) AS most_purchase_item,
    dense_rank() OVER(PARTITION BY customer_id ORDER BY COUNT(s.product_id) DESC ) AS rank
    FROM sales AS s
    JOIN menu AS m
        ON s.product_id = m.product_id
	GROUP BY customer_id, product_name)
SELECT customer_id, string_agg(product_name, ', ') AS popular_product
FROM cte
WHERE rank = 1
GROUP BY customer_id

--6. Which item was purchased first by the customer after they became a premium member?

WITH CTE AS
	(SELECT s.customer_id, product_name, order_date, join_date,
     row_number() OVER(PARTITION BY s.customer_id ORDER BY order_date ASC) AS rw
     FROM sales AS s
     JOIN members AS mb
         ON s.customer_id = mb.customer_id
     JOIN menu AS m
         ON s.product_id = m.product_id
     WHERE order_date >= join_date)
SELECT customer_id, product_name
FROM cte
WHERE rw=1

--7. Which item was purchased just before the customer became a member?

WITH CTE AS
	(SELECT s.customer_id, product_name, order_date, join_date,
     dense_rank() OVER(PARTITION BY s.customer_id ORDER BY order_date DESC) AS rank
     FROM sales AS s
     JOIN members AS mb
         ON s.customer_id = mb.customer_id
     JOIN menu AS m
         ON s.product_id = m.product_id
     WHERE order_date < join_date)
SELECT customer_id, string_agg(product_name, ', ') AS product_name
FROM cte
WHERE rank=1
GROUP BY customer_id

--8. What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id, COUNT(DISTINCT s.product_id) AS total_items, SUM(price) AS amount_spent
FROM sales AS s
JOIN members AS mb
    ON s.customer_id = mb.customer_id
JOIN menu AS m
    ON s.product_id = m.product_id
WHERE order_date < join_date
GROUP BY s.customer_id
ORDER BY s.customer_id

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT customer_id,
SUM(CASE
	    WHEN product_name = 'sushi' THEN price*20
	    ELSE price*10
    END) AS points
FROM sales AS s
JOIN menu AS m
    ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id

--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH CTE AS
     (SELECT s.customer_id, product_id, order_date, join_date,
	  CAST(Join_date + interval '6 DAYS' AS date) AS first_week
      FROM sales AS s
      JOIN members AS mb
          ON s.customer_id = mb.customer_id)
SELECT customer_id,
SUM(CASE
	    WHEN product_name = 'sushi' THEN price*20
        WHEN order_date BETWEEN join_date AND first_week THEN price*20
	    ELSE price*10
    END) AS points
FROM cte AS c
JOIN menu AS m
    ON c.product_id = m.product_id
WHERE to_char(order_date, 'MM') = '01'
GROUP BY customer_id
ORDER BY customer_id

-- BONUS QUESTION:

-- Create a new table having customer_id, order_date, product_name, price.
-- Add a new column to specify if a customer is a member or not w.r.t order_date. Use 'Y' for yes and 'N' for no.
-- Add information about the ranking of customer products.
-- Note: The client purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

WITH cte AS
	(SELECT s.customer_id, order_date, product_name, price,
	 CASE
	    WHEN order_date >= join_date THEN 'Y'
	    ELSE 'N'
	 END AS member
	 FROM sales AS s
	 LEFT JOIN members AS mb
	     ON s.customer_id = mb.customer_id
	 JOIN menu AS m
	     ON s.product_id = m.product_id)
SELECT *,
CASE 
	WHEN member= 'Y' THEN dense_rank() OVER(PARTITION BY customer_id, member ORDER BY order_date)
	ELSE NULL
END AS ranking
FROM cte