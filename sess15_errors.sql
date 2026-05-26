/*Session 15 covers handling or exceptions in T-SQL scripts.*/

--Switch to the cust db database
use Cust_db;

-- Handle the above error using a try...catch block to handle division by zero '0' error and display error information
begin try
	declare @quotient int = 217 / 0; 
	select @quotient;
end try
begin catch
	Select
	ERROR_NUMBER() as 'Error Number',
	ERROR_SEVERITY() as 'Error Severity',
	ERROR_PROCEDURE() as 'Error Procedure',
	ERROR_STATE() as 'Error State',
	ERROR_MESSAGE() as 'Error Message',
	ERROR_LINE() as 'Error Line';
	-- Rollback Transaction
	If @@TRANCOUNT > 0
		rollback transaction
	Print 'Error encountered, you cannot divide by zero. Please change the denominator to a non-zero value.'
end catch

-- Practical use of try...catch and error functions in a transaction
Begin transaction
  begin try
    delete from AdventureWorks2025.Production.Product
    where ProductID = 980;
  end try
  begin catch
    select 
      ERROR_NUMBER() as 'Error Number', -- Display the error number
      ERROR_SEVERITY() as 'Error Severity', -- Display the error's severity
      ERROR_PROCEDURE() as 'Error Procedure', -- Display where the error occured
      ERROR_STATE() as 'Error State', -- Display the error state
      ERROR_MESSAGE() as 'Error Message', -- Display a preset/default error message
      ERROR_LINE() as 'Error Line'; -- Display the line where the error occured
      -- Check the content of the trancount(Transaction count) global variable
      -- and rollback any changes made when it's > 0 as the transaction failed.
      If @@TRANCOUNT > 0
        rollback transaction
      Print 'Error encountered, transaction rolled back.'
  end catch

-- Show how to display the error message for the above scenario without using dynamic sql
-- Check if the user defined procedure usp_Example exists and drop it,
-- then recreate it
if OBJECT_ID('usp_Example1','P') is not null
	drop proc usp_Example1;
Go
create proc usp_Example1
as
select * from dbo.nonexistent;
 
Begin try
	exec usp_Example1;
end try
begin catch
	--displaying the error number and message
	select 
	ERROR_NUMBER() as [Error Number],
	ERROR_SEVERITY() As 'Error Severity',
	ERROR_MESSAGE() as [Error Message]
end catch;

-- Demonstrate how to throw and catch exceptions in TSQL
if OBJECT_ID('TestThrow','U') is not null
	drop table TestThrow; 
Create table TestThrow
(
	ID int primary key
); 
-- Try to insert duplicate records
begin try
	begin transaction
	insert into dbo.TestThrow
	values
	(1),
	(1);
	commit -- Won't be reached due to duplicate PKs
end try
begin catch
	Print 'Tried to insert duplicate records'
	rollback;
	throw; -- Re-throw the error
end catch
