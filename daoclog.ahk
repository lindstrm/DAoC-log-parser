;--- Settings ------------------------------------------------------------
log          = G:\Documents\Electronic Arts\Dark Age of Camelot\chat.log
logbutton    = {ScrollLock} ; log button in daoc
statsbutton  = {Insert} ; qbind for /stats macro
;-------------------------------------------------------------------------

#UseHook
#IfWinActive ahk_class DAoCMWC
F12::
Loop
{
	If statsbutton
		controlsend,,%statsbutton%,ahk_class DAoCMWC
		sleep 500

	controlsend,,%logbutton%,ahk_class DAoCMWC
	sleep 1000
	controlsend,,%logbutton%,ahk_class DAoCMWC

	loop
	{
		
		FileMove,%log%,%log%
	
		If Errorlevel
			break
		Else
			controlsend,,%logbutton%,ahk_class DAoCMWC

		sleep 500

	}
	
	sleep 5000
}

RShift & F12::
resetLog()
return

resetLog()
{
	global logbutton, log
	
	if checkLogging() == true
		send %logbutton%

	FileDelete, %log%
	sleep 500

	send %logbutton%
}

checkLogging()
{
	global log

	FileMove,%log%,%log%
	
	If Errorlevel
		return true
	Else
		return false
}