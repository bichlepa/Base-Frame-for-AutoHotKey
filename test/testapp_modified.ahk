
BaseFrame_AppVersion=1.0
BaseFrame_AppUpdateVersion=1.00.00
BaseFrame_License=
(

)
BaseFrame_CheckedForUpdate:=false

;It can be set whether it should be searched for updates on every start
if (false)
{
	if (false)
	{
		iniread,BaseFrame_WhetherToCheckUpdates,%a_scriptdir%\Settings.ini,BaseFrame,Check for updates,1 ;Read setting. If it cannot be read, set 1
		if BaseFrame_WhetherToCheckUpdates=1 ;If it should search for updates
		{
			BaseFrame_CheckedForUpdate:=true
		}
	}
	else
		BaseFrame_CheckedForUpdate:=true
	
	if (BaseFrame_CheckedForUpdate=true) ;If it should search for updates
	{
		try
			run, Update Checker.exe "silent" ;Try to call update checker. It should not show anything until an update was found.
		catch
			BaseFrame_CheckedForUpdate:=-1
	}
}

;Here the user code will start


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox hello world!