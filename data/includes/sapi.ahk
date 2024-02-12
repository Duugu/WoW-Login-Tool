global sap := ComObjCreate("SAPI.SpVoice")

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
	if (SUCCEEDED(SpGetCategoryFromId(SPCAT_VOICES := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices", cpSpObjectTokenCategory)))
	{
		hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+18*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "Ptr", 0, "Ptr", 0, "Ptr*", cpSpEnumTokens)

		if (SUCCEEDED(hr))
		{
			hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+8*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt*", tokenCount)
			if (SUCCEEDED(hr))
			{
				voices := Object()
				Loop %tokenCount% {
					hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+7*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt", A_Index - 1, "Ptr*", pToken)
					if (FAILED(hr)) {
						Fail()
					}
					hr := DllCall(NumGet(NumGet(pToken+0)+6*A_PtrSize), "Ptr", pToken, "Ptr", 0, "Ptr*", pszValue)
					if (FAILED(hr)) {
						Fail()
					}
					hr := DllCall(NumGet(NumGet(pToken+0)+16*A_PtrSize), "Ptr", pToken, "Ptr*", pszCoMemTokenId)
					if (FAILED(hr)) {
						Fail()
					}
					voices[StrGet(pszCoMemTokenId, "UTF-16")] := StrGet(pszValue, "UTF-16")
					DllCall("ole32\CoTaskMemFree", "Ptr", pszValue)
					DllCall("ole32\CoTaskMemFree", "Ptr", pszCoMemTokenId)
					ObjRelease(pToken)
				}
			}
			ObjRelease(cpSpEnumTokens)
		}

		ObjRelease(cpSpObjectTokenCategory)
	}
	voices := CleanupVoicesList(voices)
	return voices
}

;------------------------------------------------------------------------------------------
SetVoice(index)
{
	if (SUCCEEDED(SpGetCategoryFromId(SPCAT_VOICES := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices", cpSpObjectTokenCategory)))
	{
		hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+18*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "Ptr", 0, "Ptr", 0, "Ptr*", cpSpEnumTokens)

		if (SUCCEEDED(hr))
		{
			hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+8*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt*", tokenCount)
			if (SUCCEEDED(hr))
			{
				voices := Object()
				Loop %tokenCount% {
					hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+7*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt", A_Index - 1, "Ptr*", pToken)
					if (FAILED(hr)) {
						Fail()
					}
					hr := DllCall(NumGet(NumGet(pToken+0)+6*A_PtrSize), "Ptr", pToken, "Ptr", 0, "Ptr*", pszValue)
					if (FAILED(hr)) {
						Fail()
					}
					hr := DllCall(NumGet(NumGet(pToken+0)+16*A_PtrSize), "Ptr", pToken, "Ptr*", pszCoMemTokenId)
					if (FAILED(hr)) {
						Fail()
					}
					voices[StrGet(pszCoMemTokenId, "UTF-16")] := StrGet(pszValue, "UTF-16")
					DllCall("ole32\CoTaskMemFree", "Ptr", pszValue)
					DllCall("ole32\CoTaskMemFree", "Ptr", pszCoMemTokenId)
					ObjRelease(pToken)
				}

				voices := CleanupVoicesList(voices)
				for k, v in voices {
					if (A_Index == index) {
						hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+19*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "WStr", k)
						break
					}
				}
			}
			ObjRelease(cpSpEnumTokens)
		}

		ObjRelease(cpSpObjectTokenCategory)
	}
}

;------------------------------------------------------------------------------------------
SpGetCategoryFromId(pszCategoryId, ByRef ppCategory, fCreateIfNotExist := False)
{
	static CLSID_SpObjectTokenCategory := "{A910187F-0C7A-45AC-92CC-59EDAFB77B53}"
		  ,ISpObjectTokenCategory      := "{2D3D3845-39AF-4850-BBF9-40B49780011D}"

	hr := 0
	try {
		cpTokenCategory := ComObjCreate(CLSID_SpObjectTokenCategory, ISpObjectTokenCategory)
	} catch e {
		; No, A_LastError or ErrorLevel doesn't contain the error code on its own and I CBA to use CoCreateInstance directly
		if (RegExMatch(e.Message, "0[xX][0-9a-fA-F]+", errCode)) { ; https://stackoverflow.com/a/9221391
			hr := errCode + 0
		} else {
			hr := 0x80004005
		}
	}

	if (SUCCEEDED(hr))
	{
		hr := DllCall(NumGet(NumGet(cpTokenCategory+0)+15*A_PtrSize), "Ptr", cpTokenCategory, "WStr", pszCategoryId, "Int", fCreateIfNotExist)
	}

	if (SUCCEEDED(hr))
	{
		ppCategory := cpTokenCategory
	}
	else
	{
		if (cpTokenCategory)
			ObjRelease(cpTokenCategory)
	}

	return hr
}

;------------------------------------------------------------------------------------------
SUCCEEDED(hr)
{
	return hr != "" && hr >= 0x00
}

;------------------------------------------------------------------------------------------
FAILED(hr)
{
	return hr == "" || hr < 0
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
		aText := StrReplace(aText, "_", " ")

		try
		{
			sap.Rate := 5
			sap.Speak(aText, 3)
		}
		catch e 
		{
			;OutputDebug % "sap.speak err" . e
		}
	}
}