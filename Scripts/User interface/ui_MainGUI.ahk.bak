ui_CreateMainGUI()
{
	global
	Gui, Add, Text, x10 y10,% lang("Sourcecode") ":"
	Gui, Add, Edit, x10 y30 w180 vSource ReadOnly,
	Gui, Add, Button, x195 y25 h30 w50 gOpenFile +default, % lang("Open")
	Gui, Add, Text, x10 y60, % lang("Application name")
	Gui, Add, Edit, x10 y80 w180 vAppName
	Gui, Add, GroupBox, x10 y110 w230 h283, 
	Gui, Add, Text, x15 y130, % lang("Abbreviation") ":"
	Gui, Add, Edit, x105 yp vAppNameShort,
	Gui, Add, Text, x15 yp+25, % lang("Long name") ":"
	Gui, Add, Edit, x105 yp vAppNameLong,
	Gui, Add, Text, x15 yp+25, % lang("Installation folder") ":"
	Gui, Add, Edit, x105 yp vAppFolder,
	Gui, Add, Text, x15 yp+30, % lang("Author") ":"
	Gui, Add, Edit, x105 yp vAppAuthorName,
	Gui, Add, Text, x15 yp+25, % lang("Email") ":"
	Gui, Add, Edit, x105 yp vAppAuthorEmail,
	Gui, Add, Text, x15 yp+30,% lang("Application version") ":"
	Gui, Add, Edit, x105 yp vAppVersion,
	Gui, Add, Text, x15 yp+25, % lang("Update Version") ":"
	Gui, Add, Edit, x105 yp vAppVersionForComparison,
	Gui, Add, Text, x15 yp+25, % lang("Update URL") ":"
	Gui, Add, Edit, x105 yp vAppURLVersionComparison,
	Gui, Add, Button, x55 yp+35 w100 h30 vButtonAdvancedInformations gButtonAdvancedInformations , % lang("Advanced")
	Gui, Add, Text, x260 y10, % lang("Associated files") ":"
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
	Gui, Add, Button, x10 y400 h30 vButtonGenerateExe gGenerate ,% lang("Generate installation file")
	Gui, Add, Checkbox, x160 yp+8 vCheckboxKeepRemainingFiles, % lang("Keep temporary files")
	GuiControl, Disable, ButtonGenerateExe
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
FileSelectFile, File, 3, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, % lang("Select sourcecode"), % lang("AutoHotKey scripts") " (*.ahk)"
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

;Try to load already existing settings
iniread,AppName,%App_Direction%\Settings.ini,BaseFrame,Appname,%a_space%
iniread,AppNameShort,%App_Direction%\Settings.ini,BaseFrame,AppNameShort,%a_space%
iniread,AppNameLong,%App_Direction%\Settings.ini,BaseFrame,AppNameLong,%a_space%
iniread,AppFolder,%App_Direction%\Settings.ini,BaseFrame,AppOrdner,%a_space%
iniread,AppAuthorName,%App_Direction%\Settings.ini,BaseFrame,AppAuthorName,%a_space%
iniread,AppAuthorEmail,%App_Direction%\Settings.ini,BaseFrame,AppAuthorEmail,%a_space%
iniread,AppVersion,%App_Direction%\Settings.ini,BaseFrame,AppVersion,%a_space%
iniread,AppVersionForComparison,%App_Direction%\Settings.ini,BaseFrame,AppGenaueVersion,%a_space%
iniread,AppURLVersionComparison,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion,%a_space%
iniread,AppURLVersionComparison2,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion2,%a_space%
iniread,AppURLVersionComparison3,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion3,%a_space%
iniread,AppChangeLog,%App_Direction%\Settings.ini,BaseFrame,AppChangelog,%a_space%

iniread,AppDirList,%App_Direction%\Settings.ini,BaseFrame,AppDirList,%a_space%
iniread,AppFileList,%App_Direction%\Settings.ini,BaseFrame,AppFileList,%a_space%
iniread,AppExeList,%App_Direction%\Settings.ini,BaseFrame,AppExeList,%a_space%
iniread,AppIconList,%App_Direction%\Settings.ini,BaseFrame,AppIconList,%a_space%

;If the settings are empty, assign some default values
if not AppAuthorName
	AppAuthorName:=A_UserName

if not AppFileName
	AppFileName:=App_FilenameNoExt

if not AppName
	AppName:=App_FilenameNoExt
	
if not AppVersion
	AppVersion=1.0	

if not AppVersionForComparison
	AppVersionForComparison=1.00.00


;Show loaded settings in gui
GuiControl,,AppName,%AppName%
GuiControl,,AppNameShort,%AppNameShort%
GuiControl,,AppNameLong,%AppNameLong%
GuiControl,,AppFolder,%AppFolder%
GuiControl,,AppAuthorName,%AppAuthorName%
GuiControl,,AppAuthorEmail,%AppAuthorEmail%
GuiControl,,AppVersion,%AppVersion%
GuiControl,,AppVersionForComparison,%AppVersionForComparison%
GuiControl,,AppURLVersionComparison,%AppURLVersionComparison%




;If the exe list is empty, add the three Base Frame Exes
if not AppExeList
	AppExeList=|%AppFileName%|Update Checker|
   
gosub,GuiListUpdate





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
   If (NewFile = "License.txt") {
         MsgBox, 64, % lang("Information"), % lang("The file %1% could not be added because it is the Default Licence file of the installer",NewFile)
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
insert1 := (AppDirList = "") ? "|<Keine>|" : AppDirList
insert2 := (AppFileList = "") ? "|<Keine>|" : AppFileList
insert3 := (AppExeList = "") ? "|<Keine>|" : AppExeList
GuiControl,, List, |
GuiControl,, List, --- %_Ordners_%: ---%insert1%%A_Tab%|--- %_Dateien_%: ---%insert2%%A_Tab%|--- %_Skripte_kompilieren_%: ---%insert3%|
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


;The "Generate installation file" Bitton will only be activated if all needed fields are filled:
If not (Source = "" or AppName = "" or AppNameShort = "" or AppNameLong = "" or AppFolder = "" or AppAuthorName = "" or AppAuthorEmail = "" or AppVersion = "" or AppVersionForComparison = "" or AppURLVersionComparison = "")
   GuiControl, Enable, ButtonGenerateExe
else
   GuiControl, Disable, ButtonGenerateExe
Return




JumpOverMainGUILabels:
temp=

