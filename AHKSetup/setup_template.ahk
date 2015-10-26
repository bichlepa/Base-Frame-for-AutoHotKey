
;===INITIALIZATION END===
;lines above are inserted by builder
SetBatchLines, -1
#NoEnv
#SingleInstance Ignore
AutoUpdate=%1%
AutoUpdate := (AutoUpdate == "AutoUpdate") ? 1 : 0
if !AutoUpdate
	SetWorkingDir %A_ScriptDir%
OnMessage(0x200, "MouseHover")

MAIN_INSTALLATION_FINISHED := 0
MAIN_SITE := 0

FileInstall, ../license.txt, %A_Temp%/license.txt, 1
FileInstall, ../changelog.txt, %A_Temp%/changelog.txt, 1
FileInstall, ../res/buttonbg.png, %A_Temp%/buttonbg.png, 1
FileRead, CONST_LICENSE_TEXT, %A_Temp%/license.txt

SetRegView, 64
RegRead, AppCurrentInstallDir, HKEY_LOCAL_MACHINE\SOFTWARE\%CONST_SETUP_APPID%, InstallDir
AppExistingInstallation := !ErrorLevel
ExistingInstallationType := 0
if (!AppExistingInstallation && CONST_SETUP_APPPORTABILITY > 0) {
	AppExistingInstallation := FileExist(CONST_SETUP_APPID . "\appinfo.ini")
	ExistingInstallationType := 1
}
if AppExistingInstallation {
	if !AutoUpdate
		MAIN_SITE := -1
	CONST_SETUP_APPPORTABILITY := ExistingInstallationType
	;use update texts:
	LANG_WELCOME_TEXT := LANG_UPD_WELCOME_TEXT
	LANG_RECOMMENDATION := LANG_UPD_RECOMMENDATION
	LANG_INSTALL := LANG_UPD_INSTALL
	LANG_COMPLETED := LANG_UPD_COMPLETED
	LANG_LICENSE_AGREE := LANG_UPD_LICENSE_AGREE
	;check versions
	if (ExistingInstallationType == 0) {
		IniRead, AppCurrentUpdateVersion, % AppCurrentInstallDir . "\appinfo.ini", AppInfo, AppUpdateVersion
	} else {
		IniRead, AppCurrentUpdateVersion, % CONST_SETUP_APPID . "\appinfo.ini", AppInfo, AppUpdateVersion
		AppCurrentInstallDir := A_WorkingDir . "\" . CONST_SETUP_APPID
	}
	if (AppCurrentUpdateversion = CONST_SETUP_APPUPDATEVERSION)
		UpdateReinstall := 1
	if (AppCurrentUpdateversion > CONST_SETUP_APPUPDATEVERSION)
		UpdateRevert := 1
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
}

Gui, Color, FFFFFF
Gui, Add, Pic, x6 y6 w47 h47 Icon1, %A_ScriptFullPath%
Gui, Font, s14, Arial
Gui, Add, Text, x77 y6, % CONST_SETUP_TITLE . "`n" . LANG_INSTALLATION
Gui, Add, Progress, cD4D0C8 x0 y57 h1 w500 +Border, 100
Gui, Add, Progress, cF0F0F0 x0 y252 h1 w500 +Border, 100
Gui, Font, s8 c888888, Segoe UI
Gui, Add, Text, x5 y285 gAbout, ahksetup 2.1
Gui, Font, s8 c000000, Segoe UI

;text + button initialization
Gui, Add, Button, gBack vbuttonback x251 y260 h22 w75, % "< " . LANG_BACK
Gui, Add, Button, gNext vbuttonnext x326 y260 h22 w75, % LANG_NEXT . " >"
Gui, Add, Button, gGuiClose vbuttoncancel x413 y260 h22 w73, % LANG_CANCEL
Gui, Add, Button, gShowLicense vbuttonlicense x146 y260 h22 w93, % LANG_LICENSE_FULL
Gui, Add, Button, gShowChangelog vbuttonchangelog x46 y260 h22 w93, % LANG_CHANGELOG

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel1 x10 y65, % LANG_WELCOME
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel2 x10 y82 w480, % LANG_WELCOME_TEXT . "`n" . CONST_SETUP_TITLE . "."
if (CONST_SETUP_APPPORTABILITY == 0) {
	SetupTypeNormal := 1, SetupTypePortable := 0
}
if (CONST_SETUP_APPPORTABILITY == 1) {
	Gui, Add, Text, x10 y212 vlabel24, % LANG_PORTABLE_HINT
	SetupTypeNormal := 0, SetupTypePortable := 1
}
if (CONST_SETUP_APPPORTABILITY == 2) {
	Gui, Add, Radio, vSetupTypeNormal -Wrap Checked x10 y212, % LANG_TYPE_NORMAL
	Gui, Add, Radio, vSetupTypePortable -Wrap x10 y230, % LANG_TYPE_PORTABLE
}
Gui, Font, s8 c2222FF, Segoe UI
if (CONST_SETUP_APPWEBSITEAVAILABLE)
	Gui, Add, Text, gOpenWebsite vlabel22 x10 y119 w480, % CONST_SETUP_APPWEBSITE
