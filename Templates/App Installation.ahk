SetWorkingDir,%a_scriptdir%

UILang=_AppUILang_

AboutText=
(
_BASEFRAMEABOUTTEXT_
)

Gui, Add,edit, vAboutText  readonly, %AboutText%


Gui, Add,text,,% lang("Do you agree the license terms?")
Gui, Add, Button, gLicenseButtonIAgree   w100 h30 , % lang("Yes, I agree")
Gui, Add, Button, vLicenseButtonNo gLicenseButtonNo +default yp xp+110 w100 h30 , % lang("No")
Gui, Add, Button, gLicenseButtonShowLicense yp xp+110 w100 h30 , % lang("Show license")
gui, add, button, gLicenseButtonChangelog yp X+10 w100 h30, % lang("Changelog")
Gui, Show,, % lang("License terms")




guicontrol,focus,LicenseButtonNo
return

LicenseButtonNo:
GuiClose:
ExitApp
return

LicenseButtonShowLicense:
fileinstall,License.txt,%A_Temp%\License.txt,1
run,%A_Temp%\License.txt
return

LicenseButtonChangelog:
gui, +Disabled
gui, 2:default
gui, +alwaysontop
gui,add,edit,x10 y10 w300 h200 readonly,_AppChangelog_
gui,add,button, x100 Y+10 w100 h30 +default vLicense2ButtonOK gLicense2ButtonOK, % lang("OK")
gui,show,,Changelog

guicontrol,focus,License2ButtonOK
return

License2ButtonOK:
gui,destroy
gui 1:default
gui, -disabled
sleep,100
gui show
return



LicenseButtonIAgree:
filedelete,%A_Temp%\License.txt ;We don't spam the computer :-)
gui,destroy



;Search for the already installed appliction. If it is found, it will update
FileExistInSubfolder:=fileexist("_AppFolder_\_AppFileName_.exe") ;Check whether the application is in the subfolder
if FileExistInSubfolder<> ;If file exists, install in subfolder
   WhetherToInstallInSubfolder=true

FileExistInFolder:=fileexist("_AppFileName_.exe") ;check whether the file is insithe the current folder


;Now whe know whether we want to install in the current folder or in the subfolder
if (FileExistInSubfolder="" and FileExistInFolder="")
{
   WhetherToInstallInSubfolder=true ;If new install (no update), install in subfolder

   MsgBox, 1,%  "_AppNameLong_ v_AppVersion_ " lang("Installer"),%  lang("This installer installs %1% in the folder %2%.", "_AppName_", "_AppFolder_" ) "`n`n" lang("If you already use %1% and you want to update your version, then move the installer into tha folder of %1% and run it again.","_AppName_") "`n`n" lang("If you want to install %1% the first time, then click on OK." ,"_AppName_")
}
Else
   MsgBox, 1,%  "_AppNameLong_ v_AppVersion_ " lang("Installer"), % lang("This installer will update %1% to the version %2%.","_AppName_", "_AppVersionForComparison_") "`n" lang("Click on OK to continue.")

IfMsgBox,cancel
exitapp


_GuiInstallationsStatus_


if WhetherToInstallInSubfolder=true
{

   filecreatedir,%a_workingdir%\_AppFolder_ ;Create subfolder (necessary for first install)
   SetWorkingDir,%a_workingdir%\_AppFolder_ ;Change working path
}


_InstallFolders_

_InstallFiles_




MsgBox, 0, %  "_AppNameLong_ v_AppVersion_ " lang("Installer"), % lang("Installation successfull!") "`n" lang("If Windows notifies you that the application was not installed properly, ignore it.")



exitapp



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