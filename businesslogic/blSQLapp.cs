using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace businesslogic
{
    public class blSQLapp
    {
        private string errorMessage;
        public bool errorFound;
        private int errorNum, counter;                                        

        public blSQLapp()
        {
            errorMessage = "No errors found.";
            errorFound = false;
            errorNum = 0;
            counter = 0;
        }

        public string[] BuildTokenArray(string inputStr)
        {
            char[] delimiters = new char[] { ' ' };                         // delimiters to split on.
            string[] tokens = inputStr.Split(delimiters);                 // Returns a string array that contains the substrings in this instance that are delimited by elements of a Unicode character array, defined in the previous step.
            return tokens;                                                // return array of elements.
        }

        public DataTable GetSQLresult(string InputString, string ConnectionString)     // facade, simply passing parameters to dataaccess layer. Also invoking DL. 
        {



            return;
        }

        public void setError(int errorNum)                                    // setError method, expects an integer.
        {                                                                     // If this method is called, it means there was an error of some sort.
            switch (errorNum)                                                 // Switch on errorNum, set error message according to errorNum
            {
                case 1:                                                              
                    this.errorMessage = "Problem with SELECT statement";
                    break;
                case 2:
                    this.errorMessage = "Problem with attribute selector " + counter;
                    break;
                case 3:
                    this.errorMessage = "Problem with FROM statement";
                    break;
                case 4:
                    this.errorMessage = "";
                    break;
                case 5:
                    this.errorMessage = "Problem with table selector";
                    break;
                case 6:
                    this.errorMessage = "Too many table selectors";
                    break;
                case 7:
                    this.errorMessage = "Erroneous inclusion of a dot in table selector";
                    break;
                case 8:
                    this.errorMessage = "Not enough elements to form proper statement";
                    break;
                case 9:
                    this.errorMessage = "No table selector found";
                    break;
                case 10:
                    this.errorMessage = "Lack of comma after first attribute selector";
                    break;
                case 11:
                    this.errorMessage = "Erroneous inclusion of comma after last attribute selector";
                    break;
                case 12:
                    this.errorMessage = "Erroneous inclusion of comma after SELECT statment";
                    break;
                case 13:
                    this.errorMessage = "Table selector and second attribute selector do not match";
                    break;             
                case 14:
                    this.errorMessage = "Table selector and first attribute selector do not match";
                    break;
                default:
                    this.errorMessage = "No error found";
                    break;
            }

            errorFound = true;                                               // so we set the errorFound flag to true.
            return;                                                          // TODO: add the error code directory and assign error message corresponding to code.
        }
        public string getError()                                             // getError method retrieves the errors to be displayed at the end.
        {                                                                    // This will be called from the main file, and only if the errorFound flag is set to true.
            return errorMessage;
        }


        public void CheckSQLsyntax(string[] scrubbedInput)                   // Check the SQL Syntax, token by token. We are only checking the syntax that relates to our limited test cases.
        {
            if (scrubbedInput.Length < 4)                                    // There need to be at least 4 elements to form a proper SQL statement.
            {
                this.setError(8);
                return;
            }

            else if (scrubbedInput[0] != "SELECT")                           // Check for the SELECT statement as the first element.
            {
                if (scrubbedInput[0] == "SELECT,")                           // specifically check for the extra comma, per the test case
                {
                    this.setError(12);
                    return;
                }
                this.setError(1);                                            // If no SELECT statement, set error code which should equal 1.
                return;
            }
            else
            {                                                                // 
                CheckSelectors(scrubbedInput);                               // If SELECT statement exists, then pass the array of tokens to the check selector    
                if (this.errorFound) { return; }
            }                                                                // method. This will check the table selectors on this iteration.
            counter++;                                                       // increment the step that we are on.
            if (scrubbedInput[counter] != "FROM" )                           // check for existence of a FROM statement, either proper or not
            {
                if (scrubbedInput[counter] == "FROM;" && scrubbedInput.Length <= counter + 1)   // if the current element is the last element, and its a variation of FROM, then we have no table selector.
                {                                                            // this checks for the test case where there is a from statement, and no table selector
                    this.setError(9);                                        // the "FROM;" statement would have slipped through the last check. This is slightly awkward and 
                    return;                                                  // deserves to be revisited.
                }

                this.setError(3);                                            // if no FROM statement, then set error 
                return;                                                      
            }
            else if (scrubbedInput.Length <= counter + 1)                    // If the current element is FROM, but there is not another element after the FROM, flag error for lack of table selector
            {
                this.setError(9);
                return;
            }
            else
            {
                CheckSelectors(scrubbedInput);                               // otherwise if the FROM statement checks out, then we pass the array back over to the CheckSelectors() method again
            }
            return;
        }
        private void CheckSelectors(string[] scrubbedInput)
        {
            counter++;                                                       // increment counter by one and then
            scrubbedInput[counter] = scrubbedInput[counter].Trim('.');       // trim any leading or trailing dots from the current token.

            if (scrubbedInput[counter - 1] == "FROM")                        // If the previous token was a FROM statement, then we don't need to look for a dot,    
            {
                if (scrubbedInput.Length > counter + 1)
                {                                                            // If the length of the array is more than the counter that we are at, it means that there is more than one table selector...this is a problem with our simple syntax checker.
                    this.setError(6);
                    return;
                }
                else if (!scrubbedInput[counter].EndsWith(";"))              // instead we look to make sure that it ends with a semi-colon, 
                {
                    this.setError(5);
                    return;
                }
                else if (scrubbedInput[counter].Contains("."))
                {
                    this.setError(7);
                    return;
                }
                else
                {
                    int iCheck = Array.IndexOf(scrubbedInput, "FROM") - 2;   // Find out the index of the FROM statement, subtract 2 and set that to iCheck. This tells us where the first selector starts.
                    for (int i = 0; i <= iCheck; i++)                        // this is going to loop as many times as there are elements prior to the FROM statement.
                    {

                        string subsection = scrubbedInput[counter - (2 + i)].Substring(0, scrubbedInput[counter - (2 + i)].IndexOf(".")); // grap a subsection of the element selector, starting from 0 until we reach the Dot.
                        subsection = subsection.ToUpper();                   // change to upper case, for comparison purposes
                        string tablename = scrubbedInput[counter].Trim(';'); // for comparison purposes trim the semicolon
                        tablename = tablename.ToUpper();                     // change to upper case, for comparison purposes
                        if (subsection != tablename)                         // each time we loop, we check the substring of the attribute selector, comparing it to the table selector token.
                        {
                            counter++;                                       // advance the counter 1
                            setError(13 + i);                                  // set error code to 4
                            return;
                        }
                    }
                }
            }
            else if (scrubbedInput[counter].Contains("."))                   // For this step we check to see if there is still a dot somewhere in the mix, IOT make a valid selector.
            {                                                                // OR check to see if we are selecting the table. Check this by existence of FROM keyword in the previous element.         
                if (scrubbedInput[counter + 1] == "FROM" || scrubbedInput[counter + 1] == "FROM;")  //refactor to look for partial match, rather than use OR operator
                {
                    if (scrubbedInput[counter].EndsWith(","))               // if the next element is a FROM statement but our current attribute selector ends with a comma, then we have a problem.
                    {
                        this.setError(11);
                        return;
                    }
                    return;
                }
                else if (!scrubbedInput[counter].EndsWith(","))             // if the selector doesn't end with a comma, despite there being another selector, then we have a problem.         
                {
                    this.setError(10);
                    return;
                }
                else                                                         // otherwise go about our merry way, and call this method recursively. Why? Because I can. :-)
                {
                    CheckSelectors(scrubbedInput);
                    return;
                }
            }
            else
            {
                this.setError(2);                                           // if the attribute selector lacks a dot, then we flag error.
                return;
            }
        }
    }
}