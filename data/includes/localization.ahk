global L := {}

;------------------------------------------------------------------
LoadLocalizationLanguageData(aCode)
{
	languageData := {}

	tLineNumber := 1
	tLastLine := ""
	Loop
	{
		FileReadLine, line, %A_ScriptDir%\data\localization\%aCode%.txt, tLineNumber
		if(line = tLastLine)
		{
			break
		}

		tArray := StrSplit(line, "==")
		languageData[tArray[1]] := tArray[2]

		tLastLine := line
		tLineNumber := tLineNumber + 1
	}

	return languageData
}

;------------------------------------------------------------------
LoadLocalizationData()
{
	localizationData := {}

	tLanguages := GetLanguages()
	for k, v in tLanguages
	{
		localizationData[v.code] := LoadLocalizationLanguageData(v.code)
	}

	aLangCode := "enEN"

	if(gHasSetupLanguage != false)
	{
		aLangCode := gHasSetupLanguage
	}

	if(!localizationData[aLangCode])
	{
		aLangCode := "enEN"
	}

	for k, v in localizationData["enEN"]
	{
		if(localizationData[aLangCode][k])
		{
			L[k] := localizationData[aLangCode][k]
		}
		else
		{
			L[k] := v
		}
	}
}

;------------------------------------------------------------------
SetLanguage(aLangCode)
{
	global gHasSetupLanguage := aLangCode
	LoadLocalizationData()
}

;------------------------------------------------------------------
GetLanguages()
{
	tLanguages := {}
	tLineNumber := 1
	tLastLine := ""
	Loop
	{
		FileReadLine, line, %A_ScriptDir%\data\languages.ini, tLineNumber
		if(line = tLastLine)
		{
			break
		}

		tArray := StrSplit(line, "=")
		tLanguages[tLineNumber] := {}
		tLanguages[tLineNumber].name := tArray[1]
		tLanguages[tLineNumber].code := tArray[2]

		tLastLine := line
		tLineNumber := tLineNumber + 1
	}

	return tLanguages
}


;------------------------------------------------------------------
GetCurrentLanguageName()
{
	langs := GetLanguages()
	for i, v in langs
		{
			if(v.code = gHasSetupLanguage)
				{
					return v.name
				}
		}
	return ""
}