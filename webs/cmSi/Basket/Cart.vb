﻿Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Xml
Imports System.IO
Imports System.Web
Imports System.Web.UI.WebControls

Public Class Cart

#Region "Public Variables"

    Public CartItems As New Dictionary(Of String, CartItem)
    Public DeliveryAddress As New Address
    Public Payment As New CardPayment
    Public Vouchers As New List(Of String)


#End Region

#Region "Initialisation"

    Public Sub New()
        MyBase.New()
    End Sub

#End Region

#Region "Public Properties"

    Private _subscribed As String = "N"
    Public Property Subscribed() As String
        Get
            Return _subscribed
        End Get
        Set(ByVal value As String)
            _subscribed = value
        End Set
    End Property
    Private _PostGuid As String = Nothing
    Public Property PostGuid() As String
        Get
            Return _PostGuid
        End Get
        Set(ByVal value As String)
            _PostGuid = value
        End Set
    End Property
    Private _CURRENCY As String = "GBP"
    Public Property CURRENCY() As String
        Get
            Return _CURRENCY
        End Get
        Set(ByVal value As String)
            _CURRENCY = value
        End Set
    End Property

    Private _Value As String = "0.00"
    Public ReadOnly Property Value() As String
        Get
            Dim t As Double = 0
            For Each i As CartItem In Me.CartItems.Values
                t += CDbl(i.LINETOTAL)
            Next
            Return FormatDouble(CStr(t))
        End Get
    End Property

    Private _TotalTax As String = "0.00"
    Public ReadOnly Property TotalTax() As String
        Get
            Dim t As Double = 0
            For Each i As CartItem In Me.CartItems.Values
                t += i.QTY * (CDbl(i.SALESTAX / 100) * CDbl(i.PARTPRICE))
            Next
            Return FormatDouble(CStr(t))
        End Get
    End Property

    Private _fullPrice As String = "0.00"
    Public ReadOnly Property FullPrice() As String
        Get
            Dim t As Double = 0.0
            For Each i As CartItem In Me.CartItems.Values
                If Not CBool(cmsData.Settings("ShowVAT")) Then
                    t += CDbl(i.PARTPRICE) * (1 + CDbl(i.SALESTAX / 100))
                Else
                    t += i.LINETOTAL
                End If
            Next
            Return FormatDouble(CStr(t))
        End Get
    End Property

    Private _Discount As Double
    Public Property Discount() As Double
        Get
            Return FormatDouble(CStr(_Discount))
        End Get
        Set(ByVal value As Double)
            _Discount = value
        End Set
    End Property

    Private _Total As String = "0.00"
    Public ReadOnly Property Total() As String
        Get
            Dim t As Double = 0
            For Each i As CartItem In Me.CartItems.Values
                If Not CBool(cmsData.Settings("ShowVAT")) Then
                    t += CDbl(i.LINETOTAL) * (1 + CDbl(i.SALESTAX / 100))
                Else
                    t += i.LINETOTAL
                End If
            Next
            t -= Discount
            Return FormatDouble(CStr(t))
        End Get
    End Property


    Public ReadOnly Property PACKFAMILY() As List(Of Integer)
        Get
            Dim t As New List(Of Integer)
            For Each i As CartItem In Me.CartItems.Values
                't += (CInt(i.QTY) * CInt(i.PackSize))
                If Not t.Contains(i.PackFamily) Then
                    t.Add(i.PackFamily)
                End If
            Next
            Return t
        End Get
    End Property

    Private _DELIVERY As New DeliveryItem
    Public Property DELIVERY() As DeliveryItem
        Get
            Return _DELIVERY
        End Get
        Set(ByVal value As DeliveryItem)
            _DELIVERY = value
        End Set
    End Property

    Public ReadOnly Property chkFreeDel(ByVal FreeDelMin As String) As String
        Get
            If Me.DELIVERY.DELIVERYPART = cmsData.Settings.Item("FreeDelPart") Then
                If Me.Value > cmsData.Settings.Item("FreeDelMin") Then
                    Return 0
                End If
            End If
            Return FreeDelMin
        End Get
    End Property

    Private _CustomerID As String = ""
    Public Property CustomerID() As String
        Get
            Return _CustomerID
        End Get
        Set(ByVal value As String)
            _CustomerID = value
        End Set
    End Property

    Private _custPO As String = ""
    Public ReadOnly Property custPO() As String
        Get
            Dim id As Integer = CInt(cmSi.cmsData.rtSettings.SelectSingleNode("settings/last_order").InnerText)
            id += 1
            Return String.Format("{0}-{1}-{2}", cmSi.cmsData.Settings.Get("orderPrefix"), Today.ToString("yy"), id.ToString("00000000"))
        End Get
    End Property

