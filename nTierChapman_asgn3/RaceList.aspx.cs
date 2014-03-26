using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using businesslogic;

namespace nTierChapman_asgn3
{
    public partial class RaceList : System.Web.UI.Page
    {

        String ConnectionString = ConfigurationManager.ConnectionStrings["dbconnect"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                SetFormMode();
            
            }


          


        }

        private void SetFormMode() 
        {
            //initialize anything that needs to be initialized here if it is an intial page load rather than postback.
            //initialize PRIOR to calling populate....derrr..
            Session["SortExpression"] = "RaceLocation";
            Session["SortDir"] = "DESC";
            
            PopulateGridView();

        }



 

        protected void btFind_Click(object sender, EventArgs e)     // Dr. Pardue did a more complicated setup, checking for existences of text, and then calling an overloaded method or not depending on need.
        {                                                           // I saw no reason for this complication. Maybe ask why I would do it his way? 
            PopulateGridView();   
           
        }



        private void PopulateGridView() {
            businesslogic.blSQLapp lister = new businesslogic.blSQLapp();                          // create instance of our SQLutilities class, call it "lister". 
            DataTable dtRace = lister.GetSQLresult(tbQuery.Text, ConnectionString, 1);

            DataView dvRace = dtRace.DefaultView;
            dvRace.Sort = Session["SortExpression"].ToString() + " " + Session["SortDir"].ToString();

            gvRaceList.DataSource = dvRace;
            gvRaceList.DataBind();
           
        
        }

        protected void gvRaceList_Sorting(object sender, GridViewSortEventArgs e)
        {
            Session["SortExpression"] = e.SortExpression.ToString();
            
            if (Session["SortDir"] == "ASC")
            {
                Session["SortDir"] = "DESC";

            }
            else
            {
                Session["SortDir"] = "ASC";
            }
            


            PopulateGridView();


        }

    
    
    }
}