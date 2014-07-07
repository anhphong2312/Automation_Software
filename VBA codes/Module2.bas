Attribute VB_Name = "Module2"
Dim RunTimeGroup As TagGroup
Dim ACOMP_Runtime_Tag, P2_Runtime_Tag, P3_Runtime_Tag, P4_Runtime_Tag, P5_Runtime_Tag, P6_Runtime_Tag As Tag
Dim MC1_Runtime_Tag, MC2_Runtime_Tag, LastUpdateDate_Tag, FirstUpdateDate_Tag As Tag
Dim ACOMP_cum_local_tag, P2_cum_local_tag, P3_cum_local_tag, P4_cum_local_tag, P5_cum_local_tag, P6_cum_local_tag As Tag
Dim MC1_cum_local_tag, MC2_cum_local_tag As Tag


'========================================================'
'========================================================'
'========================================================'
Sub GetCummulativeRunTime()

    'Setup database connection
   Dim cnSQL As ADODB.Connection
   Dim rsSQL As ADODB.Recordset

   Set cnSQL = New ADODB.Connection
   Set rsSQL = New ADODB.Recordset

   With cnSQL
       .Provider = "SQLOLEDB"
       .ConnectionString = "User ID=sa;Password=ACOMP1998a*;Data Source=ACOMP-IPC\FTVIEWX64TAGDB;" & _
           "Initial Catalog=acomp_alpha_system_formatted_db"
       .Open
   End With
    
   With rsSQL
       .ActiveConnection = cnSQL
       .Open "SELECT Top 1 [DateAndTime], [ACOMP_cumulative_hours], [P2_cumulative_hours],[P3_cumulative_hours]," _
       & " [P4_cumulative_hours], [P5_cumulative_hours], [P6_cumulative_hours], [MC1_cumulative_hours], [MC2_cumulative_hours]" _
       & " FROM Runtime_Data " _
       & " ORDER BY [DateAndTime] DESC"
   End With
   
   While Not rsSQL.EOF
        ACOMP_Runtime_Tag.Value = rsSQL!ACOMP_Cumulative_hours
        P2_Runtime_Tag.Value = rsSQL!P2_Cumulative_hours
        P3_Runtime_Tag.Value = rsSQL!P3_Cumulative_hours
        P4_Runtime_Tag.Value = rsSQL!P4_Cumulative_hours
        P5_Runtime_Tag.Value = rsSQL!P5_Cumulative_hours
        P6_Runtime_Tag.Value = rsSQL!P6_Cumulative_hours
        MC1_Runtime_Tag.Value = rsSQL!MC1_Cumulative_hours
        MC2_Runtime_Tag.Value = rsSQL!MC2_Cumulative_hours
        LastUpdateDate_Tag.Value = rsSQL!DateAndTime
        
        rsSQL.MoveNext
   Wend
   
   rsSQL.Close
   Set rsSQL = Nothing
   cnSQL.Close
   Set cnSQL = Nothing
   
End Sub

'========================================================'
'========================================================'
'========================================================'
Sub GetCummulativeRunTimeOriginal()

    'Setup database connection
   Dim cnSQL As ADODB.Connection
   Dim rsSQL As ADODB.Recordset

   Set cnSQL = New ADODB.Connection
   Set rsSQL = New ADODB.Recordset

   With cnSQL
       .Provider = "SQLOLEDB"
       .ConnectionString = "User ID=sa;Password=ACOMP1998a*;Data Source=ACOMP-IPC\FTVIEWX64TAGDB;" & _
           "Initial Catalog=acomp_alpha_system_formatted_db"
       .Open
   End With
    
   With rsSQL
       .ActiveConnection = cnSQL
       .Open "SELECT Top 1 [DateAndTime], [ACOMP_cumulative_hours], [P2_cumulative_hours],[P3_cumulative_hours]," _
       & " [P4_cumulative_hours], [P5_cumulative_hours], [P6_cumulative_hours], [MC1_cumulative_hours], [MC2_cumulative_hours]" _
       & " FROM Runtime_Data "
   End With
   
   While Not rsSQL.EOF
        FirstUpdateDate_Tag.Value = rsSQL!DateAndTime
        rsSQL.MoveNext
   Wend
   
   rsSQL.Close
   Set rsSQL = Nothing
   cnSQL.Close
   Set cnSQL = Nothing
   
End Sub

