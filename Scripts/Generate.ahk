goto,jumpOverGenerateRoutines

;The generation subroutine generates three scripts and compiles them
Generate:

Gui, Submit, NoHide ;Get the entries from GUI
;Check again whether the needed entries are set
If (Source = "" or AppName = "" or AppNameShort = "" or AppNameLong = "" or AppFolder = "" or AppAuthorName = "" or AppAuthorEmail = "" or AppVersion = "" or AppVersionForComparison = "" or AppURLVersionComparison = "")
   Return

gui,hide ;Gui hide

SetTimer, Check, off ;set timer off

;Get installtion language ;TODO: It should be possible to select language during installation
AppInstallationLanguage:=%uilang%enlangname
;Get application license ; TODO: It should be possible to select the license
AppLicense=GPL
;Read License file
FileRead,LicenseShort,Licenses\GPL %AppInstallationLanguage% short.txt

;Set output direction (not useful yet)
OutputDirection=%App_Direction%
FileCreateDir,%OutputDirection% ;Create folder
FileDelete, %OutputDirection%\%App_FilenameNoExt% modified.ahk ;Delete old file


filecopy,Licenses\%AppLicense% %AppInstallationLanguage%.txt,%OutputDirection%\License.txt,1 ;copy license





;Save settings of that script

iniwrite,%AppName%,%App_Direction%\Settings.ini,BaseFrame,Appname
iniwrite,%AppNameShort%,%App_Direction%\Settings.ini,BaseFrame,AppNameShort
iniwrite,%AppNameLong%,%App_Direction%\Settings.ini,BaseFrame,AppNameLong
iniwrite,%AppFolder%,%App_Direction%\Settings.ini,BaseFrame,AppOrdner
iniwrite,%AppAuthorName%,%App_Direction%\Settings.ini,BaseFrame,AppAuthorName
iniwrite,%AppAuthorEmail%,%App_Direction%\Settings.ini,BaseFrame,AppAuthorEmail
iniwrite,%AppVersion%,%App_Direction%\Settings.ini,BaseFrame,AppVersion
iniwrite,%AppVersionForComparison%,%App_Direction%\Settings.ini,BaseFrame,AppGenaueVersion
iniwrite,%AppURLVersionComparison%,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion
iniwrite,%AppURLVersionComparison2%,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion2
iniwrite,%AppURLVersionComparison3%,%App_Direction%\Settings.ini,BaseFrame,AppUrlTxtVersion3
iniwrite,%AppChangeLog%,%App_Direction%\Settings.ini,BaseFrame,AppChangelog
iniwrite,%AppInstallationLanguage%,%App_Direction%\Settings.ini,BaseFrame,AppInstallationLanguage
iniwrite,%AppLicense%,%App_Direction%\Settings.ini,BaseFrame,AppLicense

iniwrite,%AppDirList%,%App_Direction%\Settings.ini,BaseFrame,AppDirList
iniwrite,%AppFileList%,%App_Direction%\Settings.ini,BaseFrame,AppFileList
iniwrite,%AppExeList%,%App_Direction%\Settings.ini,BaseFrame,AppExeList
iniwrite,%AppIconList%,%App_Direction%\Settings.ini,BaseFrame,AppIconList



;---Create the main application ahk---
; The code needs to be modified. In the beginning some new lines of code are added



FileRead, Code, %File% ;Read code from main ahk

stringreplace,Code,Code,BaseFrame_About: ;Remove the label if it is present. This label is present in the %Template_BeforeCode% 
;This label is made in order to allow the user to use the About window.




;In the very beginning add the template
Code_MainScript=
(
%Template_BeforeCode%
)



;Replace some placeholders according to the settings
stringreplace,Code_MainScript,Code_MainScript,_BASEFRAMEABOUTTEXT_,%LicenseShort%,a
stringreplace,Code_MainScript,Code_MainScript,_AppAuthorName_,%AppAuthorName%,a
stringreplace,Code_MainScript,Code_MainScript,_AppAuthorEmail_,%AppAuthorEmail%,a
stringreplace,Code_MainScript,Code_MainScript,_AppNameLong_,%AppNameLong%,a
stringreplace,Code_MainScript,Code_MainScript,_AppVersionToCompare_,%AppVersionForComparison%,a
stringreplace,Code_MainScript,Code_MainScript,_AppVersion_,%AppVersion%,a


