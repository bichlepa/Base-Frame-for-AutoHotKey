﻿ui_CreateMainGUI()
{
	global
    gui 1:default
	Gui, Add, Text, x10 y10,% lang("Sourcecode") ":"
	Gui, Add, Edit, x10 y30 w180 vSource ReadOnly,
	Gui, Add, Button, x195 y25 h30 w50 gOpenFile +default, % lang("Open")
	Gui, Add, Text, x10 y60, % lang("Application name") ":"
	Gui, Add, Edit, x10 y80 w180 vAppName,
	Gui, Add, GroupBox, x10 y110 w230 h213,  % lang("Important values")
	Gui, Add, Text, x15 yp+25, % lang("Installation folder") ":"
	Gui, Add, Edit, x115 yp vAppStdInstal,
	Gui, Add, Text, x15 yp+25, % lang("Start menu folder") ":"
	Gui, Add, Edit, x115 yp vAppStartMenu,
	Gui, Add, Text, x15 yp+25, % lang("Application ID") ":"
	Gui, Add, Edit, x115 yp vAppID,
	Gui, Add, Text, x15 yp+30, % lang("Author") ":"
	Gui, Add, Edit, x115 yp vAppAuthorName,
	Gui, Add, Text, x15 yp+25, % lang("Email") ":"
	Gui, Add, Edit, x115 yp vAppAuthorEmail,
	Gui, Add, Text, x15 yp+30,% lang("Application version") ":"
	Gui, Add, Edit, x115 yp vAppVersion,
	Gui, Add, Text, x15 yp+25, % lang("Update Version") ":"
	Gui, Add, Edit, x115 yp vAppUpdateVersion,
	Gui, Add, Button, x35 yp+45 w180 h30 vButtonAdvancedInformations gButtonAdvancedInformations disabled, % lang("Advanced")
	Gui, Add, Text, x260 y10, % lang("Included files") ":"
	Gui, Add, Button, x260 y30 w65 vAddFileB gAddFile Disabled,% "+ " lang("Files") ":"
	Gui, Add, Button, X+5 y30 w70 vAddDirB gAddDir Disabled,% "+ " lang("Folders")
	Gui, Add, Button, X+5 y30 w70 vAddExeB gAddExe Disabled, % "+ " lang("Exe")
	Gui, Add, Checkbox, x335 y60 -Wrap vCheckbox_folderAndContent Checked, % "+ " lang("Content")
	Gui, Add, ListBox, vList x260 y85 w250 h280 gShowItem,%  "--- " lang("Folders") ": ---|<" lang("None") ">|" A_Tab "|--- " lang("Files") ": ---|<" lang("None") ">|" a_tab "|--- " lang("Compile scripts") ": ---|<" lang("None") ">"
	Gui, Add, Button, vButtonRemoveItem gRemoveItem x260 y365 disabled, % lang("Remove Entry")
	Gui, Add, Button, vButtonIconSelect gSelectIcon X+20 yp disabled, % lang("Choose icon")
	Gui, Add, Progress, x250 y0 w1 h395 c000000, 100 ;Vertikal separator
	Gui, Add, Progress, x0 y395 w520 h1 c000000, 100 ;Horizontal Separator
	Gui, Add, Progress, x0 y0 w520 h1 c000000, 100 ;Separator of menu
	Gui, Add, Button, x10 y400 h30 w200 vButtonGenerateExe gGenerate disabled,% lang("Generate installation file")
	Gui, Add, Checkbox, X+5 yp+8 vCheckboxKeepRemainingFiles, % lang("Keep temporary files")
	Gui, Add, Button, x430 yp-8 w80 h30 gGuiClose, % lang("Close")
	Gui, Show,w520 , % lang("Base Frame") " v" BaseFrame_AppVersion
	
	
}

goto,JumpOverMainGUILabels

GuiClose:
ExitApp








;Chosse a sourcecode file
OpenFile:


;If already any AHK application is opened, restart. TODO: Allow to change path and file without restart
if AppFileName
{
   MsgBox, 52, % lang("New sourcecode"), % lang("You are about to open a new sourcecode of another Application.") "`n" lang("All your current settings of currently opened application will be lost.") "`n`n" lang("Base Frame needs to be restarted.") "`n`n" lang("Do you want to continue?")
   ifmsgbox,Yes
   {
      Reload
      return
   }
   else
      return
}

