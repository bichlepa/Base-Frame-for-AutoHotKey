#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

BaseFrame_AppVersion:=_AppVersion_
BaseFrame_AppVersionToCompare:=_AppVersionForComparison_

BaseFrameAboutText=
(
_BASEFRAMEABOUTTEXT_
)
goto,JumpOverBaseFrame_About ;Do not show the license terms

BaseFrame_About:


;Todo: make GUI multilingual

Gui, BaseFrame:destroy
gui, BaseFrame:+owner
BaseFrame_AboutWidth:=round(A_ScreenWidth*0.6)
Gui, BaseFrame:Add,edit, vBaseFrameAboutText w%BaseFrame_AboutWidth% readonly, %BaseFrameAboutText%

Gui, BaseFrame:Add, Button, gBaseFrameButtonClose  +default w100 h30 , Close
Gui, BaseFrame:Add, Button, gBaseFrameButtonLicense yp xp+110 w100 h30 , Show license
Gui, BaseFrame:Show,, About



send,{right} ;Workaround to unselect everything
return

BaseFrameButtonClose:
BaseFrameGuiClose:
Gui, BaseFrame:destroy
return

BaseFrameButtonLicense:
run,License.txt
return




JumpOverBaseFrame_About: ;Do not show the license terms





;It can be set whether it should be searched for updates on every start
iniread,BaseFrame_WhetherToCheckUpdates,Settings.ini,BaseFrame,Check for updates,1 ;Read setting. If it cannot be read, set 1
if BaseFrame_WhetherToCheckUpdates=1 ;If it should search for updates
{
	;Try to call update checker. It should not show anything until an update was found.
	try run, Update Checker.exe "silent"
}


;Here the user code will start
