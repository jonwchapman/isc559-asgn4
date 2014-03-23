/*


ISC 559 Spring 2014, Jon Chapman
Script to build the data tier for n-Tier assignment

This script runs as one transaction. 
If the database already exists, drop it and recreate it.

*/

--Don't display number of rows inserted. Restricts Messages to print statements
SET NOCOUNT ON
GO

USE master
GO
IF EXISTS (SELECT * FROM sysdatabases WHERE name='nTierChapman')
      BEGIN
	     DROP DATABASE nTierChapman;
	     EXEC sp_droplogin 'jchapman';
	     PRINT 'Dropped database and login';
      END
GO

CREATE DATABASE nTierChapman;
GO
Use nTierChapman;
GO

/*
Create at least two tables for illustration purposes.
Each table must have a primary key and at least two non-primary key
attributes. Suffix table names with "tbl" and use meaningful attribute
names. Insert at least four rows of data for each table.
*/

/*
Drop individual objects...
DROP TABLE tblPerson;
DROP TABLE tblJob; 
DROP ExecuteSqlInputString
*/
CREATE TABLE tblPerson
(
PersonID INT IDENTITY(1,1) PRIMARY KEY,
LastName VARCHAR(250) NOT NULL,
FirstName VARCHAR(250) NOT NULL,
AcctBalance MONEY NOT NULL DEFAULT 0.0
);
GO
PRINT 'Created tblPerson';
GO

INSERT INTO tblPerson(LastName, FirstName, AcctBalance) VALUES ('Pardue', 'Harold', 42);
INSERT INTO tblPerson(LastName, FirstName, AcctBalance) VALUES ('Gates', 'Bill', 10000000000);
INSERT INTO tblPerson(LastName, FirstName, AcctBalance) VALUES ('Holly', 'Cynthia', 15874);
INSERT INTO tblPerson(LastName, FirstName, AcctBalance) VALUES ('Tretch', 'Laura', 10);

GO
PRINT 'Inserted silly sample Person data';
GO
/*
Test case SQL statement
SELECT tblPerson.PersonID, tblPerson.LastName, 
       tblPerson.FirstName, tblPerson.AcctBalance
FROM tblPerson;
*/
--------------------------------------
CREATE TABLE tblJob
(
JobID INT IDENTITY(1,1) PRIMARY KEY,
JobLocation VARCHAR(500) NOT NULL,
JobHours INT NOT NULL DEFAULT 0,
JobCost MONEY NOT NULL DEFAULT 0.0
);
GO
PRINT 'Created tblJob';
GO

INSERT INTO tblJob (JobLocation, JobHours, JobCost) VALUES ('Mobile', 6, 250.00);
INSERT INTO tblJob (JobLocation, JobHours, JobCost) VALUES ('Grand Bay', 2, 50.50);
INSERT INTO tblJob (JobLocation, JobHours, JobCost) VALUES ('Mobile', 30, 3000.00);
INSERT INTO tblJob (JobLocation, JobHours, JobCost) VALUES ('Spanish Fort', 15, 1500.00);
INSERT INTO tblJob (JobLocation, JobHours, JobCost) VALUES ('Troy', 21, 6000.00);
GO
PRINT 'Inserted sample Job data';
GO
/*
Test case SQL statement
SELECT tblJob.JobLocation, tblJob.JobHours, tblJob.JobCost
FROM tblJob;
*/
--------------------------------------
CREATE PROC ExecuteSqlInputString 
  @InputString NvarChar(3000)
AS
BEGIN
	--The GOVERNOR puts a system-specific limit of one second for sql execution time
	--This is a per-connection setting. Setting the value back to 0 turns off
	--the governor.
	--The system sproc executesql is an example of dynamic SQL
	SET QUERY_GOVERNOR_COST_LIMIT 1
	EXEC sp_executesql @InputString
	SET QUERY_GOVERNOR_COST_LIMIT 0
