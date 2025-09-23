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

run taskkill /IM chrome.exe

RegExMatch(A_OSVersion, "(\d+)\.(\d+)\.(\d+)", Ver)
if (Ver1 = 10) and (Ver3>=22000) {
	;MsgBox Windows 11
	return
}	
else if (Ver1 = 10) {
	;MsgBox  Windows 10
	run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary
}	
else {
	;MsgBox  Windows ver
	run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary
}

enable_mouse := True
toggle := 0

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


TransColor =  634644
Gui, Main: Color, %transColor%
Gui, Main: Margin, 0, 0
Gui, Main: -DPIScale			; make display match pixels
; https://www.reddit.com/r/AutoHotkey/comments/vnvy3z/gui_left_click_image_to_launch_programwebsite/


Gui, Main: Font, s24
Gui, Main: add, button, gleftArror  x%btn1_x% y0 w%btn_w% h%yHeight%, 🠔 
Gui, Main: add, button, gopenLibrary x%btn2_x% y0 w%btn_w% h%yHeight%, ⟳
Gui, Main: Add, Text, center x%txt2_x% y0 w%txt2_w% h%yHeight%, Holmstad Library Catalog
Gui, Main: add, button, gF1 x%btn3_x% y0 w%btn3_w% h%yHeight%, ? 
Gui, Main: +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
Gui, Main: Show, x%xPos% y%yPos%

; Create the popup menu by adding some items to it.
Menu, MyMenu, Add, Help, MenuHandler
Menu, MyMenu, Add, Search, MenuHandler
Menu, MyMenu, Add, About, MenuHandler

;SetTimer, CheckMouseHover, 200 ; Checks mouse position every 100 milliseconds

return  ; End of script's auto-execute section.

MenuHandler:
	;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
	Gui, menu: Destroy
	if (A_ThisMenuItem = "Help") {
		MsgBox help
		FileRead, html, menu.html
		Gui, menu: Add, ActiveX, x0 y0 w400 h600 vWB, HTMLfile  
		Gui, menu: +LastFound -Caption +AlwaysOnTop +ToolWindow -Border +Resize
		wb.write(html)
		gui, menu: Show, , Test
		
	}
	else if (A_ThisMenuItem = "About") {
		;MsgBox about
		file = Docs/kiosk.png
		color = FFFFFF ; White
		Gui, menu: Add, Picture, w800 h-1,  %file%  ; scale image
		Gui, menu: Color, %color%
		Gui, menu: +LastFound -Caption +AlwaysOnTop +ToolWindow -Border +Resize
		Gui, menu: Show, Center AutoSize, Picture Scaler
	} 
	else if (A_ThisMenuItem = "xSearch") {
		image = Docs/search.png
		Gui -DPIScale
		Gui Font, s15
		Loop 2 {
		 Gui Add, Pic , % "w882 " (A_Index = 1 ? "xm" : "x+m"), % image
		 Gui Add, Text, wp yp BackgroundTrans, % "Picture #" A_Index
		}
		Gui Show
	}
	else if (A_ThisMenuItem = "Search") {	
		;run, "C:\Program Files\Google\Chrome\Application\chrome.exe"   
		run, "https://wiki.librarything.com/index.php/%22Your_books%22_Search"
		
	}
	
	GuiClose:
	Guiescape:
	;Esc::Gui, menu: cancel
	
guisize:
	GuiControl, Move, mypic, % "w" . A_GuiWidth . " h" . A_GuiHeight
	winset redraw
	return
/*
F2::
    toggle := !toggle
    If toggle
		SetTimer, CheckMouseHover, 200 ; Checks mouse position every 100 milliseconds
	else 
		SetTimer, CheckMouseHover, Off
		ToolTip
	return
*/
F1::Menu, MyMenu, Show  ; show the menu.
^w::Gosub, GoodBy   	; Ctrl-w exit with password
!F4::return   	 		;  Disables Alt+F4
^!tab::return 	 		;  Disables Ctrl-Alt-Tab
!tab::return  	 		;  Disables Alt-Tab
^h::Gosub, openLibrary	; Ctrl-h  back to library
^x::Gosub, exitonly		; Ctrl-x exit

#If !enable_mouse
LButton::return
#If



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

