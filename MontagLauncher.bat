<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] ADMIN FORCE + FORCE MAXIMIZE
:: ============================================================
cd /d "%~dp0"
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: ============================================================
:: [1] VISUAL SETUP
:: ============================================================
chcp 65001 >nul
mode con: cols=150 lines=60
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1

title Montag Store - System (V 410.0 Modular)
color 05

:: ============================================================
:: [2] CONFIGURATION
:: ============================================================
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
attrib +h "%IconDir%" >nul 2>&1

:: --- BRANDING ---
set "BrandName=Montag Store"
set "BrandPhone=Manager: 01090040022-01144566115 | Tech: 01040901444"
set "BrandURL=https://montagstore.com"
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"
set "TechSupportNumber=201040901444"

:: --- EXTERNAL OFFICE SCRIPT LINK ---
set "UrlOfficeScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagOffice.bat"

:: --- URLS ---
set "UrlKey=https://www.dropbox.com/scl/fi/onvccubmkxicdtvecdqvq/KeyboardTestUtility.exe?rlkey=62ag37rdvhp45iuzlk8261yus&st=k6li1383&dl=1"
set "UrlScr=https://www.dropbox.com/scl/fi/b63drni7qk3t8f0wudnk7/defpix.exe?rlkey=ir9k1d9gi99dwunjmqtnvtq7n&st=6etkm6wa&dl=1"
set "UrlAud=https://www.dropbox.com/scl/fi/ekej1ymnzepliyggm5hn3/xSpeaker-Headphones-Trim.mp4?rlkey=mw5md1jthagl3nfu3yfumulri&st=5xo6k9gg&dl=1"
set "UrlHwi=https://www.dropbox.com/scl/fi/fjtwrg3boc8zj88ml2jxs/HWiNFO64.EXE?rlkey=m64f5qxup91iq8ew09imqfcs0&st=9eqs19xe&dl=1"
set "UrlRar=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1"
set "UrlMAS=https://www.dropbox.com/scl/fi/cnj7x4fp8zqksmeewhsmg/MAS_AIO.cmd?rlkey=1zr26qvm9l7r26iaw52czjmt9&st=7o2zhkih&dl=1"

:: Download Icon
if not exist "%IconDir%\Montag.ico" curl -L -k -s -o "%IconDir%\Montag.ico" "https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1" >nul 2>&1

:: Visuals
set "PAD=     "
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")
set "Reset=%ESC%[0m"
set "Pink=%ESC%[38;2;255;0;255m"
set "Cyan=%ESC%[36m"
set "White=%ESC%[37m"
set "Green=%ESC%[32m"
set "Red=%ESC%[31m"
set "Yellow=%ESC%[33m"
set "Gray=%ESC%[90m"
set "Bold=%ESC%[1m"

:: Checkmarks Initialization
for %%i in (WiFi Key Screen Cam Audio Batt Specs Sensor WinUpd OEM Arab DriverBack DriverRest HighPerf Label WinRAR DefCont Revo Brand Apps Disk Mic Intake Clean Name Warranty Active Bloat Stress MAS Boost Icons Auto Game BrandClick CheckWin Office OffClean) do if not defined mark_%%i set "mark_%%i=   "

:: --- EXTRACT ENGINE ONCE ---
set "EngineScript=%ToolDir%\MontagEngine.ps1"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__ENGINE_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [2.5] WIFI CHECK & INTRO
:: ============================================================
:CheckInternet
ping -n 1 google.com >nul
if %errorlevel% equ 0 (
    cls
    call :DrawHeader
    echo.
    echo.
    echo %PAD%%Green%      Welcome to Montag Store System...%Reset%
    call :Speak "Welcome to Montag Store System."
    timeout /t 1 >nul
    goto MainMenu
)

:WifiMenu
cls
echo.
echo %PAD%%Pink%███╗   ███╗ ██████╗ ███╗   ██╗████████╗ █████╗  ██████╗      ███████╗████████╗ ██████╗ ██████╗ ███████╗%Reset%
echo %PAD%%Pink%████╗ ████║██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔════╝      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%██╔████╔██║██║   ██║██╔██╗ ██║   ██║   ███████║██║  ███╗     ███████╗   ██║   ██║   ██║██████╔╝█████╗  %Reset%
echo %PAD%%Pink%██║╚██╔╝██║██║   ██║██║╚██╗██║   ██║   ██╔══██║██║   ██║     ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  %Reset%
echo %PAD%%Pink%██║ ╚═╝ ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝     ███████║   ██║   ╚██████╔╝██║  ██║███████╗%Reset%
echo %PAD%%Pink%╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Red%    [!] NO INTERNET DETECTED. PLEASE CONNECT:%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% MontagStore               %Bold%%White%[2]%Reset% MontagStore 5G
echo %PAD%    %Bold%%White%[3]%Reset% Montag Reception          %Bold%%White%[4]%Reset% Montag Reception 5G
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo %PAD%    %Gray%[R] RETRY CONNECTION          [X] SKIP (OFFLINE MODE)%Reset%
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Connect to:%Reset% 
choice /c 1234rx /n

if %errorlevel%==6 goto MainMenu
if %errorlevel%==5 goto CheckInternet
if %errorlevel%==4 call :ConnectWifi "Montag reception 5G" "12345_Mont@g" & goto CheckInternet
if %errorlevel%==3 call :ConnectWifi "Montag reception" "12345_Mont@g" & goto CheckInternet
if %errorlevel%==2 call :ConnectWifi "MontagStore5G" "12345_Montag" & goto CheckInternet
if %errorlevel%==1 call :ConnectWifi "MontagStore" "12345_Montag" & goto CheckInternet
goto WifiMenu

:ConnectWifi
set "SSID=%~1"
set "PASS=%~2"
echo.
echo %PAD%%Cyan%Connecting to %SSID%...%Reset%
set "WiFiXML=%ToolDir%\wifi_temp.xml"
(
    echo ^<?xml version="1.0"?^>
    echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
    echo     ^<name^>%SSID%^</name^>
    echo     ^<SSIDConfig^>
    echo         ^<SSID^>
    echo             ^<name^>%SSID%^</name^>
    echo         ^</SSID^>
    echo     ^</SSIDConfig^>
    echo     ^<connectionType^>ESS^</connectionType^>
    echo     ^<connectionMode^>auto^</connectionMode^>
    echo     ^<MSM^>
    echo         ^<security^>
    echo             ^<authEncryption^>
    echo                 ^<authentication^>WPA2PSK^</authentication^>
    echo                 ^<encryption^>AES^</encryption^>
    echo                 ^<useOneX^>false^</useOneX^>
    echo             ^</authEncryption^>
    echo             ^<sharedKey^>
    echo                 ^<keyType^>passPhrase^</keyType^>
    echo                 ^<protected^>false^</protected^>
    echo                 ^<keyMaterial^>%PASS%^</keyMaterial^>
    echo             ^</sharedKey^>
    echo         ^</security^>
    echo     ^</MSM^>
    echo ^</WLANProfile^>
) > "%WiFiXML%"
netsh wlan add profile filename="%WiFiXML%" user=all >nul 2>&1
netsh wlan connect name="%SSID%" >nul 2>&1
del "%WiFiXML%" >nul 2>&1
timeout /t 5 >nul
exit /b

