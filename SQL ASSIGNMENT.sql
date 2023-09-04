create database Customers_Orders_Products;
use Customers_Orders_Products;

CREATE TABLE Customers 
(CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100));

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');
  ------------------------------------------------------------------------------
  CREATE TABLE Orders 
  (OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);
  ---------------------------------------------------------------------------------
  CREATE TABLE Products 
  (ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2));

  INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);
-----------------------------------------------------------------------------------
select * from Customers;
select * from orders;
select * from products;
-----------------------------------------------------------------------------------
-------------------------------------TASK 1 ----------------------------------------------------
--Write a query to retrieve the names and email addresses of customers whose names start with 'J'.
select Name, Email from Customers where name like 'j%'

--Write a query to retrieve the order details (OrderID, ProductName, Quantity) for all orders.
select OrderID, ProductName, Quantity from orders;

--Write a query to calculate the total quantity of products ordered.
select sum(Quantity) as total_quantity from Orders;            -- sum, count doubt

--Write a query to retrieve the names of customers who have placed an order
SELECT distinct c.Name
FROM customers as c
JOIN orders as o ON c.CustomerID = o.CustomerID;

--Write a query to retrieve the products with a price greater than $10.00
select ProductName from Products where Price > 10;

--Write a query to retrieve the customer name and order date for all orders placed on or after '2023-07-05' 
select c.Name , o.OrderDate from Customers as c
join Orders as o on c.CustomerID = o.OrderID                        -- ERROR
where o.OrderDate >= 2023-07-05;

--Write a query to calculate the average price of all products
select avg(Price) as avg_price from Products;

--Write a query to retrieve the customer names along with the total quantity of products they have ordered
select C.Name , O.Quantity as total_quantity from Customers as C     -- ask query 
join Orders as O 
on C.CustomerID = O.OrderID

--Write a query to retrieve the products that have not been ordered.
select ProductName from Products where ProductID is null             --ask query

--------------------------------------TASK 2 ----------------------------------------------------------
--Write a query to retrieve the top 5 customers who have placed the highest total quantity of orders.
SELECT TOP 5 C.Name, sum(Quantity) as total_quantity
from Customers as C 
inner join Orders as O 
on C.CustomerID = O.CustomerID
group by C.Name
order by total_quantity desc

--Write a query to calculate the average price of products for each product category.
select ProductName,avg(Price) as avg_price
from Products
group by ProductName;

--Write a query to retrieve the customers who have not placed any orders.
SELECT C.Name                                     
FROM Customers as C                                        
where not exists (select 1 from Orders as O where O.CustomerID = C.CustomerID);

--Write a query to retrieve the order details (OrderID, ProductName, Quantity) for orders placed by customers whose names start with 'M'
select OrderID , ProductName , Quantity from Orders as O 
join Customers as C 
on O.CustomerID = C.CustomerID
where Name like 'M%';

--Write a query to calculate the total revenue generated from all orders.
select sum(Quantity*Price) as total_price from Products as P
inner join Orders as O
on P.ProductName = O.ProductName;

--Write a query to retrieve the customer names along with the total revenue generated from their orders.
SELECT C.Name, SUM(O.Quantity * P.Price) AS total_revenue                        --ERROR
FROM Customers as C
inner jOIN orders as O ON C.CustomerID = O.CustomerID
inner JOIN Products as P ON P.ProductName = O.ProductName
GROUP BY C.Name;

--Write a query to retrieve the customers who have placed at least one order for each product category.
select Name from Customers as C                             
join Orders as O 
on C.CustomerID = O.CustomerID
where Quantity >= 1

--Write a query to retrieve the customers who have placed orders on consecutive days.
select C.Name from Customers as C
inner join Orders as O1
on C.CustomerID = O1.CustomerID
inner join Orders as O2
on C.CustomerID = O2.CustomerID
where DATEDIFF(day,O1.OrderDate,O2.OrderDate) = 1

--Write a query to retrieve the top 3 products with the highest average quantity ordered
select top 3 ProductName from Orders                               --ERROR
where avg(Quantity) 

--Write a query to calculate the percentage of orders that have a quantity greater than the average quantity.
select(count(case when O.Quantity > avg.Quantity then 1 end)*100.0)/
count(*) as percentage from Orders as O cross join 
(select avg(Quantity) as Quantity from Orders) avg

-----------------------------------------TASK 3 ------------------------------------------------------------
--Write a query to retrieve the customers who have placed orders for all products.
SELECT c.CustomerID, c.Name FROM Customers as c WHERE NOT EXISTS
( SELECT 1 FROM Products as p WHERE NOT EXISTS ( SELECT 1 FROM Orders as o WHERE o.CustomerID = c.CustomerID
AND o.ProductName = p.ProductName ) ); 

