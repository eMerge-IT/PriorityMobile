﻿Imports System.Data
Public Class interfaceCheckByCustomer
    Inherits SFDCData.iForm
#Region "Table selection - non barcode"
    Private Sub meclick()
        Try
            If CtrlTable.Table.SelectedIndices.Count = 0 Then
                Exit Sub

            End If


            With CtrlForm
                If Not (.el(.ColNo("ROUTE")).Data.Length > 0) Then MsgBox("Please select a route.")
                'If Not (.el(.ColNo("WHS")).Data.Length > 0) Then MsgBox("Please select a warehouse.")
            End With

            Dim m As Integer
            m = 1

            Dim h As Integer
            h = CtrlTable.Table.Items.Count
            If h >= 0 Then 'check to see if there are any rows to select
                Dim it As ListViewItem
                For Each it In CtrlTable.Table.Items
                    If it.Selected = True Then


                        Dim g As String
                        g = it.SubItems(0).Text
                        CtrlForm.el(4).DataEntry.Text = g
                        CtrlForm.el(4).Text = g
                        CtrlForm.el(4).Update()
                        CtrlForm.el(4).ProcessEntry()

                        Exit For
                    End If
                    If CtrlTable.Table.Items.Count = 0 Then
                        Exit For
                    End If
                Next
            End If
        Catch ex As Exception
            MsgBox("error in non barcode selection -- " & ex.Message)
        End Try






    End Sub
#End Region
#Region "Variables etc"
    Private current_part As String = ""
    Dim FINALLIST As New List(Of PSLIPITEMS)
    Dim changelist As New List(Of ErrorLog)
    '****************************************
    'Dim changelist As New DataTable

    Dim _obscurer As New Dictionary(Of Integer, String)
    Dim doclist As New List(Of WHSTRAN)
    Private PickDate As Integer
    Private CheckID As Integer = 0
    Private CheckLine As Integer = 0
    Private ordname As String
    Public Enum tSendType
        Route = 0
        PackSlip = 1
        Part = 2
        Warhs = 3
        Bin = 4
        Amount = 5
        AmountCheck = 6
        PickID = 7
        LOT = 8
        time = 9
        PickDate = 10
        Cust = 11
        None = 12
        Header = 13
        NextIndex = 14
        DocNo = 15
        GetFlag = 16
    End Enum

