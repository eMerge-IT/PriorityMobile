<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PriDatePick
    Inherits PriBaseCtrl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.dt = New System.Windows.Forms.DateTimePicker
        Me.SuspendLayout()
        '
        'dt
        '
        Me.dt.Dock = System.Windows.Forms.DockStyle.Right
        Me.dt.Location = New System.Drawing.Point(45, 0)
        Me.dt.Name = "dt"
        Me.dt.Size = New System.Drawing.Size(105, 24)
        Me.dt.TabIndex = 1
        '
        'PriDatePick
        '
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit
        Me.Controls.Add(Me.dt)
        Me.Name = "PriDatePick"
        Me.Size = New System.Drawing.Size(150, 23)
        Me.Controls.SetChildIndex(Me.dt, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents dt As System.Windows.Forms.DateTimePicker

End Class
