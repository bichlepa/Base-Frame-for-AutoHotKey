#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;~ ApInstallationLanguage=deutsch
AppLicense=GPL

lang_FindAllLanguages()
lang_LoadSettings()

#include %a_scriptdir%
#include scripts\Generate.ahk
#include scripts\settings.ahk
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
fileread,Template_AppInstallation,Templates\App Installation.ahk
if errorlevel
   ErrorOccured:=true

if ErrorOccured
{
   MsgBox, 16, % lang("Error"), % lang("The template files could not be loaded. Without them Base Frame does not work!")
   ExitApp
}


;Run the Subroutine "Check" every 100ms:
SetTimer, Check, 100

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