#End Region
#Region "Column Declerations"
    Public Overrides Sub FormSettings()
        With field 'using the tfield structure from the ctrlForm
            .Name = "ROUTE"
            .Title = "Route"
            .ValidExp = "^[0-9A-Za-z]+$"
            .SQLValidation = "SELECT ROUTENAME FROM V_PICKED_MONITOR where ROUTENAME = '%ME%'"
            .SQLList = "SELECT distinct ROUTENAME FROM V_PICKED_MONITOR WHERE ZROD_PICKTYPE = 'S'"
            .AltEntry = ctrlText.tAltCtrlStyle.ctList 'ctKeyb 
            .ctrlEnabled = True
            .MandatoryOnPost = False
        End With
        CtrlForm.AddField(field)

        With field 'using the tfield structure from the ctrlForm
            .Name = "FORDATE"
            .Title = "Date"
            .ValidExp = ".*"
            .SQLValidation = "SELECT '%ME%'"
            .SQLList = "SELECT distinct PICKDATE FROM V_PICKED_MONITOR where ROUTENAME = '%ROUTE%' ORDER BY PICKDATE ASC"
            .Data = ""
            .AltEntry = ctrlText.tAltCtrlStyle.ctList 'ctKeyb 
            .ctrlEnabled = True
            .MandatoryOnPost = False
        End With
        CtrlForm.AddField(field)

        With field 'using the tfield structure from the ctrlForm
            .Name = "PICKID"
            .Title = "Pick ID"
            .ValidExp = ValidStr(tRegExValidation.tNumeric)
            .SQLValidation = _
                "SELECT     PICK " & _
                "FROM         ZROD_PICKS " & _
                "WHERE     (FORROUTE = '%ROUTE%')"
            .Data = ""
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ctrlEnabled = False
            .MandatoryOnPost = False
        End With
        CtrlForm.AddField(field)

        With field 'using the tfield structure from the ctrlForm
            .Name = "CUSTOMER"
            .Title = "Customer"
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLValidation = "select '%ME%'"
            .SQLList = "SELECT DISTINCT CUSTDES FROM V_PICKED_MONITOR where ROUTENAME = '%ROUTE%' and PICKDATE = '%FORDATE%' ORDER BY CUSTDES ASC"
            .Data = ""
            .AltEntry = ctrlText.tAltCtrlStyle.ctList 'ctKeyb 
            .ctrlEnabled = True
            .MandatoryOnPost = False
        End With
        CtrlForm.AddField(field)


        With field 'using the tfield structure from the ctrlForm
            .Name = "PART"
            .Title = "Part"
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLValidation = _
                "SELECT     '%ME%'"
            .Data = ""
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ctrlEnabled = False
            .MandatoryOnPost = False
        End With
        CtrlForm.AddField(field)

    End Sub
    Public Overrides Sub TableSettings()
        '0 - part
        With col
            .Name = "_PART"
            .Title = "PART No"
            .initWidth = 40
            .TextAlign = HorizontalAlignment.Left
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tBarcode)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '1 - PARTDES
        With col
            .Name = "_PARTDES"
            .Title = "Part Name"
            .initWidth = 70
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = ""
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '2 - QUANTITY
        With col
            .Name = "_QUANT"
            .Title = "Quantity"
            .initWidth = 0
            .TextAlign = HorizontalAlignment.Left
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tNumeric)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '3 - CHECKED
        With col
            .Name = "_CHECKED"
            .Title = "Picked"
            .initWidth = 25
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = ""
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '4 - CHECK COUNT (AMOUNT OF TIMES CHECKED)
        With col
            .Name = "_COUNT"
            .Title = "Picked"
            .initWidth = 0
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = ""
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '5 - DONE FLAG

        With col
            .Name = "_DONE"
            .Title = "DONE"
            .initWidth = 0
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = ""
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)


        '15 - Packing Amount
        With col
            .Name = "_PACKING"
            .Title = "PACKING"
            .initWidth = 0
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '16 - CONVERTER flag
        With col
            .Name = "_CONVFLAG"
            .Title = "CONVFLAG"
            .initWidth = 0
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '17 - pack count
        With col
            .Name = "_PACKS"
            .Title = "PACKS"
            .initWidth = 20
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

        '18 - single units
        With col
            .Name = "_UNITS"
            .Title = "UNITS"
            .initWidth = 20
            .TextAlign = HorizontalAlignment.Center
            .AltEntry = ctrlText.tAltCtrlStyle.ctNone 'ctKeyb 
            .ValidExp = ValidStr(tRegExValidation.tString)
            .SQLList = ""
            .SQLValidation = "SELECT '%ME%'"
            .DefaultFromCtrl = Nothing
            .ctrlEnabled = False
            .Mandatory = False
            .MandatoryOnPost = False
        End With
        CtrlTable.AddCol(col)

    End Sub
