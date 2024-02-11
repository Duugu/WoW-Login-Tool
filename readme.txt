WoW Login Tool - Version 1.1

IMPORTANT: Follow the instructions below to set up the tool, otherwise it won't work.

Get help: https://discord.gg/FsfKeqxZV4

# Setting up the tool
1. Open the "CopyTheContentOfThisFolderToInterface" folder in the WoW Login Tool folder you downloaded. There should be 5 folders in this folder ("BUTTONS", "DialogFrame", etc.).
2. Copy all 5 folders.
3. Browse to the WoW game files. Depending on your setup, this could be "C:\Program Files (x86)\World of Warcraft".
4. In the WoW game files, open the folder for the version of the game you want to play:
	- for Wrath of the Lich King, open "_classic_"
	- for Retail open "_retail_"
	- for Classic Era open "_classic_era_"
5. Inside this folder, open the Interface folder.
6. Paste the 5 folders you copied in step 2 into the Interface folder. Important: overwrite any existing files and folders!
7. Run the tool: Go to your WoW Login Tool folder and run the file named START.ahk.
8. There will be a setup on the first start. Choose the correct settings and follow the instructions.
9. You're done.

# What does the tool do?
The tool adds audio accessibility to the World of Warcraft login experience. It provides an audio interface for creating characters, choosing servers, etc. 
The tool has three modes: Pause, Login and Play. 
When you start the tool, it will be in Pause mode, waiting in the background and doing nothing.
When it detects the World of Warcraft game window, i.e. when you start the game or tab into the game that's already running, it becomes active and initialises.
The tool will automatically switch modes depending on whether you are in the login screen or the game world. 
In Login mode, you can use an audio menu to select characters and enter the game world, create new characters, change servers, or delete characters.
In Play mode, you can use NUMPAD 7 to left-click at your feet in the game world, or NUMPAD 8 to right-click.

# Using the tool
Important: Do not press any keys while the tool is working (it will play the blip, blip sound). Do not move the mouse or click while the tool is running.
Run START.ahk from the tools folder. The first time you start it, it will ask you to do a quick setup.
Use the left/right arrow keys to navigate to the submenu of an item.
Use the up/down arrow keys to navigate to the previous/next item in the audio menu.
Use the Enter key to choose/execute a menu item.
To exit the tool, press alt + escape.
Each time you tab out of the game (Pause mode) and back in (Login mode), the tool needs to initialise. This is by design. Just wait for the audio menu to come up.

# Keys
Right/left/up/down arrows: navigate one entry right/left/etc. in the audio menu
Page up/down: navigate ten entries up/down in the audio menu
Enter: execute current audio menu item
Alt + escape: terminate the tool
Alt + f1: switch mode

# Updating the tool
Go to https://duugu.github.io/Sku and check the Updates section of this page to see if there is an update available. Download the update and follow the steps in "Setting up the tool" above.

# Resetting the tool
1. Exit the tool if it is running (alt + escape).
2. Open the "data" folder in your WoW Login Tool folder.
3. Delete the file setting.ini.
4. Launch the tool. The setup will start.

# What's new for experienced wow menu users
- The tool works for all versions of the game: Wrath, Retail and Classic Era
- There is only one tool for all game versions, regions and languages. The tool will guide you through a quick setup to select the correct game, region, etc. on first start.
- The tool is (or can be) localised for all languages supported by the game.
- Page up/down navigates 10 items up/down in menus.
- Audio output is via SAPI.

# Providing translations
Open the Excel spreadsheet data\localization\translations.xlsx in your WoW Login Tool folder and follow the instructions on the Instructions tab.

# Release Notes
	r1.1
		- Initial release