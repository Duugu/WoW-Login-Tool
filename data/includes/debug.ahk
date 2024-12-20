﻿global StartTime := A_TickCount
;------------------------------------------------------------------------------------------
ClearLogFile()
{
	StartTime := A_TickCount
	try{
		FileDelete, log.txt
	}
}

;------------------------------------------------------------------------------------------
AddToLogFile(aString)
{
	try{
		file := FileOpen("log.txt", "a")
		if IsObject(file)
		{
			ElapsedTime := A_TickCount - StartTime
			file.Write(ElapsedTime . ":" . aString . "`r`n")
			file.Close()
		}
	}
}


/*


SetTimer, CloseMailWarnings, 250
CloseMailWarnings:

	MouseGetPos, OutputVarX, OutputVarY
	Width := 2
	;Height := Height / 2 - (Height / 10)
	;CoordMode, Mouse, Screen
	;MouseMove, %Width%, %Height%
	;ToolTip, Multiline`nTooltip, 100, 150

	ui := ScreenToUi(OutputVarX, OutputVarY)
	uix := floor(ui.x)
	uiy := floor(ui.y)
	tmpUI := UiToScreen(uix, uiy)
	screenx := floor(tmpUI.X)
	screeny := floor(tmpUI.Y)

	ToolTip, %OutputVarX% - %OutputVarY%`n%uix% - %uiy%`n%screenx% - %screeny%
return
*/

