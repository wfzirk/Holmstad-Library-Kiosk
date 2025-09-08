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

run taskkill /IM chrome.exe

RegExMatch(A_OSVersion, "(\d+)\.(\d+)\.(\d+)", Ver)
if (Ver1 = 10) and (Ver3>=22000) {
	;MsgBox Windows 11
	return
}	
else if (Ver1 = 10) {
	;MsgBox  Windows 10
	run "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary
}	
else {
	;MsgBox  Windows ver
	run "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary
}

AhkFriendlyURL = https://www.librarything.com/catalog/HolmstadLibrary
Width = % A_ScreenWidth
Height = 50
;yPos = % A_ScreenHeight - A_ScreenHeight
yPos = 0
xPos = % A_ScreenWidth - Width

;Gui, Color, 46bfec
;TransColor =  ADD8E6			;light blue
TransColor =  D4D1C8
Gui, Color, %transColor%
Gui, Margin, 0, 0
; https://www.reddit.com/r/AutoHotkey/comments/vnvy3z/gui_left_click_image_to_launch_programwebsite/

; 🠄 🠔 🔙   🠈  🠊 ⟳ ↶ ↺

Gui, Font, s30
Gui, add, button, gleftArror  x0 y0 w50 h50, 🠔 
Gui, add, button, gopenLibrary x50 y0 w50 h50, ⟳
Gui, add, Text, x100 y0 w300 h50,
Gui, Add, Text, x400 y0 w%Width%-400 h%Height%, Holmstad Library Catalog

;Gui, add, Picture, gleftArror x0 y0 w50 h50, books.png
;Gui, Add, Picture, gleftArror x100 y0 w%Width%-100 h%Height%, books.png
Gui, +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow

Gui, Show, x%xPos% y%yPos%

;Gui, 2:Add, Progress, x0 y0 w50 h50 cFFFF66, 100


f1::
	msgbox % a_osversion
	return

^w::Gosub, GoodBy   ; Ctrl-w exit with password
!F4::return   	 	;  Disables Alt+F4
^!tab::return 	 	;  Disables Ctrl-Alt-Tab
!tab::return  	 	;  Disables Alt-Tab
^h::Gosub, openLibrary	; Ctrl-h  back to library
^x::Gosub, exitonly	; Ctrl-x exit

openLibrary:
	run https://www.librarything.com/catalog/HolmstadLibrary
	return

refreshArror:
	run https://www.librarything.com/catalog/HolmstadLibrary
	return

leftArror:
	run https://www.librarything.com/catalog/HolmstadLibrary
	return
	
exitonly:
	run taskkill /IM chrome.exe	
	exitApp


GoodBy:
	InputBox, password, Enter your Password,, HIDE,, 100

	Loop, {
		if (errorlevel = 1)
			return

		if (password = "700holm") {
			;MsgBox, The password is correct.
			run taskkill /IM chrome.exe
			shutdown, 0
			;exitApp
		} else if (password != "700holm") {
			MsgBox, The password is incorrect.
			;InputBox, password, Enter your Password,, HIDE,, 100
			return
		}
	}
	
	
; https://www.autohotkey.com/board/topic/44536-calling-functions-from-the-hotkey-command/