;Choose file:
FileSelectFile, File, % 3+32, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, % lang("Select sourcecode"), % lang("AutoHotKey scripts") " (*.ahk)"
;If user aborts:
If (File = "")
   Return



FileWasChosenByParameter: ;It is possible to start the application with parameters that point to a file. It will lead here

;Split file to following variables:
SplitPath File, App_Filename, App_Direction, App_FileExtension, App_FilenameNoExt, App_Drive
;   %App_Filename%:   Filename with extension
;   %App_Direction%:      Folder
;   %App_FileExtension%:      Extension
;   %App_FilenameNoExt%:   File name without extension (Generation of Application name)
;   %App_Drive%:   Drive of file


;Check whether it is an ahk script:
If (App_FileExtension != "ahk") {
   App_Direction := ""
   MsgBox, 16, % lang("Error"), % lang("Please choose an AutoHotKey script")
   Return
}

;Show file in edit field:
If (App_Direction != App_Drive) {
   GuiControl,, Source, %App_Drive%\...\%App_FilenameNoExt%.%App_FileExtension%
} else {
   GuiControl,, Source, %File%
}

if not ( fileexist(App_Direction "\AppInfo.ini") or fileexist(App_Direction "\Settings.ini"))
{

   ui_SetInitialSettings()
   return
}
else
{
   if not fileexist(App_Direction "\AppInfo.ini")
   { 
      ;Keep compability to old version of Base Frame
      tempInifile=Settings.ini
      tempIniSection=BaseFrame
      
   }
   else
   {
      tempInifile=AppInfo.ini
      tempIniSection=AppInfo
   }
   
   ;Try to load already existing settings
   iniread,AppName,%App_Direction%\%tempInifile%,%tempIniSection%,Appname,%a_space%
   iniread,AppStdInstal,%App_Direction%\%tempInifile%,%tempIniSection%,AppStdInstal,%a_space%
   iniread,AppStartMenu,%App_Direction%\%tempInifile%,%tempIniSection%,AppStartMenu,%a_space%
   iniread,AppID,%App_Direction%\%tempInifile%,%tempIniSection%,AppID,%a_space%
   if (AppStdInstal="" or AppStartMenu="" or AppID="") ;Keep compability to old version of Base Frame
   {
      iniread,AppFolder,%App_Direction%\%tempInifile%,%tempIniSection%,AppOrdner,%a_space%
      if (AppStdInstal="")
         AppStdInstal:=AppFolder
      if (AppStartMenu="")
         AppStartMenu:=AppFolder
      if (AppID="")
         AppID:=AppFolder
   }
   iniread,AppAuthorName,%App_Direction%\%tempInifile%,%tempIniSection%,AppAuthorName,%a_space%
   iniread,AppAuthorEmail,%App_Direction%\%tempInifile%,%tempIniSection%,AppAuthorEmail,%a_space%
   iniread,AppVersion,%App_Direction%\%tempInifile%,%tempIniSection%,AppVersion,%a_space%
   iniread,AppUpdateVersion,%App_Direction%\%tempInifile%,%tempIniSection%,AppUpdateVersion,%a_space%
   if (AppUpdateVersion="") ;Keep compability to old version of Base Frame
   {
      iniread,AppUpdateVersion,%App_Direction%\%tempInifile%,%tempIniSection%,AppGenaueVersion,%a_space%
   }
   
   iniread,AppIncludeUpdater,%App_Direction%\%tempInifile%,%tempIniSection%,AppIncludeUpdater,%a_space%
   iniread,AppOptionCheckForUpdatesOnStartup,%App_Direction%\%tempInifile%,%tempIniSection%,AppOptionCheckForUpdatesOnStartup,%a_space%
   iniread,AppURLVersionComparison,%App_Direction%\%tempInifile%,%tempIniSection%,AppUrlTxtVersion,%a_space%
   iniread,AppURLVersionComparison2,%App_Direction%\%tempInifile%,%tempIniSection%,AppUrlTxtVersion2,%a_space%
   iniread,AppURLVersionComparison3,%App_Direction%\%tempInifile%,%tempIniSection%,AppUrlTxtVersion3,%a_space%
   iniread,AppAutomaticUpdateIniFile,%App_Direction%\%tempInifile%,%tempIniSection%,AppAutomaticUpdateIniFile,%a_space%
   iniread,AppAutomaticUpdateIniSection,%App_Direction%\%tempInifile%,%tempIniSection%,AppAutomaticUpdateIniSection,%a_space%
   iniread,AppAutomaticUpdateIniKey,%App_Direction%\%tempInifile%,%tempIniSection%,AppAutomaticUpdateIniKey,%a_space%
   iniread,AppCreateIniWithUpdateInformations,%App_Direction%\%tempInifile%,%tempIniSection%,AppCreateIniWithUpdateInformations,%a_space%
   iniread,AppPathOfIniWithUpdateInformations,%App_Direction%\%tempInifile%,%tempIniSection%,AppPathOfIniWithUpdateInformations,%a_space%
   iniread,AppURLInstaller,%App_Direction%\%tempInifile%,%tempIniSection%,AppURLInstaller,%a_space%
   iniread,AppWebsite,%App_Direction%\%tempInifile%,%tempIniSection%,AppWebsite,%a_space%
   
   iniread,AppChangelog,%App_Direction%\%tempInifile%,%tempIniSection%,AppChangelog,%a_space%
   
   iniread,AppOptionWhichLicense,%App_Direction%\%tempInifile%,%tempIniSection%,AppOptionWhichLicense,%a_space%
   iniread,AppCustomLicensePath,%App_Direction%\%tempInifile%,%tempIniSection%,AppCustomLicensePath,%a_space%
   iniread,AppLicense,%App_Direction%\%tempInifile%,%tempIniSection%,AppLicense,%a_space%
   
   iniread,AppLanguage,%App_Direction%\%tempInifile%,%tempIniSection%,AppLanguage,%a_space%
   iniread,AppPortability,%App_Direction%\%tempInifile%,%tempIniSection%,AppPortability,%a_space%
   AppPortability++
   
   iniread,AppDirList,%App_Direction%\%tempInifile%,%tempIniSection%,AppDirList,%a_space%
   iniread,AppFileList,%App_Direction%\%tempInifile%,%tempIniSection%,AppFileList,%a_space%
   iniread,AppExeList,%App_Direction%\%tempInifile%,%tempIniSection%,AppExeList,%a_space%
   iniread,AppIconList,%App_Direction%\%tempInifile%,%tempIniSection%,AppIconList,%a_space%


}