#End Region

#Region "Private Functions"

    Private Function FormatDouble(ByVal str As String) As String
        str = Math.Round(CDbl(str), 2)
        If InStr(str, ".") Then
            Return Split(str, ".")(0) & "." & Left(Split(str, ".")(1) & "00", 2)
        Else
            Return str & ".00"
        End If
    End Function

#End Region

#Region "Save Cart"

    Public Sub LoadCart(ByVal OrderID As String)

        Dim ord As New XmlDocument()
        Try
            ord.Load(String.Format("{0}orders\{1}.xml", HttpContext.Current.Server.MapPath("\"), OrderID))
        Catch
            Throw New Exception("Order not found.")
        End Try

        With cmsSessions.CurrentSession(HttpContext.Current).cart
            .CartItems.Clear()
            .PostGuid = OrderID
            Dim order_post As XmlNode = ord.SelectSingleNode("order_post")
            .CustomerID = order_post.SelectSingleNode("customer_id").InnerText

            With .DeliveryAddress
                Dim deladd As XmlNode = order_post.SelectSingleNode("delivery_address")
                If Not IsNothing(deladd) Then

                    .First = deladd.ParentNode.SelectSingleNode("name/first").InnerText
                    .Last = deladd.ParentNode.SelectSingleNode("name/last").InnerText

                    .Address1 = deladd.SelectSingleNode("address_1").InnerText
                    .Address2 = deladd.SelectSingleNode("address_2").InnerText
                    .Address3 = deladd.SelectSingleNode("address_3").InnerText
                    .Address4 = deladd.SelectSingleNode("address_4").InnerText
                    .Address5 = deladd.SelectSingleNode("address_5").InnerText
                    .Address_Postcode = deladd.SelectSingleNode("postcode").InnerText
                    .eMail = deladd.SelectSingleNode("email").InnerText
                    .Phone = deladd.SelectSingleNode("phone").InnerText
                End If
            End With
            .Subscribed = order_post.SelectSingleNode("subscribed").InnerText
            Try
                Dim discounts As XmlNode = order_post.SelectSingleNode("discounts")
                .Discount = discounts.SelectSingleNode("total_discount").InnerText
                For Each Voucher As XmlNode In discounts.SelectNodes("voucher")
                    .Vouchers.Add(Voucher.InnerText)
                Next
            Catch
            End Try

            For Each line As XmlNode In order_post.SelectNodes("lines/line")
                Dim uPrice As String = ""
                Select Case CBool(cmsData.Settings("ShowVAT"))
                    Case True
                        uPrice = CStr(CDbl(line.SelectSingleNode("unit_price").InnerText) _
                        * (1 + CDbl(line.SelectSingleNode("sales_tax").InnerText) / 100))
                    Case Else
                        uPrice = line.SelectSingleNode("unit_price").InnerText
                End Select
                .CartItems.Add( _
                line.SelectSingleNode("sku").InnerText, _
                    New cmSi.CartItem( _
                        line.SelectSingleNode("sku").InnerText, _
                        line.SelectSingleNode("part_des").InnerText, _
                        uPrice, _
                        line.SelectSingleNode("qty").InnerText, _
                        line.SelectSingleNode("pack_family").InnerText, _
                        line.SelectSingleNode("sales_tax").InnerText, _
                        line.SelectSingleNode("referer").InnerText _
                    ) _
                )
            Next

        End With
    End Sub

    Public Function SaveCart(Optional ByVal OrderID As String = Nothing) As String

        If IsNothing(OrderID) Then
            _PostGuid = System.Guid.NewGuid.ToString
        Else
            _PostGuid = OrderID
        End If

        Dim fn As String = String.Format("{0}orders\{1}.xml", HttpContext.Current.Server.MapPath("\"), _PostGuid.ToString)
        While File.Exists(fn)
            File.Delete(fn)
            Threading.Thread.Sleep(1000)
        End While

        Dim ts As cmSi.Session = cmsSessions.CurrentSession(HttpContext.Current)
        Dim objX As New XmlTextWriter(fn, Nothing)
        With objX
            .WriteStartDocument()
            .WriteStartElement("order_post")
            If CInt(cmsData.Settings.Get("LiveOrders")) = 0 Then .WriteAttributeString("test", "1")
            .WriteElementString("order_id", _PostGuid)
            .WriteElementString("cust_po", custPO)
            Dim prf As Profile.ProfileBase = HttpContext.Current.Profile

            If Not IsNothing(ts.Basket.vouchers) Then
                .WriteStartElement("discounts")
                If Not Vouchers.Count = 0 Then
                    For Each v As String In Vouchers
                        Dim voucher As XmlNode = cmsData.offers.SelectSingleNode( _
                                              "//*[@code=" & Chr(34) & v & Chr(34) & "]" _
                                              )
                        .WriteStartElement("voucher")
                        .WriteAttributeString("voucherdes", _
                                              voucher.Attributes("des").Value)
                        .WriteAttributeString("expiry", _
                                              voucher.Attributes("expiry").Value)
                        .WriteString(v)
                        .WriteEndElement()


                    Next
                Else
                    For Each v As Voucher In ts.Basket.vouchers
                        .WriteElementString("voucher", v.Code)
                    Next
                End If
               
                Dim disc As Double = ts.cart.Discount
                For Each i As CartItem In CartItems.Values
                    disc += i.Discount
                Next
                .WriteElementString("total_discount", disc)
                .WriteEndElement()
            End If
            .WriteElementString("subscribed", ts.cart.Subscribed)
            .WriteElementString("customer_id", ts.cart.CustomerID)
            .WriteElementString("ORDERSOURCE", cmsData.Settings("WebName"))

            If ts.cart.Payment.trans.Length > 0 Then
                .WriteStartElement("payment")
                .WriteElementString("trans", ts.cart.Payment.trans)
                .WriteElementString("authcode", ts.cart.Payment.authcode)
                .WriteElementString("amount", ts.cart.Payment.amount)
                .WriteEndElement() 'End Settings 
            End If

            .WriteStartElement("name")
            .WriteElementString("first", ts.cart.DeliveryAddress.First)
            .WriteElementString("last", ts.cart.DeliveryAddress.Last)
            .WriteEndElement()

            .WriteStartElement("delivery_address")
            .WriteElementString("address_1", ts.cart.DeliveryAddress.Address1)
            .WriteElementString("address_2", ts.cart.DeliveryAddress.Address2)
            .WriteElementString("address_3", ts.cart.DeliveryAddress.Address3)
            .WriteElementString("address_4", ts.cart.DeliveryAddress.Address4)
            .WriteElementString("address_5", ts.cart.DeliveryAddress.Address5)
            .WriteElementString("postcode", ts.cart.DeliveryAddress.Address_Postcode)
            .WriteElementString("email", ts.cart.DeliveryAddress.eMail)
            .WriteElementString("phone", ts.cart.DeliveryAddress.Phone)
            .WriteEndElement()

            .WriteStartElement("lines")
            For Each ci As CartItem In ts.cart.CartItems.Values
                .WriteStartElement("line")
                .WriteElementString("sku", ci.PARTNAME)
                .WriteElementString("part_des", ci.PARTDES)
                .WriteElementString("qty", ci.QTY)
                Select Case CBool(cmsData.Settings("ShowVAT"))
                    Case True
                        .WriteElementString("unit_price", FormatDouble(CStr(CDbl(ci.PARTPRICE) / (1 + (ci.RETAILTAX / 100)))))
                    Case Else
                        .WriteElementString("unit_price", FormatDouble(ci.PARTPRICE))
                End Select
                .WriteElementString("pack_family", ci.PackFamily)
                .WriteElementString("sales_tax", ci.RETAILTAX)
                .WriteElementString("referer", ci.REFERER)
                .WriteElementString("delivery_date", String.Format("{0}-{1}-{2}", Year(Now).ToString, Month(Now).ToString, Day(Now).ToString))

                .WriteEndElement() 'End Settings 
            Next
            .WriteEndElement() 'End Settings 
            .WriteEndElement() 'End Settings 
            .WriteEndDocument()
            .Flush()
            .Close()
        End With
        Return _PostGuid
    End Function

    Public Function PostCart(ByVal Order As String) As Exception

        Dim result As Exception = Nothing

        Dim xmldata As String
        Using sr As New StreamReader(String.Format("{0}orders\{1}.xml", HttpContext.Current.Server.MapPath("\"), Order.ToString))
            xmldata = sr.ReadToEnd
        End Using

        Dim smtp As New Net.Mail.SmtpClient
        For Each recipient As String In cmSi.cmsData.Settings.Get("RcptTO").Split(";")
            Dim mm As New Net.Mail.MailMessage(cmsData.Settings("MailFrom"), recipient)
            With mm
                .Subject = String.Format("New order from {0}.", cmSi.cmsData.Settings.Get("WebName"))
                Dim TestOrder As String = ""
                If cmsData.Settings("LiveOrders") = 0 Then
                    TestOrder = "*TEST*"
                End If
                .Body = String.Format("A new {2} order was placed on {0}. The order referenence was: {1}.", cmSi.cmsData.Settings.Get("WebName"), custPO & " (" & Order.ToString & ") ", TestOrder)
                .IsBodyHtml = False
            End With
            smtp.Send(mm)
        Next

        Dim requestStream As Stream = Nothing
        Dim uploadResponse As Net.HttpWebResponse = Nothing
        Dim myEncoder As New System.Text.ASCIIEncoding
        Dim bytes As Byte() = myEncoder.GetBytes(xmldata)
        Dim ms As MemoryStream = New MemoryStream(bytes)

        Try
            Dim RequestURL As String = cmsData.Settings.Get("OrdersURL")
            Dim uploadRequest As Net.HttpWebRequest = CType(Net.HttpWebRequest.Create(RequestURL), Net.HttpWebRequest)
            uploadRequest.Method = Net.WebRequestMethods.Http.Post
            uploadRequest.Proxy = Nothing
            requestStream = uploadRequest.GetRequestStream()

            ' Upload the XML
            Dim buffer(1024) As Byte
            Dim bytesRead As Integer
            While True
                bytesRead = ms.Read(buffer, 0, buffer.Length)
                If bytesRead = 0 Then
                    Exit While
                End If
                requestStream.Write(buffer, 0, bytesRead)
            End While

            ' The request stream must be closed before getting the response.
            requestStream.Close()

            uploadResponse = uploadRequest.GetResponse()

            Dim thisRequest As New XmlDocument
            With HttpContext.Current
                Dim reader As New StreamReader(uploadResponse.GetResponseStream)
                With thisRequest
                    .LoadXml(reader.ReadToEnd)
                    Dim n As XmlNode = .SelectSingleNode("response")
                    If Not CInt(n.Attributes("status").Value) = 200 Then
                        result = New Exception(n.Attributes("message").Value)
                    End If
                End With
            End With

        Catch ex As UriFormatException
            result = ex
        Catch ex As Net.WebException
            result = ex
        Finally
            If uploadResponse IsNot Nothing Then
                uploadResponse.Close()
            End If
            If requestStream IsNot Nothing Then
                requestStream.Close()
            End If
        End Try
        With cmSi.cmsData.rtSettings
            .SelectSingleNode("settings/last_order").InnerText = (CInt(custPO.Split("-").Last)).ToString("00000000")
            .Save(cmSi.cmsData.rtSettingsPath)
        End With

        Return result

    End Function

#End Region

End Class