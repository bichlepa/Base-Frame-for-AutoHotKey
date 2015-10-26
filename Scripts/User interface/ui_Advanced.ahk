goto,jumpOverAdvancedSettingsRoutines




ButtonAdvancedInformations:
gui,hide

Gui, 3:Default
;Define some default positions
xg=20 ;Left Position of groubpoxes
x1=25 ;Left position of a control
x1_=45 ;Left position of a slightly moved control
x2=125 ;Middle position of a control
x3=225 ;Right position of a control
yg=40 ;Topmost position of a groupbox
y1=40 ;Topmost position of a control

w=400 ;Maximum width of a control
w1=90 ;Width of small controls
w2=190 ;Width of middle controls
w3=290 ;Width of large controls
wg=420 ;Width of a group box

wtab:=w+40
htab:=500
yButton:=500+15
gui,add,tab2,w%wtab% h%htab% ,% lang("Installer") "|" lang("Update checker") "|" lang("License") "|" lang("Changelog")

gui,tab,1 ;Installer section

Gui, Add, GroupBox, x%xg% y%yg% w%wg% h53,  % lang("Installer language")
Gui, Add, Text, x%x1% yp+25 , % lang("Select installer language") 
AllInstallerLanugages:=""
for tempkey, tempval in allLangs ;make List of all languages
{
	AllInstallerLanugages.=tempval "|"
	
}
gui, add, DropDownList, x%x3% yp vAppLanguage, %AllInstallerLanugages%
guicontrol,choose,AppLanguage,% AppLanguage


Gui, Add, GroupBox, x%xg% yp+40 w%wg% h83,  % lang("Installation type")
Gui, Add, Radio, x%x1% yp+25 vAppPortability1 gAdvancedSettingsDisableUnusedButtons, % lang("Only allow normal installation")
Gui, Add, Radio, x%x1% Y+5 vAppPortability2 gAdvancedSettingsDisableUnusedButtons, % lang("Only extract files to a folder (portable installation)")
Gui, Add, Radio, x%x1% Y+5 vAppPortability3 gAdvancedSettingsDisableUnusedButtons, % lang("Allow both")
if not AppPortability
	AppPortability=1
guicontrol,, AppPortability%AppPortability%,1


gui,tab,2 ;Updater Section

Gui, Add, Checkbox, x%x1% y%y1% vAppIncludeUpdater gAdvancedSettingsDisableUnusedButtons checked%AppIncludeUpdater%, % lang("Include update checker")

Gui, Add, GroupBox, x%xg% Y+10 w%wg% h130 section,  % lang("Behaviour")
Gui, Add, Radio, x%x1% yp+25 vAppOptionCheckForUpdatesOnStartup1 gAdvancedSettingsDisableUnusedButtons, % lang("Automatically check for updates on every startup of main application")
Gui, Add, Radio, x%x1% Y+5 vAppOptionCheckForUpdatesOnStartup2 gAdvancedSettingsDisableUnusedButtons, % lang("Do not automatically check for updates")
Gui, Add, Radio, x%x1% Y+5 vAppOptionCheckForUpdatesOnStartup3 gAdvancedSettingsDisableUnusedButtons, % lang("Only if following entry in an ini file contains 1")
if not AppOptionCheckForUpdatesOnStartup
	AppOptionCheckForUpdatesOnStartup=1
guicontrol,, AppOptionCheckForUpdatesOnStartup%AppOptionCheckForUpdatesOnStartup%,1
Gui, Add, text, x%x1_% Y+5 w150 ,% lang("File path")
Gui, Add, text, X+10 yp w90 ,% lang("Section")
Gui, Add, text, X+10 yp w90 ,% lang("Key")
Gui, Add, Edit, x%x1_% Y+5 w150 r1 vAppAutomaticUpdateIniFile,%AppAutomaticUpdateIniFile%
Gui, Add, Edit, X+10 yp w100 r1 vAppAutomaticUpdateIniSection,%AppAutomaticUpdateIniSection%
Gui, Add, Edit, X+10 yp w100 r1 vAppAutomaticUpdateIniKey,%AppAutomaticUpdateIniKey%


