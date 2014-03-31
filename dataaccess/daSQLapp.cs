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
            pRaceCnt = 0;
        }

        #region "Properties"
        private bool pTransactionSuccessful;
        public bool TransactionSuccessful
        {
            get { return pTransactionSuccessful; }
            set { pTransactionSuccessful = value; }
        }
        private string pErrorMessage;
        public string ErrorMessage
        {
            get { return pErrorMessage; }
        }

        private int pRaceCnt;
        public int RaceCnt
        {
            get { return pRaceCnt; }
        }
        #endregion

        #region "submit SQLstring"
        public DataTable GetSQLresult(string InputString, string ConnectionString)
        {


                DataTable dtSQLresults = new DataTable("dtSQLresults");

                using (SqlConnection RaceConnection = new SqlConnection(ConnectionString))  // "using" so that the system garbage collects as soon as we are done using this object. 
                {
                    RaceConnection.Open();
                    SqlCommand RaceCommand = new SqlCommand();

                    RaceCommand.Connection = RaceConnection;
                    RaceCommand.CommandType = CommandType.StoredProcedure;
                    RaceCommand.Parameters.Add(new SqlParameter("@InputString", SqlDbType.VarChar)).Value = InputString;
                    RaceCommand.CommandText = "ExecuteSqlInputString";                      // This tells SQL what the name of the stored procedure is that we are using.


                    using (SqlDataAdapter RaceAdapter = new SqlDataAdapter(RaceCommand))
                    {
                        try
                        {
                            DataSet SQLDS = new DataSet();
                            RaceAdapter.Fill(SQLDS);

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

        public DataTable GetSQLresult(string InputString, string ConnectionString, int Proc)  //overload the original GetSQLresult, taking a PROC parameter for which stored procedure to run. Trying to cut down number of lines. May have to be refactored, but lets try it. Consider changing PROC to varchar, rather than int. Makes calling pages more readable.
        {


            DataTable dtSQLresults = new DataTable("dtSQLresults");

            using (SqlConnection RaceConnection = new SqlConnection(ConnectionString))  // "using" so that the system garbage collects as soon as we are done using this object. 
            {
                RaceConnection.Open();
                SqlCommand RaceCommand = new SqlCommand();

                RaceCommand.Connection = RaceConnection;
                RaceCommand.CommandType = CommandType.StoredProcedure;
                RaceCommand.Parameters.Add(new SqlParameter("@SearchArg", SqlDbType.VarChar)).Value = InputString;
                if (Proc == 1)
                {
                    RaceCommand.CommandText = "GetRaceList";                      // This tells SQL what the name of the stored procedure is that we are using.
                }
                else if (Proc == 2)
                {
                    RaceCommand.CommandText = "GetRaceInfo";                      // This tells SQL what the name of the stored procedure is that we are using.
                }
                else
                { 
                
                
                }
               


                using (SqlDataAdapter RaceAdapter = new SqlDataAdapter(RaceCommand))
                {
                    try
                    {
                        DataSet SQLDS = new DataSet();
                        RaceAdapter.Fill(SQLDS);

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
        public void DelRaceInfo(int RaceID, string ConnectionString)  //overload the original GetSQLresult, taking a PROC parameter for which stored procedure to run. Trying to cut down number of lines. May have to be refactored, but lets try it. Consider changing PROC to varchar, rather than int. Makes calling pages more readable.
        {


            //DataTable dtSQLresults = new DataTable("dtSQLresults");
           
            using (SqlConnection RaceConnection = new SqlConnection(ConnectionString))  // "using" so that the system garbage collects as soon as we are done using this object. 
            {
                RaceConnection.Open();
                
                SqlCommand RaceCommand = new SqlCommand();
                RaceCommand.Connection = RaceConnection;
                RaceCommand.CommandType = CommandType.StoredProcedure;
                RaceCommand.Parameters.Add(new SqlParameter("@RaceID", SqlDbType.Int)).Value = RaceID;
                RaceCommand.CommandText = "DelRaceInfo";                      // This tells SQL what the name of the stored procedure is that we are using.
                RaceCommand.Parameters["@RaceID"].Direction = ParameterDirection.Input;


                try
                {
                    RaceCommand.ExecuteNonQuery();
                }
                catch (SqlException DelError)
                {
                    pErrorMessage = DelError.Message.ToString();
                }
            }
            return;
        }



        #endregion





    }



}