<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SQLchecker.aspx.cs" Inherits="nTierChapman_asgn3.SQLchecker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="wellformedsqlchecker" runat="server">
    <div style="height: 382px">
    
<h1>generic SQL submission form</h1>
    
        <asp:TextBox ID="TextBox1" runat="server" Width="475px" MaxLength="150"></asp:TextBox>
        <br />
        <asp:Button ID="btnCheckSyntax" runat="server" OnClick="btnCheckSyntax_Click" Text="Validate" />
    
        <br />
        <asp:Label ID="Scrubbed1" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="Key1" runat="server" Text="" style="z-index: 1; left: 490px; top: 134px; position: absolute"></asp:Label>
    
        <br />
        <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" AutoGenerateColumns="true" style="z-index: 1; left: 484px; top: 176px; position: absolute; height: 157px; width: 199px">
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <RowStyle ForeColor="#000066" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#007DBB" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#00547E" />
        </asp:GridView>

    
        <br />
        <asp:GridView ID="returnedDL" runat="server">
        </asp:GridView>
        <br />
        <br />
        <br />

    
    </div>
    </form>
</body>
</html>
