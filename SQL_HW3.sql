Use Northwind
GO

--1. List all cities that have both Employees and Customers.
SELECT distinct e.City from Employees e join Customers c on e.City = c.City

--2. List all cities that have Customers but no Employee.
    --a. Use sub-query
select distinct City from Customers where City not in (select distinct City from Employees)
    --b. Do not use sub-query
select distinct c.City from Customers c left join Employees e on c.City = e.City where e.City is NULL

--3. List all products and their total order quantities throughout all orders.
select p.ProductName as [Product Name], sum(op.Quantity) as [Total Order Quantity] 
from Products p join [Order Details] op on p.ProductID = op.ProductID join Orders o on op.OrderID = o.OrderID group by p.ProductName order by p.ProductName

--4. List all Customer Cities and total products ordered by that city.
select distinct c.City as [Customer Cities], sum(Quantity) as [Total Products]
from Customers c join Orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID group by c.City 

--5. List all Customer Cities that have at least two customers.
    --a. Use union
select City
from Customers group by City having count(CustomerID) >= 2 
UNION
select City
from Customers group by City having count(CustomerID) >= 2 

    --b. Use sub-query and no union
select distinct City from Customers where City in (select City from Customers group by City having count(CustomerID) >=2)

--6. List all Customer Cities that have ordered at least two different kinds of products.
select distinct City, count(distinct od.ProductID) as [NumKindsOfProducts] from Customers c join Orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID  group by City having count(distinct ProductID) >= 2

--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
select distinct c.CustomerID, City, ShipCity, ContactName from Customers c join Orders o on c.CustomerID = o.CustomerID where c.City != o.ShipCity

--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5
    p.ProductName, sum(od.Quantity) as [Total Quantity],
    AVG(od.UnitPrice) AS AveragePrice,
    (
        SELECT TOP 1 c.City
        FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
        WHERE od.ProductID = p.ProductID
        GROUP BY c.City
        ORDER BY SUM(od.Quantity) DESC
    ) AS [Most Ordered City]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY SUM(od.Quantity) DESC;


--9. List all cities that have never ordered something but we have employees there.
    --a. Use sub-query
select e.City
from (
    select distinct City
    from Employees
) as e left join Customers c on e.City = c.City where c.City is NULL

    --b. Do not use sub-query
select distinct e.City from Employees e left join Customers c on e.City = c.City where c.City is NULL

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

SELECT top 1 e.City AS [City with most orders and most product quantity]
FROM (
    SELECT e1.City, ROW_NUMBER() OVER (ORDER BY COUNT(o1.OrderID) DESC) AS OrderRanking
    FROM Employees e1 JOIN Orders o1 ON e1.EmployeeID = o1.EmployeeID
    GROUP BY e1.City
) e
LEFT JOIN (
    SELECT c1.City, ROW_NUMBER() OVER (ORDER BY SUM(od1.Quantity) DESC) AS ProductRanking
    FROM Customers c1 JOIN Orders o2 ON c1.CustomerID = o2.CustomerID JOIN [Order Details] od1 ON o2.OrderID = od1.OrderID
    GROUP BY c1.City
) c ON e.City = c.City
where c.ProductRanking = 1 and e.OrderRanking = 1

--11. How do you remove the duplicates record of a table?
 -- We can union the table with itself, and the UNION operation would drop all duplicated records.