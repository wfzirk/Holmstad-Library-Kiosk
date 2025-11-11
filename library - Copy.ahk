; https://stackoverflow.com/questions/4234242/disable-ctrl-alt-del-and-shutdown-for-kiosk
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6463
; https://www.irisclasson.com/2015/01/30/creating-a-dynamic-hotkey-window-overlay-with-autohotkey/

/*
	Symbol	Description
	#	Win (Windows logo key)
	!	Alt
	^	Control
	+	Shift
*/

;#Include Acc.ahk 
#Include OnWin.ahk


;#Persistent
#SingleInstance Force
#Warn

run taskkill /F /IMhe chrome.exe

StartChrome()

;enable_mouse := True
;SetTimer, ShowToolTip, 200 
;SetTimer, CheckMouseHover, 200 ; Checks mouse position every 100 milliseconds

xWidth = % A_ScreenWidth
yHeight = 52
yPos = 0
xPos = 0
	;0    100   200                           w-150
	;|----|----|---Holmstad Library Catalog---|---|
	; btn1 btn2             txt2  	           btn3
btn_w := 100
btn3_w := 150
btn1_x := 0			
btn2_x := 100
btn2_xa := 200
btn2_xb := 300
btn3_x := A_ScreenWidth - btn3_w
txt2_x = 150

txt2_w := xWidth - txt2_x - btn3_w

Gui, Main: Margin, 0, 0
Gui, Main: -DPIScale			; make display match pixels

Gui, Main: Font, s24, Arial
Gui, Main: Add, Text, center x0 y0 w%xWidth% h%yHeight%, Holmstad Library Catalog

Gui, Main: Font, s16, Arial
;Gui, Main: add, button, gF1  x%btn1_x% y0 w%btn_w% h%yHeight% , Admin

Gui, Main: add, button, gopenLibrary x%btn1_x% y0 w%btn_w% h%yHeight%, Home  ;⟳ 
Gui, Main: add, button, gBrowserBackFunction  x%btn2_x% y0 w%btn_w% h%yHeight%, Back ; ⬅ ; ← 
;Gui, Main: add, button, gopenLibrary x%btn2_xa% y0 w%btn_w% h%yHeight%, Home  ;⟳ 
;Gui, Main: add, button, gTags  x%btn2_xb% y0 w%btn3_w% h%yHeight% , Tags
Gui, Main: Font, s16, Arial

Gui, Main: add, button, gF1 x%btn3_x% y0 w%btn3_w% h%yHeight%, ? 	; add help
Gui, Main: +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
Gui, Main: Show, x%xPos% y%yPos%

HideTaskBar()	; hide taskbar 

;; Admin menu list
Menu, FileMenu, Add, Exit, MenuHandler
Menu, FileMenu, Add, PowerOff, MenuHandler

; Create the popup menu by adding some items to it.
Menu, MyMenu, Add, Help, MenuHandler
Menu, MyMenu, Add, About, MenuHandler

Menu, MyMenu  , Add
;Menu, Admin, Add, Exit, MenuHandler
;Menu, Admin, Add, PowerOff, MenuHandler
Menu, MyMenu  , Add, Admin, :FileMenu


Menu, FileMenu, Add, Exit, MenuHandler
Menu, FileMenu, Add, PowerOff, MenuHandler

return  ; End of script's auto-execute section.

