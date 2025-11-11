; You must include the Acc.ahk library in your script or ensure it's in a standard library location.
#Include Acc.ahk 


run taskkill /IM chrome.exe
run, "C:\Program Files\Google\Chrome\Application\chrome.exe"  --incognito  https://www.librarything.com/catalog/HolmstadLibrary


f1:: MsgBox % GetTextUnderMouse()

GetTextUnderMouse()
{
   Acc := Acc_ObjectFromPoint(child)
   try value := Acc.accValue(child)
   if Not value
      try value := Acc.accName(child)
   if (Acc.accRole(child) = 16)   ; pane
   {
      CoordMode, Mouse
      MouseGetPos, OutputVarX, OutputVarY, OutputVarWin
      loop
      {
         Acc := Acc.accParent
         if (Acc_WindowFromObject(Acc) != OutputVarWin)
            break
         try oChildren := Acc_Children(Acc)
         for _, oChild in oChildren
         {
            oCoords := Acc_Location(oChild)
            if (OutputVarX >= oCoords.x) and (OutputVarX <= oCoords.x + oCoords.w) and (OutputVarY >= oCoords.y) and (OutputVarY <= oCoords.y + oCoords.h)
            {
               try value := oChild.accValue(0)
               if Not value
                  try value := oChild.accName(0)
               try role := oChild.accRole(0)
               if (role != 16)  ; pane
                  break 2
            }
         }
      }
   }
   return value
}