#End Region
#Region "invocations"
    Public Overrides Sub EndInvokeData(ByVal Data(,) As String)
        Select Case SendType
            Case tSendType.GetFlag
                If Data Is Nothing Then

                Else
                    groupy = Data(0, 0)
                    CtrlForm.el(3).ListExp = "SELECT DISTINCT CUSTDES1 + ',' + ORDNAME AS CUSTORD FROM V_CUSTFORCHECK where ROUTENAME = '%ROUTE%' and PICKDATE = '%FORDATE%'"
                End If


            Case tSendType.PickDate
                'This is used to set the argument that stores the picking date from the database
                Try
                    PickDate = Convert.ToInt64(Data(0, 0))
                Catch ex As Exception
                    MsgBox("error in closing -- " & ex.Message)
                End Try


            Case tSendType.DocNo
                doclist.Clear()
                Try
                    If Data Is Nothing Then
                        MsgBox("No available unchecked packing slips for this customer")
                    Else
                        For y As Integer = 0 To UBound(Data, 2)
                            Dim d As New WHSTRAN(Data(0, y), 0, "", "", 0, 0, "")
                            doclist.Add(d)
                        Next
                    End If

                Catch e As Exception
                    MsgBox("error in sendtype docno -- " & e.Message)
                End Try



            Case tSendType.time
                With CtrlForm


                    'With .el(.ColNo("FORDATE"))

                    '    Dim pdate As Date
                    '    pdate = FormatDateTime("1/1/1988", DateFormat.ShortDate)
                    '    Dim am As Integer = 0
                    '    am = Convert.ToInt32(Data(0, 0))
                    '    If am <> 0 Then
                    '        .DataEntry.Text = DateAdd(DateInterval.Minute, am, pdate)
                    '        .Data = DateAdd(DateInterval.Minute, am, pdate)
                    '        Me.Argument("PickDate") = DateAdd(DateInterval.Minute, am, pdate)
                    '    End If
                    '.DataEntry.Text = Data(0, 0)
                    ' End With
                End With

            Case tSendType.LOT
                Try
                    With CtrlForm
                        With .el(.ColNo("PART"))
                            .DataEntry.Text = Data(0, 0)
                            .ProcessEntry()
                        End With
                    End With
                Catch ex As Exception
                    MsgBox("error in sendtype docno -- " & ex.Message)
                End Try


            Case tSendType.Route
                Try
                    With CtrlForm
                        'Select Case groupy
                        '    Case "Y"
                        '        Dim onm() As String
                        '        onm = Data(1, 0).Split(" ")
                        '        ordname = onm(1)
                        'End Select
                        With .el(.ColNo("CUSTOMER"))
                            .DataEntry.Text = Data(0, 0)
                            .Data = Data(0, 0)
                            '.ProcessEntry()
                            .Enabled = False

                        End With
                    End With
                Catch ex As Exception
                    MsgBox("error in sendtype route -- " & ex.Message)
                End Try


            Case tSendType.Header
                Try
                    If Data Is Nothing Then
                    Else
                        Me.Text = Data(0, 0)
                    End If
                Catch ex As Exception
                    MsgBox("error in sendtype header -- " & ex.Message)
                End Try


                'InvokeData("insert into ZROD_CHECK(CHECK_ROUTE,CHECK_DATE,CHECK_PICKDATE,CHECK_BY) VALUES(" & CtrlForm.el(0).Data & "," & PickDate & ", " & PickDate & ", " & UserName & "); SELECT SCOPE_IDENTITY()")
                'SendType = tSendType.NextIndex
                'InvokeData("SELECT MAX(CHECK_LINE) FROM ZROD_CHECK_LINE")

            Case tSendType.NextIndex
                Try
                    CheckLine = Data(0, 0)
                    CheckLine += 1
                Catch ex As Exception
                    MsgBox("error in sendtype checkline -- " & ex.Message)
                End Try



            Case tSendType.Part
                'ITERATE THROUGH THE TABLE TO DESELECT ALL PARTS
                Dim it As ListViewItem
                Try

                    For Each it In CtrlTable.Table.Items
                        it.Selected = False
                    Next
                    Dim m As Integer
                    m = 1

                Catch ex As Exception
                    MsgBox("error in sendtype part (1) -- " & ex.Message)
                End Try

                Dim h As Integer
                h = CtrlTable.Table.Items.Count
                If h >= 0 Then 'check to see if there are any rows to select
                    For Each it In CtrlTable.Table.Items
                        If it.SubItems(0).Text = Data(0, 0) Then
                            'find the correct part in the table
                            it.Selected = True
                            'select the line so the user has visual confirmation
                            If it.SubItems(4).Text <> "o" Then
                                'fires if we have hit this item previously we then need to get the counted amount
                                'the subitems(4) holds the count of the amount of times this item has been checked
                                'and the subitems(3) holds the last count
                                Dim add As Integer
                                Dim num As New frmNumber
                                With num
                                    .Text = it.SubItems(1).Text
                                    .ShowDialog()
                                    add = .number
                                    .Dispose()
                                End With
                                Dim expected, lastcount As Integer
                                Try
                                    Dim t As String = "0"
                                    Dim ind As Integer = Convert.ToInt32(it.SubItems(2).Text)
                                    t = _obscurer.Item(ind)

                                    expected = Convert.ToInt32(t)



                                    'Convert.ToInt32(it.SubItems(2).Text)
                                    lastcount = Convert.ToInt32(it.SubItems(3).Text)
                                    'SendType = tSendType.None
                                    'InvokeData("insert into ZROD_CHECK_LINE(CHECK_UNIQUE,PART,ACTUAL,EXPECTED) VALUES(" & CheckLine & ",'" & it.SubItems(0).Text & "', " & add & ", " & expected & ")")
                                    CheckLine += 1
                                    'Dim SQL As String
                                    'SQL = "UPDATE ZROD_CHECKLINES SET PARTNO = '" & it.SubItems(0).Text & "', COUNTED = " & add & ", EXPECTED =" & expected & ", COUNT_BY ='" & UserName & ", COUNT_ON = " & PickDate
                                    'SendType = tSendType.None
                                    'InvokeData(SQL)
                                Catch ex As Exception
                                    MsgBox("error in sendtype part (2) -- " & ex.Message)
                                End Try
                                'next we check the counted quantity
                                Try
                                    If lastcount = add Then

                                        'we have had 2 counts the same so ......
                                        'we need to compare the amount we have counted (twice) against what is expected
                                        Dim amount As Integer
                                        amount = add - expected
                                        'amount holds the difference between what we counted and what we expected
                                        Dim a, b, c, d As String
                                        a = CtrlForm.el(0).Data
                                        b = CtrlForm.el(3).Data
                                        c = CtrlForm.el(4).Data
                                        d = it.SubItems(1).Text
                                        If amount = 0 Then
                                            'THE ITEMS MATCH SO WE NEED TO ADD IT TO THE FINISHED LIST
                                            Dim finlist As New PSLIPITEMS( _
                                            0, _
                                            CtrlForm.el(0).Data, _
                                            CtrlForm.el(3).Data, _
                                            CtrlForm.el(4).Data, _
                                            add, _
                                            it.SubItems(1).Text, _
                                            "0", _
                                            Me.Argument("HoldWARHS"), _
                                           "0", _
                                            " ", " ", " ", 0, 0, CtrlForm.el(3).Data, 0)
                                            FINALLIST.Add(finlist)

                                            With CtrlTable
                                                .Table.Items.Remove(it)
                                            End With
                                            Exit For
                                        ElseIf amount > 0 Then
                                            'we have too many items intruct user to return surplus


                                            MsgBox("You appear to have picked too many items for this part, please RETURN " & amount & " back to stock")
                                            Dim finlist As New PSLIPITEMS( _
                                           0, _
                                           CtrlForm.el(0).Data, _
                                           CtrlForm.el(3).Data, _
                                           CtrlForm.el(4).Data, _
                                           add, _
                                           it.SubItems(1).Text, _
                                           "0", _
                                           Me.Argument("HoldWARHS"), _
                                          "0", _
                                           " ", " ", " ", 0, 0, CtrlForm.el(3).Data, 0)
                                            FINALLIST.Add(finlist)
                                            Dim err As New ErrorLog("Return", it.SubItems(1).Text, amount)
                                            changelist.Add(err)
                                            err = Nothing
                                            'changelist.Add("Return " & amount & " of " & it.SubItems(1).Text & " back to stock")
                                            With CtrlTable
                                                .Table.Items.Remove(it)
                                            End With
                                            Exit For
                                        ElseIf amount < 0 Then
                                            MsgBox("You appear to have picked too few items for this part, please TAKE " & -amount & " from stock")
                                            Dim finlist As New PSLIPITEMS( _
                                           0, _
                                           CtrlForm.el(0).Data, _
                                           CtrlForm.el(3).Data, _
                                           CtrlForm.el(4).Data, _
                                           add, _
                                           it.SubItems(1).Text, _
                                           "0", _
                                           Me.Argument("HoldWARHS"), _
                                          "0", _
                                           " ", " ", " ", 0, 0, CtrlForm.el(3).Data, 0)
                                            FINALLIST.Add(finlist)
                                            Dim err As New ErrorLog("Take", it.SubItems(1).Text, -amount)
                                            changelist.Add(err)
                                            err = Nothing
                                            'Dim msg As String
                                            'msg = "Take " & amount & " of " & it.SubItems(1).Text & " from stock"
                                            'Try
                                            '    changelist.Add(msg)
                                            'Catch ex As Exception
                                            '    MsgBox(ex.ToString)
                                            'End Try

                                            With CtrlTable
                                                .Table.Items.Remove(it)
                                            End With
                                            Exit For
                                        End If
                                    Else

                                        MsgBox("This count does not match the expected amount, please RECOUNT and try again")
                                        it.SubItems(3).Text = add
                                        Dim counts As Integer
                                        counts = Convert.ToInt32(it.SubItems(4).Text)
                                        counts += 1
                                        it.SubItems(4).Text = counts

                                    End If
                                Catch ex As Exception
                                    MsgBox("error in sendtype part (2) -- " & ex.Message)
                                End Try


                            Else
                                Try
                                    'we havent had a check on this item yet as the check is still set to o
                                    'so we will need to get the amount counted by calling the number pad
                                    Dim add As Integer
                                    Dim num As New frmNumber
                                    With num
                                        .Text = it.SubItems(1).Text
                                        .ShowDialog()
                                        add = .number
                                        .Dispose()
                                    End With
                                    'now we check the number against the expected amount
                                    Dim expected As Integer
                                    Dim t As String = "0"
                                    Dim ind As Integer = Convert.ToInt32(it.SubItems(2).Text)
                                    t = _obscurer.Item(ind)

                                    expected = Convert.ToInt32(t)
                                    SendType = tSendType.None
                                    'InvokeData("insert into ZROD_CHECK_LINE(CHECK_UNIQUE,PART,ACTUAL,EXPECTED) VALUES(" & CheckLine & ",'" & it.SubItems(0).Text & "', " & add & ", " & expected & ")")
                                    'CheckLine += 1
                                    'Dim SQL As String
                                    'SQL = "UPDATE ZROD_CHECKLINES SET PARTNO = '" & it.SubItems(0).Text & "', COUNTED = " & add & ", EXPECTED =" & expected & ", COUNT_BY ='" & UserName & ", COUNT_ON = " & PickDate
                                    'SendType = tSendType.None
                                    'InvokeData(SQL)
                                    Dim a, b, c, d As String
                                    a = CtrlForm.el(0).Data
                                    b = CtrlForm.el(3).Data
                                    c = CtrlForm.el(4).Data
                                    d = it.SubItems(1).Text
                                    If add = expected Then
                                        Dim finlist As New PSLIPITEMS( _
                                           0, _
                                           CtrlForm.el(0).Data, _
                                           CtrlForm.el(3).Data, _
                                           CtrlForm.el(4).Data, _
                                           add, _
                                           it.SubItems(1).Text, _
                                           "0", _
                                           Me.Argument("HoldWARHS"), _
                                          "0", _
                                           " ", " ", " ", 0, 0, CtrlForm.el(3).Data, 0)
                                        FINALLIST.Add(finlist)
                                        'the check is fine, this line can be hidden
                                        'TODO add hiding ability or add a boolean field to check against so that any attempts to recheck a done line error out
                                        CtrlTable.Table.Items.Remove(it)
                                        Exit For
                                    ElseIf add < expected Then
                                        MsgBox("This count does not match the expected amount, please RECOUNT and try again")
                                        it.SubItems(3).Text = add
                                        it.SubItems(4).Text = 1
                                    ElseIf add > expected Then
                                        MsgBox("This count does not match the expected amount, please RECOUNT and try again")
                                        it.SubItems(3).Text = add
                                        it.SubItems(4).Text = 1
                                    End If
                                    current_part = it.SubItems(0).Text
                                Catch ex As Exception
                                    MsgBox("error in sendtype part (3) -- " & ex.Message)
                                End Try



                            End If

                        End If
                    Next
                End If
        End Select
    End Sub
    Dim SendType As tSendType = tSendType.Route

    Private groupy As String = ""
