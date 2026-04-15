--This script introduces us to SQL server and T-SQL(transact sequel)

--Switch/choose the adventureworks2025
use AdventureWorks2025;

--Fetch/get/retrieve the top 10 rows from the shift table in the HR scheme
Select top 10 [name]
From HumanResources.Shift;