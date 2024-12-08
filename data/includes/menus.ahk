;------------------------------------------------------------------------------------------
;generic class for menu entries
;------------------------------------------------------------------------------------------
class baseMenuEntryObject
{
    name := "generic Name"
    type := ""
    parent := ""
    p := ""
    n := ""
    childs := []

    onSelect()
    {
		if (this.childs not or this.childs.MaxIndex() < 1)
		{
			tFinalString := this.name
			if(this.realmNumber != "")
			{
				tFinalString := this.realmNumber . " " . tFinalString
			}
			if(this.type != "")
			{
				tFinalString := tFinalString . ", " . this.type
			}
			PlayUtterance(tFinalString)
			return
		}
		this.childs[1].onEnter()
    }

    onEnter()
    {
		gCurrentMenuItem := this
		tFinalString := this.name
		if(this.realmNumber != "")
		{
			tFinalString := this.realmNumber . " " . tFinalString
		}
		if(this.type != "")
		{
			tFinalString := tFinalString . ", " . this.type
		}
		PlayUtterance(tFinalString)
    }

	onAction()
	{
		;MsgBox % this.name " generic"
	}
}

;------------------------------------------------------------------------------------------
InitMenu:
	global gCharUIPositions := {}
	global gRealmLangs := {}
	global gServerNames := {}
	global gGenders := {}
	global gRaces := {}

	LoadData()

	;build the audio menu
	;main
	gMainMenu := new baseMenuEntryObject
	gMainMenu.name := L["main menu"]
	gMainMenu.parent := ""
	gMainMenu.childs := []

	;menu item 1
	tMainItemN := 1
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["select character"]
	;UpdateCharacterMenu(false)

	;menu item 2
	tMainItemN := 2
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["login with selected character"]
	gMainMenuchilds2Action(this){
		tRGBColor := GetColorAtUiPos(9918, 705)
		if (IsColorRange(tRGBColor.r, 139) = true and IsColorRange(tRGBColor.g, 139) = true and IsColorRange(tRGBColor.b, 139) = true)
		{
			gMainMenu.childs[1].onEnter()
		}
		else
		{
			tmp := UiToScreen(gGameUiWidgets.loginButton.x, gGameUiWidgets.loginButton.y)
			MouseMove, tmp.X, tmp.Y, 0
			Send {Click}
		}
	}
	gMainMenu.childs[tMainItemN].onAction := Func("gMainMenuchilds2Action").Bind(gMainMenu.childs[tMainItemN])


	;menu item 3
	tMainItemN := 3
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["create new character"]
	gMainMenu.childs[tMainItemN].childs := []
		Loop, 2
		{
			tGenderNumber := A_Index
			gMainMenu.childs[tMainItemN].childs[tGenderNumber] := new baseMenuEntryObject
			gMainMenu.childs[tMainItemN].childs[tGenderNumber].parent := gMainMenu.childs[tMainItemN]
			gMainMenu.childs[tMainItemN].childs[tGenderNumber].name := gGenders[tGenderNumber].name
			gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs := []
			Loop % gRaces.MaxIndex()
			{
				tRaceNumber := A_Index
				gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber] := new baseMenuEntryObject
				gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].parent := gMainMenu.childs[tMainItemN].childs[tGenderNumber]
				gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].name := gRaces[tRaceNumber].name
				gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs := []
				tEntryCounter := 1
				Loop % gRaces[tRaceNumber].classes.MaxIndex()
				{
					tClassNumber := A_Index
					if(gRaces[tRaceNumber].classes[tClassNumber] != L["Not_available"])
					{
						gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter] := new baseMenuEntryObject
						gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].parent := gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber]
						gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].name := gRaces[tRaceNumber].classes[tClassNumber]
						gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs := {}
						Loop % gStartingZones.MaxIndex()
						{
							tZoneNumber := A_Index
							gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs[tZoneNumber] := new baseMenuEntryObject
							gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs[tZoneNumber].parent := gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter]
							gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs[tZoneNumber].name := gStartingZones[tZoneNumber].name
							gMainMenuchildsGenericCreateCharAction(this, genderNumber, raceNumber, classNumber, zoneNumber)
							{
								gNumberOfCharsOnCurrentRealm := GetNumberOfChars50(true)
	
								if(gNumberOfCharsOnCurrentRealm < 50)
								{
									gIgnoreKeyPress := true
									tmp := UiToScreen(gGameUiWidgets.ChatSelectionScreenCreateCharButton.x, gGameUiWidgets.ChatSelectionScreenCreateCharButton.y) ;cata
									;tmp := UiToScreen(-261, 686) ;classic
									MouseMove, tmp.X, tmp.Y, 0
									Send {Click}
	
									;wait for create screen
									tTimeout := 0
									while(IsCharCreationScreen() != true)
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
											return
										}
									}
	
									;check if race is locked
									tLockedRaces := GetLockedRaces()
									if(tLockedRaces[raceNumber] = true)
									{
										gIgnoreKeyPress := true

										PlayUtterance(L["this race is locked for your account. Try a different race."])
										
										WaitForX(3, 1000)
										Send {Esc}
										
										while IsCharSelectionScreen() != true
										{
											if(mode != 1)
											{
												return
											}
									
											if(A_Index > 30)
											{
												gEnterCharacterNameFlag := false
												gIgnoreKeyPress := false
												Fail()
												return
											}
											WaitForX(1, 500)

										}
										gIgnoreKeyPress := false
										gMainMenu.childs[3].onEnter()
										return
									}

									;race
									tmp := UiToScreen(gRaces[raceNumber].x, gRaces[raceNumber].y)
									MouseMove, tmp.X, tmp.Y, 0
									Send {Click}
									WaitForX(2, 500)
	
									;class
									tmp := UiToScreen(gClassBoxes[classNumber].x, gClassBoxes[classNumber].y)
									MouseMove, tmp.X, tmp.Y, 0
									Send {Click}
									WaitForX(2, 500)
	
									;gender
									tmp := UiToScreen(gGenders[genderNumber].x, gGenders[genderNumber].y)
									MouseMove, tmp.X, tmp.Y, 0
									Send {Click}
									WaitForX(2, 500)
	
									;random style
									/*
									tmp := UiToScreen(90, 737)
									MouseMove, tmp.X, tmp.Y, 0
									Send {Click}
									*/
	
									if(gHasSetupGametype = "Retail")
									{
										;click on preview
										WaitForX(2, 500)
										tmp := UiToScreen(-115,729)
										MouseMove, tmp.X, tmp.Y, 0
										Send {Click}
									}
	
									;enter char name and press enter or esc to abort
									gEnterCharacterNameFlag := true
									gEnterCharacterNameSelectZoneFlag := false
									if(gHasSetupGametype = "Retail")
									{
										gEnterCharacterNameSelectZoneFlag := zoneNumber
									}

									PlayUtterance(L["enter the name for the new character and press enter, or escape to cancel character creation."])
									WaitForX(5, 1000)
	
									gIgnoreKeyPress := false
								}
								else
								{
									PlayUtterance(L["Failed You already have the maximum number of character on this server."])
									WaitForX(4, 1000)
								}
								gIgnoreKeyPress := false
	
							}
							gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs[tZoneNumber].onAction := Func("gMainMenuchildsGenericCreateCharAction").Bind(gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter].childs[tZoneNumber], tGenderNumber, tRaceNumber, tClassNumber, tZoneNumber)
						}
						UpdateChilds(gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber].childs[tEntryCounter])
						tEntryCounter := tEntryCounter + 1
					}
				}
				UpdateChilds(gMainMenu.childs[tMainItemN].childs[tGenderNumber].childs[tRaceNumber])
			}
			UpdateChilds(gMainMenu.childs[tMainItemN].childs[tGenderNumber])
		}
		;we need to run the helper UpdateChilds once for every new sub menu, to set up prev/next menu item for all menu items on the given menu level
		UpdateChilds(gMainMenu.childs[tMainItemN])

		
	;menu item 4
	tMainItemN := 4
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["switch server"]
	gMainMenu.childs[tMainItemN].childs := []
		Loop % gRealmLangs.MaxIndex()
		{
			tLangNumber := A_Index
			gMainMenu.childs[tMainItemN].childs[tLangNumber] := new baseMenuEntryObject
			gMainMenu.childs[tMainItemN].childs[tLangNumber].parent := gMainMenu.childs[tMainItemN]
			gMainMenu.childs[tMainItemN].childs[tLangNumber].name := gRealmLangs[tLangNumber].name
			gMainMenu.childs[tMainItemN].childs[tLangNumber].type := gRealmLangs[tLangNumber].type
			gMainMenu.childs[tMainItemN].childs[tLangNumber].childs := []
				Loop % gServerNames[tLangNumber].MaxIndex()
				{
					tRealmNumber := A_Index
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber] := new baseMenuEntryObject
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber].parent := gMainMenu.childs[tMainItemN].childs[tLangNumber ]
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber].name := gServerNames[tLangNumber][tRealmNumber].name
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber].type := gServerNames[tLangNumber][tRealmNumber].type
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber].realmNumber := tRealmNumber
					gMainMenuchilds4ChildsXChildsYAction(this, langNumber, serverNumber)
					{
						gIgnoreKeyPress := true

						PlayUtterance(L["switching to server. please wait."])
						WaitForX(2, 1000)


						if(IsRealmQueue() == true)
						{
							;from queue
							;click on "select realm"
							tmp := UiToScreen(10194, 450)
							MouseMove, tmp.X, tmp.Y, 0
							Send {Click}

							;wait for realm selection screen
							tTimeout := 0
							while(IsRealmSelectionScreen() != true)
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
									return
								}
							}
						}
						else
						{
							;from css
							;test if on char selection screen
							if(IsCharSelectionScreen() != true)
							{
								;if not > init to char sel
								;Send {Esc}
								InitLogin()
							}

							;click on "select realm"
							tmp := UiToScreen(-191, 51)
							MouseMove, tmp.X, tmp.Y, 0
							Send {Click}

							;wait for realm selection screen
							tTimeout := 0
							while(IsRealmSelectionScreen() != true)
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
									return
								}
							}
						}

						;click on lang tab
						tmp := UiToScreen(gRealmLangs[langNumber].x, gRealmLangs[langNumber].y)
						MouseMove, tmp.X, tmp.Y, 0
						Send {Click}
						WaitForX(1, 500)

						;click on sort by type
						tmp := UiToScreen(9985, 168)
						MouseMove, tmp.X, tmp.Y, 0
						Send {Click}
						WaitForX(1, 500)

						;click on sort by name
						tmp := UiToScreen(9735, 168)
						MouseMove, tmp.X, tmp.Y, 0
						Send {Click}
						WaitForX(1, 500)

						if(IsRealmListScrollbar() == true)
						{
							tServersPerScrollPage := 20
							tServersPerScrollPageStep := 2
							if(gHasSetupGametype = "Classic")
							{
								tServersPerScrollPage := 17
								tServersPerScrollPageStep := 1
							}

							;click on server with scrollable list
							tmp := UiToScreen(9735, 368)
							MouseMove, tmp.X, tmp.Y, 0
							WaitForX(1, 500)

							Loop % (4)
							{
								Loop % (20)
								{
									Click, WheelUp
									Sleep, 30
								}
								WaitForX(1, 20)
							}

							tNumberOfFullPages := (Ceil(ObjMaxIndex(gServerNames[langNumber]) / tServersPerScrollPage) - 1)
							tServerOnPageNumber := (Ceil(serverNumber / tServersPerScrollPage))

							tEntryNumberInList := 0
							tNumberOfDownEntries := 0
							if(tServerOnPageNumber > tNumberOfFullPages)
							{
								tNumberOfDownEntries := ((tServerOnPageNumber - 2) * tServersPerScrollPage) + (serverNumber - (tNumberOfFullPages * tServersPerScrollPage))
								tEntryNumberInList := tServersPerScrollPage ;serverNumber - (tNumberOfFullPages * tServersPerScrollPage)
							}
							else
							{
								;full pages down
								tEntryNumberInList := serverNumber - ((tServerOnPageNumber - 1) * tServersPerScrollPage)
								tNumberOfDownEntries := ((tServerOnPageNumber - 1) * tServersPerScrollPage)
							}

							tNumberOfDownEntries := tNumberOfDownEntries / tServersPerScrollPageStep

							Loop % tNumberOfDownEntries
							{
								Click, WheelDown
								Sleep, 30
							}

							WaitForX(1, 100)

							tmp := UiToScreen(gServerNames[langNumber][serverNumber].x,(gServerNames[langNumber][tEntryNumberInList].y))
							if(tServerOnPageNumber > tNumberOfFullPages && serverNumber == ObjMaxIndex(gServerNames[langNumber]))
							{
								MouseMove, tmp.X, tmp.Y + 10, 0
							}
							else
							{
								MouseMove, tmp.X, tmp.Y, 0
							}

							WaitForX(1, 100)
							Send {Click}
							WaitForX(1, 500)
						}
						else
						{
							WaitForX(1, 500)
							;click on server with no scrollable list
							tmp := UiToScreen(gServerNames[langNumber][serverNumber].x,gServerNames[langNumber][serverNumber].y)
							MouseMove, tmp.X, tmp.Y, 0
							Send {Click}
						}


						;allowed?
						WaitForX(2, 500)
						if(Is21Popup() = true)
						{
							;nope :(
							PlayUtterance(L["Fail. Client is reporting incorrect language."])
							WaitForX(2, 1000)
							Send {Escape}
							Send {Escape}
							WaitForX(2, 500)
							;update number of characters
							UpdateCharacterMenu(true)

							gosub InitMenu
							UpdateCharacterMenu(false)

							;jump to char selection
							gMainMenu.onEnter()

							gIgnoreKeyPress := false
							return
						}


						;click on ok
						tmp := UiToScreen(gGameUiWidgets.ServerListOkButton.x, gGameUiWidgets.ServerListOkButton.y)
						MouseMove, tmp.X, tmp.Y, 0
						Send {Click}



						WaitForX(4, 500)
						if(IsHighPopServerWarning() = true)
						{
							tmp := UiToScreen(9810, 436)
							MouseMove, tmp.X, tmp.Y, 0
							Send {Click}
							WaitForX(1, 500)
						}

						MouseMove, tmp.X, tmp.Y - 100, 0

						WaitForX(4, 500)

						;click away any hc warning
						if(IsRealmQueue() != true)
						{
							WaitForX(4, 500)
							tmp := UiToScreen(9942, 442)
							MouseMove, tmp.X, tmp.Y, 0
							Send {Click}
						}
						WaitForX(4, 1000)

						;test if on char selection screen
						tTimeout := 0
						twiccounter := 20
						while(IsCharSelectionScreen() != true)
						{
							gosub CheckMode
							if(Mode != 1)
							{
								return
							}

							;test if queue
							if(IsRealmQueue() == true)
							{
								PlayUtterance(L["The server is full. You are in queue."])
								WaitForX(4, 1000)
								gosub InitQueueMenu
								return
							}
							else
							{
								if(IsCharCreationScreen() = true)
								{
									;not chars > back to char sel
									;tmp := UiToScreen(-160, 749)
									;MouseMove, tmp.X, tmp.Y, 0
									Send {Esc}
									WaitForX(1, 500)
								}

								tTimeout := tTimeout + 1
								WaitForX(1, 1500)
								if(tTimeout > 20)
								{
									Fail()
									return
								}
							}
						}

						;update number of characters
						UpdateCharacterMenu(true)

						PlayUtterance(L["switched to Server"])
						WaitForX(2, 500)

						gosub InitMenu
						UpdateCharacterMenu(false)

						;jump to char selection
						gMainMenu.childs[1].onEnter()

						gIgnoreKeyPress := false
					}
					gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber].onAction := Func("gMainMenuchilds4ChildsXChildsYAction").Bind(gMainMenu.childs[tMainItemN].childs[tLangNumber].childs[tRealmNumber], tLangNumber, tRealmNumber)
				}
			UpdateChilds(gMainMenu.childs[tMainItemN].childs[tLangNumber])
		}
		UpdateChilds(gMainMenu.childs[4])


	;menu item 5
	tMainItemN := 5
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["delete character"]
	gMainMenuchilds5Action(this){
		;tRGBColor := GetColorAtUiPos(-280, 724)
		tRGBColor := GetColorAtUiPos(gGameUiWidgets.CharSelectionScreenDeleteChar.x, gGameUiWidgets.CharSelectionScreenDeleteChar.y)
		;MsgBox % tRGBColor.r tRGBColor.g tRGBColor.b
		if (IsColorRange(tRGBColor.r, 255) = true and IsColorRange(tRGBColor.g, 0) = true and IsColorRange(tRGBColor.b, 0) = true)
		{
			;gMainMenu.childs[5].onEnter()
			;enter char name and press enter or esc to abort
			tmp := UiToScreen(gGameUiWidgets.CharSelectionScreenDeleteChar.x, gGameUiWidgets.CharSelectionScreenDeleteChar.y)
			MouseMove, tmp.X, tmp.Y, 0
			Send {Click}

			gDeleteCharacterNameFlag := true
			PlayUtterance(L["enter delete and press enter, or press escape to cancel the deleting process."])
			WaitForX(4, 1000)
			gIgnoreKeyPress := false
		}
	}
	gMainMenu.childs[tMainItemN].onAction := Func("gMainMenuchilds5Action").Bind(gMainMenu.childs[tMainItemN])


	;menu item 6 - voice
	tMainItemN := 6
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["select voice"]
	gMainMenu.childs[tMainItemN].childs := []

	voices := GetVoices()
	for k, v in voices
	{
		tVoiceNumber := A_Index
		gMainMenu.childs[tMainItemN].childs[tVoiceNumber] := new baseMenuEntryObject
		gMainMenu.childs[tMainItemN].childs[tVoiceNumber].parent := gMainMenu.childs[tMainItemN]
		gMainMenu.childs[tMainItemN].childs[tVoiceNumber].name := tVoiceNumber . ": " . v
		gMainMenuVoiceAction(this, voiceNumber, voiceName)
		{
			gIgnoreKeyPress := true

			SetToolVoiceByName(voiceName)
			WriteSettings(false)

			PlayUtterance(L["selected"])
			WaitForX(1, 500)
			gIgnoreKeyPress := false

			gCurrentMenuItem := gMainMenu
			gMainMenu.onEnter()
		}
		gMainMenu.childs[tMainItemN].childs[tVoiceNumber].onAction := Func("gMainMenuVoiceAction").Bind(gMainMenu.childs[tMainItemN].childs[tVoiceNumber], tVoiceNumber, v)

		;MsgBox %  tVoiceNumber . ": " . v
	}
	UpdateChilds(gMainMenu.childs[tMainItemN])


	;menu item 7
	tMainItemN := 7
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["select language"]
	gMainMenu.childs[tMainItemN].childs := []

	languages := GetLanguages()
	for k, v in languages
	{
		tLangNumber := A_Index
		gMainMenu.childs[tMainItemN].childs[tLangNumber] := new baseMenuEntryObject
		gMainMenu.childs[tMainItemN].childs[tLangNumber].parent := gMainMenu.childs[tMainItemN]
		gMainMenu.childs[tMainItemN].childs[tLangNumber].name := tLangNumber . ": " . v.name
		gMainMenuchilds7ChildsXChildsYAction(this, langNumber, code)
		{
			gIgnoreKeyPress := true

			;save the lang
			SetLanguage(code)
			WriteSettings(false)
			
			PlayUtterance(L["selected, restart script to apply"])
			WaitForX(2, 1000)
			gIgnoreKeyPress := false

			Reload
			;gCurrentMenuItem := gMainMenu
			;gMainMenu.onEnter()
		}
		gMainMenu.childs[tMainItemN].childs[tLangNumber].onAction := Func("gMainMenuchilds7ChildsXChildsYAction").Bind(gMainMenuLanguage.childs[tLangNumber], tLangNumber, v.code)
	}
	UpdateChilds(gMainMenu.childs[tMainItemN])


	;menu item 8
	tMainItemN := 8
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["select game type"]
	gMainMenu.childs[tMainItemN].childs := []
	tGametypes:= LoadGameTypesData()
	Loop % tGametypes.MaxIndex()
	{
		tLangNumber := A_Index
		gMainMenu.childs[tMainItemN].childs[tLangNumber] := new baseMenuEntryObject
		gMainMenu.childs[tMainItemN].childs[tLangNumber].parent := gMainMenu.childs[tMainItemN]
		gMainMenu.childs[tMainItemN].childs[tLangNumber].name := L[tGametypes[tLangNumber].name]
		gMainMenuchilds8ChildsXChildsYAction(this, langNumber, ganmeName)
		{
			gIgnoreKeyPress := true

			;save the voice
			global gHasSetupGametype := ganmeName
			global gHasSetup := true
			global gHasSetupVersion := gSettingsVersion

			WriteSettings(false)
			
			PlayUtterance(L["selected, restart script to apply"])
			WaitForX(2, 1000)
			gIgnoreKeyPress := false

			Reload
			;SwitchToMode_1()

			;gCurrentMenuItem := gMainMenu
			;gMainMenu.onEnter()
		}
		gMainMenu.childs[tMainItemN].childs[tLangNumber].onAction := Func("gMainMenuchilds8ChildsXChildsYAction").Bind(gMainMenuLanguage.childs[tLangNumber], tLangNumber, tGametypes[tLangNumber].name)
	}
	UpdateChilds(gMainMenu.childs[tMainItemN])

	;menu item 9
	tMainItemN := 9
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["select region"]
	gMainMenu.childs[tMainItemN].childs := []

	tRegions:= LoadRegionsData()
	for i, v in tRegions
	{
		tLangNumber := A_Index
		gMainMenu.childs[tMainItemN].childs[tLangNumber] := new baseMenuEntryObject
		gMainMenu.childs[tMainItemN].childs[tLangNumber].parent := gMainMenu.childs[tMainItemN]
		gMainMenu.childs[tMainItemN].childs[tLangNumber].name := L[tRegions[i].name]
		gMainMenuchilds9ChildsXChildsYAction(this, aMenuIndex, aRegionCode)
		{
			gIgnoreKeyPress := true

			;save the voice
			global gHasSetupRegion := aRegionCode
			global gHasSetup := true
			global gHasSetupVersion := gSettingsVersion

			WriteSettings(false)
			
			PlayUtterance(L["selected, restart script to apply"])
			WaitForX(2, 1000)
			gIgnoreKeyPress := false

			Reload
			;SwitchToMode_1()

			;gCurrentMenuItem := gMainMenu
			;gMainMenu.onEnter()
		}
		gMainMenu.childs[tMainItemN].childs[tLangNumber].onAction := Func("gMainMenuchilds9ChildsXChildsYAction").Bind(gMainMenuLanguage.childs[tLangNumber], tLangNumber, i)
	}
	UpdateChilds(gMainMenu.childs[tMainItemN])	

	;menu item 9 - version
	tMainItemN := 9
	gMainMenu.childs[tMainItemN] := new baseMenuEntryObject
	gMainMenu.childs[tMainItemN].parent := gMainMenu
	gMainMenu.childs[tMainItemN].name := L["Version"] . ": " . gSettingsVersion
	gMainMenu.childs[tMainItemN].childs := []

	UpdateChilds(gMainMenu)

	;gCurrentMenuItem = gMainMenu
	;gMainMenu.onEnter()

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
InitQueueMenu:
	if(gMainMenu.childs[1].name != L["switch server"])
	{
		LoadData()

		global gMainMenuBackup := gMainMenu


		global gMainMenu := new baseMenuEntryObject
		gMainMenu.name := L["main menu"]
		gMainMenu.parent := ""
		gMainMenu.childs := []


		;MsgBox % gMainMenuBackup.childs[4].name

		;menu item 1
		tMainItemN := 1
		gMainMenu.childs[tMainItemN] := gMainMenuBackup.childs[4]
		gMainMenu.childs[tMainItemN].parent := gMainMenu
		gMainMenu.childs[tMainItemN].name := L["switch server"]
		UpdateChilds(gMainMenu.childs[1])

		UpdateChilds(gMainMenu)

		gCurrentMenuItem := gMainMenu
		gMainMenu.onEnter()
	}

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
InitMenuFirstStartVoiceMenu:
	gIgnoreKeyPress := true

	gMainMenuVoice := new baseMenuEntryObject
	gMainMenuVoice.name := L["go right to select a voice"]
	gMainMenuVoice.parent := ""
	gMainMenuVoice.childs := []

	voices := GetVoices()
	for k, v in voices
	{
		tVoiceNumber := A_Index
		gMainMenuVoice.childs[tVoiceNumber] := new baseMenuEntryObject
		gMainMenuVoice.childs[tVoiceNumber].parent := gMainMenuVoice
		gMainMenuVoice.childs[tVoiceNumber].name := tVoiceNumber . ": " . v
		InitMenuFirstStartVoiceMenu(this, voiceNumber, voiceName)
		{
			gIgnoreKeyPress := true

			SetToolVoiceByName(voiceName)
			PlayUtterance(L["selected"])
			WaitForX(1, 500)

			gIgnoreKeyPress := false

			gCurrentMenuItem := gMainMenuLanguage
			gMainMenuLanguage.onEnter()
		}
		gMainMenuVoice.childs[tVoiceNumber].onAction := Func("InitMenuFirstStartVoiceMenu").Bind(gMainMenuVoice.childs[tVoiceNumber], tVoiceNumber, v)
	}

	UpdateChilds(gMainMenuVoice)

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
InitMenuFirstStartLanguageMenu:
	gIgnoreKeyPress := true

	gMainMenuLanguage := new baseMenuEntryObject
	gMainMenuLanguage.name := L["go right to select a language"]
	gMainMenuLanguage.parent := ""
	gMainMenuLanguage.childs := []

	languages := GetLanguages()
	for k, v in languages
	{
		tLangNumber := A_Index
		gMainMenuLanguage.childs[tLangNumber] := new baseMenuEntryObject
		gMainMenuLanguage.childs[tLangNumber].parent := gMainMenuLanguage
		gMainMenuLanguage.childs[tLangNumber].name := tLangNumber . ": " . L[v.name]
		gMainMenuLanguageAction(this, langNumber, code)
		{
			gIgnoreKeyPress := true

			SetLanguage(code)
			gosub InitMenuFirstStartRegionMenu
			gosub InitMenuFirstStartGameTypeMenu
			gosub InitMenu
			
			PlayUtterance(L["selected"])
			WaitForX(1, 500)

			gIgnoreKeyPress := false

			gCurrentMenuItem := gMainMenuRegion
			gMainMenuRegion.onEnter()
		}
		gMainMenuLanguage.childs[tLangNumber].onAction := Func("gMainMenuLanguageAction").Bind(gMainMenuLanguage.childs[tLangNumber], tLangNumber, v.code)
	}

	UpdateChilds(gMainMenuLanguage)

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
InitMenuFirstStartRegionMenu:
	tRegions := LoadRegionsData()

	gIgnoreKeyPress := true

	gMainMenuRegion := new baseMenuEntryObject
	gMainMenuRegion.name := L["go right to select a region"]
	gMainMenuRegion.parent := ""
	gMainMenuRegion.childs := []

	for i, v in tRegions
	{
		tMenuIndex := A_Index
		gMainMenuRegion.childs[tMenuIndex] := new baseMenuEntryObject
		gMainMenuRegion.childs[tMenuIndex].parent := gMainMenuRegion
		gMainMenuRegion.childs[tMenuIndex].name := L[tRegions[i].name]
		gMainMenuRegionAction(this, aMenuIndex, aRegionCode)
		{
			gIgnoreKeyPress := true

			global gHasSetupRegion := aRegionCode
			WriteSettings(false)

			gIgnoreKeyPress := false

			PlayUtterance(L["selected"])
			WaitForX(1, 500)

			gIgnoreKeyPress := false

			gCurrentMenuItem := gMainMenuGametyp
			gMainMenuGametyp.onEnter()
			
		}
		gMainMenuRegion.childs[tMenuIndex].onAction := Func("gMainMenuRegionAction").Bind(gMainMenuRegion.childs[tMenuIndex], tMenuIndex, i)
	}

	UpdateChilds(gMainMenuRegion)

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
InitMenuFirstStartGameTypeMenu:
	tGametypes:= LoadGameTypesData()

	gIgnoreKeyPress := true

	gMainMenuGametyp := new baseMenuEntryObject
	gMainMenuGametyp.name := L["go right to select a game type"]
	gMainMenuGametyp.parent := ""
	gMainMenuGametyp.childs := []

	Loop % tGametypes.MaxIndex()
	{
		tGameNumber := A_Index
		gMainMenuGametyp.childs[tGameNumber] := new baseMenuEntryObject
		gMainMenuGametyp.childs[tGameNumber].parent := gMainMenuGametyp
		gMainMenuGametyp.childs[tGameNumber].name := L[tGametypes[tGameNumber].name]
		gMainMenuGametypAction(this, gameNumber, gameName)
		{
			gIgnoreKeyPress := true

			global gHasSetupGametype := gameName
			global gHasSetup := true
			global gHasSetupVersion := gSettingsVersion

			WriteSettings(false)
			LoadData()
			WaitForX(2, 500)
			

			gIgnoreKeyPress := false
			
			PlayUtterance(L["Setup completed. Start the game now."])
			WaitForX(4, 500)

			gCurrentMenuItem := gMainMenu
			;gMainMenu.onEnter()
		}
		gMainMenuGametyp.childs[tGameNumber].onAction := Func("gMainMenuGametypAction").Bind(gMainMenuGametyp.childs[tGameNumber], tGameNumber, tGametypes[tGameNumber].name)
	}

	UpdateChilds(gMainMenuGametyp)

	gIgnoreKeyPress := false
