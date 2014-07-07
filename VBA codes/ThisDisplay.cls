VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisDisplay"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'========================================================'
'========================================================'
'========================================================'

Private Sub Display_Load()
    
    'Run Vibration software
    Dim RetVal
    Dim FirstTime As Boolean
    
    FirstTime = True
    
    'Set up tag group
    Call SetUpTagGroup

    'RetVal = Shell("C:\vibration\VibGet_mssql_rms.exe", 1)
   
End Sub



'========================================================'
'========================================================'
'========================================================'

Private Sub Display_Unload()
    'Dim RetVal
    'RetVal = Shell("C:\vibration\VibGet_mssql_rms.exe", 1)
End Sub


'========================================================'
'========================================================'
'========================================================'
Private Sub StringDisplay_Time_Change()
    
    

    
    
    Call TagValue
    
    


End Sub
