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