;------------------------------------------------------------------
;------------------------------------------------------------------
; TEST
/*


global timerRunning := false
F1::
	if(timerRunning = false)
	{
		global timerRunning := true
		SetTimer, debugtooltip, 50
	}
	else
	{
		timerRunning := false
		ToolTip
		SetTimer, debugtooltip, Delete
	}
return
debugtooltip:
	MouseGetPos, OutputVarX, OutputVarY
	Width := 2
	ui := ScreenToUi(OutputVarX, OutputVarY)
	uix := floor(ui.x)
	uiy := floor(ui.y)
	tmpUI := UiToScreen(uix, uiy)
	screenx := floor(tmpUI.X)
	screeny := floor(tmpUI.Y)


	tt := OutputVarX . " - " . OutputVarY . "`n" . uix . " - " . uiy . "`n" . screenx . " - " . screeny

	;tt := tt . "IsRealmQueue: " . IsRealmQueue() . "`n"
	tt := tt . "`n"
	tt := tt . "IsIngame: " . IsIngame() . "`n"
	tt := tt . "IsGlue: " . IsGlue() . "`n"
	tt := tt . "IsLoginScreenInitialStart: " . IsLoginScreenInitialStart() . "`n"
	tt := tt . "IsLoginScreen: " . IsLoginScreen() . "`n"
	tt := tt . "IsCharSelectionScreen: " . IsCharSelectionScreen() . "`n"
	tt := tt . "IsCharCreationScreen: " . IsCharCreationScreen() . "`n"
	tt := tt . "IsRealmSelectionScreen: " . IsRealmSelectionScreen() . "`n"
	tt := tt . "IsRealmListScrollbar: " . IsRealmListScrollbar() . "`n"
	tt := tt . "IsContract: " . IsContract() . "`n"
	tt := tt . "IsOutdatedAddonsWarning: " . IsOutdatedAddonsWarning() . "`n"
	tt := tt . "IsHighPopServerWarning: " . IsHighPopServerWarning() . "`n"
	tt := tt . "IsDisconnected: " . IsDisconnected() . "`n"
	tt := tt . "IsDeleteButtonEnabled: " . IsDeleteButtonEnabled() . "`n"
	tt := tt . "IsDeleteButtonDisabled: " . IsDeleteButtonDisabled() . "`n"
	tt := tt . "IsDeleteCancelButton: " . IsDeleteCancelButton() . "`n"
	tt := tt . "Is12Popup: " . Is12Popup() . "`n"
	tt := tt . "Is22Popup: " . Is22Popup() . "`n"
	tt := tt . "Is11Popup: " . Is11Popup() . "`n"
	tt := tt . "Is21Popup: " . Is21Popup() . "`n"
	tt := tt . "IsDeleteCharPopup: " . IsDeleteCharPopup() . "`n"
	tt := tt . "IsReconnect: " . IsReconnect() . "`n"
	tt := tt . "IsConnectingToGame: " . IsConnectingToGame() . "`n"

	tRGBColorQuit := GetColorAtUiPos(gGameUiWidgets.LoginScreenQuit.x,gGameUiWidgets.LoginScreenQuit.y)
	if ((IsColorRange(tRGBColorLogo.r, gGameUiColors.GenericLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.GenericLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.GenericLogo.b) = true))
	{
		tt := tt . gGameUiWidgets.LoginScreenQuit.x  . " x " .  gGameUiWidgets.LoginScreenQuit.y . " x " . (IsColorRange(tRGBColorLogo.r, gGameUiColors.GenericLogo.r) = true and IsColorRange(tRGBColorLogo.g, gGameUiColors.GenericLogo.g) = true and IsColorRange(tRGBColorLogo.b, gGameUiColors.GenericLogo.b) = true)

	}

	if(IsWoWWindowFocus() = true)
	{
		ToolTip % tt
	}
return


f1::
AcceptContract()
return

f2::
	MouseGetPos, OutputVarX, OutputVarY
	Width := 2
	ui := ScreenToUi(OutputVarX, OutputVarY)
	uix := floor(ui.x)
	uiy := floor(ui.y)
	tmpUI := UiToScreen(uix, uiy)
	screenx := floor(tmpUI.X)
	screeny := floor(tmpUI.Y)
	tt := "screen: " . OutputVarX . "," . OutputVarY . "`nUI: " . uix . "," . uiy

	tRGBColorLogo := GetColorAtUiPos(uix, uiy)
	tt := tt . "`n" . tRGBColorLogo.r . "," . tRGBColorLogo.g . "," . tRGBColorLogo.b
	OutputDebug % tt
	;tmp := UiToScreen(gGameUiWidgets.CharCreationLogo.x, gGameUiWidgets.CharCreationLogo.y)
	MouseMove, tmp.X, tmp.Y, 0
	;Send {Click}
return

F3::
	OutputDebug % "-----------------------------------------------------"

	OutputDebug % "IsLoginScreenInitialStart: " . IsLoginScreenInitialStart()
	OutputDebug % "IsLoginScreen: " . IsLoginScreen()
	OutputDebug % "IsCharSelectionScreen: " . IsCharSelectionScreen()
	OutputDebug % "IsDisconnected: " . IsDisconnected()
	OutputDebug % "Is11Popup: " . Is11Popup()
	OutputDebug % "Is12Popup: " . Is12Popup()
	OutputDebug % "Is21Popup: " . Is21Popup()
	OutputDebug % "Is22Popup: " . Is22Popup()
	OutputDebug % "IsReconnect: " . IsReconnect()
	OutputDebug % "IsConnectingToGame: " . IsConnectingToGame()
	OutputDebug % "IsDeleteButtonDisabled: " . IsDeleteButtonDisabled()
	OutputDebug % "IsDeleteButtonEnabled: " . IsDeleteButtonEnabled()
	OutputDebug % "IsDeleteCancelButton: " . IsDeleteCancelButton()
	OutputDebug % "IsDeleteCharPopup: " . IsDeleteCharPopup()
	OutputDebug % "IsRealmQueue: " . IsRealmQueue()
	OutputDebug % "IsGlue: " . IsGlue()
	OutputDebug % "IsContract: " . IsContract()
	OutputDebug % "IsRealmListScrollbar: " . IsRealmListScrollbar()
	OutputDebug % "IsCharCreationScreen: " . IsCharCreationScreen()
	OutputDebug % "IsWoWWindowFocus: " . IsWoWWindowFocus()
	tRGBColorLogo := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenLogo.x,gGameUiWidgets.CharSelectionScreenLogo.y)

	OutputDebug % "tRGBColorLogo.r: " . tRGBColorLogo.r
	OutputDebug % "gGameUiColors.CharSelectionScreenLogo.r: " . gGameUiColors.CharSelectionScreenLogo.r
	;ListVars
	;Pause, On
return

NumpadAdd::
	Pause, Off
	
return
*/



/*


SetTimer, aaa, 250
aaa:

	MouseGetPos, OutputVarX, OutputVarY
	Width := 2
	;Height := Height / 2 - (Height / 10)
	;CoordMode, Mouse, Screen
	;MouseMove, %Width%, %Height%
	;ToolTip, Multiline`nTooltip, 100, 150

	ui := ScreenToUi(OutputVarX, OutputVarY)
	uix := floor(ui.x)
	uiy := floor(ui.y)
   tRGBColor := GetColorAtUiPos(uix, uiy)
   r := tRGBColor.r
   g := tRGBColor.g
   b := tRGBColor.b



	tmpUI := UiToScreen(uix, uiy)
	screenx := floor(tmpUI.X)
	screeny := floor(tmpUI.Y)

	ToolTip, %OutputVarX% - %OutputVarY%`n%uix% - %uiy%`n%screenx% - %screeny%`n%r% - %g% - %b%
return


f2::
	uix := floor(-75)
	uiy := floor(275)
	tmpUI := UiToScreen(uix, uiy)
	MouseMove, floor(tmpUI.X), floor(tmpUI.Y), 0
	;Send {Click}
return

f1::
   
GetNumberOfChars50Classic(false)
return



*/