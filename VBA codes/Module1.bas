Attribute VB_Name = "Module1"
'========================================================'
'========================================================'
'========================================================'
'Tag group
Dim oGroup As TagGroup
Dim oTagCT_D1, oTagCT_D2, oTagCT_MC1, oTagCT_MC2, oTagCT_P2, oTagCT_P3, oTagCT_P4, oTagCT_P5, oTagCT_P6 As Tag
Dim oTagLeak_D_Grundfos, oTagLeak_D_MC1, oTagLeak_D_Side_Box, oTagLeak_D_P5, oTagLeak_D_Viscometer As Tag
Dim oTagHMI_P3_P, oTagHMI_P6_P, oTagPT_301, oTagPT_302, oTagPT_303, oTagPT_304, oTagPT_Viscometer, oTagTemp_Loop_PT1, oTagTemp_Loop_PT2 As Tag
Dim oTagTT_Ambient, oTagTT_MC1, oTagTT_MC2, oTagTT_Side_Cabinet, oTagTT_Spare, oTagTT_Viscometer As Tag
Dim oTagUV_VIS_abs_0, oTagUV_VIS_abs_1, oTagUV_VIS_abs_2, oTagUV_VIS_abs_3 As Tag

Sub SetUpTagGroup()

    On Error Resume Next
    Err.Clear
    If oGroup Is Nothing Then
        Set oGroup = Application.CreateTagGroup(ThisDisplay)
        If Err.Number Then
            LogDiagnosticsMessage "Error creating TagGroup. Error: & Err.Description, ftDiagSeverityError"
            Exit Sub
        End If
   
        oGroup.Add "{[software_v1]CT_D1}"
        oGroup.Add "{[software_v1]CT_D2}"
        oGroup.Add "{[software_v1]MC_1.Output_Current}"
        oGroup.Add "{[software_v1]CT_MC2}"
        oGroup.Add "{[software_v1]CT_P2}"
        oGroup.Add "{[software_v1]CT_P3}"
        oGroup.Add "{[software_v1]CT_P4}"
        oGroup.Add "{[software_v1]CT_P5}"
        oGroup.Add "{[software_v1]CT_P6}"
                
        oGroup.Add "{[software_v1]LEAK_D_Grundfos}"
        oGroup.Add "{[software_v1]LEAK_D_MC1}"
        oGroup.Add "{[software_v1]LEAK_D_P5}"
        oGroup.Add "{[software_v1]LEAK_D_Side_box}"
        oGroup.Add "{[software_v1]LEAK_D_Viscometer}"
        
        oGroup.Add "{[software_v1]HMI_P3_P}"
        oGroup.Add "{[software_v1]HMI_P6_P}"
        oGroup.Add "{[software_v1]PT_301}"
        oGroup.Add "{[software_v1]PT_302}"
        oGroup.Add "{[software_v1]PT_303}"
        oGroup.Add "{[software_v1]PT_304}"
        oGroup.Add "{[software_v1]PT_Viscometer}"
        oGroup.Add "{[software_v1]Temp_Loop_PT1}"
        oGroup.Add "{[software_v1]Temp_Loop_PT2}"
        
        oGroup.Add "{[software_v1]TT_Ambient}"
        oGroup.Add "{[software_v1]TT_MC1}"
        oGroup.Add "{[software_v1]TT_MC2}"
        oGroup.Add "{[software_v1]TT_Side_Cabinet}"
        oGroup.Add "{[software_v1]TT_Spare}"
        oGroup.Add "{[software_v1]Viscometer.current_TT}"
        
        oGroup.Add "{[software_v1]UV_VIS.absorbance[0]}"
        oGroup.Add "{[software_v1]UV_VIS.absorbance[1]}"
        oGroup.Add "{[software_v1]UV_VIS.absorbance[2]}"
        oGroup.Add "{[software_v1]UV_VIS.absorbance[3]}"
        
        
        oGroup.Active = True
    
    End If

End Sub