ShowLoadedSettingsInGUI: ;Label is used if the initial settings was opened, because the application was selected the first time

;If some settings are empty, assign default values
if not AppAuthorName
{
   IniRead,AppAuthorName,Settings.ini,DefaultValues,AppAuthorName,%a_space%
   if not AppAuthorName
      AppAuthorName:=A_UserName
}

if not AppAuthorEmail
{
   IniRead,AppAuthorEmail,Settings.ini,DefaultValues,AppAuthorEmail,%a_space%
}

if not AppName
   AppName:=App_FilenameNoExt

if not AppFileName
   AppFileName:=AppName

if not AppStdInstal
   AppStdInstal:=AppName
if not AppStartMenu
   AppStartMenu:=AppName
if not AppID
   AppID:=AppName

if not AppVersion
   AppVersion=1.0	

if not AppUpdateVersion
   AppUpdateVersion=1.00.00
   
if not AppAutomaticUpdateIniFile
   AppAutomaticUpdateIniFile=settings.ini
if not AppAutomaticUpdateIniSection
   AppAutomaticUpdateIniSection=BaseFrame
if not AppAutomaticUpdateIniKey
   AppAutomaticUpdateIniKey=Check for updates

if not AppLicense
   AppLicense=gnu_gpl
if not AppLanguage
   AppLanguage:=UIlang

if AppIncludeUpdater=
   AppIncludeUpdater:=false
if AppCreateIniWithUpdateInformations=
   AppCreateIniWithUpdateInformations:=false
if not AppOptionCheckForUpdatesOnStartup
   AppOptionCheckForUpdatesOnStartup:=1
if AppOptionWhichLicense=
   AppOptionWhichLicense:=1
if AppPortability=
   AppPortability:=1

;Show loaded settings in gui
GuiControl,,AppName,%AppName%
GuiControl,,AppStdInstal,%AppStdInstal%
GuiControl,,AppStartMenu,%AppStartMenu%
GuiControl,,AppID,%AppID%
GuiControl,,AppAuthorName,%AppAuthorName%
GuiControl,,AppAuthorEmail,%AppAuthorEmail%
GuiControl,,AppVersion,%AppVersion%
GuiControl,,AppUpdateVersion,%AppUpdateVersion%
GuiControl,,AppURLVersionComparison,%AppURLVersionComparison%

