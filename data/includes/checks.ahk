;------------------------------------------------------------------------------------------
IsRealmQueue()
{
	/*
	Apparently there are no realm queues anymore. If, I can't test, as I can't reproduce the popup.
	Therefore we are ignoring this for now. Always returning false.
	*/
	return false

	/*
	Orginal code
	*/
	rReturnValue := true

	tmpUI := UiToScreen(9799, 450)

		MouseMove, tmpUI.X, tmpUI.Y, 0
		sleep, 100


	tRGBColor := GetColorAtUiPos(9799, 450)

	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		;rReturnValue := true
	}
	else
	{
		rReturnValue := false
	}

	tmpUI := UiToScreen(gGameUiWidgets.CharSelectionRealmsButton.x, gGameUiWidgets.CharSelectionRealmsButton.y)

		MouseMove, tmpUI.X, tmpUI.Y, 0
		sleep, 100


	tRGBColor := GetColorAtUiPos(10194, 450)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		;rReturnValue := true
	}
	else
	{
		rReturnValue := false
	}

	tmpUI := UiToScreen(445, 450)

		MouseMove, tmpUI.X, tmpUI.Y, 0
		sleep, 100


	tRGBColor := GetColorAtUiPos(445, 450)
	if (IsColorRange(tRGBColor.r, 0) = true and IsColorRange(tRGBColor.g, 20) = true and IsColorRange(tRGBColor.b, 0) = true)
	{
		;rReturnValue := true
	}
	else
	{
		rReturnValue := false
	}

	if(rReturnValue == true)
	{
		global gInQueue := true
		gIsInitializing = false
	}
	else
	{
		global gInQueuePlayed := false
		global gInQueue := false
	}

	OutputDebug % "IsRealmQueue" rReturnValue
	AddToLogFile("IsRealmQueue " . rReturnValue)
	return rReturnValue

}

;------------------------------------------------------------------------------------------
IsColorRange(aTestColorValue, aCompareColorValue)
{
	if(aTestColorValue >= (aCompareColorValue - 2) and aTestColorValue <= (aCompareColorValue + 2))
	{
		return true
	}
	else
	{
		return false
	}
}

