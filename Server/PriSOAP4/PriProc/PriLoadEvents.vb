﻿Imports System
Imports System.Management

Friend Enum tWMIProcess
    WINRUN = 1
    WINACTIV = 2
End Enum

Friend Enum tWMIEventState
    StateStart = 1
    StateStop = 2
End Enum

Friend Class HandledWMIEvent

    Public Sub New(ByVal Name As tWMIProcess, ByVal EventState As tWMIEventState, ByVal ParentProcessID As Integer, ByVal ProcessID As Integer)
        _Name = Name
        _EventState = EventState
        _ParentProcessID = ParentProcessID
        _ProcessID = ProcessID
    End Sub
    Private _Name As tWMIProcess
    Public Property Name() As tWMIProcess
        Get
            Return _Name
        End Get
        Set(ByVal value As tWMIProcess)
            _Name = value
        End Set
    End Property
    Private _EventState As tWMIEventState
    Public Property EventState() As tWMIEventState
        Get
            Return _EventState
        End Get
        Set(ByVal value As tWMIEventState)
            _EventState = value
        End Set
    End Property
    Private _ParentProcessID As Integer
    Public Property ParentProcess() As Integer
        Get
            Return _ParentProcessID
        End Get
        Set(ByVal value As Integer)
            _ParentProcessID = value
        End Set
    End Property
    Private _ProcessID
    Public Property Process() As Integer
        Get
            Return _ProcessID
        End Get
        Set(ByVal value As Integer)
            _ProcessID = value
        End Set
    End Property

End Class

Public Class PriLoadEvents

#Region "Private Variables"

    'Private CmdProc As Integer = -1
    Private RunProc As Integer = -1
    Private ActProc As Integer = -1

    Private _BubbleQFolder As System.IO.DirectoryInfo
    Private _HasEnded As Boolean
    Private _HasElapsed As Boolean
    Private _HasFailed As Boolean

    Private WithEvents StartTimer As Timers.Timer
    Private WithEvents CheckEventTimer As Timers.Timer
    Private WithEvents tmr As Timers.Timer

    Private HldEvents As List(Of HandledWMIEvent)
    Private LogBuilder As Builder

#End Region

#Region "Public Properties"

    Public ReadOnly Property HasEnded() As Boolean
        Get
            Return _HasEnded
        End Get
    End Property

    Public ReadOnly Property HasElapsed() As Boolean
        Get
            Return _HasElapsed
        End Get
    End Property

    Public ReadOnly Property HasFailed() As Boolean
        Get
            Return _HasFailed
        End Get
    End Property

    Public ReadOnly Property qStarted() As Boolean
        Get
            Try
                Return BubbleQ.EnableRaisingEvents
            Catch
                Return False
            End Try
        End Get
    End Property

#End Region

#Region "Event Watchers declarations"

    Private WINACTIVStartWatcher As ManagementEventWatcher
    Private WINACTIVStopWatcher As ManagementEventWatcher
    Private WINRUNStartWatcher As ManagementEventWatcher
    Private WINRUNStopWatcher As ManagementEventWatcher

    Private WithEvents BubbleQ As System.IO.FileSystemWatcher

#End Region

