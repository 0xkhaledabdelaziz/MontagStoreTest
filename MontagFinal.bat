@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
color 07
title Montag Store System (V5 Safe)

:: --- CONFIG ---
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1

:: --- URLs ---
set "UrlKey=https://www.dropbox.com/scl/fi/onvccubmkxicdtvecdqvq/KeyboardTestUtility.exe?rlkey=62ag37rdvhp45iuzlk8261yus&st=k6li1383&dl=1"
set "UrlScr=https://www.dropbox.com/scl/fi/b63drni7qk3t8f0wudnk7/defpix.exe?rlkey=ir9k1d9gi99dwunjmqtnvtq7n&st=6etkm6wa&dl=1"
set "UrlHwi=https://www.dropbox.com/scl/fi/fjtwrg3boc8zj88ml2jxs/HWiNFO64.EXE?rlkey=m64f5qxup91iq8ew09imqfcs0&st=9eqs19xe&dl=1"

:: --- MAIN MENU ---
:MainMenu
cls
echo.
echo    ===================================
echo       MONTAG STORE SYSTEM (SAFE)
echo    ===================================
echo.
echo    [1] Hardware Tests
echo    [2] Windows Setup
echo    [3] Drivers Center
echo    [4] Software Hub
echo    [5] Print Label
echo.
echo    [X] Exit
echo.
choice /c 12345x /n /m "   > Choose: "

if %errorlevel%==6 exit
if %errorlevel%==5 goto PrintLabel
if %errorlevel%==4 goto Menu_Software
if %errorlevel%==3 goto Menu_Drivers
if %errorlevel%==2 goto Menu_Windows
if %errorlevel%==1 goto Menu_Hardware
goto MainMenu

:: --- HARDWARE ---
:Menu_Hardware
cls
echo.
echo    [ HARDWARE ]
echo.
echo    [1] Keyboard    [2] Screen
echo    [3] Camera      [4] Audio
echo    [5] Battery     [6] Sensors
echo    [0] Back
echo.
choice /c 1234560 /n /m "   > Test: "
if %errorlevel%==7 goto MainMenu
if %errorlevel%==6 (set "F=HWiNFO.exe" & set "L=%UrlHwi%" & goto DownRun)
if %errorlevel%==5 (powercfg /batteryreport /output "%TEMP%\batt.html" & start "" "%TEMP%\batt.html" & goto Menu_Hardware)
if %errorlevel%==4 (start mmsys.cpl & goto Menu_Hardware)
if %errorlevel%==3 (start microsoft.windows.camera: & goto Menu_Hardware)
if %errorlevel%==2 (set "F=Screen.exe" & set "L=%UrlScr%" & goto DownRun)
if %errorlevel%==1 (set "F=KeyTest.exe" & set "L=%UrlKey%" & goto DownRun)
goto Menu_Hardware

:DownRun
echo    [*] Downloading %F%...
curl -L -k -# -o "%ToolDir%\%F%" "%L%"
if exist "%ToolDir%\%F%" (start "" "%ToolDir%\%F%") else (echo [!] Failed & pause)
goto Menu_Hardware

:: --- WINDOWS ---
:Menu_Windows
cls
echo.
echo    [ WINDOWS ]
echo.
echo    [1] High Perf    [2] Arabic Key
echo    [3] Win Update   [4] Rename PC
echo    [5] Activate     [0] Back
echo.
choice /c 123450 /n /m "   > Option: "
if %errorlevel%==6 goto MainMenu
if %errorlevel%==5 (cscript //nologo %windir%\system32\slmgr.vbs /ato & pause & goto Menu_Windows)
if %errorlevel%==4 (set /p "N=Name: " & powershell "Rename-Computer -NewName '%N%-PC' -Force" & goto Menu_Windows)
if %errorlevel%==3 (start ms-settings:windowsupdate & goto Menu_Windows)
if %errorlevel%==2 (powershell "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}" & goto Menu_Windows)
if %errorlevel%==1 (powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & goto Menu_Windows)
goto Menu_Windows

:: --- DRIVERS ---
:Menu_Drivers
cls
echo.
echo    [ DRIVERS ]
echo.
echo    [1] Backup    [2] Restore
echo    [0] Back
echo.
choice /c 120 /n /m "   > Option: "
if %errorlevel%==3 goto MainMenu
if %errorlevel%==2 (
    set /p "D=Source Drive (e.g. D): "
    pnputil /add-driver "%D%:\Drivers\*.inf" /subdirs /install
    pause & goto Menu_Drivers
)
if %errorlevel%==1 (
    set /p "D=Target Drive (e.g. D): "
    mkdir "%D%:\Drivers"
    pnputil /export-driver * "%D%:\Drivers"
    pause & goto Menu_Drivers
)
goto Menu_Drivers

:: --- SOFTWARE ---
:Menu_Software
cls
echo.
echo    [ SOFTWARE ]
echo.
echo    [1] WinRAR       [2] Chrome
echo    [3] VLC          [0] Back
echo.
choice /c 1230 /n /m "   > Option: "
if %errorlevel%==4 goto MainMenu
if %errorlevel%==3 (winget install -e --id VideoLAN.VLC & goto Menu_Software)
if %errorlevel%==2 (winget install -e --id Google.Chrome & goto Menu_Software)
if %errorlevel%==1 (set "F=WinRAR.exe" & set "L=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownRun)
goto Menu_Software

:: --- LABEL ---
:PrintLabel
cls
echo    [*] Printing Label...
set "PS=%TEMP%\Label.ps1"
echo $b="Montag Store"; > "%PS%"
echo $s=(Get-CimInstance Win32_ComputerSystem).Model; >> "%PS%"
echo $c=(Get-CimInstance Win32_Processor).Name.Replace("Intel(R) Core(TM) ","").Replace("CPU @ ",""); >> "%PS%"
echo $r=[math]::Round((Get-CimInstance Win32_PhysicalMemory^|Measure-Object -Property Capacity -Sum).Sum/1GB); >> "%PS%"
echo $d=[math]::Round((Get-CimInstance Win32_DiskDrive^|Select -First 1).Size/1GB); >> "%PS%"
echo $h="<body style='font-family:Arial;width:70mm;font-size:9pt'><h3 style='text-align:center;margin:0'>$b</h3><hr><b>$s</b><br>$c<br><b>RAM: $r GB | SSD: $d GB</b><script>window.print()</script></body>"; >> "%PS%"
echo $h^|Out-File "$env:TEMP\L.html";Start-Process "$env:TEMP\L.html" >> "%PS%"
powershell -ExecutionPolicy Bypass -File "%PS%"
del "%PS%"
goto MainMenu
