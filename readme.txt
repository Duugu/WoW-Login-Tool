WoW Login Tool - Version 1.1

IMPORTANT: Excactly follow the instructions below to set up the tool, or it won't work.

Getting help: https://discord.gg/FsfKeqxZV4

# Setting up the tool
1. Open the folder "CopyTheContentOfThisFolderToInterface" in your downloaded WoW Login Tool folder. There should be 5 folders in that folder ("BUTTONS", "DialogFrame", etc.).
2. Copy all 5 folders.
3. Go to the WoW game files. Depening on your setup this could be "C:\Program Files (x86)\World of Warcraft".
4. In the WoW game files open the folder for the game version you would like to play:
	- for Wrath of the Lich King open "_classic_"
	- for Retail open "_retail_"
	- for Classic Era open "_classic_era_"
5. In that folder open the Interface folder.
6. Paste the 5 folders you've copied in step 2 in that Interface folder. Caution: overwrite all existing files and folders, if there are any!
7. Start the tool: go to your WoW Login Tool folder and start the file named START.ahk.
8. There will be a setup on first start. Choose the correct settings for and follow the instructions.
9. You're done.

# What is the tool doing?
The tool will start in "Pause mode", doing nothing. It is getting active if it is detecting the game window.
The tool has two modes: "Login" and "Play". Depending on if you are on the login screen or in the game world, the tool will auto switch modes. You can manually switch them with ALT + F1.
In "Login" mode, you can select characters and enter the game world with them, create new characters, change the server or delete characters.
In "Play" mode, you can use the NUMPAD 7 to do a left click at your feet in the game world or NUMPAD 8 to do a right click.
Use ALT + ESCAPE to terminate the script.

# Shortcuts
right/left/up/down arrow: navigate one entry right/left/etc. in the audio menu
page up/down: navigate ten entries up/down in the audio menu
enter: execute the current audio menu entry
alt + escape: terminate the tool
alt + f1: switch mode

# Updating the tool
Go to https://duugu.github.io/Sku and check in the Updates section of that page if there is an update. Download the update, and complete the steps in "Setting up the tool" above.

# Resetting the tool
1. Terminate the tool, if it is running (alt + escape).
2. Open the folder "data" in your WoW Login Tool folder.
3. Delete the file named setting.ini
4. Start the tool. The setup will start.

# What's new for experience wow menu users
- The tool is for all WoW game versions: Wrath, Retail and Classic Era
- There is only a single tool for all game flavors, regions and languages. The tool will lead you though a quick setup to select the correct game, region, etc. on first start.
- The tool is (or can be) localized to all languages that are supported by the game.
- Page down/up is navigating 10 entries down/up in menus.
- The audio output is via SAPI.

# Providing translations
Open the Excel spreadsheet data\localization\translations.xlsx in your WoW Login Tool folder, and follow the instructions on the Instructions tab.

# Release notes
	r1.1
		- French translation added
	r1.0
		- Initial release

