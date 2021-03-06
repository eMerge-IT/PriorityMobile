﻿Imports System.Xml

Public Class xmlForms

#Region "Public Events"

    Public Event AddUserControl(ByVal ControlName As String, ByRef view As iView, ByRef thisForm As xForm)
    Public Event DrawForm()
    Public Event DrawSubMenu()
    Public Event DrawDirectActivations()
    Public Event StartCalc(ByVal Max As Integer)

#End Region

#Region "Public Shared Members"

    Public Shared FormDesign As OfflineXML
    Public Shared FormData As OfflineXML
    Public Shared DataLookUp As lookupData
    Public Shared TopForm As Dictionary(Of String, TopLevelForm)
    Public Shared changedAttribute As XmlAttribute

#End Region

#Region "initialisation and Finalisation"

    Public Sub New(ByRef _FormDesign As OfflineXML, ByRef _FormData As OfflineXML, ByRef _lookup As OfflineXML)

        FormDesign = _FormDesign
        FormData = _FormData
        DataLookUp = New lookupData(_lookup)
        TopForm = New Dictionary(Of String, TopLevelForm)

        For Each f As XmlNode In FormDesign.Document.SelectNodes("forms/form")
            TopForm.Add(f.Attributes("name").Value, New TopLevelForm(New xForm(f, f.Attributes("xpath").Value, Nothing)))
        Next

        changedAttribute = FormData.Document.CreateAttribute("changed")
        changedAttribute.Value = "1"

    End Sub

    Private Sub hAddUserControl(ByVal ControlName As String, ByRef view As ViewControl.iView, ByRef thisForm As xForm)
        RaiseEvent AddUserControl(ControlName, view, thisForm)
    End Sub

#Region "Interface Event Handlers"

    Private Sub hDrawForm()
        RaiseEvent DrawForm()
    End Sub

    Private Sub hDrawSubMenu()
        RaiseEvent DrawSubMenu()
    End Sub

    Private Sub hDrawDirectActivations()
        RaiseEvent DrawDirectActivations()
    End Sub

    Private Sub hOpenCalc(ByVal Max As Integer)
        RaiseEvent StartCalc(Max)
    End Sub

#End Region

#Region "Load view controls"

    Public Sub LoadViewControls()
        For Each f As TopLevelForm In TopForm.Values
            SetEventHandlers(f.TopForm)
            f.TopForm.LoadViewControls()
            For Each x As xForm In f.TopForm.SubForms.Values
                SetEventHandlers(x)
                x.LoadViewControls()
                RecurseView(x)
            Next
            f.TopForm.Bind()
        Next
    End Sub

    Private Sub RecurseView(ByVal x As xForm)
        For Each rx As xForm In x.SubForms.Values
            SetEventHandlers(rx)
            rx.LoadViewControls()
            RecurseView(rx)
        Next
    End Sub

    Private Sub SetEventHandlers(ByVal this As xForm)
        With this
            RemoveHandler .AddUserControl, AddressOf hAddUserControl
            RemoveHandler .DrawSubMenu, AddressOf hDrawSubMenu
            RemoveHandler .DrawDirectActivations, AddressOf hDrawDirectActivations
            RemoveHandler .DrawForm, AddressOf hDrawForm
            RemoveHandler .StartCalc, AddressOf hOpenCalc

            AddHandler .AddUserControl, AddressOf hAddUserControl
            AddHandler .DrawSubMenu, AddressOf hDrawSubMenu
            AddHandler .DrawDirectActivations, AddressOf hDrawDirectActivations
            AddHandler .DrawForm, AddressOf hDrawForm
            AddHandler .StartCalc, AddressOf hOpenCalc
        End With
    End Sub

#End Region

#End Region

#Region "Public Properties"

    Private _Activeform As Integer = 0
    Public Property ActiveForm() As Integer
        Get
            Return _Activeform
        End Get
        Set(ByVal value As Integer)
            If value > TopForm.Count - 1 Then
                _Activeform = 0
            Else
                _Activeform = value
            End If
        End Set
    End Property

#End Region

End Class