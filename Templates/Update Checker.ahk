#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;~ #Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

modus=%1% ;Parameter in Variable. It may be "silent"





;Prepare some variables. They will be set during code generation
AppVersion=_AppVersion_
AppVersionForComparison=_AppVersionForComparison_
AppName=_AppName_
AppNameLong=_AppNameLong_
AppFileNameNoExt=_AppFileNameNoExt_
AppURLVersionComparison1:="_AppURLVersionComparison_"
AppURLVersionComparison2:="_AppURLVersionComparison2_"
AppURLVersionComparison3:="_AppURLVersionComparison3_"
UILang=_AppUILang_

if modus!=silent ;If silent do not show anything
	TrayTip,% lang("Update Checker for %1%",AppName) ,% lang("Downloading the update informations"),,1

FileDelete,%A_WorkingDir%\Online version.txt ;Delete old file

;Get the count of update info URLs
CountOfURLs=0
ifinstring, AppURLVersionComparison1,http
	CountOfURLs++
ifinstring, AppURLVersionComparison2,http
	CountOfURLs++
ifinstring, AppURLVersionComparison3,http
	CountOfURLs++

;Download the update information
TempGreatestAvailableVersion=0 ;This variable will contain the greatest available version. It may happen that if there are more than one urls for update informations, one of them is not updated anymore by the creator of the application.
if modus!=silent ;If not silent check all URLs
{
	loop %CountOfURLs%
	{
		TempDownloadURL:=AppURLVersionComparison%a_index%
		URLDownloadToFile,%TempDownloadURL%,%A_WorkingDir%\Online version.txt ;Download text file with update informations
		
		
		
		;Read txt file. If file is broken, the variables will contain "error"
		iniread,TempAvailableVersion,%A_WorkingDir%\Online version.txt,Update Info,Version,0 
		iniread,TempAppUpdateExe,%A_WorkingDir%\Online version.txt,Update Info,Download Path,error
		iniread,TempOpenWebsite,%A_WorkingDir%\Online version.txt,Update Info,Open Site,error
		;~ msgbox,%TempGreatestAvailableVersion%,%AppUpdateExe%
		
		if TempAvailableVersion<>error  ;If an available version is present
		{
			;~ msgbox
			ifinstring,TempAvailableVersion,. ;There must be a dot
			{
				;~ msgbox
				if (TempAvailableVersion>TempGreatestAvailableVersion) ;If avialable version is greater than the current version
				{
					TempGreatestAvailableVersion:=TempAvailableVersion ;Store the variables
					AppUpdateExe:=TempAppUpdateExe
					AppUpdateWebsite:=TempOpenWebsite
					
				}
				
				
			}
		}
		
		;~ msgbox,%TempGreatestAvailableVersion%`n%GrößteTempGreatestAvailableVersion%
		
	}
}
else ;If Silent only check a random one
{
	random,tempNumber,1,%CountOfURLs%
	TempDownloadURL:=AppURLVersionComparison%tempNumber%
	URLDownloadToFile,%TempDownloadURL%,%A_WorkingDir%\Online version.txt ;Download text file with download informations
	
	
	
	;Read txt file. If file is broken, the variables will contain "error"
	iniread,TempAvailableVersion,%A_WorkingDir%\Online version.txt,Update Info,Version,error 
	iniread,TempAppUpdateExe,%A_WorkingDir%\Online version.txt,Update Info,Download Path,error
	iniread,TempOpenWebsite,%A_WorkingDir%\Online version.txt,Update Info,Open Site,error
	;~ msgbox,%TempGreatestAvailableVersion%,%AppUpdateExe%
	
	if TempAvailableVersion<>error
	{
		ifinstring,TempAvailableVersion,.
		{
			TempGreatestAvailableVersion:=TempAvailableVersion
			AppUpdateExe:=TempAppUpdateExe
			AppUpdateWebsite:=TempOpenWebsite
			
			
		}
	}
	
}

TrayTip
if TempGreatestAvailableVersion=0
{
	if modus!=silent ;Do not show anything if no update information could be downloaded or evaluated
		msgbox,16, % lang("Update Checker for %1%",AppName) , % lang("An error occured while getting the update informations") ".`n" lang("Maybe you don't have internet connetion or the link that is stored in the application is corrupt") ".`n" lang("There might be an update available anyway") "."
	exitapp
}


FileDelete,%A_WorkingDir%\Online version.txt ;Delete this file because it is not needed anymore

If(TempGreatestAvailableVersion>AppVersionForComparison) ;If the avialable version is greater than the current
{

	
	MsgBox, 68, % lang("Update Checker for %1%",AppName),% lang("A new version is avialable!") ".`n" lang("Do you want to download it?") "`n`n" lang("Installed version") ": " AppVersionForComparison "`n" lang("Available version") ": " TempGreatestAvailableVersion
	
	IfMsgBox,yes ;If user agree
	{		
		
		
		if AppUpdateExe<>error ;If the download link was set in the text file
		{
			TrayTip,% lang("Update Checker for %1%",AppName),% lang("Downloading new version"),,1
			FileDelete,%A_WorkingDir%\%AppFileNameNoExt%_Installation.exe ;Delete old installation file (If any)
			URLDownloadToFile,%AppUpdateExe% ,%A_WorkingDir%\%AppFileNameNoExt% Installation.exe ;Download installation file
			
			if errorlevel=0 ;If download was successfull
			{
				TrayTip,% lang("Update Checker for %1%",AppName), % lang("Download successfull!") "`n" lang("Starting installation"),,1
				process,close,%AppFileNameNoExt%.exe ;close the application
				run,"%A_WorkingDir%\%AppFileNameNoExt% Installation.exe" ;Start the installation
			}
			else ;If download fails
			{
				if AppUpdateWebsite<>error ;If a website was inside
				{
					TrayTip,% lang("Update Checker for %1%",AppName), % lang("Download failed") "!`n" lang("Open webpage"),,3
					run, %AppUpdateWebsite% ;Webseite öffnen
				}
				else ;Wenn keine Seite drin steht, pech
				{
					Msgbox,0,% lang("Update Checker for %1%",AppName),% lang("Download failed") "! "  lang("Maybe you should try it later")
				}
			}
		}
		else ;If no download link was inside
		{
			if AppUpdateWebsite<>error ;If a website link is inside
			{
				run, %AppUpdateWebsite% ;Webseite öffnen
			}
			else ;If nothing inside. Tough!
			{
				msgbox,16,% lang("Update Checker for %1%",AppName), % lang("The update information does not contain informations about where to get the new version.") " " lang("Download of the update is not possible")
			}
		}
		
	}
	
}
Else ;If no new version is available
{
	
	if modus!=silent ;If silent do not show anything
		MsgBox, 0,% lang("Update Checker for %1%",AppName),% lang("No new version available.") "`n" lang("Current version") ": " AppVersionForComparison
	
}

ExitApp


lang(langvar,$1="",$2="",$3="",$4="",$5="",$6="",$7="",$8="",$9="")
{
	global UILang
	StringReplace,langvar,langvar,%a_space%,_,all
	
	;MsgBox %langvar%
	
	;All translations need to be inserted here
		;Translations are inserted during code generation as following: 
	;~ if (UILang="de") ;(In this example: German)
	;~ {
		;~ if langvar=to_translate
			;~ translated=Zu übersetzen 
	;~ }
	
	_Translations_in_Lang_function_
	
	
	
	
	
	return translated
}