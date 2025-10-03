; https://stackoverflow.com/questions/4234242/disable-ctrl-alt-del-and-shutdown-for-kiosk
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6463
; https://www.irisclasson.com/2015/01/30/creating-a-dynamic-hotkey-window-overlay-with-autohotkey/

;Symbol	Description
;#	Win (Windows logo key)
;!	Alt
;^	Control
;+	Shift



#Include OnWin.ahk

;#Persistent
#SingleInstance Force
#Warn

run taskkill /F /IMhe chrome.exe

RegExMatch(A_OSVersion, "(\d+)\.(\d+)\.(\d+)", Ver)
if (Ver1 = 10) and (Ver3>=22000) {
	;MsgBox Windows 11
	return
}	
else if (Ver1 = 10) {
	;MsgBox  Windows 10
	run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk  https://www.librarything.com/catalog/HolmstadLibrary
}	
else {
	;MsgBox  Windows ver
	run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary
}


;enable_mouse := True
;toggle := 0

xWidth = % A_ScreenWidth
yHeight = 52
yPos = 0
xPos = 0
					;0    50   100                                           w-150
btn_w := 50			;|----|----|------------Holmstad Library Catalog---------|----|
btn1_x := 0			; btn1 btn2             txt2     					      btn3
btn2_x := 50
btn3_w := 150
btn3_x := A_ScreenWidth - btn3_w
txt2_x = 100
txt2_w := xWidth - txt2_x - btn3_w

Gui, Main: Margin, 0, 0
Gui, Main: -DPIScale			; make display match pixels

Gui, Main: Font, s16, Arial
Gui, Main: add, button, gF2  x%btn1_x% y0 w%btn_w% h%yHeight%, File
Gui, Main: Font, s24, Arial
Gui, Main: add, button, gopenLibrary x%btn2_x% y0 w%btn_w% h%yHeight%, ↷
Gui, Main: Add, Text, center x%txt2_x% y0 w%txt2_w% h%yHeight%, Holmstad Library Catalog
Gui, Main: add, button, gF1 x%btn3_x% y0 w%btn3_w% h%yHeight%, ? 
Gui, Main: +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
Gui, Main: Show, x%xPos% y%yPos%

HideTaskBar()	; hide taskbar 


;; file/home menu list
Menu, FileMenu, Add, Home, MenuHandler
Menu, FileMenu, Add, Exit, MenuHandler
Menu, FileMenu, Add, PowerOff, MenuHandler



; Create the popup menu by adding some items to it.
Menu, MyMenu, Add, Help, MenuHandler
Menu, MyMenu, Add, About, MenuHandler

;SetTimer, CheckMouseHover, 200 ; Checks mouse position every 100 milliseconds

return  ; End of script's auto-execute section.

;CloseButton:
;	Gui, menu: Destroy
	
MenuHandler:
	;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
	Gui, menu: Destroy
	;MsgBox %A_WorkingDir%
	;Gui, menu: New, hwndhGui AlwaysOnTop Resize MinSize
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
			Gui, menu: Add, ActiveX, x0 y0 w600 h700 vWB1, Shell.Explorer
			Gui, menu: Show, 

			htmlPath := A_ScriptDir "/Docs/help.html"   	; Construct the full path to the HTML file
			WB1.Navigate(htmlPath)
			return
		}
	} else {
		if (A_ThisMenuItem = "Home") {
			run https://www.librarything.com/catalog/HolmstadLibrary
			Sleep, 100
			send {f11}
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

guisize:
	GuiControl, Move, mypic, % "w" . A_GuiWidth . " h" . A_GuiHeight
	winset redraw
	return

F2::Menu, FileMenu, Show  ; show the menu.

^r::Gosub, BrowserBackFunction
;Esc::Gui, menu: Destroy ; end help
F1::Menu, MyMenu, Show  ; show the menu.
^w::GoodBy(0)   	; Ctrl-w exit with password
!F4::return   	 		;  Disables Alt+F4
^!tab::return 	 		;  Disables Ctrl-Alt-Tab
!tab::return  	 		;  Disables Alt-Tab
^h::Gosub, openLibrary	; Ctrl-h  back to library
^x::Gosub, exitonly		; Ctrl-x exit




openLibrary:
	run https://www.librarything.com/catalog/HolmstadLibrary
	;Sleep, 100
	;send {f11}
	;Sleep, 100
	return

refreshArror() {
	run https://www.librarything.com/catalog/HolmstadLibrary
	Sleep, 100
	send {f11}
	return
}

BrowserBackFunction:
	Send, !{Left}
	;Sendinput, !{Left}
	;ControlFocus,, ahk_exe chrome.exe
	;Sleep, 100
	;ControlSend,, {!Left}, ahk_exe chrome.exe
    Return

exitonly:
	run taskkill /IM chrome.exe	
	exitApp

; Set coordinate mode for mouse and screen to be consistent
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

/*
CheckMouseHover:
	CoordMode, Mouse, Screen  ; Set coordinate mode to screen
	;searchImage = Docs/plus.png
	OutputVar = ""
	MouseGetPos, mouseX, mouseY
	PixelGetColor, Color, %mouseX%, %mouseY%, RGB
	;StatusBarGetText, OutputVar, ControlName, WinTitle
	;StatusBarGetText,%OutputVar%    ;, ,ahk_class  Chrome_WidgetWin_1
	;ToolTip,  mx:%mouseX% my:%mouseY% %A_Cursor% %Color% `n%tooltipContent%
	;if (mouseX > 1777 && mouseX < 1833 && mouseY > 210  && A_Cursor = "Unknown") {
	if (Color = 0x00C801 && mouseX > 1777 &&  A_Cursor = "Unknown") {
        enable_mouse := False
	} else {
        enable_mouse := True
	}
	ToolTip,  mx:%mouseX% `nmy:%mouseY% `n%A_Cursor% `n%enable_mouse% `n%Color%  `n%OutputVar%
Return	
*/


; AutoHotkey script to toggle Windows Taskbar visibility
HideTaskBar(){  ;toggle hide/show
    DetectHiddenWindows, On
    WinGet, TaskbarID, ID, ahk_class Shell_TrayWnd
    if WinExist("ahk_id " . TaskbarID)
    {
        WinGet, Style, Style, ahk_id %TaskbarID%
        if (Style & 0x10000000) ; WS_VISIBLE flag
        {
            WinHide, ahk_id %TaskbarID%
        }
        else
        {
            WinShow, ahk_id %TaskbarID%
        }
    }
	return
}

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
			run taskkill /IM chrome.exe
			shutdown, sd
			;exitApp
		} else if (password != "700holm") {
			MsgBox, The password is incorrect.
			;InputBox, password, Enter your Password,, HIDE,, 100
			return
		}
	}
}
	
; https://www.autohotkey.com/board/topic/44536-calling-functions-from-the-hotkey-command/