;Now also add the normal code
Code_MainScript=
(
%Code_MainScript%

%Code%
)

;Write modified code to file
fileappend,%Code_MainScript%,%OutputDirection%\%App_FilenameNoExt% modified.ahk,utf-8





;---Create Update Checker.ahk.

FileDelete, %OutputDirection%\Update Checker.ahk ; Delete old file
FileRead,Code_UpdateChecker,Templates\Update Checker.ahk ;Read template file

;Add translations
;TODO allow multiple translations. Here is only the current UI language
Code_Translation:=GenerateTranslationString(Code_UpdateChecker,UILang)

;MsgBox %Code_Translation%

StringReplace,Code_UpdateChecker,Code_UpdateChecker,_Translations_in_Lang_function_,%Code_Translation%

;Replace some placeholders
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppUILang_,%uilang% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppVersion_,%AppVersion% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppVersionForComparison_,%AppVersionForComparison% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppName_,%AppName% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppNameLong_,%AppNameLong% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppFileNameNoExt_,%App_FilenameNoExt% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison_,%AppURLVersionComparison% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison2_,%AppURLVersionComparison2% ,a
stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison3_,%AppURLVersionComparison3% ,a
FileAppend, %Code_UpdateChecker%, %OutputDirection%\Update Checker.ahk,utf-8 ;Write file






;---Create installation file---
filedelete,%OutputDirection%\%App_FilenameNoExt% Installation.ahk ;Delete old file
FileRead,Code_Installer,Templates\App Installation.ahk ;Read template file

tempTextTheFileMayBeOpened:=lang("The File may be opened")
tempTextError:=lang("Error")
;Code generation: Loop through content of %AppFileList% and create the code for the installer
fcounter := 0
loop,parse,AppDirList,|
{
       
   if A_loopfield
   {
      fcounter++
      tempTextCreateFolderXY:=lang("Creating folder %1%",A_loopfield)
      tempTextFolderXYCouldNotBeCreated:=lang("Folder %1% could not be created",A_loopfield)
      InstallerCodeForFolders=
      (
      %InstallerCodeForFolders%
      FolderNumber%A_index%:
      Gui, Submit, NoHide
      GuiControl,, Log, [%fcounter%/`%fcounter`%] %tempTextCreateFolderXY%...``n`%Log`%
      filecreatedir,`%a_workingdir`%\%A_loopfield%
      if errorlevel=1
      {
          GuiControl,, Log, [%tempTextError%] %tempTextFolderXYCouldNotBeCreated%.``n`%Log`% 
          MsgBox, 6, %AppNameLong% v%AppVersion% Installer, %tempTextFolderXYCouldNotBeCreated%.
          ifmsgbox TryAgain
          {
              goto FolderNumber%A_index%
          }
          ifmsgbox Cancel
              exitapp
      }
      prc := Round(100 * (%fcounter%/fcounter))
      GuiControl,, Progress, `%prc`%
      GuiControl,, Percent, `%prc`%```%
      
      )
      
   }

}

;Code generation: Loop through content of %AppFileList% and create the code for the installer 
loop,parse,AppFileList,|
{
   
   if A_loopfield
   {
      fcounter++
      tempTextExtractFileXY:=lang("Extracting file %1%",A_loopfield)
      tempTextFileXYCouldNotBeExtracted:=lang("File %1% could not be extracted",A_loopfield)
      InstallerCodeForFiles=
      (
      %InstallerCodeForFiles%
      FileNumber%A_index%:
      Gui, Submit, NoHide
      GuiControl,, Log, [%fcounter%/`%fcounter`%] %tempTextExtractFileXY%...``n`%Log`%
      FileInstall,%A_loopfield%,`%a_workingdir`%\%A_loopfield%,1
      if errorlevel=1
      {
          GuiControl,, Log, [%tempTextError%] %tempTextFileXYCouldNotBeExtracted%.``n`%Log`% 
          MsgBox, 6, %AppNameLong% v%AppVersion% Installer, %tempTextFileXYCouldNotBeExtracted%. %tempTextTheFileMayBeOpened%.
          ifmsgbox TryAgain 
          {
              goto FileNumber%A_index%
          }
          ifmsgbox Cancel
              exitapp
      }
      prc := Round(100 * (%fcounter%/fcounter))
      GuiControl,, Progress, `%prc`%
      GuiControl,, Percent, `%prc`%```%
      
      )
   }

}