return

;------------------------------------------------------------------------------------------
gMainMenuchilds1ChildsXGenericAction(this, charNumber) ;unfortunately this ugly helper is required as ahk can't directly assign funcs to variables/objects :(
{
	gIgnoreKeyPress := true

	tCharSlots := gCharUIPositions

	tIMode := mode

	tmp := UiToScreen(-10, 10)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200

	tSpeed := 266
	oldTick := 0

	;go down until first slot is selected > on first char
	tCount := 0
	tResult := false
	while(tResult != true and tCount <= 50)
	{
		tCount := tCount + 1
		Send {down}
		OutputDebug % "first round: " . tCount
		if(tCount > oldTick + 2)
		{
			WaitForX(1, tSpeed)
			oldTick := tCount
		}
		else
		{
			sleep % tSpeed	
		}
		tResult := IsWhiteUI(tCharSlots[1].x,tCharSlots[1].y)
		sleep, 200
	}

	tCount := 0
	sleep, 66
	Loop % (charNumber - 1)
	{
		Send {Down}
		sleep, 66
		if((tCount / 10) - Ceil(tCount / 10) == 0)
		{
			mode := 1
			WaitForX(1, 100)
			mode := tIMode
		}
	}

	gIgnoreKeyPress := false

	PlayUtterance(L["character"] . " " . charNumber . " " . L["selected"])
	WaitForX(3, 500)

	gMainMenu.childs[2].onEnter()
}

