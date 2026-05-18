/*This session covers how to work with indexes/indeces in SQL server.*/

--Switch to cust db
use Cust_db;

-- ------------------------------------------------------------------------------
-- Demonstrate creating, modifying and deleting indexes
-- ------------------------------------------------------------------------------
--1. Create an Employee_details table
Create table Employee_Details
 (
        EmpID int not null identity(1001,1) primary key,
        AccNo nvarchar(10) not null,
        AccName nvarchar(180) not null,
        Country nvarchar(70) not null
 );
else
   print('The ''Employee_Details'' table already exists and will not be recreated')

--2. Insert/add rows into the Employee_Details table
Insert into dbo.Cust_Details
(AccNo,AccName,Country)
values
('CN001','John Keena', 'Spain'),
('CN020','Smith Jones', 'Russia'),
('CN011','Albert Walker', 'Germany'),
('CN021','Rosa Stines', 'Italy');

--Get all the values store in the 'Cust_Details' table
select*from Cust_Details;

--3.Create a non-clustered index on the country field
create index ixCountry on Cust_Details(Country);

--Create a clustered index on the productID field of the product_details table
Create clustered index ix_ProductID on dbo.product_details(ProductID);

--Create a non-clustered index on the city field in the 'Customer_Details'
create index ixCity on Customer_Details(City);

--TODO:Execute the code from line 40 and below as well as line 33 and above as soon as the code for 'CricketTeam' as well as 'Cust_details' is recovered

--Add a primary key constraint to the 'CricketTeam' table
Alter table dbo.Cricketteam
add constraint PK_TeamID primary key clustered(TeamID);

--Create a primary xml index on the 'CricketTeam' table on the teaminfo column/field.
Create primary xml index PXML_Teaminfo
on dbo.CricketTeam(Teaminfo)

--Create a secondary index for value() => optimises value() method which is useful when extracting scalar values
Create XML Index SXML_TeamInfo_Value
on dbo.CricketTeam(Teaminfo)
Using XML Index PXML_Teaminfo
for Value;

--Create a secondary index for path => optimises exists() method and path based lookups
Create XML Index SXML_TeamInfo_Value
on dbo.CricketTeam(Teaminfo)
Using XML Index PXML_Teaminfo
for Path;

--Create a secondary index for Property => best used with typed xml comuns (the teaminfor column is using the CricketSchemaCollection xsd)
Create XML Index SXML_TeamInfo_Value
on dbo.CricketTeam(Teaminfo)
Using XML Index PXML_Teaminfo
for Property;

--TODO: 1. Create a non-clustered index on the product name field in the 'Product_Details' table.