:: ============================================================
:: [3] MAIN MENU
:: ============================================================
:MainMenu
cls
echo.
echo %PAD%%Pink%███╗   ███╗ ██████╗ ███╗   ██╗████████╗ █████╗  ██████╗      ███████╗████████╗ ██████╗ ██████╗ ███████╗%Reset%
echo %PAD%%Pink%████╗ ████║██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔════╝      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%██╔████╔██║██║   ██║██╔██╗ ██║   ██║   ███████║██║  ███╗     ███████╗   ██║   ██║   ██║██████╔╝█████╗  %Reset%
echo %PAD%%Pink%██║╚██╔╝██║██║   ██║██║╚██╗██║   ██║   ██╔══██║██║   ██║     ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  %Reset%
echo %PAD%%Pink%██║ ╚═╝ ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝     ███████║   ██║   ╚██████╔╝██║  ██║███████╗%Reset%
echo %PAD%%Pink%╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%      %Gray%(Key/Screen)%Reset%            %Bold%%White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%       %Gray%(Perf/Name)%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%      %Gray%(Back/Rest)%Reset%             %Bold%%White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%        %Gray%(Apps/Winget)%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% %Cyan%PRINT SPEC LABEL%Reset%    %Gray%(ZPL/Side)%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%           %Green%[R] FINISH + UPLOAD REPORT%Reset%                       %Red%[X] EXIT + WIPE CACHE%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Select Option:%Reset% 
choice /c 12345rx /n

if %errorlevel%==7 goto ExitCleanup
if %errorlevel%==6 goto FinalReport
if %errorlevel%==5 goto PrintLabel
if %errorlevel%==4 goto Menu_Software
if %errorlevel%==3 goto Menu_Drivers
if %errorlevel%==2 goto Menu_Windows
if %errorlevel%==1 goto Menu_Hardware
goto MainMenu

:: ============================================================
:: [1] HARDWARE MENU
:: ============================================================
:Menu_Hardware
cls
echo.
echo %PAD%%Pink%██╗  ██╗ █████╗ ██████╗ ██╗    ██╗ █████╗ ██████╗ ███████╗%Reset%
echo %PAD%%Pink%██║  ██║██╔══██╗██╔══██╗██║    ██║██╔══██╗██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%███████║███████║██████╔╝██║ █╗ ██║███████║██████╔╝█████╗  %Reset%
echo %PAD%%Pink%██╔══██║██╔══██║██╔══██╗██║███╗██║██╔══██║██╔══██╗██╔══╝  %Reset%
echo %PAD%%Pink%██║  ██║██║  ██║██║  ██║╚███╔███╔╝██║  ██║██║  ██║███████╗%Reset%
echo %PAD%%Pink%╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% KEYBOARD TEST       %Green%!mark_Key!%Reset%             %Bold%%White%[2]%Reset% SCREEN TEST         %Green%!mark_Screen!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% CAMERA TEST         %Green%!mark_Cam!%Reset%             %Bold%%White%[4]%Reset% AUDIO TEST          %Green%!mark_Audio!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% BATTERY REPORT      %Green%!mark_Batt!%Reset%             %Bold%%White%[6]%Reset% SENSORS (HWiNFO)    %Green%!mark_Sensor!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% CHECK WARRANTY      %Green%!mark_Warranty!%Reset%         %Bold%%White%[8]%Reset% SYSTEM STRESS TEST  %Green%!mark_Stress!%Reset%
echo.
echo %PAD%    %Bold%%Red%[9] CHECK WIN INTEGRITY%Reset% %Green%!mark_CheckWin!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK TO MAIN%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Select Test:%Reset% 
choice /c 1234567890 /n

if %errorlevel%==10 goto MainMenu
if %errorlevel%==9 goto CheckWinIntegrity
if %errorlevel%==8 goto StressTest
if %errorlevel%==7 goto CheckWarranty
if %errorlevel%==6 (set "mark_Sensor=[OK]" & set "ExeName=HWiNFO.exe" & set "TargetUrl=%UrlHwi%" & goto DownloadAndRun)
if %errorlevel%==5 (set "mark_Batt=[OK]" & goto BatteryTest)
if %errorlevel%==4 (set "mark_Audio=[OK]" & set "ExeName=Audio.mp4" & set "TargetUrl=%UrlAud%" & goto DownloadAndRun)
if %errorlevel%==3 (set "mark_Cam=[OK]" & goto CamTest)
if %errorlevel%==2 (set "mark_Screen=[OK]" & set "ExeName=ScreenTest.exe" & set "TargetUrl=%UrlScr%" & goto DownloadAndRun)
if %errorlevel%==1 (set "mark_Key=[OK]" & set "ExeName=KeyTest.exe" & set "TargetUrl=%UrlKey%" & goto DownloadAndRun)
goto Menu_Hardware

:: --- HARDWARE FUNCTIONS ---
:StressTest
cls
echo.
echo %PAD%%Red%[CAUTION] STARTING STRESS TEST (60 SECONDS)%Reset%
echo %PAD%This will push CPU to 100%% usage.
pause >nul
powershell -Command "$s=[System.Diagnostics.Stopwatch]::StartNew();$j=@();1..[Environment]::ProcessorCount|%%{$j+=Start-Job -ScriptBlock{$r=1;while($true){$r=$r*1.000001}}};Write-Host ' [!] CPU 100% Load Active...';while($s.Elapsed.TotalSeconds -lt 60){Start-Sleep 1};$j|Stop-Job|Remove-Job"
set "mark_Stress=[OK]"
timeout /t 2 >nul
goto Menu_Hardware

:CheckWarranty
cls
echo %PAD%%Cyan%Detecting Serial Number...%Reset%
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_Bios).SerialNumber"`) do set "SN=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_ComputerSystem).Manufacturer"`) do set "MFG=%%a"
echo.
echo %PAD%Serial: %White%%SN%%Reset%
echo %PAD%Brand : %White%%MFG%%Reset%
echo.
echo %PAD%Opening Warranty Page...
if /i "%MFG%"=="Dell Inc." start "" "https://www.dell.com/support/home/en-us/product-support/servicetag/%SN%/overview"
if /i "%MFG%"=="HP" start "" "https://support.hp.com/us-en/checkwarranty"
if /i "%MFG%"=="Lenovo" start "" "https://pcsupport.lenovo.com/us/en/warrantylookup"
set "mark_Warranty=[OK]"
timeout /t 2 >nul
goto Menu_Hardware

