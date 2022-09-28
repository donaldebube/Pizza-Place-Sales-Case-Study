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

-- Types of pizza Sold in 2015
SELECT DISTINCT pizza_id
FROM OrderDetails

--Number of Pizza types sold
SELECT COUNT(DISTINCT pizza_id) AS [Total Number]
FROM OrderDetails

--Total number of Orders made
SELECT COUNT(order_id) AS [Total Orders]
FROM Orders

--Total number of Pizza Sold from Jan 1, 2015 to 31 Dec, 2015
SELECT COUNT([date]) AS [Total Number of Pizza Sold]
FROM Orders

--Total Number of Pizza Sold in 2015
SELECT DISTINCT SUM(quantity) AS [Total Pizza Sold]
FROM OrderDetails

--Total revenue throughout the year
SELECT ROUND(SUM(price), 0) AS [Total Price]
FROM Pizzas P
INNER JOIN OrderDetails OD
    ON P.pizza_id = OD.pizza_id
GO

--List of pizzas that are ordered the most with the sum of quantity ordered for the year
--Most ordered Pizzas
SELECT DISTINCT pizza_id, SUM(quantity) AS total_quantity
FROM OrderDetails
GROUP BY pizza_id
ORDER BY total_quantity DESC

--Date with the highest number of pizzas delivered
SELECT DISTINCT TOP 20  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week]
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date])
ORDER BY [quantity] DESC

--Most preferred days for customers to order throughout the year based on the quantity of orders each weekday
SELECT DISTINCT  SUM(quantity) AS [Quantity for Sunday], DATENAME([WEEKDAY],[date]) AS [Day of the Week]
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY DATENAME([WEEKDAY],[date])
HAVING 
    DATENAME([WEEKDAY],[date]) = 'Sunday' OR 
    DATENAME([WEEKDAY],[date]) = 'Monday' OR
    DATENAME([WEEKDAY],[date]) = 'Tuesday' OR
    DATENAME([WEEKDAY],[date]) = 'Wednesday' OR
    DATENAME([WEEKDAY],[date]) = 'Thursday' OR
    DATENAME([WEEKDAY],[date]) = 'Friday' OR
    DATENAME([WEEKDAY],[date]) = 'Saturday' 
ORDER BY [Quantity for Sunday] DESC
GO

--Days with the highest number of pizzas delivered
SELECT DISTINCT  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week]
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date]) 
ORDER BY [quantity] DESC

-- List of pizzas that customers do not order
SELECT DISTINCT OD.pizza_id , P.pizza_id AS [Not Ordered By Customers]
FROM OrderDetails OD
FULL OUTER JOIN Pizzas P
    ON OD.pizza_id = P.pizza_id
WHERE OD.pizza_id IS NULL

-- List of pizzas that customers do order
SELECT DISTINCT OD.pizza_id , P.pizza_id AS [Ordered]
FROM OrderDetails OD
FULL OUTER JOIN Pizzas P
    ON OD.pizza_id = P.pizza_id
WHERE OD.pizza_id IS NOT NULL

--Top most expensive Pizza Types
SELECT P.pizza_type_id, P.price,P.[size], PT.name, PT.category, SUM(OD.quantity) AS total_quantity
FROM Pizzas P
INNER JOIN PizzaTypes PT
    ON P.pizza_type_id = PT.pizza_type_id
INNER JOIN OrderDetails OD 
    ON P.pizza_id = OD.pizza_id
GROUP BY P.pizza_type_id, P.price,P.[size], PT.name, PT.category
ORDER BY total_quantity DESC

--Still keep for further analyses
SELECT P.pizza_type_id, P.price,P.[size], PT.name, PT.category
FROM Pizzas P
INNER JOIN PizzaTypes PT
    ON P.pizza_type_id = PT.pizza_type_id
ORDER BY P.price DESC

-- Total pizza quantity by the 5 different sizes
SELECT
	pizzas.size, SUM(OrderDetails.quantity) AS quantity
FROM orders 
	INNER JOIN OrderDetails
		ON orders.order_id = orderdetails.order_id
	INNER JOIN pizzas 
		ON pizzas.pizza_id = orderdetails.pizza_id
	INNER JOIN pizzatypes
		ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizzas.size
ORDER BY quantity DESC;

--% quantity for the year, for each category of pizza
SELECT
	ROUND (SUM
        (
            CASE WHEN pizzatypes.category = 'Chicken' THEN orderdetails.quantity ELSE NULL END
        )/SUM(OrderDetails.quantity) * 100,2)  AS 'Chicken %',
	ROUND (SUM
        (
            CASE WHEN pizzatypes.category = 'Classic' THEN orderdetails.quantity ELSE NULL END
        )/SUM(OrderDetails.quantity) * 100,2)  AS [Classic %],
	ROUND (SUM
        (
            CASE WHEN pizzatypes.category = 'Supreme' THEN orderdetails.quantity ELSE NULL END
        )/SUM(OrderDetails.quantity) * 100,2)   AS [Supreme %],
	ROUND (SUM
    (
        CASE WHEN pizzatypes.category = 'Veggie' THEN orderdetails.quantity ELSE NULL END
    )/SUM(OrderDetails.quantity) * 100,2)   AS 'Veggie %'
FROM orders 
	INNER JOIN orderdetails 
		ON orders.order_id = orderdetails.order_id
	INNER JOIN pizzas 
		ON pizzas.pizza_id = orderdetails.pizza_id
	INNER JOIN pizzatypes
		ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
GO

--Top 5 most expensive Pizzas with their respective quantities for the year
SELECT DISTINCT  
    PT.name AS Name, 
    ROUND(SUM(P.price), 2) AS [Total Price], 
    SUM(OD.quantity) AS [Total Quantity]
FROM OrderDetails OD
INNER JOIN Pizzas P
    ON OD.pizza_id = P.pizza_id
INNER JOIN PizzaTypes PT
    ON P.pizza_type_id = PT.pizza_type_id
GROUP BY PT.name, OD.quantity
ORDER BY [Total Price] DESC
GO

-- Revenue for each month by price
SELECT 
	MONTH(orders.date) AS Month,
	SUM(OrderDetails.quantity) AS [Total Quantity],
	ROUND(SUM(pizzas.price), 0) AS Price
FROM orders 
	INNER JOIN orderdetails 
		ON orders.order_id = orderdetails.order_id
	INNER JOIN pizzas 
		ON pizzas.pizza_id = orderdetails.pizza_id
GROUP BY MONTH(orders.date)
ORDER BY [Total Quantity] DESC
GO