;Code generation: Add Licese.txt:
fcounter++
tempTextExtractFileXY:=lang("Extracting file %1%","License.txt")
tempTextFileXYCouldNotBeExtracted:=lang("File %1% could not be extracted","License.txt")

InstallerCodeForFiles=
(
%InstallerCodeForFiles%
ExtractLicenseFIle:
Gui, Submit, NoHide
GuiControl,, Log, [%fcounter%/`%fcounter`%] %tempTextExtractFileXY%...``n`%Log`%
FileInstall,License.txt,`%a_workingdir`%\License.txt,1
if errorlevel=1
{
	GuiControl,, Log, [Fehler] %tempTextFileXYCouldNotBeExtracted%.``n`%Log`% 
	MsgBox, 6, %AppNameLong% v%AppVersion% Installer, %tempTextFileXYCouldNotBeExtracted%. %tempTextTheFileMayBeOpened%.
	ifmsgbox TryAgain 
	{
	  goto ExtractLicenseFIle
	}
	ifmsgbox Cancel
		exitapp
}
prc := Round(100 * (%fcounter%/fcounter))
GuiControl,, Progress, `%prc`%
GuiControl,, Percent, `%prc`%```%

)

;Code generation: Code for exe files that will be included after compilation
loop,parse,AppExeList,|
{
   
   if A_loopfield
   {
      fcounter++
      tempTextExtractFileXY:=lang("Extracting file %1%",A_loopfield ".exe")
      tempTextFileXYCouldNotBeExtracted:=lang("File %1% could not be extracted",A_loopfield ".exe")
      
      InstallerCodeForFiles=
      (
      %InstallerCodeForFiles%
      ExeNr%A_index%:
      Gui, Submit, NoHide
      GuiControl,, Log, [%fcounter%/`%fcounter`%] %tempTextExtractFileXY%...``n`%Log`%
      FileInstall,%A_loopfield%.exe,`%a_workingdir`%\%A_loopfield%.exe,1
      if errorlevel=1
      {
          GuiControl,, Log, [Fehler] %tempTextFileXYCouldNotBeExtracted%.``n`%Log`%
          MsgBox, 6, %AppNameLong% v%AppVersion% Installer, %tempTextFileXYCouldNotBeExtracted%. %tempTextTheFileMayBeOpened%.
          ifmsgbox TryAgain 
          {
              goto ExeNr%A_index%
          }
          ifmsgbox Cancel
              exitapp
      }
      prc := Round(100 * (%fcounter%/fcounter))
      GuiControl,, Progress, `%prc`%
      GuiControl,, Percent, `%prc`%```%
      
      )
   }

}