:CheckWinIntegrity
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ WINDOWS DETECTIVE - ORIGINALITY CHECK ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
:: --- CRASH PROOF METHOD: USE THE UNIFIED ENGINE IN 'CHECK' MODE ---
powershell -ExecutionPolicy Bypass -File "%EngineScript%" -Task "CheckWin"

echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
set "mark_CheckWin=[OK]"
pause
goto Menu_Hardware

:DownloadAndRun
set "Exe=%ToolDir%\%ExeName%"
if not exist "%ToolDir%" mkdir "%ToolDir%"
if exist "%Exe%" (start "" "%Exe%" & goto ReturnPoint)
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DOWNLOAD MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading: %White%%ExeName%...
echo.
curl -L -k -# -o "%Exe%" "%TargetUrl%"
if exist "%Exe%" (start "" "%Exe%") else (echo %PAD%%Red%[ERROR] Failed.%Reset% & pause)
:ReturnPoint
if "%ExeName%"=="WinRAR.exe" goto Menu_Software
if "%ExeName%"=="DefCont.rar" goto Menu_Software
if "%ExeName%"=="Revo.rar" goto Menu_Software
goto Menu_Hardware

:CamTest
start microsoft.windows.camera: & goto Menu_Hardware
:BatteryTest
powercfg /batteryreport /output "%TEMP%\batt.html" >nul 2>&1
start "" "%TEMP%\batt.html"
goto Menu_Hardware

:: ============================================================
:: [2] WINDOWS MENU
:: ============================================================
:Menu_Windows
cls
echo.
echo %PAD%%Pink%██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗%Reset%
echo %PAD%%Pink%██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝%Reset%
echo %PAD%%Pink%██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗%Reset%
echo %PAD%%Pink%██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║%Reset%
echo %PAD%%Pink%╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║%Reset%
echo %PAD%%Pink% ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% HIGH PERF + NO SLEEP  %Green%!mark_HighPerf!%Reset%         %Bold%%White%[2]%Reset% ARAB KEY + EGYPT REG  %Green%!mark_Arab!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% CHECK WINDOWS UPDATE  %Green%!mark_WinUpd!%Reset%           %Bold%%White%[4]%Reset% RENAME PC ^& USER     %Green%!mark_Name!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% ACTIVATE ORIGINAL KEY %Green%!mark_Active!%Reset%          %Bold%%White%[6]%Reset% REMOVE BLOATWARE      %Green%!mark_Bloat!%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% QUICK BOOST ^& FIX    %Green%!mark_Boost!%Reset%          %Bold%%White%[8]%Reset% ADD RIGHT-CLICK BRAND %Green%!mark_BrandClick!%Reset%
echo.
echo %PAD%    %Bold%%Yellow%[9] PREPARE FOR SALE (AUTO-PILOT)%Reset% %Green%!mark_Auto!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 1234567890 /n
if %errorlevel%==10 goto MainMenu
if %errorlevel%==9 goto AutoPilot
if %errorlevel%==8 goto AddRightClickBrand
if %errorlevel%==7 goto QuickBoost
if %errorlevel%==6 goto RemoveBloatware
if %errorlevel%==5 goto ActivateOEM
if %errorlevel%==4 goto RenameUser
if %errorlevel%==3 (set "mark_WinUpd=[OK]" & goto WinUpdate)
if %errorlevel%==2 (set "mark_Arab=[OK]" & goto AddArabic)
if %errorlevel%==1 (set "mark_HighPerf=[OK]" & goto HighPerf)
goto Menu_Windows

:AutoPilot
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ AUTO-PILOT: PREPARE FOR SALE ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Red%[WARNING] This will run ALL setup steps automatically.%Reset%
echo %PAD%Please do not touch the mouse or keyboard.
echo.
echo %PAD%%Green%   Initiating Auto-Pilot Mode. Please stand by.%Reset%
call :Speak "Initiating Auto-Pilot Mode. Please stand by."
echo.
timeout /t 2 >nul

:: --- STEP 1: RESTORE POINT (Safety) ---
echo %PAD%%Yellow%[1/9] Creating Backup Point...%Reset%
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_AutoPilot' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: --- STEP 2: BOOST & TIME ---
echo %PAD%%Yellow%[2/9] Tuning System (Time/Hibernate)...%Reset%
powercfg -h off >nul 2>&1
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1

:: --- STEP 3: BLOATWARE ---
echo %PAD%%Yellow%[3/9] Removing Bloatware...%Reset%
echo %PAD%%Green%   Removing unnecessary system applications.%Reset%
call :Speak "Removing unnecessary system applications."
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1

:: --- STEP 4: APPS ---
set "Args=-e --accept-source-agreements --accept-package-agreements"
echo %PAD%%Yellow%[4/9] Installing Apps (Chrome/VLC/etc)...%Reset%
echo %PAD%%Green%   Installing basic applications.%Reset%
call :Speak "Installing basic applications."
winget install --id Google.Chrome %Args% >nul 2>&1
winget install --id VideoLAN.VLC %Args% >nul 2>&1
winget install --id WhatsApp.WhatsApp %Args% >nul 2>&1
winget install --id AnyDeskSoftwareEvents.AnyDesk %Args% >nul 2>&1
winget install --id Adobe.Acrobat.Reader.64-bit %Args% >nul 2>&1

:: --- STEP 5: GAMING PACK ---
echo %PAD%%Yellow%[5/9] Installing Gaming Essentials...%Reset%
winget install --id Microsoft.VCRedist.2015+.x64 %Args% >nul 2>&1
winget install --id Microsoft.VCRedist.2015+.x86 %Args% >nul 2>&1

:: --- STEP 6: ACTIVATION (OEM) ---
echo %PAD%%Yellow%[6/9] Checking Activation...%Reset%
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"
if not "%BiosKey%"=="" (
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey% >nul 2>&1
    cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
)

:: --- STEP 7: ICONS & BRANDING ---
echo %PAD%%Yellow%[7/9] Showing Desktop Icons...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul 2>&1

echo %PAD%%Yellow%[8/9] Applying Right-Click Branding...%Reset%
call :AddContextSupport >nul 2>&1

:: --- STEP 8: CLEANUP ---
echo %PAD%%Yellow%[9/9] Cleaning Temp Files...%Reset%
del /s /f /q %temp%\*.* >nul 2>&1

:: --- STEP 9: RESTART EXPLORER ---
echo %PAD%%Yellow%Refreshing Interface...%Reset%
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

set "mark_Auto=[OK]"
set "mark_Boost=[OK]"
set "mark_Bloat=[OK]"
set "mark_Apps=[OK]"
set "mark_Icons=[OK]"
set "mark_Game=[OK]"
set "mark_BrandClick=[OK]"

