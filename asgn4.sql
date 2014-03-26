/*
ISC 559 MARCH 2014, Jon Chapman
Script to build the data tier for n-Tier assignment 4.

This script runs as one transaction. 
If the database already exists, drop it and recreate it.
Create Tables
Add Data
Create PROCs
Grant Permissions
Various Testing data commented out
*/

--Don't display number of rows inserted. Restricts Messages to print statements
SET NOCOUNT ON
GO

USE master
GO
IF EXISTS (SELECT * FROM sysdatabases WHERE name='nTierChapman4')
      BEGIN
	     DROP DATABASE nTierChapman4;
	     EXEC sp_droplogin 'jwc';
	     PRINT 'Dropped database and login';
      END
GO

-- Create Database
CREATE DATABASE nTierChapman4;
GO
Use nTierChapman4;
GO

--This allows a user to login or establish a connection to the database.
EXEC sp_addlogin 'jwc', 'mypass', 'nTierChapman4';
GO
--To add a user to a database, make it the current database and "add" the login.
--You would do this step for any database for which the login is to have access.
USE nTierChapman4;
EXEC sp_adduser 'jwc';
GO



-- Create Table
CREATE TABLE tblRallyRacer
(
RacerID INT IDENTITY(1,1) PRIMARY KEY,
LastName VARCHAR(250) NOT NULL,
FirstName VARCHAR(250) NOT NULL,
SeasonWins VARCHAR(250) NULL DEFAULT 0
);
GO
PRINT 'Created tblRallyRacer';
GO

-- Create Table for Races
CREATE TABLE tblRaces
(
RaceID INT IDENTITY(1,1) PRIMARY KEY,
RaceLocation VARCHAR(500) NOT NULL,
RaceLengthMiles INT NOT NULL DEFAULT 0,
RaceWinnings MONEY NOT NULL DEFAULT 0.0, 
WinnerRacerID INT NOT NULL DEFAULT 0,
StatusID INT NOT NULL DEFAULT 1
);
GO
PRINT 'Created tblRaces';
GO
-- Create Table for record statuses
CREATE TABLE tblRecStatus
(
StatusID INT IDENTITY (1,1) PRIMARY KEY,
RecStatus VARCHAR(200) NOT NULL DEFAULT 'Active'
);
-- Insert Date into Record Status Table
INSERT INTO tblRecStatus(RecStatus) VALUES ('Active');
INSERT INTO tblRecStatus(RecStatus) VALUES ('Inactive');
INSERT INTO tblRecStatus(RecStatus) VALUES ('Deleted');
GO
PRINT 'Inserted Record Status Data';
GO


-- Insert Data into Racer Table
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Atkinson', 'Chris', 12);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Pastrana', 'Travis', 3);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Loeb', 'Sabastian', 78);
INSERT INTO tblRallyRacer(LastName, FirstName, SeasonWins) VALUES ('Solberg', 'Petter', 10);
GO
PRINT 'Inserted sample Racer data';
GO




-- Insert Data into race tables
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES ('Denver', 82, 25000, 1);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID, StatusID) VALUES ('Helsinki', 76, 5000, 3, 2);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES ('Morocco', 127, 40000, 3);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES ('Eagle Glenn', 97, 15000, 3);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES ('Nome', 134, 60000, 4);
INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES ('Pikes Peak', 115, 35000, 2);
GO
PRINT 'Inserted sample Race data';
GO


/* Note about using the asterik during a production query. 
1. Bad Security - violates "need to know" principal; can provide data for hacking (Data Leak)
2. Poor Performance - Can lead to slow transactions e.g, What if last column contained a BLOB? (Example about storing PDFs in actual DB, instead of link)
3. Can lead to run-time error. What if an App expects the columns in particular order? 

Like can have very serious performance consequences, consider option to not allow partial match. Maybe put check box on interface to allow partial search? 
*/



CREATE PROC GetRaceList
@SearchArg VARCHAR(100) = null
AS
BEGIN
	IF @SearchArg IS NOT NULL
		-- instead of string literal, put input variable (parameter)
		SELECT [RaceID],[RaceLocation],[RaceLengthMiles],[RaceWinnings],[WinnerRacerID] 
		FROM tblRaces, tblRecStatus
		WHERE tblRaces.StatusID =tblRecStatus.StatusID AND  RaceLocation LIKE '%' + @SearchArg + '%' AND RecStatus = 'Active';
	ELSE 
		SELECT [RaceID],[RaceLocation],[RaceLengthMiles],[RaceWinnings],[WinnerRacerID] 
		FROM tblRaces, tblRecStatus
		WHERE tblRaces.StatusID =tblRecStatus.StatusID AND RecStatus = 'Active';
END
GO




/* Testing Purposes, remove later 
--------------------------------------
	DECLARE @SearchArg VARCHAR(100)
	SET @SearchArg = 'd'
EXEC GetRaceList @SearchArg;
GO
--------------------------------
*/


/*   FAITHFULLY NOTED!!!! passing primary key ID by URL in query string is bad practice unless encrypted!!!    */ 



CREATE PROC GetRaceInfo
AS
BEGIN
		SELECT [RaceID],[RaceLocation],[RaceLengthMiles],[RaceWinnings],[WinnerRacerID] 
		FROM tblRaces, tblRecStatus
		WHERE tblRaces.StatusID =tblRecStatus.StatusID AND RecStatus = 'Active';
END
GO

