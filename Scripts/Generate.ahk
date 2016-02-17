goto,jumpOverGenerateRoutines

;The generation subroutine generates three scripts and compiles them
Generate:

Gui, Submit, NoHide ;Get the entries from GUI
;Check again whether the needed entries are set
If (Source = "" or AppName = "" or AppStdInstal = "" or AppStartMenu = "" or AppID = "" or AppVersion = "" or AppUpdateVersion = "" or (AppURLVersionComparison = "" and AppIncludeUpdater = 1))
   Return

gui,hide ;Gui hide

SetTimer, Check, off ;set timer off




;Read License file


;Set output direction
NameOfTempFolder=Base Frame temp
OutputDirection=%App_Direction%\%NameOfTempFolder%
FileRemoveDir,%OutputDirection%,1 ;Delete folder
FileCreateDir,%OutputDirection% ;Create folder
;~ FileDelete, %App_Direction%\%App_FilenameNoExt% modified.ahk ;Delete old file

;Copy license file if a default one will be used
if AppOptionWhichLicense=1
{
   filecopy,Licenses\%AppLicense%_%AppLanguage%.txt,AHKSetup\LicenseForCurrentBuild.txt,1 ;copy license
}
else
{
   if DllCall("Shlwapi.dll\PathIsRelative","Str",AppCustomLicensePath)
   {
      filecopy,% App_Direction "\" AppCustomLicensePath,AHKSetup\LicenseForCurrentBuild.txt,1 ;copy license 
   }      
   else
   {
      filecopy,% AppCustomLicensePath,AHKSetup\LicenseForCurrentBuild.txt,1 ;copy license  
   }

}




;Save settings of that script

iniwrite,%AppName%,%App_Direction%\AppInfo.ini,AppInfo,Appname
iniwrite,%AppStdInstal%,%App_Direction%\AppInfo.ini,AppInfo,AppStdInstall
iniwrite,%AppStartMenu%,%App_Direction%\AppInfo.ini,AppInfo,AppStartMenu
iniwrite,%AppID%,%App_Direction%\AppInfo.ini,AppInfo,AppID
iniwrite,%AppAuthorName%,%App_Direction%\AppInfo.ini,AppInfo,AppAuthorName
iniwrite,%AppAuthorEmail%,%App_Direction%\AppInfo.ini,AppInfo,AppAuthorEmail
iniwrite,%AppVersion%,%App_Direction%\AppInfo.ini,AppInfo,AppVersion
iniwrite,%AppUpdateVersion%,%App_Direction%\AppInfo.ini,AppInfo,AppUpdateVersion

iniwrite,%AppIncludeUpdater%,%App_Direction%\AppInfo.ini,AppInfo,AppIncludeUpdater
iniwrite,%AppOptionCheckForUpdatesOnStartup%,%App_Direction%\AppInfo.ini,AppInfo,AppOptionCheckForUpdatesOnStartup
iniwrite,%AppURLVersionComparison%,%App_Direction%\AppInfo.ini,AppInfo,AppUrlTxtVersion
iniwrite,%AppURLVersionComparison2%,%App_Direction%\AppInfo.ini,AppInfo,AppUrlTxtVersion2
iniwrite,%AppURLVersionComparison3%,%App_Direction%\AppInfo.ini,AppInfo,AppUrlTxtVersion3
iniwrite,%AppCreateIniWithUpdateInformations%,%App_Direction%\AppInfo.ini,AppInfo,AppCreateIniWithUpdateInformations
iniwrite,%AppPathOfIniWithUpdateInformations%,%App_Direction%\AppInfo.ini,AppInfo,AppPathOfIniWithUpdateInformations
iniwrite,%AppURLInstaller%,%App_Direction%\AppInfo.ini,AppInfo,AppURLInstaller
iniwrite,%AppWebsite%,%App_Direction%\AppInfo.ini,AppInfo,AppWebsite

iniwrite,%AppChangelog%,%App_Direction%\AppInfo.ini,AppInfo,AppChangeLog

iniwrite,%AppOptionWhichLicense%,%App_Direction%\AppInfo.ini,AppInfo,AppOptionWhichLicense
iniwrite,%AppCustomLicensePath%,%App_Direction%\AppInfo.ini,AppInfo,AppCustomLicensePath
iniwrite,%AppLicense%,%App_Direction%\AppInfo.ini,AppInfo,AppLicense

iniwrite,%AppLanguage%,%App_Direction%\AppInfo.ini,AppInfo,AppLanguage
iniwrite,% AppPortability -1,%App_Direction%\AppInfo.ini,AppInfo,AppPortability

