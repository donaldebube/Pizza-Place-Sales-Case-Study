-- Mannually analayse the different datasets
SELECT *
FROM OrderDetails
GO

SELECT *
FROM Orders
GO

SELECT *
FROM Pizzas
GO

SELECT *
FROM PizzaTypes


--Analysis Begins

-- Types of pizza
SELECT DISTINCT pizza_id
FROM OrderDetails

--Total number of Pizza ID
SELECT COUNT(DISTINCT pizza_id) AS [Total Number of Pizza ID]
FROM OrderDetails

--List of pizza ids that are ordered the most with the sum of quantity ordered for the year
--Most ordered Pizzas
SELECT DISTINCT pizza_id, SUM(quantity) AS total_quantity
FROM OrderDetails
GROUP BY pizza_id
ORDER BY total_quantity DESC

SELECT DISTINCT pizza_id,  SUM(quantity) AS quantity, [date]
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY  pizza_id, [date]
ORDER BY quantity DESC

-- list of pizz_id that customers do not order
SELECT DISTINCT OD.pizza_id , P.pizza_id AS [Not Ordered By Customers]
FROM OrderDetails OD
FULL OUTER JOIN Pizzas P
    ON OD.pizza_id = P.pizza_id
WHERE OD.pizza_id IS NULL