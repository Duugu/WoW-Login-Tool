;------------------------------------------------------------------------------------------
AcceptContract()
{
	tmp := UiToScreen(9999, 195)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 2000
	Loop 5
	{
		Click, WheelDown
	}

	sleep, 1000
	ty := 439
	Loop, 34
	{
		tmp := UiToScreen(9950, ty)
		MouseMove, tmp.X, tmp.Y, 0
		WaitForX(1, 100)
		Send {Click}
		ty := ty + 3
	}

	Loop, 34
	{
		tmp := UiToScreen(9893, (A_Index * 17) + 502)
		MouseMove, tmp.X, tmp.Y, 0
		WaitForX(1, 100)
		Send {Click}

	}
}

;------------------------------------------------------------------------------------------
ClosePopUps()
{
	if(Is11Popup() = true and tPopupClosed != true)
	{
		;click 1 line 1 button popup away
		;MsgBox 1L 1B
		tPopupClosed := true
		tmpScreen := UiToScreen(9915, 397)
		MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
		Send {Click}
		Sleep, 200
	}

	if(Is21Popup() = true and tPopupClosed != true)
	{
		;click 2 lines 1 button popup away
		;MsgBox 2L 1B
		tPopupClosed := true
		tmpScreen := UiToScreen(9915, 405)
		MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
		Send {Click}
		Sleep, 200
	}

	if(Is12Popup() = true and tPopupClosed != true)
	{
		;click 1 line 2 buttons popup away
		;MsgBox 1L 2B
		tPopupClosed := true
		tmpScreen := UiToScreen(10196, 397)
		MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
		Send {Click}
		Sleep, 200
	}

	if(Is22Popup() = true and tPopupClosed != true)
	{
		;click 2 lines 2 buttons popup away (right button)
		;MsgBox 2L 2B
		tPopupClosed := true
		tmpScreen := UiToScreen(10196, 405)
		MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
		Send {Click}
		Sleep, 200
	}
}

;------------------------------------------------------------------------------------------
WaitForX(waitCycles, ms)
{
	gIgnoreKeyPress = true
	loop % waitCycles
	{
		gosub CheckMode
		if (mode != 1 and mode != -2)
		{
			break
			return
		}

		PlayUtterance(L["wait"])
		sleep ms
	}
	gIgnoreKeyPress = false
}

;------------------------------------------------------------------------------------------
Fail()
{
	PlayUtterance(L["Something went wrong. Please restart the game and try again."])
	WaitForX(4, 1000)
	gIgnoreKeyPress := false
	SwitchToMode_1()
	Pause
}

;------------------------------------------------------------------------------------------
GetLockedRaces()
{
	tLockedRaces := {}

	if(gHasSetupGametype != "Retail")
	{
		return tLockedRaces
	}

	Loop % gRaces.MaxIndex()
	{
		raceNumber := A_Index
		tRGBColor := GetColorAtUiPos(gRaces[raceNumber].x, gRaces[raceNumber].y)
		if (IsColorRange(tRGBColor.r, gGameUiColors.CharCreationDisabledRace.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.CharCreationDisabledRace.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.CharCreationDisabledRace.b) = true)
		{
			tLockedRaces[raceNumber] := true
		}
	}

	return tLockedRaces
}


;------------------------------------------------------------------------------------------
ScrollUpCharacterList()
{
	tmp := UiToScreen(-90, 200)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200
	Loop 50
	{
		sleep, 10
		Click, WheelUp
	}
}

;------------------------------------------------------------------------------------------
UpdateFavoriteSlots()
{
	if(gHasSetupGametype != "Retail")
	{
		return
	}

	ScrollUpCharacterList()

	WaitForX(1, 1000)

	tmp := UiToScreen(-10, 10)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200


	tDone := false
	while(tDone = false)
	{
		tFavoriteSlots := {1: 1, 2: 1, 3: 1, 4: 1}

		Loop % tFavoriteSlots.Length()
		{
			tSlotNumber := A_Index
			tRGBColor := GetColorAtUiPos(gCharUIPositions[tSlotNumber].x,gCharUIPositions[tSlotNumber].y)
			if (IsColorRange(tRGBColor.r, gGameUiColors.CharListFavoritesSlotEmpty.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.CharListFavoritesSlotEmpty.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.CharListFavoritesSlotEmpty.b) = true)
				{
					tFavoriteSlots[tSlotNumber] := false
				}
		}
		;MsgBox % tFavoriteSlots[1] tFavoriteSlots[2] tFavoriteSlots[3] tFavoriteSlots[4] 
		if(tFavoriteSlots[1] = 1 && tFavoriteSlots[2] = 1 && tFavoriteSlots[3] = 1 && tFavoriteSlots[4] = 1)
		{
			tDone := true
			;MsgBox, finished
			return
		}

		else
		{
			Loop % tFavoriteSlots.Length()
			{
				tSlotNumber := A_Index
				if(tFavoriteSlots[tSlotNumber] = 0)
				{
					tFoundSomething := false
					;MsgBox % "updating " tSlotNumber
					tStart := tSlotNumber
					tCount := 8 - tStart
					Loop % tCount
					{
						tSourceSlotNumber := A_Index + tStart
						;MsgBox % "checking " tSourceSlotNumber
						tRGBColor := GetColorAtUiPos(gCharUIPositions[tSourceSlotNumber].x,gCharUIPositions[tSourceSlotNumber].y)
						if ((IsColorRange(tRGBColor.r, gGameUiColors.CharListFavoritesSlotEmpty.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.CharListFavoritesSlotEmpty.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.CharListFavoritesSlotEmpty.b) = true) = false && (IsColorRange(tRGBColor.r, gGameUiColors.CharListRegularSlotEmpty.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.CharListRegularSlotEmpty.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.CharListRegularSlotEmpty.b) = true) = false)
						{
							;MsgBox % "moving " tSourceSlotNumber " to " tSlotNumber
							tFoundSomething := true
							tmp := UiToScreen(gCharUIPositions[tSourceSlotNumber].x,gCharUIPositions[tSourceSlotNumber].y)
							MouseMove, tmp.X, tmp.Y, 0
							sleep, 500
							Click, down
							sleep, 500
							tmp := UiToScreen(gCharUIPositions[tSlotNumber].x,gCharUIPositions[tSlotNumber].y)
							MouseMove, tmp.X, tmp.Y, 0
							sleep, 500
							Click, up
							sleep, 500
							break	
						}
					}
				}
				if(tFoundSomething = false)
				{
					tDone := true
				}
			}
		}		
	}
	;MsgBox, finished 1
	return
}