<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Output
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Output))
        Me.strOutput = New System.Windows.Forms.TextBox
        Me.SuspendLayout()
        '
        'strOutput
        '
        Me.strOutput.BackColor = System.Drawing.SystemColors.InactiveCaption
        Me.strOutput.Dock = System.Windows.Forms.DockStyle.Fill
        Me.strOutput.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.strOutput.ForeColor = System.Drawing.Color.Black
        Me.strOutput.Location = New System.Drawing.Point(0, 0)
        Me.strOutput.Multiline = True
        Me.strOutput.Name = "strOutput"
        Me.strOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.strOutput.Size = New System.Drawing.Size(284, 264)
        Me.strOutput.TabIndex = 0
        Me.strOutput.WordWrap = False
        '
        'Output
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(284, 264)
        Me.Controls.Add(Me.strOutput)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "Output"
        Me.Text = "Output"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents strOutput As System.Windows.Forms.TextBox
End Class
