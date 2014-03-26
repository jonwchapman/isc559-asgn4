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
            
            

            if (Session["SortExpression"] == null)  // don't really need to check for existence of null on both, if we set one we set the other. Two checks per the video is redundant.
            {  
                Session["SortExpression"] = "RaceLocation";
                Session["SortDir"] = "ASC"; 
            }

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
            gvRaceList.Columns[0].Visible = false;      // Cheating and including the RaceID so I can reference it later because I cannot get Dr. Pardue's method to work yet..... ARGH!
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
        protected void gvRaceList_RowDataBound(object sender, GridViewRowEventArgs e) 
        {

            if (e.Row.RowType == DataControlRowType.DataRow)  //only use data type of "row", we don't want header, or footer, etc.
            { 

                e.Row.Cells[4].Attributes.Add("onClick", "return confirm('Are you sure you want to delete " + e.Row.Cells[0].Text + "?')");


               //Returns a string that can be used in a client event to cause a postback to the server.                
               // e.Row.Attributes.Add("onClick", Page.ClientScript.GetPostBackEventReference((Control)sender, "Edit" + e.Row.RowIndex.ToString()));
            
            }
        
        }
        protected void gvRaceList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteJob")
            {
                
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                DataKey dkRace = gvRaceList.DataKeys[rowIndex];
                // row contains current Clicked Gridview Row

                //  int index = Convert.ToInt32(e.CommandArgument);
                //  int RaceID = Convert.ToInt32(gvRaceList.SelectedRow.Cells[0].Text)
                //  int RaceID = Convert.ToInt32(gvRaceList.DataKeys[index].Value);
                //  int RaceID = Convert.ToInt32(gvRaceList.Rows[rowIndex].Cells[0].Text);

                dataaccess.daSQLapp objRace = new dataaccess.daSQLapp();
                objRace.DelRaceInfo(RaceID, ConnectionString);
                PopulateGridView();

            }
            else if (e.CommandName == "EditDetails")
            {
                int RowIndex = Convert.ToInt32(e.CommandArgument);

            }

        }
    
        protected void gvRaceList_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


    
    }
}