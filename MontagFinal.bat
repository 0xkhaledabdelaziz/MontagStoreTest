@echo off
setlocal EnableDelayedExpansion
:: Enable UTF-8 and ANSI Colors
chcp 65001 >nul
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1
mode con: cols=110 lines=45
title Montag Store - Enterprise System (V5.0 Pro)

:: --- COLORS SETUP ---
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")
set "Red=%ESC%[91m"
set "Green=%ESC%[92m"
set "Yellow=%ESC%[93m"
set "Blue=%ESC%[94m"
set "Pink=%ESC%[95m"
set "Cyan=%ESC%[96m"
set "White=%ESC%[97m"
set "Reset=%ESC%[0m"

:: --- CONFIGURATION ---
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1

:: --- URLS ---
set "UrlKey=https://www.dropbox.com/scl/fi/onvccubmkxicdtvecdqvq/KeyboardTestUtility.exe?rlkey=62ag37rdvhp45iuzlk8261yus&st=k6li1383&dl=1"
set "UrlScr=https://www.dropbox.com/scl/fi/b63drni7qk3t8f0wudnk7/defpix.exe?rlkey=ir9k1d9gi99dwunjmqtnvtq7n&st=6etkm6wa&dl=1"
set "UrlHwi=https://www.dropbox.com/scl/fi/fjtwrg3boc8zj88ml2jxs/HWiNFO64.EXE?rlkey=m64f5qxup91iq8ew09imqfcs0&st=9eqs19xe&dl=1"