guicontrol,enable,ButtonAdvancedInformations


;If the exe list is empty, add the three Base Frame Exes
if not AppExeList
{
   if AppIncludeUpdater
      AppExeList=|%AppFileName%|Update Checker|
   else
       AppExeList=|%AppFileName%|
}
   
gosub,GuiListUpdate

;Run the Subroutine "Check" every 100ms:
SetTimer, Check, 100



Return








;Add a file to %AppFileList%
AddFile:

;Select file
FileSelectFile, NewFiles, M3, %App_Direction%,  % lang("Select file to add")
;Falls der Benutzer abbricht:
If (NewFiles = "")
   Return

;It's possible to choose multiple files. The file must be saved in different Variables
Loop, Parse, NewFiles, `n
{
   If (A_Index = 1)
      NewDir := A_LoopField
   else 
   {
	   count := A_Index - 1
	   File%count% := A_LoopField
   }
}

;Check whether the choosen file are inside %App_Direction%
IfNotInString NewDir, %App_Direction%
{
   MsgBox, 16, % lang("Error"), % lang("The files must be inside the path of the sourcecode")
   Return
}

;Make NewDir a relative path
StringReplace, NewDir, NewDir, %App_Direction%\

;Loop through choosen files:
Loop %count%
{
   ;If the file is in %App_Direction%, only add the filenme.
   ;If the file is in a subfolder, add the subfolder and filename.
   NewFile := (NewDir = App_Direction) ? File%A_Index% : NewDir . "\" . File%A_Index%

   ;Skip the file if it is a sourcecode file. Notify user
   If (NewFile == App_Filename) {
      If (count = 1)
         MsgBox, 64, % lang("Information"), % lang("The sourcecode script cannot be added to the selection")
      else
         MsgBox, 64, % lang("Information"), % lang("The file %1% could not be added because it is the sourcecode script",NewFile)
      continue
   }

   ;Add file to %AppFileList%
   ;If %AppFileList% is empty, save file as first entry, otherwise append
   If (AppFileList = "")
      AppFileList=|%NewFile%|
   else {
      IfNotInString, AppFileList, |%NewFile%|
         AppFileList=%AppFileList%%NewFile%|
   }
}

;If the files are inside a subfolder:
;Check whether the folder is inside %AppDirList%. If not, add it.
If not (NewDir = App_Direction)
{
   If (AppDirList = "")
      AppDirList=|%NewDir%|
   else {
      IfNotInString, AppDirList, |%NewDir%|
         AppDirList=%AppDirList%%NewDir%|
   }
}

gosub,GuiListUpdate
Return








;Add a folder to%AppDirList%:
AddDir:

;Choose a folder:
;   (%App_Direction% enthält den Pfad in dem die Quellcode-Datei liegt.)
FileSelectFolder NewDir, %App_Direction%, 0,  % lang("Select a folder to add")
;If user cancels:
If (NewDir = "")
   Return

;Check whether it is really a subfolder of %App_Direction%.
IfNotInString NewDir, %App_Direction%
{
   MsgBox, 16,  % lang("Error"),  % lang("The folder must be a subfolder of the sourcecode path") 
   Return
}

;Remove %App_Direction% from the path and make it relative:
StringReplace, NewDir, NewDir, %App_Direction%\

;If the folder is the %App_Direction%, abort
If (NewDir = App_Direction)
   Return

;Add choosen folder to %AppDirList%:
;If %AppDirList% is empty, save folder as first entry, otherwise append:
If (AppDirList = "")
   AppDirList=|%NewDir%|
else {
   IfNotInString, AppDirList, |%NewDir%|
      AppDirList=%AppDirList%%NewDir%|
}

;%Checkbox_folderAndContent% determines whether the files inside the folder should be added.
;If so, add the files (like in the AddFile subroutine)
Gui, Submit, NoHide
If Checkbox_folderAndContent
{
   Loop, %App_Direction%\%NewDir%\*.*, 0, 0
   {
      StringReplace, NewFile, A_LoopFileLongPath, %App_Direction%\
      If (AppFileList = "")
         AppFileList=|%NewFile%|
      else {
         IfNotInString, AppFileList, |%NewFile%|
            AppFileList=%AppFileList%%NewFile%|
      }
      If (A_Index = 25)
         ToolTip %_Bitte_Warten_%
   }
   ToolTip
}
gosub,GuiListUpdate
return



AddExe:
;Choose a file:
FileSelectFile, NewFiles, M3, %App_Direction%,  % lang("Add Scripts that should compile"),% lang("AutoHotKey scripts") " (*.ahk)"
;If user cancels:
If (NewFiles = "")
   Return

;It's possible to select all files. Save them in other variables
Loop, Parse, NewFiles, `n
{
   If (A_Index = 1)
      NewDir := A_LoopField
   else {
   count := A_Index - 1
   File%count% := A_LoopField
   }
}

