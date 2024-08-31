/*** SQL 2 Homework ***/
Tanya Wang

/** Part 1 Answer following questions **/

/*
-- What is a result set?
	The output of a query.

-- What is the difference between Union and Union All?
	Unions keep only unique results, but Union All keeps all results.

-- What are the other Set Operators SQL Server has?
	Intersect and Except.

-- What is the difference between Union and Join?
	Union: combines multiple quires into one result set.
	Join: combines rows combines rows horizontally by matching rows based on a join condition.

-- What is the difference between INNER JOIN and FULL JOIN?
	Inner join returns only match results in both joined tables.
	Full join returns all rows of both tables, "Null" for missing data.

-- What is difference between left join and outer join
	Left Join returns all rows from the left table and matched rows from the right table. NULL values are returned for unmatched columns from the right table.
	Outer Join returns all matched rows from either left or right table.
	
-- What is cross join?
	Returns all possible combinations of rows from the two tables.

-- What is the difference between WHERE clause and HAVING clause?
	The WHERE clause applies to individual rows.
	The HAVING clause applies to groups as a whole, and can be used with aggregate functions.

-- Can there be multiple group by columns?
	Yes, by using Group By, results can be grouped by each unique combination of values.
	*/


/** Part 2 Write queries for following scenarios **/

/* Select master Database */
Use master
Go
 

SELECT *
FROM Products; 

/* Query 1
How many products can you find in the Products table?
*/
SELECT COUNT(*) AS ProductCounts
FROM Products;

/* Query 2
Write a query that retrieves the number of products in the Products table that are out of stock. 
The rows that have 0 in column UnitsInStock are considered to be out of stock. 
*/
SELECT COUNT(*) AS OutOfStock
FROM Products
WHERE UnitsInStock = 0;


/* Query 3
How many Products reside in each Category? Write a query to display the results with the following titles.
CategoryID CountedProducts
---------- ---------------
*/
SELECT CategoryID, COUNT(*) AS CountedProducts
FROM Products
Group By CategoryID;


/* Query 4
How many products that are not in category 6. 
*/
SELECT COUNT(*)
FROM Products
WHERE CategoryID <> 6;


/* Query 5
Write a query to list the sum of products UnitsInStock in Products table.
*/
SELECT SUM(UnitsInStock) AS TotalUnitsInStock
FROM Products;


/* Query 6 
Write a query to list the sum of products by category in the Products table 
and UnitPrice over 25 and limit the result to include just summarized quantities larger than 10.
CategoryID			TheSum
-----------        ----------
*/
SELECT CategoryID, SUM(UnitsInStock) AS CategorySum
FROM Products
WHERE UnitPrice>25 
GROUP BY CategoryID
HAVING SUM(UnitsInStock) >10 ;


/* Query 7
Write a query to list the sum of products with productID by category in the Products table 
and UnitPrice over 25 and limit the result to include just summarized quantities larger than 10.
ProductID  CategoryID	  TheSum
---------- -----------    -----------
*/
SELECT CategoryID, ProductID, SUM(UnitsInStock) AS CategorySum
FROM Products
WHERE UnitPrice>25 
GROUP BY CategoryID, ProductID
HAVING SUM(UnitsInStock) >10 ;


/* Query 8
Write the query to list the average UnitsInStock for products 
where column CategoryID has the value of 2 from the table Products.
*/
SELECT AVG(UnitsInStock) AS TheAvg
FROM Products
WHERE CategoryID = 2;


/* Query 9
Write query to see the average quantity of products by Category from the table Products.
CategoryID      TheAvg
----------    -----------
*/
SELECT CategoryID, AVG(UnitsInStock) AS TheAvg
FROM Products
GROUP BY CategoryID;


/* Query 10
Write query  to see the average quantity  of  products by Category and product id
excluding rows that has the value of 1 in the column Discontinued from the table Products
ProductID   CategoryID   TheAvg
----------- ----------   -----------
*/
SELECT ProductID, CategoryID, AVG(UnitsInStock) AS TheAvg
FROM Products
WHERE Discontinued <> 1
GROUP BY ProductID, CategoryID;


/* Query 11
List the number of members (rows) and average UnitPrice in the Products table. 
This should be grouped independently over the SupplierID and the CategoryID column. Exclude the discountinued products (discountinue = 1)
SupplierID      CategoryID		TheCount   		AvgPrice
--------------	------------ 	----------- 	---------------------
*/
SELECT SupplierID, CategoryID, COUNT(*) AS TheCount, AVG(UnitPrice) AS AvgPrice
FROM Products
WHERE Discontinued <> 1
GROUP BY SupplierID, CategoryID;


-- Joins
-- Using Northwnd Database: (Use aliases for all the Joins)
Use Northwind
GO



/* Query 12
Write a query that lists the Territories and Regions names from Territories and Region tables. 
Join them and produce a result set similar to the following. 
Territory           Region
---------         ----------------------
*/
SELECT t.TerritoryDescription, r.RegionDescription
FROM Territories t
JOIN Region r on t.RegionID = r.RegionID;


