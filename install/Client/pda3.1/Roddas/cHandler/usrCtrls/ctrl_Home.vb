﻿Imports System.Xml
Imports CPCL
Imports PriorityMobile

Public Class ctrl_Home
    Inherits iView

    Private ReadOnly Property dllVersionString()
        Get
            With thisForm.thisUserEnv.CustomHandler.GetName.Version
                Return String.Format("{0}.{1}.{2}.{3}", .Major, .Minor, .Build, .Revision)
            End With
        End Get
    End Property

    Private ReadOnly Property exeVersionString()
        Get
            With thisForm.thisUserEnv.exeVersion
                Return String.Format("{0}.{1}.{2}.{3}", .Major, .Minor, .Build, .Revision)
            End With
        End Get
    End Property

    Public Overrides Sub Bind()
        With Me
            Try
                .curdate.Text = thisForm.DateFromInt(CInt(thisForm.FormData.SelectSingleNode("pdadata/home/curdate").InnerText)).ToString("dd/MM/yyy")
                .routenumber.DataBindings.Add("Text", thisForm.TableData, "routenumber")
                .vehiclereg.DataBindings.Add("Text", thisForm.TableData, "vehiclereg")
                .user.Text = thisForm.thisUserEnv.User
                .exeVersion.Text = exeVersionString
                .dllVersion.Text = dllVersionString
            Catch
            End Try
        End With
    End Sub

    Public Overrides Sub CurrentChanged()

    End Sub

    Public Function CRLFifData(ByVal str As String) As String
        If Len(Trim(str)) > 0 Then
            Return str & vbCrLf
        Else
            Return ""
        End If
    End Function

    Public Overrides Function SubFormVisible(ByVal Name As String) As Boolean

        Dim ret As Boolean = True
        Select Case Name.ToUpper

            Case "START DAY"
                Return IsNothing(thisForm.FormData.SelectSingleNode("pdadata/home").Attributes("changed"))

            Case "DELIVERIES"
                Dim maintainance As XmlNode = thisForm.FormData.SelectSingleNode("pdadata/maintainance/daystart")
                For Each response As XmlNode In maintainance.SelectNodes(String.Format(".//question", ""))
                    With response
                        If Not IsNothing(.SelectSingleNode("mandatory")) Then
                            If .SelectSingleNode("mandatory").InnerText = "Y" Then
                                If .SelectSingleNode("response/text").InnerText.Length = 0 And .SelectSingleNode("response/value").InnerText.Length = 0 Then
                                    Return False
                                End If
                            End If
                        End If
                    End With
                Next
                Return True

            Case "END DAY"            
                Dim maintainance As XmlNode = thisForm.FormData.SelectSingleNode("pdadata/maintainance/daystart")
                For Each response As XmlNode In maintainance.SelectNodes(String.Format(".//question", ""))
                    With response
                        If Not IsNothing(.SelectSingleNode("mandatory")) Then
                            If .SelectSingleNode("mandatory").InnerText = "Y" Then
                                If .SelectSingleNode("response/text").InnerText.Length = 0 And .SelectSingleNode("response/value").InnerText.Length = 0 Then
                                    Return False
                                End If
                            End If
                        End If
                    End With
                Next

                Return CBool(thisForm.FormData.SelectNodes("pdadata/home/deliveries/delivery[delivered='N']").Count = 0)

        End Select

        Return ret

    End Function

#Region "Direct Activations"

    Public Overrides Sub DirectActivations(ByRef ToolBar As daToolbar)
        ToolBar.Add(AddressOf hPrintSetup, "print.BMP", Not thisForm.Printer.Connected)
    End Sub

    Private Sub hPrintSetup()
        If thisForm.Printer.Connected Then
            MsgBox("Printer is connected.")
            Exit Sub
        End If
        With thisForm
            Dim dlg As New dlgPRNSetup
            Dim MacAddress As TextBox = dlg.FindControl("MACAddress")
            MacAddress.Text = .MACAddress
            dlg.FocusContolName = "MACAddress"
            .Dialog(dlg)
        End With
    End Sub

    Public Overrides Sub CloseDialog(ByVal frmDialog As PriorityMobile.UserDialog)
        If frmDialog.Result = DialogResult.OK Then
            Dim MacAddress As TextBox = frmDialog.FindControl("MACAddress")            
            With thisForm
                .MACAddress = MacAddress.Text
                With .Printer()                    
                    .BeginConnect(thisForm.MACAddress)
                End With
            End With
        End If
        thisForm.RefreshForm()
        thisForm.RefreshDirectActivations()
    End Sub

    Public Overrides Sub PrintForm()
        Dim headerFont As New PrinterFont(50, 5, 2) 'variable width. 

        Using TestPrint As New Label(thisForm.Printer, eLabelStyle.receipt)
            With TestPrint
                'logo
                .AddImage("roddas.pcx", New Point(186, thisForm.Printer.Dimensions.Height + 10), 147)

                'line
                .AddLine(New Point(10, thisForm.Printer.Dimensions.Height + 10), _
                         New Point(thisForm.Printer.Dimensions.Width - 10, thisForm.Printer.Dimensions.Height + 10), 10, 15)

                'header = 334px wide
                .AddText("TEST PRINT", New Point((thisForm.Printer.Dimensions.Width / 2) - 86, thisForm.Printer.Dimensions.Height + 10), _
                         headerFont)

                'line
                .AddLine(New Point(10, thisForm.Printer.Dimensions.Height + 10), _
                         New Point(thisForm.Printer.Dimensions.Width - 10, thisForm.Printer.Dimensions.Height + 10), 10)

                'tear 'n' print!
                .AddTearArea(New Point(0, thisForm.Printer.Dimensions.Height))
                thisForm.Printer.Print(.toByte)

            End With
        End Using

    End Sub

#End Region

End Class
