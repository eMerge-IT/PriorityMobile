Public Class cfResolution
    Inherits cfOnBoardData.PDAData
    Dim ws As New priwebsvc.Service

#Region "Initialisation"

    Public Sub New(Optional ByRef App As cfOnBoardData.BaseForm = Nothing)

        CallerApp = App

        With Me
            .Name = "Resolution"
            .ConQuery = "SELECT * FROM V_SVCCALL_RESOLUTION"
            .Column(0) = "CODE"
            .Column(1) = "DES"
        End With

    End Sub

#End Region

#Region "Must Override Subs"

    Public Overrides Function ConWebService(ByRef data) As Boolean

        Dim subName As String = "ConWebService" 'New StackTrace().GetFrame(0).GetMethod.ToString()
        Try
            ' Connect to the web service and get data
            data = ws.GetData(ConQuery)
            Return True
        Catch e As Exception
            Return False
        End Try

    End Function

    Public Overrides Sub ConFail(ByRef Cancel As Boolean)

        Dim subName As String = "ConFail" 'New StackTrace().GetFrame(0).GetMethod.ToString()
        Try
            ' Did not connect
            ' Cancel = True terminates the running thread
            Cancel = True
            doWarning(subName, "Could not download data." & vbCrLf & "Please check your connection and try again.")
        Catch e As Exception
            doWarning(subName, e.Message)
        End Try

    End Sub

    Public Overrides Sub SyncNewData()

        Dim subName As String = "SyncNewData" 'New StackTrace().GetFrame(0).GetMethod.ToString()
        Try
            ' New data arrives here
            thisArray = tempArray

            ' Caller must save the data if changed
            If Not Save() Then
                MsgBox("File I/O", , " Error saving " & Name & ".")
            Else
                HasNewData = True
            End If

        Catch e As Exception
            doWarning(subName, e.Message)
        End Try

    End Sub

    Public Overrides Sub LoadData(ByVal Ordinal As Integer)

        Dim subName As String = "LoadData" 'New StackTrace().GetFrame(0).GetMethod.ToString()
        Try

            ' This dataset is not loaded back to Priority

        Catch e As Exception
            doWarning(subName, e.Message)
        End Try

    End Sub

    Public Overrides Function Validate() As Boolean

        Dim subName As String = "Validate" 'New StackTrace().GetFrame(0).GetMethod.ToString()
        Try
            ' Does the selected part exist in the recordset
            Dim v As Boolean = currentOrdinal > -1
            If Not v Then doWarning(subName, currentIndex & " is not a valid part.")
            Return v
        Catch e As Exception
            doWarning(subName, e.Message)
        End Try

    End Function

#End Region

End Class