Gui, Font, s8 c000000, Segoe UI
Gui, Add, Text, % "vlabel3 x10 y" (CONST_SETUP_APPWEBSITEAVAILABLE ? 140 : 120) " w480", % LANG_RECOMMENDATION

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel4 x10 y65, % LANG_LICENSE
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel5 x10 y82 w480, % LANG_LICENSE_REVIEW . " " . CONST_SETUP_TITLE . "."
Gui, Add, Edit, vlabel6 x10 y100 w480 h120 ReadOnly, % CONST_LICENSE_TEXT
Gui, Add, Text, vlabel7 x10 y227 w480, % LANG_LICENSE_AGREE

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel8 x10 y65, % LANG_DESTINATION
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel9 x10 y82 w480, % LANG_DESTINATION_TEXT
Gui, Add, GroupBox, vlabel10 x10 y160 w480 h60, % LANG_DESTINATION_GROUPBOX
Gui, Add, Edit, vlabel11 x20 y182 w365 h25 ReadOnly, % A_ProgramFiles . "\" . CONST_SETUP_STD_FOLDER
Gui, Add, Button, gChooseFolder vlabel12 x390 y182 w90 h25, % LANG_BROWSE

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel13 x10 y65, % LANG_INSTALLING
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Progress, vlabel14 x10 y86 h12 w450 -Border c111111, 0
;c1111DD
Gui, Add, Text, vlabel23 x10 y107 h16 w450, ...
Gui, Add, Text, vlabel15 x465 y83 w35, 0`%
Gui, Add, Edit, vlabel16 x10 y128 w480 h120 ReadOnly, % "-- " . CONST_SETUP_TITLE . " " . LANG_SETUP

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel17 x10 y65, % LANG_COMPLETED
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel18 x10 y82 w480, % CONST_SETUP_TITLE . " (" . CONST_SETUP_APPUPDATEVERSION . ") " . LANG_COMPLETED_TEXT
Gui, Add, Checkbox, vlabel19 x20 y140 +Checked, % LANG_DESKTOP_SHORTCUT
Gui, Add, Checkbox, vlabel20 x20 y165 +Checked, % LANG_STARTPROG_SHORTCUT
Gui, Add, Checkbox, vlabel21 x20 y190 +Checked, % LANG_RUN . " " . CONST_SETUP_TITLE

Gui, Font, s9 c000000 bold, Segoe UI
Gui, Add, Text, vlabel25 x10 y65, % LANG_WELCOME
Gui, Font, s9 c000000 normal, Segoe UI
Gui, Add, Text, vlabel26 x10 y82 w480, % LANG_EXISTING_INSTALLATION . " " . AppCurrentUpdateVersion
;Gui, Add, Button, vlabel27 gUninstall x20 y150 w100 h22, Deinstallieren
;Gui, Add, Button, vlabel28 gNext x20 y180 w100 h22, % "Update" . " (" . CONST_SETUP_APPUPDATEVERSION . ")"
Gui, Add, Picture, vlabel27 HwndhUninst gUninstall x20 y140 h35 +Border, %A_Temp%/buttonbg.png
Gui, Add, Picture, vlabel28 HwndhNext gNext x20 y190 h35 +Border, %A_Temp%/buttonbg.png
Gui, Font, s13 c333333 normal, Segoe UI
Gui, Add, Text, vlabel29 HwndhUninstT gUninstall x30 y147 BackgroundTrans, % LANG_DOUNINSTALL
Gui, Add, Text, vlabel30 HwndhNextT gUninstall x30 y197 BackgroundTrans, % LANG_UPD_INSTALL . " (" . (UpdateReinstall ? (LANG_UPD_REINSTALL . " ") : (UpdateRevert ? (LANG_UPD_REVERT . " ") : "")) . CONST_SETUP_APPUPDATEVERSION . ")"

gosub, Next
Gui, Show, w500 h300, % CONST_SETUP_TITLE . " " . LANG_SETUP
Return
;FileInstall, Source, Dest [, Flag]

GuiClose:
if(!MAIN_INSTALLATION_FINISHED) {
	MsgBox, 36, % LANG_EXIT_SETUP, % LANG_EXIT_SETUP_TEXT
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
Loop, 30
	GuiControl, Hide, label%A_Index%
GuiControl, Text, buttonnext, % LANG_NEXT . " >"
GuiControl, Text, buttoncancel, % LANG_CANCEL
GuiControl, Hide, SetupTypeNormal
GuiControl, Hide, SetupTypePortable
Gui, Submit, NoHide

if(MAIN_SITE = 0){
	Loop, 6
		GuiControl, Show, % "label" . A_Index + 24
	GuiControl, Hide, buttonback
	GuiControl, Hide, buttonlicense
	GuiControl, Hide, buttonchangelog
	GuiControl, Hide, buttonnext
}
if(MAIN_SITE = 1){
	Loop, 3
		GuiControl, Show, label%A_Index%
	GuiControl, Show, label22
	GuiControl, Show, label24
	GuiControl, Show, SetupTypeNormal
	GuiControl, Show, SetupTypePortable
	GuiControl, Show, buttonnext
	GuiControl, Hide, buttonback
	GuiControl, Hide, buttonlicense
	GuiControl, Hide, buttonchangelog
}
if(MAIN_SITE = 2){
	Loop, 4
		GuiControl, Show, % "label" . A_Index + 3
	GuiControl, Show, buttonback
	GuiControl, Show, buttonlicense
	if (CONST_SETUP_APPCHANGELOGAVAILABLE) {
		GuiControl, Show, buttonchangelog
	}
;!!	if (SetupTypePortable and !AppExistingInstallation) {
;!!		GuiControl, Text, label7, % LANG_PTB_LICENSE_AGREE
;!!		GuiControl, Text, buttonnext, % LANG_INSTALL
;!!	} else if AppExistingInstallation {
	if AppExistingInstallation {
		GuiControl, Text, buttonnext, % LANG_INSTALL
	} else {
		GuiControl, Text, label7, % LANG_LICENSE_AGREE
		GuiControl, Text, buttonnext, % LANG_AGREE
	}
	GuiControl, Text, buttoncancel, % LANG_DECLINE
}
if(MAIN_SITE = 3){
	GuiControl, Hide, buttonlicense
	GuiControl, Hide, buttonchangelog
	if SetupTypePortable
	{
		GuiControl, Text, label11, % A_WorkingDir . "\" . CONST_SETUP_APPID
;!!		FileCreateDir, % A_WorkingDir . "\" . CONST_SETUP_APPID
	}
;!!		MAIN_SITE := 4
;!!	} else if AppExistingInstallation {
	if AppExistingInstallation {
		GuiControl, Text, label11, % AppCurrentInstallDir
		MAIN_SITE := 4
	} else {
		Loop, 5
			GuiControl, Show, % "label" . A_Index + 7
		GuiControl, Show, buttonback
		GuiControl, Text, buttonnext, % LANG_INSTALL
	}
}
if(MAIN_SITE = 4){
	Loop, 4
		GuiControl, Show, % "label" . A_Index + 12
	GuiControl, Show, label23
	GuiControl, Hide, buttonback
	GuiControl, Text, buttonnext, % LANG_NEXT
	GuiControl, +Disabled, buttonnext
	gosub, Install
}
if(MAIN_SITE = 5){
	if SetupTypeNormal and !AppExistingInstallation {
		Loop, 5
			GuiControl, Show, % "label" . A_Index + 16
	} else {
		GuiControl, Show, % "label17"
		GuiControl, Show, % "label18"
		GuiControl, Show, % "label21"
	}
	GuiControl, Hide, buttonback
	GuiControl, Text, buttonnext, % LANG_FINISH
	GuiControl, -Disabled, buttonnext
	GuiControl, +Disabled, buttoncancel
	MAIN_INSTALLATION_FINISHED := 1
}
if(MAIN_SITE = 6){
	Gui, Submit, NoHide
	;19 - Desktop
	;20 - Start Menu
	;21 - Run
	if(label19 and !(AppExistingInstallation or SetupTypePortable))
		FileCreateShortcut, %label11%\%CONST_SETUP_APPEXE%, %A_Desktop%\%CONST_SETUP_APPNAME%.lnk, %label11%, % "", % CONST_SETUP_APPNAME . " " . CONST_SETUP_APPVERSION
	if(label20 and !(AppExistingInstallation or SetupTypePortable))
	{
		FileCreateDir, %A_ProgramsCommon%\%CONST_SETUP_APPSTARTMENU%
		FileCreateShortcut, %label11%\%CONST_SETUP_APPEXE%, %A_ProgramsCommon%\%CONST_SETUP_APPSTARTMENU%\%CONST_SETUP_APPNAME%.lnk, %label11%, % "", % CONST_SETUP_APPNAME . " " . CONST_SETUP_APPVERSION
		FileCreateShortcut, %label11%\Uninstall.exe, %A_ProgramsCommon%\%CONST_SETUP_APPSTARTMENU%\%CONST_SETUP_APPNAME% - %LANG_UNINSTALL%.lnk, %label11%, % "", % CONST_SETUP_APPNAME . " " . CONST_SETUP_APPVERSION . " - " . LANG_UNINSTALL
	}
	if(label21)
		Run, %label11%\%CONST_SETUP_APPEXE%, %label11%
	ExitApp
}
Return

About:
	Run, https://github.com/AndTheFortyThieves/Base-Frame-for-AutoHotKey/tree/master/ahksetup
Return

OpenWebsite:
	Run, % CONST_SETUP_APPWEBSITE
Return

ShowLicense:
	Run, %A_Temp%/license.txt
Return

ShowChangelog:
	Run, %A_Temp%/changelog.txt
Return

ChooseFolder:
	FileSelectFolder, new_folder,, 1, % LANG_DESTINATION_SELECT
	If (new_folder != "")
		GuiControl, Text, label11, % new_folder
Return

Install:
	Gui, Submit, NoHide
	if !FileExist(label11)
		FileCreateDir, % label11
	#Include ../instructions
	if (!FileExist(label11 . "\Uninstall.exe")) {
		MsgBox, 16, Error, Unable to write to installation directory!
	}
	DllCall("shell32\SHChangeNotify", "uint", 0x08000000, "uint", 0, "int", 0, "int", 0) ; SHCNE_ASSOCCHANGED
	log(LANG_FINISHED . " --")
	GuiControl, Text, label23, % LANG_FINISHED . "!"
	GuiControl, -Disabled, buttonnext
	GuiControl, +Disabled, buttoncancel
Return

Uninstall:
	if ExistingInstallationType {
		UninstallLocation := A_ScriptDir . "\" . CONST_SETUP_APPID . "\Uninstall.exe"
	} else {
		UninstallLocation := AppCurrentInstallDir . "\Uninstall.exe"
	}
	if !FileExist(UninstallLocation)
		FileInstall, Uninstall.exe, % UninstallLocation
	Run, % UninstallLocation
	ExitApp
Return

log(message){
	global
	Gui, Submit, NoHide
	GuiControl, Text, label16, % message . "`n" . label16 
	StringReplace, rel_path, message, % label11, % "", 0
	GuiControl, Text, label23, % rel_path
	Return
}

prog(percent){
	global
	while (progressnow < percent) {
		progressnow += 1
		GuiControl,, label14, % progressnow
		GuiControl,, label15, %progressnow% `%
		sleep, 15
	}
	Return
}

MouseHover(wParam, lParam){
	global hUninst, hUninstT, hNext, hNextT
	static hover
	MouseGetPos,,,, ctrl, 2
	if ((ctrl == hUninst) or (ctrl == hUninstT)) {
		if !hover
		{
			GuiControl, MoveDraw, label29, x35 y147
			hover := 1
		}
	} else if ((ctrl == hNext) or (ctrl == hNextT)) {
		if !hover
		{
			GuiControl, MoveDraw, label30, x35 y197
			hover := 1
		}
	} else if hover {
		GuiControl, Move, label29, x30 y147
		GuiControl, Move, label30, x30 y197
		hover := 0
	}
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
	global
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