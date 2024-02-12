!Esc::
	PlayUtterance(L["script exited"])
	sleep 1000
	ExitApp
return

;------------------------------------------------------------------------------------------
!f1::
	Thread, Interrupt, 0

	gManualOverride := true

	if(Mode = 1 or Mode = -1)
	{
		SwitchToMode0()
	}
	else if(Mode = 0)
	{
		SwitchToMode1()
		InitLogin()
	}
return

#If mode = 1 or mode = -2
	;------------------------------------------------------------------------------------------
	Right::
		if(mode != 1 and mode != -2)
		{
			send {Right}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.childs[1] not)
		{
			gCurrentMenuItem.onEnter()
			return
		}
		gCurrentMenuItem.onSelect()
	return

	;------------------------------------------------------------------------------------------
	Left::
		if(mode != 1 and mode != -2)
		{
			send {Left}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.parent not)
		{
			gCurrentMenuItem.onEnter()
			return
		}

		gCurrentMenuItem.parent.onEnter()
	return

	;------------------------------------------------------------------------------------------
	Up::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {Up}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.p not)
		{
			gCurrentMenuItem.onEnter()
			return
		}
		gCurrentMenuItem.p.onEnter()
	return

	;------------------------------------------------------------------------------------------
	PgUp::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {PgUp}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.p10 not)
		{
			gCurrentMenuItem.onEnter()
			return
		}
		gCurrentMenuItem.p10.onEnter()
	return

	;------------------------------------------------------------------------------------------
	Down::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {Down}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.n not)
		{
			gCurrentMenuItem.onEnter()
			return
		}
		gCurrentMenuItem.n.onEnter()
	return

	;------------------------------------------------------------------------------------------
	PgDn::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {PgDn}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if (gCurrentMenuItem not)
		{
			return
		}
		if (gCurrentMenuItem.n10 not)
		{
			gCurrentMenuItem.onEnter()
			return
		}
		gCurrentMenuItem.n10.onEnter()
	return
	;------------------------------------------------------------------------------------------
	Enter::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {Enter}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if(gEnterCharacterNameFlag = true)
		{
			send {Enter}
			PlayUtterance(L["Please wait."])
			WaitForX(3, 500)

			EnterCharacterNameHandler()
		}
		else if(gDeleteCharacterNameFlag = true)
		{
			;send {Enter}
			DeleteCharacterNameHandler()
		}
		else
		{
			if (gCurrentMenuItem not)
			{
				return
			}
			gCurrentMenuItem.onAction()
		}
	return

	;------------------------------------------------------------------------------------------
	Escape::
		gosub CheckMode
		if(mode != 1 and mode != -2)
		{
			send {Esc}
			return
		}

		if (gIgnoreKeyPress = true)
		{
			;return
		}

		if(gEnterCharacterNameFlag = true)
		{
			gEnterCharacterNameFlag := false
			gEnterCharacterNameSelectZoneFlag := false

			Send {Esc}

			PlayUtterance(L["Creation is canceled. Please wait."])
			WaitForX(4, 500)

			sleep 1500

			;tmp := UiToScreen(-104, 706)
			;tmp := UiToScreen(-104, 706)
			;MouseMove, tmp.X, tmp.Y, 0

			tTimeout := 0
			while(IsCharSelectionScreen() != true)
			{
				Send {Esc}
				gosub CheckMode
				if(Mode != 1)
				{
					return
				}

				tTimeout := tTimeout + 1
				WaitForX(1, 2500)
				if(tTimeout > 20)
				{
					Fail()
					return
				}
			}

			gMainMenu.childs[3].onEnter()
		}

		if(gDeleteCharacterNameFlag = true)
		{
			gDeleteCharacterNameFlag := false

			PlayUtterance(L["Deleting is canceled. Please wait"])
			WaitForX(4, 500)

			if (IsDeleteCancelButton() = true)
			{
				;tmp := UiToScreen(10195, 437)
				;MouseMove, tmp.X, tmp.Y, 0
				Send {Esc}
			}

			sleep 1000

			tTimeout := 0
			while(IsCharSelectionScreen() != true)
			{
				Send {Esc}

				gosub CheckMode
				if(Mode != 1)
				{
					return
				}

				tTimeout := tTimeout + 1
				WaitForX(1, 2500)
				if(tTimeout > 20)
				{
					Fail()
					return
				}
			}

			gMainMenu.childs[1].onEnter()
		}
	return
#If

;------------------------------------------------------------------------------------------
; Play modus keybinds; set view 2-5 and mouse position to view 2-5; we don't use view 1 (first person) and 3
;------------------------------------------------------------------------------------
#If mode = 0 && gHasSetupGametype != "Retail"
	;------------------------------------------------------------------------------------------
	;view 2
	Numpad7::
		gosub CheckMode
		if(mode = 0)
		{
			WinGetPos, X, Y, Width, Height, Program Manager
			Width := Width / 2
			Height := Height / 2 - (Height / 10)
			CoordMode, Mouse, Screen
			MouseMove, %Width%, %Height%
			Send ^{Numpad7}
			Sleep, 500
			SendEvent {Click, right}
		}
	return

	;------------------------------------------------------------------------------------------
	;view 4
	Numpad8::
		gosub CheckMode
		if(mode = 0)
		{
			WinGetPos, X, Y, Width, Height, Program Manager
			Width := Width / 2
			Height := Height / 2 - (Height / 20)
			CoordMode, Mouse, Screen
			MouseMove, %Width%, %Height%
			Send ^{Numpad8}
			Sleep, 500
			SendEvent {Click, left}
		}
	return
	;------------------------------------------------------------------------------------------
	;view 5
	/*
	Numpad9::
	i::
		Send i
		gosub CheckMode
		if(mode = 0)
		{
			tmpUI := ScreenToUi(1, 20)
			tRGBColor := GetColorAtUiPos(tmpUI.x, tmpUI.y)
			if (IsColorRange(tRGBColor.r, 255) = true and IsColorRange(tRGBColor.g, 0) = true and IsColorRange(tRGBColor.b, 0) = true)
			{
				WinGetPos, X, Y, Width, Height, Program Manager
				Width := Width / 2
				Height := 5
				CoordMode, Mouse, Screen
				MouseMove, %Width%, %Height%
				Sleep, 250
				SendEvent {Click, right}
				Sleep, 1
				MouseMove, %Width%, %Height%
			}
		}
	return
	*/
#If





