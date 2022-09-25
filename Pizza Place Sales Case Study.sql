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
SELECT DISTINCT pizza_id, SUM(quantity) AS total_quantity
FROM OrderDetails
GROUP BY pizza_id
ORDER BY total_quantity DESC

SELECT DISTINCT pizza_id,  SUM(quantity) AS quantity, COUNT([date]) AS Date
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY OD.order_id, pizza_id
ORDER BY quantity DESC