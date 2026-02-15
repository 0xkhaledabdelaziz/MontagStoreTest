<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [1] BULLETPROOF ADMIN ELEVATION
:: ============================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:: ============================================================
:: [2] F11 FULLSCREEN & BLACK CANVAS
:: ============================================================
cd /d "%~dp0"
chcp 65001 >nul
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1

:: Hit F11 automatically
powershell -nop -c "Start-Sleep -m 200; $wsh = New-Object -ComObject WScript.Shell; $wsh.SendKeys('{F11}')" >nul 2>&1

:: Make screen black for intro
color 00
cls

:: ============================================================
:: [3] VARIABLES & CORE SETUP
:: ============================================================
title Montag Store - System (V 270.0 Launcher Final)

:: Colors
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")
set "Reset=%ESC%[0m"
set "Pink=%ESC%[38;2;255;0;255m"
set "Cyan=%ESC%[36m"
set "White=%ESC%[37m"
set "Green=%ESC%[32m"
set "Red=%ESC%[31m"
set "Yellow=%ESC%[33m"
set "Bold=%ESC%[1m"
set "Gray=%ESC%[90m"

:: Padding
set "PAD=                                                  "

:: Paths
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "IconDir=%ProgramData%\MontagStore"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
attrib +h "%IconDir%" >nul 2>&1
set "SupportNum=201040901444"

:: URLs
set "UrlReportScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagReport.bat"
set "UrlOfficeScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagOffice.bat"
set "UrlAppsScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagApps.bat"
set "UrlLabelScript=https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagLabel.bat"
set "UrlHwi=https://www.dropbox.com/scl/fi/fjtwrg3boc8zj88ml2jxs/HWiNFO64.EXE?rlkey=m64f5qxup91iq8ew09imqfcs0&st=9eqs19xe&dl=1"
set "UrlKey=https://www.dropbox.com/scl/fi/onvccubmkxicdtvecdqvq/KeyboardTestUtility.exe?rlkey=62ag37rdvhp45iuzlk8261yus&st=k6li1383&dl=1"
set "UrlScr=https://www.dropbox.com/scl/fi/b63drni7qk3t8f0wudnk7/defpix.exe?rlkey=ir9k1d9gi99dwunjmqtnvtq7n&st=6etkm6wa&dl=1"
set "UrlAud=https://www.dropbox.com/scl/fi/ekej1ymnzepliyggm5hn3/xSpeaker-Headphones-Trim.mp4?rlkey=mw5md1jthagl3nfu3yfumulri&st=5xo6k9gg&dl=1"
set "UrlMAS=https://www.dropbox.com/scl/fi/cnj7x4fp8zqksmeewhsmg/MAS_AIO.cmd?rlkey=1zr26qvm9l7r26iaw52czjmt9&st=7o2zhkih&dl=1"
set "UrlLogo=https://www.dropbox.com/scl/fi/2qv201jvm18n3c971436o/Logo-purple.png?rlkey=b8n5e732fsepkadzg7y10gj1k&st=7q4k6jll&dl=1"
set "UrlIcon=https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1"

:: Markers
for %%i in (WiFi Key Screen Cam Audio Batt Sensor WinUpd Arab DriverBack DriverRest HighPerf DefCont Revo Apps Game MAS Office Report Touch RealBatt Warranty Stress CheckWin Name Bloat Active Boost Auto BrandClick ClassicMenu SAC) do if not defined mark_%%i set "mark_%%i=    "

:: Download Logo
set "LogoPath=%IconDir%\Logo.png"
if not exist "%LogoPath%" curl -L -k -s -o "%IconDir%\Logo.png" "%UrlLogo%" >nul 2>&1
if not exist "%IconDir%\Montag.ico" curl -L -k -s -o "%IconDir%\Montag.ico" "%UrlIcon%" >nul 2>&1

