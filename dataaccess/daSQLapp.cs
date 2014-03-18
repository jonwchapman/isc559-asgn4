using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Threading.Tasks;

namespace dataaccess
{
    public class daSQLapp
    {
        public daSQLapp()                                              //Define default constructor method to initialize properties
        {
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
        #endregion

        #region "submit SQLstring"
        public DataTable GetSQLresult(string InputString, string ConnectionString)
        {
            DataTable dtSQLresults = new DataTable("dtSQLresults");

            using (SqlConnection JobConnection = new SqlConnection(ConnectionString))
            {
                JobConnection.Open();
                SqlCommand JobCommand = new SqlCommand();

                JobCommand.Connection = JobConnection;
                JobCommand.CommandType = CommandType.StoredProcedure;
                JobCommand.CommandText = "ExecuteSqlInputString";


                using (SqlDataAdapter JobAdapter = new SqlDataAdapter(JobCommand))
                {

                    try
                    {
                        DataSet JobDS = new DataSet();
                        JobAdapter.Fill(JobDS);

                        dtSQLresults = JobDS.Tables[0];
                    }

                    catch (SqlException ReadError)
                    {
                        pTransactionSuccessful = false; // if our SQL results in no data found or some other error not tested for

                        DataRow ErrorRow = dtSQLresults.NewRow();
                        dtSQLresults.Columns.Add("ErrorMessage");
                        ErrorRow["ErrorMessage"] = ReadError.Message.ToString();
                        dtSQLresults.Rows.Add(ErrorRow);
                    }
                }
            }
            return dtSQLresults;
        }
        #endregion





    }



}