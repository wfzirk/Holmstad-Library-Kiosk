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

run taskkill /IM chrome.exe
;run chrome.exe --kiosk -tab ;https://www.librarything.com/catalog/HolmstadLibrary
run chrome.bat

AhkFriendlyURL = https://www.librarything.com/catalog/HolmstadLibrary
Width = % A_ScreenWidth
Height = 50
yPos = % A_ScreenHeight - A_ScreenHeight
xPos = % A_ScreenWidth - Width

Gui, Color, 46bfec
Gui, Margin, 0, 0
; https://www.reddit.com/r/AutoHotkey/comments/vnvy3z/gui_left_click_image_to_launch_programwebsite/
Gui, Add, Picture, gopenLibrary x0 y0 w%Width% h%Height%, books.png
Gui, +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
;Gui, add, button, x0 y0 w100 h50, Home
;Gui Add,Picture,gInteractedWith w100 h100,Test.png
Gui, Show, x%xPos% y%yPos%


^w::Gosub, GoodBy     ; Ctrl-w exit with password
!F4::return   	 ;  Disables Alt+F4
^!tab::return 	 ;  Disables Ctrl-Alt-Tab
!tab::return  	 ;  Disables Alt-Tab
^h::Gosub, openLibrary	; Ctrl-h  back to library
^x::Gosub, exitonly	; Ctrl-x exit
^!Delete::return  ; Disables Ctrl+Alt+Delete   doesnt work
^+Esc::return    ; Disables Ctrl+Shift+Esc	doesnt work

openLibrary:
	;MsgBox, Back to library.
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

