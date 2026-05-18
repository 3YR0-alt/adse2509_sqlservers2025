/*Session 12 covers database and table triggers i.e., how to create, modify, and delete DB & table triggers. */

--Switch to the cust_db database
use Cust_db;

--Create the employee table 'tbEmployee' if it doesnt exist
if not exists
(select* from INFORMATION_SCHEMA.TABLES where TABLE_NAME like 'tbEmployee')
Begin
   CREATE Table tblEmployee
   (
      EmpID int not null primary key,
      Names nvarchar(150) not null,
      Salary decimal(10,2) not null,
      HomeTown nvarchar(80) not null
   )
End;

--Insert/add records to the 'tbEmployee' table
insert into dbo.tblEmployee
values
(1, 'Rashley Mumbua', 135000.00, 'Ahero'),
(2, 'Moses Mapena', 20000.00, 'Arusha'),
(3, 'Francis Xavier', 70000.00, 'Sportsview'),
(4, 'Valentine Miranda', 100000.00, 'juja'),
(5, 'Alexander Ntumba', 115000.00, 'Westlands'),
(6, 'Mohammed Said', 120000.00, 'Eastleigh'),
(7, 'Yonatan Teka', 300000.00, 'Mahutuni'),
(8, 'Zakaria Yussuf', 200000.00, 'South B'),
(9, 'Mathew Muindi', 250000.00, 'Millimani');

--Confirm the inertion of the above records
Select*from tblEmployee;

--Delete the 1st record from the 'tblEmployee' table
delete 
from tblEmployee
where EmpID = 1;

--Create an insert trigger on the 'tblEmployee' table to prevent insert of salary amounts less 15000
Create trigger trg_minSalary
on dbo.tblEmployee
for insert
as
if(select salary from inserted) < 15000
Begin
   Print 'Sorry, you cannot pay employees less than 15000 as its below the minimum statutory wage!'
   rollback
End;

--Insert a record that will violate the minimum wage statutory law
insert into dbo.tblEmployee
values
(1, 'Nyanjui Arthur', 13500.00, 'Limuru');

--Create an employeedetails table if it doesn't exist
if OBJECT_ID('EmployeeDetails', 'u') is null
    Create table EmployeeDetails
    (
      EmpID int not null primary key,
      FirstName nvarchar(20) not null,
      LastName nvarchar(20) not null,
      DateOfBirth date not null,
      Gender nvarchar(6) not null,
      City nvarchar(50) not null
    )
else
   Print('The "EmployeeDetails" table already exists and will not be recreated!')

   --Add/Insert records into the 'EmployeeDetails' table
   insert into dbo.EmployeeDetails
   values
   (101,'Andrew', 'Waller', '1994-03-22', 'Male', 'Boston'),
   (102,'Aj', 'Sties', '1992-02-14', 'Female', 'Liverpool'),
   (183, 'Sephia', 'Broderich', '1996-05-18', 'Female', 'Boston'),
   (104, 'Shann', 'Ro', '1994-03-22', 'Male', 'Boston'),

   --Add your details (fix the error on this line and execute all the code onwards from here)
   insert into dbo.EmployeeDetails
   values
   (105, 'Nyanjui', 'Arthur', '2010-03-22','Male', 'Limuru');

   --Confirm the above insertion
   select*from dbo.EmployeeDetails;

   -- Add/insert more records into the employeedetails table
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (1, 'Edin', 'Sangwin', '1978-03-10', 'Female', 'Licuan');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (2, 'Karen', 'Ivashnyov', '1979-07-30', 'Female', 'Santa Cruz');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (3, 'Briggs', 'Dameisele', '1971-03-06', 'Male', 'San Mateo');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (4, 'Janina', 'Van Dijk', '1986-07-25', 'Female', 'Fukuma');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (5, 'Vivyanne', 'Haggett', '1981-05-16', 'Female', 'Mora');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (6, 'Clerc', 'Kingcott', '1998-07-28', 'Male', 'Ciudad Bolivia');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (7, 'Melessa', 'Whitby', '1992-06-05', 'Female', 'Ushi');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (8, 'Siward', 'Bugden', '1983-04-20', 'Male', 'Hörby');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (9, 'Brigida', 'Drummond', '1988-11-18', 'Female', 'Liangzeng');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (10, 'Saxe', 'Ethington', '1977-10-13', 'Male', 'Frutal');

--Create a trigger that will prevent entering birthdates greater than today's date.
Create trigger trg_CheckBirthDate
on dbo.EmployeeDetails
for update as
if(Select dateofbirth from inserted) > GETDATE()
  Begin
    print 'Sorry, the date of birth cannot be after today'' date!'
    rollback
End;

--Try to update Clerc Kingcott's birth date to 24th August 2022
update dbo.employeeDetails
set dateofbirth = '2022-08-24'
where empid = 6;

-- Create the employee table "tblEmployee' if it doesn't exist
if not exists
(select * from INFORMATION_SCHEMA. TABLES where TABLE_NAME Like 'StudentDetails')
Begin
CREATE Table StudentDetails
(
int not null primary key,
Name nvarchar (50) not null,
Age int,
Email varchar (100)
)
End;

--Insert/add records to the 'tblEmployee' table
insert into dbo.StudentDetails (ID,Name,Age,Email)
values
(1, 'Abigail',20,'abigail@edulink.ac.ke'),
(2, 'Brian',22,'brian@edulink.ac.ke'),
(3, 'Charlie',21,'charlie@edulink.ac.ke'),
(4, 'David',20,'David@edulink.ac.ke'),
(5, 'Eve',20,'Eve@edulink.ac.ke');

--Confirm the above insertion
select*from StudentDetails;
