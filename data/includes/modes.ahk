SetTimer, CheckMode, 1000

;------------------------------------------------------------------------------------------
CheckMode:
	if(gIsChecking = true)
	{
		return
	}

	gIsChecking := true

	if(gHasSetup != true)
	{
		if(Mode != -2)
		{
			SwitchToMode_2()
		}

		gIsChecking := false
		return
	}

	if(gManualOverride = true)
	{
		return
	}

	if(gIsInitializing = true)
	{
		return
	}

	if(IsWoWWindowFocus() != true and Mode != -1)
	{
		SwitchToMode_1()
	}
	else
	{
		if(IsIngame() = true and Mode != 0)
		{
			SwitchToMode0()
		}
		else if(Mode != 1 and IsGlue() = true)
		{
			SwitchToMode1()
			if(gIsInitializing != true)
			{
				InitLogin()
			}
		}
		else if(Mode = 0 and IsIngame() != true and IsGlue() != true)
		{
			SwitchToMode_1()
		}
	}

	gIsChecking := false
return

;------------------------------------------------------------------------------------------
SwitchToMode_2()
{
	AddToLogFile("SwitchToMode_2")

	mode := -2
	PlayUtterance(L["setup mode"])
	sleep, 500

	gCurrentMenuItem := gMainMenuVoice
	gMainMenuVoice.onEnter()
}

;------------------------------------------------------------------------------------------
SwitchToMode_1()
{
	AddToLogFile("SwitchToMode_1")
	mode := -1
	PlayUtterance(L["pause mode"])
	sleep, 500
}

;------------------------------------------------------------------------------------------
SwitchToMode0()
{
	AddToLogFile("SwitchToMode0")
	mode := 0
	PlayUtterance(L["play mode"])
	sleep, 500
}

;------------------------------------------------------------------------------------------
SwitchToMode1()
{
	AddToLogFile("SwitchToMode1")
	LoadData()
	gNumberOfCharsOnCurrentRealm := -1
	mode = 1
	regions := LoadRegionsData()
	PlayUtterance(L["login mode for"] . " " . L[gHasSetupGametype] . ", " . L[regions[gHasSetupRegion].name] . ", " . L[GetCurrentLanguageName()])
	WaitForX(2, 1000)
}

;------------------------------------------------------------------------------------------
global gInQueuePlayed := false
SetTimer, WatchInQueue, 3663
WatchInQueue:
	if(global Mode == 1)
	{
		if(global gInQueue == true)
		{
			if(gCurrentMenuItem.name == L["main menu"])
			{
				SoundPlay, % A_WorkingDir . "\data\soundfiles\sound-notification6_de.mp3"

				if(global gInQueuePlayed == false)
				{
					global gInQueuePlayed := true
					PlayUtterance(L["server full. Waiting in queue."])
					WaitForX(4, 500)
				}

				tValue := true

				tRGBColor := GetColorAtUiPos(9799, 450)
				if (IsColorRange(tRGBColor.r, 255) = true and IsColorRange(tRGBColor.g, 0) = true and IsColorRange(tRGBColor.b, 0) = true)
				{
					;tValue := true
				}
				else
				{
					tValue := false
				}

				tRGBColor := GetColorAtUiPos(10194, 450)
				if (IsColorRange(tRGBColor.r, 255) = true and IsColorRange(tRGBColor.g, 0) = true and IsColorRange(tRGBColor.b, 0) = true)
				{
					;tValue := true
				}
				else
				{
					tValue := false
				}

				tRGBColor := GetColorAtUiPos(445, 450)
				if (IsColorRange(tRGBColor.r, 0) = true and IsColorRange(tRGBColor.g, 20) = true and IsColorRange(tRGBColor.b, 0) = true)
				{
					;tValue := true
				}
				else
				{
					tValue := false
				}

				if(tValue == false)
				{
					global gInQueue := false
					global gInQueuePlayed := false
					gosub InitMenu

					sleep, 2000
					InitLogin()
				}
			}
		}
	}

return

