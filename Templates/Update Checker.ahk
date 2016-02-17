#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;~ #Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, off

modus=%1% ;Parameter in Variable. It may be "silent"


;If in silent mode. Search for a hidden window of an already existing instance of update checker. 
if modus=silent
{
	DetectHiddenWindows on
	IfWinExist,#%A_ScriptFullPath%#,#%A_ScriptFullPath%#
		ExitApp
}

;create hidden window for other instances of update checker
gui,hidden:add, text,,#%A_ScriptFullPath%#
gui,hidden:show,hide,#%A_ScriptFullPath%#

;Prepare some variables. They will be set during code generation
AppVersion=_AppVersion_
AppUpdateVersion=_AppUpdateVersion_
AppName=_AppName_
AppFileNameNoExt=_AppFileNameNoExt_
AppURLVersionComparison1:="_AppURLVersionComparison_"
AppURLVersionComparison2:="_AppURLVersionComparison2_"
AppURLVersionComparison3:="_AppURLVersionComparison3_"
UILang=_AppUILang_
AppWebsite=_AppWebsite_

FileDelete,%A_Temp%\Online version.txt ;Delete old file

;Get the count of update info URLs
CountOfURLs=0
ifinstring, AppURLVersionComparison1,http
	CountOfURLs++
ifinstring, AppURLVersionComparison2,http
	CountOfURLs++
ifinstring, AppURLVersionComparison3,http
	CountOfURLs++

;Build GUI
gui,margin,10
gui,font,s16
gui,add,text,w480 h30 x10 vGUITitle,% AppName " - " AppUpdateVersion " - " lang("Update Checker")
gui,font,s12
gui,add,text,w480 h100 x10 vGUIText, % lang("Downloading the update informations")
gui,font,s8
gui,add,text,w480 x10 vGUISmallText
gui,add,edit,w480 h100 x10 readonly vGUIEdit
gui,font,s12
gui,add,button,w150 h50 x10 disabled vButtonDownloadUpdate gButtonDownloadUpdate,% lang("Download new version")
gui,add,button,w150 h50 X+10 disabled vButtonOpenWebsite gButtonOpenWebsite,% lang("Open website")
gui,add,button,w150 h50 X+10 vButtonClose gButtonClose default,% lang("Close")

guicontrol,focus,ButtonClose

if AppWebsite
{
	guicontrol,enable,ButtonOpenWebsite
	guicontrol,focus,ButtonOpenWebsite
}

;Download the update information
AppUpdateNewVersion=0 ;This variable will contain the greatest available version. It may happen that if there are more than one urls for update informations, one of them is not updated anymore by the creator of the application.
if modus!=silent ;If not silent check all URLs
{
	
	gui,show
	
	loop %CountOfURLs%
	{
		
		TempDownloadURL:=AppURLVersionComparison%a_index%
		GUIEdit.=lang("Link %1%",a_index)
		guicontrol,,GUIEdit,%GUIEdit%
		sleep,10
		URLDownloadToFile,%TempDownloadURL%,%A_Temp%\Online version.txt ;Download text file with update informations
		
		
		
		;Read txt file. If file is broken, the variables will contain "error"
		iniread,TempAvailableVersion,%A_Temp%\Online version.txt,Update Info,Version,error 
		iniread,TempAppUpdateExe,%A_Temp%\Online version.txt,Update Info,Download Path,error
		iniread,TempOpenWebsite,%A_Temp%\Online version.txt,Update Info,Open Site,error
		iniread,TempChangelog,%A_Temp%\Online version.txt,Update Info,Changelog,%a_space%
		;~ msgbox,%AppUpdateNewVersion%,%AppUpdateExe%
		
		if TempAvailableVersion<>error  ;If an available version is present
		{
			GUIEdit.=" - " lang("Found version: %1%",TempAvailableVersion) "`n"
			;~ msgbox
			;~ ifinstring,TempAvailableVersion,. ;There must be a dot
			;~ {
				;~ msgbox
				if (TempAvailableVersion>AppUpdateNewVersion) ;If avialable version is greater than the current version
				{
					AppUpdateNewVersion:=TempAvailableVersion ;Store the variables
					AppUpdateExe:=TempAppUpdateExe
					AppUpdateWebsite:=TempOpenWebsite
					AppUpdateChangelog:=TempChangelog
					
				}
				
			;~ }
		}
		else
		{
			GUIEdit.=" - " lang("Error") "`n"
		}
		
		
	}
	
	
	
}
else ;If Silent only check a random one
{
	random,tempNumber,1,%CountOfURLs%
	TempDownloadURL:=AppURLVersionComparison%tempNumber%
	URLDownloadToFile,%TempDownloadURL%,%A_Temp%\Online version.txt ;Download text file with download informations
	
	
	
	;Read txt file. If file is broken, the variables will contain "error"
	iniread,TempAvailableVersion,%A_Temp%\Online version.txt,Update Info,Version,error 
	iniread,TempAppUpdateExe,%A_Temp%\Online version.txt,Update Info,Download Path,error
	iniread,TempOpenWebsite,%A_Temp%\Online version.txt,Update Info,Open Site,error
	iniread,TempChangelog,%A_Temp%\Online version.txt,Update Info,Changelog,%a_space%
	;~ msgbox,%AppUpdateNewVersion%,%AppUpdateExe%
	
	if TempAvailableVersion<>error
	{
		ifinstring,TempAvailableVersion,.
		{
			AppUpdateNewVersion:=TempAvailableVersion
			AppUpdateExe:=TempAppUpdateExe
			AppUpdateWebsite:=TempOpenWebsite
			AppUpdateChangelog:=TempChangelog
			
		}
	}
	
}