;Check whether the chossen files are inside %App_Direction% or a subfolder
IfNotInString NewDir, %App_Direction%
{
   MsgBox, 16,  % lang("Error"),  % lang("The files must be inside the folder of the sourcecode or a subfolder") 
   Return
}

;Remove %App_Direction% from the path to make it relative.
StringReplace, NewDir, NewDir, %App_Direction%\

;Loop through selected files
Loop %count%
{
   ;if the file is in %App_Direction%, add filename to list.
   ;If it is inside a subfolder, also add the subfolder 
   NewFile := (NewDir = App_Direction) ? File%A_Index% : NewDir . "\" . File%A_Index%

 
   stringtrimright,newfile,newfile,4 ;Remove extension
   ;Add file in %AppExeList%:
   ;If %AppExeList% is empty, put it as first entry, otherwise append
   If (AppExeList = "")
      AppExeList=|%NewFile%|
   else {
      IfNotInString, AppExeList, |%NewFile%|
         AppExeList=%AppExeList%%NewFile%|
   }
}

;If the files were inside a subfolder
;Check whether %AppDirList% contains the subfolder, otherwise add it:
If not (NewDir = App_Direction)
{
   If (AppDirList = "")
      AppDirList=|%NewDir%|
   else {
      IfNotInString, AppDirList, |%NewDir%|
         AppDirList=%AppDirList%%NewDir%|
   }
}

gosub,GuiListUpdate
return

SelectIcon:
;If an icon is already selected, remove it
IconForThisExe:=FindIconAssignedToExe(list)
if IconForThisExe
{
   stringreplace,AppIconList,AppIconList,|%List%#%IconForThisExe%|,|
   if AppIconList=|
      AppIconList=
   return
}


;Select a file:
FileSelectFile, NewFile, 3, %App_Direction%, % lang("Choose icon file for the script %1%",List),% lang("Icons") " (*.ico)"
;If user aborts:
If (NewFile = "")
   Return

;If icon is in a subfolder, make relative path
StringReplace,NewFile,NewFile,%App_Direction%\
   
;Connect icon to selected entry
If (AppIconList = "")
   AppIconList=|%List%#%NewFile%|
else {
   IfNotInString, AppIconList, |%List%#
      AppIconList=%AppIconList%%List%#%NewFile%|
   else
   {
      IconForThisExe:=FindIconAssignedToExe(List)
      stringreplace,AppIconList,AppIconList,#%IconForThisExe%|,#%NewFile%|
   }
   
}


gosub,GuiListUpdate

return


GuiListUpdate:
;Show content of %AppDirList% and %AppFileList% in the list
insert1 := (AppDirList = "") ? "|<" lang("none") ">|" : AppDirList
insert2 := (AppFileList = "") ? "|<" lang("none") ">|" : AppFileList
insert3 := (AppExeList = "") ? "|<" lang("none") ">|" : AppExeList
GuiControl,, List, |
GuiControl,, List,% "--- " lang("Folders") ": ---" insert1 A_Tab "|--- " lang("Files") ": ---" insert2 a_tab "|--- " lang("Compile scripts") ": ---" insert3
Return








;Remove the selected item from the file selection in the list
RemoveItem:
ToolTip
Gui, Submit, NoHide

;If the entry is a file, delete ist from,%AppFileList%:
IfInString, AppFileList, |%List%|
   StringReplace, AppFileList, AppFileList, |%List%|, |