;Code generation: GUI for installation status
tempTextDetails:=lang("Details")
tempTextInstallationStarted:=lang("Installation started")
tempTextInstaller:=lang("Installer")
InstallerCodeForInstallationGUI=
(
fcounter=%fcounter%
Gui -Caption +Border
Gui, Add, Progress, vProgress x10 y10 h15 w350 +Border c0000AA, 0
Gui, Add, Text, x10 y35, %tempTextDetails%:
Gui, Add, Text, x320 y35 w50 vPercent, 0```%
Gui, Add, Edit, vLog x10 y55 h75 w350 ReadOnly, %tempTextInstallationStarted%...
Gui, Show, w370 h140, %AppNameLong% v%AppVersion% %tempTextInstaller%
)





;Assemble the script
stringreplace,Code_Installer,Code_Installer,_AppShortLicenseDescription_,%ApShortLicenseDescription% ,a
stringreplace,Code_Installer,Code_Installer,_InstallFolders_,%InstallerCodeForFolders% ,a
stringreplace,Code_Installer,Code_Installer,_InstallFiles_,%InstallerCodeForFiles%,a
stringreplace,Code_Installer,Code_Installer,_GuiInstallationsStatus_,%InstallerCodeForInstallationGUI%


;Add translations
;TODO allow multiple translations. Here is only the current UI language
Code_Translation:=GenerateTranslationString(Code_Installer,UILang)

;MsgBox %Code_Translation%

StringReplace,Code_Installer,Code_Installer,_Translations_in_Lang_function_,%Code_Translation%

stringreplace,Code_Installer,Code_Installer,_BASEFRAMEABOUTTEXT_,%LicenseShort%,a
stringreplace,Code_Installer,Code_Installer,_AppUILang_,%uilang% ,a
stringreplace,Code_Installer,Code_Installer,_AppFileName_,%App_FilenameNoExt% ,a
stringreplace,Code_Installer,Code_Installer,_AppFolder_,%AppFolder% ,a
stringreplace,Code_Installer,Code_Installer,_AppNameLong_,%AppNameLong% ,a
stringreplace,Code_Installer,Code_Installer,_AppName_,%AppName% ,a
stringreplace,Code_Installer,Code_Installer,_AppVersion_,%AppVersion% ,a
stringreplace,Code_Installer,Code_Installer,_AppAuthorName_,%AppAuthorName% ,a
stringreplace,Code_Installer,Code_Installer,_AppAuthorEmail_,%AppAuthorEmail% ,a
stringreplace,Code_Installer,Code_Installer,_AppVersionForComparison_,%AppVersionForComparison% ,a
stringreplace,Code_Installer,Code_Installer,_AppChangelog_,%AppChangeLog% ,a
stringreplace,Code_Installer,Code_Installer,_AppLicense_,%AppLicense% ,a
stringreplace,Code_Installer,Code_Installer,_AppInstallationLanguage_,%ApInstallationLanguage% ,a


FileAppend, %Code_Installer%, %OutputDirection%\%App_FilenameNoExt% Installation.ahk,utf-8




;---Find out the path of the compiler---
SplitPath, A_AhkPath,,AHK_COMPILERdir
AHK_COMPILER := AHK_COMPILERdir "\Compiler\Ahk2Exe.exe"




;---Compile all files---
Loop,parse,AppExeList,|
{
   
   if a_loopfield ;Make sure, the parameter is not empty
   {
      ;If main application ahk itself will be compiled, leave it untouched
      If a_loopfield=%AppFileName%
         ToCompile=%a_loopfield% modified
      else
         ToCompile=%a_loopfield%
      ;icon Finden
      IconForThisExe:=FindIconAssignedToExe(a_loopfield)
      if IconForThisExe
      {
         ifinstring,IconForThisExe,:
            IconForThisExe=/icon "%IconForThisExe%"
         else
            IconForThisExe=/icon "%App_Direction%\%IconForThisExe%"
      }
      
      
      ;MsgBox %IconForThisExe% 
      TryAgainToCompileExe:
      SplashTexton,200,60,% lang("In progress"),%  lang("Compile %1%", ToCompile) 
      process,close,Ahk2Exe.exe ;If compiler is running, close ist
      run,%AHK_COMPILER% /in "%OutputDirection%\%ToCompile%.ahk" /out "%OutputDirection%\%ToCompile%.exe" %IconForThisExe% ;Call compiler
      process,waitclose,Ahk2Exe.exe,10 ;Wait until compiler has finished
      if errorlevel<>0 ;If compiler wont finish
      {
         SplashTextOff
         settimer,CheckWhetherCompilerHasFinishedAnyway,100  ;Check regulary whether the compiler finishes anyway
         MsgBox, 6,% lang("Attention"), % lang("The compiler needs very long to compile %1%.",ToCompile)
         ifmsgbox,Cancel
            ExitApp
         IfMsgBox, tryagain
            goto,TryAgainToCompileExe
      } 
      
      
   }
   
}

;Removie the "modified" from the compiled application
filemove,%OutputDirection%\%AppFileName% modified.exe,%OutputDirection%\%AppFileName%.exe,1 



;At last, compile installation file
IconForThisExe:=FindIconAssignedToExe(AppFileName) ;Find icon
if IconForThisExe
{
   ifinstring,IconForThisExe,:
      IconForThisExe=/icon "%IconForThisExe%"
   else
      IconForThisExe=/icon "%App_Direction%\%IconForThisExe%"
}
TryAgainToCompileInstalltionFile:
SplashTexton,200,60,% lang("In progress"),%  lang("Compile the installation file", ToCompile) 
process,close,Ahk2Exe.exe ;If compiler is running, close ist
run,%AHK_COMPILER% /in "%OutputDirection%\%AppFileName% Installation.ahk" /out "%OutputDirection%\%AppFileName% Installation.exe" %IconForThisExe% ;Call compiler
process,waitclose,Ahk2Exe.exe,10 ;Wait until compiler finishes
if errorlevel<>0 ;If compiler wont finish
{
   SplashTextOff
   settimer,CheckWhetherCompilerHasFinishedAnyway,100  ;Check regulary whether the compiler finishes anyway
   MsgBox, 6, % lang("Attention"), % lang("The compiler needs very long to compile %1%.",ToCompile)
   ifmsgbox,Cancel
      ExitApp
   IfMsgBox, tryagain
      goto,TryAgainToCompileInstalltionFile
}

;~ Gui, Submit, NoHide
If not CheckboxKeepRemainingFiles ;If the temporary file should be deleted
{
	;Delete temporary files
    FileDelete, %OutputDirection%\Update Checker.ahk
	FileDelete, %OutputDirection%\Update Checker.exe
	FileDelete, %OutputDirection%\%App_FilenameNoExt% Installation.ahk
	FileDelete, %OutputDirection%\%App_FilenameNoExt% modified.ahk 
	FileDelete, %OutputDirection%\%App_FilenameNoExt%.exe
}

splashtextoff






;When ready
ToolTip
if 1!=FastCompile ;Do not show the message box, if it was called by the shortcut
{
   MsgBox, 4, % lang("Finished"), % lang("Base Frame was appended to %1%.",AppName) "`n" lang("Do you want to create a shortcut for faster compilation?") 
   IfMsgBox,yes
   {
      FileCreateShortcut,%a_scriptfullpath% ,% App_Direction "\" AppName " " lang("Compile with Base Frame") ".lnk",,"FastCompile" "%App_Direction%\%AppFileName%.ahk" ;Create shortcut that tells Base Frame whitch file to compile
   }
}
ExitApp