iniwrite,%AppDirList%,%App_Direction%\AppInfo.ini,AppInfo,AppDirList
iniwrite,%AppFileList%,%App_Direction%\AppInfo.ini,AppInfo,AppFileList
iniwrite,%AppExeList%,%App_Direction%\AppInfo.ini,AppInfo,AppExeList
iniwrite,%AppIconList%,%App_Direction%\AppInfo.ini,AppInfo,AppIconList



;---Create the main application ahk---
; The code of the main programm will be modified. In the beginning some new lines of code are added


FileRead, Code, %File% ;Read code from main ahk


;In the very beginning add the template
Code_MainScript=
(
%Template_BeforeCode%
)



;Replace some placeholders according to the settings
stringreplace,Code_MainScript,Code_MainScript,_BASEFRAMEABOUTTEXT_,%LicenseShort%,a ;TODO
stringreplace,Code_MainScript,Code_MainScript,_AppUpdateVersion_,%AppUpdateVersion%,a
stringreplace,Code_MainScript,Code_MainScript,_AppVersion_,%AppVersion%,a
if (AppIncludeUpdater and (AppOptionCheckForUpdatesOnStartup=1 or AppOptionCheckForUpdatesOnStartup=3))
   stringreplace,Code_MainScript,Code_MainScript,_AppCheckForUpates_,true,a
else
   stringreplace,Code_MainScript,Code_MainScript,_AppCheckForUpates_,false,a
if (AppIncludeUpdater=1 and AppOptionCheckForUpdatesOnStartup=3)
   stringreplace,Code_MainScript,Code_MainScript,_AppCheckForUpatesReadIni_,true,a
else
   stringreplace,Code_MainScript,Code_MainScript,_AppCheckForUpatesReadIni_,false,a
;~ MsgBox %Code_MainScript%

;Now also add the normal code
Code_MainScript=
(
%Code_MainScript%

%Code%
)

;Write modified code to file
FileDelete,%App_Direction%\%App_FilenameNoExt%_modified.ahk
fileappend,%Code_MainScript%,%App_Direction%\%App_FilenameNoExt%_modified.ahk,utf-8





;---Create Update Checker.ahk.
if AppIncludeUpdater
{
   ;~ FileDelete, %OutputDirection%\Update Checker.ahk ; Delete old file
   FileRead,Code_UpdateChecker,Templates\Update Checker.ahk ;Read template file

   ;Add translations
   ;TODO allow multiple translations.
   Code_Translation:=GenerateTranslationString(Code_UpdateChecker,AppLanguage)
   ;MsgBox %Code_Translation%
   StringReplace,Code_UpdateChecker,Code_UpdateChecker,_Translations_in_Lang_function_,%Code_Translation%

   ;Replace some placeholders
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppUILang_,%AppLanguage% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppVersion_,%AppVersion% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppUpdateVersion_,%AppUpdateVersion% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppName_,%AppName% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppFileNameNoExt_,%App_FilenameNoExt% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison_,%AppURLVersionComparison% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison2_,%AppURLVersionComparison2% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppURLVersionComparison3_,%AppURLVersionComparison3% ,a
   stringreplace,Code_UpdateChecker,Code_UpdateChecker,_AppWebsite_,%AppWebsite% ,a
   ;Write file
   FileAppend, %Code_UpdateChecker%, %OutputDirection%\Update Checker.ahk,utf-8
}


;Copy appinfo.ini to the temporary path. The build.exe needs it.
FileCopy,%App_Direction%\AppInfo.ini,%OutputDirection%\AppInfo.ini

