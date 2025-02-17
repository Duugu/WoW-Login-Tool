global sap := ComObjCreate("SAPI.SpVoice")

;------------------------------------------------------------------
IsValidVoice(voiceName)
{
	if(InStr(voiceName, "Amazon") = 0)
	{
		return true
	}
}
;------------------------------------------------------------------
CleanupVoicesList(aVoices)
{
	voices := {}
	for i, v in aVoices
	{
		if(InStr(v, "Amazon") = 0)
		{
			voices[i] := v
		}
	}
	return voices
}

;------------------------------------------------------------------
GetVoices()
{
	voices := {}
	tCount := 0
	for i, v in sap.GetVoices()
	{
		if(IsValidVoice(i.GetDescription()))
		{
			voices[tCount] := i.GetDescription()
		}
		tCount := tCount + 1
	}
	
	voices := CleanupVoicesList(voices)

	return voices
}

;------------------------------------------------------------------------------------------
GetSapiVoiceNumberByName(newVoiceName)
{
	tCount := 0
	for i, v in sap.GetVoices()
	{
		if(i.GetDescription() = newVoiceName)
		{
			sap.Voice := sap.GetVoices.item(tCount)
			return tCount
		}
		tCount := tCount + 1
	}
}

;------------------------------------------------------------------------------------------
SetSapiVoiceByName(newVoiceName)
{
	tCount := 0
	for i, v in sap.GetVoices()
	{
		if(i.GetDescription() = newVoiceName)
		{
			sap.Voice := sap.GetVoices.item(tCount)
			return
		}
		tCount := tCount + 1
	}
}

;------------------------------------------------------------------------------------------
SetSapiVoiceByNumber(newVoiceNumber)
{
	sap.Voice := sap.GetVoices.item(newVoiceNumber)
}

;------------------------------------------------------------------------------------------
SetToolVoiceByName(newVoiceName)
{
	global gHasSetupVoice :=  newVoiceName
}

;------------------------------------------------------------------------------------------
PlayUtterance(aText)
{

	if(aText = L["wait"])
	{
		SoundPlay, % A_WorkingDir . "\data\soundfiles\sound-notification6_de.mp3"
	}
	else
	{
		;OutputDebug, % aText
		aText := StrReplace(aText, "_", " ")

		try
		{
			global gOrgSapiVoiceObject := sap.Voice

			SetSapiVoiceByName(gHasSetupVoice)
			sap.Rate := 5
			sap.Speak(aText, 3)
			sap.Voice := gOrgSapiVoiceObject
		}
		catch e 
		{
			;OutputDebug % "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!sap.speak err" . e
		}
	}
}