;------------------------------------------------------------------------------------------
UpdateCharacterMenu(aSilent)
{
	WaitForX(1, 100)
	gNumberOfCharsOnCurrentRealm := GetNumberOfChars50(aSilent)
	tMainItemN := 1
	
	gMainMenu.childs[tMainItemN].childs := []
	if(gNumberOfCharsOnCurrentRealm = 0)
	{
		gMainMenu.childs[tMainItemN].childs[1] := new baseMenuEntryObject
		gMainMenu.childs[tMainItemN].childs[1].parent := gMainMenu.childs[tMainItemN]
		gMainMenu.childs[tMainItemN].childs[1].name := L["Empty - No characters on this server."]
	}
	else
	{
		Loop % gNumberOfCharsOnCurrentRealm
		{
			if(Mode != 1)
			{
				break
				return
			}
			if(A_Index <= gNumberOfCharsOnCurrentRealm)
			{
				gMainMenu.childs[tMainItemN].childs[A_Index] := new baseMenuEntryObject
				gMainMenu.childs[tMainItemN].childs[A_Index].parent := gMainMenu.childs[tMainItemN]
				gMainMenu.childs[tMainItemN].childs[A_Index].name := A_Index
				gMainMenu.childs[tMainItemN].childs[A_Index].onAction := Func("gMainMenuchilds1ChildsXGenericAction").Bind(gMainMenu.childs[tMainItemN].childs[A_Index], A_Index)
			}
		}
	}

	UpdateChilds(gMainMenu.childs[tMainItemN])
}

