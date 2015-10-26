
CONST_SETUP_INSTALLDIR=%1%
;===INITIALIZATION END===
;lines above are inserted by builder
#NoEnv
#SingleInstance Ignore
SetWorkingDir %A_ScriptDir%

MAIN_INSTALLATION_FINISHED := 0
MAIN_SITE := 0

AppCurrentInstallDir := CONST_SETUP_INSTALLDIR
if (process_list := isAppRunning(AppCurrentInstallDir)) {
	MsgBox, % 0x2034, % CONST_SETUP_APPNAME . " " . LANG_SETUP, % LANG_CLOSE_PROCESS . "`n`n" . process_list . "`n" . LANG_CLOSE_PROCESS_CONFIRM
	IfMsgBox, No
		ExitApp
	taskkill_cmd := "TASKKILL /T /F"
	Loop, Parse, process_list, `n
	{
		RegExMatch(A_LoopField, ".*\((\d+)\)", process_pid)
		taskkill_cmd .= (process_pid ? " /PID " . process_pid1 : "")
	}
	RunWait, % taskkill_cmd,, Hide
	while(process_list := isAppRunning(AppCurrentInstallDir)) {
		MsgBox, % 0x2035, % CONST_SETUP_APPNAME . " " . LANG_SETUP, % LANG_PROCESS_PROBLEM . "`n`n" . process_list . "`n" . LANG_PROCESS_PROBLEM_CONFIRM
		IfMsgBox, Cancel
			ExitApp
	}
}

Gui, Color, FFFFFF
Gui, Add, Pic, x6 y6 w47 h47 Icon1, %A_ScriptFullPath%
Gui, Font, s14, Arial
Gui, Add, Text, x77 y6, % CONST_SETUP_TITLE . "`n" . LANG_UNINSTALL
Gui, Add, Progress, cD4D0C8 x0 y57 h1 w500 +Border, 100
Gui, Add, Progress, cF0F0F0 x0 y182 h1 w500 +Border, 100
Gui, Font, s10 c888888, Segoe UI
Gui, Add, Text, x5 y282 gAbout, ahksetup 2.1
Gui, Font, s8 c000000, Segoe UI

;text + button initialization
Gui, Add, Button, gNext vbuttonnext x311 y195 h22 w90, % LANG_NEXT . " >"
Gui, Add, Button, gGuiClose vbuttoncancel x413 y195 h22 w73, % LANG_CANCEL

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel1 x10 y65, % LANG_WELCOME
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel2 x10 y82 w480, % LANG_U_WELCOME_TEXT . "`n" . CONST_SETUP_TITLE . "."
Gui, Font, s8 c2222FF, Segoe UI
Gui, Font, s8 c000000, Segoe UI
Gui, Add, Text, % "vlabel3 x10 y120 w480", % LANG_U_QUESTION

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel4 x10 y65, % LANG_UNINSTALLING
Gui, Font, s9 c666666 normal, Segoe UI
Gui, Add, Text, vlabel5 x30 y95 h16 w450, % LANG_CLEAN_REG
Gui, Add, Text, vlabel6 x30 y113 h16 w450, % LANG_REMOVE_SHORTCUTS
Gui, Add, Text, vlabel7 x30 y131 h16 w450, % LANG_REMOVE_FILES
Gui, Add, Text, vlabel8 x200 y95 h16 w450, ...
Gui, Add, Text, vlabel9 x200 y113 h16 w450, 
Gui, Add, Text, vlabel10 x200 y131 h16 w450, 
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel11 x30 y160 h16 w450, % LANG_FINISHED_UNINSTALL


gosub, Next
Gui, Show, w500 h230, % CONST_SETUP_TITLE . " " . LANG_UNINSTALL
Return
;FileInstall, Source, Dest [, Flag]

GuiClose:
if(!MAIN_INSTALLATION_FINISHED) {
	MsgBox, 36, % LANG_EXIT_UNINSTALL, % LANG_EXIT_UNINSTALL_TEXT
	IfMsgBox, Yes
		ExitApp
} else {
	ExitApp
}
Return

Back:
MAIN_SITE -= 2
Next:
MAIN_SITE++

;clear all labels
Loop, 23
	GuiControl, Hide, label%A_Index%
GuiControl, Text, buttonnext, % LANG_NEXT . " >"
GuiControl, Text, buttoncancel, % LANG_CANCEL