Gui, Add, GroupBox, x%xg% Y+20 w%wg% h110,  % lang("Download URL for update information")
Gui, Add, Text, x%x1% yp+25 , % lang("Update URL") " (" lang("needed") ")"
Gui, Add, Edit, x%x3% yp w%w2% vAppURLVersionComparison r1,%AppURLVersionComparison%
Gui, Add, Text, x%x1% Y+5,% lang("Update URL") " 2 (" lang("optional") ")"
Gui, Add, Edit, x%x3% yp w%w2% vAppURLVersionComparison2 r1,%AppURLVersionComparison2%
Gui, Add, Text, x%x1% Y+5, % lang("Update URL") " 3 (" lang("optional") ")"
Gui, Add, Edit, x%x3% yp w%w2% vAppURLVersionComparison3 r1,%AppURLVersionComparison3%

Gui, Add, GroupBox, x%xg% Y+20 w%wg% h150, % lang("Ini file with update information")
Gui, Add, Checkbox, x%x1% yp+25 vAppCreateIniWithUpdateInformations gAdvancedSettingsDisableUnusedButtons checked%AppCreateIniWithUpdateInformations%, % lang("Create ini file after generation")

Gui, Add, Text, x%x1% yp+25 , % lang("Destination path for ini file")
w:=w2-30
Gui, Add, Edit, x%x3% yp w%w% vAppPathOfIniWithUpdateInformations r1,%AppPathOfIniWithUpdateInformations%
gui,add,button,X+5 yp vButtonSelectIniPath g3ButtonSelectIniPath, ...
Gui, Add, Text, x%x1% Y+10 , % lang("Installer URL")
Gui, Add, Edit, x%x3% yp w%w2% vAppURLInstaller r1,%AppURLInstaller%
Gui, Add, Text, x%x1% Y+5 , % lang("Project website")
Gui, Add, Edit, x%x3% yp w%w2% vAppWebsite r1,%AppWebsite%


gui,tab,3 ;License section
Gui, Add, GroupBox,  x%xg% y%yg% w%wg% h100,  % lang("License")
Gui, Add, Radio, x%x1% yp+25 vAppOptionWhichLicense1 gAdvancedSettingsDisableUnusedButtons, % lang("Include following license")
Gui, Add, Radio, x%x1% yp+40 vAppOptionWhichLicense2 gAdvancedSettingsDisableUnusedButtons, % lang("Use own license text")
if not AppOptionWhichLicense
	AppOptionWhichLicense=1
guicontrol,, AppOptionWhichLicense%AppOptionWhichLicense%,1

;~ Gui, Add, Text, x%x1_% yp+35 , % lang("Select license") 

;Find avaliable licenses
allLicenses:=""
loop,licenses\*.txt
{
	
	StringTrimRight,tempFileNameNoExt,a_loopfilename,4
	StringRight,tempFileNameLanguageCode,tempFileNameNoExt,2
	tempfound:=false
	for tempkey, tempval in allLangs
	{
		;~ MsgBox %tempkey% %tempval% %tempFileNameLanguageCode%
		if (tempval=tempFileNameLanguageCode)
		{
			tempfound:=true
		}
	}
	if tempfound
	{
		StringTrimRight,tempFileNameNoExt,tempFileNameNoExt,3
		If (allLicenses = "")
			allLicenses=|%tempFileNameNoExt%|
		else {
			IfNotInString, allLicenses, |%tempFileNameNoExt%|
			allLicenses=%allLicenses%%tempFileNameNoExt%|
		}
	}
}
StringTrimLeft,allLicenses,allLicenses,1

x:=x3-20
gui, add, DropDownList, x%x% yp-40 vAppLicense w%w2%, %allLicenses%
guicontrol,choose,AppLicense,% AppLicense
gui,add,edit,xp yp+40 w%w2% vAppCustomLicensePath r1,%AppCustomLicensePath% 
gui,add,button,X+5 yp vButtonSelectCustomLicense g3ButtonSelectCustomLicense, ...


