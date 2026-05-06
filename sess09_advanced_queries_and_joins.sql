/* Session09 covers grouping, aggregating data, subqueries, joins, table expressions, and pivoting & unpivoting data. */

--Switch to the AdventureWorks database
use AdventureWorks2025;

-- Demostrate the 'group by' clause in a select statement
-- Get/retrieve the number of hours per work order from the workrouting table in the production schema
select workorderid, sum(ActualResourceHRS) 'Hours Per Order'
from production.workorderrouting
group by workorderid;

-- Get/retrieve the number of hours per work order from the workrouting table in the production schema for work
-- order ids that are less than 50
select workorderid, sum(ActualResourceHRS) 'Hours Per Order'
from production.workorderrouting
where WorkOrderID < 50
group by workorderid;

-- Get the average prices of products from the product table in the production schema and group them by class
Select class, AVG(ListPrice) as 'Average List Price'
from Production. Product
group by Class;

-- Get the sum of the salesYTD column from the salesterritory table in the sales schema and group them by
-- names that start with 'N' or 'E' using the 'group by' with all
select [group], sum(salesytd) as 'Total Region Sales'
from Sales. SalesTerritory
where [group] like 'N%' or [group] like 'E%'
group by all [group];

-- Get/display the total sales in various regions from the salesterritory table in the sales schema for sales
-- less than 6M
select [group], convert(decimal(10,2), sum(salesytd)) as 'Total Region Sales'
from Sales. SalesTerritory
group by [group]
having sum(salesytd) < 6000000;

-- Get or display the total sales in countries other than 'Australia' or 'Canada' using the cube operator
select [Name], CountryRegionCode, sum(salesytd) as 'Total Region Sales'
from sales.SalesTerritory
where [Name] <> 'Australia' and [Name] not Like 'Canada'
group by [Name], CountryRegionCode with Cube;

-- Get or display the total sales in countries other than 'Australia' or 'Canada' using the 'rollup' operator (records in the resultset with be sorted/arranged in ascending order)
select [Name], CountryRegionCode, sum(salesytd) as 'Total Region Sales'
from sales.SalesTerritory
where [Name] <> 'Australia' and [Name] not like 'Canada'
group by [Name], CountryRegionCode with rollup;

-- ---------------------------------------------------------------------------
--Demonstrate Various SQL Server aggregate functions
-- ---------------------------------------------------------------------------
-- Get the average/mean price, least order quantity and highest unit price from the salesorder table in the sales schema

select AVG(unitprice) as [Average Unit Price],
MIN(Orderqty) as 'Minimum Order Quantity',
MAX(unitPricediscount) as 'Maximum Discount'
from Sales.SalesOrderDetail;

-- Get the earliest and latest order dates from the salesorderheader table in the sales sche,a
select MIN(orderdate) [Earliest Order],
MAX(orderdate) as 'Most recent Order'
from Sales.SalesOrderHeader;


-- ---------------------------------------------------------------------------
-- Demonstrate Various SQL Spatial aggregate functions
-- ---------------------------------------------------------------------------


-- Demonstrate the use of STUnion() function
select geometry::Point(251,1,4326).STUnion(geometry::Point(252,2,4326));

-- Another example of STUnion()
-- 1. Declare 2 variables of the 'geography' type to represent spatial(geographic) areas
Declare @city1 geography, @city2 geography

-- 2. Set te values of '@cityl' & '@city2' with different sets of geographic coodinates using latitude and longitude coordinates in Well-Known Text (WKT) format
set @city1 = geography::STPolyFromText('POLYGON((175.3 -41.5, 178.3 37.9, 172.8 -34.6, 175.3 -41.5))', 4326)
set @city2 = geography::STPolyFromText('POLYGON((169.3 -46.6, 174.3 41.6, 172.5 -34.6, 169.3 -46.6))', 4326)

-- 3. Create a new geography variable called '@combinedCity' using the STUnion() method to merge the shapes of '@city1' & '@city2'
declare @combinedCity geography = @city1.STUnion(@city2);

-- 4. Display the combined geography object (merged polygon) as the result of the query
select @combinedCity as 'Merged Poly of @city1 & @city2';

-- Example that merges all the living areas (geography values) for addresses in London from the Address table in the Person schemal uisn the UnionAggregate() function.
select Geography :: UnionAggregate(SpatialLocation) as 'Average Location'
from Person.Address
where city like 'London';

-- Return the smallest/minimal bounding rectangle that contains all spatial instances in the spatiallocation column in the address table in the person schema
select Geography :: EnvelopeAggregate(SpatialLocation) as 'London Area Bounds'
from Person. Address
where city like 'London';

-- Declare a table object/variable with two columns of type geometry and nvarchar
Declare @collectionDemo Table
(
Shape geometry,
ShapeType nvarchar(50)
);
--Insert Two records in the @collectionDemo variale table
insert into @collectionDemo
values
('CURVEPOLYGON(CIRCULARSTRING(2 3, 4 1, 6 3, 4 5, 2 3))' , 'Circle'),
('POLYGON((1 1, 4 1, 4 5, 1 5, 1 1))', 'Rectangle');

-- Use the CollectionAggregate() function to aggregate the circle and rectangle intoa single geometry collection.
Select geometry::CollectionAggregate(Shape) as 'Combined Shape'
from @collectionDemo;

-- Use the ConvexHullAggregate() function to get the convex hull( smallest convex polygon) that contains all the geography points from the spatiallocaiton column in the address table in the Person schea
Select Geography::ConvexHullAggregate(SpatialLocation) as 'London Coverage Area'
from Person.Address
where city like 'London'


-- Display/fetch all the records added/inserted from the dbo. SterlingEmployee table
select * from dbo. SterlingEmployee;