#End Region
#Region "Form Processing"
    Public Overrides Sub AfterAdd(ByVal TableIndex As Integer)

    End Sub

    Public Overrides Sub AfterEdit(ByVal TableIndex As Integer)

    End Sub

    Public Overrides Sub BeginAdd()

    End Sub

    Public Overrides Sub BeginEdit()

    End Sub

    Public Overrides Sub ProcessEntry(ByVal ctrl As SFDCData.ctrlText, ByVal Valid As Boolean)
        Select Case Valid
            Case False
                Beep()

            Case True
                Dim i As String
                i = ctrl.Data.ToString

                If ctrl.Data <> "" Then
                    Select Case ctrl.Name
                        Case "ROUTE"
                            SendType = tSendType.GetFlag
                            InvokeData("SELECT GROUPFLAG FROM ZROD_ROUTES WHERE ROUTENAME = '%ROUTE%'")

                        Case "FORDATE"
                            'SendType = tSendType.Route
                            Try
                                'InvokeData("SELECT CUSTNAME FROM dbo.V_Route_Customer  WHERE ZROD_ROUTE = '%ROUTE%' ")
                                Me.CtrlTable.Table.Items.Clear()
                                Dim j As DateTime = FormatDateTime("1/1/1988", DateFormat.LongDate)
                                Dim hh As Integer = DateDiff(DateInterval.Minute, j, Now)

                                SendType = tSendType.PickDate
                                InvokeData("SELECT DUEDATE FROM V_PICKED_MONITOR WHERE PICKDATE = '%FORDATE%' AND ROUTENAME = '%ROUTE%' AND ZROD_PICKTYPE = 'S'")

                                SendType = tSendType.Cust
                                Dim PD As Integer
                                Dim t As String = PickDate

                                PD = Convert.ToInt64(t)


                                'InvokeData("exec dbo.SP_SFDC_UPDATEITEMS " & RouteID & "," & PD)
                                'SendType = tSendType.Route
                                'InvokeData("select dbo.FUNC_ROUTE_CHECKED('%ROUTE%'," & PickDate & ") as DOCNO")
                                With CtrlForm
                                    With .el(.ColNo("ROUTE"))
                                        .Enabled = False
                                        Me.Argument("HoldWARHS") = .Data & "PI"
                                    End With
                                    SendType = tSendType.Bin
                                    'check to see if a customer exists for this route and if so get the first one

                                End With


                                'With CtrlForm
                                '    Me.Text = Data(0, 0)
                                '    With .el(.ColNo("CUSTOMER"))
                                '        .DataEntry.Text = Data(0, 0)
                                '        .ProcessEntry()

                                '    End With

                                'End With
                                'SendType = tSendType.Header
                                'InvokeData("insert into ZROD_CHECK(CHECK_ROUTE,CHECK_DATE,CHECK_PICKDATE,CHECK_BY) VALUES('" & CtrlForm.el(0).Data & "'," & hh & ", " & PickDate & ", '" & UserName & "'); SELECT SCOPE_IDENTITY()")

                            Catch ex As Exception
                                MsgBox("error in process f0r date -- " & ex.Message)

                            End Try

                        Case "PART"
                            Try
                                SendType = tSendType.Part

                                InvokeData("SELECT PARTNAME FROM V_PICKED_MONITOR WHERE PARTNAME = '%PART%'")
                            Catch ex As Exception
                                MsgBox("error in process pick id -- " & ex.Message)
                            End Try

                        Case "CUSTOMER"
                            Try
                                Dim hold() As String
                                hold = CtrlForm.el(3).Data.Split(",")

                                With CtrlForm
                                    Me.Text = hold(0)
                                End With
                                Select Case groupy
                                    Case "Y"
                                        SendType = tSendType.Route
                                        ordname = hold(1)
                                        InvokeData("select CUSTNAME FROM V_CUSTFORCHECK WHERE CUSTDES1 = '" & hold(0) & "'")

                                        CtrlTable.RecordsSQL = _
                     "select PARTNAME,PARTDES,QUANT as PICKED,'o' as CHECK_SUM, 'o' as CHECK_COUNT,CONV,PACKING,NOTFIXEDCONV " & _
                     "from V_PICKED_MONITOR " & _
                     "WHERE ROUTENAME = '%ROUTE%' AND DUEDATE = " & PickDate & " AND ORDNAME = '" & ordname & "' " & _
                     "order BY PARTNAME"
                                    Case Else
                                        SendType = tSendType.Route
                                        InvokeData("select CUSTNAME FROM V_PICKED_MONITOR WHERE CUSTDES = '%CUSTOMER%'")

                                        CtrlTable.RecordsSQL = _
                     "select PARTNAME,PARTDES,sum(dbo.REALQUANT(QUANT)) as PICKED,'o' as CHECK_SUM, 'o' as CHECK_COUNT,CONV,PACKING,NOTFIXEDCONV " & _
                     "from V_PICKED_MONITOR " & _
                     "WHERE CUSTNAME = '%CUSTOMER%' AND ROUTENAME = '%ROUTE%' AND DUEDATE = " & PickDate & _
                     " group by PARTNAME,PARTDES,CONV,PACKING,NOTFIXEDCONV " & _
                     "order BY PARTNAME"
                                End Select



                                With CtrlTable
                                    .Table.Items.Clear()
                                    .BeginLoadRS()
                                    .Table.Focus()
                                End With
                                SendType = tSendType.Header
                                Select Case groupy
                                    Case "Y"
                                        InvokeData("SELECT CUSTDES FROM V_PICKED_MONITOR WHERE ORDNAME = '" & ordname & "'")
                                    Case Else
                                        InvokeData("SELECT CUSTDES FROM V_PICKED_MONITOR WHERE CUSTNAME = '%CUSTOMER%'")
                                End Select
                                'InvokeData("SELECT CUSTDES FROM V_PICKED_MONITOR WHERE CUSTNAME = '%CUSTOMER%'")

                                doclist.Clear()

                                SendType = tSendType.DocNo
                                Select Case groupy
                                    Case "Y"
                                        InvokeData("SELECT DISTINCT DOCNO FROM V_Route_Customer WHERE ORDNAME = '" & ordname & "' AND ZROD_ROUTE = '%ROUTE%' AND PICKDATE = '%FORDATE%'")
                                    Case Else
                                        InvokeData("SELECT DISTINCT DOCNO FROM V_Route_Customer WHERE CUSTNAME = '%CUSTOMER%' AND ZROD_ROUTE = '%ROUTE%' AND PICKDATE = '%FORDATE%'")
                                End Select

                                'changelist.Columns.Add("Trans Type", GetType(String))
                                'changelist.Columns.Add("Part", GetType(String))
                                'changelist.Columns.Add("Quant", GetType(Integer))
                            Catch ex As Exception
                                MsgBox("error in process customer -- " & ex.Message)
                            End Try


                    End Select
                End If

        End Select

    End Sub

    Public Overrides Sub ProcessForm()
        With CtrlForm
            If .el(3).Data.Length = 0 Then

            Else
                Try
                    With p
                        .DebugFlag = False
                        .Procedure = "ZSFDC_LOAD_VAN"
                        .Table = "ZSFDC_LOAD_VAN"
                        .RecordType1 = "CURDATE,WARHSNAME,LOCNAME,TOWARHSNAME,TOLOCNAME,USERLOGIN"
                        .RecordType2 = "DOCNO"
                        .RecordTypes = "TEXT,TEXT,TEXT,TEXT,TEXT,TEXT,TEXT"
                    End With

                Catch e As Exception
                    MsgBox("Error creating loading" & e.Message)
                End Try

                ' Type 1 records
                Try
                    Dim startdate As Date = FormatDateTime("1/1/1988", DateFormat.LongDate)
                    Dim nowdate As Integer = DateDiff(DateInterval.Minute, startdate, Now())
                    Dim t1() As String = { _
                                        nowdate, _
                                        CtrlForm.ItemValue("ROUTE") & "PI", _
                                        "0", _
                                        CtrlForm.ItemValue("ROUTE"), _
                                        "0", _
                                        UserName}
                    p.AddRecord(1) = t1

                    For y As Integer = 0 To (doclist.Count - 1)
                        Dim t2() As String = {doclist(y).trPart}
                        p.AddRecord(2) = t2
                    Next
                    doclist.Clear()

                    FINALLIST.Clear()
                    If changelist.Count > 0 Then
                        Dim f As New frmDisplay
                        f.Text = "Error Report"
                        Dim startpos As New Point(3, 11)
                        Dim errsize As New Size(400, 30)
                        f.Panel1.Controls.Clear()
                        For Each h As ErrorLog In changelist
                            Dim errlab As Label = New Label
                            errlab.Location = startpos
                            errlab.Size = errsize
                            startpos.Y += 70
                            errlab.Text = h.EType.ToUpper & " " & h.Amount & " " & h.Desc
                            f.Panel1.Controls.Add(errlab)
                        Next



                        Argument("PickDate") = ""
                        Argument("HoldWARHS") = ""
                        Me.Text = ""
                        f.ShowDialog()
                        changelist.Clear()
                        doclist.Clear()

                    End If
                    'SendType = tSendType.time
                Catch ex As Exception
                    MsgBox("error creating loading data -- " & ex.Message)
                End Try


                'InvokeData("UPDATE ORDERITEMS SET ZROD_IN_CHECK = 'Y', ZROD_CHECKED_ON = dbo.DATETOMIN(GETDATE()), ZROD_CHECKED_BY = " & UserName & " WHERE  CUSTNAME = '%CUSTOMER%' AND ROUTENAME = '%ROUTE%' AND DUEDATE = " & pickdate)
            End If
        End With



    End Sub