;------------------------------------------------------------------------------------------
UpdateChilds(menuObj)
{
	Loop % menuObj.childs.MaxIndex()
	{
		if (A_Index = 1)
		{
			menuObj.childs[1].n := menuObj.childs[2]
		}
		else if (A_Index = menuObj.childs.MaxIndex())
		{
			menuObj.childs[A_Index].p := menuObj.childs[A_Index - 1]
		}
		else
		{
			menuObj.childs[A_Index].p := menuObj.childs[A_Index - 1]
			menuObj.childs[A_Index].n := menuObj.childs[A_Index + 1]
		}
	}

	Loop % menuObj.childs.MaxIndex()
		{
			tp10 := A_Index - gMenuBigStep
			tn10 := A_Index + gMenuBigStep
			if(tp10 < 1)
			{
				tp10 := 1
			}
			if(tn10 > menuObj.childs.MaxIndex())
			{
				tn10 := menuObj.childs.MaxIndex()
			}
	
			menuObj.childs[A_Index].p10 := menuObj.childs[tp10]
			menuObj.childs[A_Index].n10 := menuObj.childs[tn10]
		}	
}

;------------------------------------------------------------------------------------------
GetNumberOfChars50(silent)
{
	tmp := UiToScreen(-10, 10)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200

	tCount := 0

	if(gHasSetupGametype == "Retail")
		{
			tCount := GetNumberOfChars50Retail(silent)
		}
	else
		{
			tCount := GetNumberOfChars50Classic(silent)
		}		

	return tCount
}