'========================================================'
'========================================================'
'========================================================'
Sub WriteCummulativeRunTime()

    'Database setup
    Dim cnSQL As ADODB.Connection
    Dim rsSQL As ADODB.Recordset
    
    Set cnSQL = New ADODB.Connection
    Set rsSQL = New ADODB.Recordset
    
    With cnSQL
        .Provider = "SQLOLEDB"
        .ConnectionString = "User ID=sa;Password=ACOMP1998a*;Data Source=ACOMP-IPC\FTVIEWX64TAGDB;" & _
            "Initial Catalog=acomp_alpha_system_formatted_db"
        .Open
    End With
    
    'Datalog values
    Dim CurrentDateStr As String
    Dim strSQL As String
    
    'Update cumulative values
    ACOMP_Runtime_Tag.Value = (ACOMP_Runtime_Tag.Value + ACOMP_cum_local_tag.Value)
    P2_Runtime_Tag.Value = (P2_Runtime_Tag.Value + P2_cum_local_tag.Value * 0.0167)
    P3_Runtime_Tag.Value = (P3_Runtime_Tag.Value + P3_cum_local_tag.Value * 0.0167)
    P4_Runtime_Tag.Value = (P4_Runtime_Tag.Value + P4_cum_local_tag.Value * 0.0167)
    P5_Runtime_Tag.Value = (P5_Runtime_Tag.Value + P5_cum_local_tag.Value * 0.0167)
    P6_Runtime_Tag.Value = (P6_Runtime_Tag.Value + P6_cum_local_tag.Value * 0.0167)
    MC1_Runtime_Tag.Value = (MC1_Runtime_Tag.Value + MC1_cum_local_tag.Value * 0.0167)
    MC2_Runtime_Tag.Value = (MC2_Runtime_Tag.Value + MC2_cum_local_tag.Value * 0.0167)
       
    '===============================
    'Write to database
    CurrentDateStr = Format(DateTime.Now(), "yyyy-MM-dd hh:mm:ss")
    'DateAndTime data type is String wrapped in single quote
    strSQL = "INSERT INTO [Runtime_Data]" _
    & "([DateAndTime],[ACOMP_Cumulative_hours], [P2_Cumulative_hours],[P3_Cumulative_hours],[P4_Cumulative_hours]," _
    & "[P5_Cumulative_hours], [P6_Cumulative_hours], [MC1_Cumulative_hours], [MC2_Cumulative_hours])" _
    & " VALUES('" & CurrentDateStr & "','" _
    & ACOMP_Runtime_Tag.Value & "','" & P2_Runtime_Tag.Value & "','" & P3_Runtime_Tag.Value & "','" & P4_Runtime_Tag.Value & "','" _
    & P5_Runtime_Tag.Value & "','" & P6_Runtime_Tag.Value & "','" & MC1_Runtime_Tag.Value & "','" & MC2_Runtime_Tag.Value _
    & "')"
    

    cnSQL.Execute (strSQL)
    
    'datalogging post process

    cnSQL.Close
    Set cnSQL = Nothing

End Sub
'========================================================'
'========================================================'
'========================================================'
Sub SetUpTagGroup_Runtime()

    On Error Resume Next
    Err.Clear
    If RunTimeGroup Is Nothing Then
        Set RunTimeGroup = Application.CreateTagGroup(ThisDisplay)
        If Err.Number Then
            LogDiagnosticsMessage "Error creating TagGroup. Error: & Err.Description, ftDiagSeverityError"
            Exit Sub
        End If
   
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.ACOMP_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P2_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P3_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P4_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P5_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P6_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.MC1_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.MC2_cum_time_overall}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.Last_Cum_Overall_Date_DB}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.First_Cum_Overall_Date_DB}"
        
        
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.ACOMP_time_elapsed_hr}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P2_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P3_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P4_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P5_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.P6_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.MC1_cum_min_local}"
        RunTimeGroup.Add "{::[software_v1]Program:Device_Runtime.MC2_cum_min_local}"
        
        
                
        RunTimeGroup.Active = True
    
    End If
    
    If Not RunTimeGroup Is Nothing Then
        Set ACOMP_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.ACOMP_cum_time_overall}")
        Set P2_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P2_cum_time_overall}")
        Set P3_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P3_cum_time_overall}")
        Set P4_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P4_cum_time_overall}")
        Set P5_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P5_cum_time_overall}")
        Set P6_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P6_cum_time_overall}")
        Set MC1_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.MC1_cum_time_overall}")
        Set MC2_Runtime_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.MC2_cum_time_overall}")
        Set LastUpdateDate_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.Last_Cum_Overall_Date_DB}")
        Set FirstUpdateDate_Tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.First_Cum_Overall_Date_DB}")
        
        Set ACOMP_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.ACOMP_time_elapsed_hr}")
        Set P2_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P2_cum_min_local}")
        Set P3_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P3_cum_min_local}")
        Set P4_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P4_cum_min_local}")
        Set P5_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P5_cum_min_local}")
        Set P6_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.P6_cum_min_local}")
        Set MC1_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.MC1_cum_min_local}")
        Set MC2_cum_local_tag = RunTimeGroup.Item("{::[software_v1]Program:Device_Runtime.MC2_cum_min_local}")
        
        

        
        Select Case Err.Number
            Case 0:
               ' MsgBox "System\Second = " & vValue
            Case tagErrorReadValue:
                MsgBox "Error to reading tag value. Error: oTag.LastErrorString"
            Case tagErrorOperationFailed:
                MsgBox "Failed to read from tag. Error: " & Err.Description
        End Select
    End If


End Sub