Sub TagValue()
    
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
    'Dim count As Integer
    
    


    If Not oGroup Is Nothing Then
        Set oTagCT_D1 = oGroup.Item("{[software_v1]CT_D1}")
        Set oTagCT_D2 = oGroup.Item("{[software_v1]CT_D2}")
        Set oTagCT_MC1 = oGroup.Item("{[software_v1]MC_1.Output_Current}")
        Set oTagCT_MC2 = oGroup.Item("{[software_v1]CT_MC2}")
        Set oTagCT_P2 = oGroup.Item("{[software_v1]CT_P2}")
        Set oTagCT_P3 = oGroup.Item("{[software_v1]CT_P3}")
        Set oTagCT_P4 = oGroup.Item("{[software_v1]CT_P4}")
        Set oTagCT_P5 = oGroup.Item("{[software_v1]CT_P5}")
        Set oTagCT_P6 = oGroup.Item("{[software_v1]CT_P6}")
       
       
        Set oTagLeak_D_Grundfos = oGroup.Item("{[software_v1]LEAK_D_Grundfos}")
        Set oTagLeak_D_MC1 = oGroup.Item("{[software_v1]LEAK_D_MC1}")
        Set oTagLeak_D_Side_Box = oGroup.Item("{[software_v1]LEAK_D_Side_box}")
        Set oTagLeak_D_P5 = oGroup.Item("{[software_v1]LEAK_D_P5}")
        Set oTagLeak_D_Viscometer = oGroup.Item("{[software_v1]LEAK_D_Viscometer}")
        
        Set oTagHMI_P3_P = oGroup.Item("{[software_v1]HMI_P3_P}")
        Set oTagHMI_P6_P = oGroup.Item("{[software_v1]HMI_P6_P}")
        Set oTagPT_301 = oGroup.Item("{[software_v1]PT_301}")
        Set oTagPT_302 = oGroup.Item("{[software_v1]PT_302}")
        Set oTagPT_303 = oGroup.Item("{[software_v1]PT_303}")
        Set oTagPT_304 = oGroup.Item("{[software_v1]PT_304}")
        Set oTagPT_Viscometer = oGroup.Item("{[software_v1]PT_Viscometer}")
        Set oTagTemp_Loop_PT1 = oGroup.Item("{[software_v1]Temp_Loop_PT1}")
        Set oTagTemp_Loop_PT2 = oGroup.Item("{[software_v1]Temp_Loop_PT2}")

        Set oTagTT_Ambient = oGroup.Item("{[software_v1]TT_Ambient}")
        Set oTagTT_MC1 = oGroup.Item("{[software_v1]TT_MC1}")
        Set oTagTT_MC2 = oGroup.Item("{[software_v1]TT_MC2}")
        Set oTagTT_Side_Cabinet = oGroup.Item("{[software_v1]TT_Side_Cabinet}")
        Set oTagTT_Spare = oGroup.Item("{[software_v1]TT_Spare}")
        Set oTagTT_Viscometer = oGroup.Item("{[software_v1]Viscometer.current_TT}")
        
        
        Set oTagUV_VIS_abs_0 = oGroup.Item("{[software_v1]UV_VIS.absorbance[0]}")
        Set oTagUV_VIS_abs_1 = oGroup.Item("{[software_v1]UV_VIS.absorbance[1]}")
        Set oTagUV_VIS_abs_2 = oGroup.Item("{[software_v1]UV_VIS.absorbance[2]}")
        Set oTagUV_VIS_abs_3 = oGroup.Item("{[software_v1]UV_VIS.absorbance[3]}")
        
        Select Case Err.Number
            Case 0:
               ' MsgBox "System\Second = " & vValue
            Case tagErrorReadValue:
                MsgBox "Error to reading tag value. Error: oTag.LastErrorString"
            Case tagErrorOperationFailed:
                MsgBox "Failed to read from tag. Error: " & Err.Description
        End Select
    End If




    '===============================
    'Write to database
    CurrentDateStr = Format(DateTime.Now(), "yyyy-MM-dd hh:mm:ss")
    'DateAndTime data type is String wrapped in single quote
    strSQL = "INSERT INTO [Rockwell_Data]" _
    & "([DateAndTime],[CT_D1], [CT_D2], [CT_MC1],[CT_MC2], [CT_P2], [CT_P3], [CT_P4], [CT_P5], [CT_P6], " _
    & "[LEAK_D_Grundfos], [LEAK_D_MC1], [LEAK_D_P5], [LEAK_D_Side_box],[LEAK_D_Viscometer], " _
    & "[HMI_P3_P], [HMI_P6_P], [PT_301], [PT_302], [PT_303], [PT_304], [PT_Viscometer], [Temp_Loop_PT1], [Temp_Loop_PT2], " _
    & "[TT_Ambient], [TT_MC1], [TT_MC2], [TT_Side_Cabinet], [TT_Spare], [TT_Viscometer]," _
    & "[UV_VIS_absorbance0], [UV_VIS_absorbance1], [UV_VIS_absorbance2], [UV_VIS_absorbance3]" _
    & ")" _
    & " VALUES('" & CurrentDateStr & "','" _
    & oTagCT_D1.Value & "','" & oTagCT_D2.Value & "','" & oTagCT_MC1.Value & "','" & oTagCT_MC2.Value & "','" & oTagCT_P2.Value & "','" & oTagCT_P3.Value & "','" & oTagCT_P4.Value & "','" & oTagCT_P5.Value & "','" & oTagCT_P6.Value & "','" _
    & oTagLeak_D_Grundfos.Value & "','" & oTagLeak_D_MC1.Value & "','" & oTagLeak_D_Side_Box.Value & "','" & oTagLeak_D_P5.Value & "','" & oTagLeak_D_Viscometer.Value & "','" _
    & oTagHMI_P3_P.Value & "','" & oTagHMI_P6_P.Value & "','" & oTagPT_301.Value & "','" & oTagPT_302.Value & "','" & oTagPT_303.Value & "','" & oTagPT_304.Value & "','" & oTagPT_Viscometer.Value & "','" & oTagTemp_Loop_PT1.Value & "','" & oTagTemp_Loop_PT2.Value & "','" _
    & oTagTT_Ambient.Value & "','" & oTagTT_MC1.Value & "','" & oTagTT_MC2.Value & "','" & oTagTT_Side_Cabinet.Value & "','" & oTagTT_Spare.Value & "','" & oTagTT_Viscometer.Value & "','" _
    & oTagUV_VIS_abs_0.Value & "','" & oTagUV_VIS_abs_1.Value & "','" & oTagUV_VIS_abs_2.Value & "','" & oTagUV_VIS_abs_3.Value _
    & "')"

    


    
    cnSQL.Execute (strSQL)
    
    'datalogging post process

    cnSQL.Close
    Set cnSQL = Nothing

    
    
    
End Sub