;------------------------------------------------------------------------------------------
GetNumberOfChars50Retail(silent)
{
	tmp := UiToScreen(-10, 10)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200

	;try filling empty favorite slots
	UpdateFavoriteSlots()

	tCount := GetNumberOfChars50Classic(silent)

	return tCount
}

;------------------------------------------------------------------------------------------
GetNumberOfChars50Classic(silent)
{
	tmp := UiToScreen(-10, 10)
	MouseMove, tmp.X, tmp.Y, 0
	sleep, 200

	gIgnoreKeyPress := true

	tCharSlots := gCharUIPositions

	tSpeed := 266

	oldTick := 0

	;go down until first slot is selected > on first char
	tCount := 0
	tResult := false
	while(tResult != true and tCount <= 50)
	{
		tCount := tCount + 1
		Send {down}
		OutputDebug % "first round: " . tCount
		if(tCount > oldTick + 2)
		{
			WaitForX(1, tSpeed)
			oldTick := tCount
		}
		else
		{
			sleep % tSpeed	
		}
		tResult := IsWhiteUI(tCharSlots[1].x,tCharSlots[1].y)
		sleep, 200
	}
	
	if(tCount > 50)
	{
		if(silent != true)
		{
			PlayUtterance(L["you don't have any characters on the selected server"])
			WaitForX(1, 2500)
		}
		return 0
	}
	
	oldTick := 0

	;go down until first slot is selected > number of chars
	tCount := 0
	tResult := false
	while(tResult != true and tCount <= 50)
	{
		tCount := tCount + 1
		Send {down}
		OutputDebug % "second round: " . tCount
		OutputDebug % "oldTick: " . oldTick
		if(tCount > oldTick + 2)
		{
			WaitForX(1, tSpeed)
			oldTick := tCount
		}
		else
		{
			sleep % tSpeed	
		}
		tResult := IsWhiteUI(tCharSlots[1].x,tCharSlots[1].y)
		sleep, 200
	}
	OutputDebug % "result: " . tCount

	if(tCount > 50)
	{
		if(silent != true)
		{
			PlayUtterance(L["you don't have any characters on the selected server"])
			WaitForX(1, 2500)
		}
		return 0
	}

	if(silent != true)
	{
		PlayUtterance(L["character"] . " " . 1 . " " . L["selected"])
		WaitForX(2, 500)
	}

	gIgnoreKeyPress := false
	return tCount
}

