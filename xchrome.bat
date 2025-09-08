
goto win10

taskkill /IM chrome.exe
rem chrome.exe --kiosk -tab https://www.librarything.com/catalog/HolmstadLibrary

rem if win 7
:win7
rem "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary

rem if win10
:win10
"C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary

rem "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --kiosk https://www.librarything.com/catalog/HolmstadLibrary

rem "C:\Program Files\Mozilla Firefox\firefox.exe"  --kiosk https://www.librarything.com/catalog/HolmstadLibrary
goto exit

:exit 
quit