;If a changelog is available, retrieve the relevant part of changelog. All entries older than the current installed versions will be removed.
if AppUpdateChangelog
{
	StringReplace,AppUpdateChangelog,AppUpdateChangelog,↓,`n,all
	StringReplace,AppUpdateChangelog,AppUpdateChangelog,→,`t,all
	StringGetPos,temppos,AppUpdateChangelog,%AppUpdateVersion%
	if temppos>=0
	{
		stringleft,AppUpdateChangelog,AppUpdateChangelog,%temppos%
		stringgetpos,temppos,AppUpdateChangelog,`n,R
		if temppos>=0
			stringleft,AppUpdateChangelog,AppUpdateChangelog,%temppos%
	}
}



guicontrol,,GUIEdit,%GUIEdit%


if AppUpdateNewVersion=0
{
	if modus!=silent ;Do not show anything if no update information could be downloaded or evaluated
	{
		guicontrol,,GUIText,% lang("An error occured while getting the update informations") ".`n" lang("Maybe you don't have internet connetion or the link that is stored in the application is corrupt") ".`n" lang("There might be an update available anyway") "."
		if AppUpdateWebsite<>error ;If a website link is inside
		{
			guicontrol,enable,ButtonOpenWebsite
			guicontrol,focus,ButtonOpenWebsite
		}
		;~ msgbox,16, % lang("Update Checker for %1%",AppName) , % lang("An error occured while getting the update informations") ".`n" lang("Maybe you don't have internet connetion or the link that is stored in the application is corrupt") ".`n" lang("There might be an update available anyway") "."
	}
	else
		ExitApp
	return
}




If(AppUpdateNewVersion>AppUpdateVersion) ;If the avialable version is greater than the current
{
	SetTimer,showChangelog,1000
	
	if AppUpdateWebsite<>error
	{
		guicontrol,,GUIText,% lang("A new version is avialable!") ".`n" lang("Do you want to download it?") "`n" lang("Available version") ": " AppUpdateNewVersion
		guicontrol,enable,ButtonDownloadUpdate
		guicontrol,focus,ButtonDownloadUpdate
		
		if AppUpdateWebsite<>error ;If a website link is inside
		{
			guicontrol,enable,ButtonOpenWebsite
		}
	}
	else if AppUpdateWebsite<>error ;If a website link is inside
	{
		guicontrol,,GUIText,% lang("A new version is avialable!") ".`n" lang("Available version") ": " AppUpdateNewVersion "`n" lang("No download link available")
		guicontrol,enable,ButtonOpenWebsite
		guicontrol,focus,ButtonOpenWebsite
	}
	else
	{
		guicontrol,,GUIText,% lang("A new version is avialable!") ".`n" lang("Available version") ": " AppUpdateNewVersion "`n" lang("No download link available") "`n" lang("No website link available")  
		
	}
	
	
	gui,show
	
	;~ MsgBox, 68, % lang("Update Checker for %1%",AppName),% lang("A new version is avialable!") ".`n" lang("Do you want to download it?") "`n`n" lang("Installed version") ": " AppUpdateVersion "`n" lang("Available version") ": " AppUpdateNewVersion
	
	
	
}
Else ;If no new version is available
{
	
	if modus!=silent ;If silent do not show anything
	{
		guicontrol,,GUIText,% lang("No new version available.")
		if AppUpdateWebsite<>error ;If a website link is inside
		{
			guicontrol,enable,ButtonOpenWebsite
			guicontrol,focus,ButtonOpenWebsite
		}
		
		;MsgBox, 0,% lang("Update Checker for %1%",AppName),% lang("No new version available.") "`n" lang("Current version") ": " AppUpdateVersion
	}
	else
		ExitApp
}

return


showChangelog:
	guicontrol,,GUISmallText,% lang("Changelog")
	guicontrol,,GUIEdit,% AppUpdateChangelog

return


ButtonOpenWebsite:
if AppUpdateWebsite
	run, %AppUpdateWebsite% ;Webseite öffnen
else
	run, %AppWebsite% ;Webseite öffnen
return


ButtonDownloadUpdate:
if AppUpdateExe<>error ;If the download link was set in the text file
{
	;~ TrayTip,% lang("Update Checker for %1%",AppName),% lang("Downloading new version"),,1
	guicontrol,disable,ButtonDownloadUpdate
	guicontrol,,GUIText,% lang("Downloading new version...")
	FileDelete,%A_Temp%\%AppFileNameNoExt% Setup.exe ;Delete old installation file (If any)
	URLDownloadToFile,%AppUpdateExe% ,%A_Temp%\%AppFileNameNoExt% Setup.exe ;Download installation file
	
	if errorlevel=0 ;If download was successfull
	{
		;~ TrayTip,% lang("Update Checker for %1%",AppName), % lang("Download successfull!") "`n" lang("Starting installation"),,1
		;process,close,%AppFileNameNoExt%.exe ;close the application
		guicontrol,,GUIText,% lang("Download successfull!") "`n" lang("Starting installation")
		sleep,500
		run,"%A_Temp%\%AppFileNameNoExt% Setup.exe" ;Start the installation
		sleep,1000
		ExitApp
	}
	else ;If download fails
	{
		guicontrol,enable,ButtonDownloadUpdate
		guicontrol,,GUIText,% lang("Download failed") "! "  lang("Maybe you should try it again")
		
	}
}


return

GuiClose:
ButtonClose:
FileDelete,%A_Temp%\Online version.txt ;Delete this file because it is not needed anymore
ExitApp
return


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