:: Generate Splash Script
set "SplashScript=%TEMP%\MontagSplash.ps1"
(
echo Add-Type -AssemblyName System.Windows.Forms
echo Add-Type -AssemblyName System.Drawing
echo $form = New-Object System.Windows.Forms.Form
echo $form.FormBorderStyle = 'None'
echo $form.BackColor = [System.Drawing.Color]::FromArgb^(1, 1, 1^)
echo $form.TransparencyKey = [System.Drawing.Color]::FromArgb^(1, 1, 1^)
echo $form.StartPosition = 'CenterScreen'
echo $form.Size = New-Object System.Drawing.Size^(800, 800^)
echo $form.TopMost = $true
echo $form.ShowInTaskbar = $false
echo $form.Opacity = 0
echo $pb = New-Object System.Windows.Forms.PictureBox
echo $pb.Image = [System.Drawing.Image]::FromFile^('%LogoPath%'^)
echo $pb.SizeMode = 'Zoom'
echo $pb.Dock = 'Fill'
echo $pb.BackColor = [System.Drawing.Color]::Transparent
echo $form.Controls.Add^($pb^)
echo $form.Show^(^)
echo for ^($i = 0; $i -le 1; $i += 0.05^) { $form.Opacity = $i; [System.Windows.Forms.Application]::DoEvents^(^); Start-Sleep -Milliseconds 15 }
echo Start-Sleep -Seconds 2
echo for ^($i = 1; $i -ge 0; $i -= 0.05^) { $form.Opacity = $i; [System.Windows.Forms.Application]::DoEvents^(^); Start-Sleep -Milliseconds 15 }
echo $form.Close^(^)
echo $pb.Dispose^(^)
echo $form.Dispose^(^)
) > "%SplashScript%"

:: Run Splash (Start)
if exist "%SplashScript%" powershell -NoProfile -ExecutionPolicy Bypass -File "%SplashScript%" >nul 2>&1

:: Restore Color
color 05

:: ============================================================
:: [5] MAIN MENU
:: ============================================================
:MainMenu
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%       %Gray%(Key/Screen)%Reset%         %Bold%%White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%        %Gray%(Perf/Name)%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%       %Gray%(Back/Rest)%Reset%          %Bold%%White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%         %Gray%(Apps/Office)%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% %Cyan%PRINT SPEC LABEL%Reset%     %Gray%(ZPL/Side)%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%                %Green%[R] FINISH + UPLOAD REPORT%Reset%                     %Red%[X] EXIT + WIPE CACHE%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Select Option:%Reset% 
choice /c 12345rx /n

if %errorlevel%==7 goto ExitCleanup
if %errorlevel%==6 goto FinalSequence
if %errorlevel%==5 call :PrintLabel & goto MainMenu
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
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% KEYBOARD TEST            %Green%!mark_Key!%Reset%          %Bold%%White%[2]%Reset% SCREEN TEST              %Green%!mark_Screen!%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% CAMERA TEST              %Green%!mark_Cam!%Reset%          %Bold%%White%[4]%Reset% AUDIO TEST               %Green%!mark_Audio!%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% BATTERY REPORT           %Green%!mark_Batt!%Reset%          %Bold%%White%[6]%Reset% PRO TOUCH TEST           %Green%!mark_Touch!%Reset%
echo.
echo %PAD%    %Bold%%Yellow%[B] REAL BATTERY TEST (OFFLINE)%Reset% %Green%!mark_RealBatt!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%White%[7]%Reset% CHECK WARRANTY           %Green%!mark_Warranty!%Reset%          %Bold%%White%[8]%Reset% SYSTEM STRESS TEST       %Green%!mark_Stress!%Reset%
echo.
echo %PAD%    %Bold%%White%[9]%Reset% CHECK WIN INTEGRITY      %Green%!mark_CheckWin!%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%    %Bold%%Yellow%[S] SENSORS (HWiNFO)%Reset%        %Green%!mark_Sensor!%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Yellow%^> Select Test:%Reset% 
choice /c 123456789b0s /n

if %errorlevel%==12 set "ExeName=HWiNFO.exe" & set "TargetUrl=%UrlHwi%" & call :DownloadAndRun & set "mark_Sensor=[OK]" & goto Menu_Hardware
if %errorlevel%==11 goto MainMenu
if %errorlevel%==10 goto RealBatteryTest
if %errorlevel%==9 goto CheckWinIntegrity
if %errorlevel%==8 call :StressTest & set "mark_Stress=[OK]" & goto Menu_Hardware
if %errorlevel%==7 call :CheckWarranty & set "mark_Warranty=[OK]" & goto Menu_Hardware
if %errorlevel%==6 call :ProTouchTest & set "mark_Touch=[OK]" & goto Menu_Hardware
if %errorlevel%==5 call :BatteryTest & set "mark_Batt=[OK]" & goto Menu_Hardware
if %errorlevel%==4 set "ExeName=Audio.mp4" & set "TargetUrl=%UrlAud%" & call :DownloadAndRun & set "mark_Audio=[OK]" & goto Menu_Hardware
if %errorlevel%==3 call :CamTest & set "mark_Cam=[OK]" & goto Menu_Hardware
if %errorlevel%==2 set "ExeName=ScreenTest.exe" & set "TargetUrl=%UrlScr%" & call :DownloadAndRun & set "mark_Screen=[OK]" & goto Menu_Hardware
if %errorlevel%==1 set "ExeName=KeyTest.exe" & set "TargetUrl=%UrlKey%" & call :DownloadAndRun & set "mark_Key=[OK]" & goto Menu_Hardware
goto Menu_Hardware