/* Query 13
Write a query that lists the Territories and Regions names from Territories and Region tables. 
and list the Territories filter them by Eastern and Northern. Join them and produce a result set similar to the following.
Territory           Region
---------     ----------------------
*/
SELECT t.TerritoryDescription, r.RegionDescription
FROM Territories t
JOIN Region r on t.RegionID = r.RegionID
WHERE r.RegionDescription IN ('Eastern', 'Northern')
ORDER BY t.TerritoryDescription;


/* Query 14
List all Products that has been sold at least once in last 25 years.
*/
SELECT DISTINCT p.ProductName
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN  Orders o ON od.OrderID = o.OrderID
WHERE DATEDIFF(YEAR, o.OrderDate, GETDATE()) <= 25;

/* List all Products that has been sold at least once in last 25 years with quantity
SELECT DISTINCT p.ProductName, SUM(od.Quantity) AS TotalQuantity
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN  Orders o ON od.OrderID = o.OrderID
WHERE DATEDIFF(YEAR, o.OrderDate, GETDATE()) <= 25
GROUP BY p.ProductName;
*/


/* Query 15
List top 5 locations (Zip Code) where the products sold most.
*/
SELECT TOP 5 o.ShipPostalCode AS ZipCode, COUNT(*) AS ProductsSold
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY ProductsSold DESC;


/* Query 16
List top 5 locations (Zip Code) where the products sold most in last 25 years.
*/
SELECT TOP 5 o.ShipPostalCode AS ZipCode, COUNT(*) AS ProductsSold
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(YEAR, o.OrderDate, GETDATE()) <= 25
GROUP BY o.ShipPostalCode
ORDER BY ProductsSold DESC;



/* Query 17
List all city names and number of customers in that city. 
*/
SELECT City, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City;



/* Query 18
List city names which have more than 2 customers, and number of customers in that city 
*/
SELECT City, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City
HAVING COUNT(*) > 2;


/* Query 19
List the names of customers who placed orders after 1/1/98 with order date.
*/
SELECT c.ContactName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01';



/* Query 20
List the names of all customers with most recent order dates 
*/
SELECT c.ContactName, MAX(o.OrderDate) AS LastOrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY LastOrderDate DESC;


/* Query 21
Display the names of all customers along with the count of products they bought
*/
SELECT 
    c.ContactName, 
    COUNT(od.ProductID) AS ProductCount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    c.ContactName;



/* Query 22
Display the customer ids who bought more than 100 Products with count of products.
*/
SELECT 
    c.CustomerID, 
    COUNT(od.ProductID) AS ProductCount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID
HAVING 
    COUNT(od.ProductID) > 100;



/* Query 23
List all of the possible ways that suppliers can ship their products. Display the results as below
Supplier Company Name   	Shipping Company Name
----------------------      ----------------------------------
*/
SELECT 
    s.CompanyName AS SupplierCompanyName, 
    sh.CompanyName AS ShippingCompanyName
FROM 
    Suppliers s
JOIN 
    Shippers sh ON 1=1;



/* Query 24
Display the products order each day. Show Order date and Product Name.
*/
SELECT 
    o.OrderDate, 
    p.ProductName
FROM 
    Orders o
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
ORDER BY 
    o.OrderDate;



/* Query 25
Displays pairs of employees who have the same job title.
*/
SELECT 
    e1.FirstName + ' ' + e1.LastName AS Employee1, 
    e2.FirstName + ' ' + e2.LastName AS Employee2, 
    e1.Title
FROM 
    Employees e1
JOIN 
    Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID;


/* Query 26
Display all the Managers who have more than 2 employees reporting to them.
*/
SELECT e1.EmployeeID, e1.FirstName + ' ' + e1.LastName AS ManagerName, COUNT(e2.EmployeeID) AS NumOfReports
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID, e1.FirstName, e1.LastName
HAVING COUNT(e2.EmployeeID) > 2;


/* Query 27
Display the customers and suppliers by city. The results should have the following columns
City 
Name 
Contact Name,
Type (Customer or Supplier)
*/
SELECT City, CompanyName AS Name, ContactName, 'Customer' AS Type
FROM Customers
UNION
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM Suppliers
ORDER BY City, Type;



/* Query 28
For example, you have two exactly the same tables T1 and T2 with two columns F1 and F2
	F1	F2
	--- ---
	1	2
	2	3
	3	4
Please write a query to inner join these two tables and write down the result of this query.
*/
SELECT t1.F1, t1.F2
FROM T1 t1
INNER JOIN T2 t2 ON t1.F1 = t2.F1 AND t1.F2 = t2.F2;


/* Query 29
Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
*/
SELECT t1.F1, t1.F2, t2.F1, t2.F2
FROM T1 t1
LEFT OUTER JOIN T2 t2 ON t1.F1 = t2.F1 AND t1.F2 = t2.F2;

