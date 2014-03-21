using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace businesslogic
{
    public class blSQLapp
    {
                                      
        public blSQLapp()                            //Define default constructor method to initialize properties
        {
            errorMessage = "No errors found.";
            errorFound = false;
            errorNum = 0;
            counter = 0;
            pTransactionSuccessful = true;
            pJobCnt = 0;
        }

        #region "Properties"
        

        private bool pTransactionSuccessful;
        public bool TransactionSuccessful
        {
            get { return pTransactionSuccessful; }
        }
        private int pJobCnt;
        public int JobCnt
        {
            get { return pJobCnt; }
        }

        private string errorMessage;
        public bool errorFound;
        private int errorNum, counter;  

        #endregion




        public string[] BuildTokenArray(string inputStr)
        {
            char[] delimiters = new char[] { ' ' };                         // delimiters to split on.
            string[] tokens = inputStr.Split(delimiters);                 // Returns a string array that contains the substrings in this instance that are delimited by elements of a Unicode character array, defined in the previous step.
            return tokens;                                                // return array of elements.
        }
        public DataTable GetSQLresult(string InputString, string ConnectionString)     // facade, simply passing parameters to dataaccess layer. Also invoking DL. 
        {
            DataTable dtSQLresults = new DataTable();
            dataaccess.daSQLapp daSQLsubmit = new dataaccess.daSQLapp();

            dtSQLresults = daSQLsubmit.GetSQLresult(InputString, ConnectionString);    // call DataAccess SQL submitter, set results equal to datatable results (dtSQLresults). 

            return dtSQLresults;
        }
    }
}