--Write a query to retrieve the products that have been ordered by all customers.
SELECT p.ProductName FROM Products p WHERE NOT EXISTS ( SELECT 1 FROM Customers c WHERE NOT EXISTS 
( SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID AND o.ProductName = p.ProductName ) ); 

--Write a query to calculate the total revenue generated from orders placed in each month
SELECT DATEPART(MONTH, o.OrderDate) AS Month, SUM(o.Quantity * p.Price) AS TotalRevenue FROM Orders o 
INNER JOIN Products p ON p.ProductName = o.ProductName GROUP BY DATEPART(MONTH, o.OrderDate); 

--Write a query to retrieve the products that have been ordered by more than 50% of the customers
SELECT p.ProductName FROM Products p INNER JOIN Orders o ON p.ProductName = o.ProductName 
GROUP BY p.ProductName HAVING COUNT(DISTINCT o.CustomerID) > (SELECT COUNT(*) * 0.5 FROM Customers)

--Write a query to retrieve the customers who have placed orders for all products in a specific category.
SELECT c.CustomerID, c.Name FROM Customers c WHERE NOT EXISTS ( SELECT 1 FROM Products p WHERE p.Category = 'CategoryName'
AND NOT EXISTS ( SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID AND o.ProductName = p.ProductName ) ); 

--Write a query to retrieve the top 5 customers who have spent the highest amount of money on orders
SELECT TOP 5 c.Name, SUM(p.Price * o.Quantity) AS TotalAmount FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN Products p ON o.ProductName = p.ProductName GROUP BY c.Name ORDER BY TotalAmount DESC; 

--Write a query to calculate the running total of order quantities for each customer
SELECT c.Name, o.OrderID, o.Quantity, SUM(o.Quantity) 
OVER (PARTITION BY c.CustomerID ORDER BY o.OrderID) AS RunningTotal FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID; 

--Write a query to retrieve the top 3 most recent orders for each customer.
SELECT c.Name, o.OrderID, o.OrderDate FROM Customers c 
INNER JOIN ( SELECT OrderID, CustomerID, OrderDate, ROW_NUMBER() 
OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum FROM Orders ) o 
ON c.CustomerID = o.CustomerID WHERE o.RowNum <= 3; 

--Write a query to calculate the total revenue generated by each customer in the last 30 days.
SELECT c.Name, SUM(p.Price * o.Quantity) AS TotalRevenue FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN Products p ON o.ProductName = p.ProductName
WHERE o.OrderDate >= DATEADD(DAY, -30, GETDATE()) GROUP BY c.Name; 

--Write a query to retrieve the customers who have placed orders for at least two different product categories.
SELECT c.CustomerID, c.Name FROM Customers c INNER JOIN ( SELECT CustomerID FROM Orders
GROUP BY CustomerID HAVING COUNT(DISTINCT ProductName) >= 2 ) o ON c.CustomerID = o.CustomerID; 

--Write a query to calculate the average revenue per order for each customer
SELECT c.Name, AVG(p.Price * o.Quantity) AS AverageRevenue FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN Products p ON o.ProductName = p.ProductName GROUP BY c.Name; 

--Write a query to retrieve the products that have been ordered by customers from a specific country.
SELECT p.ProductName FROM Products p INNER JOIN Orders o ON p.ProductName = o.ProductName
INNER JOIN Customers c ON o.CustomerID = c.CustomerID WHERE c.Country = 'CountryName'; 

--Write a query to retrieve the customers who have placed orders for every month of a specific year
SELECT c.CustomerID, c.Name FROM Customers c 
WHERE NOT EXISTS ( SELECT 1 FROM ( SELECT DISTINCT DATEPART(MONTH, OrderDate) AS Month FROM Orders 
WHERE DATEPART(YEAR, OrderDate) = 2023 ) m
WHERE NOT EXISTS ( SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID AND DATEPART(MONTH, o.OrderDate) = m.Month ) ); 

--Write a query to retrieve the customers who have placed orders for a specific product in consecutive months.
SELECT c.Name FROM Customers c INNER JOIN Orders o1 ON c.CustomerID = o1.CustomerID 
INNER JOIN Orders o2 ON c.CustomerID = o2.CustomerID
WHERE o1.ProductName = 'ProductName' AND o2.ProductName = 'ProductName' AND DATEDIFF(MONTH, o1.OrderDate, o2.OrderDate) = 1; 

--Write a query to retrieve the products that have been ordered by a specific customer at least twice
SELECT p.ProductName FROM Products p 
INNER JOIN Orders o ON p.ProductName = o.ProductName 
WHERE o.CustomerID = 1 GROUP BY p.ProductName HAVING COUNT(*) >= 2;