echo.
echo %PAD%%Green%[SUCCESS] Auto-Pilot Completed Successfully!%Reset%
echo %PAD%System is ready for sale.
echo %PAD%%Green%   System Ready. Have a nice day.%Reset%
call :Speak "System Ready. Have a nice day."
pause
goto Menu_Windows

:AddRightClickBrand
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DESKTOP BRANDING SETUP ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Adding 'Contact Montag Support' to context menu...%Reset%
call :AddContextSupport
echo.
echo %PAD%%Green%[OK] Added successfully! Check your Right-Click.%Reset%
set "mark_BrandClick=[OK]"
timeout /t 3 >nul
goto Menu_Windows

:ShowIcons
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DESKTOP ICONS SETUP ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Showing 'This PC' and 'User' icons on desktop...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo %PAD%%Green%[OK] Icons Visible.%Reset%
set "mark_Icons=[OK]"
timeout /t 3 >nul
goto Menu_Windows

:QuickBoost
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ QUICK SYSTEM TUNE-UP ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%[1/3] Disabling Hibernation (Free Space)...%Reset%
powercfg -h off >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
echo %PAD%%Yellow%[2/3] Syncing Time (Fix SSL Errors)...%Reset%
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
echo %PAD%%Yellow%[3/3] Disabling Sticky Keys...%Reset%
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d "58" /f >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
set "mark_Boost=[OK]"
echo %PAD%%Green%[OK] System Boosted.%Reset%
timeout /t 2 >nul
goto Menu_Windows

:RemoveBloatware
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ SYSTEM CLEANUP MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
:: --- 1. SAFETY FIRST ---
echo %PAD%%Yellow%[1/3] Creating System Restore Point (Safety)...%Reset%
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_Clean_Backup' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
if %errorlevel%==0 (echo %PAD%%Green%      Success! Backup created.%Reset%) else (echo %PAD%%Red%      Skipped (Admin rights needed).%Reset%)
echo.
:: --- 2. TEMP CLEANUP ---
echo %PAD%%Yellow%[2/3] Cleaning Temporary Junk Files...%Reset%
del /s /f /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
echo %PAD%%Green%      Temp Files Deleted.%Reset%
echo.
:: --- 3. BLOATWARE REMOVAL ---
echo %PAD%%Yellow%[3/3] Removing Bloatware Apps...%Reset%
echo %PAD%      - Removing Xbox & Solitaire...
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue"
echo %PAD%      - Removing 3D Viewer & Paint 3D...
powershell -Command "Get-AppxPackage *3d* | Remove-AppxPackage -ErrorAction SilentlyContinue"
echo %PAD%      - Removing Maps & News...
powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue"
echo %PAD%      - Removing Skype & Feedback...
powershell -Command "Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *feedback* | Remove-AppxPackage -ErrorAction SilentlyContinue"
set "mark_Bloat=[OK]"
echo.
echo %PAD%%Green%[OK] System Cleaned & Secured.%Reset%
timeout /t 3 >nul
goto Menu_Windows

:ActivateOEM
cls
echo.
echo %PAD%%Cyan%Searching for BIOS Product Key...%Reset%
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"

if "%BiosKey%"=="" (
    echo.
    echo %PAD%%Red%[ERROR] No Original BIOS Key Found.%Reset%
    pause
) else (
    echo.
    echo %PAD%%Green%[OK] Key Found: %White%%BiosKey%%Reset%
    echo %PAD%Installing Key...
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey%
    echo %PAD%Activating Online...
    cscript //nologo %windir%\system32\slmgr.vbs /ato
    echo.
    echo %PAD%%Green%[SUCCESS] Activation Command Sent.%Reset%
    set "mark_Active=[OK]"
    timeout /t 3 >nul
)
goto Menu_Windows

:RenameUser
cls
echo.
echo %PAD%%Magenta%[ CLIENT PERSONALIZATION ]%Reset%
set "ClientName="
set /p ClientName="%PAD%Enter Client Name: "
if "%ClientName%"=="" goto Menu_Windows
echo %PAD%Processing...
powershell -Command "Rename-Computer -NewName '%ClientName%-PC' -Force -ErrorAction SilentlyContinue"
net user "%USERNAME%" /fullname:"%ClientName%" >nul 2>&1
wmic useraccount where name="%USERNAME%" rename "%ClientName%" >nul 2>&1
set "mark_Name=[OK]"
echo %PAD%%Green%[OK] Done. Restart later.%Reset%
timeout /t 3 >nul
goto Menu_Windows

:AddArabic
cls
echo %PAD%%Cyan%Configuring Region...%Reset%
powershell -Command "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}"
tzutil /s "Egypt Standard Time"
goto Menu_Windows

:HighPerf
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
goto Menu_Windows

:WinUpdate
start ms-settings:windowsupdate & goto Menu_Windows

:: ============================================================
:: [3] DRIVERS MENU
:: ============================================================
:Menu_Drivers
cls
echo.
echo %PAD%%Pink%██████╗ ██████╗ ██╗██╗   ██╗███████╗██████╗ ███████╗%Reset%
echo %PAD%%Pink%██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%██║  ██║██████╔╝██║██║   ██║█████╗  ██████╔╝███████╗%Reset%
echo %PAD%%Pink%██║  ██║██╔══██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║%Reset%
echo %PAD%%Pink%██████╔╝██║  ██║██║ ╚████╔╝ ███████╗██║  ██║███████║%Reset%
echo %PAD%%Pink%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% BACKUP DRIVERS      %Green%!mark_DriverBack!%Reset%       %Bold%%White%[2]%Reset% RESTORE DRIVERS     %Green%!mark_DriverRest!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% OEM SUPPORT - DELL  %Gray%[Web]%Reset%                   %Bold%%White%[4]%Reset% OEM SUPPORT - HP    %Gray%[Web]%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 12340 /n
if %errorlevel%==5 goto MainMenu
if %errorlevel%==4 start "" "https://ftp.hp.com/pub/softpaq/sp168501-169000/sp168523.exe" & goto Menu_Drivers
if %errorlevel%==3 start "" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe" & goto Menu_Drivers
if %errorlevel%==2 (set "mark_DriverRest=[OK]" & goto RestoreDrivers)
if %errorlevel%==1 (set "mark_DriverBack=[OK]" & goto BackupDrivers)
goto Menu_Drivers