gui,tab,4 ;Changelog section

Gui, Add, GroupBox, x%xg% y%yg% w%wg% h293,  % lang("Changelog")
;~ stringreplace,AppChangeLogTextToShow,AppChangeLogText,``n,`n,all ;Fix linefeeds

Gui, Add, Text, x%x1% yp+25 , % lang("File containing changelog")
x:=x3-20
gui,add,edit,x%x% yp vAppChangelog g3AppChangelogChanged w%w2%  r1,%AppChangelog%
gui,add,button,X+5 yp vButtonSelectChangelog g3ButtonSelectChangelog, ...
gui,add,text,x%x1% Y+10,% lang("You can edit the changelog here")
Gui, Add, Edit, x%x1% Y+5 w400 h180 vAppChangeLogText,%AppChangeLogTextToShow%
gui, add, Button, x%x1% Y+5 w195 g3ButtonAddEntry vButtonAddEntry, % lang("Add entry")


gui,tab ;Buttons for all sections

gui, add, Button, x%xg% y%yButton% w150 h30 v3ok g3OK +default, % lang("OK")
gui, add, button, X+10 yp w150 h30 g3Cancel, % lang("Cancel")

guicontrol,focus,3ok
gosub,3AppChangelogChanged
gosub,AdvancedSettingsDisableUnusedButtons
gui,show,,% lang("Advanced settings")
return

3OK:
gui,submit
loop 3
{
	if AppOptionCheckForUpdatesOnStartup%a_index%
		AppOptionCheckForUpdatesOnStartup:=a_index
}
loop 2
{
	if AppOptionWhichLicense%a_index%
		AppOptionWhichLicense:=a_index
}
loop 3
{
	if AppPortability%a_index%
		AppPortability:=a_index
}

if AppIncludeUpdater ;If user changed the inclusion of the update checker, remove or add it to list
{
	ifnotinstring,AppExeList,|%AppFileName%|Update Checker|
		StringReplace,AppExeList,AppExeList,|%AppFileName%|,|%AppFileName%|Update Checker|
}
else
{

	ifinstring,AppExeList,|%AppFileName%|Update Checker|
		StringReplace,AppExeList,AppExeList,|%AppFileName%|Update Checker|,|%AppFileName%|

}


;Save changelog
if (fileexist(App_Direction "\" AppChangelog) and AppChangelog!="")
{
	FileDelete,%App_Direction%\%AppChangelog%
	FileAppend,%AppChangelogText%,%App_Direction%\%AppChangelog%,UTF-8
}


3Cancel:
3guiclose:
gui destroy
gui 1:default
gui show,restore
sleep,100
gui show

gosub,GuiListUpdate
return

3ButtonAddEntry:
gui,1:submit,nohide
gui,submit,nohide
AppChangeLogText=%AppUpdateVersion%`n`n`n%AppChangeLogText%
guicontrol,,AppChangeLogText,%AppChangeLogText%

return

3ButtonSelectCustomLicense:
FileSelectFile,AppCustomLicensePath,1,%App_Direction%,% lang("Select_A_License_File")
StringReplace,AppCustomLicensePath,AppCustomLicensePath,%App_Direction%\
guicontrol,,AppCustomLicensePath,%AppCustomLicensePath%
return
3ButtonSelectIniPath:
FileSelectFile,AppPathOfIniWithUpdateInformations,S,%App_Direction%,% lang("Select destination file with update information")
StringReplace,AppPathOfIniWithUpdateInformations,AppPathOfIniWithUpdateInformations,%App_Direction%\
guicontrol,,AppPathOfIniWithUpdateInformations,%AppPathOfIniWithUpdateInformations%
return

3ButtonSelectChangelog:
FileSelectFile,tempAppChangelog,,::{20d04fe0-3aea-1069-a2d8-08002b30309d},% lang("Select a file which contains the changelog")
if errorlevel
	return
