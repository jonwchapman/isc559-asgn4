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
           
        }

 

        protected void btFind_Click(object sender, EventArgs e)
        {

            businesslogic.blSQLapp lister = new businesslogic.blSQLapp();                          // create instance of our SQLutilities class, call it "lister"

            DataTable returneddl = lister.GetSQLresult(tbQuery.Text, ConnectionString, 1);

            returnedDL.DataSource = returneddl;
            returnedDL.DataBind();


        
        }


    
    
    }
}