﻿Imports PriorityMobile
Imports System.Xml
Imports System.Data

Public Class ctrl_Parts_Actual
    Inherits iView

    Private ReadOnly Property whCurr() As xForm
        Get
            Return TopForm("Warehouse").CurrentForm
        End Get
    End Property

    Private ReadOnly Property whCurrView() As iView
        Get
            Return whCurr.Views(whCurr.CurrentView)
        End Get
    End Property

#Region "Initialisation and Finalisation"

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        With Me
            With ListSort1
                .Sort = "name"
                .AddColumn("name", "Part", 150)
                .AddColumn("des", "Description", 250)
                .AddColumn("serial", "Serial No", 150)
                .AddColumn("qty", "Qty", 50)
                .AddColumn("location", "Location", 250)
            End With
        End With

    End Sub

#End Region

#Region "Overides Base Properties"

    Public Overrides ReadOnly Property ButtomImage() As String
        Get
            Return "actual.BMP"
        End Get
    End Property

    Public Overrides ReadOnly Property Selected() As String
        Get
            Return ListSort1.Selected
        End Get
    End Property

#End Region

#Region "Overrides base Methods"

    Public Overrides Sub Bind() Handles ListSort1.Bind

        IsBinding = True
        Dim dr() As Data.DataRow = Nothing
        Dim query As String = String.Format( _
                "planned <> 'Y' and id <> 'dummy'" _
                )
        dr = thisForm.Datasource.Select(query, ListSort1.Sort)

        With ListSort1
            .Clear()
            For Each r As System.Data.DataRow In dr
                .AddRow(r)
                With .Items(.Items.Count - 1)
                    If String.Compare(r("name"), thisForm.CurrentRow("name"), True) = 0 And _
                        String.Compare(r("serial"), thisForm.CurrentRow("serial"), True) = 0 _
                    Then
                        .Selected = True
                        .Focused = True
                    Else
                        .Selected = False
                        .Focused = False
                    End If
                End With
            Next
            .Focus()
        End With
        thisForm.RefreshSubForms()
        IsBinding = False

    End Sub

    Public Overrides Sub SetFocus()
        Me.ListSort1.Focus()
    End Sub

    Public Overrides Sub ViewChanged()
        Bind()
    End Sub

#End Region

