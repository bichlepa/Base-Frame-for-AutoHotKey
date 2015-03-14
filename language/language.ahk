;Find all languages
lang_FindAllLanguages()
{
	global
	allLangs:=Object()

	Loop,language\*.ini
	{
		
		StringReplace,filenameNoExt,A_LoopFileName,.%A_LoopFileExt%
		
		IniRead,%filenameNoExt%enlangname,language\%filenameNoExt%.ini,general,enname
		;MsgBox % filenameNoExt "-" %filenameNoExt%enlangname
		IniRead,%filenameNoExt%langname,language\%filenameNoExt%.ini,general,name
		IniRead,%filenameNoExt%code,language\%filenameNoExt%.ini,general,code
		if %filenameNoExt%enlangname!=Error
		{
			
			allLangs.insert(filenameNoExt)
			
		}
		
		;MsgBox %  filenameNoExt "|" %filenameNoExt%langname
	}


	
}


;Load language settings
lang_LoadSettings()
{
	global
	iniread,translationto,settings.ini,common,translatingto
	iniread,developing,settings.ini,common,developing
	
	iniread,UILang,settings.ini,common,UILanguage
	if uilang=error
	{
		
		for index, templang in allLangs
		{
			;MsgBox % templang " " %templang%code " " A_Language
			IfInString,%templang%code,%A_Language%
			{
				uilang:=templang
				break
			}
		}
		if uilang=Error
			uilang=en
	}
	;IniRead,%UILang%enlangname,language\%UILang%.ini\general\enname
	;IniRead,%UILang%langname,language\%UILang%.ini\general\name
	
}

lang_SetNewLanguage(newlang)
{
	global
	
	local tempkey
	local tempvalue
	
	;The newLang may be a number
	if newlang is number
	{
		iniwrite,% allLangs[newlang],settings.ini,common,UILanguage
		
	}
	else
	{
		;newlang may be abbreviation of the language
		for tempkey, tempvalue in allLangs
		{
			if (tempvalue=newlang)
			{
				iniwrite,% allLangs[tempkey],settings.ini,common,UILanguage
				break
			}
			
		}
		;newlang may be the English name of the language
		for tempkey, tempvalue in allLangs
		{
			if (%tempvalue%enlangname=newlang)
			{
				iniwrite,% allLangs[tempkey],settings.ini,common,UILanguage
				break
			}
			
		}
		;newlang may be the native name of the language
		for tempkey, tempvalue in allLangs
		{
			if (%tempvalue%langname=newlang)
			{
				iniwrite,% allLangs[tempkey],settings.ini,common,UILanguage
				break
			}
			
		}
		
	}
	
}


;Translate. This function will be called very often
lang(langvar,$1="",$2="",$3="",$4="",$5="",$6="",$7="",$8="",$9="")
{
	global UILang
	global developing
	global translationto
	static guiCreated
	global allLangs
	
	if (langvar ="")
		return ""
	langaborted:=false
	StringReplace,langvar_no_spaces,langvar,%a_space%,_,all
	
	langBeginAgain:
	IniRead,initext,language\%UILang%.ini,translations,%langvar_no_spaces%
	if (initext="" or initext=="ERROR")
	{
		;iniwrite,% "",language\%UILang%.ini,translations,%langvar_no_spaces%
		
		IniRead,initexten,language\en.ini,translations,%langvar_no_spaces%
		;MsgBox %initexten%, %langvar_no_spaces%
		if (initexten=="ERROR" or initexten="") 
		{
			
			if developing=yes
			{
				StringReplace,langvarSpaces,langvar_no_spaces,_,%A_Space%,all
				;MsgBox %langvar_no_spaces%
				InputBox,newtrans,How is this in English?,%langvar_no_spaces%,,,,,,,,%langvarSpaces%
				if ErrorLevel
				{
					IniDelete,language\en.ini,translations,%langvar_no_spaces%
					return
				}
				loop,9
				{
					;Replace some misspellings. For example replace %1$ with %1%
					StringReplace,newtrans,newtrans,$%a_index%,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%$,`%1`%,all
					StringReplace,newtrans,newtrans,`%%a_index%$,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%`%,`%1`%,all
					
				}
				iniwrite,% newtrans,language\en.ini,translations,%langvar_no_spaces%
				goto,langBeginAgain
			}
			else
				MsgBox,English text for %langvar_no_spaces% not found!
		}
		else if (translationto=UILang and langaborted=!true)
		{
			temptlangText=
			for tempindex, templang in allLangs
			{
				
				IniRead,templangcont,language\%templang%.ini,translations,%langvar_no_spaces%,%A_Space%
				;MsgBox %templang% %templangcont%
				if templangcont
					temptlangText:=temptlangText "`n" %templang%enlangname ": " templangcont
				
			}
			
			InputBox,newtrans,% "How is this in " %UILang%enlangname "?" ,%langvar_no_spaces% `n%temptlangText%,,% A_ScreenWidth*0.9,% A_ScreenHeight*0.9
			if errorlevel
				langaborted:=true
			else
			{
				loop,9
				{
					
					;Replace some misspellings. For example replace %1$ with %1%
					StringReplace,newtrans,newtrans,$%a_index%,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%$,`%1`%,all
					StringReplace,newtrans,newtrans,`%%a_index%$,`%1`%,all
					StringReplace,newtrans,newtrans,$%a_index%`%,`%1`%,all
					
				}
				iniwrite,% newtrans,language\%UILang%.ini,translations,%langvar_no_spaces%
				if ErrorLevel
				{
					IniDelete,language\%UILang%.ini,translations,%langvar_no_spaces%
					return
				}
			}
			goto,langBeginAgain
		
		}
		else 
		{
			initext:=initextEN
			
		}
	}
	
	langSuccess:
	;replace all placeholders with transmitted parameters
	StringReplace,initext,initext,`%1`%,%$1%,all
	StringReplace,initext,initext,`%2`%,%$2%,all
	StringReplace,initext,initext,`%3`%,%$3%,all
	StringReplace,initext,initext,`%4`%,%$4%,all
	StringReplace,initext,initext,`%5`%,%$5%,all
	StringReplace,initext,initext,`%6`%,%$6%,all
	StringReplace,initext,initext,`%7`%,%$7%,all
	StringReplace,initext,initext,`%8`%,%$8%,all
	StringReplace,initext,initext,`%9`%,%$9%,all
	
	
	return initext
	
}