;------------------------------------------------------------------------------------------
IsWoWWindowFocus()
{
	rReturnValue := false
	SetTitleMatchMode, 3
	If(WinActive("World of Warcraft"))
	{
		rReturnValue := true
	}
	If(WinActive("WORLD OF WARCRAFT"))
		{
			rReturnValue := true
		}
	
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsIngame()
{
	rReturnValue := false

	tmpUI := ScreenToUi(1, 1)

	tRGBColor := GetColorAtUiPos(tmpUI.x, tmpUI.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericBlue.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericBlue.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericBlue.b) = true)
	{
		rReturnValue := true
	}

	tmpUI := ScreenToUi(1, A_ScreenHeight-2)

	tRGBColor := GetColorAtUiPos(tmpUI.x, tmpUI.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericBlue.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericBlue.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericBlue.b) = true)
	{
		rReturnValue := true
	}


	OutputDebug % "IsIngame" rReturnValue
	AddToLogFile("IsIngame " rReturnValue)

	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsGlue()
{
	rReturnValue := false

	if(IsLoginScreen() = true or IsCharSelectionScreen() = true or IsRealmSelectionScreen() = true or IsCharCreationScreen() = true or IsContract() = true)
	{
		rReturnValue := true
	}

	OutputDebug % "IsGlue" rReturnValue
	AddToLogFile("IsGlue " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsLoginScreenInitialStart()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.LoginScreenLogo.x,gGameUiWidgets.LoginScreenLogo.y)
	tRGBColorQuit := GetColorAtUiPos(gGameUiWidgets.LoginScreenQuit.x,gGameUiWidgets.LoginScreenQuit.y)
	tRGBColorCreate := GetColorAtUiPos(gGameUiWidgets.LoginScreenCreate.x,gGameUiWidgets.LoginScreenCreate.y)
	if ((IsColorRange(tRGBColorLogo.r, gGameUiColors.GenericLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.GenericLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.GenericLogo.b) = true) = true and (IsColorRange(tRGBColorQuit.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorQuit.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorQuit.b, gGameUiColors.GenericRedButton.b) = true) = true and (IsColorRange(tRGBColorCreate.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorCreate.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorCreate.b, gGameUiColors.GenericRedButton.b) = true) = false)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsLoginScreenInitialStart" rReturnValue
	AddToLogFile("IsLoginScreenInitialStart " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsLoginScreen()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.LoginScreenLogo.x,gGameUiWidgets.LoginScreenLogo.y)
	tRGBColorQuit := GetColorAtUiPos(gGameUiWidgets.LoginScreenQuit.x,gGameUiWidgets.LoginScreenQuit.y)
	if ((IsColorRange(tRGBColorLogo.r, gGameUiColors.GenericLogo.r) = true 
		and IsColorRange(tRGBColorLogo.g, gGameUiColors.GenericLogo.g) = true 
		and IsColorRange(tRGBColorLogo.b, gGameUiColors.GenericLogo.b) = true) 
		and (IsColorRange(tRGBColorQuit.r, gGameUiColors.GenericRedButton.r) = true 
		and IsColorRange(tRGBColorQuit.g, gGameUiColors.GenericRedButton.g) = true 
		and IsColorRange(tRGBColorQuit.b, gGameUiColors.GenericRedButton.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsLoginScreen" rReturnValue
	AddToLogFile("IsLoginScreen " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsCharSelectionScreen()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenLogo.x,gGameUiWidgets.CharSelectionScreenLogo.y)
	tRGBColorAddons := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenAddons.x,gGameUiWidgets.CharSelectionScreenAddons.y)

	if (((IsColorRange(tRGBColorLogo.r, gGameUiColors.CharSelectionScreenLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.CharSelectionScreenLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.CharSelectionScreenLogo.b) = true) and (IsColorRange(tRGBColorAddons.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorAddons.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorAddons.b, gGameUiColors.GenericRedButton.b) = true)) or (((IsColorRange(tRGBColorLogo.r, gGameUiColors.CharSelectionScreenLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.CharSelectionScreenLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.CharSelectionScreenLogo.b) = true) and (IsColorRange(tRGBColorAddons.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorAddons.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorAddons.b, gGameUiColors.GenericRedButton.b) = true))))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsCharSelectionScreen" rReturnValue
	AddToLogFile("IsCharSelectionScreen " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsCharCreationScreen()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.CharCreationLogo.x, gGameUiWidgets.CharCreationLogo.y)
	tRGBColorRCBackdrop := GetColorAtUiPos(gGameUiWidgets.CharCreationBackdrop.x, gGameUiWidgets.CharCreationBackdrop.y)
	if ((IsColorRange(tRGBColorLogo.r, gGameUiColors.CharCreationLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.CharCreationLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.CharCreationLogo.b) = true) and (IsColorRange(tRGBColorRCBackdrop.r, gGameUiColors.CharCreationBackdrop.r) = true and IsColorRange(tRGBColorRCBackdrop.g, gGameUiColors.CharCreationBackdrop.g) = true and IsColorRange(tRGBColorRCBackdrop.b, gGameUiColors.CharCreationBackdrop.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsCharCreationScreen" rReturnValue
	AddToLogFile("IsCharCreationScreen " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsRealmSelectionScreen()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorTitleBackdrop := GetColorAtUiPos(gGameUiWidgets.RealmSelectionTitleBackdrop.x, gGameUiWidgets.RealmSelectionTitleBackdrop.y)
	tRGBColorListBackdrop := GetColorAtUiPos(gGameUiWidgets.RealmSelectionListBackdrop.x, gGameUiWidgets.RealmSelectionListBackdrop.y)
	if ((IsColorRange(tRGBColorTitleBackdrop.r, gGameUiColors.RealmSelectionTitleBackdrop.r) = true and IsColorRange(tRGBColorTitleBackdrop.g, gGameUiColors.RealmSelectionTitleBackdrop.g) = true and IsColorRange(tRGBColorTitleBackdrop.b, gGameUiColors.RealmSelectionTitleBackdrop.b) = true) and (IsColorRange(tRGBColorListBackdrop.r, gGameUiColors.RealmSelectionListBackdrop.r) = true and IsColorRange(tRGBColorListBackdrop.g, gGameUiColors.RealmSelectionListBackdrop.g) = true and IsColorRange(tRGBColorListBackdrop.b, gGameUiColors.RealmSelectionListBackdrop.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsRealmSelectionScreen" rReturnValue
	AddToLogFile("IsRealmSelectionScreen " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsRealmListScrollbar()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorScrollbarBackdrop := GetColorAtUiPos(gGameUiWidgets.ServerListScrollbarBackdrop.x, gGameUiWidgets.ServerListScrollbarBackdrop.y) ;retail
	if ((IsColorRange(tRGBColorScrollbarBackdrop.r, gGameUiColors.RealmSelectionScrollbarBackdrop.r) = true and IsColorRange(tRGBColorScrollbarBackdrop.g, gGameUiColors.RealmSelectionScrollbarBackdrop.g) = true and IsColorRange(tRGBColorScrollbarBackdrop.b, gGameUiColors.RealmSelectionScrollbarBackdrop.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsRealmListScrollbar" rReturnValue
	AddToLogFile("IsRealmListScrollbar " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsContract()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenLogo.x,gGameUiWidgets.CharSelectionScreenLogo.y)
	tRGBColorAddons := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenAddons.x,gGameUiWidgets.CharSelectionScreenAddons.y)
	tRGBColorTitleBackdrop := GetColorAtUiPos(9852, 284)

	if ((IsColorRange(tRGBColorLogo.r, gGameUiColors.CharSelectionContractLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.CharSelectionContractLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.CharSelectionContractLogo.b) = true) and (IsColorRange(tRGBColorAddons.r, gGameUiColors.CharSelectionContractAddons.r) = true and IsColorRange(tRGBColorAddons.g, gGameUiColors.CharSelectionContractAddons.g) = true and IsColorRange(tRGBColorAddons.b, gGameUiColors.CharSelectionContractAddons.b) = true) and (IsColorRange(tRGBColorTitleBackdrop.r, gGameUiColors.GenericBlack.r) = true and IsColorRange(tRGBColorTitleBackdrop.g, gGameUiColors.GenericBlack.g) = true and IsColorRange(tRGBColorTitleBackdrop.b, gGameUiColors.GenericBlack.b) = true))
	{
		rReturnValue := true
	}
	gIgnoreKeyPress := false
	OutputDebug % "IsContract" rReturnValue
	AddToLogFile("IsContract " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsOutdatedAddonsWarning()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenLogo.x,gGameUiWidgets.CharSelectionScreenLogo.y)
	tRGBColorAddons := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenAddons.x,gGameUiWidgets.CharSelectionScreenAddons.y)
	tRGBColorTitleBackdrop := GetColorAtUiPos(gGameUiWidgets.OutdatedAddonsWarningBackdrop.x, gGameUiWidgets.OutdatedAddonsWarningBackdrop.y)

	if ((((IsColorRange(tRGBColorLogo.r, gGameUiColors.GenericLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.GenericLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.GenericLogo.b) = true) and (IsColorRange(tRGBColorAddons.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorAddons.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorAddons.b, gGameUiColors.GenericRedButton.b) = true)) or (((IsColorRange(tRGBColorLogo.r, 50) = true and IsColorRange(tRGBColorLogo.g, 57) = true and IsColorRange(tRGBColorLogo.b, 0) = true) and (IsColorRange(tRGBColorAddons.r, gGameUiColors.CharSelectionContractAddons.r) = true and IsColorRange(tRGBColorAddons.g, gGameUiColors.CharSelectionContractAddons.g) = true and IsColorRange(tRGBColorAddons.b, gGameUiColors.CharSelectionContractAddons.b) = true)))) and (IsColorRange(tRGBColorTitleBackdrop.r, 0) = true and IsColorRange(tRGBColorTitleBackdrop.g, 40) = true and IsColorRange(tRGBColorTitleBackdrop.b, 0) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsOutdatedAddonsWarning" rReturnValue
	AddToLogFile("IsOutdatedAddonsWarning " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsHighPopServerWarning()
{
	gIgnoreKeyPress := true
	rReturnValue := false

		
	tRGBColor := GetColorAtUiPos(gGameUiWidgets.SwitchRealmHighPopWarnOkButton.x, gGameUiWidgets.SwitchRealmHighPopWarnOkButton.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsHighPopServerWarning" rReturnValue
	AddToLogFile("IsHighPopServerWarning " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsDisconnected()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(560,405)
	if (tRGBColor.r > 90 and tRGBColor.g < 40 and tRGBColor.b < 40)
	{
		rReturnValue := true
	}
	;MsgBox % rReturnValue
	gIgnoreKeyPress := false
	OutputDebug % "IsDisconnected" rReturnValue
	AddToLogFile("IsDisconnected " . rReturnValue)
	return rReturnValue
}

;-----------------------------------------------------------------------------------------------------------------------------------------------------
IsDeleteButtonEnabled()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(gGameUiWidgets.CharDeleteConfirmButton.x, gGameUiWidgets.CharDeleteConfirmButton.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsDeleteButtonEnabled" rReturnValue
	AddToLogFile("IsDeleteButtonEnabled " . rReturnValue)
	return rReturnValue
}

;-----------------------------------------------------------------------------------------------------------------------------------------------------
IsDeleteButtonDisabled()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(gGameUiWidgets.CharDeleteConfirmButton.x, gGameUiWidgets.CharDeleteConfirmButton.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericLightGreyButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericLightGreyButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericLightGreyButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsDeleteButtonDisabled" rReturnValue
	AddToLogFile("IsDeleteButtonDisabled " . rReturnValue)
	return rReturnValue
}

;-----------------------------------------------------------------------------------------------------------------------------------------------------
IsDeleteCancelButton()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(gGameUiWidgets.CharDeleteCancelButton.x, gGameUiWidgets.CharDeleteCancelButton.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsDeleteCancelButton" rReturnValue
	AddToLogFile("IsDeleteCancelButton " . rReturnValue)
	return rReturnValue
}
/*
;------------------------------------------------------------------------------------------
IsEnterCredentials()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tmyAccount := false

	tRGBColor := GetColorAtUiPos(32,590)
	if (tRGBColor.r > 190 and tRGBColor.g < 40 and tRGBColor.b < 40)
	{
		tmyAccount := true
	}

	tmp := UiToScreen(510,396)

	tRGBColor := GetColorAtUiPos(510.4,396)
	if (tRGBColor.r < 90 and tRGBColor.g < 90 and tRGBColor.b < 90 and tmyAccount = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	return rReturnValue
}
*/

;------------------------------------------------------------------------------------------
/*
	1 line, 2 buttons
*/
Is12Popup()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLeft := GetColorAtUiPos(9802, 386)
	tRGBColorRight := GetColorAtUiPos(10196, 386)
	if((IsColorRange(tRGBColorLeft.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorLeft.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorLeft.b, gGameUiColors.GenericRedButton.b) = true) and (IsColorRange(tRGBColorRight.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorRight.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorRight.b, gGameUiColors.GenericRedButton.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "Is12Popup" rReturnValue
	AddToLogFile("Is12Popup " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
/*
	2 lines, 2 buttons
*/
Is22Popup()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorLeft := GetColorAtUiPos(9802, 412)
	tRGBColorRight := GetColorAtUiPos(10196, 412)
	if((IsColorRange(tRGBColorLeft.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorLeft.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorLeft.b, gGameUiColors.GenericRedButton.b) = true) and (IsColorRange(tRGBColorRight.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColorRight.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColorRight.b, gGameUiColors.GenericRedButton.b) = true))
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "Is22Popup" rReturnValue
	AddToLogFile("Is22Popup " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
/*
	1 line, 1 button
*/
Is11Popup()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(9915, 386)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true and Is12Popup() != true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "Is11Popup" rReturnValue
	AddToLogFile("Is11Popup " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
/*
	2 lines, 1 button
*/
Is21Popup()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(9915, 412)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true and Is22Popup() != true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "Is21Popup" rReturnValue
	AddToLogFile("Is21Popup " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsDeleteCharPopup()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColorBackdrop := GetColorAtUiPos(gGameUiWidgets.DeleteCharPopupBackdrop.x, gGameUiWidgets.DeleteCharPopupBackdrop.y)
	tRGBColorEditbox := GetColorAtUiPos(gGameUiWidgets.DeleteCharPopupEditBox.x, gGameUiWidgets.DeleteCharPopupEditBox.y)
	if (IsColorRange(tRGBColorBackdrop.r, 0) = true and IsColorRange(tRGBColorBackdrop.g, 40) = true and IsColorRange(tRGBColorBackdrop.b, 0) = true) and (IsColorRange(tRGBColorEditbox.r, 3) = true and IsColorRange(tRGBColorEditbox.g, 17) = true and IsColorRange(tRGBColorEditbox.b, 3) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsDeleteCharPopup" rReturnValue
	AddToLogFile("IsDeleteCharPopup " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsReconnect()
{
	gIgnoreKeyPress := true
	rReturnValue := false
	
	tRGBColor := GetColorAtUiPos(gGameUiWidgets.LoginScreenReconnectButton.x, gGameUiWidgets.LoginScreenReconnectButton.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericRedButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericRedButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericRedButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsReconnect" rReturnValue
	AddToLogFile("IsReconnect " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsConnectingToGame()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(570,394)
	if (tRGBColor.r > 100 and tRGBColor.g < 40 and tRGBColor.b < 40)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsConnectingToGame" rReturnValue
	AddToLogFile("IsConnectingToGame " . rReturnValue)
	return rReturnValue
}

;------------------------------------------------------------------------------------------
IsWhiteUI(x, y)
{
	tRGBColor := GetColorAtUiPos(x, y)
	if (tRGBColor.r > 250 and tRGBColor.g > 250 and tRGBColor.b > 250)
	{
		return true
	}
	return false
}

;------------------------------------------------------------------------------------------
IsCharCreattionPreviewButtonDisabled()
{
	gIgnoreKeyPress := true
	rReturnValue := false

	tRGBColor := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenCreateCharPreview.x, gGameUiWidgets.CharSelectionScreenCreateCharPreview.y)
	if (IsColorRange(tRGBColor.r, gGameUiColors.GenericLightGreyButton.r) = true and IsColorRange(tRGBColor.g, gGameUiColors.GenericLightGreyButton.g) = true and IsColorRange(tRGBColor.b, gGameUiColors.GenericLightGreyButton.b) = true)
	{
		rReturnValue := true
	}

	gIgnoreKeyPress := false
	OutputDebug % "IsCharCreattionPreviewButtonDisabled" rReturnValue
	AddToLogFile("IsCharCreattionPreviewButtonDisabled" . rReturnValue)
	return rReturnValue
}