END;
GO
PRINT 'Created ExecuteSQLinputString sproc';
GO
/*
Create a SQL Server user account that will access the stored procedure through our C#
data access tier. Windows integrated security is more secure than SQL Server 
logins but using SQL Server will give us more explicit experience with setting permissions 
and the security model built into SQL Server.

Access to the database instance is through a login. A login allows the user to connect
to the database. The database administrator must then grant the login access to one
or more databases in that instance.
Once the login is added to a database, the dba must grant privledges to objects
in the database.
 
*/

--This allows a user to login or establish a connection to the database.
EXEC sp_addlogin 'jchapman', 'mypass', 'nTierChapman';
GO
--To add a user to a database, make it the current database and "add" the login.
--You would do this step for any database for which the login is to have access.
USE nTierChapman;
EXEC sp_adduser 'jchapman';
GO
/*
In general, best practice is to not provide CRUD (Create, Read, Update, Delete)
access directly to tables or views. Rather, provide access through stored procedures
(sprocs) which allow for information hiding and more robust security. An sproc defines 
exactly what a user can or cannot do to a table/view. The opposite is to allow users or
developers to write their own SQL statements directly against tables and views. The
security issues with this are, I hope, obvious. At a minimum, there is no control.
However, in this assignment we have a situation which requires us to violate this 
best practice because we want our user/developer to be able to write their own SQL
against tables (the SQL intput string). The sproc ExecuteSqlInputString is running
the input string as dynamic SQL. Normally when a user executes a sproc, the dbms allows
the SQL statement inside the sproc to access tables regardless of the permissions granted to the
user who invoked it. This is called ownership chaining. The permissions of the owner of
the sproc are implicilty granted to the user who invoked it. It works fine when the sproc
contains an static SQL expression that cannot be changed by the user who invoked the 
sproc. In our case, the SQL expression inside the sproc is likely to change EVERY TIME.
Therefore, it would be naive, from a security perspective, for the dbms to chain the 
ownership to the underlying tables. Sooo... we have to at least give the user Read or
SELECT permission on any tables they may need to access with the sproc ExecuteSqlInputString.
*/

--Grant and revoke privledges
--In a way we don't need to do this because we are checking the syntax and only SELECT
--is allowed in the input string.
--But normally we would not grant select on any tables.
GRANT SELECT ON tblPerson TO jchapman;
REVOKE UPDATE ON tblPerson TO jchapman;
REVOKE DELETE ON tblPerson TO jchapman;
REVOKE INSERT ON tblPerson TO jchapman;
GO
GRANT SELECT ON tblJob TO jchapman;
REVOKE UPDATE ON tblJob TO jchapman;
REVOKE DELETE ON tblJob TO jchapman;
REVOKE INSERT ON tblJob TO jchapman;
GO
GRANT EXECUTE ON ExecuteSqlInputString TO jchapman;
GO

PRINT 'Updated permissions';
GO

/*
Test cases for the sproc
The DECLARE statement creates a local variable. I defined the 
variable to be identical to the input parameter in the sproc.
Note that @InputString will be passed to the sproc through the 
DataAccess tier. That is why I always put local variables in my 
test cases. The test cases further document the signature of the sproc
and is a more realistic test case.
In SQL Server, the single "@" indicates it is a local variable.
A double "@@" indicates a system variable such as @@Identity.
The SET statement is the assignment statement in SQL Server.
EXEC is short for Execute.
*/
DECLARE @InputString NVARCHAR(3000);

SET @InputString = 'SELECT tblPerson.PersonID, tblPerson.LastName, ' +
                   'tblPerson.FirstName, tblPerson.AcctBalance FROM tblPerson;';

EXEC ExecuteSqlInputString @InputString;

SET @InputString = 'SELECT tblJob.JobLocation, tblJob.JobHours, tblJob.JobCost FROM tblJob;'

EXEC ExecuteSqlInputString @InputString;