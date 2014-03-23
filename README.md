isc559-asgn3
============


School: University of South Alabama
Course: Spring 2014, ISC 559, Dr. Pardue
Author: JonWChapman
Tags: C#, .net, n-tier
Title: Assignment 3 - nTier Demonstration






see below for assignment parameters from professor:











======================================================================
Assignment parameters:
======================================================================
Assignment 3, Execute SQL
ISC 559 Spring 2014

Grading: The assignment grade is calculated as the percentage (%) of completion. However, I will randomly select a group of students for an in-class code review. If a student does not answer my question(s) satisfactorily, the student will receive a zero (0) grade for this assignment. If when I call upon a student to conduct the code review, they do not have their laptop open with the project running, the student will receive a zero (0) grade for this assignment. No exceptions. If you have any questions regarding the grading system, ask.

Learning Objective: The learning objective of this assignment is to give the student an opportunity to gain experience developing systems with the n-tier architecture using C#. In this assignment you will submit the SQL input string from assignments 1 and 2 to the database via the DataAcccess tier, return it to the presentation tier, and bind it to a gridview for display.

Application Description: The purpose of this application is to submit an SQL expression to a database, format the return type to a datatable, and bind it to a gridview on a webform. If the Data Tier does not return a result because of an error, the return DataTable is filled with the SQL Server error message and displayed instead of the result set. See the running version of my solution for correct behavior.

http://192.245.222.134/nTierPardue/WellFormedSQLtester.aspx

Instructions:  
1.	DataAccess Tier: I prefer to start with the DataAccess Tier because the higher tiers must instantiate an instance of the DataAccess tier. A top down approach would require creating stubs and drivers. An advantage of the n-Tier architecture is the work of developing an application can be divided horizontally, meaning by tier. Your development team can have a sub-group that specializes in say the DataAccces tier. If you prefer to work in a different order that’s fine but all component must be present in your application.

Note: I won’t remind you at every step in the instructions, but you should always rebuild the BusinessLogic and DataAccess tiers after changes, otherwise the changes may not be visible to the Presentation tier.

Add two using directives to your class: using System.Data; and using System.Data.SqlClient;

Create the following method in your class per the videos for the n-Tier architecture.

   public DataTable GetSQLresult(string InputString, string ConnectionString)

The InputString is the scrubbed SQL expression from the presentation tier. ConnectionString is the connection string stored in the Web.Config file of the presentation tier. This method invokes the Data Tier sproc ExecuteSqlInputString (see Assignment 2). InputString is passed to the sproc as the input parameter @InputString. Inside the Catch {} block (see videos), add a row to the local DataTable and insert the error message passed by SQL Server. In this way, the Gridview will display the error message rather than the result of the SQL expression. The issue is this, the syntax might be well formed, but it might not match tables or attributes in your database. 

Add a public property to your class called TransactionSuccessful. If there is an error returned by SQL Server, set the property pTransactionSuccessful to false.

Add a custom default constructor to your class to initialize pTransactionSuccessful to true.

Rebuild the DataAccess tier. The screenshot below shows the contents of my DataTable for the query:

SELECT tblPerson.PersonID, tblPerson.LastName, 
       tblPerson.FirstName, tblPerson.AcctBalance
FROM tblPerson;

Hover over the DataTable and click on the magnifying glass to see the contents of the DataTable. It should resemble the following screen shots.

 
 

2.	BusinessLogic Tier: In this case, the BusinessLogic tier is acting like a facade pattern. It is simply passing parameters to the DataAccess tier and returning its type. In the relaxed n-tier architecture, the presentation tier can go directly to the DA tier when an intervening tier is a facade pattern. However, for our purposes, (which are educational) we will have all calls go through the BusinessLogic tier.

Add a using directive to your class: using System.Data;

Create the following method in your class per the videos for this section. Notice the signature is exactly the same as the method in the DataAccess tier. The BL method is simply passing parameters along. The BL method should also set any properties set by the DataAccess tier so they are exposed to the Presentation tier.

public DataTable GetSQLresult(string InputString, string ConnectionString)

Copy the method CheckSQLsyntax(string[] TokenArray) from the SQLutilities class on the Presentation tier to the BusinessLogic tier. You will need to copy the properties as well. Rebuild the BL tier.

Add a custom default constructor to your class to initialize properties to appropriate values.

2.	Presentation Tier: In the code behind for WellFormedSQLtester.aspx where you have the call to CheckSQLsyntax, instantiate an instance of the BusinessLogic tier and alter the call to reference the BL tier instead of the SQLutilities class. Once you have tested that it works properly, delete the CheckSQLsyntax method from the SQLutilities class (or comment it out for now…) and rebuild the solution.

Add a using directive to your web form class: using System.Web.Configuration;

Add a <connectionStrings></connectionStrings> element to your Web.Config file for you connection string. Either follow the technique demonstrated in the videos using a SQLdataSource control from the toolbox or simply type the element yourself. At the top of the web form class, declare a local ConnectionString variable. Use the WebConfigurationManager class to access the connection string elements in the Web.Config file. This local variable will be passed to any calls requiring a connection with the Data Tier.

Add another GridView control to WellFormedSQLtester.aspx. This gridview will be used to display the result of the SQL expression. See my running solution for correct behavior.

In the click event btnCheckSyntax_Click, there is an if/then statement to test whether an error was thrown. In the same block where the message "Syntax correct!" is assigned to the error message label text, make a call to the BusinessLogic Tier method GetSQLresult. If the syntax is correct, pass the scrubbed input string and the connection string to the BL tier. The result of this call is the data source for your newly created GridView. Bind the result to the Gridview. If the Data Tier returns an error message because the DataTable was empty (or encountered some other error), set the error message label to ”See below for SQL Server error message”.  See my running version for correct behavior. 

And that’s it! 



