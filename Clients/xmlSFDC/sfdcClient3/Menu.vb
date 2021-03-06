﻿Imports System.Xml
Imports PrioritySFDC

Public Class Menu : Inherits BaseForm

    Public Declare Sub keybd_event Lib "coredll.dll" (ByVal bVK As Byte, _
    ByVal bScan As Byte, ByVal dwFlags As Integer, ByVal dwExtraInfo _
    As Integer)

    Private thisPrinter As btZebra.LabelPrinter
    Private TransactionWindow As New Dictionary(Of String, iForm)

    Private ReadOnly Property Forms() As XmlDocument
        Get
            Return ue("forms").Document
        End Get
    End Property

    Private Sub hCloseInt(ByVal sender As Object, ByVal e As System.EventArgs)
        TransactionWindow.Remove(TryCast(sender, iForm).thisInterface.GUID)
    End Sub

    Private Sub Menu_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        If TransactionWindow.Count > 0 Then
            MsgBox("Not all transaction forms are closed.")
            e.Cancel = True
        Else
            If Not (MsgBox("Close the application?", MsgBoxStyle.OkCancel, "Close") = MsgBoxResult.Ok) Then
                e.Cancel = True
            End If
        End If
    End Sub

    Private Sub Menu_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles MyBase.KeyDown
        Select Case e.KeyCode
            Case Keys.Enter
                e.Handled = True
                SendKey(VK_MENU)
        End Select
    End Sub

    Private Sub SendKey(ByVal Key As Byte)
        keybd_event(key, 0, KEYEVENTF_KEYDOWN, 0)
        keybd_event(key, 0, KEYEVENTF_KEYUP, 0)
    End Sub

    Private Sub hLoad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        With Me

            .StatusBar.Text = String.Format("{0}@{1}", ue.User, ue.Server.Host.ToString)
            .Logo.Image = ue.LogoFile
            .Logo.Height = ue.LogoFile.Height * (ue.LogoFile.Width / Screen.PrimaryScreen.WorkingArea.Width)
            .Menu = New ctrlMenu( _
                ue, _
                Forms.SelectSingleNode("sfdc"), _
                AddressOf hMenuClick, _
                AddressOf hUpdate, _
                AddressOf hClose _
            )

            AddHandler TryCast(Menu, ctrlMenu).ListWindows, AddressOf hListWindows

            thisPrinter = New btZebra.LabelPrinter( _
                New Point(300, 300), _
                New Size(576, 0), _
                ue.AppPath & "\prnimg\" _
            )
        End With

    End Sub

    Private Sub hListWindows(ByRef WindowList As MenuItem)
        With WindowList.MenuItems
            .Clear()
            For Each k As String In TransactionWindow.Keys
                Dim mi As New MenuItem
                mi.Text = TransactionWindow(k).Text
                AddHandler mi.Click, AddressOf TransactionWindow(k).FormActivate
                .Add(mi)
            Next
        End With
    End Sub

    Private Sub hClose()
        Me.Close()
    End Sub

    Private Sub hMenuClick(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim si As MenuItem = sender
        Dim mi As MenuItem = si.Parent

        Try
            Dim int As New iForm( _
                New cInterface( _
                    Forms.SelectSingleNode( _
                        String.Format( _
                            "sfdc/menu[@name='{0}']/interface[@name='{1}']", _
                            mi.Text, _
                            si.Text _
                        ) _
                    ), _
                    ue _
                ), _
                AddressOf hCloseInt _
            )
            With int
                .Text = si.Text
                .Printer = thisPrinter
                .Show()
            End With
            TransactionWindow.Add(int.thisInterface.GUID, int)

        Catch EX As Exception
            Cursor.Current = Cursors.Default
            MsgBox(EX.Message)
        End Try

    End Sub

    Private Sub hUpdate()
        If TransactionWindow.Count > 0 Then
            MsgBox("Please close open forms before updating.")
        Else
            Try
                ue("forms").Sync()
                With Me
                    .Menu = Nothing
                    .Menu = New ctrlMenu( _
                        ue, _
                        Forms.SelectSingleNode("sfdc"), _
                        AddressOf hMenuClick, _
                        AddressOf hUpdate, _
                        AddressOf hClose _
                    )
                    AddHandler TryCast(Menu, ctrlMenu).ListWindows, AddressOf hListWindows
                End With
                MsgBox("Form definition update Complete. Please restart the application to update any custom handlers.", , "Form Defintions.")
            Catch EX As Exception
                MsgBox(String.Format("Update Failed. {0}", EX.Message))
            End Try
        End If
    End Sub

End Class