if(MAIN_SITE = 1){
	Loop, 3
		GuiControl, Show, label%A_Index%
	GuiControl, Show, label22
	GuiControl, Text, buttonnext, % LANG_DOUNINSTALL
	GuiControl, Hide, buttonback
	GuiControl, Hide, buttonlicense
}
if(MAIN_SITE = 2){
	Loop, 7
		GuiControl, Show, % "label" . A_Index + 3
	GuiControl, Show, label23
	GuiControl, Hide, buttonback
	GuiControl, Text, buttonnext, % LANG_FINISH
	GuiControl, +Disabled, buttonnext
	gosub, Uninstall
}
if(MAIN_SITE = 3){
	Suicide()
}
Return

About:
	Run, https://github.com/AndTheFortyThieves/Base-Frame-for-AutoHotKey/tree/master/ahksetup
Return

Uninstall:
	Gui, Submit, NoHide
	
	GuiControl,, label8, ...
	Gui, Font, c000000 bold
	GuiControl, Font, label5
	GuiControl, Font, label8
	
	if ((CONST_SETUP_APPNAME == "") or  (CONST_SETUP_APPEXE == "")){
		MsgBox, 16, Unexpected error, No application data available.`nThe program will exit now!
		ExitApp
	}
	
	;Registry
	AppKey := "SOFTWARE\" . CONST_SETUP_APPID
	UninstallKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" . CONST_SETUP_APPID
	AppPathKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" . CONST_SETUP_APPEXE
	SetRegView % (A_Is64bitOS ? 64 : 32)
	Loop
	{
		RegDelete, HKLM, % AppKey
		RegDelete, HKLM, % UninstallKey
		RegDelete, HKLM, % AppPathKey
		RegRead, null, HKLM, % AppKey
		if (!Errorlevel) {
			MsgBox, 22, Error, Unable to remove application registry keys!
			IfMsgBox, Cancel
				Suicide()
			IfMsgBox, TryAgain
				continue
		}
		break
	}
		
	
	Gui, Font, c00CC00 normal
	GuiControl, Font, label5
	GuiControl, Font, label8
	GuiControl,, label8, % LANG_FINISHED
	
	GuiControl,, label9, ...
	Gui, Font, c000000 bold
	GuiControl, Font, label6
	GuiControl, Font, label9
	
	Loop, Read, % CONST_SETUP_INSTALLDIR . "\" . CONST_SETUP_APPUNINSTREG
	{
		if (A_LoopReadLine != "")
			RegDelete, %A_LoopReadLine%
	}
	
	;Links
	FileDelete, %A_Desktop%\%CONST_SETUP_APPNAME%.lnk
	FileRemoveDir, %A_ProgramsCommon%\%CONST_SETUP_APPSTARTMENU%, 1
	
	Gui, Font, c00CC00 normal
	GuiControl, Font, label6
	GuiControl, Font, label9
	GuiControl,, label9, % LANG_FINISHED
	
	GuiControl,, label10, ...
	Gui, Font, c000000 bold
	GuiControl, Font, label7
	GuiControl, Font, label10
	
	;Files
	
	Loop, Read, % CONST_SETUP_INSTALLDIR . "\" . CONST_SETUP_APPUNINSTFILES
	{
		if (A_LoopReadLine != "") {
			type := SubStr(A_LoopReadLine, 1, 1)
			path := SubStr(A_LoopReadLine, 3)
			if (type == "F")
				FileDelete, %path%
			if (type == "D")
				FileRemoveDir, %path%, 1
		}
	}
	
	Loop 
	{
		FileRemoveDir, % CONST_SETUP_INSTALLDIR, 1
		if (FileExist(CONST_SETUP_INSTALLDIR)) {
			MsgBox, 22, Error, Unable to remove the installation directory!
			IfMsgBox, Cancel
				Suicide()
			IfMsgBox, TryAgain
				continue
		}
		break
	}
	
	Gui, Font, c00CC00 normal
	GuiControl, Font, label7
	GuiControl, Font, label10
	GuiControl,, label10, % LANG_FINISHED
	GuiControl, Show, label11
	
	
	GuiControl, -Disabled, buttonnext
	GuiControl, +Disabled, buttoncancel
	
	DllCall("shell32\SHChangeNotify", "uint", 0x08000000, "uint", 0, "int", 0, "int", 0) ; SHCNE_ASSOCCHANGED
Return


Suicide() {
	;Just for security:
	if (!A_IsCompiled)
		ExitApp
	FileDelete remove.cmd
	FileAppend,
	(LTrim
		@echo off
		:again
		del "%A_ScriptFullPath%"
		if exist "%A_ScriptFullPath%" goto again
		cd ..
		rd /S /Q "%A_ScriptDir%"
		exit
	), remove.cmd
	Run, remove.cmd,, hide
	ExitApp
}

isAppRunning(AppPath) {
	list := ""
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
	{
		if (path := process.ExecutablePath) && InStr(path, AppPath)
			list .= process.Name . " (" . process.ProcessId . ")`n"
	}
	return (list ? list : "")
}

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