:: --- MAIN MENU ---
:MainMenu
cls
echo.
echo  %Pink%  __  __  ____  _   _  _____  ____   _____  _____  ____  _____  _____ %Reset%
echo  %Pink% |  \/  |/ __ \| \ | ||_   _|/ __ \ / ____|/ ____||_  _||_   _||_   _|%Reset%
echo  %Pink% | \  / | |  | |  \| |  | | | |  | | |  __| (___    ||    | |    | |  %Reset%
echo  %Pink% | |\/| | |  | | . ` |  | | | |  | | | |_ |\___ \   ||    | |    | |  %Reset%
echo  %Pink% | |  | | |__| | |\  |  | | | |__| | |__| |____) | _||_  _| |_  _| |_ %Reset%
echo  %Pink% |_|  |_|\____/|_| \_|  |_|  \____/ \_____|_____/ |____||_____||_____|%Reset%
echo.
echo  %Cyan% ====================================================================%Reset%
echo.
echo       %White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%          %White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%
echo       %White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%          %White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%
echo       %White%[5]%Reset% %Cyan%PRINT SPEC LABEL%Reset%
echo.
echo  %Cyan% --------------------------------------------------------------------%Reset%
echo       %Green%[R] FINISH REPORT%Reset%               %Red%[X] EXIT%Reset%
echo  %Cyan% ====================================================================%Reset%
echo.
choice /c 12345rx /n /m " > Select Option: "

if %errorlevel%==7 exit
if %errorlevel%==6 goto FinalReport
if %errorlevel%==5 goto PrintLabel
if %errorlevel%==4 goto Menu_Software
if %errorlevel%==3 goto Menu_Drivers
if %errorlevel%==2 goto Menu_Windows
if %errorlevel%==1 goto Menu_Hardware
goto MainMenu

:: --- HARDWARE MENU ---
:Menu_Hardware
cls
echo.
echo  %Pink% [ HARDWARE DIAGNOSTICS ] %Reset%
echo  %Cyan% ------------------------ %Reset%
echo.
echo   [1] Keyboard Test
echo   [2] Screen Test
echo   [3] Camera Test
echo   [4] Audio Test
echo   [5] Battery Report
echo   [6] Sensors (HWiNFO)
echo   [7] Check Warranty
echo   [8] Stress Test (CPU)
echo.
echo   [0] Back to Main Menu
echo.
choice /c 123456780 /n /m " > Select Test: "
if %errorlevel%==9 goto MainMenu
if %errorlevel%==8 goto StressTest
if %errorlevel%==7 goto CheckWarranty
if %errorlevel%==6 (set "F=HWiNFO.exe" & set "L=%UrlHwi%" & goto DownRun)
if %errorlevel%==5 (powercfg /batteryreport /output "%TEMP%\batt.html" & start "" "%TEMP%\batt.html" & goto Menu_Hardware)
if %errorlevel%==4 (start mmsys.cpl & goto Menu_Hardware)
if %errorlevel%==3 (start microsoft.windows.camera: & goto Menu_Hardware)
if %errorlevel%==2 (set "F=Screen.exe" & set "L=%UrlScr%" & goto DownRun)
if %errorlevel%==1 (set "F=KeyTest.exe" & set "L=%UrlKey%" & goto DownRun)
goto Menu_Hardware

:DownRun
echo.
echo  %Yellow%[*] Downloading Tool...%Reset%
curl -L -k -# -o "%ToolDir%\%F%" "%L%"
if exist "%ToolDir%\%F%" (start "" "%ToolDir%\%F%") else (echo %Red%[!] Failed%Reset% & pause)
goto Menu_Hardware

:StressTest
cls
echo.
echo  %Red%[!] STRESS TEST ACTIVE (60 Seconds)%Reset%
echo  System will be under 100%% Load.
powershell -Command "$s=[System.Diagnostics.Stopwatch]::StartNew();$j=@();1..[Environment]::ProcessorCount|%%{$j+=Start-Job -ScriptBlock{$r=1;while($true){$r=$r*1.000001}}};while($s.Elapsed.TotalSeconds -lt 60){Start-Sleep 1};$j|Stop-Job|Remove-Job"
goto Menu_Hardware

:CheckWarranty
cls
echo.
echo  %Cyan%[*] Reading Serial Number...%Reset%
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_Bios).SerialNumber"`) do set "SN=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_ComputerSystem).Manufacturer"`) do set "MFG=%%a"
echo  Serial: %White%%SN%%Reset%
echo  Brand : %White%%MFG%%Reset%
echo.
echo  Opening Browser...
if /i "%MFG%"=="Dell Inc." start "" "https://www.dell.com/support/home/en-us/product-support/servicetag/%SN%/overview"
if /i "%MFG%"=="HP" start "" "https://support.hp.com/us-en/checkwarranty"
if /i "%MFG%"=="Lenovo" start "" "https://pcsupport.lenovo.com/us/en/warrantylookup"
timeout /t 3 >nul
goto Menu_Hardware

:: --- WINDOWS MENU ---
:Menu_Windows
cls
echo.
echo  %Pink% [ WINDOWS CONFIGURATION ] %Reset%
echo  %Cyan% ------------------------- %Reset%
echo.
echo   [1] High Performance Mode
echo   [2] Add Arabic Keyboard
echo   [3] Open Windows Update
echo   [4] Rename PC & User
echo   [5] Activate Windows (OEM)
echo   [0] Back
echo.
choice /c 123450 /n /m " > Select Option: "
if %errorlevel%==6 goto MainMenu
if %errorlevel%==5 (cscript //nologo %windir%\system32\slmgr.vbs /ato & pause & goto Menu_Windows)
if %errorlevel%==4 (set /p "N=Enter Name: " & powershell "Rename-Computer -NewName '%N%-PC' -Force" & goto Menu_Windows)
if %errorlevel%==3 (start ms-settings:windowsupdate & goto Menu_Windows)
if %errorlevel%==2 (powershell "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}" & goto Menu_Windows)
if %errorlevel%==1 (powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c & goto Menu_Windows)
goto Menu_Windows

:: --- DRIVERS MENU ---
:Menu_Drivers
cls
echo.
echo  %Pink% [ DRIVERS CENTER ] %Reset%
echo  %Cyan% ------------------ %Reset%
echo.
echo   [1] Backup Drivers (Export)
echo   [2] Restore Drivers (Import)
echo   [0] Back
echo.
choice /c 120 /n /m " > Select Option: "
if %errorlevel%==3 goto MainMenu
if %errorlevel%==2 (
    set /p "D=Source Drive Letter (e.g. D): "
    pnputil /add-driver "%D%:\Drivers\*.inf" /subdirs /install
    pause & goto Menu_Drivers
)
if %errorlevel%==1 (
    set /p "D=Target Drive Letter (e.g. D): "
    mkdir "%D%:\Drivers"
    pnputil /export-driver * "%D%:\Drivers"
    pause & goto Menu_Drivers
)
goto Menu_Drivers

:: --- SOFTWARE MENU ---
:Menu_Software
cls
echo.
echo  %Pink% [ SOFTWARE HUB ] %Reset%
echo  %Cyan% ---------------- %Reset%
echo.
echo   [1] Install WinRAR
echo   [2] Install Chrome
echo   [3] Install VLC
echo   [4] Defender Control
echo   [0] Back
echo.
choice /c 12340 /n /m " > Select Option: "
if %errorlevel%==5 goto MainMenu
if %errorlevel%==4 (curl -L -k -# -o "%ToolDir%\DefCont.rar" "https://www.dropbox.com/scl/fi/ek7g511arqlacuf8jblhx/Defender-Control-pass-1.rar?rlkey=wrpduzvs5gynt3nta96xfkxuh&st=369mh2n4&dl=1" & explorer "%ToolDir%" & goto Menu_Software)
if %errorlevel%==3 (winget install -e --id VideoLAN.VLC & goto Menu_Software)
if %errorlevel%==2 (winget install -e --id Google.Chrome & goto Menu_Software)
if %errorlevel%==1 (set "F=WinRAR.exe" & set "L=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownRun)
goto Menu_Software

:: --- PRINT LABEL ---
:PrintLabel
cls
echo.
echo  %Cyan%[*] Generating Label...%Reset%
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

:: --- REPORT ---
:FinalReport
cls
echo.
echo  %Green%[*] Uploading Final Report...%Reset%
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"
set /p "TN=Enter Tester Name: "
set "PS=%TEMP%\R.ps1"
echo $b=@{"entry.392302034"="%TN%"};Invoke-WebRequest -Uri "https://docs.google.com/forms/d/e/%GFormID%/formResponse" -Method POST -Body $b -UseBasicParsing > "%PS%"
powershell -ExecutionPolicy Bypass -File "%PS%"
del "%PS%"
echo  Done.
timeout /t 3 >nul
rmdir /s /q "%ToolDir%"
exit