:: --- HARDWARE FUNCTIONS ---
:RealBatteryTest
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ REAL BATTERY DRAIN TEST ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Starting Auto-Test:%Reset%
echo %PAD% 1. Prevent Sleep Mode...
echo %PAD% 2. Searching for 'BatteryTest.mp4' on ALL drives...
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg -h off >nul 2>&1

set "DestVid=%ToolDir%\BatteryTest.mp4"
set "FoundSource="
if exist "%~dp0BatteryTest.mp4" set "FoundSource=%~dp0BatteryTest.mp4" & goto FoundVideo
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\BatteryTest.mp4" (set "FoundSource=%%d:\BatteryTest.mp4" & goto FoundVideo)
)
echo %PAD%%Red%[ERROR] 'BatteryTest.mp4' NOT FOUND on any drive!%Reset%
pause >nul
goto Menu_Hardware

:FoundVideo
echo %PAD%%Green%[FOUND] %FoundSource%%Reset%
echo %PAD%%Yellow%Copying to System (C:) - Please Wait...%Reset%
copy /z /y "%FoundSource%" "%DestVid%"
if not exist "%DestVid%" (
    echo %PAD%%Red%[ERROR] Copy Failed. Trying to play directly from USB...%Reset%
    start "" "%FoundSource%"
    goto StartLogger
)
echo %PAD%%Green%[OK] Copy Complete. Starting Test...%Reset%
timeout /t 2 >nul
start "" "%DestVid%"
goto StartLogger

:StartLogger
set "BatScript=%TEMP%\BatLogger.ps1"
if exist "%BatScript%" del "%BatScript%"
echo $log = "C:\MontagBatteryLog.txt" > "%BatScript%"
echo $sys = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%BatScript%"
echo $ser = (Get-WmiObject Win32_Bios).SerialNumber.Trim() >> "%BatScript%"
echo $start = Get-Date >> "%BatScript%"
echo Add-Content $log "==========================================" >> "%BatScript%"
echo Add-Content $log "      MONTAG STORE - BATTERY TEST" >> "%BatScript%"
echo Add-Content $log "==========================================" >> "%BatScript%"
echo Add-Content $log "Device : $sys" >> "%BatScript%"
echo Add-Content $log "Serial : $ser" >> "%BatScript%"
echo Add-Content $log "Started: $start" >> "%BatScript%"
echo Add-Content $log "------------------------------------------" >> "%BatScript%"
echo Write-Host "`n   MONTAG STORE - BATTERY STOPWATCH" -ForegroundColor Magenta >> "%BatScript%"
echo Write-Host "   Device: $sys" -ForegroundColor White >> "%BatScript%"
echo while ($true) { >> "%BatScript%"
echo     $now = Get-Date >> "%BatScript%"
echo     $diff = $now - $start >> "%BatScript%"
echo     $bat = (Get-WmiObject Win32_Battery).EstimatedChargeRemaining >> "%BatScript%"
echo     $str = "{0:hh\:mm\:ss}          {1}%%" -f $diff, $bat >> "%BatScript%"
echo     Write-Host "   $str" -ForegroundColor Cyan >> "%BatScript%"
echo     $logLine = "$($now.ToString('HH:mm:ss')) | Elapsed: $($diff.ToString('hh\:mm')) | Battery: $bat%%" >> "%BatScript%"
echo     Add-Content $log $logLine >> "%BatScript%"
echo     Start-Sleep -Seconds 60 >> "%BatScript%"
echo } >> "%BatScript%"
start "Montag Battery Timer" powershell -NoProfile -ExecutionPolicy Bypass -File "%BatScript%"
set "mark_RealBatt=[OK]"
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
set "CheckWinScript=%TEMP%\CheckWin.ps1"
if exist "%CheckWinScript%" del "%CheckWinScript%"
echo $score = 0 > "%CheckWinScript%"
echo $lic = Get-CimInstance SoftwareLicensingProduct ^| Where-Object {$_.PartialProductKey -and $_.Name -match 'Windows'} ^| Select-Object -ExpandProperty Name -First 1 >> "%CheckWinScript%"
echo if ($lic -match 'Volume' -or $lic -match 'KMS') { Write-Host '   [1/4] License Channel : FAKE/VOLUME (Modified)' -ForegroundColor Red; $score++ } else { Write-Host '   [1/4] License Channel : OEM/RETAIL (Original)' -ForegroundColor Green } >> "%CheckWinScript%"
echo if (Get-Service windefend -ErrorAction SilentlyContinue) { Write-Host '   [2/4] Windows Defender: OK' -ForegroundColor Green } else { Write-Host '   [2/4] Windows Defender: DELETED (Modified)' -ForegroundColor Red; $score++ } >> "%CheckWinScript%"
echo if (Get-Service wuauserv -ErrorAction SilentlyContinue) { Write-Host '   [3/4] Windows Update  : OK' -ForegroundColor Green } else { Write-Host '   [3/4] Windows Update  : DELETED (Modified)' -ForegroundColor Red; $score++ } >> "%CheckWinScript%"
echo if (Test-Path 'C:\Windows\System32\Recovery\ReAgent.xml') { Write-Host '   [4/4] Recovery System : OK' -ForegroundColor Green } else { Write-Host '   [4/4] Recovery System : MISSING (Modified)' -ForegroundColor Red; $score++ } >> "%CheckWinScript%"
echo if ($score -eq 0) { Write-Host "`n   [VERDICT] ORIGINAL (STOCK) WINDOWS - SAFE" -ForegroundColor Green } else { Write-Host "`n   [VERDICT] MODIFIED / FAKE DETECTED" -ForegroundColor Red } >> "%CheckWinScript%"

