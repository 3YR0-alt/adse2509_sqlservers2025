/* This session covers working with views, stored procedures and queriying database metadata */
--Switch to the customer database
use Cust_db_adse2509;
--Demonstrate creating, modifying and deleting views
--Create a view to display the details from the Production.Product table in the AD2025 DBCreate view vwProductInfo asSelect ProductID [Product ID], ProductNumber [Product Number], [name] [ProductName], SafetyStockLevel as [Safety Stock Level]

 FROM AdventureWorks2025.Production.Product;-- Display the records returned by the Product by the Product viewSelect * from vwProductInfo

 FROM vwProductInfo
 -- Create a view to display the details from the Production. Product table in the AD2025 DB

create view vwProductInfo as

Select ProductID [Product ID], ProductNumber [Product Number], [name] [Product Name],

12

SafetyStockLevel as [Safety Stock Level]

13

from AdventureWorks2025.Production. Product;
-- Display the records returned by the ProductInfo view

I

16

Select * from vwProductInfo;
-- Get all products with lock from the ProductInfo view

19

select [Product Name]

20

from vwProductInfo

21

where [Product Name] like '%Lock%';
-- Create a view using a join to get data from multiple tables

24

-- Create a view to display the personal detials of employees using data from the HR.Employee

 From AdventureWorks2025.Person.Person P -- Person table aliasjoin AdventureWorks2025 HumanResources.Employee E --Employee aliason P.BusinessEntityID = E.BusinessEntityID;--Display all the employee personal details from the EmpDetails viewSelect * from vwEmp
--Create tables to be used as the base tables for the employee details view
create table Employee_Personal_Details
(
   EmpID int not null primary key,
   FirstName nvarchar (30) not null,
   LastName nvarchar(30) not null,
   Address nvarchar(30)
);

Create table Employee_Salary_Details
( 
   EmpID int not null Primary key,
   Designation nvarchar(30) not null,
   Salary int not null
   Foreign key (EmpID) references Employee_Personal_Details(EmpID)
);

--Insert records in the employee personal details and salary details table
insert into dbo.Employee_Personal_Details
values
(1,'Jack','Wilson','24, Park Ave.'),
(2,'Susan','Andrews','12, Hill Road'),
(3,'Jack', 'Wilson','24, Park Ave.');

insert into dbo.Employee_Salary_Details
values
(1,'Accountant', 8000),
(2,'Reviewer', 12000),
(3,'Admin', 125000);

--confirm the above record insertions
select*from dbo.Employee_Personal_Details;
select*from dbo.Employee_Salary_Details;

-- Create a view to display the employee's personal and salary details
create view vwEmpDetails as
Select PD.EmpID [Employee ID], PD.FirstName, PD.LastName, SD.Designation, SD.Salary
from Employee_Personal_Details PD
join Employee_Salary_Details SD
on PD.EmpID = SD.EmpID;

-- Display the data returned by the employee details view
select * from vwEmpDetails

--Try to insert the details of a new employee using the Employee details view
insert into vwEmpDetails
values
(2,'Jack','Wilson','Software Developer',160000);--will not work as it gets its data from multiple base table

--Create a view that will allow us to enter rows/records/tuples in the employee salary details table
create view vwEmp_Details as 
Select EmpID,FirstName, LastName, Address
from Employee_Personal_Details;

--Get/Display the records returned by the above view
Select*from vwEmp_Details;

--Add/Insert Jack Wilson's details using the 'vwEmp_Details view
Insert into vwEmp_Details
values
(4,'Jack','Wilson','New York');

--Create a product details table and its corresponding view that will be used to modify/ update records in the table
Create table Product_Details
(
    ProductID int not null,
    ProductName nvarchar(35) not null,
    Rate money not null
);

--Insert/add records into the above table
insert into Product_Details
values
(5,'DVD Writer',2250.00),
(4,'DVD Writer',1250.00),
(6,'DVD Writer',1250.00),
(2,'External Hard Drive',4250.00),
(3,'External Hard Drive',4250.00);

--Confirm table creation and record insertion
select*from Product_Details;

--TODO: Create a view called 'vwProduct_Details' to display all columns from the 'Products_Details' table. Send your statements via private chat
Create view vwProduct_Details as
select ProductID,ProductName,Rate from Product_Details;

--View all the records returned by the product details view
select * from vwProduct_Details;

--Update the prices of all DVD writers to 3k 
update vwProduct_Details
set rate = 3000
where ProductName like 'DVD Writer';

-- Modify the product details table to add a description column
alter table dbo.Product_Details
add [Description] nvarchar(MAX);-- Description in [] since its a keyword

-- Add/insert more records into the product_details table
Insert into Product_Details
values
(1, 'Hard Disk Drive', 3750,'Internal 120 GB'),
(7,	'Portable Disk Drive',5580,'Internal 500 GB'),
(8,	'Hard Disk Drive',5580,'Internal 500 GB'),
(9,	'Hard Disk Drive',3750,'Internal 120 GB'),
(10,'Portable Disk Drive',3750,'Internal 500 GB');
