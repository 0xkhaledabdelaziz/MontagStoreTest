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

title Montag Store - Enterprise System (V 199.0 Turbo Clean)
color 07

:: ============================================================
:: [2] CONFIGURATION
:: ============================================================
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1

set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
attrib +h "%IconDir%" >nul 2>&1

set "BrandName=Montag Store"
set "BrandPhone=01090040022"
set "BrandURL=https://montagstore.com"
set "BrandHours=Sat-Thu 12PM-9PM"
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"

:: URLs Setup
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

:: Checkmarks
for %%i in (WiFi Key Screen Cam Audio Batt Specs Sensor WinUpd OEM Arab DriverBack DriverRest HighPerf Label WinRAR DefCont Revo Brand Apps Disk Mic Intake Clean Name Warranty Active Bloat Stress MAS) do if not defined mark_%%i set "mark_%%i=   "

:: ============================================================
:: [2.5] WIFI CHECK & MENU
:: ============================================================
:CheckInternet
ping -n 1 google.com >nul
if %errorlevel% equ 0 goto MainMenu

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
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK TO MAIN%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Select Test:%Reset% 
choice /c 123456780 /n

if %errorlevel%==9 goto MainMenu
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

:DownloadAndRun
set "Exe=%ToolDir%\%ExeName%"
if not exist "%ToolDir%" mkdir "%ToolDir%"
if exist "%Exe%" (start "" "%Exe%" & goto ReturnPoint)
:: --- MODIFIED: REMOVED RESIZE + ADDED BLOCK LOGO + CURL PROGRESS BAR (-#) ---
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DOWNLOAD MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading: %White%%ExeName%...
echo.
:: -# enables hash-style progress bar
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
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 1234560 /n
if %errorlevel%==7 goto MainMenu
if %errorlevel%==6 goto RemoveBloatware
if %errorlevel%==5 goto ActivateOEM
if %errorlevel%==4 goto RenameUser
if %errorlevel%==3 (set "mark_WinUpd=[OK]" & goto WinUpdate)
if %errorlevel%==2 (set "mark_Arab=[OK]" & goto AddArabic)
if %errorlevel%==1 (set "mark_HighPerf=[OK]" & goto HighPerf)
goto Menu_Windows

:RemoveBloatware
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ SYSTEM CLEANUP MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Removing Bloatware & Junk Apps...%Reset%
echo.

:: --- LIST OF APPS TO REMOVE ---
:: 1. Gaming & Xbox
echo %PAD%- Removing Xbox & Solitaire...
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue"

:: 2. 3D Apps & Mixed Reality
echo %PAD%- Removing 3D Viewer, Paint 3D & VR...
powershell -Command "Get-AppxPackage *3d* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *reality* | Remove-AppxPackage -ErrorAction SilentlyContinue"

:: 3. Microsoft Services (News, Weather, Maps)
echo %PAD%- Removing Maps, News, Weather & Money...
powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue"

:: 4. Useless Media Apps (Replaced by VLC)
echo %PAD%- Removing Groove Music & Movies...
powershell -Command "Get-AppxPackage *zune* | Remove-AppxPackage -ErrorAction SilentlyContinue"

:: 5. Communication & Ads
echo %PAD%- Removing Skype, YourPhone, Tips & Feedback...
powershell -Command "Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *phone* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *getstarted* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *feedback* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *officehub* | Remove-AppxPackage -ErrorAction SilentlyContinue"

set "mark_Bloat=[OK]"
echo.
echo %PAD%%Green%[OK] System is now Clean & Fast.%Reset%
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
echo %PAD%    %Bold%%White%[1]%Reset% INSTALL WINRAR        %Green%!mark_WinRAR!%Reset%           %Bold%%White%[2]%Reset% INSTALL DEFENDER CTRL %Green%!mark_DefCont!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% INSTALL REVO UNINSTALL%Green%!mark_Revo!%Reset%             %Bold%%White%[4]%Reset% INSTALL BASIC APPS    %Green%!mark_Apps!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% ACTIVATE              %Green%!mark_MAS!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 123450 /n
if %errorlevel%==6 goto MainMenu
if %errorlevel%==5 goto DownloadMAS
if %errorlevel%==4 goto InstallWingetApps
if %errorlevel%==3 (set "mark_Revo=[OK]" & set "ExeName=Revo.rar" & set "TargetUrl=https://www.dropbox.com/scl/fi/e0x2yjrnhi6qgx9k6ltxg/RevoUninstallerPro5.rar?rlkey=vq4zsk9x1uyco7ratzkhw62f1&st=4f0776fb&dl=1" & goto DownloadAndRun)
if %errorlevel%==2 goto InstallDefControl
if %errorlevel%==1 (set "mark_WinRAR=[OK]" & set "ExeName=WinRAR.exe" & set "TargetUrl=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownloadAndRun)
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

:: Draw header once
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ APP INSTALLER - LIVE PROGRESS ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.

:: === STEP 1: Google Chrome ===
echo %PAD%%Yellow%[1/7] Installing Google Chrome...%Reset%
winget install --id Google.Chrome %Args%

:: === STEP 2: Brave Browser ===
echo.
echo %PAD%%Yellow%[2/7] Installing Brave Browser...%Reset%
winget install --id Brave.Brave %Args%

:: === STEP 3: WhatsApp ===
echo.
echo %PAD%%Yellow%[3/7] Installing WhatsApp...%Reset%
winget install --id WhatsApp.WhatsApp %Args%

:: === STEP 4: AnyDesk ===
echo.
echo %PAD%%Yellow%[4/7] Installing AnyDesk...%Reset%
winget install --id AnyDeskSoftwareEvents.AnyDesk %Args%

:: === STEP 5: VLC Media Player ===
echo.
echo %PAD%%Yellow%[5/7] Installing VLC Media Player...%Reset%
winget install --id VideoLAN.VLC %Args%

:: === STEP 6: Adobe Reader ===
echo.
echo %PAD%%Yellow%[6/7] Installing Adobe Reader...%Reset%
winget install --id Adobe.Acrobat.Reader.64-bit %Args%

:: === STEP 7: Zoom ===
echo.
echo %PAD%%Yellow%[7/7] Installing Zoom...%Reset%
winget install --id Zoom.Zoom %Args%

:: === FINISH ===
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
:: REPORT GENERATOR
:: ============================================================
:FinalReport
echo %PAD%%Cyan%Preparing Report...%Reset%
call :SilentIconSetup
call :ApplyBranding

ping -n 1 google.com >nul
if %errorlevel% neq 0 (
    echo %PAD%%Red%[ERROR] No Internet Connection.%Reset%
    timeout /t 5 >nul
    exit
)

set "TesterName=Unknown"
set /p TesterName="%PAD%Enter Tester Name: "
set "PSScript=%TEMP%\GenReport.ps1"
if exist "%PSScript%" del "%PSScript%"

echo $ErrorActionPreference = 'SilentlyContinue' >> "%PSScript%"
echo [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 >> "%PSScript%"
echo $path = [Environment]::GetFolderPath('Desktop') + '\Montag_Test_Report.txt' >> "%PSScript%"
echo $sys = Get-CimInstance Win32_ComputerSystem >> "%PSScript%"
echo $cpu = Get-CimInstance Win32_Processor >> "%PSScript%"
echo $mem = Get-CimInstance Win32_PhysicalMemory >> "%PSScript%"
echo $gpus = Get-CimInstance Win32_VideoController >> "%PSScript%"
echo $disks = Get-CimInstance Win32_DiskDrive >> "%PSScript%"
echo $bios = Get-CimInstance win32_bios >> "%PSScript%"
echo $Man = $sys.Manufacturer.Trim() >> "%PSScript%"
echo $Mod = $sys.Model.Trim() >> "%PSScript%"
echo if ($Mod.StartsWith($Man)) { $FullModel = $Mod } else { $FullModel = "$Man $Mod" } >> "%PSScript%"
echo $memArray = @($mem); $stickCount = $memArray.Count; $totalRam = [math]::Round(($memArray ^| Measure-Object -Property Capacity -Sum).Sum / 1GB, 1) >> "%PSScript%"
echo $ramSpeed = 0; foreach ($s in $memArray) { if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } }; if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" } >> "%PSScript%"
echo $ramDetails = "$totalRam GB ($stickCount Sticks) @ $ramSpeed MHz" >> "%PSScript%"
echo $maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2) >> "%PSScript%"
echo $cacheMB = [int]($cpu.L3CacheSize / 1024); if ($cacheMB -eq 0) { $cacheMB = [int]($cpu.L2CacheSize / 1024) } >> "%PSScript%"
echo $cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz | $cacheMB MB Cache" >> "%PSScript%"
echo $gpuList = @(); foreach ($g in $gpus) { $ramGB = [math]::Round($g.AdapterRAM / 1GB, 0); if ($ramGB -gt 0) { $nm = "$($g.Name) ($ramGB GB)" } else { $nm = $g.Name }; $gpuList += $nm }; $gpuString = $gpuList -join " + " >> "%PSScript%"
echo $diskList = @(); foreach ($d in $disks) { $s = [math]::Round($d.Size / 1GB, 0); $diskList += "$($d.Model) ($s GB)" }; $storageString = $diskList -join " | " >> "%PSScript%"
echo $FinalStatus = "%StatusText%" >> "%PSScript%"
echo $out = 'DATE: ' + (Get-Date).ToString() + [Environment]::NewLine >> "%PSScript%"
echo $out += 'STATUS: ' + $FinalStatus + [Environment]::NewLine >> "%PSScript%"
echo $out += 'MODEL : ' + $FullModel + [Environment]::NewLine >> "%PSScript%"
echo $out += 'SERIAL: ' + $bios.SerialNumber + [Environment]::NewLine >> "%PSScript%"
echo $out += 'CPU   : ' + $cpuDetails + [Environment]::NewLine >> "%PSScript%"
echo $out += 'RAM   : ' + $ramDetails + [Environment]::NewLine >> "%PSScript%"
echo $out += 'GPU   : ' + $gpuString + [Environment]::NewLine >> "%PSScript%"
echo $out += 'DISK  : ' + $storageString + [Environment]::NewLine >> "%PSScript%"
echo $out ^| Out-File -FilePath $path -Encoding UTF8 >> "%PSScript%"
echo $formUrl = "https://docs.google.com/forms/d/e/%GFormID%/formResponse" >> "%PSScript%"
echo $body = @{ "entry.531158115"=$FullModel; "entry.1203480099"=$bios.SerialNumber; "entry.1462565184"=$cpuDetails; "entry.212987726"=$ramDetails; "entry.1717831234"=$storageString; "entry.2044586469"=$gpuString; "entry.310563239"=$FinalStatus; "entry.392302034"="%TesterName%" } >> "%PSScript%"

echo try { >> "%PSScript%"
echo     $null = Invoke-WebRequest -Uri $formUrl -Method POST -Body $body -UseBasicParsing >> "%PSScript%"
echo     Write-Host " [Cloud] Upload Success" -ForegroundColor Green >> "%PSScript%"
echo } catch { >> "%PSScript%"
echo     Write-Host " [Cloud] Upload Failed" -ForegroundColor Red >> "%PSScript%"
echo     Write-Host $_.Exception.Message -ForegroundColor Red >> "%PSScript%"
echo } >> "%PSScript%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PSScript%"
del "%PSScript%"
echo.
echo %PAD%%Green%[OK] Report on Desktop. Goodbye!%Reset%
timeout /t 5 >nul
goto ExitCleanup

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
echo URL=https://wa.me/201040901444
if exist "%IconPath%" (
    echo IconIndex=0
    echo IconFile=%IconPath%
) else (
    echo IconIndex=23
    echo IconFile=C:\Windows\System32\shell32.dll
)
) > "%SLink%"
exit /b

:ApplyBranding
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "%BrandName%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "Certified Refurbished" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /t REG_SZ /d "%BrandPhone%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "%BrandURL%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportHours /t REG_SZ /d "%BrandHours%" /f >nul 2>&1
exit /b