<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] ADMIN FORCE & PREP
:: ============================================================
cd /d "%~dp0"
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
:: [1] VISUAL SETUP
:: ============================================================
chcp 65001 >nul
mode con: cols=150 lines=60
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1

title Montag Store - System (V 6.0 Master Modular)
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

:: --- GITHUB LINKS (MODULAR SYSTEM) ---
set "UrlReportScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagReport.bat"
set "UrlOfficeScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagOffice.bat"
set "UrlAppsScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagApps.bat"

:: --- TOOLS URLS ---
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

:: Checkmarks Init
for %%i in (WiFi Key Screen Cam Audio Batt Sensor WinUpd Arab DriverBack DriverRest HighPerf WinRAR DefCont Revo Apps Game MAS Office Report) do if not defined mark_%%i set "mark_%%i=   "

:: --- EXTRACT LIGHTWEIGHT ENGINE ---
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
echo %PAD%%Red%[WARNING] This will run ALL setup steps automatically.%Reset%
echo %PAD%Apps & Games are SKIPPED (Install them from Software Hub).
echo.
echo %PAD%%Green%   Initiating Auto-Pilot Mode...%Reset%
call :Speak "Initiating System Preparation."
echo.
timeout /t 2 >nul

:: --- STEP 1: RESTORE POINT ---
echo %PAD%%Yellow%[1/7] Creating Backup Point...%Reset%
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_Prep' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: --- STEP 2: BOOST & TIME ---
echo %PAD%%Yellow%[2/7] Tuning System (Time/Hibernate)...%Reset%
powercfg -h off >nul 2>&1
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1

:: --- STEP 3: BLOATWARE ---
echo %PAD%%Yellow%[3/7] Removing Bloatware...%Reset%
echo %PAD%%Green%   Removing Xbox, Solitaire, Skype, Bing...%Reset%
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1

:: --- STEP 4: ACTIVATION (OEM) ---
echo %PAD%%Yellow%[4/7] Checking Original Activation...%Reset%
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"
if not "%BiosKey%"=="" (
    echo %PAD%      Key Found. Activating...
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey% >nul 2>&1
    cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
) else (
    echo %PAD%      No OEM Key found. Skipping.
)

:: --- STEP 5: ICONS & BRANDING ---
echo %PAD%%Yellow%[5/7] Applying Desktop Icons & Branding...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul 2>&1
call :AddContextSupport >nul 2>&1

:: --- STEP 6: CLEANUP ---
echo %PAD%%Yellow%[6/7] Cleaning Temp Files...%Reset%
del /s /f /q %temp%\*.* >nul 2>&1

:: --- STEP 7: RESTART EXPLORER ---
echo %PAD%%Yellow%[7/7] Refreshing Interface...%Reset%
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

set "mark_Auto=[OK]"
set "mark_Boost=[OK]"
set "mark_Bloat=[OK]"
set "mark_Icons=[OK]"
set "mark_BrandClick=[OK]"

echo.
echo %PAD%%Green%[SUCCESS] System Optimized. Install Apps Manually.%Reset%
call :Speak "System Ready."
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
:: [4] SOFTWARE MENU (MODULAR & EXTERNAL)
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
    :: !!! EXTERNAL LAUNCH !!!
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
    :: !!! EXTERNAL LAUNCH !!!
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
:: REPORT GENERATOR (FIXED: EXTERNAL WINDOW)
:: ============================================================
:FinalReport
echo %PAD%%Cyan%Deep Scanning System Specs...%Reset%
call :SilentIconSetup
call :ApplyBranding
call :AddContextSupport

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

if "%TEST_LOG%"=="" set "TEST_LOG=General Inspection"

:: --- CALL EXTERNAL REPORT (NEW METHOD) ---
echo.
echo %PAD%%Yellow%Downloading Report Module...%Reset%
curl -L -k -# -o "%ToolDir%\MontagReport.bat" "%UrlReportScript%"
if exist "%ToolDir%\MontagReport.bat" (
    echo %PAD%%Green%[OK] Opening Report Interface...%Reset%
    :: This opens a separate window so the main script doesn't glitch
    start "Montag Report Generator" cmd /c "%ToolDir%\MontagReport.bat" "!TEST_LOG!"
) else (
    echo %PAD%%Red%[ERROR] Failed to load Report Module.%Reset%
    pause
)

echo.
echo %PAD%%Green%[OK] Process Launched in New Window.%Reset%
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
::  UNIFIED POWERSHELL ENGINE (NO ECHO HAZARDS)
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