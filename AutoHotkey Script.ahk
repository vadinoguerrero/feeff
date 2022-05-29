   #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetNumlockState, AlwaysOn
Muted:=0
return


isWindowFullScreen( winTitle) {
winID := WinExist( winTitle )
If WinActive("ahk_class WorkerW") Or WinActive("ahk_class Shell_TrayWnd") Or  WinActive("ahk_exe chrome.exe")
	Return false
If ( !winID )
	Return false
WinGet style, Style, ahk_id %WinID%
WinGetPos ,,,winW,winH, %winTitle%
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
	}


#IfWinActive, ahk_class CabinetWClass
~MButton::Send !{Up} 
#IfWinActive

PgDn::
send {WheelDown 2}
return

PgUp::
send {WheelUp 2}
return

~CapsLock::SetTimer, CapsOff, % GetKeyState("CapsLock", "T") ? -15000 : "Off"
CapsOff:
SetCapsLockState, Off
Return


!g::
<^>!g::
 Send, ^c
 Sleep 50
 Run, https://www.google.com/search?q=%clipboard%
 Return


 !l::
<^>!l::
IfWinActive ahk_exe Spotify.exe
{
WinGetTitle, WinTitle
If (WinTitle = "Spotify Free"){
    		return
		}
		else{
			FileRead, Song, C:\Users\Public\Song.txt
			Run, https://www.google.com/search?q=%Song%+lyrics
			}
}
IfWinActive ahk_exe chrome.exe
{
WinGetTitle, WinTitle
Yt := InStr(WinTitle, "Youtube Music") 
If (Yt= 0 ||Yt= 1){
    		return
		}
		else{
		FileRead, Song, C:\Users\Public\Song.txt
			Run, https://www.google.com/search?q=%Song%+lyrics
			}
}
return


#ifwinactive ahk_class CabinetWClass
<^>!Del::
Msgbox 4, Confirm, Force delete this folder?
	IfMsgBox Yes
	{
		Send, !d
		Sleep 200
		Send, ^c
		Sleep 300
		Send, ^c
		Folder := Clipboard
		Com = rmdir /s /q "%Folder%"
		Run *RunAs cmd.exe /c %Com%
		}
return
#if


#F1::
Run "C:\Program Files\Google\Chrome\Application\chrome.exe"
return

#F2::
Run  C:\Users\Vadiño\AppData\Roaming\Spotify\Spotify.exe

return

#F3::
Run  "C:\Program Files\Tor Browser\Browser\firefox.exe"
return

#c::
Run calc.exe
return

#s::
Run "C:\Program Files\Everything\Everything.exe"
return

#IfWinActive ahk_exe chrome.exe
#.::
<^>!.::
Send !+e
return
#IfWinActive

#f::
	If WinActive("ahk_class CabinetWClass"){

		Send, !d
		Sleep 200
		Send, wt
		Send, {Enter}
		}else{
		Run, wt -d C:\Users\Vadiño
		}
return

#a::
Send, #n
return

#k::
Sleep 700
Click, 1770 1060 1
return

#n::
Run, "C:\Program Files\AutoHotkey\Sticky.lnk"
return

LControl & Escape::
isFullScreen := isWindowFullScreen( "A" )
if (isFullScreen = false){
Send,  ^+{Esc}
}
return

LWin & Space::return
RWin & Space::return

#IfWinActive ahk_exe chrome.exe
F1::
Send, ^+n
return
#IfWinActive

#IfWinActive ahk_exe chrome.exe
F7::return
#IfWinActive

RWin & Del::
Run C:\Windows\explorer.exe ::{645FF040-5081-101B-9F08-00AA002F954E}
return


^Del::
Msgbox 4, Confirm, Empty the Recycle Bin?
IfMsgBox Yes
	FileRecycleEmpty
IfMsgBox No
	Return
return

!F4::
Send, ^!{F4}
return

^!F3::
Gui, +AlwaysOnTop
Gui, Add, Text,, Restarting
Gui, Show, NoActivate, System
shutdown,  6
return

^!F2::
Gui, +AlwaysOnTop
Gui, Add, Text,, Shutting Down
Gui, Show, NoActivate, System
shutdown,  5
return

^!F1::
DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 1, "Int", 0)
return

RControl & F11::
Process,Exist, WsaClient.exe
If (ErrorLevel != 0){
		Process, Close, WsaClient.exe
		MsgBox, WSA process terminated
		}
		else{
			MsgBox, WSA not opened
		}
return

RControl & Space::Send       {Media_Play_Pause}
RControl & Left::Send        {Media_Prev}
RControl & Right::Send       {Media_Next}


#IfWinActive ahk_exe spotify.exe
Shift & Up::
Send, ^{Up}
return

Shift & Down::
Send, ^{Down}
return
#IfWinActive

::mail::vadinoguerrero@gmail.com


;; MICROPHONE CONTROL ;;

RControl & F12::
If(Muted= "0")
{
Muted:=1
WinActivate ahk_exe Discord.exe
Sleep, 200
Send, ^+M
Run "C:\Program Files\soundvolumeview-x64\SoundVolumeView.exe" /Mute "Realtek(R) Audio\Device\Microphone\Capture"
SoundBeep, 900, 500
return
}
If(Muted= "1")
{
Muted:=0
WinActivate ahk_exe Discord.exe
Sleep, 200
Send, ^+M
Run "C:\Program Files\soundvolumeview-x64\SoundVolumeView.exe" /Unmute "Realtek(R) Audio\Device\Microphone\Capture"
SoundBeep, 500, 500
return
}


;; VOLUME CONTROL ;;

#Warn,UseUnsetLocal
#NoEnv
#SingleInstance force
SetBatchLines,-1

RControl & Down::
SoundSet,-1
Gosub,DisplaySlider
Return

RControl & Up::
SoundSet,+1
Gosub,DisplaySlider
Return

Shift & RControl::
RControl & Shift::
SoundSet,0
Gosub,DisplaySlider
Return

SliderOff:
Progress,Off
Return

DisplaySlider:
isFullScreen := isWindowFullScreen( "A" )
if (isFullScreen = false){
	SetTimer,SliderOff,2500
	SoundGet,Volume
	Volume:=Round(Volume)
	Progress,x1600 y930,%Volume%,Volume,Volume
	Progress,%Volume%,%Volume%,Volume,Volume
}
Return