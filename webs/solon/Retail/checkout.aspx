﻿<%@ Page Language="VB" MasterPageFile="~/membership.master" AutoEventWireup="false" CodeFile="checkout.aspx.vb" Inherits="checkout" title="Delivery Information" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" Runat="Server">

 

    <table>
<tr><td align="left" valign="top" style="height: 89px">Name:</td><td align="left" 
        valign="top" style="height: 89px">
 <asp:TextBox ID="Name_First" runat="server" Width="50%"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                 ControlToValidate="Name_First" 
        ErrorMessage="Missing"></asp:RequiredFieldValidator>
    <br />
 <asp:TextBox ID="Name_Last" runat="server" Width="50%"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                 ControlToValidate="Name_Last" 
        ErrorMessage="Missing"></asp:RequiredFieldValidator>
 </td></tr>
<tr><td align="left" valign="top" style="height: 175px">Address:</td>
    <td align="left" valign="top" style="height: 175px">
 <asp:TextBox ID="Address_Address1" runat="server" Width="50%"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                 ControlToValidate="Address_Address1" ErrorMessage="Missing"></asp:RequiredFieldValidator>
 <br />
 <asp:TextBox ID="Address_Address2" runat="server" Width="50%"></asp:TextBox>
 <br />
 <asp:TextBox ID="Address_Address3" runat="server" Width="50%"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                 ControlToValidate="Address_Address3" ErrorMessage="Missing"></asp:RequiredFieldValidator>
 <br />
 <asp:TextBox ID="Address_Address4" runat="server" Width="50%"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                 ControlToValidate="Address_Address4" ErrorMessage="Missing"></asp:RequiredFieldValidator>
 <br />
 <asp:TextBox ID="Address_Postcode" MaxLength="10" runat="server"></asp:TextBox>
                             
                             <br />
                             <br />
                 
                                 <asp:Button ID="btnSaveProfile" runat="server" Text="Proceed"/>
                
                             
                             
 </td></tr>
</table>
<BR/>

</asp:Content>



