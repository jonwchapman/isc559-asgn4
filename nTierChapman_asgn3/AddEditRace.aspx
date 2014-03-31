<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <title></title>    
</head>
<body>
    <form id="form1" runat="server">   



<asp:panel runat="server" style="z-index: 1; left: 113px; top: 145px; position: absolute; height: 163px; width: 381px">
    Race Location:
    <asp:TextBox ID="RaceLocation" runat="server" style="z-index: 1; left: 110px; top: 6px; position: absolute"></asp:TextBox>
    <br />
    <br />
    Race Length:
    <asp:TextBox ID="RaceLength" runat="server" style="z-index: 1; left: 110px; top: 40px; position: absolute"></asp:TextBox>
    <br />
    <br />
    Race Winnings:
    <asp:TextBox ID="RaceWinnings" runat="server" Width="64px" style="z-index: 1; left: 111px; top: 76px; position: absolute"></asp:TextBox>
    <br />
    <br />


    <asp:Button ID="Save" runat="server" Text="Save Changes" style="z-index: 1; left: 19px; top: 115px; position: absolute" /> 

    &nbsp;<asp:Button ID="Cancel" runat="server" Text="Cancel" style="z-index: 1; left: 288px; top: 115px; position: absolute" />
    <br />


</asp:panel>



    </form>
</body>
</html>

