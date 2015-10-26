goto,jumpOverDefaultSettingsRoutines

MenuSetDefaults:



Gui,hide

Gui 2:default

iniread,DefaultAppAuthorName,Settings.ini,DefaultValues,AppAuthorName,%a_space%
iniread,DefaultAppAuthorEmail,Settings.ini,DefaultValues,AppAuthorEmail,%a_space%

gui,add,text,, % lang("Enter the default values for new projects")
Gui, Add, Text, x15 Y+10,  % lang("Author") ":"
Gui, Add, Edit, x105 yp vDefaultAppAuthorName w160,%DefaultAppAuthorName%
Gui, Add, Text, x15 yp+25,  % lang("Email") ":"
Gui, Add, Edit, x105 yp vDefaultAppAuthorEmail w160,%DefaultAppAuthorEmail%
gui,add,button,x15 Y+10 w120 h25 g2OK, % lang("OK")
gui,add,button,X+10 yp w120 h25 g2Cancel, % lang("Cancel")

gui,show,, % lang("Set default values")

return

2OK:
gui,submit
iniwrite,%DefaultAppAuthorName%,Settings.ini,DefaultValues,AppAuthorName
iniwrite,%DefaultAppAuthorEmail%,Settings.ini,DefaultValues,AppAuthorEmail


2Cancel:
2GuiClose:
gui destroy
gui 1:default
gui show,restore
return





jumpOverDefaultSettingsRoutines:
temp=