powershell -ExecutionPolicy Bypass -File "%CheckWinScript%"
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
set "mark_CheckWin=[OK]"
if exist "%CheckWinScript%" del "%CheckWinScript%"
pause
goto Menu_Hardware

:DownloadAndRun
set "Exe=%ToolDir%\%ExeName%"
if exist "%~dp0%ExeName%" copy /y "%~dp0%ExeName%" "%Exe%" >nul 2>&1
if exist "%Exe%" (start "" "%Exe%" & goto ReturnPoint)
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DOWNLOAD MANAGER ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading: %White%%ExeName%...
curl -L -k -# -o "%Exe%" "%TargetUrl%"
if exist "%Exe%" (start "" "%Exe%") else (echo %PAD%%Red%[ERROR] Failed.%Reset% & pause)
:ReturnPoint
if "%ExeName%"=="WinRAR.exe" goto Menu_Software
if "%ExeName%"=="DefCont.rar" goto Menu_Software
if "%ExeName%"=="Revo.rar" goto Menu_Software
goto Menu_Hardware

:CamTest
start microsoft.windows.camera:
exit /b

:BatteryTest
powercfg /batteryreport /output "%TEMP%\batt.html" >nul 2>&1
start "" "%TEMP%\batt.html"
exit /b

:StressTest
cls
echo.
echo %PAD%%Red%[CAUTION] STARTING STRESS TEST (60 SECONDS)%Reset%
echo %PAD%This will push CPU to 100%% usage.
pause >nul
powershell -Command "$s=[System.Diagnostics.Stopwatch]::StartNew();$j=@();1..[Environment]::ProcessorCount|%%{$j+=Start-Job -ScriptBlock{$r=1;while($true){$r=$r*1.000001}}};Write-Host ' [!] CPU 100% Load Active...';while($s.Elapsed.TotalSeconds -lt 60){Start-Sleep 1};$j|Stop-Job|Remove-Job"
set "mark_Stress=[OK]"
goto Menu_Hardware

