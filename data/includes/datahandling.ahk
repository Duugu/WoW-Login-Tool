;------------------------------------------------------------------------------------------
WriteSettings()
{
	tFileHandle := FileOpen(A_ScriptDir . "\data\settings.ini", "w")

	if(gHasSetup != false)
	{
		tFileHandle.WriteLine("gHasSetupGametype=" . gHasSetupGametype)
		tFileHandle.WriteLine("gHasSetupVoice=" . gHasSetupVoice)
		tFileHandle.WriteLine("gHasSetupLanguage=" . gHasSetupLanguage)
		tFileHandle.WriteLine("gHasSetupRegion=" . gHasSetupRegion)
		tFileHandle.WriteLine("gHasSetup=" . gHasSetup)
	}
}

;------------------------------------------------------------------------------------------
LoadSettings()
{
	tFileHandle := FileOpen(A_ScriptDir . "\data\settings.ini", "r")
	if(tFileHandle)
	{
		while(!ErrorLevel)
		{
			tLine := tFileHandle.ReadLine()
			if(tLine = "")
			{
			break
			}

			tLine := SubStr(tLine, 1, StrLen(tLine) - 1)
			tArray := StrSplit(tLine, "=")

			if(tArray[1] == "gHasSetupGametype")
			{
				global gHasSetupGametype := tArray[2]
			}
			if(tArray[1] == "gHasSetupVoice")
			{
				global gHasSetupVoice := tArray[2]
			}
			if(tArray[1] == "gHasSetupLanguage")
			{
				global gHasSetupLanguage := tArray[2]
			}
			if(tArray[1] == "gHasSetupRegion")
			{
				global gHasSetupRegion := tArray[2]
			}
			if(tArray[1] == "gHasSetup")
			{
				global gHasSetup := tArray[2]
			}
		}
	}
	else
	{
		WriteSettings()
	}
}


;------------------------------------------------------------------------------------------
; load data helpers
;------------------------------------------------------------------------------------------
LoadData()
{
	tLastServerNamesIndex1 := 1
	tLastServerNamesIndex2 := 1

	global data := {}
	data.gCharUIPositions := {}
	data.gClassBoxes := {}
	data.gGameUiWidgets := {}
	data.gGameUiColors := {}
	data.gServerNames := {}
	data.gGenders := {}
	data.gStartingZones := {}
	data.gRaces := {}
	data.gRealmLangs := {}

	if(gHasSetup = false)
	{
		return	
	}

	tNextLineNumber := 1
	tReadNextLines := false
	Loop
	{
		FileReadLine, line, %A_ScriptDir%\data\data.ini, %tNextLineNumber%
		if(ErrorLevel)
		{
			global gCharUIPositions := data.gCharUIPositions
			global gClassBoxes := data.gClassBoxes
			global gRealmLangs := data.gRealmLangs
			global gServerNames := data.gServerNames
			global gGenders := data.gGenders
			global gStartingZones := data.gStartingZones
			global gRaces := data.gRaces
			global gGameUiWidgets := data.gGameUiWidgets
			global gGameUiColors := data.gGameUiColors

			return data
		}
		else
		{
			if(InStr(line, "--") = 0)
			{
				if(InStr(line, "[") > 0)
				{
					tLastServerNamesIndex1 := 1
					tLastServerNamesIndex2 := 1

					line := SubStr(line, 2, StrLen(line) - 2)
					tTypes :=  StrSplit(line, "-")


					if((tTypes[1] = gHasSetupGametype && !tTypes[2]) || (tTypes[1] = gHasSetupGametype && tTypes[2] = gHasSetupRegion && !tTypes[3]) || (tTypes[1] = gHasSetupGametype && tTypes[2] = gHasSetupLanguage && !tTypes[3]) || (tTypes[1] = gHasSetupGametype && tTypes[2] = gHasSetupRegion && tTypes[3] = gHasSetupLanguage))
					{
						tReadNextLines := true
					}
					else
					{
						tReadNextLines := false
					}
				}
				else
				{
					if(tReadNextLines = true)
					{
						tArray := StrSplit(line, "=")
			
						if(tArray[1] = "gCharUIPositions")
						{
							tValues :=  StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[1]] := {}
							data[tArray[1]][tValues[1]].x := tValues[2]
							data[tArray[1]][tValues[1]].y := tValues[3]
						}
						else if(tArray[1] = "gRealmLangs")
						{
							tValues :=  StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[1]] := {}
							data[tArray[1]][tValues[1]].name := tValues[2]
							data[tArray[1]][tValues[1]].x := tValues[3]
							data[tArray[1]][tValues[1]].y := tValues[4]
							;MsgBox % tValues[1] . " " . tValues[2] . " " . tValues[3] . " " . tValues[4]
						}
						else if(tArray[1] = "gServerNames")
						{
							tValues := StrSplit(tArray[2], ",")

							if(tValues[1] != tLastServerNamesIndex1)
							{
								tLastServerNamesIndex1 := tValues[1]
								tLastServerNamesIndex2 := 1
							}
							else
							{
								tLastServerNamesIndex2 := tLastServerNamesIndex2 + 1	
							}

							if(data[tArray[1]][tLastServerNamesIndex1].MaxIndex() == "")
							{
								data[tArray[1]][tLastServerNamesIndex1] := {}
							}
							data[tArray[1]][tLastServerNamesIndex1][tLastServerNamesIndex2] := {}
							data[tArray[1]][tLastServerNamesIndex1][tLastServerNamesIndex2].name := tValues[2]
							data[tArray[1]][tLastServerNamesIndex1][tLastServerNamesIndex2].x := tValues[3]
							data[tArray[1]][tLastServerNamesIndex1][tLastServerNamesIndex2].y := tValues[4]
							data[tArray[1]][tLastServerNamesIndex1][tLastServerNamesIndex2].type := tValues[5]
						}
						else if(tArray[1] = "gClassBoxes")
						{
							tValues := StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[1]] := {}
							data[tArray[1]][tValues[1]].x := tValues[2]
							data[tArray[1]][tValues[1]].y := tValues[3]
						}
						else if(tArray[1] = "gStartingZones")
						{
							tValues := StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[1]] := {}
							data[tArray[1]][tValues[1]].name := L[tValues[2]]
							data[tArray[1]][tValues[1]].x := tValues[3]
							data[tArray[1]][tValues[1]].y := tValues[4]
						}								
						else if(tArray[1] = "gGenders")
							{
								tValues := StrSplit(tArray[2], ",")
								data[tArray[1]][tValues[1]] := {}
								data[tArray[1]][tValues[1]].name := L[tValues[2]]
								data[tArray[1]][tValues[1]].x := tValues[3]
								data[tArray[1]][tValues[1]].y := tValues[4]
							}					
						else if(tArray[1] = "gRaces")
						{
							tValues := StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[1]] := {}
							data[tArray[1]][tValues[1]].name := L[tValues[2]]
							data[tArray[1]][tValues[1]].x := tValues[3]
							data[tArray[1]][tValues[1]].y := tValues[4]
							data[tArray[1]][tValues[1]].classes := {}
							tValuesClasses := StrSplit(tValues[5], ";")
							Loop % tValuesClasses.MaxIndex()
							{
								data[tArray[1]][tValues[1]].classes[A_Index] := L[tValuesClasses[A_Index]]
							}
						}
						else if(tArray[1] = "gGameUiWidgets")
						{
							if(!data[tArray[1]])
							{
								data[tArray[1]] := {}
							}
							tValues := StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[2]] := {}
							data[tArray[1]][tValues[2]].x := tValues[3]
							data[tArray[1]][tValues[2]].y := tValues[4]
						}
						else if(tArray[1] = "gGameUiColors")
						{
							if(!data[tArray[1]])
							{
								data[tArray[1]] := {}
							}
							tValues := StrSplit(tArray[2], ",")
							data[tArray[1]][tValues[2]] := {}
							data[tArray[1]][tValues[2]].r := tValues[3]
							data[tArray[1]][tValues[2]].g := tValues[4]
							data[tArray[1]][tValues[2]].b := tValues[5]
						}							
					}
				}
			}
		}
		tNextLineNumber := tNextLineNumber + 1
	}
}