MenuHandler:
	;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
	Gui, menu: Destroy

	Gui, menu: New, +Resize, %A_ThisMenuItem%
	if (A_ThisMenu = "MyMenu") {
		if (A_ThisMenuItem = "About") {
			Gui, menu: New, +Resize, %A_ThisMenuItem%	; Create the GUI window
			Gui, menu: Add, ActiveX, x0 y0 w600 h700 vWB1, Shell.Explorer
			Gui, menu: Show, 

			htmlPath := A_ScriptDir "/Docs/about.html"   	; Construct the full path to the HTML file
			WB1.Navigate(htmlPath)
			return
		}
		else if (A_ThisMenuItem = "Help") {
			Gui, menu: New, +Resize, %A_ThisMenuItem%	; Create the GUI window
			Gui, menu: Add, ActiveX, x0 y0 w700 h700 vWB1, Shell.Explorer
			Gui, menu: Show, 

			htmlPath := A_ScriptDir "/Docs/help.html"   	; Construct the full path to the HTML file
			WB1.Navigate(htmlPath)
			return
		}
		else if (A_ThisMenuItem = "Exit") {
			GoodBy(0)
		}
		else if (A_ThisMenuItem = "PowerOff") {
			GoodBy(4+8)
		}
	} else {
		if (A_ThisMenuItem = "Home") {
			run https://www.librarything.com/catalog/HolmstadLibrary
			Sleep, 100
			;send {f11}
			HideTaskBar()
			return
		}
		else if (A_ThisMenuItem = "Exit") {
			GoodBy(0)
		}
		else if (A_ThisMenuItem = "PowerOff") {
			GoodBy(4+8)
		}
	}
	
	GuiClose:
	Guiescape:
	Esc::Gui, menu: cancel

;F2::Menu, FileMenu, Show  ; show the menu.

;Esc::Gui, menu: Destroy ; end help
;^h::Gosub, openLibrary	; Ctrl-h  back to library

F1::Menu, MyMenu, Show   ; show the menu.
F3::ClearToolTip()   ;tooltip ,,,,9
F4::ShowToolTip()    ; Blah Boo, A_ScreenWidth - 100, 0, 9

^r::Gosub, BrowserBackFunction
^w::GoodBy(0)   	; Ctrl-w exit with password
!F4::return   	 		;  Disables Alt+F4
^!tab::return 	 		;  Disables Ctrl-Alt-Tab
!tab::return  	 		;  Disables Alt-Tab
^x::Gosub, exitonly		; Ctrl-x exit
LWin::Return		;disable win button

;chrome - get url under cursor
;q:: GetClipBoard()




/*
x::
	ControlFocus,, ahk_exe chrome.exe
	ControlSend,, {PgDn}, ahk_exe chrome.exe
	;MsgBox, pg down.
return

!x::
	if WinExist("ahk_exe chrome.exe"){
		WinActivate
		Sleep, 100
		SendInput, {PgDn}
		;MsgBox, pg down.
		
	}
return
*/

openLibrary:
	; Close all instances of Google Chrome
	;Process, Close, chrome.exe
	;run cookie.bat		; clear out Collections and search parms

	;run https://www.librarything.com/catalog/HolmstadLibrary
	StartChrome()

	return
	
	
/*
Tags:
	;run https://www.librarything.com/catalog/HolmstadLibrary
	run https://www.librarything.com/catalog_tags.php?view=HolmstadLibrary
	Return
*/

BrowserBackFunction:
	;MsgBox, browserback.
	ControlFocus,, ahk_exe chrome.exe
	sleep 50
	ControlSend,, !{Left}, ahk_exe chrome.exe	
	sleep 200
	ControlSend,, !{Left}, ahk_exe chrome.exe	; seems to work better if sending twice
	sleep 200
	ControlSend,, !{Left}, ahk_exe chrome.exe	; seems to work better if sending twice
    Return

exitonly:
	ShowTaskBar()				; enable taskbar
	;run taskkill /IM chrome.exe	
	; Close all instances of Google Chrome
	Process, Close, chrome.exe
	WinWaitClose, ahk_class Chrome_WidgetWin_1 ; Wait until all instances of Chrome are closed
	exitApp

;This displays a tool tip in the upper right hand corner of the screen
; Set the tooltip mode to screen coordinates
CoordMode tooltip, screen

ClearToolTip() {
	ToolTip ,,,,9
}