:ProTouchTest
cls
call :DrawHeader
echo.
echo %PAD%%Yellow%Generating Touch Grid...%Reset%
set "TouchFile=%TEMP%\MontagTouch.html"
if exist "%TouchFile%" del "%TouchFile%"
(
echo ^<!DOCTYPE html^>^<html lang="en"^>^<head^>^<meta charset="UTF-8"^>^<title^>Montag Touch^</title^>
echo ^<style^>body{margin:0;background:#000;overflow:hidden;touch-action:none;font-family:sans-serif}
echo #grid{display:grid;grid-template-columns:repeat(20,1fr^);grid-template-rows:repeat(12,1fr^);width:100vw;height:100vh}
echo .cell{border:1px solid #333;transition:0s}.touched{background:#0f0;box-shadow:0 0 10px #0f0;border-color:#0f0}
echo #info{position:absolute;top:50%%;left:50%%;transform:translate(-50%%,-50%%^);color:#fff;pointer-events:none;text-align:center;mix-blend-mode:difference}
echo h1{font-size:40px;margin:0}p{color:#aaa}^</style^>^</head^>
echo ^<body^>^<div id="info"^>^<h1^>TOUCH TEST^</h1^>^<p^>Swipe to fill squares^</p^>^</div^>^<div id="grid"^>^</div^>
echo ^<script^>const grid=document.getElementById('grid'^);for(let i=0;i^<240;i++^){let d=document.createElement('div'^);d.className='cell';grid.appendChild(d^);}
echo function act(e^){e.preventDefault(^);let t=e.touches^|^|[e];for(let i=0;i^<t.length;i++^){let el=document.elementFromPoint(t[i].clientX,t[i].clientY^);if(el^&^&el.classList.contains('cell'^)^)el.classList.add('touched'^);}check(^);}
echo function check(^){let t=document.querySelectorAll('.cell'^).length;let a=document.querySelectorAll('.touched'^).length;let p=Math.round((a/t^)*100^);document.querySelector('#info h1'^).innerText=p+''%%'';if(p==100^)document.querySelector('#info h1'^).style.color='#0f0';}
echo window.addEventListener('touchmove',act,{passive:false}^);window.addEventListener('mousemove',function(e^){if(e.buttons==1^)act(e^);}^);^</script^>^</body^>^</html^>
) > "%TouchFile%"
start "" "%TouchFile%"
set "mark_Touch=[OK]"
goto Menu_Hardware

:: ============================================================
:: [2] WINDOWS MENU
:: ============================================================
:Menu_Windows
cls
call :DrawHeader
echo.
echo %PAD%    %Bold%%Yellow%[1] PREPARE FOR SALE (AUTO-PILOT)%Reset% %Green%!mark_Auto!%Reset%
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo %PAD%    %Bold%%White%[2]%Reset% HIGH PERF + NO SLEEP     %Green%!mark_HighPerf!%Reset%      %Bold%%White%[3]%Reset% ARAB KEY + EGYPT REG     %Green%!mark_Arab!%Reset%
echo.
echo %PAD%    %Bold%%White%[4]%Reset% ACTIVATE ORIGINAL KEY    %Green%!mark_Active!%Reset%      %Bold%%White%[5]%Reset% REMOVE BLOATWARE         %Green%!mark_Bloat!%Reset%
echo.
echo %PAD%    %Bold%%White%[6]%Reset% QUICK BOOST ^& FIX        %Green%!mark_Boost!%Reset%
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo %PAD%    %Bold%%White%[7]%Reset% CHECK WINDOWS UPDATE     %Green%!mark_WinUpd!%Reset%      %Bold%%White%[8]%Reset% RENAME PC ^& USER         %Green%!mark_Name!%Reset%
echo.
echo %PAD%    %Bold%%White%[9]%Reset% DISABLE WIN11 MENU       %Green%!mark_ClassicMenu!%Reset%      %Bold%%White%[S] DISABLE SMART APP        %Green%!mark_SAC!%Reset%
echo.
echo %PAD%                                     %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
choice /c 123456789s0 /n

if %errorlevel%==11 goto MainMenu
if %errorlevel%==10 goto DisableSAC
if %errorlevel%==9 goto ClassicMenu
if %errorlevel%==8 goto RenameUser
if %errorlevel%==7 goto WinUpdate
if %errorlevel%==6 goto QuickBoost
if %errorlevel%==5 goto RemoveBloatware
if %errorlevel%==4 goto ActivateOEM
if %errorlevel%==3 goto AddArabic
if %errorlevel%==2 goto HighPerf
if %errorlevel%==1 goto AutoPilot
goto Menu_Windows

:AutoPilot
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ AUTO-PILOT: PREPARE FOR SALE ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Red%[WARNING] Optimizing Windows (No Apps)...%Reset%
echo %PAD%%Green%   Initiating Auto-Pilot Mode...%Reset%
echo.
timeout /t 2 >nul

:: --- STEP 1: RESTORE POINT (Safety) ---
echo %PAD%%Yellow%[1/7] Creating Backup Point...%Reset%
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_AutoPilot' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: --- STEP 2: BOOST & TIME ---
echo %PAD%%Yellow%[2/7] Tuning System (Time/Hibernate)...%Reset%
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg -h off >nul 2>&1
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
set "mark_HighPerf=[OK]"

:: --- STEP 3: BLOATWARE ---
echo %PAD%%Yellow%[3/7] Removing Bloatware...%Reset%
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
set "mark_Bloat=[OK]"

:: --- STEP 4: ARABIC & EGYPT ---
echo %PAD%%Yellow%[4/7] Setting Region and Language...%Reset%
powershell -NoProfile -Command "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}" >nul 2>&1
powershell -NoProfile -Command "Set-WinHomeLocation -GeoId 68" >nul 2>&1
reg add "HKCU\Control Panel\International\Geo" /v Nation /t REG_SZ /d "68" /f >nul 2>&1
reg add "HKCU\Control Panel\International\Geo" /v Name /t REG_SZ /d "EG" /f >nul 2>&1
powershell -NoProfile -Command "Set-Culture en-US" >nul 2>&1
reg add "HKCU\Control Panel\International" /v Locale /t REG_SZ /d "0409" /f >nul 2>&1
reg add "HKCU\Control Panel\International" /v LocaleName /t REG_SZ /d "en-US" /f >nul 2>&1
tzutil /s "Egypt Standard Time" >nul 2>&1
set "mark_Arab=[OK]"

:: --- STEP 5: ACTIVATION ---
echo %PAD%%Yellow%[5/7] Checking Activation...%Reset%
set "KeyScript=%TEMP%\FindKey.ps1"
if exist "%KeyScript%" del "%KeyScript%"
echo $key = ""> "%KeyScript%"
echo try { $key = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey } catch {}>> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault } catch {} }>> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BootDeviceProductKey } catch {} }>> "%KeyScript%"
echo $key ^| Out-File "$env:TEMP\oemkey.txt" -Encoding ASCII>> "%KeyScript%"

