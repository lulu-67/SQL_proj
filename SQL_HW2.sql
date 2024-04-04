Use AdventureWorks2019
go 

-- 1. How many products can you find in the Production.Product table?
select count(distinct ProductID) as NumOfProducts from Production.Product

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
select count(distinct ProductID) as NumOfProductsThatAreIncludedInASubcategory from Production.Product where ProductSubcategoryID is not null 

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
select ProductSubcategoryID, COUNT(distinct ProductID) as CountedProducts from Production.Product where ProductSubcategoryID is not NULL group by ProductSubcategoryID

-- 4. How many products that do not have a product subcategory.
select COUNT(distinct ProductID) as NumOfNoSubcategory from Production.Product where ProductSubcategoryID is null 

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
select SUM(quantity) from Production.ProductInventory

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(quantity) as TheSum from Production.ProductInventory where LocationID = 40 GROUP by ProductID having sum(Quantity) < 100

-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(quantity) as TheSum from Production.ProductInventory where LocationID = 40 GROUP by Shelf, ProductID having sum(Quantity) < 100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
select AVG(Quantity) from Production.ProductInventory where LocationID = 10

-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
select ProductID, Shelf, AVG(quantity) as TheAvg from Production.ProductInventory group by ProductID, Shelf

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
select ProductID, Shelf, AVG(quantity) as TheAvg from Production.ProductInventory where shelf <> 'N/A' group by ProductID, Shelf

--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
Select Color, Class, COUNT(ProductID) as TheCount, AVG(ListPrice) as AvgPrice from Production.Product where Color is not null and Class is not NULL group by Color, Class

--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province from Person.CountryRegion cr join Person.StateProvince sp on cr.CountryRegionCode = sp.CountryRegionCode

--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name as Country, sp.Name as Province from Person.CountryRegion cr join Person.StateProvince sp on cr.CountryRegionCode = sp.CountryRegionCode where cr.Name in ('Canada', 'Germany')

--14. List all Products that has been sold at least once in last 25 years.
Use Northwind 
Go

SELECT Distinct ProductID FROM dbo.[Orders] o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID WHERE o.OrderDate <= DATEADD(YEAR, -25, GETDATE()) order by ProductID

--15. List top 5 locations (Zip Code) where the products sold most.
SELECT ShipPostalCode, OrderCount, Rank
FROM (
    SELECT ShipPostalCode, COUNT(OrderID) AS OrderCount, DENSE_RANK() OVER (ORDER BY COUNT(OrderID) DESC) as Rank
    FROM dbo.Orders
    GROUP BY ShipPostalCode
) AS RankedOrders
WHERE Rank <= 5;

--16.  List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT ShipPostalCode, OrderCount, Rank
FROM (
    SELECT o.ShipPostalCode, COUNT(o.OrderID) AS OrderCount, DENSE_RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) as Rank
    FROM dbo.Orders o WHERE o.OrderDate <= DATEADD(YEAR, -25, GETDATE())
    GROUP BY o.ShipPostalCode
) AS RankedOrders
WHERE Rank <= 5;

--17. List all city names and number of customers in that city.     
SELECT distinct ShipCity, count(distinct CustomerID) as Num_Of_Customer from dbo.Orders group by ShipCity

--18. List city names which have more than 2 customers, and number of customers in that city
SELECT distinct ShipCity, count(distinct CustomerID) as Num_Of_Customer from dbo.Orders group by ShipCity having count(distinct CustomerID) >2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT distinct c.ContactName AS Name FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderDate < '1998-01-01';

--20. List the names of all customers with most recent order dates
select c.ContactName As Name from dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderDate in (select max(OrderDate) from dbo.Orders)

--21. Display the names of all customers  along with the  count of products they bought
select c.ContactName As Name, sum(od.Quantity) as Count_Of_Products 
from dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od on o.OrderID = od.OrderID
group by c.ContactName

--22. Display the customer ids who bought more than 100 Products with count of products.
select o.CustomerID, sum(od.Quantity) as [Count of Products]
from Orders o join dbo.[Order Details] od on o.OrderID = od.OrderID group by o.CustomerID having sum(od.Quantity) > 100 

--23. List all of the possible ways that suppliers can ship their products. Display the results as below
select supp.CompanyName as [Supplier Company Name], ship.CompanyName as [Shipping Company Name] from dbo.Shippers ship cross join dbo.Suppliers supp

--24. Display the products order each day. Show Order date and Product Name.
select o.OrderDate, p.ProductName from dbo.Orders o join dbo.[Order Details] od on o.OrderID = od.OrderID join dbo.Products p on od.ProductID = p.ProductID

--25. Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' + e1.LastName as FirstEmployee, e2.FirstName + ' ' + e2.LastName as SecondEmployee
From dbo.Employees e1 join dbo.Employees e2 on e1.Title = e2.Title where e1.EmployeeID != e2.EmployeeID

--26. Display all the Managers who have more than 2 employees reporting to them.
SELECT e2.FirstName + ' ' + e2.LastName AS ManagerName FROM dbo.Employees e1
JOIN dbo.Employees e2 ON e1.ReportsTo = e2.EmployeeID GROUP BY e2.FirstName, e2.LastName HAVING COUNT(*) > 2;

--27. Display the customers and suppliers by city. The results should have the following columns
select City, CompanyName as Name, ContactName as [Contact Name], 'Customer' Type
from dbo.Customers
Union 
select City, CompanyName as Name, ContactName as [Contact Name], 'Supplier' Type
from dbo.Suppliers