#End Region
    Public Sub New(Optional ByRef App As Form = Nothing)

        'InitializeComponent()
        CallerApp = App
        NewArgument("PickDate", " ")
        NewArgument("HoldWARHS", " ")
        AddHandler CtrlTable.Table.ItemActivate, AddressOf meclick
    End Sub



    Public Overrides Sub TableRXData(ByVal Data(,) As String)
        _obscurer.Clear()

        If Data Is Nothing Then
            Exit Sub
        End If
        Try
            For y As Integer = 0 To UBound(Data, 2)
                Dim lvi As New ListViewItem
                Dim Q As Decimal
                Q = Data(2, y)
                'If Data(5, y) <> 1 Then
                '    Q = Q * Data(5, y)
                'End If
                Dim pack, singl, tot As Integer
                pack = 0
                singl = 0
                If Data(6, y) <> 0 And Data(7, y) <> "Y" Then
                    tot = Data(2, y)
                    pack = tot \ Data(6, y)
                    singl = tot Mod Data(6, y)
                End If
                Dim hstring As String = "9999" & y
                _obscurer.Add(hstring, Q)
                With CtrlTable.Table
                    .Items.Add(lvi)
                    .Items(.Items.Count - 1).Text = Data(0, y)
                    .Items(.Items.Count - 1).SubItems.Add(Data(1, y))
                    .Items(.Items.Count - 1).SubItems.Add(hstring)
                    .Items(.Items.Count - 1).SubItems.Add(Data(3, y))
                    .Items(.Items.Count - 1).SubItems.Add(Data(4, y))
                    .Items(.Items.Count - 1).SubItems.Add("N")
                    .Items(.Items.Count - 1).SubItems.Add(Data(6, y))
                    .Items(.Items.Count - 1).SubItems.Add(Data(7, y))
                    .Items(.Items.Count - 1).SubItems.Add(pack)
                    .Items(.Items.Count - 1).SubItems.Add(singl)
                End With

            Next
        Catch e As Exception
            MsgBox("error in tablerxdata -- " & e.Message)
        End Try
    End Sub


    Public Overrides Sub TableScan(ByVal Value As String)
        Try
            If System.Text.RegularExpressions.Regex.IsMatch(Value, ValidStr(tRegExValidation.tBarcode)) Or System.Text.RegularExpressions.Regex.IsMatch(Value, ValidStr(tRegExValidation.tBarcode2)) Then
                ' Scanning a barcode
                With CtrlForm
                    With .el(.ColNo("PART"))
                        .DataEntry.Text = Value
                        .ProcessEntry()
                    End With
                End With



                'SendType = tSendType.TableScan
                'InvokeData("SELECT PARTNAME, BARCODE FROM PART WHERE BARCODE = '" & Value & "'")
            ElseIf System.Text.RegularExpressions.Regex.IsMatch(Value, ValidStr(tRegExValidation.tLotNumber)) Then
                ' Scanning a Lot Number
                With CtrlForm

                    ' A warehouse must be selected
                    'If Not (.el(.ColNo("WHS")).Data.Length > 0) Then Throw New Exception("Please select a warehouse.")
                    SendType = tSendType.LOT
                    InvokeData("select distinct [PARTNAME],[SERIALNAME],[balance],[EXPIRYDATE],[WARHSNAME],[LOCNAME],[TYPE] from dbo.V_PICKLIST_PARTS where SERIALNAME = '" & Value & "'")
                End With


            Else
                Throw New Exception("Scanned item is not a part or a Lot")
            End If

        Catch EX As Exception
            MsgBox(String.Format(" error in scanning -- {0}", EX.Message))
        End Try


    End Sub




    Public Overrides Function VerifyForm() As Boolean
        Try
            If CtrlTable.Table.Items.Count = 0 Then
                Return True
            Else
                'MsgBox("Not all items have been checked, please check them before continuing.")
                'Return False
                Return True
            End If
        Catch ex As Exception
            MsgBox("error in process verify form -- " & ex.Message)
            Return False
        End Try

    End Function
End Class