;------------------------------------------------------------------------------------------
InitLogin()
{
	gIsInitializing := true

	StartOver:

	WaitForX(4, 500)
	if(IsOutdatedAddonsWarning() = true)
	{
		ClickAwayOutdateAddonsWarning()
	}
	WaitForX(4, 500)


	if(IsOutdatedAddonsWarning() = true)
	{
		ClickAwayOutdateAddonsWarning()
	}
	if(IsContract() = true)
	{
		AcceptContract()
	}

	if(IsRealmQueue() == true)
	{
		gosub InitQueueMenu
		return
	}

	if(IsCharSelectionScreen() = true)
	{
		WaitForX(4, 500)

		if(IsOutdatedAddonsWarning() = true)
		{
			ClickAwayOutdateAddonsWarning()
		}
		if(IsContract() = true)
		{
			AcceptContract()
		}

		if(IsDeleteCharPopup() = true)
		{
			tmpScreen := UiToScreen(gGameUiWidgets.DeleteCharPopupOkButton.x, gGameUiWidgets.DeleteCharPopupOkButton.y)
			MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
			Send {Click}
		}
		
		tTimeout := 0
		while(IsCharSelectionScreen() = true and (Is11Popup() = true or Is12Popup() = true))
		{
			gosub CheckMode
			if(Mode != 1)
			{
				return
			}

			ClosePopUps()

			tTimeout := tTimeout + 1
			WaitForX(1, 500)
			if(tTimeout > 60)
			{
				Fail()
				Pause
				return
			}
		}
		if(IsContract() = true)
		{
			AcceptContract()
		}
		
		gosub CheckMode
		if(Mode != 1)
		{
			return
		}
		
		UpdateCharacterMenu(false)
		
		gosub CheckMode
		if(Mode != 1)
		{
			return
		}

		gCurrentMenuItem := gMainMenu
		gMainMenu.onEnter()
	}
	else if(IsLoginScreen() = true)
	{
		tPopupClosed := false

		tTimeout := 0
		while(IsLoginScreen() = true)
		{
			gosub CheckMode
			if(Mode != 1)
			{
				return
			}

			tTimeout := tTimeout + 1
			WaitForX(1, 500)
			if(tTimeout > 120)
			{
				Fail()
				Pause
			return
			}


			if(IsLoginScreenInitialStart() != true)
			{
				ClosePopUps()

				if(IsReconnect() = true)
				{
					;click on reconnect
					tPopupClosed := true
					tmpScreen := UiToScreen(gGameUiWidgets.LoginScreenReconnectButton.x, gGameUiWidgets.LoginScreenReconnectButton.y)
					MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
					Send {Click}
				}
			}
		}
	}
	else if(IsRealmSelectionScreen() = true)
	{
		tmpScreen := UiToScreen(gGameUiWidgets.RealmSelectionCancelButton.x, gGameUiWidgets.RealmSelectionCancelButton.y)
		MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
		Send {Click} ;cancel

		tTimeout := 0
		while(IsRealmSelectionScreen() = true)
		{
			gosub CheckMode
			if(Mode != 1)
			{
				return
			}

			tTimeout := tTimeout + 1
			WaitForX(1, 500)
			if(tTimeout > 60)
			{
				Fail()
				Pause
			return
			}
		}
	}
	else if(IsCharCreationScreen() = true)
	{
		Send {Esc} ;back

		tTimeout := 0
		while(IsCharCreationScreen() = true)
		{
			Send {Esc} ;back

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

			tTimeout := tTimeout + 1
		}
	}
	else if(IsRealmQueue() == true)
	{
		gosub InitQueueMenu
		return
	}
	
	if(IsCharSelectionScreen() != true)
	{
		if(IsRealmQueue() == true)
		{
			gosub InitQueueMenu
			return
		}
		else
		{
			gosub CheckMode
			if(Mode != 1)
			{
				return
			}
			goto, StartOver
			;InitLogin()
		}
	}
	else if(gNumberOfCharsOnCurrentRealm = -1)
	{
		gosub CheckMode
		if(Mode != 1)
		{
			return
		}
		UpdateCharacterMenu(false)

		gosub CheckMode
		if(Mode != 1)
		{
			return
		}

		gCurrentMenuItem := gMainMenu
		gMainMenu.onEnter()
	}
	gIsInitializing := false
}