IfNotInString,tempAppChangelog,%App_Direction%\
{
	MsgBox, 16,  % lang("Error"),  % lang("The file must be in a subfolder of the sourcecode path") 
}
else
{
	StringReplace,tempAppChangelog,tempAppChangelog,%App_Direction%\

	if !FileExist(App_Direction "\" tempAppChangelog)
	{
		MsgBox, 64, % lang("Information"), % lang("The file does not exist. A new one will be created.")
		FileAppend,,%App_Direction%\%tempAppChangelog%,UTF-8
	}
	guicontrol,,AppChangeLog,%tempAppChangelog%
	
}
return


3AppChangelogChanged:
guicontrolget,tempAppChangelog,,AppChangelog
if (tempAppChangelog!="" and fileexist(App_Direction "\" tempAppChangelog) )
{
	FileRead,AppChangeLogText,%App_Direction%\%tempAppChangelog%
	guicontrol,,AppChangeLogText,%AppChangeLogText%
	tempAppChangelogValid:=true
}
else
{
	tempAppChangelogValid:=false
}
gosub,AdvancedSettingsDisableUnusedButtons
return

AdvancedSettingsDisableUnusedButtons:
guicontrolget,tempAppIncludeUpdater,,AppIncludeUpdater
guicontrolget,tempAppOptionCheckForUpdatesOnStartup3,,AppOptionCheckForUpdatesOnStartup3
guicontrolget,tempAppOptionWhichLicense1,,AppOptionWhichLicense1
guicontrolget,tempAppCreateIniWithUpdateInformations,,AppCreateIniWithUpdateInformations
if tempAppIncludeUpdater
	tempEnableDisable=enable
else
	tempEnableDisable=disable

guicontrol,%tempEnableDisable%,AppURLVersionComparison
guicontrol,%tempEnableDisable%,AppURLVersionComparison2
guicontrol,%tempEnableDisable%,AppURLVersionComparison3
guicontrol,%tempEnableDisable%,AppOptionCheckForUpdatesOnStartup1
guicontrol,%tempEnableDisable%,AppOptionCheckForUpdatesOnStartup2
guicontrol,%tempEnableDisable%,AppOptionCheckForUpdatesOnStartup3
guicontrol,%tempEnableDisable%,AppCreateIniWithUpdateInformations
if (tempAppIncludeUpdater and tempAppOptionCheckForUpdatesOnStartup3)
	tempEnableDisable=enable
else
	tempEnableDisable=disable

guicontrol,%tempEnableDisable%,AppAutomaticUpdateIniFile
guicontrol,%tempEnableDisable%,AppAutomaticUpdateIniSection
guicontrol,%tempEnableDisable%,AppAutomaticUpdateIniKey

if (tempAppIncludeUpdater and tempAppCreateIniWithUpdateInformations)
	tempEnableDisable=enable
else
	tempEnableDisable=disable

guicontrol,%tempEnableDisable%,AppURLInstaller
guicontrol,%tempEnableDisable%,AppWebsite
guicontrol,%tempEnableDisable%,AppPathOfIniWithUpdateInformations
guicontrol,%tempEnableDisable%,ButtonSelectIniPath


if (tempAppOptionWhichLicense1)
{
	guicontrol,enable,AppLicense
	guicontrol,Disable,AppCustomLicensePath
	guicontrol,Disable,ButtonSelectCustomLicense
}
else
{
	guicontrol,Disable,AppLicense
	guicontrol,enable,AppCustomLicensePath
	guicontrol,enable,ButtonSelectCustomLicense
}


if (tempAppChangelogValid)
{
	guicontrol,enable,ButtonAddEntry	
	guicontrol,enable,AppChangeLogText
}
else
{
	guicontrol,Disable,ButtonAddEntry	
	guicontrol,Disable,AppChangeLogText
}
return

jumpOverAdvancedSettingsRoutines:
temp=

