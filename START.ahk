#Persistent
#MaxThreadsPerHotkey 2 ;we need that for NumpadSub; without at least 2 threads it won't be able to interupt itself to switch modes while the select mode is scanning for the char selection screen
#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8

;------------------------------------------------------------------------------------------
global gSettingsVersion := 1.9

;------------------------------------------------------------------------------------------
#Include %A_ScriptDir%\data\includes\debug.ahk

;------------------------------------------------------------------------------------------
#Include %A_ScriptDir%\data\includes\sapi.ahk
#Include %A_ScriptDir%\data\includes\localization.ahk
#Include %A_ScriptDir%\data\includes\helpers.ahk

;------------------------------------------------------------------------------------------
global gManualOverride := false
global gHasSetup := false
global gHasSetupVersion := 0
global gHasSetupGametype := false
global gHasSetupRegion := false
global gHasSetupVoice := sap.Voice.GetDescription()
global gHasSetupLanguage := false
global gMenuBigStep := 10
global gCurrentMenuItem
global gMainMenu
global gMainMenuLanguage
global gMainMenuRegion
global gMainMenuVoice
global gMainMenuGametyp
global gNumberOfCharsOnCurrentRealm := -1
global gCharUIPositions
global gClassBoxes
global gGameUiWidgets
global gGameUiColors
global gServerNames
global gGenders
global gStartingZones
global gRaces
global gRealmLangs
global gEnterCharacterNameFlag := false
global gEnterCharacterNameSelectZoneFlag := false
global gDeleteCharacterNameFlag := false
global gIgnoreKeyPress := false
global gIsInitializing
global gIsChecking
global tPopupClosed
global Mode := -1
global gInQueue := false
global gOrgSapiVoiceObject


;------------------------------------------------------------------------------------------
ClearLogFile()
LoadSettings()
LoadLocalizationData()
SwitchToMode_1()

;------------------------------------------------------------------------------------------
gosub InitMenu
if(gHasSetup = false)
   {
      gHasSetupGametype := "Cata"
      gHasSetupRegion  := "enEN"
      gHasSetupLanguage := "USA"
      LoadData()
      gHasSetupGametype := false
      gHasSetupRegion  := false
      gHasSetupLanguage := false
   }
gosub InitMenuFirstStartLanguageMenu
gosub InitMenuFirstStartVoiceMenu
gosub InitMenuFirstStartGameTypeMenu
gosub InitMenuFirstStartRegionMenu

;------------------------------------------------------------------------------------------
#Include %A_ScriptDir%\data\includes\modes.ahk
#Include %A_ScriptDir%\data\includes\menus.ahk
#Include %A_ScriptDir%\data\includes\checks.ahk
#Include %A_ScriptDir%\data\includes\gameuihandling.ahk
#Include %A_ScriptDir%\data\includes\keybinds.ahk
#Include %A_ScriptDir%\data\includes\datahandling.ahk

