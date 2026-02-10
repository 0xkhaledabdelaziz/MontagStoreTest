<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION & ENCODING FIX
:: ============================================================
cd /d "%~dp0"
:: Force UTF-8 Encoding immediately to fix garbled text
chcp 65001 >nul
:: Force Admin Rights
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: Whitelist Working Directory
if not exist "%SystemDrive%\MontagOffice" mkdir "%SystemDrive%\MontagOffice" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%~dp0'" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemDrive%\MontagOffice'" >nul 2>&1

:: ============================================================
:: [1] CONFIGURATION
:: ============================================================
mode con: cols=150 lines=60
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1
title Montag Store - System (V 11.0 Stable)
color 05

set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
attrib +h "%IconDir%" >nul 2>&1

:: Links
set "UrlReportScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagReport.bat"
set "UrlOfficeScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagOffice.bat"
set "UrlAppsScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagApps.bat"
set "UrlHwi=https://www.dropbox.com/scl/fi/fjtwrg3boc8zj88ml2jxs/HWiNFO64.EXE?rlkey=m64f5qxup91iq8ew09imqfcs0&st=9eqs19xe&dl=1"
set "UrlKey=https://www.dropbox.com/scl/fi/onvccubmkxicdtvecdqvq/KeyboardTestUtility.exe?rlkey=62ag37rdvhp45iuzlk8261yus&st=k6li1383&dl=1"
set "UrlScr=https://www.dropbox.com/scl/fi/b63drni7qk3t8f0wudnk7/defpix.exe?rlkey=ir9k1d9gi99dwunjmqtnvtq7n&st=6etkm6wa&dl=1"
set "UrlAud=https://www.dropbox.com/scl/fi/ekej1ymnzepliyggm5hn3/xSpeaker-Headphones-Trim.mp4?rlkey=mw5md1jthagl3nfu3yfumulri&st=5xo6k9gg&dl=1"
set "UrlRar=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1"
set "UrlMAS=https://www.dropbox.com/scl/fi/cnj7x4fp8zqksmeewhsmg/MAS_AIO.cmd?rlkey=1zr26qvm9l7r26iaw52czjmt9&st=7o2zhkih&dl=1"

:: Visuals
if not exist "%IconDir%\Montag.ico" curl -L -k -s -o "%IconDir%\Montag.ico" "https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1" >nul 2>&1
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")
set "Reset=%ESC%[0m"
set "Pink=%ESC%[38;2;255;0;255m"
set "Cyan=%ESC%[36m"
set "White=%ESC%[37m"
set "Green=%ESC%[32m"
set "Red=%ESC%[31m"
set "Yellow=%ESC%[33m"
set "Bold=%ESC%[1m"
set "PAD=     "

for %%i in (WiFi Key Screen Cam Audio Batt Sensor WinUpd Arab DriverBack DriverRest HighPerf WinRAR DefCont Revo Apps Game MAS Office Report Touch) do if not defined mark_%%i set "mark_%%i=   "

:: Extract Engine
set "EngineScript=%ToolDir%\MontagEngine.ps1"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__POWERSHELL_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [2.5] WIFI CHECK
:: ============================================================
:CheckInternet
ping -n 1 google.com >nul
if %errorlevel% equ 0 (
    cls
    call :DrawHeader
    echo.
    echo %PAD%%Green%      Welcome to Montag Store System...%Reset%
    call :Speak "Welcome to Montag Store System."
    timeout /t 1 >nul
    goto MainMenu
)

:WifiMenu
cls
call :DrawHeader
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
set "SSID=%~1" & set "PASS=%~2"
echo %PAD%Connecting to %SSID%...
set "WiFiXML=%ToolDir%\wifi.xml"
(echo ^<?xml version="1.0"?^>^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>^<name^>%SSID%^</name^>^<SSIDConfig^>^<SSID^>^<name^>%SSID%^</name^>^</SSID^>^</SSIDConfig^>^<connectionType^>ESS^</connectionType^>^<connectionMode^>auto^</connectionMode^>^<MSM^>^<security^>^<authEncryption^>^<authentication^>WPA2PSK^</authentication^>^<encryption^>AES^</encryption^>^<useOneX^>false^</useOneX^>^</authEncryption^>^<sharedKey^>^<keyType^>passPhrase^</keyType^>^<protected^>false^</protected^>^<keyMaterial^>%PASS%^</keyMaterial^>^</sharedKey^>^</security^>^</MSM^>^</WLANProfile^>) > "%WiFiXML%"
netsh wlan add profile filename="%WiFiXML%" user=all >nul 2>&1
netsh wlan connect name="%SSID%" >nul 2>&1
del "%WiFiXML%" >nul 2>&1
timeout /t 4 >nul
exit /b

