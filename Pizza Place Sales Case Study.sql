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


--List of pizzas that are ordered the most with the sum of quantity ordered for the year
--Most ordered Pizzas
SELECT DISTINCT pizza_id, SUM(quantity) AS total_quantity
FROM OrderDetails
GROUP BY pizza_id
ORDER BY total_quantity DESC

--Total Number of Pizza Sold in 2015
SELECT DISTINCT SUM(quantity) AS [Total Pizza Sold]
FROM OrderDetails
--GROUP BY pizza_id
--ORDER BY total_quantity DESC

--Date with the highest number of pizzas delivered
SELECT DISTINCT  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE)
ORDER BY [quantity] DESC

--Days with the highest number of pizzas delivered
SELECT DISTINCT  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week], AVG(CAST([date] AS INT))
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date])
ORDER BY [quantity] DESC

--Days with the highest number of pizzas delivered
SELECT DISTINCT  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week]
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date]) 
ORDER BY [quantity] DESC

--Add 'Day of the Week' column to Order Table

ALTER TABLE Orders
    ADD [Day of the Week]  INT /*new_column_datatype*/ NULL /*new_column_nullability*/
GO

--Get the specific days for each order



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




--Test
SELECT DISTINCT  COUNT(quantity) AS quantity, CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week], AVG(CAST([date] AS INT))
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date])
ORDER BY [date] DESC
GO

--Create a function to determine the days of each date
CREATE FUNCTION CalcWeekDay (@WkDay DATE)
RETURNS DATE
AS
BEGIN
    --DECLARE @DOB DATE -- DELETE THIS... NOT REQUIRED
    DECLARE @DATE DATE
    --SET @DOB = '10/20/1998' --DELETE THIS... NOT REQUIRED

    SET @DATE = DATENAME(WEEKDAY, @WkDay) -
                CASE
                    WHEN
                        (MONTH(@WkDay) > MONTH(GETDATE())) OR 
                        (MONTH(@WkDay) = MONTH(GETDATE())) AND 
                        (DAY(@WkDay) > DAY(GETDATE()))
                    THEN 1
                    ELSE 0
                END

    RETURN @WkDay --Change 'SELECT' to 'RETURN'
END
GO

SELECT [date], dbo.CalcWeekDay(CONVERT(DATE, [date]))
FROM Orders


--Days with the highest number of pizzas delivered
SELECT COUNT(quantity), CAST([date] AS DATE) AS date, DATENAME([WEEKDAY],[date]) AS [Day of the Week],  COUNT(DISTINCT CONVERT(nvarchar,(DATENAME([WEEKDAY],[date])))) 
FROM OrderDetails OD
INNER JOIN Orders O
    ON OD.order_id = O.order_id
GROUP BY CAST([date] AS DATE), DATENAME([WEEKDAY],[date]), quantity

