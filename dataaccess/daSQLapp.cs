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

                using (SqlConnection JobConnection = new SqlConnection(ConnectionString))  // "using" so that the system garbage collects as soon as we are done using this object. 
                {
                    JobConnection.Open();
                    SqlCommand JobCommand = new SqlCommand();

                    JobCommand.Connection = JobConnection;
                    JobCommand.CommandType = CommandType.StoredProcedure;
                    JobCommand.Parameters.Add(new SqlParameter("@InputString", SqlDbType.VarChar)).Value = InputString;
                    JobCommand.CommandText = "ExecuteSqlInputString";                      // This tells SQL what the name of the stored procedure is that we are using.


                    using (SqlDataAdapter JobAdapter = new SqlDataAdapter(JobCommand))
                    {
                        try
                        {
                            DataSet SQLDS = new DataSet();
                            JobAdapter.Fill(SQLDS);

                            dtSQLresults = SQLDS.Tables[0];
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

        public DataTable GetSQLresult(string InputString, string ConnectionString, int Proc)
        {


            DataTable dtSQLresults = new DataTable("dtSQLresults");

            using (SqlConnection JobConnection = new SqlConnection(ConnectionString))  // "using" so that the system garbage collects as soon as we are done using this object. 
            {
                JobConnection.Open();
                SqlCommand JobCommand = new SqlCommand();

                JobCommand.Connection = JobConnection;
                JobCommand.CommandType = CommandType.StoredProcedure;
                JobCommand.Parameters.Add(new SqlParameter("@SearchArg", SqlDbType.VarChar)).Value = InputString;
                if (Proc == 1)
                {
                    JobCommand.CommandText = "GetRaceList";                      // This tells SQL what the name of the stored procedure is that we are using.
                }
                else
                {
                    JobCommand.CommandText = "GetRaceInfo";                      // This tells SQL what the name of the stored procedure is that we are using.
                }
               


                using (SqlDataAdapter JobAdapter = new SqlDataAdapter(JobCommand))
                {
                    try
                    {
                        DataSet SQLDS = new DataSet();
                        JobAdapter.Fill(SQLDS);

                        dtSQLresults = SQLDS.Tables[0];
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