ui_CreateMenuBar()
{
	global
	
	for tempkey, tempval in allLangs
	{
	   ;MsgBox % tempval "|" %tempval%enlangname
	   menu,MenuLanguage,add,% %tempval%enlangname,MenuChangeLanguage
	}
	
	
	Menu,MenuSettings,add,% "&" lang("Default values"),MenuSetDefaults
	Menu,MenuSettings,add,% "&" lang("Language"), :MenuLanguage

	Menu,MenuHelp,add, % "&" lang("Help"),MenuHelp
	Menu,MenuHelp,add, % "&" lang("About"),MenuAbout

	Menu, MenuBar, Add,% "&" lang("Settings"), :MenuSettings
	Menu, MenuBar, Add,% "&" lang("Help"), :MenuHelp
	
	Gui, Menu, MenuBar
}

goto,jumpOverMenuBarLabels

MenuChangeLanguage:
WhitchLanguage:=A_ThisMenuItem
MsgBox, 52, % lang("Attention"), % lang("When you change the language, Base Frame needs to be restarted. All settings will be lost")
ifmsgbox,Yes
{
  lang_SetNewLanguage(WhitchLanguage)
  Reload
  return
}
else
  return


return


MenuHelp:
Gui, Help:Destroy
IfNotExist, Help\%UILang%\Index.html
{
   MsgBox, 16, % lang("Error"),% lang("No help file was found")
   Return
}
Gui, Help:Add, ActiveX, x0 y0 w720 h490 vHB, Shell.Explorer
HB.Navigate(A_ScriptDir . "\Help\" UILang "\Index.html")
Gui, Help:+ToolWindow +LabelHelp
Gui, Help:Color, FFFFFF
Gui, Help:Show, w720 h490,% "Base Frame - " lang("Help")
Return

HelpClose:
Gui, Help:Destroy
Return

MenuAbout:
goto,BaseFrame_About




jumpOverMenuBarLabels:
temp=