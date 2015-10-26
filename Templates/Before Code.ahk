
BaseFrame_AppVersion=_AppVersion_
BaseFrame_AppUpdateVersion=_AppUpdateVersion_
BaseFrame_License=
(
_BASEFRAMEABOUTTEXT_
)
BaseFrame_CheckedForUpdate:=false

;It can be set whether it should be searched for updates on every start
if (_AppCheckForUpates_)
{
	if (_AppCheckForUpatesReadIni_)
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
