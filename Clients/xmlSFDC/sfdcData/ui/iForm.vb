﻿Imports System.Windows.Forms
Imports Microsoft.WindowsCE.Forms
Imports PrioritySFDC
Imports System.Reflection
Imports System.IO

Public Class iForm : Inherits BaseForm

#Region "Initialisation and Finalisation"

    Private hConnectPrinter As CPCL.PrinterConnectionHandler = Nothing

    Public Sub New(ByRef intf As cInterface, ByRef closeHandler As EventHandler)

        InitializeComponent()
        Cursor.Current = Cursors.WaitCursor

        Select Case SystemSettings.Platform
            Case WinCEPlatform.WinCEGeneric
                Me.Menu = Nothing
            Case Else
                Me.Menu = Me.MainMenu1
        End Select

        intf.SetiForm(Me)
        _intf = intf
        _ue = intf.ue
        _DataService = New Priority.GetData(_ue.Server.ToString)

        If IsNothing(intf.strHandler) Then
            _thisHandler = New defaultHandler()
        Else
            Dim oType As System.Type = Nothing
            Dim oAssembly As System.Reflection.Assembly = _ue.CustomHandler
            If IsNothing(oAssembly) Then
                Throw New cfmtException("Custom Handler Assembly not found.")
            End If
            Try
                oType = oAssembly.GetType(String.Format("cHandler.{0}", intf.strHandler))
            Catch EX As Exception
                Throw New cfmtException("Failed to load handler [cHandler.{0}]: {1}", intf.strHandler, EX.Message)
            End Try
            Try
                _thisHandler = Activator.CreateInstance(oType)
            Catch ex As Exception
                Throw New cfmtException("Failed to create instance of [cHandler.{0}]: {1}", intf.strHandler, ex.Message)
            End Try
        End If

        _thisHandler.CloseHandler = closeHandler

        With Me

            With .Controls
                .Add(ViewDialog)
                .Add(ViewCalc)
                .Add(ViewMain)
                .Add(ViewSignature)
            End With

            With .ViewMain
                .Load(Me, intf)
                .TableView.TableView = PrioritySFDC.TableView.eTableView.vTable
                .Visible = True
                .Dock = DockStyle.Fill
            End With

            With .ViewCalc
                .Load(Me)
                .Visible = False
                .Dock = DockStyle.None
            End With

            With .ViewDialog
                .Load(Me)
                .Visible = False
                .Dock = DockStyle.None
            End With

            With .ViewSignature
                .Load(Me)
                .Visible = False
                .Dock = DockStyle.None
            End With

            .SetView()

        End With

        Cursor.Current = Cursors.Default
        AddHandler _DataService.StartRead, AddressOf hStartRead
        AddHandler _DataService.EndRead, AddressOf hEndRead

    End Sub

    Public Sub FormActivate()
        Me.Show()
    End Sub

    Private Sub iForm_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        If Not Posted Then
            If MsgBox("Close this form?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                thisHandler.Close(Me)
                Me.Close()
            Else
                e.Cancel = True
            End If
        Else
            thisHandler.Close(Me)
            Me.Close()
        End If
    End Sub

    Private Sub MenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem1.Click
        Me.Hide()
    End Sub

#End Region

#Region "Public Properties"

    Private _Posted As Boolean = False
    Public Property Posted() As Boolean
        Get
            Return _Posted
        End Get
        Set(ByVal value As Boolean)
            _Posted = value
        End Set
    End Property

    Private _intf As cInterface
    Public ReadOnly Property thisInterface() As cInterface
        Get
            Return _intf
        End Get
    End Property

    Private _thisHandler As iHandler
    Public Property thisHandler() As iHandler
        Get
            Return _thisHandler
        End Get
        Set(ByVal value As iHandler)
            _thisHandler = value
        End Set
    End Property

    Private _ue As UserEnv = Nothing
    Public Property ue() As UserEnv
        Get
            Return _ue
        End Get
        Set(ByVal value As UserEnv)
            _ue = value
        End Set
    End Property

    Private _DataService As Priority.GetData
    Public ReadOnly Property DataService() As Priority.GetData
        Get
            Return _DataService
        End Get
    End Property

    Public Property Printer() As CPCL.LabelPrinter
        Get
            Return prn
        End Get
        Set(ByVal value As CPCL.LabelPrinter)
            prn = value
            hConnectPrinter = AddressOf hPrinterConnect
            AddHandler prn.connectionEstablished, hConnectPrinter
            If File.Exists(_ue.AppPath & "\prnmac.txt") Then
                Using sr As New StreamReader(_ue.AppPath & "\prnmac.txt")
                    prnmac = sr.ReadToEnd
                End Using
            Else
                prnmac = Nothing
            End If
        End Set
    End Property

    Private Sub hPrinterConnect()
        'thisHandler.PrintForm(Me)
    End Sub

#Region "Form Views"

    Public Enum eiFromView
        ViewMain
        ViewCalc
        ViewDialog
        ViewSignature
    End Enum

    Private _View As eiFromView = eiFromView.ViewMain
    Public Property View() As eiFromView
        Get
            Return _View
        End Get
        Set(ByVal value As eiFromView)
            _View = value
            SetView()
        End Set
    End Property

    Private Sub SetView()
        With Me
            Select Case _View
                Case eiFromView.ViewMain
                    With .ViewMain
                        If Not .Visible Then
                            .Dock = DockStyle.Fill
                            .Visible = True
                        End If
                        .BringToFront()
                        .Focus()
                    End With

                Case eiFromView.ViewCalc
                    With .ViewCalc
                        If Not .Visible Then
                            .Dock = DockStyle.Fill
                            .Visible = True
                        End If
                        .BringToFront()
                        .Focus()
                    End With

                Case eiFromView.ViewDialog
                    With .ViewDialog
                        If Not .Visible Then
                            .Dock = DockStyle.Fill
                            .Visible = True
                        End If
                        .BringToFront()
                        .Focus()
                    End With

                Case eiFromView.ViewSignature
                    With .ViewSignature
                        If Not .Visible Then
                            .Dock = DockStyle.Fill
                            .Visible = True
                        End If                        
                        .BringToFront()
                        .Focus()
                        .ResizeMe(Me, New System.EventArgs)
                    End With

            End Select

            If Not View = eiFromView.ViewMain Then
                With .ViewMain
                    If .Visible Then
                        .Dock = DockStyle.None
                        .Visible = False
                    End If
                End With
            End If
            If Not View = eiFromView.ViewCalc Then
                With .ViewCalc
                    If .Visible Then
                        .Dock = DockStyle.None
                        .Visible = False
                    End If
                End With
            End If
            If Not View = eiFromView.ViewDialog Then
                With .ViewDialog
                    If .Visible Then
                        .Dock = DockStyle.None
                        .Visible = False
                    End If
                End With
            End If
            If Not View = eiFromView.ViewSignature Then
                With .ViewSignature
                    If .Visible Then
                        .Dock = DockStyle.None
                        .Visible = False
                    End If
                End With
            End If

        End With
    End Sub

#End Region

#Region "Container Panels"

    Private _ViewMain As New FormPanel
    Public Property ViewMain() As FormPanel
        Get
            Return _ViewMain
        End Get
        Set(ByVal value As FormPanel)
            _ViewMain = value
        End Set
    End Property

    Private _ViewCalc As New CalcPanel
    Public Property ViewCalc() As CalcPanel
        Get
            Return _ViewCalc
        End Get
        Set(ByVal value As CalcPanel)
            _ViewCalc = value
        End Set
    End Property

    Private _ViewDialog As New DialogPanel
    Public Property ViewDialog() As DialogPanel
        Get
            Return _ViewDialog
        End Get
        Set(ByVal value As DialogPanel)
            _ViewDialog = value
        End Set
    End Property

    Private _ViewSignature As New SignPanel
    Public Property ViewSignature() As SignPanel
        Get
            Return _ViewSignature
        End Get
        Set(ByVal value As SignPanel)
            _ViewSignature = value
        End Set
    End Property

#End Region

#End Region

#Region "User Dialogs"

    Private calcResult As calcSetting
    Private calcFinish As Boolean = False

    Public Function Calc(ByVal setting As calcSetting) As calcSetting
        With Me
            calcFinish = False

            .ViewCalc.InitSetting(setting)
            AddHandler .ViewCalc.SetNumber, AddressOf hCalc
            .View = iForm.eiFromView.ViewCalc

            While Not calcFinish
                Application.DoEvents()
            End While

            RemoveHandler .ViewCalc.SetNumber, AddressOf hCalc
            .View = iForm.eiFromView.ViewMain

            Return calcResult
        End With
    End Function

    Private Sub hCalc(ByRef cSetting As calcSetting)
        With Me
            calcResult = cSetting
            calcFinish = True
        End With
    End Sub

    Public Sub Dialog(ByRef frmDialog As PrioritySFDC.UserDialog, Optional ByVal frmName As String = "")
        frmDialog.frmName = frmName
        With Me
            With .ViewDialog.Controls
                .Clear()
                .Add(frmDialog)
                .Item(.Count - 1).Dock = DockStyle.Fill
                AddHandler frmDialog.CloseDialog, AddressOf hCloseFrmDialog
            End With

            .View = eiFromView.ViewDialog

        End With
    End Sub

    Private Sub hCloseFrmDialog(ByRef frmDialog As PrioritySFDC.UserDialog)
        With Me
            .View = eiFromView.ViewMain
            With .thisHandler
                .CloseDialog(Me, frmDialog)
            End With
        End With
    End Sub

#End Region

#Region "Data Event Handlers"

    Private Sub hStartRead()
        Cursor.Current = Cursors.WaitCursor
    End Sub

    Private Sub hEndRead()
        Cursor.Current = Cursors.Default
    End Sub

#End Region

End Class