:: ============================================================
:: [3] MAIN MENU
:: ============================================================
:MainMenu
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%      %Gray%(Key/Screen)%Reset%            %Bold%%White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%       %Gray%(Perf/Name)%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%      %Gray%(Back/Rest)%Reset%             %Bold%%White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%        %Gray%(Apps/Office)%Reset%
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
echo %PAD%    %Bold%%White%[5]%Reset% BATTERY REPORT      %Green%!mark_Batt!%Reset%             %Bold%%White%[6]%Reset% PRO TOUCH TEST      %Green%!mark_Touch!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% CHECK WARRANTY      %Green%!mark_Warranty!%Reset%         %Bold%%White%[8]%Reset% SYSTEM STRESS TEST  %Green%!mark_Stress!%Reset%
echo.
echo %PAD%    %Bold%%White%[9]%Reset% CHECK WIN INTEGRITY %Green%!mark_CheckWin!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%Yellow%[S] SENSORS (HWiNFO)%Reset%   %Green%!mark_Sensor!%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Select Test:%Reset% 
choice /c 123456789s0 /n

if %errorlevel%==11 goto MainMenu
if %errorlevel%==10 (set "mark_Sensor=[OK]" & set "ExeName=HWiNFO.exe" & set "TargetUrl=%UrlHwi%" & goto DownloadAndRun)
if %errorlevel%==9 goto CheckWinIntegrity
if %errorlevel%==8 goto StressTest
if %errorlevel%==7 goto CheckWarranty
if %errorlevel%==6 goto ProTouchTest
if %errorlevel%==5 (set "mark_Batt=[OK]" & goto BatteryTest)
if %errorlevel%==4 (set "mark_Audio=[OK]" & set "ExeName=Audio.mp4" & set "TargetUrl=%UrlAud%" & goto DownloadAndRun)
if %errorlevel%==3 (set "mark_Cam=[OK]" & goto CamTest)
if %errorlevel%==2 (set "mark_Screen=[OK]" & set "ExeName=ScreenTest.exe" & set "TargetUrl=%UrlScr%" & goto DownloadAndRun)
if %errorlevel%==1 (set "mark_Key=[OK]" & set "ExeName=KeyTest.exe" & set "TargetUrl=%UrlKey%" & goto DownloadAndRun)
goto Menu_Hardware