CheckWhetherCompilerHasFinishedAnyway: ;If compiler needs very long, this code checks whether the compiler has finished anyway and if so, it closes the error message
process,exist,Ahk2Exe.exe
if errorlevel=0
{
   settimer,,off ;Stop timer
   controlsend,Button3,{space},% lang("Attention"), % lang("The compiler needs very long to compile %1%.",ToCompile) ;Close msgbox
}
return

jumpOverGenerateRoutines:
temp=

GenerateTranslationString(ahkFileContent,WhitchLanguage)
{
   ;Change uilang temporary
   global UILang
   tempoldUILang:=UILang
   UILang:=WhitchLanguage
   
   
   tempFoundPos=1
   returnCode=
   Loop ;Loop through all strings that may be translated in the file
   {
      ;Search for "lаng("...") and extract the string that will look like: to_translate"    or: I want translate into %1%"
      ;The found position is saved and on the next loop it will continue searching the next appearance
      tempFoundPos:=RegExMatch(ahkFileContent, "U)lang\(""(.+"")", tempVariablesToReplace,tempFoundPos +1)
      if tempFoundPos=0
         break
     
      TrayTip, %A_LoopFileFullPath% %tempFoundPos%
      ;Search for "
      StringGetPos,pos,tempVariablesToReplace1,"
      if pos
         StringLeft,tempVariablesToReplace1,tempVariablesToReplace1,%pos% ;get everything left to "
      else
      {
         MsgBox, error! could not exract the string that should be translated
         
      }
     
      TrayTip, %A_LoopFileFullPath% %tempFoundPos% %tempVariablesToReplace1%
      
      StringReplace,tempVariablesToReplace1,tempVariablesToReplace1,%a_space%,_,all ;Replace spaces by understrokes (if any)
      translatedString:=lang(tempVariablesToReplace1,`%$1`%,`%$2`%,`%$3`%,`%$4`%,`%$5`%,`%$6`%,`%$7`%,`%$8`%,`%$9`%) ;Call the lang() function in language.ahk
      returnCode.="if(langvar=""" tempVariablesToReplace1 """)`n   translated=" translatedString "`n" ;append the translation
   }
   UILang:=tempoldUILang ;Set uilang back
   
   ;Add an if statement
   returnCode=
   (
   if (UILang="%WhitchLanguage%")
   {
      %returnCode%
   }
   )
   return returnCode ;return the generated translations
}