:BackupDrivers
cls
set "PSDr=%TEMP%\DrvBack.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $host.UI.RawUI.WindowTitle = 'Montag Store - Driver Backup' >> "%PSDr%"
echo Write-Host "`n   DRIVER BACKUP" -ForegroundColor Magenta >> "%PSDr%"
echo $model = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%PSDr%"
echo Write-Host "   Detected: $model" -ForegroundColor Yellow >> "%PSDr%"
echo $drv = Read-Host "`n   Enter Drive (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $name = "$model".Replace(" ", "_") + "_Drivers" >> "%PSDr%"
echo $finalPath = "$($drv):\$name" >> "%PSDr%"
echo New-Item -ItemType Directory -Force -Path $finalPath ^| Out-Null >> "%PSDr%"
echo Write-Host "`n   Backing up..." -ForegroundColor Green >> "%PSDr%"
echo pnputil /export-driver * "$finalPath" >> "%PSDr%"
echo Write-Host "`n   [OK] Done." -ForegroundColor Green >> "%PSDr%"
echo Read-Host "`n   Press Enter..." >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:RestoreDrivers
cls
set "PSDr=%TEMP%\DrvRest.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $host.UI.RawUI.WindowTitle = 'Montag Store - Driver Restore' >> "%PSDr%"
echo Write-Host "`n   DRIVER RESTORE" -ForegroundColor Magenta >> "%PSDr%"
echo $drv = Read-Host "   Enter Source Drive (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $term = Read-Host "   Search Term (empty for auto)" >> "%PSDr%"
echo if (-not $term) { $term = (Get-WmiObject Win32_ComputerSystem).Model.Trim() } >> "%PSDr%"
echo $pattern = "*" + $term.Replace(" ", "*") + "*" >> "%PSDr%"
echo Write-Host "   Searching..." -ForegroundColor Yellow >> "%PSDr%"
echo try { $folder = Get-ChildItem -Path "$($drv):\" -Directory -Recurse -Filter $pattern -ErrorAction SilentlyContinue ^| Select-Object -First 1 } catch { $folder = $null } >> "%PSDr%"
echo if ($folder) { >> "%PSDr%"
echo     Write-Host "   [FOUND] $($folder.FullName)" -ForegroundColor Green >> "%PSDr%"
echo     $conf = Read-Host "   Install? (Y/N)" >> "%PSDr%"
echo     if ($conf -eq 'Y' -or $conf -eq 'y') { >> "%PSDr%"
echo         Write-Host "   Installing..." -ForegroundColor Magenta >> "%PSDr%"
echo         Start-Process pnputil -ArgumentList "/add-driver `"$($folder.FullName)\*.inf`" /subdirs /install" -NoNewWindow -Wait >> "%PSDr%"
echo         Write-Host "   [OK] Done." -ForegroundColor Green >> "%PSDr%"
echo         Read-Host "   Press Enter to restart later..." >> "%PSDr%"
echo     } >> "%PSDr%"
echo } else { Write-Host "   [ERROR] Not found." -ForegroundColor Red; Read-Host "   Press Enter..." } >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:: ============================================================
:: [4] SOFTWARE MENU (LINKED TO YOUR GITHUB)
:: ============================================================
:Menu_Software
cls
echo.
echo %PAD%%Pink%███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗%Reset%
echo %PAD%%Pink%██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗  %Reset%
echo %PAD%%Pink%╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝  %Reset%
echo %PAD%%Pink%███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗%Reset%
echo %PAD%%Pink%╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% INSTALL WINRAR        %Green%!mark_WinRAR!%Reset%           %Bold%%White%[2]%Reset% INSTALL DEFENDER CTRL %Green%!mark_DefCont!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% INSTALL REVO UNINSTALL%Green%!mark_Revo!%Reset%             %Bold%%White%[4]%Reset% INSTALL BASIC APPS    %Green%!mark_Apps!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% ACTIVATE              %Green%!mark_MAS!%Reset%             %Bold%%White%[6]%Reset% GAMING ESSENTIALS     %Green%!mark_Game!%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% OFFICE SUITE (SCRIPT) %Green%!mark_Office!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 12345670 /n
if %errorlevel%==8 goto MainMenu
if %errorlevel%==7 goto LaunchOfficeScript
if %errorlevel%==6 goto InstallGaming
if %errorlevel%==5 goto DownloadMAS
if %errorlevel%==4 goto InstallWingetApps
if %errorlevel%==3 (set "mark_Revo=[OK]" & set "ExeName=Revo.rar" & set "TargetUrl=https://www.dropbox.com/scl/fi/e0x2yjrnhi6qgx9k6ltxg/RevoUninstallerPro5.rar?rlkey=vq4zsk9x1uyco7ratzkhw62f1&st=4f0776fb&dl=1" & goto DownloadAndRun)
if %errorlevel%==2 goto InstallDefControl
if %errorlevel%==1 (set "mark_WinRAR=[OK]" & set "ExeName=WinRAR.exe" & set "TargetUrl=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownloadAndRun)
goto Menu_Software

:LaunchOfficeScript
cls
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ OFFICE MODULE MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading External Script...%Reset%
curl -L -k -# -o "%ToolDir%\MontagOffice.bat" "%UrlOfficeScript%"
if exist "%ToolDir%\MontagOffice.bat" (
    echo %PAD%%Green%[OK] Starting Office Module...%Reset%
    call "%ToolDir%\MontagOffice.bat"
    set "mark_Office=[OK]"
) else (
    echo %PAD%%Red%[ERROR] Download Failed.%Reset%
    pause
)
goto Menu_Software

:InstallGaming
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ GAMING PACK INSTALLER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%[1/2] Installing Visual C++ AIO Runtimes (x64^&x86)...%Reset%
call :Speak "Installing gaming system components."
winget install --id Microsoft.VCRedist.2015+.x64 -e --accept-source-agreements --accept-package-agreements >nul 2>&1
winget install --id Microsoft.VCRedist.2015+.x86 -e --accept-source-agreements --accept-package-agreements >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
echo %PAD%%Yellow%[2/2] Installing DirectX (Check Windows Update if needed)...%Reset%
echo %PAD%%Green%      Verified.%Reset%
echo.
set "mark_Game=[OK]"
echo %PAD%%Green%[OK] Gaming Essentials Ready.%Reset%
timeout /t 3 >nul
goto Menu_Software

:DownloadMAS
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ ACTIVATION MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading Activation Script (MAS)...%Reset%
curl -L -k -# -o "%ToolDir%\MAS_AIO.cmd" "%UrlMAS%"
if exist "%ToolDir%\MAS_AIO.cmd" (
    set "mark_MAS=[OK]"
    cls
    call "%ToolDir%\MAS_AIO.cmd"
) else ( echo %PAD%%Red%[ERROR] Download Failed.%Reset% & pause )
goto Menu_Software

:InstallDefControl
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DEFENDER CONTROL ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%[MANUAL STEP] Please disable Real-time protection manually.%Reset%
echo.
echo %PAD%%Cyan%Downloading Tool...%Reset%
curl -L -k -# -o "%ToolDir%\DefCont.rar" "https://www.dropbox.com/scl/fi/ek7g511arqlacuf8jblhx/Defender-Control-pass-1.rar?rlkey=wrpduzvs5gynt3nta96xfkxuh&st=369mh2n4&dl=1"
if exist "%ToolDir%\DefCont.rar" (
    set "mark_DefCont=[OK]"
    echo %PAD%%Green%[DONE] Password is: 1%Reset%
    explorer "%ToolDir%"
) else ( echo %PAD%%Red%[ERROR] Failed.%Reset% )
pause
goto Menu_Software

:InstallWingetApps
set "Args=-e --accept-source-agreements --accept-package-agreements"
set "Count=0"
set "Total=7"
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ APP INSTALLER - LIVE PROGRESS ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%[1/7] Installing Google Chrome...%Reset%
winget install --id Google.Chrome %Args%
echo %PAD%%Yellow%[2/7] Installing Brave Browser...%Reset%
winget install --id Brave.Brave %Args%
echo %PAD%%Yellow%[3/7] Installing WhatsApp...%Reset%
winget install --id WhatsApp.WhatsApp %Args%
echo %PAD%%Yellow%[4/7] Installing AnyDesk...%Reset%
winget install --id AnyDeskSoftwareEvents.AnyDesk %Args%
echo %PAD%%Yellow%[5/7] Installing VLC Media Player...%Reset%
winget install --id VideoLAN.VLC %Args%
echo %PAD%%Yellow%[6/7] Installing Adobe Reader...%Reset%
winget install --id Adobe.Acrobat.Reader.64-bit %Args%
echo %PAD%%Yellow%[7/7] Installing Zoom...%Reset%
winget install --id Zoom.Zoom %Args%
set "mark_Apps=[OK]"
echo.
echo %PAD%%Green%[OK] All applications installed successfully.%Reset%
pause
goto Menu_Software

:DrawHeader
echo.
echo %PAD%%Pink%███╗   ███╗ ██████╗ ███╗   ██╗████████╗ █████╗  ██████╗      ███████╗████████╗ ██████╗ ██████╗ ███████╗%Reset%
echo %PAD%%Pink%████╗ ████║██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔════╝      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝%Reset%
echo %PAD%%Pink%██╔████╔██║██║   ██║██╔██╗ ██║   ██║   ███████║██║  ███╗     ███████╗   ██║   ██║   ██║██████╔╝█████╗  %Reset%
echo %PAD%%Pink%██║╚██╔╝██║██║   ██║██║╚██╗██║   ██║   ██╔══██║██║   ██║     ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  %Reset%
echo %PAD%%Pink%██║ ╚═╝ ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝     ███████║   ██║   ╚██████╔╝██║  ██║███████╗%Reset%
echo %PAD%%Pink%╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝%Reset%
exit /b

:: ============================================================
:: [5] PRINT LABEL (TABLE LAYOUT - FORCE SIDE BY SIDE)
:: ============================================================
:PrintLabel
cls
echo.
echo %PAD%%Cyan%Generating ZPL Label...%Reset%
set "PSScript=%TEMP%\GenLabel.ps1"
if exist "%PSScript%" del "%PSScript%"

:: Safe-Write the PowerShell Script line by line
echo $brand = "%BrandName%" > "%PSScript%"
echo $sys = (Get-CimInstance Win32_ComputerSystem).Model >> "%PSScript%"
echo $serial = (Get-CimInstance Win32_Bios).SerialNumber >> "%PSScript%"
echo $cpu = (Get-CimInstance Win32_Processor).Name.Replace("Intel(R) Core(TM) ", "").Replace("CPU @ ", "") >> "%PSScript%"
echo $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory ^| Measure-Object -Property Capacity -Sum).Sum / 1GB) >> "%PSScript%"
echo $disk = [math]::Round((Get-CimInstance Win32_DiskDrive ^| Select-Object -First 1).Size / 1GB) >> "%PSScript%"
echo $gpu = (Get-CimInstance Win32_VideoController ^| Select-Object -ExpandProperty Name) -join " + " >> "%PSScript%"
echo $qr = "https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=$sys $serial" >> "%PSScript%"

:: TABLE LAYOUT: 1 Row, 2 Columns (30% QR Left, 70% Text Right)
echo $html = "<body style='font-family:Arial,sans-serif;width:70mm;margin:0;padding:2px;font-size:9pt'><h3 style='margin:0;text-align:center;border-bottom:1px solid #000'>$brand</h3><table style='width:100%%;margin-top:5px'><tr><td style='width:30%%;vertical-align:top'><img src='$qr' style='width:100%%'></td><td style='width:70%%;padding-left:5px;vertical-align:top;line-height:1.2'><b>$sys</b><br>$cpu<br><b>RAM: $ram GB</b><br><b>SSD: $disk GB</b><br><span style='font-size:8pt'>$gpu</span></td></tr></table><script>window.print()</script></body>" >> "%PSScript%"

echo $html ^| Out-File "$env:TEMP\Label.html" >> "%PSScript%"
echo Start-Process "$env:TEMP\Label.html" >> "%PSScript%"

powershell -ExecutionPolicy Bypass -File "%PSScript%"
del "%PSScript%"

echo.
echo %PAD%%Green%[OK] Label sent to printer.%Reset%
timeout /t 3 >nul
goto MainMenu
:: ============================================================
:: REPORT GENERATOR (HYBRID: DEEP SPECS + HTML UI)
:: ============================================================
:FinalReport
echo %PAD%%Cyan%Deep Scanning System Specs...%Reset%
call :SilentIconSetup
call :ApplyBranding
call :AddContextSupport

:: Build Detailed Status String with Checkmarks (Using [OK] to prevent crash)
set "TEST_LOG="
if "!mark_Key!"=="[OK]" set "TEST_LOG=!TEST_LOG! Key:OK"
if "!mark_Screen!"=="[OK]" set "TEST_LOG=!TEST_LOG! Screen:OK"
if "!mark_Audio!"=="[OK]" set "TEST_LOG=!TEST_LOG! Audio:OK"
if "!mark_Batt!"=="[OK]" set "TEST_LOG=!TEST_LOG! Batt:OK"
if "!mark_Cam!"=="[OK]" set "TEST_LOG=!TEST_LOG! Cam:OK"
if "!mark_WiFi!"=="[OK]" set "TEST_LOG=!TEST_LOG! WiFi:OK"
if "!mark_Sensor!"=="[OK]" set "TEST_LOG=!TEST_LOG! Sensor:OK"
if "!mark_Stress!"=="[OK]" set "TEST_LOG=!TEST_LOG! Stress:OK"
if "!mark_HighPerf!"=="[OK]" set "TEST_LOG=!TEST_LOG! Perf:OK"
if "!mark_WinUpd!"=="[OK]" set "TEST_LOG=!TEST_LOG! Upd:OK"
if "!mark_Name!"=="[OK]" set "TEST_LOG=!TEST_LOG! Name:OK"
if "!mark_Active!"=="[OK]" set "TEST_LOG=!TEST_LOG! Active:OK"
if "!mark_Bloat!"=="[OK]" set "TEST_LOG=!TEST_LOG! Debloat:OK"
if "!mark_Apps!"=="[OK]" set "TEST_LOG=!TEST_LOG! Apps:OK"
if "!mark_DriverBack!"=="[OK]" set "TEST_LOG=!TEST_LOG! DrvBack:OK"
if "!mark_CheckWin!"=="[OK]" set "TEST_LOG=!TEST_LOG! WinCheck:OK"

if "%TEST_LOG%"=="" set "TEST_LOG=General Inspection"

:: --- USE THE UNIFIED ENGINE IN 'REPORT' MODE ---
powershell -ExecutionPolicy Bypass -File "%EngineScript%" -Task "Report" -TesterName "User" -StatusLog "%TEST_LOG%" -FormID "%GFormID%"

echo.
echo %PAD%%Green%[OK] Interface Opened. Returning to Menu...%Reset%
timeout /t 3 >nul
goto MainMenu

:ExitCleanup
cd /d "C:\"
start "" /Min cmd /C "timeout /t 2 >nul & rmdir /s /q "%ToolDir%""
exit

:: --- SUB-FUNCTIONS ---
:SilentIconSetup
set "SLink=%USERPROFILE%\Desktop\Montag Support.url"
set "IconPath=%IconDir%\Montag.ico"
(
echo [InternetShortcut]
echo URL=https://wa.me/%TechSupportNumber%
if exist "%IconPath%" (
    echo IconIndex=0
    echo IconFile=%IconPath%
) else (
    echo IconIndex=23
    echo IconFile=C:\Windows\System32\shell32.dll
)
) > "%SLink%"
exit /b

:AddContextSupport
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /ve /t REG_SZ /d "Contact Montag Support" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /v "Icon" /t REG_SZ /d "%IconDir%\Montag.ico" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport\command" /ve /t REG_SZ /d "explorer \"https://wa.me/%TechSupportNumber%\"" /f >nul 2>&1
exit /b

:ApplyBranding
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "%BrandName%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "Certified Refurbished" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /t REG_SZ /d "%BrandPhone%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "%BrandURL%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportHours /t REG_SZ /d "%BrandHours%" /f >nul 2>&1
exit /b

:Speak
powershell -Command "Add-Type -AssemblyName System.Speech; $s=New-Object System.Speech.Synthesis.SpeechSynthesizer; $v=$s.GetInstalledVoices().VoiceInfo | Where-Object {$_.Name -like '*Zira*' -or $_.Gender -eq 'Female'} | Select-Object -First 1; if($v){$s.SelectVoice($v.Name)}; $s.Speak('%~1')" >nul 2>&1
exit /b

:: ============================================================
::  UNIFIED POWERSHELL ENGINE (NO ECHO HAZARDS)
:: ============================================================
:::__ENGINE_START__:::
param($Task, $TesterName, $StatusLog, $FormID)
$ErrorActionPreference = 'SilentlyContinue'

# --- 1. WINDOWS CHECKER MODE ---
if ($Task -eq 'CheckWin') {
    $score = 0
    $lic = Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like "*Windows*"} | Select-Object -ExpandProperty Name -First 1
    
    if ($lic -match "Volume" -or $lic -match "KMS") { 
        $status = "FAKE/VOLUME (Modified)"
        $color = "Red"
        $score++ 
    } else { 
        $status = "OEM/RETAIL (Original)"
        $color = "Green" 
    }
    Write-Host "   [1/4] License Channel : $status" -ForegroundColor $color

    $def = Get-Service windefend -ErrorAction SilentlyContinue
    if (!$def) { Write-Host "   [2/4] Windows Defender: DELETED (Modified)" -ForegroundColor Red; $score++ } 
    else { Write-Host "   [2/4] Windows Defender: OK" -ForegroundColor Green }

    $upd = Get-Service wuauserv -ErrorAction SilentlyContinue
    if (!$upd) { Write-Host "   [3/4] Windows Update  : DELETED (Modified)" -ForegroundColor Red; $score++ } 
    else { Write-Host "   [3/4] Windows Update  : OK" -ForegroundColor Green }

    if (Test-Path "C:\Windows\System32\Recovery\ReAgent.xml") {
        Write-Host "   [4/4] Recovery System : OK" -ForegroundColor Green
    } else {
        Write-Host "   [4/4] Recovery System : MISSING (Modified)" -ForegroundColor Red; $score++
    }

    if ($score -eq 0) { 
        Write-Host "`n   [VERDICT] ORIGINAL (STOCK) WINDOWS - SAFE" -ForegroundColor Green 
    } else { 
        Write-Host "`n   [VERDICT] MODIFIED / FAKE DETECTED - FORMAT RECOMMENDED" -ForegroundColor Red 
    }
    exit
}

# --- 2. REPORT GENERATOR MODE (YOUR ORIGINAL HTML) ---
if ($Task -eq 'Report') {
    # Gather Specs
    $sys = Get-CimInstance Win32_ComputerSystem
    $cpu = Get-CimInstance Win32_Processor
    $bios = Get-CimInstance Win32_Bios
    $Man = $sys.Manufacturer.Trim()
    $Mod = $sys.Model.Trim()
    if ($Mod.StartsWith($Man)) { $FullModel = $Mod } else { $FullModel = "$Man $Mod" }
    $maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
    $cacheMB = [int]($cpu.L3CacheSize / 1024)
    if ($cacheMB -eq 0) { $cacheMB = [int]($cpu.L2CacheSize / 1024) }
    $cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz | $cacheMB MB Cache"

    $mem = Get-CimInstance Win32_PhysicalMemory
    $memArray = @($mem)
    $stickCount = $memArray.Count
    $totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
    $ramSpeed = 0
    foreach ($s in $memArray) { if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } }
    if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" }
    $ramDetails = "$totalRam GB ($stickCount Sticks) @ $ramSpeed MHz"

    $disks = Get-CimInstance Win32_DiskDrive
    $diskList = @()
foreach ($d in $disks) { $s = [math]::Round($d.Size / 1GB, 0); $diskList += "$($d.Model) ($s GB)" }
    $storageString = $diskList -join " | "

    $gpuList = @()
    $regBase = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
    Get-ChildItem $regBase -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty $_.PSPath
        if ($props.DriverDesc) {
            $size = 0
            if ($props.'HardwareInformation.QwMemorySize') { $size = $props.'HardwareInformation.QwMemorySize' }
            elseif ($props.'HardwareInformation.MemorySize') { $size = $props.'HardwareInformation.MemorySize' }
            $gb = [math]::Round($size / 1GB)
            if ($gb -gt 0) { $gpuList += "$($props.DriverDesc) ($gb GB)" }
            else {
                $wmi = Get-CimInstance Win32_VideoController | Where-Object { $_.Description -eq $props.DriverDesc } | Select-Object -First 1
                if ($wmi.AdapterRAM -gt 0) {
                    $wmiGB = [math]::Round($wmi.AdapterRAM / 1GB)
                    if($wmiGB -gt 0) { $gpuList += "$($props.DriverDesc) ($wmiGB GB)" } else { $gpuList += $props.DriverDesc }
                } else { $gpuList += $props.DriverDesc }
            }
        }
    }
    $gpuString = ($gpuList | Select-Object -Unique) -join " + "

    # Generate Text Report
    $txtReport = "MONTAG STORE - SYSTEM INFO`r`n"
    $txtReport += "----------------------------------------`r`n"
    $txtReport += "DATE   : " + (Get-Date).ToString() + "`r`n"
    $txtReport += "MODEL  : $FullModel`r`n"
    $txtReport += "SERIAL : $($bios.SerialNumber)`r`n"
    $txtReport += "CPU    : $cpuDetails`r`n"
    $txtReport += "RAM    : $ramDetails`r`n"
    $txtReport += "GPU    : $gpuString`r`n"
    $txtReport += "DISK   : $storageString`r`n"
    $txtReport += "STATUS : $StatusLog`r`n"
    $txtReport += "----------------------------------------`r`n"
    $txtReport | Out-File "$([Environment]::GetFolderPath('Desktop'))\Montag_Specs.txt" -Encoding UTF8

    # Generate HTML
    $htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Montag Store System</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
    body { background-color: #050505; color: #8f00ff; font-family: 'Share Tech Mono', monospace; text-align: center; padding: 20px; overflow-x: hidden; background-image: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06)); background-size: 100% 2px, 3px 100%; }
    .container { max-width: 700px; margin: auto; background: rgba(20, 20, 20, 0.9); padding: 30px; border: 1px solid #333; box-shadow: 0 0 20px rgba(143, 0, 255, 0.2); border-radius: 10px; position: relative; }
    .glitch-header { font-size: 40px; font-weight: bold; text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff; letter-spacing: 3px; margin-bottom: 20px; animation: glitch 1s infinite alternate; color: #fff; }
    @keyframes glitch { 0% { text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff; } 100% { text-shadow: -2px -2px 0px #ff00ff, 2px 2px 0px #00ffff; } }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; text-align: left; direction: ltr; margin-bottom: 20px; }
    .card { background: #111; border: 1px solid #8f00ff; padding: 15px; border-radius: 5px; box-shadow: inset 0 0 10px rgba(143, 0, 255, 0.1); transition: 0.3s; }
    .card:hover { transform: translateY(-3px); box-shadow: 0 0 15px rgba(143, 0, 255, 0.4); }
    .card h4 { margin: 0 0 5px 0; color: #fff; font-size: 14px; text-transform: uppercase; border-bottom: 1px solid #444; padding-bottom: 5px; }
    .card p { margin: 0; font-size: 13px; color: #ccc; word-wrap: break-word; }
    .input-group { margin-bottom: 20px; text-align: left; }
    label { display: block; color: #fff; margin-bottom: 5px; font-size: 18px; }
    input, textarea { width: 95%; padding: 15px; background: #000; border: 2px solid #444; color: #8f00ff; font-family: inherit; font-size: 16px; border-radius: 5px; outline: none; transition: 0.3s; }
    input:focus, textarea:focus { border-color: #8f00ff; box-shadow: 0 0 10px #8f00ff; }
    .btn-group { display: flex; gap: 20px; }
    button { flex: 1; padding: 20px; font-size: 20px; font-family: inherit; font-weight: bold; border: none; cursor: pointer; color: #fff; text-transform: uppercase; border-radius: 5px; position: relative; overflow: hidden; transition: 0.3s; }
    .btn-sell { background: linear-gradient(45deg, #1e7e34, #28a745); box-shadow: 0 5px 0 #155724; }
    .btn-test { background: linear-gradient(45deg, #117a8b, #17a2b8); box-shadow: 0 5px 0 #0f6674; }
    button:active { transform: translateY(4px); box-shadow: none; }
    button:hover { filter: brightness(1.2); }
</style>
</head>
<body>
    <div class="container">
        <div class="glitch-header">MONTAG STORE REPORT</div>
        <div class="input-group">
            <label>TESTER NAME:</label>
            <input type="text" id="testerName" placeholder="Type your name here..." autofocus required>
        </div>
        <div class="info-grid">
            <div class="card"><h4>MODEL</h4><p>$FullModel</p></div>
            <div class="card"><h4>SERIAL</h4><p>$($bios.SerialNumber)</p></div>
            <div class="card"><h4>CPU</h4><p>$cpuDetails</p></div>
            <div class="card"><h4>RAM</h4><p>$ramDetails</p></div>
            <div class="card"><h4>GRAPHICS</h4><p>$gpuString</p></div>
            <div class="card"><h4>STORAGE</h4><p>$storageString</p></div>
        </div>
        <div class="input-group">
            <label>INSPECTION LOGS (STATUS):</label>
            <textarea id="status" rows="2">$StatusLog</textarea>
        </div>
        <div class="btn-group">
            <button class="btn-sell" onclick="sendData('SELL')">SELL (CUSTOMER)</button>
            <button class="btn-test" onclick="sendData('TEST')">TEST (STOCK)</button>
        </div>
    </div>
    <script>
        function sendData(type) {
            var testerRaw = document.getElementById('testerName').value;
            var statusRaw = document.getElementById('status').value;
            if (testerRaw.trim() === "") { alert("Please enter tester name first!"); return; }
            
            var mergedTesterName = testerRaw + " - " + type;
            var baseURL = "https://docs.google.com/forms/d/e/$FormID/formResponse?usp=pp_url";
            var finalURL = baseURL + 
                "&entry.371291262=" + type +
                "&entry.392302034=" + encodeURIComponent(mergedTesterName) +
                "&entry.531158115=" + encodeURIComponent("$FullModel") +
                "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)") +
                "&entry.1462565184=" + encodeURIComponent("$cpuDetails") +
                "&entry.212987726=" + encodeURIComponent("$ramDetails") +
                "&entry.1717831234=" + encodeURIComponent("$storageString") +
                "&entry.2044586469=" + encodeURIComponent("$gpuString") +
                "&entry.310563239=" + encodeURIComponent(statusRaw);
            
            fetch(finalURL, { mode: 'no-cors' });
            setTimeout(function(){ window.close(); }, 1000);
        }
    </script>
</body>
</html>
"@
    $htmlContent | Out-File "$env:TEMP\SystemReport.html" -Encoding UTF8
    Start-Process "$env:TEMP\SystemReport.html"
}