#Region "Initialisation and finalisation"

    Public Sub New(ByVal BubbleQFolder As System.IO.DirectoryInfo)

        _BubbleQFolder = BubbleQFolder

        WINRUNStartWatcher = New ManagementEventWatcher(GenerateStartQuery("WINRUN.EXE"))
        AddHandler WINRUNStartWatcher.EventArrived, AddressOf WINRUNStarted
        WINRUNStartWatcher.Start()

        WINRUNStopWatcher = New ManagementEventWatcher(GenerateStopQuery("WINRUN.EXE"))
        AddHandler WINRUNStartWatcher.EventArrived, AddressOf WINRUNStopped
        WINRUNStopWatcher.Start()

        WINACTIVStartWatcher = New ManagementEventWatcher(GenerateStartQuery("WINACTIV.EXE"))
        AddHandler WINACTIVStartWatcher.EventArrived, AddressOf WINACTIVStarted
        WINACTIVStartWatcher.Start()

        WINACTIVStopWatcher = New ManagementEventWatcher(GenerateStopQuery("WINACTIV.EXE"))
        AddHandler WINACTIVStopWatcher.EventArrived, AddressOf WINACTIVStopped
        WINACTIVStopWatcher.Start()

        StartTimer = New Timers.Timer
        With StartTimer
            .Interval = 10000
            AddHandler .Elapsed, AddressOf StartBubbleQ
            .Start()
        End With

    End Sub

    Private Sub StartBubbleQ(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)

        Dim logbuilder As New Builder
        Dim evt As ntEvtlog.LogEntryType = ntEvtlog.LogEntryType.SuccessAudit
        Dim verb As ntEvtlog.EvtLogVerbosity = ntEvtlog.EvtLogVerbosity.VeryVerbose

        Try
            logbuilder.AppendFormat("Initialising the bubble queue at: [{0}].", _BubbleQFolder.FullName).AppendLine()

            If Not IsNothing(StartTimer) Then
                With StartTimer
                    .Stop()
                    .Dispose()
                End With
            End If

            If _BubbleQFolder.GetFiles.Count > 0 Then
                logbuilder.AppendFormat("Found {0} bubbles waiting in the queue.", _BubbleQFolder.GetFiles.Count).AppendLine()
            End If

            While _BubbleQFolder.GetFiles.Count > 0
                Try
                    logbuilder.AppendFormat("Processing bubble file [{0}]...", _BubbleQFolder.GetFiles.ElementAt(0).FullName)
                    RaiseEvent NewBubble(_BubbleQFolder.GetFiles.ElementAt(0).FullName)
                    logbuilder.AppendFormat("OK.", "").AppendLine()
                Catch ex As Exception
                    verb = ntEvtlog.EvtLogVerbosity.Normal
                    evt = ntEvtlog.LogEntryType.FailureAudit
                    logbuilder.AppendFormat("Failed.", "").AppendLine()
                    logbuilder.AppendFormat("Please see seperate event log for bubble [{0}].", _BubbleQFolder.GetFiles.ElementAt(0).FullName.Split("\").Last.Split(".").First).AppendLine()
                    logbuilder.AppendFormat("{0}", ex.Message).AppendLine()
                End Try
            End While

        Catch ex As Exception
            evt = ntEvtlog.LogEntryType.Err
            verb = ntEvtlog.EvtLogVerbosity.Normal
            logbuilder.AppendFormat("Error during queue initialisation: {0}", ex.Message).AppendLine()

        Finally
            Try
                logbuilder.AppendFormat("Starting the bubble queue at: [{0}]...", _BubbleQFolder.FullName)
                BubbleQ = New System.IO.FileSystemWatcher(_BubbleQFolder.FullName)
                BubbleQ.EnableRaisingEvents = True
                logbuilder.AppendFormat("OK.", _BubbleQFolder.FullName).AppendLine()
            Catch ex As Exception
                evt = ntEvtlog.LogEntryType.Err
                verb = ntEvtlog.EvtLogVerbosity.Normal
                logbuilder.AppendFormat("FAILED.", _BubbleQFolder.FullName).AppendLine()
                logbuilder.AppendFormat("{0}", ex.Message).AppendLine()
            End Try

            ev.Log(logbuilder.ToString, evt, ntEvtlog.EvtLogVerbosity.Normal)

        End Try

    End Sub

    Protected Overrides Sub Finalize()

        WINRUNStartWatcher.Stop()
        RemoveHandler WINRUNStartWatcher.EventArrived, AddressOf WINRUNStarted
        WINRUNStartWatcher.Dispose()

        WINRUNStopWatcher.Stop()
        RemoveHandler WINRUNStopWatcher.EventArrived, AddressOf WINRUNStopped
        WINRUNStopWatcher.Dispose()

        WINACTIVStartWatcher.Stop()
        RemoveHandler WINACTIVStartWatcher.EventArrived, AddressOf WINACTIVStarted
        WINACTIVStartWatcher.Dispose()

        WINACTIVStopWatcher.Stop()
        RemoveHandler WINACTIVStopWatcher.EventArrived, AddressOf WINACTIVStopped
        WINACTIVStopWatcher.Dispose()

        If Not IsNothing(BubbleQ) Then
            BubbleQ.EnableRaisingEvents = False
            BubbleQ.Dispose()
        End If

        MyBase.Finalize()
    End Sub

#End Region

#Region "Public Events"

    Public Event NewBubble(ByVal BubbleFile As String)

#End Region

#Region "WMI Event Handlers"

    Private Sub WINACTIVStarted(ByVal sender As Object, ByVal e As EventArrivedEventArgs)
        HldEvents.Add(New HandledWMIEvent(tWMIProcess.WINACTIV, tWMIEventState.StateStart, e.NewEvent.Properties("ParentProcessID").Value, e.NewEvent.Properties("ProcessID").Value))
    End Sub

    Private Sub WINACTIVStopped(ByVal sender As Object, ByVal e As EventArrivedEventArgs)
        HldEvents.Add(New HandledWMIEvent(tWMIProcess.WINACTIV, tWMIEventState.StateStop, e.NewEvent.Properties("ParentProcessID").Value, e.NewEvent.Properties("ProcessID").Value))
    End Sub

    Private Sub WINRUNStarted(ByVal sender As Object, ByVal e As EventArrivedEventArgs)
        HldEvents.Add(New HandledWMIEvent(tWMIProcess.WINRUN, tWMIEventState.StateStart, e.NewEvent.Properties("ParentProcessID").Value, e.NewEvent.Properties("ProcessID").Value))
    End Sub

    Private Sub WINRUNStopped(ByVal sender As Object, ByVal e As EventArrivedEventArgs)
        HldEvents.Add(New HandledWMIEvent(tWMIProcess.WINRUN, tWMIEventState.StateStop, e.NewEvent.Properties("ParentProcessID").Value, e.NewEvent.Properties("ProcessID").Value))
    End Sub

    Private Sub CheckEvents(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)
        If (RunProc = -1) Then
            For Each hld As HandledWMIEvent In HldEvents
                If hld.Name = tWMIProcess.WINRUN _
                    And hld.EventState = tWMIEventState.StateStart _
                    And hld.ParentProcess = System.Diagnostics.Process.GetCurrentProcess().Id Then
                    RunProc = hld.Process
                    LogBuilder.AppendFormat("Started [{0}] process with ID [{1}]", "WINRUN", RunProc.ToString).AppendLine()
                    Exit For
                End If
            Next
        End If
        If (RunProc = -1) Then Exit Sub
        If (ActProc = -1) Then
            For Each hld As HandledWMIEvent In HldEvents
                If hld.Name = tWMIProcess.WINACTIV _
                    And hld.EventState = tWMIEventState.StateStart _
                    And hld.ParentProcess = RunProc Then
                    ActProc = hld.Process
                    LogBuilder.AppendFormat("Started [{0}] process with ID [{1}]", "WINACTIV", ActProc.ToString).AppendLine()
                    Exit For
                End If
            Next
        End If
        If (ActProc = -1) Then Exit Sub
        For Each hld As HandledWMIEvent In HldEvents
            If hld.Name = tWMIProcess.WINACTIV _
                And hld.EventState = tWMIEventState.StateStop _
                And hld.Process = ActProc Then

                DisposeTimers()
                LogBuilder.AppendFormat("Finished [{0}] process with ID [{1}]", "WINACTIV", ActProc.ToString).AppendLine()

                _HasElapsed = False
                _HasFailed = False
                _HasEnded = True

                Exit For
            End If
        Next
    End Sub

    Private Sub TimeOutElapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)

        DisposeTimers()
        LogBuilder.Append("Loading timeout elapsed. Begin Process Clean-up.").AppendLine()

        LogBuilder.Append("I saw the following threads...").AppendLine()
        For Each hld As HandledWMIEvent In HldEvents
            Select Case hld.EventState
                Case tWMIEventState.StateStart
                    LogBuilder.AppendFormat("Process [{0}] with PID [{1}] started by PID [{2}]", hld.Name, hld.Process, hld.ParentProcess).AppendLine()
                Case tWMIEventState.StateStop
                    LogBuilder.AppendFormat("Process [{0}] with PID [{1}] terminating", hld.Name, hld.Process).AppendLine()
            End Select

        Next

        If Not IsNothing(ActProc) Then
            Try
                LogBuilder.AppendFormat("Killing Process [{0}] with process ID [{1}]", "WINACTIV", ActProc.ToString).AppendLine()
                Dim P As System.Diagnostics.Process = System.Diagnostics.Process.GetProcessById(ActProc)
                P.Kill()
            Catch
                LogBuilder.Append("Kill process by ID failed. Killing all WINACTIV processes.").AppendLine()
                For Each P As System.Diagnostics.Process In System.Diagnostics.Process.GetProcessesByName("WINACTIV")
                    With P
                        LogBuilder.AppendFormat("Killing [{0}] process with ID [{1}]", "WINACTIV", P.Id.ToString).AppendLine()
                        P.Kill()
                    End With
                Next
            End Try
        Else
            LogBuilder.Append("A WINACTIV process ID was not found. Killing all WINACTIV processes.").AppendLine()
            For Each P As System.Diagnostics.Process In System.Diagnostics.Process.GetProcessesByName("WINACTIV")
                With P
                    LogBuilder.AppendFormat("Killing [{0}] process with ID [{1}]", "WINACTIV", P.Id.ToString).AppendLine()
                    P.Kill()
                End With
            Next
        End If

        _HasFailed = False
        _HasElapsed = True
        _HasEnded = True

    End Sub

    Private Sub DisposeTimers()
        With tmr
            .Stop()
            .Dispose()
        End With

        With CheckEventTimer
            .Stop()
            .Dispose()
        End With
    End Sub

#End Region

#Region "Folder Watcher Event Handlers"

    Private Sub BubbleQ_Created(ByVal sender As Object, ByVal e As System.IO.FileSystemEventArgs) Handles BubbleQ.Created
        RaiseEvent NewBubble(e.FullPath)
    End Sub

#End Region

#Region "Start / stop WMI Queries"

    Private Function GenerateStartQuery(ByVal ProcessName As String) As WqlEventQuery
        Dim ApplicationStartQuery As New WqlEventQuery
        ApplicationStartQuery.EventClassName = "Win32_ProcessStartTrace"
        ApplicationStartQuery.QueryString = String.Concat("SELECT * FROM Win32_ProcessStartTrace where ProcessName = ", """", ProcessName, """")
        Return ApplicationStartQuery
    End Function

    Private Function GenerateStopQuery(ByVal ProcessName As String) As WqlEventQuery
        Dim ApplicationStopQuery As New WqlEventQuery
        ApplicationStopQuery.EventClassName = "Win32_ProcessStopTrace"
        ApplicationStopQuery.QueryString = String.Concat("SELECT * FROM Win32_ProcessStopTrace where ProcessName = ", """", ProcessName, """")
        Return ApplicationStopQuery
    End Function

#End Region

#Region "Public Methods"

    Public Sub WatchProcess(ByRef Log As Builder, Optional ByVal TimeOut As Integer = 60)

        'CmdProc = ProcessID
        RunProc = -1
        ActProc = -1

        _HasEnded = False
        _HasElapsed = False
        _HasFailed = False

        LogBuilder = Log
        HldEvents = New List(Of HandledWMIEvent)

        tmr = New Timers.Timer()
        With tmr
            .Interval = TimeOut * 1000
            AddHandler .Elapsed, AddressOf TimeOutElapsed
            .Start()
        End With

        CheckEventTimer = New Timers.Timer()
        With CheckEventTimer
            .Interval = 100
            AddHandler .Elapsed, AddressOf CheckEvents
            .Start()
        End With

    End Sub

    Public Sub RestartQ()
        StartTimer = New Timers.Timer
        With StartTimer
            .Interval = 1
            AddHandler .Elapsed, AddressOf StartBubbleQ
            .Start()
        End With
    End Sub

#End Region

End Class
