#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

random,rand,1,1000

IniWrite,hallo%rand%,test.ini,test,test
IniRead,hallovar,test.ini,test,test

MsgBox %hallovar%