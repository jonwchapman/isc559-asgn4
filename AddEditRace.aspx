<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <title></title>    
</head>
<body>
    <form id="form1" runat="server">   



<asp:panel runat="server">
    Race Location:
    <asp:TextBox ID="RaceLocation" runat="server"></asp:TextBox>
    <br />
    Race Length:
    <asp:TextBox ID="RaceLength" runat="server"></asp:TextBox>
    <br />
    Race Winnings:
    <asp:TextBox ID="RaceWinnings" runat="server" Width="64px"></asp:TextBox>
    <br />


    <asp:Button ID="Save" runat="server" Text="Save Changes" /> 

    &nbsp;<asp:Button ID="Cancel" runat="server" Text="Cancel" />
    <br />


</asp:panel>



    </form>
</body>
</html>

