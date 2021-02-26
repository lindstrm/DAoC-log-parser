;--- Settings ------------------------------------------------------------
log          = G:\Documents\Electronic Arts\Dark Age of Camelot\chat.log
statfile     = stats.json
logbutton    = {ScrollLock} ; log button in daoc
statsbutton  = {Insert} ; qbind for /stats macro
stats       := {}
;-------------------------------------------------------------------------
#Include JSON.ahk
#UseHook
F12::
WinGetTitle, Title, A
Loop
{

	If statsbutton
		controlsend,,%statsbutton%, %title%
		sleep 500

	controlsend,,%logbutton%, %title%
	sleep 1000
	controlsend,,%logbutton%, %title%

	stats.dbcount      := 0
	stats.killcount    := 0
	stats.dmgdealt     := 0
	stats.dmgreceived  := 0
	stats.rpearned     := 0
	stats.goldearned   := 0
	stats.healdone     := 0
	stats.healreceived := 0
	stats.buffrips     := 0
	stats.irs          := 0
	stats.rph          := 0

	loop, read, %log%
	{
		#If WinActive (title)

		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,4}) .*? damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,4}) damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "You attack .* and hit for (\d{1,4}) .* damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "You attack .* and hit for (\d{1,4}) damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,2}) extra damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "You critical hit for an additional (\d{1,}) damage!", dmgdealt)
		if dmgdealt
			stats.dmgdealt += dmgdealt1

		RegExMatch(A_LoopReadLine, "Deathblows: (\d{1,})", deathblow)
		if deathblow
			stats.dbcount := deathblow1

		RegExMatch(A_LoopReadLine, "Total RP: (\d{1,})", rpearned)
		if rpearned
			stats.rpearned := rpearned1

		RegExMatch(A_LoopReadLine, "RP\/hour: (.*)", rph)
		if rph
			stats.rph := rph1

		RegExMatch(A_LoopReadLine, ".I Remain Standing\.\.\..: (\d{1,6})", irs)
		if irs
			stats.irs := irs1

		RegExMatch(A_LoopReadLine, "Kills that have earned RP: (\d{1,})", killcount)
		if killcount
			stats.killcount := killcount1

		RegExMatch(A_LoopReadLine, "Your share of the loot is (\d{1,}) gold,", goldearned)
		if goldearned
			stats.goldearned += goldearned1

		RegExMatch(A_LoopReadLine, "You pick up (\d{1,}) gold,", goldearned)
		if goldearned
			stats.goldearned += goldearned1

		RegExMatch(A_LoopReadLine, "You gain an additional (\d{1,}) gold,", goldearned)
		if goldearned
			stats.goldearned += goldearned1

		RegExMatch(A_LoopReadLine, "You recieve (\d{1,}) gold,", goldearned)
		if goldearned
			stats.goldearned += goldearned1

		RegExMatch(A_LoopReadLine, "You heal .* for (\d{1,}) hit points.", healdone)
		if healdone
			stats.healdone += healdone1

		RegExMatch(A_LoopReadLine, "You critical heal for an additional (\d{1,}) hit points!", healdone)
		if healdone
			stats.healdone += healdone1

		RegExMatch(A_LoopReadLine, ".* healed you for (\d{1,}) hit points.", healreceived)
		if healreceived
			stats.healreceived += healreceived1

		RegExMatch(A_LoopReadLine, ".* hits you for (\d{1,}) damage.", dmgreceived)
		if dmgreceived
			stats.dmgreceived += dmgreceived1

		RegExMatch(A_LoopReadLine, ".* hits your .* for (\d{1,}) .* damage.", dmgreceived)
		if dmgreceived
			stats.dmgreceived += dmgreceived1

		RegExMatch(A_LoopReadLine, "You are hit for (\d{1,}) .* damage.", dmgreceived)
		if dmgreceived
			stats.dmgreceived += dmgreceived1

		RegExMatch(A_LoopReadLine, "Your spell rips away some of your target's enhancing magic.", _)
		if _
			stats.BuffRips += 1

		RegExMatch(A_LoopReadLine, "Your spell strips .* from the target.", _)
		if _
			stats.BuffRips += 1
	}

	str := JSON.Dump( stats, [, indent := "" ] )

	FileDelete, %statfile%
		FileAppend, %str% , %statfile%

	loop
	{

		FileMove,%log%,%log%

		If Errorlevel
			break
		Else
			controlsend,,%logbutton%, %title%

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
