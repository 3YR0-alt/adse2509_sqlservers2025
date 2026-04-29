from sales. SalesTerritory;

-- Rename a column name using the as clause
USE AdventureWorks2025
SELECT ModifiedDate as 'ChangedDate' FROM Person. Person
GO

-- Demonstrate calculations on table columns
-- Get a 15% discount of the standardcost from the productcosthistory table in the production schema
select ProductID, StandardCost, StandardCost * .15 as [Discount Amount]
from Production. ProductCostHistory; 

/*Re-write the above query to display the same fields/columns plus Discount price.
for each monetary column, results are displayed correct to 2 d.p. */
select ProductID, convert(decimal(10,2) StandardCost) as [Standard Cost], convert(decimal
(10,2), (StandardCost * .15)) as [Discount Amount], convert(decimal(10,2), StandardCost)
convert(decimal(10,2), (StandardCost * .15)) as [Discounted Price]
from Production ProductCostHistory;

--Display all the standardcosts from the productcosthistory table in the production schema
select StandardCost as [Standard Cost]
from Production.ProductCostHistory;

-- Display only the distinct standardcosts from the productcosthistory table in the production schema
select distinct StandardCost as [Standard Cost]
from Production.ProductCostHistory;

-- Display only the 1st five distinct standardcosts from the productcosthistory table in the production schema
select distinct top 5 StandardCost as [Standard Cost]
from Production. ProductCostHistory;

-- Display the five highest distinct standardcosts from the productcosthistory table in the production schema
select distinct top 5 StandardCost as [Standard Cost]
from Production. ProductCostHistory
order by [Standard Cost] desc;

-- Display the five lowest distinct standardcosts from the productcosthistory table in the
production schema
select distinct top 5 StandardCost as [Standard Cost]
from Production.ProductCostHistory
order by [Standard Cost];

--Switch to the customer database
use Cust_db;

--Get/fetch records from one table in ADS2025 and insert/add them into a new table in the customer database
select ProductModelID , Name -- Columns to get values from
into Cust_db.dbo.ProductName -- Destination table where rows/ tubles wil[dbo].[StoreProduct]l be inserted
from AdventureWorks2025.Production.ProductModel;

-- Confirm whether the table above was created and the records inserted
Select *
from Cust_db.dbo.ProductName;

--Filtering records using the 'Where' clause
--Fetch records whose end date (completion date) is 29th May
Select *
from Production.productcosthistory
where enddate = '2012-05-29 12:00:00 AM' ; --same as 'where enddate = '5/29/2012 12:00:00

-- Get all the details of the departments with an id less than 10
select *
from HumanResources.Department
where departmentid < 10;

-- Display all the details of individuals whose suffix starts with 'jr' followed by a
single character
select *
from Person person
where suffix like 'Jr_';

--Display the title, firstname, and lastname of people whose title is 'Mr.' or 'Ms.'
select title, firstname, lastname
from Person.person
where title like 'M_.';-- can be written as 'where title like 'Mr.' or title like 'Ms.' "

--Display the BusinessEntityID and names of individuals whose last names start with letter 'B'
select BusinessEntityID, CONCAT(firstname, ' ' , middlename) as [Firstname and Initial], lastname
from Person.person
where lastname like 'B%';

-- Fetch/retrieve all details of transaction from usd to canadian dollars or chinese yuan
select *
from sales.currencyrate
where tocurrencycode like 'c[an][dy]';

-- Fetch/retrieve all details of transaction from usd to currencies starting with 'A' and not followed by an 'r' or an 's'
select *
from sales.currencyrate
where tocurrencycode like 'a[^r][^s]';

-- Demostrate the 'group by' clause in a select statement
-- Get/retrieve the number of hours per work order from the workrouting table in the production schema
select workorderid, sum(ActualResourceHRS) 'Hours Per Order'
from production.workorderrouting
group by workorderid
order by 'Hours Per Order' desc;

-- Demonstrate the use of the 'order by' clause to arrange/sort the results in
-- a) ascending order (default)
-- b) descending order
-- Display all records from the salesterritory tabe in the sales schema arranged by the saleslastyear column from the least to the greatest (ascending order)
Select *
from sales.salesterritory
order by salesLastyear;

-- Individual assignment
-- TODO : 01. Get all the details of individuals from Bothel city in the address table in the Person schema

-- TODO : 02. Get allIthe details where the addressid is more than 900 or the addresstype is 5 in the businessEntityaddress table in the Person schema






--Create and register an xml schema
CREATE XML SCHEMA COLLECTION

-- Create a CricketTeam table with an XML type column and specify the above schema will be used to validate the column
Create table CricketTeam
(
TeamID int identity not null,
TeamInfo xml(CricketSchemaCollection)
);

-- Insert/add data to the CricketTeam table
insert into CricketTeam (TeamInfo)
values
(

'<MatchDetails>
   <Team country="Australia" score="355"></Team>
   <Team country="Zimbambwe" score="475"></Team>
   <Team country="England" score="200"></Team>
</MatchDetails>'

);

-- Create a typed xml variable using the 'CricketSchemaCollection' schema
Declare @team xml(CricketSchemaCollection)
Set @team = '<MatchDetails><Team country="Australia"></Team></MatchDetails>'
Select @team as 'Team';

-- Demonstrate the use of exist() method
Select TeamID
from CricketTeam
where TeamInfo.exist('(/MatchDetails/Team)') = 1;

-- Demonstrate the use of query() method
Select TeamInfo.query('(/MatchDetails/Team)')As info
from CricketTeam;

-- Demonstrate the use of value() method
Select TeamInfo. value('(/MatchDetails/Team/@score) [1]', 'varchar(20)') as 'Score'
from CricketTeam
where TeamID = 1;
