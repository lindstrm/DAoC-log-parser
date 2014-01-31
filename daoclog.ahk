;--- Settings ------------------------------------------------------------
log          = D:\My Documents\Electronic Arts\Dark Age of Camelot\chat.log
output       = c:\_stream ; no end slash
DBString     = Death Blows:
KillsString  = Total Kills:
DMGString    = Damage Done:
RPString     = Total RP:
GoldString   = Gold:
HealString   = Healing Done:
DamageTakenString = Damage Taken:
logbutton    = {ScrollLock} ; log button in daoc
statsbutton  = {Insert} ; qbind for /stats macro
;-------------------------------------------------------------------------

#UseHook
#IfWinActive ahk_class DAoCMWC

Loop
{
	parseLog()
	sleep 15000
}

^F12::
parseLog()
return

RShift & F12::
send %logbutton%
FileDelete, %log%
sleep 500
send %logbutton%
return

parseLog()
{
	global log, output, DBString, DMGString, RPString, KillsString, HealString, GoldString, DamageTakenString, logbutton, statsbutton, logStatus
	
	If statsbutton
		send {Insert}
		sleep 500

	send %logbutton%
	sleep 1000
	send %logbutton%
	DBCount     = 0
	KillCount   = 0
	DamageTotal = 0
	TotalRp     = 0
	GoldCount   = 0
	HealCount   = 0
	DamageTaken = 0
	loop, read, %log%
	{
		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,4}) .*? damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,4}) damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "You attack .* and hit for (\d{1,4}) .* damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "You attack .* and hit for (\d{1,4}) damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "You hit .* for (\d{1,2}) extra damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "You critical hit for an additional (\d{1,}) damage!", DamageDealt)
		if DamageDealt
			DamageTotal += DamageDealt1

		RegExMatch(A_LoopReadLine, "Deathblows: (\d{1,})", DeathBlow)
		if DeathBlow
			DBCount := DeathBlow1

		RegExMatch(A_LoopReadLine, "Total RP: (\d{1,})", TotalRps)
		if TotalRps
			TotalRp := TotalRps1

		RegExMatch(A_LoopReadLine, "Kills that have earned RP: (\d{1,})", TotalKills)
		if TotalKills
			KillCount := TotalKills1

		RegExMatch(A_LoopReadLine, "Your share of the loot is (\d{1,}) gold,", TotalGold)
		if TotalGold
			GoldCount += TotalGold1

		RegExMatch(A_LoopReadLine, "You pick up (\d{1,}) gold,", TotalGold)
		if TotalGold
			GoldCount += TotalGold1

		RegExMatch(A_LoopReadLine, "You gain an additional (\d{1,}) gold,", TotalGold)
		if TotalGold
			GoldCount += TotalGold1

		RegExMatch(A_LoopReadLine, "You recieve (\d{1,}) gold,", TotalGold)
		if TotalGold
			GoldCount += TotalGold1

		RegExMatch(A_LoopReadLine, "You heal .* for (\d{1,}) hit points.", TotalHeal)
		if TotalHeal
			HealCount += TotalHeal1

		RegExMatch(A_LoopReadLine, "You critical heal for an additional (\d{1,}) hit points!", TotalHeal)
		if TotalHeal
			HealCount += TotalHeal1

		RegExMatch(A_LoopReadLine, ".* hits you for (\d{1,}) damage.", TotalDamage)
		if TotalDamage
			DamageTaken += TotalDamage1

		RegExMatch(A_LoopReadLine, ".* hits your .* for (\d{1,}) .* damage.", TotalDamage)
		if TotalDamage
			DamageTaken += TotalDamage1
	}

	DeathBlowsFile  = %output%\DaocDeathblows.txt
	TotalKillsFile  = %output%\DaocTotalKills.txt
	DamageDealtFile = %output%\DaocDamageDealt.txt
	TotalRpFile     = %output%\DaocTotalRp.txt
	TotalGoldFile   = %output%\DaocTotalGold.txt
	HealingDoneFile = %output%\DaocHealing.txt
	DamageTakenFile = %output%\DaocDamageTaken.txt

	FileDelete, %DeathBlowsFile%
	FileAppend, %DBString% %DBCount%, %DeathBlowsFile%

	FileDelete, %DamageDealtFile%
	FileAppend, %DMGString% %DamageTotal%, %DamageDealtFile%

	FileDelete, %TotalRpFile%
	FileAppend, %RPString% %TotalRp%, %TotalRpFile%

	FileDelete, %TotalKillsFile%
	FileAppend, %KillsString% %KillCount%, %TotalKillsFile%

	FileDelete, %TotalGoldFile%
	FileAppend, %GoldString% %GoldCount%, %TotalGoldFile%

	FileDelete, %HealingDoneFile%
	FileAppend, %HealString% %HealCount%, %HealingDoneFile%

	FileDelete, %DamageTakenFile%
	FileAppend, %DamageTakenString% %DamageTaken%, %DamageTakenFile%

	loop
	{
		
		FileMove,%log%,%log%
	
		If Errorlevel
			break
		Else
			send %logbutton%

		sleep 500

	}
	
}