;If the entry is a folder, delete it from %AppDirList%
IfInString, AppDirList, |%List%|
{
   ;Tell that the files will be removed, too
   MsgBox, 52, % lang("Attention"), % lang("All files that are inside this folder will also be removed from the selection")
   IfMsgBox no
      Return
   ;Remove all files inside the folder from %AppFileList%
   Loop, Parse, AppFileList, |
   {
      If ((SubStr(A_LoopField, 1, StrLen(List))) == List)
         StringReplace, AppFileList, AppFileList, |%A_LoopField%|, |
   }
   ;Remove the folder from %AppDirList%
   StringReplace, AppDirList, AppDirList, |%List%|, |
}



ifinstring,AppExeList,|%List%| 
{
   if (List="Update Checker" or List=AppFileName)
   {
      MsgBox, 16,  % lang("Error"),  % lang("The file belongs to Base Frame and cannot be removed")
      return
   }
   StringReplace, AppExeList, AppExeList, |%List%|, |
   
}


;If the last entry was removed from %AppFileList% or %AppDirList% only a | is left in the variable.
;If so, empty the variable:
If (AppDirList = "|")
   AppDirList := ""
If (AppFileList = "|")
   AppFileList := ""
If (AppExeList = "|")
   AppExeList := ""

;Show the contents of %AppDirList% and %AppFileList% in the list:
gosub,GuiListUpdate
Return  





;Find out whitch icon is assigned with a script
FindIconAssignedToExe(exe)
{
   global
   local tempicon
   loop,parse,AppIconList,|
   {
      IfINstring,a_loopfield,%exe%
      {
         stringgetpos,pos,a_loopfield,#
         stringtrimleft,tempicon,a_loopfield,(pos + 1)
         return tempicon
      }
      
   }

   return
}





;Show a tooltip with the name of the selected entry of the file selection. (Useful for long pathes and filenames)
ShowItem:
Gui, Submit, NoHide
;If selected entry is not valid (like "--- folder: ---" or "<none>") turn off tooltip:
If not (List == A_Tab or List == "--- %_Ordners_%: ---" or List == "--- %_Dateien_%: ---" or List == "--- %_Skripte_kompilieren_%: ---" or List == "<%_Keine_%>")
{
   ifinstring,AppExeList,|%List%| ;Show also the icon for every exe
   {
      IconForThisExe:=FindIconAssignedToExe(List)
      if IconForThisExe=
         IconForThisExe:= "<" lang("No icon")">"
      settimer,RemoveTooltip,-2000
      ToolTip, % List " --- " lang("Icon") ": " IconForThisExe
   }
   else
   {
      settimer,RemoveTooltip,-2000
      ToolTip, %List%
   }
}
else
   ToolTip
Return

RemoveTooltip:
ToolTip
return





;The Check routine is executed regulary and does several things
Check:

;The buttons "+ File", "+ Folder" und "+ Exe" will be activated as soon as a sourcecode (and thus a root directory) is set
If (App_Direction != "") {
   GuiControl, Enable, AddFileB
   GuiControl, Enable, AddDirB
   GuiControl, Enable, AddExeB
}

;The "Remove entry" Button will be activated when a valid entry is choosen
;   (invalid entries are "--- Folder: ---" or "<none>"
Gui, Submit, NoHide

If not (List == A_Tab or List == "--- " lang("Folders") ": ---" or List == "--- " lang("Files") ": ---" or List == "--- " lang("Compile scripts") ": ---" or List == "<" lang("None") ">" or List =="") ;Entry valid?
{
   ifinstring,AppExeList,|%List%| ;Exe-File chosen?
   {
      GuiControl,Enable,ButtonIconSelect
      
      IconForThisExe:=FindIconAssignedToExe(list) ;Already an icon assigned?
      if IconForThisExe
         GuiControl,,ButtonIconSelect,% lang("Delete icon")
      else
         GuiControl,,ButtonIconSelect,% lang("Select icon")
      
   }
   else
      GuiControl,Disable,ButtonIconSelect
   
   GuiControl, Enable, ButtonRemoveItem
   
   
}
else
{
   GuiControl, Disable, ButtonRemoveItem
   GuiControl,Disable,ButtonIconSelect
}


;The "Generate installation file" Button will only be activated if all needed fields are filled:
If not (Source = "" or AppName = "" or AppStdInstal = "" or AppStartMenu = "" or AppID = "" or AppVersion = "" or AppUpdateVersion = "" or (AppURLVersionComparison = "" and AppIncludeUpdater = 1))
   GuiControl, Enable, ButtonGenerateExe
else
   GuiControl, Disable, ButtonGenerateExe
Return




JumpOverMainGUILabels:
temp=

