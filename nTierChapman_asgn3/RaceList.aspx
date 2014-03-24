<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RaceList.aspx.cs" Inherits="nTierChapman_asgn3.RaceList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:Panel ID="MainPanel" runat="server" Height="384px" style="z-index: 1; left: 167px; top: 28px; position: absolute; height: 384px; width: 800px" Width="800px">
            <asp:Button ID="btFind" runat="server" Text="Find" style="z-index: 1; left: 353px; top: 45px; position: absolute" OnClick="btFind_Click" />
            <asp:TextBox ID="tbQuery" runat="server" style="z-index: 1; left: 169px; top: 49px; position: absolute"></asp:TextBox>
            <asp:Button ID="btAdd" runat="server" style="z-index: 1; left: 444px; top: 45px; position: absolute" Text="Add New" />
            <asp:GridView ID="returnedDL" runat="server" style="z-index: 1; left: 165px; top: 143px; position: absolute; height: 133px; width: 395px">
            </asp:GridView>
        </asp:Panel>
    
    </div>
    </form>
</body>
</html>
