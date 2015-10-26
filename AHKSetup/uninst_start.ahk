﻿RunAsAdmin()
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if !A_IsCompiled
	ExitApp
FileCreateDir, %A_Temp%\Uninstall
FileInstall, #uninstaller#, %A_Temp%\Uninstall\Uninstaller.exe, 1
Run, %A_Temp%\Uninstall\Uninstaller.exe "%A_ScriptDir%"
ExitApp

/*
------------------------------------------------------------------
RunAsAdmin() by shajul
Function: To check if the user has Administrator rights and elevate it if needed by the script
URL: http://www.autohotkey.com/forum/viewtopic.php?t=50448
------------------------------------------------------------------
*/

RunAsAdmin() {
  Loop, %0%  ; For each parameter:
    {
      param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
      params .= A_Space . param
    }
  ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
      
  if not A_IsAdmin
  {
      If A_IsCompiled
         DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
      Else
         DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
      ExitApp
  }
}