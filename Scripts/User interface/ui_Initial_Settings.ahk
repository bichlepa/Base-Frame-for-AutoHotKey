goto,jumpOverInitialSettingsRoutines

ui_SetInitialSettings()
{

	global

	Gui,1:hide

	;~ Gui 4:default


	gui, 4:add,text,, % lang("Following values are needed for the project")
	Gui, 4:Add, Text, x15 Y+10,  % lang("Application name") ":"
	Gui, 4:Add, Edit, x155 yp vAppName w160,%App_FilenameNoExt%
	Gui, 4:Add, Text, x15 yp+25,  % lang("Application version to show") ":"
	Gui, 4:Add, Edit, x155 yp vAppVersion w160,1.0
	Gui, 4:Add, Text, x15 yp+25,  % lang("Precise application version") ":"
	Gui, 4:Add, Edit, x155 yp vAppVersionForComparison w160,1.00.00
	gui, 4:add,button,x15 Y+10 w140 h25 v4OK g4OK default, % lang("OK")
	gui, 4:add,button,X+10 yp w140 h25 g4Cancel, % lang("Cancel")
	guicontrol,4:focus,4OK
	gui, 4:show,, % lang("Create new project")

}	

4OK:
gui,4:submit

4Cancel:
4GuiClose:
gui 4:destroy
gui 1:default
gui 1:show,restore

goto,ShowLoadedSettingsInGUI
return





jumpOverInitialSettingsRoutines:
temp=