;------------------------------------------------------------------------------------------
isArray(arrOrObj)
{
	if(ObjMinIndex(arrOrObj) == 1 || ObjCount(arrOrObj) > 0)
	{
		return 5
	}
}

;------------------------------------------------------------------------------------------
join(strArray, depth)
{
	s := ""
	tcount := 0
	for i,v in strArray
	{
		if(isArray(v) == 5)
		{
			Loop, %depth%
			{
				s := s . "`t"
			}
			s := s . i . "`n" . join(v, depth + 1) . "`n"
		}
		else
		{
			;s := s . "`n"
			if(tcount == 0)
			{
				Loop, %depth%
				{
					s := s . "`t"
				}
			}
			s := s . i . " = " . v . ", "

		}
		tcount := tcount + 1
	}
	return s
}

;------------------------------------------------------------------------------------------
LoadGameTypesData()
{
	tGametypes := {}

	tLineNumber := 1
	tLastLine := ""
	Loop
	{
		FileReadLine, line, %A_ScriptDir%\data\gametypes.ini, tLineNumber
		if(line = tLastLine)
		{
			break
		}

		tGametypes[tLineNumber] := {}
		tGametypes[tLineNumber].name := line

		tLastLine := line
		tLineNumber := tLineNumber + 1
	}

	return tGametypes
}
	
;------------------------------------------------------------------------------------------
LoadRegionsData()
{
	tRegions := {}

	tLineNumber := 1
	tLastLine := ""
	Loop
	{
		FileReadLine, line, %A_ScriptDir%\data\regions.ini, tLineNumber
		if(line = tLastLine)
		{
			break
		}

		tValues := StrSplit(line, "=")
		tRegions[tValues[1]] := {}
		tRegions[tValues[1]].name := tValues[2]

		tLastLine := line
		tLineNumber := tLineNumber + 1
	}

	return tRegions
}