#Region "Direct Activations"

    Public Overrides Sub DirectActivations(ByRef ToolBar As daToolbar)
        With ToolBar
            .Add(AddressOf hCalc, "edit.BMP", (ListSort1.SelectedIndex <> -1))
            .Add(AddressOf hDeleteActual, "delete.BMP", (ListSort1.SelectedIndex <> -1))
        End With
    End Sub

    Public Overrides Sub SetNumber(ByVal MyValue As Integer)

        With thisForm

            If .CurrentRow("fromstock") = "Y" Then
                Dim whNode As XmlNode = .FormData.SelectSingleNode( _
                    String.Format("pdadata/warehouse/part[name={0}{1}{0} and serial={0}{2}{0}]", _
                            Chr(34), _
                            .CurrentRow("name"), _
                            .CurrentRow("serial") _
                        ) _
                    )
                If Not IsNothing(whNode) Then
                    Dim DIF As Integer = MyValue - CInt(.CurrentRow("qty"))
                    whNode.SelectSingleNode("qty").InnerText = CStr(CInt(whNode.SelectSingleNode("qty").InnerText) - DIF)                    
                    whCurr.TableData.EndEdit()
                    .Save()
                End If
            End If

            .CurrentRow("qty") = MyValue
            .TableData.EndEdit()
            .Bind()
            For Each V As iView In .Views
                V.Bind()
            Next

            .Views(.CurrentView).RefreshData()
            .RefreshForm()

            whCurr.Bind()
            With whCurrView
                .RefreshData()
                For Each V As iView In .thisForm.Views
                    V.Bind()
                Next
            End With

        End With

    End Sub

    Private Sub hCalc()

        With thisForm
            Dim whNode As XmlNode = .FormData.SelectSingleNode( _
                String.Format("pdadata/warehouse/part[name={0}{1}{0} and serial={0}{2}{0}]", _
                          Chr(34), _
                        .CurrentRow("name"), _
                        .CurrentRow("serial") _
                    ) _
                )
            If Not IsNothing(whNode) Then
                thisForm.Calc(CInt(thisForm.CurrentRow("qty")) + CInt(whNode.SelectSingleNode("qty").InnerText))
            Else
                thisForm.Calc(thisForm.CurrentRow("qty"))
            End If
        End With

    End Sub

    Private Sub hDeleteActual()

        With thisForm
            If MsgBox(String.Format("This will remove part {0} from the call. Are you sure?", thisForm.CurrentRow("name")), MsgBoxStyle.OkCancel, "Confirm?") = MsgBoxResult.Cancel Then Exit Sub
            If String.Compare(thisForm.CurrentRow("fromstock"), "y", True) = 0 Then
                Dim whNode As XmlNode = .FormData.SelectSingleNode( _
                    String.Format("pdadata/warehouse/part[name={0}{1}{0} and serial={0}{2}{0}]", _
                            Chr(34), _
                            .CurrentRow("name"), _
                            .CurrentRow("serial") _
                        ) _
                    )
                If Not IsNothing(whNode) Then
                    whNode.SelectSingleNode("qty").InnerText = CStr(CInt(whNode.SelectSingleNode("qty").InnerText) + CInt(.CurrentRow("qty")))
                    .TableData.EndEdit()
                    .Save()
                End If
            End If
        End With

        Dim removenode As XmlNode = xmlForms.FormData.Document.SelectSingleNode(myxPath)
        removenode.ParentNode.RemoveChild(removenode)
        thisForm.Save()
        RefreshData()

        With Me
            .RefreshData()
            For Each V As iView In .thisForm.Views
                V.Bind()
            Next
        End With

        whCurr.Bind()
        With whCurrView
            .RefreshData()
            For Each V As iView In .thisForm.Views
                V.Bind()
            Next
        End With

    End Sub

#End Region

    Private ReadOnly Property myxPath()
        Get
            Dim path As String
            If IsNothing(thisForm.TableData.Current) Then Return Nothing
            path = String.Format("/parts/part[name={0}{1}{0} and serial = {0}{2}{0}]", _
               Chr(34), _
               ListSort1.Value("name", ListSort1.SelectedIndex), _
               ListSort1.Value("serial", ListSort1.SelectedIndex) _
            )

            Dim p As xForm = thisForm.Parent
            Dim k As String
            Dim repeat As Boolean = True
            Do
                If Not IsNothing(p.thisNode.Attributes("key")) And Not IsNothing(p.TableData.Current) Then
                    k = parseKey(p)
                Else
                    k = ""
                End If
                path = String.Format("{0}{1}{2}", p.xPath, k, path)
                If Not IsNothing(p.Parent) Then
                    p = p.Parent
                Else
                    repeat = False
                End If
            Loop Until Not repeat
            Return path
        End Get
    End Property

    Private Function parseKey(ByVal p As xForm) As String

        Dim bstr As String = ""
        Dim keys() As String = Split(p.thisNode.Attributes("key").Value, ",")

        For i As Integer = 0 To keys.Count - 1
            bstr += String.Format( _
                "{1}={0}{2}{0}", _
                Chr(34), _
                keys(i), _
                p.CurrentRow(keys(i)) _
            )
            If i < keys.Count - 1 Then
                bstr += " and "
            End If
        Next

        Return String.Format( _
            "[{0}]", _
            bstr _
        )

    End Function

    Private Sub hSelectedindexChanged(ByVal row As Integer) Handles ListSort1.SelectedIndexChanged
        If IsBinding Then Exit Sub
        With thisForm
            Dim cur As String = ListSort1.Value("name", row) & "~" & ListSort1.Value("serial", row)
            If Not (String.Compare(.CurrentRow("name"), ListSort1.Value("name", row)) = 0 And String.Compare(.CurrentRow("serial"), ListSort1.Value("serial", row)) = 0) Then
                .TableData.Position = .TableData.Find("id", cur)
                .RefreshSubForms()
                .RefreshDirectActivations()
            End If
        End With
    End Sub
End Class