ALTER PROC GetRaceInfo 
@RaceID INT = null
AS
BEGIN
	IF @RaceID is not null
		SELECT [RaceID],[RaceLocation],[RaceLengthMiles],[RaceWinnings],[WinnerRacerID] 
		FROM tblRaces,tblRecStatus
		WHERE tblRaces.StatusID =tblRecStatus.StatusID AND RecStatus = 'Active' AND RaceID = @RaceID;
	ELSE 
		SELECT [RaceID],[RaceLocation],[RaceLengthMiles],[RaceWinnings],[WinnerRacerID] 
		FROM tblRaces, tblRecStatus
		WHERE tblRaces.StatusID =tblRecStatus.StatusID AND RecStatus = 'Active';
END
GO


/* Testing purposes, remove later  

-------------------------------------
DECLARE @RaceID INT
SET @RaceID = 3

EXEC GetRaceInfo @RaceID;
GO
-------------------------------------
*/

/* CREATE, UPDATE, DELECT SPROCS
With multi-table trans we shoudl use transaction management techniques such as 
BEGIN TRAN, COMMIT, AND ROLLBACK. These are all just single table trans & so the trans will
be rolledback by optimizer anyhow.
*/

-- INSERT (Add new record)


CREATE PROC InsertRaceInfo
	@RaceLocation VARCHAR(500), @RaceLengthMiles INT, @RaceWinnings MONEY, @WinnerRacerID INT
AS
BEGIN
	DECLARE @StatusID INT
	SET @StatusID = (SELECT StatusID FROM tblRecStatus WHERE RecStatus = 'Active')
	INSERT INTO tblRaces (RaceLocation, RaceLengthMiles, RaceWinnings, WinnerRacerID) VALUES (@RaceLocation, @RaceLengthMiles, @RaceWinnings, @WinnerRacerID);
	PRINT 'Race Info Inserted Successfully.' -- For debugging purposes. 
END
GO


/* Testing purposes, remove later 
 
 ---------------------------------------------------------------------------------------------------
DECLARE @RaceLocation VARCHAR(500), @RaceLengthMiles INT, @RaceWinnings MONEY, @WinnerRacerID INT;
SET @RaceLocation = 'Shingletown'
SET @RaceLengthMiles = 2
SET @RaceWinnings = 12
SET @WinnerRacerID = 1

EXEC InsertRaceInfo @RaceLocation, @RaceLengthMiles, @RaceWinnings, @WinnerRacerID;
GO
------------------------------------------------------------------------------------------------------
*/


CREATE PROC UpdateRaceInfo
	@RaceLocation VARCHAR(500), @RaceLengthMiles INT, @RaceWinnings MONEY, @WinnerRacerID INT, @RaceID INT
AS
BEGIN
	UPDATE tblRaces
		SET RaceLocation = @RaceLocation,
			RaceLengthMiles = @RaceLengthMiles,
			RaceWinnings = @RaceWinnings,
			WinnerRacerID = @WinnerRacerID
		WHERE RaceID = @RaceID;
		IF @@ROWCOUNT = 0 
		BEGIN
			Print 'No Records Updated.'
			RAISERROR ('No Row Updated', 16, 1)
		END
		ELSE
			PRINT 'Race Info Updated Successfully.'
END
GO


/* Testing purposes, remove later 
 
 ---------------------------------------------------------------------------------------------------
DECLARE @RaceLocation VARCHAR(500), @RaceLengthMiles INT, @RaceWinnings MONEY, @WinnerRacerID INT, @RaceID INT;
	SET @RaceLocation = 'Pikes Peak edited'
	SET @RaceLengthMiles = 12
	SET @RaceWinnings = 12000
	SET @WinnerRacerID = 2
	SET @RaceID = 10
EXEC UpdateRaceInfo @RaceLocation, @RaceLengthMiles, @RaceWinnings, @WinnerRacerID, @RaceID;
GO
---------------------------------------------------------------------------------------------------
*/




---- lazy delete -----------------------
-- our del PROC is really an update PROC

CREATE PROC DelRaceInfo
	@RaceID INT
AS
BEGIN
	UPDATE tblRaces
		SET StatusID = (SELECT StatusID FROM tblRecStatus WHERE RecStatus = 'Deleted')
		WHERE RaceID = @RaceID;
		IF @@ROWCOUNT = 0 
		BEGIN
			Print 'No Records Deleted.'
			RAISERROR ('No Record Deleted', 16, 1)
		END
		ELSE
			PRINT 'Race Info Deleted Successfully.'
END
GO


/*Testing purposes only, remove later 

DECLARE @RaceID INT
SET @RaceID = 1
EXEC DelRaceInfo @RaceID;

*/






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




--Grant and revoke privileges

GRANT SELECT ON tblRallyRacer TO jwc;
REVOKE UPDATE ON tblRallyRacer TO jwc;
REVOKE DELETE ON tblRallyRacer TO jwc;
REVOKE INSERT ON tblRallyRacer TO jwc;
GO
GRANT SELECT ON tblRaces TO jwc;
REVOKE UPDATE ON tblRaces TO jwc;
REVOKE DELETE ON tblRaces TO jwc;
REVOKE INSERT ON tblRaces TO jwc;
GO

GRANT EXECUTE ON ExecuteSqlInputString TO jwc;
GRANT EXECUTE ON GetRaceList to jwc;
GRANT EXECUTE ON GetRaceInfo to jwc;
GRANT EXECUTE ON InsertRaceInfo to jwc;
GRANT EXECUTE ON UpdateRaceInfo to jwc;
GRANT EXECUTE ON DelRaceInfo to jwc;
GO

PRINT 'Updated permissions';
GO

