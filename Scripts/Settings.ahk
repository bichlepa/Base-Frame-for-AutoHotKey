goto,jumpOverSettingsRoutines

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



ButtonAdvancedInformations:
gui,hide

Gui, 3:Default

stringreplace,AppChangeLogToShow,AppChangeLog,``n,`n,all ;Fix linefeeds

Gui, Add, Text, x15 y15,% lang("Update URL") "2 :"
Gui, Add, Edit, x120 yp w200 vAppURLVersionComparison2,%AppURLVersionComparison2%
Gui, Add, Text, x15 yp+25, % lang("Update URL") " 3:"
Gui, Add, Edit, x120 yp w200 vAppURLVersionComparison3,%AppURLVersionComparison3%
gui, Add, Text, x15 yp+25,% lang("Changelog") ":"
Gui, Add, Edit, x120 yp w200 h80 vAppChangeLog,%AppChangeLogToShow%
gui, add, Button, x15 yp+30 w95 g3ButtonAddEntry , % lang("Add entry")



gui, add, Button, x15 y150 w100 h30 v3ok g3OK +default, % lang("OK")
gui, add, button, X+10 yp w100 h30 g3Cancel, % lang("Cancel")

guicontrol,focus,3ok
gui,show,,% lang("Advanced informations")
return

3OK:
gui,submit
StringReplace,AppChangeLog,AppChangeLog,`n,``n,all ;Fix linefeeds

3Cancel:
3guiclose:
gui destroy
gui 1:default
gui show,restore
sleep,100
gui show

return

3ButtonAddEntry:
gui,1:submit,nohide
gui,submit,nohide
AppChangeLog=%AppVersionForComparison%`n`n`n%AppChangeLog%
guicontrol,,AppChangeLog,%AppChangeLog%

return



jumpOverSettingsRoutines:
temp=

