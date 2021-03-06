﻿Public Class calc

    Dim btn(14) As Button
    Private _cSetting As calcSetting
    Private mclosing As Boolean = True    
    'Private PressDot As Boolean = False

    Public Event SetNumber(ByRef cSetting As calcSetting)

    Public Property isClosing() As Boolean
        Get
            Return mclosing
        End Get
        Set(ByVal value As Boolean)
            mclosing = value
        End Set
    End Property

    Private Sub ct_number_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Resize

        'If mclosing Then Exit Sub
        Dim fs As Single

        If Me.Width > 319 Then
            fs = 14
        ElseIf Me.Width > 268 Then
            fs = 12
        ElseIf Me.Width > 258 Then
            fs = 11
        ElseIf Me.Width > 241 Then
            fs = 10
        ElseIf Me.Width > 214 Then
            fs = 9
        ElseIf Me.Width > 199 Then
            fs = 8
        Else
            fs = 8
        End If

        Dim f As New Font("Microsoft Sans Serif", fs + 2, FontStyle.Bold)
        Dim c As New Font("Microsoft Sans Serif", fs + 4, FontStyle.Regular)

        txt_Number.Font = c

        Dim i As Integer = 0
        For y As Integer = 0 To 4
            For x As Integer = 0 To 2
                If IsNothing(btn(i)) Then
                    btn(i) = New Button
                End If
                btn(i).Width = Me.Width / 3
                btn(i).Height = (Me.Height - txt_Number.Height) / 5
                btn(i).Font = f
                btn(i).Top = (txt_Number.Top + txt_Number.Height) + (y * btn(i).Height)
                btn(i).Left = x * btn(i).Width
                i = i + 1
            Next
        Next

    End Sub

    Public Sub New(ByRef cSetting As calcSetting)

        InitializeComponent()

        _cSetting = cSetting
        If Not (String.Compare(_cSetting.FormTitle, String.Empty) = 0) Then
            Dim mnu As New ContextMenu
            Dim mi As New MenuItem
            mi.Text = _cSetting.FormTitle
            mnu.MenuItems.Add(mi)
            Me.txt_Number.ContextMenu = mnu
        End If

        For i As Integer = 0 To 14
            btn(i) = New Button
            btn(i).Width = Me.Width / 3
            btn(i).Height = (Me.Height - txt_Number.Height) / 5
            Select Case i
                Case 0, 1, 2, 3, 4, 5, 6, 7, 8
                    btn(i).Text = CStr(i + 1)
                Case 9
                    btn(i).Text = "."
                    btn(i).Enabled = _cSetting.permitDouble
                Case 10
                    btn(i).Text = "0"
                Case 11
                    btn(i).Text = "-"
                    btn(i).Enabled = _cSetting.permitNeg
                Case 12
                    btn(i).Text = "<"
                Case 13
                    btn(i).Text = "Ok"
                Case 14
                    btn(i).Text = "X"

            End Select
            AddHandler btn(i).Click, AddressOf Btn_Click
            AddHandler btn(i).KeyPress, AddressOf hKeyPress
            AddHandler btn(i).KeyDown, AddressOf hKeyDown
            Me.Controls.Add(btn(i))
        Next

        Me.txt_Number.Text = _cSetting.DNUM.ToString
        Me.btn(9).Focus()

    End Sub

    Private Sub Btn_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim btn As Button = sender
        Select Case Strings.Left(btn.Text, 1)
            Case "O"
                'PressDot = False
                Me.isClosing = True
                RaiseEvent SetNumber(_cSetting)
            Case "C"
                'PressDot = False
                _cSetting.DNUM = 0
                txt_Number.Text = 0
            Case "<"
                'PressDot = False
                If Len(txt_Number.Text) > 1 Then
                    Try
                        txt_Number.Text = txt_Number.Text.Substring(0, txt_Number.Text.Length - 1)
                        _cSetting.DNUM = CDbl(txt_Number.Text)
                    Catch
                        txt_Number.Text = "0"
                        _cSetting.DNUM = 0
                    End Try
                Else
                    txt_Number.Text = "0"
                    _cSetting.DNUM = 0
                End If
            Case "."
                If InStr(txt_Number.Text, ".") = 0 Then
                    'PressDot = True
                    txt_Number.Text = txt_Number.Text & "."
                End If
            Case "X"
                _cSetting.Result = DialogResult.Cancel
                'PressDot = False
                Me.isClosing = True
                RaiseEvent SetNumber(_cSetting)
            Case "-"
                Try
                    txt_Number.Text = CDbl(txt_Number.Text) - (CDbl(txt_Number.Text) * 2)
                    _cSetting.DNUM = CDbl(txt_Number.Text)
                Catch
                    txt_Number.Text = 0
                    _cSetting.DNUM = 0
                End Try
            Case Else
                txt_Number.Text = txt_Number.Text & btn.Text
                'If PressDot Then
                '    txt_Number.Text = txt_Number.Text & "."
                '    '_cSetting.DNUM = CDbl(_cSetting.DNUM.ToString & "." & btn.Text)
                '    PressDot = False
                'Else
                '    txt_Number.Text = txt_Number.Text & btn.Text
                '    '_cSetting.DNUM = CDbl(_cSetting.DNUM.ToString & btn.Text)
                'End If
        End Select

        If Not IsNumeric(txt_Number.Text) Then
            txt_Number.Text = "0"
            _cSetting.DNUM = 0
        Else
            _cSetting.DNUM = CDbl(txt_Number.Text)
            If _cSetting.DNUM > _cSetting.Max Then
                _cSetting.DNUM = _cSetting.Max
                txt_Number.Text = _cSetting.Max.ToString
            End If
            If _cSetting.DNUM < _cSetting.Min Then
                _cSetting.DNUM = _cSetting.Min
                txt_Number.Text = _cSetting.Min.ToString
            End If
        End If

        'txt_Number.Text = _cSetting.DNUM.ToString

        While String.Compare(txt_Number.Text.Substring(0, 1), "0") = 0 _
            And txt_Number.Text.Length > 1
            txt_Number.Text = txt_Number.Text.Substring(1)
        End While

        Me.btn(9).Focus()

    End Sub

    Private Sub txt_Number_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles txt_Number.GotFocus
        Try
            Me.btn(9).Focus()
        Catch
        End Try
    End Sub

    Private Sub hKeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles txt_Number.KeyDown
        e.Handled = True
        Select Case e.KeyValue
            Case Keys.Back
                Btn_Click(Me.btn(12), New System.EventArgs)
            Case Keys.D0
                Btn_Click(Me.btn(10), New System.EventArgs)
            Case Keys.D1
                Btn_Click(Me.btn(0), New System.EventArgs)
            Case Keys.D2
                Btn_Click(Me.btn(1), New System.EventArgs)
            Case Keys.D3
                Btn_Click(Me.btn(2), New System.EventArgs)
            Case Keys.D4
                Btn_Click(Me.btn(3), New System.EventArgs)
            Case Keys.D5
                Btn_Click(Me.btn(4), New System.EventArgs)
            Case Keys.D6
                Btn_Click(Me.btn(5), New System.EventArgs)
            Case Keys.D7
                Btn_Click(Me.btn(6), New System.EventArgs)
            Case Keys.D8
                Btn_Click(Me.btn(7), New System.EventArgs)
            Case Keys.D9
                Btn_Click(Me.btn(8), New System.EventArgs)
            Case 190
                Btn_Click(Me.btn(9), New System.EventArgs)
            Case Keys.Subtract
                Btn_Click(Me.btn(11), New System.EventArgs)
        End Select
    End Sub

    Private Sub hKeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txt_Number.KeyPress, txt_Number.KeyPress


    End Sub


End Class