-- Use a self-join to get the names of employees and their managers
select A.Fname + ' ' + A.Lname as 'Employee Name',
B.Fname + ' ' + B.Lname as 'Manager Name'
from dbo.SterlingEmployee A
join -- can still use inner join
dbo.SterlingEmployee B
on A.Mngr_ID = B.Emp_ID -- Link each employee to their manager
where A.Emp_ID <> B.Emp_ID -- Optional to ensure that no employee is shown as managing themselves
order by 'Manager Name';

-- Use a self-join to get the names managers and the number of employees

Select m. Emp_ID [Manager's Emp. ID], M. Fname + ' ' + M.Lname as [Manager's Name],
count(E.emp_id) as [Number of Employees] -- count the number of employees reporting to each manager
from SterlingEmployee E--treat/assume this as the Employee Table
join SterlingEmployee M--treat/assume this as the Manager table
on E.Mngr_ID = M.Mngr_ID -- Match each employee to their manager using the manager's id I
group by m.Emp_ID,m.Fname, m.Lname -- Group results by manager's emp_id, firstname and lastname
order by [Number of Employees] desc;

-- Get a list of all products that share the same colour from the production. product table in the AW2025 database
Select P1.ProductID [Product ID], P1.Color 'Colour', P1. Name 'Product Name',
P2.ProductID 'Related Product ID', P2.Name 'Related Product Name'
from AdventureWorks2025.Production. Product P1
inner join AdventureWorks2025.Production. Product P2
on P1.Color = P2.Color and P1.ProductID < P2.ProductID
order by P1.ProductID;



-- 1. Create the products and newproducts table in the customer database
if OBJECT_ID('Products') is null
        create table NewProducts
        (
           ProductID int not null Primary Key,
           [Name] nvarchar(30) not null,
           [Type] nvarchar(30) not null,
           PurchaseDate date not null
        )

    else
    print('NewProducts Table already exists and will not be recreated.')

-- Insert values/records in both tables
Insert into Products
values
(101,'Rivets','Hardware', '2012-12-01'),
(102,'Nuts','Hardware', '2012-12-01'),
(103,'Washers','Hardware', '2011-12-01'),
(104,'Rings','Hardware', '2013-01-15'),
(105,'Paper Clips','Stationery', '2012-01-01');
 
Insert into NewProducts
values
(102,'Nuts','Hardware', '2012-12-01'),
(103,'Washers','Hardware', '2011-12-01'),
(107,'Rings','Hardware', '2013-01-15'),
(108,'Paper Clips','Stationery', '2012-01-01');

-- Display details from the products and newproducts table
select * from products;
select * from NewProducts;

-- 3. Merge the records from the NewProducts table to the Products Table
Merge into dbo.Products P1
using dbo.NewProducts P2
on P1.ProductID = P2.ProductID
when matched then update
set P1.Name = P2.Name, P1. Type = P2. Type, P1. PurchaseDate = P2.PurchaseDate
when not matched then
insert (ProductID, Name, Type, PurchaseDate)
values (P2. ProductID, P2.Name, P2. Type, P2.PurchaseDate)
when not matched by source then delete
output $action, Inserted.ProductID, Inserted.Name, Inserted. Type, Inserted. PurchaseDate,
deleted. ProductID, deleted.Name, deleted.Type, deleted.PurchaseDate;

-- Display the year and number of customers in a given using a CTE
with CTE_OrderYear
as
C

Select Year(orderdate) as OrderYear, CustomerId
from AdventureWorks2025.Sales.SalesOrderHeader

Select Orderyear, count(distinct customerid) as 'Number of customers'
from CTE_OrderYear
group by OrderYear
order by OrderYear;

--disptay the year and numder of customers in a given using d CTE with CTE_OrderYear
as
(
Select Year(orderdate) as OrderYear, CustomerId
from AdventureWorks2025.Sales.SalesOrderHeader
)
Select Orderyear, count(distinct customerid) as 'Number of customers'
from CTE_OrderYear
group by OrderYear
order by OrderYear;

-- Recursive CTE to find all employees who report directly or indirectly to a manager
-- Recursive CTE to find all employees who report directly or indirectly to a manager
with EmployeeHeirachy as
(
-- Anchor member: top-leve-manager (e.g., CEO)
Select Emp_ID, Fname, Lname, Mngr_Id
from dbo. SterlingEmployee
where Mngr_ID is null

union all

-- Recursive member: find employees who report to somenone already in the heirachy
select E.Emp_ID, E.fname, E.lname, E.mngr_ID
from dbo.SterlingEmployee E
Join EmployeeHeirachy h on E.Mngr_ID = H.Emp_ID
)
Select * from EmployeeHeirachy; -- NB: will not yeild any results as we don't have a manager who's in charge of all emplovees & Managers in the dbo.sterlingemplovee table

-- Display all the product IDs from the Production.Product table and the matching ProductIDs from the Sales.Salesorderdetails table without duplicates
select productid from Production.product
union
select productid from sales.salesorderdetail;
 
-- Display all the product IDs from the Production.Product table and the matching ProductIDs from the Sales.Salesorderdetails table with duplicates
select productid from Production.product
union all
select productid from sales.salesorderdetail;
 
-- Display all the distinct rows  from the Production.Product table that don't have matching records from the Sales.Salesorderdetails table using the except operator
select productid from Production.product
except
select productid from sales.salesorderdetail;

-- Use the pivot operator to display the above query row wise
Select top 5 'Total Sales Year to Date'
as [Grand Totals], [NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast] -- column headings/headers
from

Select top 5 [Name], salesytd
from Sales SalesTerritory

as sourcetable
pivot

sum(salesytd)
for name in ([NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast])
As PivotTable