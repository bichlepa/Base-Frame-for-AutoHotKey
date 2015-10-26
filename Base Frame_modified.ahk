
BaseFrame_AppVersion=3 BETA
BaseFrame_AppUpdateVersion=3.00.00
BaseFrame_License=
(

)
BaseFrame_CheckedForUpdate:=false

;It can be set whether it should be searched for updates on every start
if (true)
{
	if (false)
	{
		iniread,BaseFrame_WhetherToCheckUpdates,%a_scriptdir%\Settings.ini,BaseFrame,Check for updates,1 ;Read setting. If it cannot be read, set 1
		if BaseFrame_WhetherToCheckUpdates=1 ;If it should search for updates
		{
			BaseFrame_CheckedForUpdate:=true
		}
	}
	else
		BaseFrame_CheckedForUpdate:=true
	
	if (BaseFrame_CheckedForUpdate=true) ;If it should search for updates
	{
		try
			run, Update Checker.exe "silent" ;Try to call update checker. It should not show anything until an update was found.
		catch
			BaseFrame_CheckedForUpdate:=-1
	}
}

;Here the user code will start


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


if not a_iscompiled
   developing=yes

lang_FindAllLanguages()
LangNoUseCache:=true

#include %a_scriptdir%
#include scripts\Generate.ahk
#include scripts\User interface\ui_advanced.ahk
#include scripts\User interface\ui_Initial_Settings.ahk
#include scripts\User interface\ui_Default_Settings.ahk
#include scripts\User interface\ui_MainGUI.ahk
#include scripts\User interface\ui_MenuBar.ahk
#include language\language.ahk


;Read content of temporary files
ErrorOccured:=false
fileread,Template_BeforeCode,Templates\Before code.ahk
if errorlevel
   ErrorOccured:=true
fileread,Template_UpdateChecker,Templates\Update Checker.ahk
if errorlevel
   ErrorOccured:=true
;~ fileread,Template_AppInstallation,Templates\App Installation.ahk
;~ if errorlevel
   ;~ ErrorOccured:=true

if ErrorOccured
{
   MsgBox, 16, % lang("Error"), % lang("The template files could not be loaded. Without them Base Frame does not work!")
   ExitApp
}




;Initialize the variables for the file selection (on the right side):
AppFileList := ""
AppDirList := ""


ui_CreateMenuBar()

ui_CreateMainGUI()



;If parameter exists open file
if 1=FastCompile
   if 2
   {
      guicontrol,+default,ButtonGenerateExe
      File=%2%
      gosub,FileWasChosenByParameter
      ;~ goto,generate
      return
   }
Return



BaseFrame_About: ;Label will be replaced on compilation
msgbox,% lang("About") "..."
return