;Copy changelog file to the temporary path.
if (fileexist(App_Direction "\" AppChangelog) and AppChangelog!="")
{
   FileRead,AppChangelogText,%App_Direction%\%AppChangelog%
   FileCopy,%App_Direction%\%AppChangelog%,%OutputDirection%\%AppChangelog%
}

;---Find out the path of the compiler---
SplitPath, A_AhkPath,,AHK_COMPILERdir
AHK_COMPILER := AHK_COMPILERdir "\Compiler\Ahk2Exe.exe"


;Create all folders in the temporary path
Loop,parse,AppDirList,|
{
   if a_loopfield ;Make sure, the parameter is not empty
   {
      FileCreateDir,%OutputDirection%\%A_LoopField%
   }
}

;Copy all files
Loop,parse,AppFileList,|
{
   if a_loopfield ;Make sure, the parameter is not empty
   {
      FileCopy,%App_Direction%\%A_LoopField%,%OutputDirection%\%A_LoopField%
   }
}

;---Compile all files---
Loop,parse,AppExeList,|
{
   
   if a_loopfield ;Make sure, the parameter is not empty
   {
      ToCompile=%a_loopfield%
      
      ;application ahk and update checker are already in the temporary folder
      ToCompile_Add:=""
      If (ToCompile="Update Checker")
      {
         SubfolderOfCurrentAHK:=NameOfTempFolder "\"
      }
      else If (ToCompile=AppFileName or ToCompile="Update Checker")
      {
         ToCompile_Add:="_modified"
         SubfolderOfCurrentAHK=
      }
      else
      {
         SubfolderOfCurrentAHK=
      }
      
      ;Find icon
      IconForThisExe:=FindIconAssignedToExe(ToCompile)
      if IconForThisExe
      {
         ifinstring,IconForThisExe,:
            IconForThisExe=/icon "%IconForThisExe%"
         else
            IconForThisExe=/icon "%App_Direction%\%IconForThisExe%"
      }
      
      
      ;Compile the ahk to exe
      TryAgainToCompileExe:
      SplashTexton,200,60,% lang("In progress"),%  lang("Compile %1%", ToCompile) 
      process,close,Ahk2Exe.exe ;If compiler is running, close ist
      run,%AHK_COMPILER% /in "%App_Direction%\%SubfolderOfCurrentAHK%%ToCompile%%ToCompile_Add%.ahk" /out "%OutputDirection%\%ToCompile%.exe" %IconForThisExe% ;Call compiler
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
      
      ;Delete ahk file from temporary folder
      if (SubfolderOfCurrentAHK=NameOfTempFolder "\")
      {
         FileDelete,%App_Direction%\%SubfolderOfCurrentAHK%%ToCompile%.ahk
      }
      
   }
   
}
;~ FileMove,%OutputDirection%\%AppFileName%_modified.exe,%OutputDirection%\%AppFileName%.exe

;---Create installation file---

;~ SplashTexton,200,60,% lang("In progress"),%  lang("Create installation file") 
SplashTextOff

q="
build_source := OutputDirection "\" AppFileName ".exe"

build_license := A_ScriptDir "\AHKSetup\LicenseForCurrentBuild.txt"

build_dest := App_Direction "\" AppFileName " Setup.exe" 
build_lang := AppLanguage
build_single := ""

build_cmd := "AHKSetup\build.exe " . q . build_source . q . " " . ((build_license == "-gnu_gpl") ? "" : "-li ") . q . build_license . q . " " . ((build_dest == "") ? "" : "-d ") . q . build_dest . q . " " . ((build_lang == "") ? "" : "-lang ") . q . build_lang . q . " " . q . build_single . q
;~ MsgBox %build_cmd%
RunWait, %comspec% /c " %build_cmd% && exit",,max

;~ run,AHKSetup\log.txt


;~ Gui, Submit, NoHide
If not CheckboxKeepRemainingFiles ;If the temporary file should be deleted
{
	;Delete temporary files
    FileDelete,% App_Direction "\" AppFileName "_modified.ahk" 
	FileRemoveDir, %OutputDirection%,1
}

splashtextoff






;When ready
ToolTip

;Create ini file with update informations (if chosen)
if (AppCreateIniWithUpdateInformations and AppPathOfIniWithUpdateInformations!="")
{
   if DllCall("Shlwapi.dll\PathIsRelative","Str",AppCustomLicensePath)
      tempIniPath:=App_Direction "\" AppPathOfIniWithUpdateInformations
   else
      tempIniPath:=AppPathOfIniWithUpdateInformations
   FileDelete,%tempIniPath%
   FileAppend,[Update Info]`n,%tempIniPath%,UTF-16
   
   iniwrite,%AppUpdateVersion%,%tempIniPath%,Update Info,Version
   if (AppURLInstaller!="")
      iniwrite,%AppURLInstaller%,%tempIniPath%,Update Info,Download Path
   if (AppWebsite!="")
      iniwrite,%AppWebsite%,%tempIniPath%,Update Info,Open Site
   if (AppChangeLogText!="")
   {
      StringReplace,AppChangelogTextToINI,AppChangeLogText,`n,↓,all
      StringReplace,AppChangelogTextToINI,AppChangelogTextToINI,`t,→,all
      StringReplace,AppChangelogTextToINI,AppChangelogTextToINI,`r,,all
      iniwrite,%AppChangelogTextToINI%,%tempIniPath%,Update Info,Changelog
   }
}

;Create shortcut in the sourcecode path if user wants
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

GenerateTranslationString(ahkFileContent,WhichLanguage)
{
   ;Change uilang temporary
   global UILang
   tempoldUILang:=UILang
   UILang:=WhichLanguage
   
   
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
   if (UILang="%WhichLanguage%")
   {
      %returnCode%
   }
   )
   return returnCode ;return the generated translations
}