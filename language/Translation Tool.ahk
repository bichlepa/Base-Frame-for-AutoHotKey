#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include language.ahk

;Retrieve all available languages
allLangs:=Object()
stringalllangs=`n
Loop,%A_WorkingDir%\*.ini
{
	StringReplace,filenameNoExt,A_LoopFileName,.%A_LoopFileExt%
	
	IniRead,%filenameNoExt%enlangname,%filenameNoExt%.ini,general,enname
	IniRead,%filenameNoExt%langname,%filenameNoExt%.ini,general,name
	if %filenameNoExt%enlangname!=Error
	{
		allLangs.insert(filenameNoExt)
		
	}
	stringalllangs:=stringalllangs filenameNoExt " (" %filenameNoExt%enlangname " - "  %filenameNoExt%langname ")`n"
	;MsgBox %  filenameNoExt "|" %filenameNoExt%langname
}


;ask user to select a language
InputBox,translationto,Select Language,To whitch language do you want to translate?`nEnter a new short code or one of following codes:`n%stringalllangs%,,,% A_ScreenHeight*0.9
if (errorlevel OR translationto="")
	ExitApp
;If user has entered a new language
IfnotInString,stringalllangs,`n%translationto% (
{
	
	MsgBox,4,Question, %translationto% does not exist yet. Do you want to add a new language?
	IfMsgBox,yes ;If user wants to add this language
	{
		allLangs.insert(translationto)
		;Ask for the language name
		InputBox,%translationto%enlangname,Enter language name,What is the English name of the new language?
		if errorlevel
			ExitApp
		InputBox,%translationto%langname,Enter language name,% "What is the name of the new language in " %translationto%enlangname "?"
		if errorlevel
			ExitApp
		;Create ini and write the language names
		IniWrite,% %translationto%enlangname,%translationto%.ini,general,enname
		IniWrite,% %translationto%langname,%translationto%.ini,general,name
	}
	else
		reload
	
}

UILang:=translationto ;Needed by language.ahk. This way it will ask for the translations in the aim language
developing=yes ;needen by language.ahk. This way it will ask if there is no english translation

;Go upward to set the root dir of the project as the working dir
StringReplace,newWorkingDir,a_Scriptdir,\language
SetWorkingDir,%newWorkingDir%
Comma=,
;Loop through all ahks
loop %A_WorkingDir%\*.ahk,1,1
{
	;MsgBox %A_LoopFileFullPath%
	if A_LoopFileName=language.ahk ;Skip language.ahk
		continue
	
	FileRead,ahkFileContent,%A_LoopFileFullPath% ;Read file content
	tempFoundPos=1
	Loop ;Loop through all strings that may be translated in the file
	{
		;Search for "lаng("...") and extract the string that will look like: to_translate"    or: I want translate into %1%"
		;The found position is saved and on the next loop it will continue searching the next appearance
		tempFoundPos:=RegExMatch(ahkFileContent, "U)lang\(""(.+"")", tempVariablesToReplace,tempFoundPos +1)
		if tempFoundPos=0
			break
		
		TrayTip,File, %A_LoopFileFullPath% %tempFoundPos%
		;Search for "
		StringGetPos,pos,tempVariablesToReplace1,"
		if pos
			StringLeft,tempVariablesToReplace1,tempVariablesToReplace1,%pos% ;get everything left to "
		else
		{
			MsgBox, error! could not exract the string that should be translated
			
		}
		
		TrayTip,File, %A_LoopFileFullPath% %tempFoundPos% %tempVariablesToReplace1%
		
		
		lang(tempVariablesToReplace1) ;Call the lang() function in language.ahk
		
	}
}
MsgBox Everything is translated! :-)
ExitApp

