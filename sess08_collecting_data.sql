/*Session 08 covers retrieving/fetching/getting data from an SQL Server Database,
working with typed and untyped XML and XML schemas.*/

--Demonstrate the use of the 'SELECT' clause without a 'FROM'
--pick off/get the first 5 characters from the word 'International'
select Left('International',5) as [First 5 Characters];

--pick off/get the last 7 characters from the word 'International'
select Right('International',7) as [First 7 Characters];

--Do some basic math using 'SELECT' clause
slect (7+5) as [Sum of 7 and 5];

--Switch to the ADVENTURE WORKS Database
Use AdventureWorks2025;

--Use the 'Asterisk *' with a select clause to display all columns in the employee table in the HR schematics
select*from HumanResources.Employee;

--Display the 'locationid' and 'costrate' from the location table in the production schematics
select locationid, costrate from Production.Location;

--When currently working with another database, use the fully qualified name as shown below
select*from AdventureWorks2025.HumanResources.Employee;

--Display the 'name' and 'regioncode' from the salesterritory table in the sales schematic
select [Name], countryregioncode from sales.SalesTerritory;

--Format the above query using constants
select [Name] + ' :' + [countryregioncode] + ' -->' + [group] as [Country Region and Code]
from sales.SalesTerritory;

-- Rename a column name using the as clause
USE AdventureWorks2025
SELECT ModifiedDate as 'ChangedDate' FROM Person.Person
GO