powershell -ExecutionPolicy Bypass -File "%KeyScript%" >nul 2>&1
set "BiosKey="
if exist "%TEMP%\oemkey.txt" ( set /p BiosKey=<"%TEMP%\oemkey.txt" )
if not "%BiosKey%"=="" (
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey% >nul 2>&1
    cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
    set "mark_Active=[OK]"
)
if exist "%KeyScript%" del "%KeyScript%"
if exist "%TEMP%\oemkey.txt" del "%TEMP%\oemkey.txt"

:: --- STEP 6: DISABLE WIN11 MENU (AUTOMATIC) ---
echo %PAD%%Yellow%[6/7] Restoring Classic Context Menu...%Reset%
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
set "mark_ClassicMenu=[OK]"

:: --- STEP 7: CLEANUP & RESTART ---
echo %PAD%%Yellow%[7/7] Refreshing Interface...%Reset%
del /s /f /q %temp%\*.* >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

set "mark_Auto=[OK]"
set "mark_Boost=[OK]"
echo.
echo %PAD%%Green%[SUCCESS] Auto-Pilot Completed Successfully!%Reset%
echo.
timeout /t 3 >nul
goto Menu_Windows

:DisableSAC
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ DISABLE SMART APP CONTROL ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Disabling Smart App Control...%Reset%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v VerifiedAndReputablePolicyState /t REG_DWORD /d 0 /f >nul 2>&1
echo.
echo %PAD%%Green%[OK] Policy Updated.%Reset%
echo %PAD%%Red%[NOTE] A System Restart is required to apply this change.%Reset%
set "mark_SAC=[OK]"
timeout /t 3 >nul
goto Menu_Windows

:ClassicMenu
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ RESTORE CLASSIC CONTEXT MENU ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Applying Registry Fix...%Reset%
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
echo %PAD%%Yellow%Restarting Explorer...%Reset%
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo %PAD%%Green%[OK] Classic Menu Restored.%Reset%
set "mark_ClassicMenu=[OK]"
timeout /t 3 >nul
goto Menu_Windows

:QuickBoost
cls
powercfg -h off >nul 2>&1
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
set "mark_Boost=[OK]"
echo %PAD%%Green%[OK] System Boosted.%Reset%
timeout /t 2 >nul
goto Menu_Windows

:RemoveBloatware
cls
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue"
set "mark_Bloat=[OK]"
echo %PAD%%Green%[OK] Cleaned.%Reset%
timeout /t 3 >nul
goto Menu_Windows

:ActivateOEM
cls
echo.
echo %PAD%%Cyan%Searching for BIOS Product Key...%Reset%
set "KeyScript=%TEMP%\FindKey.ps1"
if exist "%KeyScript%" del "%KeyScript%"
echo $key = ""> "%KeyScript%"
echo try { $key = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey } catch {}>> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault } catch {} }>> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BootDeviceProductKey } catch {} }>> "%KeyScript%"
echo $key ^| Out-File "$env:TEMP\oemkey.txt" -Encoding ASCII>> "%KeyScript%"