ShowToolTip() {
	Tooltip, %A_Cursor%, A_ScreenWidth - 100, 0, 9
	return
}

; Set the mouse mode to screen coordinates
CoordMode, Mouse, Screen
/*
#If GetMouseInDisabledArea()
LButton::return
#If

; Function to check if the mouse is in the disabled area
GetMouseInDisabledArea() {
    MouseGetPos, xp, yp

    ; Define your forbidden area here
    forbidden_x_start := 152
    forbidden_x_end := 1600
    forbidden_y_start := 60   ;108
    forbidden_y_end := 108    ;200
    
    if (xp >= forbidden_x_start and xp <= forbidden_x_end and yp >= forbidden_y_start and yp <= forbidden_y_end)
        return true
     return false
}
*/
; AutoHotkey script to toggle Windows Taskbar visibility
ShowTaskBar() {
	DetectHiddenWindows, On
    WinGet, TaskbarID, ID, ahk_class Shell_TrayWnd
	WinShow, ahk_id %TaskbarID%
}

HideTaskBar() {
	DetectHiddenWindows, On
    WinGet, TaskbarID, ID, ahk_class Shell_TrayWnd
	WinHide, ahk_id %TaskbarID%
}

StartChrome() {
	;run taskkill /IM chrome.exe	
	; Close all instances of Google Chrome
	Process, Close, chrome.exe
	;Sleep, 100
	RegExMatch(A_OSVersion, "(\d+)\.(\d+)\.(\d+)", Ver)
	if (Ver1 = 10) and (Ver3>=22000) {
		;MsgBox Windows 11
		return
	}	
	else if (Ver1 = 10) {
		;MsgBox  Windows 10
		;run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk  --incognito  https://www.librarything.com/catalog/HolmstadLibrary
		run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk  --incognito  https://www.librarything.com/catalog/HolmstadLibrary&viewstyle=6

		

	}	
	else {
		;MsgBox  Windows ver
		;run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk  --incognito https://www.librarything.com/catalog/HolmstadLibrary
		run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk  --incognito https://www.librarything.com/catalog/HolmstadLibrary&viewstyle=6
	}
}	
;https://www.librarything.com/catalog_bottom.php?view=HolmstadLibrary&viewstyle=1
;https://www.librarything.com/catalog_tags.php?view=HolmstadLibrary

GoodBy(sd){
	/* param value
    0 = Logoff
    1 = Shutdown
    2 = Reboot
    4 = Force
    8 = Power down
	*/
	InputBox, password, Enter your Password,, HIDE,, 100
	;MsgBox %sd%
	Loop, {
		if (errorlevel = 1)
			return
		if (password = "700holm") {
			;MsgBox, The password is correct.
			ShowTaskBar()
			;run taskkill /IM chrome.exe
			; Close all instances of Google Chrome
			Process, Close, chrome.exe
			WinWaitClose, ahk_class Chrome_WidgetWin_1 ; Wait until all instances of Chrome are closed

			shutdown, sd
			;exitApp
		} else if (password != "700holm") {
			MsgBox, The password is incorrect.
			;InputBox, password, Enter your Password,, HIDE,, 100
			return
		}
	}
}

/*
; block urls
#If A_Cursor = "Unknown" ; This condition might need adjustment based on your browser and A_Cursor output
LButton::
    ; Prevent the default action (opening the URL)
    Return

    ; Optional: Perform an alternative action, e.g., copy link to clipboard
    ; Send {RButton} ; Simulate right-click
    ; Sleep, 100 ; Wait for context menu to appear
    ; Send {Down 9} ; Adjust number of Down presses to reach "Copy link address"
    ; Send {Enter}
    ; Sleep, 100
    ; MsgBox, The URL "%Clipboard%" was copied to the clipboard.
#If ; End the #If directive
*/

; https://www.autohotkey.com/board/topic/44536-calling-functions-from-the-hotkey-command/

