
#SingleInstance Force
SetTitleMatchMode, 2

InputBoxX := 1588
InputBoxY := 763
JoinButtonX := 1659
JoinButtonY := 891
; ----------------------------------------------------------------<3
ApexWindowTitle := "Apex Legends"

DelayBetweenAttempts := 1500 ; milliseconds (1 second, as requested)

F9::
{
    if !WinActive(ApexWindowTitle)
    {
        MsgBox, 48, Not Focused, Apex Legends must be the active window to start. Alt-tab into the game and press F9 again.
        return
    }

    codesFile := A_ScriptDir . "\codes.txt"
    if !FileExist(codesFile)
    {
        MsgBox, 16, Missing File, Could not find codes.txt in %A_ScriptDir%. Create it with one code per line.
        return
    }

    FileRead, fileContents, %codesFile%
    if (ErrorLevel)
    {
        MsgBox, 16, Read Error, Failed to read codes.txt.
        return
    }

    ; Split into an array of non-empty lines
    codes := []
    Loop, Parse, fileContents, `n, `r
    {
        line := Trim(A_LoopField)
        if (line != "")
            codes.Push(line)
    }

    totalCodes := codes.MaxIndex()

    if (totalCodes = "")
    {
        MsgBox, 48, No Codes, codes.txt was found but contained no codes.
        return
    }

    ToolTip, Starting in 3...
    Sleep, 1000
    ToolTip, Starting in 2...
    Sleep, 1000
    ToolTip, Starting in 1...
    Sleep, 1000
    ToolTip

    for index, code in codes
    {
        if !WinActive(ApexWindowTitle)
        {
            ToolTip, Stopped - Apex lost focus
            Sleep, 1500
            ToolTip
            return
        }

        ; Click the input box, clear any existing text, type the code
        Click, %InputBoxX%, %InputBoxY%
        Sleep, 100
        Send, ^a
        Send, {Backspace}
        Send, %code%
        Sleep, 200

        ; Click the Join Match button
        Click, %JoinButtonX%, %JoinButtonY%

        ToolTip, Submitted code %index% of %totalCodes%: %code%
        Sleep, %DelayBetweenAttempts%
    }

    ToolTip, Done - all codes submitted
    Sleep, 2000
    ToolTip
    return
}

F10::
{
    ToolTip, Stopped by user (F10)
    Sleep, 1000
    ToolTip
    Reload  ; resets the script, cancels any in-progress loop
    return
}