;------------------------------------------------------------------------------------------
EnterCharacterNameHandler()
{
	gIgnoreKeyPress := true
	WaitForX(6, 500)

	tFoundSuccessOrFail := false

	while tFoundSuccessOrFail != true
	{
		if(mode != 1)
		{
			return
		}

		if(A_Index > 30)
		{
			gEnterCharacterNameFlag := false
			gIgnoreKeyPress := false
			Fail()
			return
		}

		if(gEnterCharacterNameFlag = true && gEnterCharacterNameSelectZoneFlag != false)
		{
			tmp := UiToScreen(gStartingZones[gEnterCharacterNameSelectZoneFlag].x, gStartingZones[gEnterCharacterNameSelectZoneFlag].y)
			MouseMove, tmp.X, tmp.Y, 0
			Send {Click}
			WaitForX(4, 1000)
			if(IsCharSelectionScreen() != true)
			{
				Send {Enter}
			}
		}

		WaitForX(1, 1000)

		;click away possible hardcore warning
		tmp := UiToScreen(9951,552)
		MouseMove, tmp.X, tmp.Y, 0
		Send {Click}
		WaitForX(1, 1000)


		if(IsCharSelectionScreen() = true)
		{
			;char created, we're back to char selection screen
			gEnterCharacterNameSelectZoneFlag := false
			gEnterCharacterNameFlag := false
			PlayUtterance(L["Character created"])
			WaitForX(3, 500)
			PlayUtterance(L["character number:"] . " " . (gNumberOfCharsOnCurrentRealm + 1))
			sleep 600

			tFoundSuccessOrFail := true
			WaitForX(4, 500)

			UpdateCharacterMenu(false)

			gMainMenu.onEnter()

			gIgnoreKeyPress := false
			return
		}
		else
		{
			if(gEnterCharacterNameFlag != false)
			{

				tNoSuccessButtonCheck := false
				tNoSuccessBackdropCheck := false

				If(IsCharCreationScreen() = true and (Is11Popup() = true or Is21Popup() = true))
				{
					tNoSuccessButtonCheck := true
				}

				If((IsCharCreationScreen() = true and gHasSetupGametype = "Retail" and  IsCharCreattionPreviewButtonDisabled() = true) || (IsCharCreationScreen() = true and (Is11Popup() = true or Is21Popup() = true)))
				{
					tNoSuccessButtonCheck := true
				}
	
				if((tNoSuccessButtonCheck = true) and IsCharSelectionScreen() = false)
				{
					;char name not available or no char name > retry
					tFoundSuccessOrFail := true

					Send {Enter}
					WaitForX(1, 300)
					send ^a
					WaitForX(1, 100)
					send ^{Backspace}
					WaitForX(1, 100)

					PlayUtterance(L["Failed. The name is not available, or the names format is not allowed."])
					WaitForX(4, 1000)
					PlayUtterance(L["enter the name for the new character and press enter, or escape to cancel character creation."])
					WaitForX(5, 1000)
}
			}
		}
	}
	gIgnoreKeyPress := false
}
;------------------------------------------------------------------------------------------
DeleteCharacterNameHandler()
{
	gIgnoreKeyPress := true
	WaitForX(6, 500)

	tFoundSuccessOrFail := false

	while tFoundSuccessOrFail != true
	{
		if(mode != 1)
		{
			return
		}

		if(A_Index > 40)
		{
			gDeleteCharacterNameFlag := false
			gIgnoreKeyPress := false
			Fail()
			return
		}
		WaitForX(1, 500)

		if(gDeleteCharacterNameFlag = true)
		{
			if(IsDeleteButtonDisabled() = true)
			{
				WaitForX(1, 300)
				send ^a
				WaitForX(1, 100)
				send ^{Backspace}
				WaitForX(1, 100)

				PlayUtterance(L["Deleting failed. Type delete again and press enter, or press escape to cancel the deleting process."])
				WaitForX(5, 1000)
				tFoundSuccessOrFail := true

			}
			else if(IsDeleteButtonEnabled() = true)
			{
				gDeleteCharacterNameFlag := false
				tmpScreen := UiToScreen(9796, 437)
				MouseMove, floor(tmpScreen.X), floor(tmpScreen.Y), 0
				PlayUtterance(L["character deleted"])
				Send {Click}
				WaitForX(3, 500)

				tFoundSuccessOrFail := true
				WaitForX(4, 500)

				UpdateCharacterMenu(false)
				gMainMenu.childs[1].onEnter()

				gIgnoreKeyPress := false
				return
			}
			else
			{
				tFoundSuccessOrFail := true
				WaitForX(4, 500)

				UpdateCharacterMenu(false)
				gMainMenu.childs[1].onEnter()

				gIgnoreKeyPress := false
				return
			}
		}
		else
		{
			tFoundSuccessOrFail := true
			WaitForX(4, 500)

			UpdateCharacterMenu(false)
			gMainMenu.childs[1].onEnter()

			gIgnoreKeyPress := false
			return
		}
	}
	gIgnoreKeyPress := false
}