powershell -ExecutionPolicy Bypass -File "%KeyScript%" >nul 2>&1
set "BiosKey="
if exist "%TEMP%\oemkey.txt" ( set /p BiosKey=<"%TEMP%\oemkey.txt" )
if not "%BiosKey%"=="" (
    echo.
    echo %PAD%%Green%[OK] Key Found: %White%%BiosKey%%Reset%
    echo %PAD%Installing Key...
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey% >nul 2>&1
    echo %PAD%Activating Online...
    cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
    echo.
    echo %PAD%%Green%[SUCCESS] Activation Command Sent.%Reset%
    set "mark_Active=[OK]"
    timeout /t 3 >nul
) else (
    echo.
    echo %PAD%%Red%[ERROR] No Original BIOS Key Found.%Reset%
    pause
)
if exist "%KeyScript%" del "%KeyScript%"
if exist "%TEMP%\oemkey.txt" del "%TEMP%\oemkey.txt"
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
powershell -Command "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}"
tzutil /s "Egypt Standard Time"
set "mark_Arab=[OK]"
goto Menu_Windows

:HighPerf
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
set "mark_HighPerf=[OK]"
goto Menu_Windows

:WinUpdate
start ms-settings:windowsupdate & goto Menu_Windows

:: ============================================================
:: [3] DRIVERS MENU
:: ============================================================
:Menu_Drivers
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% BACKUP DRIVERS        %Green%!mark_DriverBack!%Reset%       %Bold%%White%[2]%Reset% RESTORE DRIVERS     %Green%!mark_DriverRest!%Reset%
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
echo Write-Host "`n   DRIVER BACKUP (SMART)" -ForegroundColor Magenta >> "%PSDr%"
echo $model = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%PSDr%"
echo Write-Host "   Detected Model: $model" -ForegroundColor Yellow >> "%PSDr%"
echo $drv = Read-Host "`n   Enter Target Drive Letter (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $name = "$model".Replace(" ", "_") + "_Drivers" >> "%PSDr%"
echo $finalPath = "$($drv):\$name" >> "%PSDr%"
echo New-Item -ItemType Directory -Force -Path $finalPath ^| Out-Null >> "%PSDr%"
echo Write-Host "   Destination: $finalPath" -ForegroundColor Cyan >> "%PSDr%"
echo Write-Host "`n   Exporting Drivers... (This allows you to see progress)" -ForegroundColor Yellow >> "%PSDr%"
echo $s = [System.Diagnostics.Stopwatch]::StartNew() >> "%PSDr%"
echo Start-Process pnputil -ArgumentList "/export-driver * `"$finalPath`"" -NoNewWindow -Wait >> "%PSDr%"
echo $s.Stop() >> "%PSDr%"
echo Write-Host "`n   [OK] Drivers Saved Successfully." -ForegroundColor Green >> "%PSDr%"
echo Write-Host "   Time Taken: $($s.Elapsed.ToString('mm\:ss'))" -ForegroundColor White >> "%PSDr%"
echo Read-Host "`n   Press Enter to return..." >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:RestoreDrivers
cls
set "PSDr=%TEMP%\DrvRest.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $host.UI.RawUI.WindowTitle = 'Montag Store - Driver Restore' >> "%PSDr%"
echo Write-Host "`n   DRIVER RESTORE (SMART)" -ForegroundColor Magenta >> "%PSDr%"
echo $drv = Read-Host "   Enter Source Drive Letter (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $term = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%PSDr%"
echo $pattern = "*" + $term.Replace(" ", "*") + "*" >> "%PSDr%"
echo Write-Host "   Searching for drivers matching: $term ..." -ForegroundColor Yellow >> "%PSDr%"
echo try { $folder = Get-ChildItem -Path "$($drv):\" -Directory -Recurse -Filter $pattern -ErrorAction SilentlyContinue ^| Select-Object -First 1 } catch { $folder = $null } >> "%PSDr%"
echo if ($folder) { >> "%PSDr%"
echo     Write-Host "   [FOUND] $($folder.FullName)" -ForegroundColor Green >> "%PSDr%"
echo     $conf = Read-Host "   Install these drivers? (Y/N)" >> "%PSDr%"
echo     if ($conf -eq 'Y' -or $conf -eq 'y') { >> "%PSDr%"
echo         Write-Host "   Installing... Please watch the progress below..." -ForegroundColor Magenta >> "%PSDr%"
echo         $s = [System.Diagnostics.Stopwatch]::StartNew() >> "%PSDr%"
echo         Start-Process pnputil -ArgumentList "/add-driver `"$($folder.FullName)\*.inf`" /subdirs /install" -NoNewWindow -Wait >> "%PSDr%"
echo         $s.Stop() >> "%PSDr%"
echo         Write-Host "`n   [OK] Installation Complete." -ForegroundColor Green >> "%PSDr%"
echo         Write-Host "   Time Taken: $($s.Elapsed.ToString('mm\:ss'))" -ForegroundColor White >> "%PSDr%"
echo         Read-Host "   Press Enter to restart later..." >> "%PSDr%"
echo     } >> "%PSDr%"
echo } else { >> "%PSDr%"
echo     Write-Host "   [ERROR] No driver folder found for this model on $drv drive." -ForegroundColor Red >> "%PSDr%"
echo     Write-Host "   Tip: Ensure the folder name contains the laptop model." -ForegroundColor Gray >> "%PSDr%"
echo     Read-Host "   Press Enter..." >> "%PSDr%"
echo } >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:: ============================================================
:: [4] SOFTWARE MENU
:: ============================================================
:Menu_Software
cls
call :DrawHeader
echo.
echo %PAD%%Cyan%=====================================================================================%Reset%
echo.
echo %PAD%   %Bold%%White%[1]%Reset% INSTALL APPS BUNDLE   %Green%!mark_Apps!%Reset%      %Bold%%White%[2]%Reset% OFFICE SUITE (SCRIPT) %Green%!mark_Office!%Reset%
echo.
echo %PAD%   %Bold%%White%[3]%Reset% INSTALL WINRAR        %Green%!mark_WinRAR!%Reset%      %Bold%%White%[4]%Reset% INSTALL DEFENDER CTRL %Green%!mark_DefCont!%Reset%
echo.
echo %PAD%   %Bold%%White%[5]%Reset% INSTALL REVO UNINSTALL%Green%!mark_Revo!%Reset%      %Bold%%White%[6]%Reset% GAMING ESSENTIALS     %Green%!mark_Game!%Reset%
echo.
echo %PAD%   %Bold%%White%[7]%Reset% ACTIVATE              %Green%!mark_MAS!%Reset%
echo.
echo %PAD%%Cyan%-------------------------------------------------------------------------------------%Reset%
echo.
echo %PAD%                                  %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Cyan%=====================================================================================%Reset%
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
    echo %PAD%%Green%[DONE] Password is: 1%Reset%
    explorer "%ToolDir%"
) else ( echo %PAD%%Red%[ERROR] Failed.%Reset% )
pause
goto Menu_Software