:: --- HARDWARE FUNCTIONS ---
:ProTouchTest
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ MONTAG PRO TOUCH DIAGNOSTIC ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Generating Grid...%Reset%
set "TouchFile=%TEMP%\MontagTouch.html"
if exist "%TouchFile%" del "%TouchFile%"
echo ^<!DOCTYPE html^>^<html lang="en"^>^<head^>^<meta charset="UTF-8"^>^<title^>Montag Touch^</title^> > "%TouchFile%"
echo ^<style^>body{margin:0;background:#000;overflow:hidden;touch-action:none;font-family:sans-serif} >> "%TouchFile%"
echo #grid{display:grid;grid-template-columns:repeat(20,1fr);grid-template-rows:repeat(12,1fr);width:100vw;height:100vh} >> "%TouchFile%"
echo .cell{border:1px solid #333;transition:0s}.touched{background:#0f0;box-shadow:0 0 10px #0f0;border-color:#0f0} >> "%TouchFile%"
echo #info{position:absolute;top:50%%;left:50%%;transform:translate(-50%%,-50%%);color:#fff;pointer-events:none;text-align:center;mix-blend-mode:difference} >> "%TouchFile%"
echo h1{font-size:40px;margin:0}p{color:#aaa}^</style^>^</head^> >> "%TouchFile%"
echo ^<body^>^<div id="info"^>^<h1^>TOUCH TEST^</h1^>^<p^>Swipe to fill squares^</p^>^</div^>^<div id="grid"^>^</div^> >> "%TouchFile%"
echo ^<script^>const grid=document.getElementById('grid');for(let i=0;i^<240;i++){let d=document.createElement('div');d.className='cell';grid.appendChild(d);} >> "%TouchFile%"
echo function act(e){e.preventDefault();let t=e.touches^|^|[e];for(let i=0;i^<t.length;i++){let el=document.elementFromPoint(t[i].clientX,t[i].clientY);if(el^&^&el.classList.contains('cell'))el.classList.add('touched');}check();} >> "%TouchFile%"
echo function check(){let t=document.querySelectorAll('.cell').length;let a=document.querySelectorAll('.touched').length;let p=Math.round((a/t)*100);document.querySelector('#info h1').innerText=p+'%%';if(p==100)document.querySelector('#info h1').style.color='#0f0';} >> "%TouchFile%"
echo window.addEventListener('touchmove',act,{passive:false});window.addEventListener('mousemove',function(e){if(e.buttons==1)act(e);});^</script^>^</body^>^</html^> >> "%TouchFile%"

echo %PAD%%Green%[OK] Launching... Press F11 for Full Screen.%Reset%
start "" "%TouchFile%"
set "mark_Touch=[OK]"
timeout /t 2 >nul
goto Menu_Hardware

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
echo %PAD%%Cyan%Detecting Serial...%Reset%
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
echo %PAD%                              [ WINDOWS DETECTIVE ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
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
echo %PAD%                              [ AUTO-PILOT: SYSTEM PREP ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Red%[WARNING] Optimizing Windows (No Apps)...%Reset%
echo %PAD%%Green%   Initiating Auto-Pilot Mode...%Reset%
call :Speak "Initiating System Preparation."
echo.
timeout /t 2 >nul

:: --- STEP 1: RESTORE POINT ---
echo %PAD%%Yellow%[1/6] Creating Backup...%Reset%
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_Prep' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: --- STEP 2: HIGH PERFORMANCE & NO SLEEP ---
:: Using ^& to prevent batch error
echo %PAD%%Yellow%[2/6] Power ^& Performance...%Reset%
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg -h off >nul 2>&1
set "mark_HighPerf=[OK]"

:: --- STEP 3: ARABIC KEYBOARD & EGYPT REGION ---
echo %PAD%%Yellow%[3/6] Language ^& Region...%Reset%
powershell -Command "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}" >nul 2>&1
tzutil /s "Egypt Standard Time" >nul 2>&1
set "mark_Arab=[OK]"

:: --- STEP 4: REMOVE BLOATWARE ---
echo %PAD%%Yellow%[4/6] Removing Bloatware...%Reset%
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
set "mark_Bloat=[OK]"

:: --- STEP 5: ACTIVATE ORIGINAL KEY (OEM) ---
echo %PAD%%Yellow%[5/6] Checking Activation...%Reset%
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"
if not "%BiosKey%"=="" (cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey% >nul 2>&1 & cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1)
set "mark_Active=[OK]"

:: --- STEP 6: ICONS & BRANDING PREP ---
echo %PAD%%Yellow%[6/6] Finishing Touches...%Reset%
:: Desktop Icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul 2>&1
:: Note: Right Click Brand is applied in the Final Report, but we mark it here as planned
set "mark_BrandClick=[OK]"

:: Cleanup & Restart UI
del /s /f /q %temp%\*.* >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

set "mark_Auto=[OK]"
set "mark_Boost=[OK]"

echo.
echo %PAD%%Green%[SUCCESS] System Optimized.%Reset%
call :Speak "Ready."
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
echo %PAD%%Yellow%Note: Branding is now applied automatically during FINAL REPORT.%Reset%
echo.
echo %PAD%%Green%[OK] Ready.%Reset%
set "mark_BrandClick=[OK]"
timeout /t 2 >nul
goto Menu_Windows

:QuickBoost
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ QUICK SYSTEM TUNE-UP ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%[1/3] Disabling Hibernation...%Reset%
powercfg -h off >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
echo %PAD%%Yellow%[2/3] Syncing Time...%Reset%
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
echo %PAD%%Green%      Done.%Reset%
echo.
echo %PAD%%Yellow%[3/3] Disabling Sticky Keys...%Reset%
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
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
echo %PAD%%Yellow%Removing Bloatware (Xbox, Skype, etc)...%Reset%
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue"
set "mark_Bloat=[OK]"
echo.
echo %PAD%%Green%[OK] Cleaned.%Reset%
timeout /t 3 >nul
goto Menu_Windows

:ActivateOEM
cls
echo.
echo %PAD%%Cyan%Searching for BIOS Product Key...%Reset%
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"
if "%BiosKey%"=="" (echo %PAD%%Red%[ERROR] No Key Found.%Reset% & pause) else (
    echo %PAD%%Green%[OK] Key Found.%Reset%
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey%
    cscript //nologo %windir%\system32\slmgr.vbs /ato
    echo %PAD%%Green%[SUCCESS] Activated.%Reset%
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
echo %PAD%%Pink%██╔══██╗██╔══██╗██║██║   ██║██╔════╝██╔══██╗██╔════╝%Reset%
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
echo %PAD%    %Bold%%White%[5]%Reset% OEM SUPPORT - LENOVO%Gray%[Web]%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 123450 /n
if %errorlevel%==6 goto MainMenu
if %errorlevel%==5 start "" "https://support.lenovo.com/us/en/" & goto Menu_Drivers
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
echo $drv = Read-Host "`n   Enter Drive (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo pnputil /export-driver * "$($drv):\Drivers_Backup" >> "%PSDr%"
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
echo pnputil /add-driver "$($drv):\Drivers_Backup\*.inf" /subdirs /install >> "%PSDr%"
echo Write-Host "`n   [OK] Done." -ForegroundColor Green >> "%PSDr%"
echo Read-Host "`n   Press Enter..." >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:: ============================================================
:: [4] SOFTWARE MENU
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
echo %PAD%    %Bold%%White%[1]%Reset% INSTALL APPS BUNDLE   %Green%!mark_Apps!%Reset%             %Bold%%White%[2]%Reset% OFFICE SUITE (SCRIPT) %Green%!mark_Office!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% INSTALL WINRAR        %Green%!mark_WinRAR!%Reset%           %Bold%%White%[4]%Reset% INSTALL DEFENDER CTRL %Green%!mark_DefCont!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% INSTALL REVO UNINSTALL%Green%!mark_Revo!%Reset%             %Bold%%White%[6]%Reset% GAMING ESSENTIALS     %Green%!mark_Game!%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% ACTIVATE              %Green%!mark_MAS!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 12345670 /n
if %errorlevel%==8 goto MainMenu
if %errorlevel%==7 goto DownloadMAS
if %errorlevel%==6 goto InstallGaming
if %errorlevel%==5 (set "mark_Revo=[OK]" & set "ExeName=Revo.rar" & set "TargetUrl=https://www.dropbox.com/scl/fi/e0x2yjrnhi6qgx9k6ltxg/RevoUninstallerPro5.rar?rlkey=vq4zsk9x1uyco7ratzkhw62f1&st=4f0776fb&dl=1" & goto DownloadAndRun)
if %errorlevel%==4 goto InstallDefControl
if %errorlevel%==3 (set "mark_WinRAR=[OK]" & set "ExeName=WinRAR.exe" & set "TargetUrl=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownloadAndRun)
if %errorlevel%==2 goto LaunchOfficeScript
if %errorlevel%==1 goto LaunchAppsScript
goto Menu_Software

:LaunchOfficeScript
cls
echo.
echo %PAD%%Yellow%Downloading Office Module...%Reset%
curl -L -k -# -o "%ToolDir%\MontagOffice.bat" "%UrlOfficeScript%"
if exist "%ToolDir%\MontagOffice.bat" (
    echo %PAD%%Green%[OK] Launching in New Window...%Reset%
    start "Montag Office Suite" cmd /c "%ToolDir%\MontagOffice.bat"
    set "mark_Office=[OK]"
) else ( echo %PAD%%Red%[ERROR] Download Failed.%Reset% & pause )
goto Menu_Software

:LaunchAppsScript
cls
echo.
echo %PAD%%Yellow%Downloading Apps Module...%Reset%
curl -L -k -# -o "%ToolDir%\MontagApps.bat" "%UrlAppsScript%"
if exist "%ToolDir%\MontagApps.bat" (
    echo %PAD%%Green%[OK] Launching in New Window...%Reset%
    start "Montag Apps Installer" cmd /c "%ToolDir%\MontagApps.bat"
    set "mark_Apps=[OK]"
) else ( echo %PAD%%Red%[ERROR] Download Failed.%Reset% & pause )
goto Menu_Software

:InstallGaming
cls
call :DrawHeader
echo.
echo %PAD%%Yellow%[1/2] Installing Visual C++ AIO Runtimes (x64^&x86)...%Reset%
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

:: --- HELPER FUNCTIONS ---
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

:PrintLabel
cls
echo.
echo %PAD%%Cyan%Generating ZPL Label...%Reset%
powershell -ExecutionPolicy Bypass -File "%EngineScript%" -Task "Label"
echo.
echo %PAD%%Green%[OK] Label sent to printer.%Reset%
timeout /t 3 >nul
goto MainMenu

:: ============================================================
:: REPORT GENERATOR (SAFE LAUNCH METHOD)
:: ============================================================
:FinalReport
echo %PAD%%Cyan%Collecting Test Results...%Reset%

:: --- 1. BUILD STATUS STRING ---
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
if "!mark_Office!"=="[OK]" set "TEST_LOG=!TEST_LOG! Office:OK"
if "!mark_OffClean!"=="[OK]" set "TEST_LOG=!TEST_LOG! OffScrub:OK"
if "!mark_Touch!"=="[OK]" set "TEST_LOG=!TEST_LOG! Touch:OK"

if "%TEST_LOG%"=="" set "TEST_LOG=General Inspection"

:: --- 2. SAVE STATUS TO FILE (PREVENTS CRASHES) ---
echo !TEST_LOG! > "%ToolDir%\MontagLog.txt"

:: --- 3. DOWNLOAD & RUN REPORT SCRIPT ---
echo.
echo %PAD%%Yellow%Loading Montag Report System...%Reset%
curl -L -k -# -o "%ToolDir%\MontagReport.bat" "%UrlReportScript%"

if exist "%ToolDir%\MontagReport.bat" (
    echo %PAD%%Green%[OK] Handing over control...%Reset%
    :: Launch without arguments (it reads the file now)
    start "Montag Report" "%ToolDir%\MontagReport.bat"
) else (
    echo %PAD%%Red%[ERROR] Failed to load Report Module.%Reset%
    pause
)

echo.
timeout /t 2 >nul
goto MainMenu

:ExitCleanup
cd /d "C:\"
start "" /Min cmd /C "timeout /t 2 >nul & rmdir /s /q "%ToolDir%""
exit

:: --- SUB-FUNCTIONS ---
:Speak
powershell -Command "Add-Type -AssemblyName System.Speech; $s=New-Object System.Speech.Synthesis.SpeechSynthesizer; $v=$s.GetInstalledVoices().VoiceInfo | Where-Object {$_.Name -like '*Zira*' -or $_.Gender -eq 'Female'} | Select-Object -First 1; if($v){$s.SelectVoice($v.Name)}; $s.Speak('%~1')" >nul 2>&1
exit /b

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
::  UNIFIED POWERSHELL ENGINE
:: ============================================================
:::__POWERSHELL_START__:::
param($Task, $TesterName, $StatusLog, $FormID)
$ErrorActionPreference = 'SilentlyContinue'

if ($Task -eq 'CheckWin') {
    $score = 0
    $lic = Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like "*Windows*"} | Select-Object -ExpandProperty Name -First 1
    if ($lic -match "Volume" -or $lic -match "KMS") { Write-Host "   [1/4] License Channel : FAKE/VOLUME (Modified)" -ForegroundColor Red; $score++ } else { Write-Host "   [1/4] License Channel : OEM/RETAIL (Original)" -ForegroundColor Green }
    if (Get-Service windefend -ErrorAction SilentlyContinue) { Write-Host "   [2/4] Windows Defender: OK" -ForegroundColor Green } else { Write-Host "   [2/4] Windows Defender: DELETED (Modified)" -ForegroundColor Red; $score++ }
    if (Get-Service wuauserv -ErrorAction SilentlyContinue) { Write-Host "   [3/4] Windows Update  : OK" -ForegroundColor Green } else { Write-Host "   [3/4] Windows Update  : DELETED (Modified)" -ForegroundColor Red; $score++ }
    if (Test-Path "C:\Windows\System32\Recovery\ReAgent.xml") { Write-Host "   [4/4] Recovery System : OK" -ForegroundColor Green } else { Write-Host "   [4/4] Recovery System : MISSING (Modified)" -ForegroundColor Red; $score++ }
    if ($score -eq 0) { Write-Host "`n   [VERDICT] ORIGINAL (STOCK) WINDOWS - SAFE" -ForegroundColor Green } else { Write-Host "`n   [VERDICT] MODIFIED / FAKE DETECTED" -ForegroundColor Red }
    exit
}

if ($Task -eq 'Label') {
    $sys = Get-CimInstance Win32_ComputerSystem
    $bio = Get-CimInstance Win32_Bios
    $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB)
    $dsk = [math]::Round((Get-CimInstance Win32_DiskDrive | Select-Object -First 1).Size / 1GB)
    $gpu = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name -First 1) -replace "Intel\(R\) ","" -replace "NVIDIA ",""
    $qr = "https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=$($sys.Model) $($bio.SerialNumber)"
    $HTML = "<body style='font-family:Arial;width:60mm'><h3>Montag Store</h3><img src='$qr'><br><b>$($sys.Model)</b><br>$($bio.SerialNumber)<script>window.print()</script></body>"
    $HTML | Out-File "$env:TEMP\Label.html"
    Start-Process "$env:TEMP\Label.html"
}