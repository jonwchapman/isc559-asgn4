/*
ISC 559 Spring 2014, Jon Chapman
Script to build the data tier for n-Tier assignment 4.

This script runs as one transaction. 
If the database already exists, drop it and recreate it.
*/

--Don't display number of rows inserted. Restricts Messages to print statements
SET NOCOUNT ON
GO

USE master
GO
IF EXISTS (SELECT * FROM sysdatabases WHERE name='nTierChapman4')
      BEGIN
	     DROP DATABASE nTierChapman4;
	     EXEC sp_droplogin 'jchapman';
	     PRINT 'Dropped database and login';
      END
GO

CREATE DATABASE nTierChapman4;
GO
Use nTierChapman4;
GO

/*
Create at least two tables for illustration purposes.
Each table must have a primary key and at least two non-primary key
attributes. Suffix table names with "tbl" and use meaningful attribute
names. Insert at least four rows of data for each table.
*/

/*
Drop individual objects...
DROP TABLE tblRallyRacer;
DROP TABLE tblRaces; 
DROP ExecuteSqlInputString
*/
CREATE TABLE tblRallyRacer
(
PersonID INT IDENTITY(1,1) PRIMARY KEY,
LastName VARCHAR(250) NOT NULL,
FirstName VARCHAR(250) NOT NULL,
SeasonWins VARCHAR(250) NULL DEFAULT 0
);
GO
PRINT 'Created tblRallyRacer';
GO

INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Atkinson', 'Chris', 12);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Pastrana', 'Travis', 3);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Loeb', 'Sabastian', 78);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Solberg', 'Petter', 10);

GO
PRINT 'Inserted silly sample Racer data';
GO
/*
Test case SQL statement
SELECT tblRallyRacer.PersonID, tblRallyRacer.LastName, 
       tblRallyRacer.FirstName, tblRallyRacer.SeasonWins
FROM tblRallyRacer;
*/
--------------------------------------
CREATE TABLE tblRaces
(
RaceID INT IDENTITY(1,1) PRIMARY KEY,
RaceLocation VARCHAR(500) NOT NULL,
RaceLengthMiles INT NOT NULL DEFAULT 0,
RaceWinnings MONEY NOT NULL DEFAULT 0.0
);
GO
PRINT 'Created tblRaces';
GO

INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings) VALUES ('Denver', 82, 25000);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings) VALUES ('Helsinki', 76, 5000);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings) VALUES ('Morocco', 127, 40000);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings) VALUES ('Eagle Glenn', 97, 15000);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings) VALUES ('Nome', 134, 60000);
GO
PRINT 'Inserted sample Job data';
GO
/*
Test case SQL statement
SELECT tblRaces.RaceLocation, tblRaces.RaceLengthMiles, tblRaces.RaceWinnings
FROM tblRaces;
*/
--------------------------------------


/* Note about using the asterik during a production query. 
1. Bad Security - violates "need to know" principal; can provide data for hacking (Data Leak)
2. Poor Performance - Can lead to slow transactions e.g, What if last column contained a BLOB? (Example about storing PDFs in actual DB, instead of link)
3. Can lead to run-time error. What if an App expects the columns in particular order? 
*/
CREATE PROC 



END;


CREATE PROC





END;

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
GRANT SELECT ON tblRallyRacer TO jchapman;
REVOKE UPDATE ON tblRallyRacer TO jchapman;
REVOKE DELETE ON tblRallyRacer TO jchapman;
REVOKE INSERT ON tblRallyRacer TO jchapman;
GO
GRANT SELECT ON tblRaces TO jchapman;
REVOKE UPDATE ON tblRaces TO jchapman;
REVOKE DELETE ON tblRaces TO jchapman;
REVOKE INSERT ON tblRaces TO jchapman;
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

SET @InputString = 'SELECT tblRallyRacer.PersonID, tblRallyRacer.LastName, ' +
                   'tblRallyRacer.FirstName, tblRallyRacer.SeasonWins FROM tblRallyRacer;';

EXEC ExecuteSqlInputString @InputString;

SET @InputString = 'SELECT tblRaces.RaceLocation, tblRaces.RaceLengthMiles, tblRaces.RaceWinnings FROM tblRaces;'

EXEC ExecuteSqlInputString @InputString;