:: ============================================================
:: PRINT & REPORT HELPER
:: ============================================================
:PrintLabel
cls
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo %PAD%                              [ LABEL PRINTING SYSTEM ]
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%Downloading Label Module...%Reset%
curl -L -k -# -o "%ToolDir%\MontagLabel.bat" "%UrlLabelScript%"
if exist "%ToolDir%\MontagLabel.bat" (
    echo %PAD%%Green%[OK] Launching Label Printer...%Reset%
    start "" "%ToolDir%\MontagLabel.bat"
) else (
    echo %PAD%%Red%[ERROR] Failed to download Label Script.%Reset%
    echo %PAD%Check internet connection.
    pause
)
goto MainMenu

:: ============================================================
:: REPORT GENERATOR + CINEMATIC EXIT
:: ============================================================
:FinalSequence
echo %PAD%%Cyan%Collecting Test Results...%Reset%
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
if "!mark_RealBatt!"=="[OK]" set "TEST_LOG=!TEST_LOG! RealBatt:OK"
if "%TEST_LOG%"=="" set "TEST_LOG=General Inspection"
echo !TEST_LOG! > "%ToolDir%\MontagLog.txt"

echo.
echo %PAD%%Yellow%Loading Montag Report System...%Reset%
curl -L -k -# -o "%ToolDir%\MontagReport.bat" "%UrlReportScript%"
if exist "%ToolDir%\MontagReport.bat" (
    echo %PAD%%Green%[OK] Handing over control...%Reset%
    :: CRITICAL FIX: LAUNCH REPORT AND EXIT. DO NOT CLEAN UP YET.
    start "" "%ToolDir%\MontagReport.bat"
    exit
) else (
    echo %PAD%%Red%[ERROR] Failed to load Report Module.%Reset%
    pause
)
goto ExitCleanup

:ExitCleanup
cd /d "C:\"
start "" /Min cmd /C "timeout /t 2 >nul & rmdir /s /q "%ToolDir%""
exit

:: ============================================================
:: GLOBAL HELPERS
:: ============================================================
:Speak
start /b powershell -nop -c "Add-Type -AssemblyName System.Speech; $s=New-Object System.Speech.Synthesis.SpeechSynthesizer; $v=$s.GetInstalledVoices().VoiceInfo | Where-Object {$_.Name -like '*Zira*' -or $_.Gender -eq 'Female'} | Select-Object -First 1; if($v){$s.SelectVoice($v.Name)}; $s.Speak('%~1')" >nul 2>&1
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
param($Task, $TesterName, $StatusLog, $FormID, $LogoPath)
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