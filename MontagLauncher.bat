@echo off
setlocal EnableDelayedExpansion

:: ==============================================================================
:: [0] GLOBAL VARIABLES & SAFE CORE PATHS
:: ==============================================================================
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1
set "BatchPath=%ToolDir%\MontagCore.bat"
if /i "%~f0" neq "%BatchPath%" copy /y "%~f0" "%BatchPath%" >nul 2>&1

:: Router Intercept for OS Commands
if "%~1" neq "" goto ROUTER

:: ==============================================================================
:: [1] ADMINISTRATIVE PRIVILEGES ENFORCEMENT (CLEAN BYPASS)
:: ==============================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -nop -ep bypass -c "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit
)

:: ==============================================================================
:: [2] ENVIRONMENT SETUP & QUANTUM ENGINE EXECUTION
:: ==============================================================================
cd /d "%~dp0"
chcp 65001 >nul
title Montag Store - Quantum OS Dashboard v22.0
for /f "usebackq delims=" %%a in (`powershell -nop -c "(Get-CimInstance Win32_ComputerSystem).Manufacturer.Trim()"`) do set "BRAND=%%a"
set "HubEngine=%ToolDir%\MontagQuantumEngine.ps1"
if exist "%HubEngine%" del "%HubEngine%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__HUB_CORE_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%HubEngine%"

:: Execute Engine Safely
powershell -WindowStyle Hidden -nop -ep bypass -File "%HubEngine%" -MFG "!BRAND!"

:: ==============================================================================
:: [3] POST-DIAGNOSTIC REPORT COMPILER (LOG ONLY)
:: ==============================================================================
if exist "%ToolDir%\action_report.txt" (
    set "KB_ST=PENDING" & set "SC_ST=PENDING" & set "AU_ST=PENDING" & set "TO_ST=PENDING" & set "CA_ST=PENDING"
    
    if exist "%ToolDir%\kb_status.txt" set /p KB_ST=<"%ToolDir%\kb_status.txt"
    if exist "%ToolDir%\sc_status.txt" set /p SC_ST=<"%ToolDir%\sc_status.txt"
    if exist "%ToolDir%\au_status.txt" set /p AU_ST=<"%ToolDir%\au_status.txt"
    if exist "%ToolDir%\to_status.txt" set /p TO_ST=<"%ToolDir%\to_status.txt"
    if exist "%ToolDir%\ca_status.txt" set /p CA_ST=<"%ToolDir%\ca_status.txt"
    
    echo Key:!KB_ST! Screen:!SC_ST! Audio:!AU_ST! Touch:!TO_ST! Cam:!CA_ST! > "%ToolDir%\MontagLog.txt"
    del "%ToolDir%\action_report.txt" >nul 2>&1
)
exit

:: ==============================================================================
:: [4] OS COMMAND ROUTER (SAFE EXECUTION ENVIRONMENT)
:: ==============================================================================
:ROUTER
mode con: cols=85 lines=25
color 0B
title Montag Store - Executing Task...

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")
set "Reset=%ESC%[0m"
set "Green=%ESC%[32m"
set "Red=%ESC%[31m"
set "Yellow=%ESC%[33m"
set "White=%ESC%[37m"
set "Cyan=%ESC%[36m"
set "Magenta=%ESC%[35m"

echo.
if "%~1"=="CMD_AUTOPILOT" goto DO_AUTOPILOT
if "%~1"=="CMD_THISPC" goto DO_THISPC
if "%~1"=="CMD_HIGHPERF" goto DO_HIGHPERF
if "%~1"=="CMD_ARABIC" goto DO_ARABIC
if "%~1"=="CMD_ACTIVATE" goto DO_ACTIVATE
if "%~1"=="CMD_BLOAT" goto DO_BLOAT
if "%~1"=="CMD_BOOST" goto DO_BOOST
if "%~1"=="CMD_RENAME" goto DO_RENAME
if "%~1"=="CMD_CLASSIC" goto DO_CLASSIC
if "%~1"=="CMD_SAC" goto DO_SAC
if "%~1"=="CMD_DRV_BACKUP" goto DO_DRV_BACKUP
if "%~1"=="CMD_DRV_RESTORE" goto DO_DRV_RESTORE
if "%~1"=="CMD_APP_GAMING" goto DO_APP_GAMING

if "%~1"=="CMD_BATTERY" goto DO_BATTERY
if "%~1"=="CMD_CHARGER_TEST" goto DO_CHARGER

if "%~1"=="CMD_CPU_30" set "SType=CPU" & set "SDur=30" & goto DO_STRESS
if "%~1"=="CMD_CPU_60" set "SType=CPU" & set "SDur=60" & goto DO_STRESS
if "%~1"=="CMD_CPU_INF" set "SType=CPU" & set "SDur=0" & goto DO_STRESS

if "%~1"=="CMD_RAM_30" set "SType=RAM" & set "SDur=30" & goto DO_STRESS
if "%~1"=="CMD_RAM_60" set "SType=RAM" & set "SDur=60" & goto DO_STRESS
if "%~1"=="CMD_RAM_INF" set "SType=RAM" & set "SDur=0" & goto DO_STRESS

if "%~1"=="CMD_GPU_30" set "SType=GPU" & set "SDur=30" & goto DO_STRESS
if "%~1"=="CMD_GPU_60" set "SType=GPU" & set "SDur=60" & goto DO_STRESS
if "%~1"=="CMD_GPU_INF" set "SType=GPU" & set "SDur=0" & goto DO_STRESS

if "%~1"=="CMD_UPDATE" start ms-settings:windowsupdate & exit
if "%~1"=="CMD_OEM_DELL" start "" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe" & exit
if "%~1"=="CMD_OEM_HP" start "" "https://ftp.hp.com/pub/softpaq/sp168501-169000/sp168523.exe" & exit
if "%~1"=="CMD_OEM_LENOVO" start "" "https://support.lenovo.com/us/en/" & exit

if "%~1"=="CMD_APP_BUNDLE" goto DO_APP_BUNDLE
if "%~1"=="CMD_APP_OFFICE" goto DO_APP_OFFICE
if "%~1"=="CMD_APP_DEFCONT" goto DO_APP_DEFCONT
goto :EOF

:DO_AUTOPILOT
cls
echo %Cyan%Applying Auto-Pilot (Prepare for Sale)...%Reset%
echo %Yellow%Creating Restore Point...%Reset%
powershell -nop -c "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Montag_AutoPilot' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo %Yellow%Tuning Performance...%Reset%
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0 & powercfg /change standby-timeout-ac 0 & powercfg -h off >nul 2>&1
net start w32time >nul 2>&1 & w32tm /resync >nul 2>&1
echo %Yellow%Removing Bloatware...%Reset%
powershell -nop -c "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo %Yellow%Setting Region and Language...%Reset%
powershell -nop -c "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}; Set-WinHomeLocation -GeoId 68; Set-Culture en-US" >nul 2>&1
reg add "HKCU\Control Panel\International\Geo" /v Nation /t REG_SZ /d "68" /f >nul 2>&1
tzutil /s "Egypt Standard Time" >nul 2>&1
echo %Yellow%Restoring Classic Menu ^& This PC...%Reset%
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
echo %Yellow%Restarting Explorer...%Reset%
taskkill /f /im explorer.exe >nul 2>&1 & start explorer.exe
echo %Green%[OK] Auto-Pilot Completed Successfully!%Reset%
timeout /t 3 >nul
goto :EOF

:DO_THISPC
cls
echo %Cyan%Showing This PC Icon on Desktop...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1 & start explorer.exe
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_HIGHPERF
cls
echo %Cyan%Applying High Performance Power Plan...%Reset%
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0 & powercfg /change standby-timeout-ac 0
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_ARABIC
cls
echo %Cyan%Setting Region to Egypt and adding Arabic Keyboard...%Reset%
powershell -nop -c "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}; Set-WinHomeLocation -GeoId 68" >nul 2>&1
tzutil /s "Egypt Standard Time" >nul 2>&1
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_ACTIVATE
cls
echo.
echo %Cyan%Searching for BIOS Product Key...%Reset%
set "KeyScript=%ToolDir%\FindKey.ps1"
if exist "%KeyScript%" del "%KeyScript%"
echo $key = "" > "%KeyScript%"
echo try { $key = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey } catch {} >> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault } catch {} } >> "%KeyScript%"
echo if ([string]::IsNullOrWhiteSpace($key)) { try { $key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BootDeviceProductKey } catch {} } >> "%KeyScript%"
echo $key ^| Out-File "$env:SystemDrive\MontagTools\oemkey.txt" -Encoding ASCII >> "%KeyScript%"

powershell -nop -ep bypass -File "%KeyScript%" >nul 2>&1
set "BiosKey="
if exist "%ToolDir%\oemkey.txt" ( set /p BiosKey=<"%ToolDir%\oemkey.txt" )
if not "!BiosKey!"=="" (
    echo.
    echo %Green%[OK] Key Found: %White%!BiosKey!%Reset%
    echo Installing Key...
    cscript //nologo %windir%\system32\slmgr.vbs /ipk !BiosKey! >nul 2>&1
    echo Activating Online...
    cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
    echo.
    echo %Green%[SUCCESS] Activation Command Sent.%Reset%
) else (
    echo.
    echo %Red%[ERROR] No Original BIOS Key Found.%Reset%
)
if exist "%KeyScript%" del "%KeyScript%"
if exist "%ToolDir%\oemkey.txt" del "%ToolDir%\oemkey.txt"
echo.
pause
goto :EOF

:DO_BLOAT
cls
echo %Cyan%Removing Windows Bloatware...%Reset%
powershell -nop -c "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *skype* | Remove-AppxPackage -ErrorAction SilentlyContinue"
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_BOOST
cls
echo %Cyan%Running Quick Boost ^& Fix...%Reset%
powercfg -h off >nul 2>&1 & net start w32time >nul 2>&1 & w32tm /resync >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_RENAME
cls
echo.
echo %Cyan%[ RENAME PC ^& USER ]%Reset%
echo.
set "ClientName="
set /p ClientName=" Enter Client Name: "
if "!ClientName!"=="" goto :EOF
powershell -nop -c "Rename-Computer -NewName '!ClientName!-PC' -Force -ErrorAction SilentlyContinue"
net user "%USERNAME%" /fullname:"!ClientName!" >nul 2>&1
wmic useraccount where name="%USERNAME%" rename "!ClientName!" >nul 2>&1
echo.
echo %Green%[OK] Name has been updated to '!ClientName!'.%Reset%
echo %Yellow%Restart the PC for changes to take effect.%Reset%
echo.
pause
goto :EOF

:DO_CLASSIC
cls
echo %Cyan%Restoring Classic Windows 11 Menu...%Reset%
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1 & start explorer.exe
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_SAC
cls
echo %Cyan%Disabling Smart App Control...%Reset%
set "SAC_P1=HKLM\SYSTEM\CurrentControlSet"
set "SAC_P2=Control\CI\Policy"
reg add "!SAC_P1!\!SAC_P2!" /v VerifiedAndReputablePolicyState /t REG_DWORD /d 0 /f >nul 2>&1
echo %Green%[OK] Policy Updated. Restart required.%Reset%
timeout /t 3 >nul
goto :EOF

:DO_DRV_BACKUP
set "PSDr=%ToolDir%\DrvBack.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $host.UI.RawUI.WindowTitle = 'Montag Store - Driver Backup' > "%PSDr%"
echo Write-Host "`n   DRIVER BACKUP (SMART ENGINE)" -ForegroundColor Magenta >> "%PSDr%"
echo $model = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%PSDr%"
echo $safeModel = $model -replace '[^^a-zA-Z0-9]', '_' >> "%PSDr%"
echo Write-Host "   Detected Model: $model" -ForegroundColor Yellow >> "%PSDr%"
echo $drv = Read-Host "`n   Enter Target Drive Letter (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $drv = $drv.Replace(':', '').Trim() >> "%PSDr%"
echo if (-not (Test-Path "$($drv):\")) { Write-Host "`n   [ERROR] Drive $($drv): does not exist!" -ForegroundColor Red; Read-Host "   Press Enter to exit..."; exit } >> "%PSDr%"
echo $finalPath = "$($drv):\$safeModel`_Drivers" >> "%PSDr%"
echo New-Item -ItemType Directory -Force -Path $finalPath ^| Out-Null >> "%PSDr%"
echo Write-Host "   Destination: $finalPath" -ForegroundColor Cyan >> "%PSDr%"
echo Write-Host "`n   Exporting Drivers... (Please wait, this takes time)" -ForegroundColor Yellow >> "%PSDr%"
echo Start-Process pnputil -ArgumentList "/export-driver * `"$finalPath`"" -NoNewWindow -Wait >> "%PSDr%"
echo Write-Host "`n   [OK] Drivers Saved Successfully." -ForegroundColor Green >> "%PSDr%"
echo Read-Host "`n   Press Enter to exit..." >> "%PSDr%"
powershell -nop -ep bypass -File "%PSDr%"
del "%PSDr%" >nul 2>&1
goto :EOF

:DO_DRV_RESTORE
set "PSDr=%ToolDir%\DrvRest.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $host.UI.RawUI.WindowTitle = 'Montag Store - Driver Restore' > "%PSDr%"
echo Write-Host "`n   DRIVER RESTORE (SMART ENGINE)" -ForegroundColor Magenta >> "%PSDr%"
echo $drv = Read-Host "`n   Enter Source Drive Letter (e.g. D)" >> "%PSDr%"
echo if (-not $drv) { exit } >> "%PSDr%"
echo $drv = $drv.Replace(':', '').Trim() >> "%PSDr%"
echo if (-not (Test-Path "$($drv):\")) { Write-Host "`n   [ERROR] Drive $($drv): does not exist!" -ForegroundColor Red; Read-Host "   Press Enter to exit..."; exit } >> "%PSDr%"
echo $term = (Get-WmiObject Win32_ComputerSystem).Model.Trim() >> "%PSDr%"
echo $pattern = "*" + ($term -replace '[^^a-zA-Z0-9]', '*') + "*" >> "%PSDr%"
echo Write-Host "   Searching for drivers matching: $term ..." -ForegroundColor Yellow >> "%PSDr%"
echo try { $folder = Get-ChildItem -Path "$($drv):\" -Directory -Recurse -Filter $pattern -ErrorAction SilentlyContinue ^| Select-Object -First 1 } catch { $folder = $null } >> "%PSDr%"
echo if ($folder) { >> "%PSDr%"
echo     Write-Host "   [FOUND] $($folder.FullName)" -ForegroundColor Green >> "%PSDr%"
echo     $conf = Read-Host "`n   Install these drivers? (Y/N)" >> "%PSDr%"
echo     if ($conf -match 'y') { >> "%PSDr%"
echo         Write-Host "   Installing... Please wait..." -ForegroundColor Magenta >> "%PSDr%"
echo         Start-Process pnputil -ArgumentList "/add-driver `"$($folder.FullName)\*.inf`" /subdirs /install" -NoNewWindow -Wait >> "%PSDr%"
echo         Write-Host "`n   [OK] Installation Complete." -ForegroundColor Green >> "%PSDr%"
echo         Read-Host "   Press Enter to restart later..." >> "%PSDr%"
echo     } >> "%PSDr%"
echo } else { >> "%PSDr%"
echo     Write-Host "`n   [ERROR] No driver folder found for this model on $drv drive." -ForegroundColor Red >> "%PSDr%"
echo     Read-Host "   Press Enter to exit..." >> "%PSDr%"
echo } >> "%PSDr%"
powershell -nop -ep bypass -File "%PSDr%"
del "%PSDr%" >nul 2>&1
goto :EOF

:DO_APP_GAMING
cls
echo %Cyan%Installing Gaming Essentials (VCRedist)...%Reset%
winget install --id Microsoft.VCRedist.2015+.x64 -e --accept-source-agreements --accept-package-agreements >nul 2>&1
winget install --id Microsoft.VCRedist.2015+.x86 -e --accept-source-agreements --accept-package-agreements >nul 2>&1
echo %Green%[OK] Done.%Reset%
timeout /t 2 >nul
goto :EOF

:DO_APP_BUNDLE
cls
echo %Cyan%Downloading Apps Module...%Reset%
curl -L -k -# -o "%ToolDir%\MontagApps.bat" "https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagApps.bat"
if exist "%ToolDir%\MontagApps.bat" start "" "%ToolDir%\MontagApps.bat"
goto :EOF

:DO_APP_OFFICE
cls
echo %Cyan%Downloading Office Suite Script...%Reset%
curl -L -k -# -o "%ToolDir%\MontagOffice.bat" "https://raw.githubusercontent.com/0xkhaledabdelaziz/MontagStoreTest/refs/heads/main/MontagOffice.bat"
if exist "%ToolDir%\MontagOffice.bat" start "" "%ToolDir%\MontagOffice.bat"
goto :EOF

:DO_APP_DEFCONT
cls
echo %Cyan%Downloading Defender Control...%Reset%
curl -L -k -# -o "%ToolDir%\DefCont.rar" "https://www.dropbox.com/scl/fi/ek7g511arqlacuf8jblhx/Defender-Control-pass-1.rar?rlkey=wrpduzvs5gynt3nta96xfkxuh&st=369mh2n4&dl=1"
if exist "%ToolDir%\DefCont.rar" explorer "%ToolDir%"
goto :EOF

:DO_BATTERY
cls
echo %Cyan%================================================================================%Reset%
echo                               [ REAL BATTERY DRAIN TEST ]
echo %Cyan%================================================================================%Reset%
echo.
echo %Yellow%Starting Auto-Test:%Reset%
echo  1. Prevent Sleep Mode...
echo  2. Searching for 'BatteryTest.mp4' on ALL drives...
echo.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg -h off >nul 2>&1

set "DestVid=%ToolDir%\BatteryTest.mp4"
set "FoundSource="
if exist "%~dp0BatteryTest.mp4" set "FoundSource=%~dp0BatteryTest.mp4" & goto FoundVideoBAT
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\BatteryTest.mp4" (set "FoundSource=%%d:\BatteryTest.mp4" & goto FoundVideoBAT)
)
echo %Red%[ERROR] 'BatteryTest.mp4' NOT FOUND on any drive!%Reset%
echo.
pause
goto :EOF

:FoundVideoBAT
echo %Green%[FOUND] %FoundSource%%Reset%
echo %Yellow%Copying to System (C:) - Please Wait...%Reset%
copy /z /y "%FoundSource%" "%DestVid%" >nul 2>&1
if not exist "%DestVid%" (
    echo %Red%[ERROR] Copy Failed. Trying to play directly from USB...%Reset%
    start "" "%FoundSource%"
    goto StartLoggerBAT
)
echo %Green%[OK] Copy Complete. Starting Test...%Reset%
timeout /t 2 >nul
start "" "%DestVid%"

:StartLoggerBAT
set "BatScript=%ToolDir%\BatLogger.ps1"
if exist "%BatScript%" del "%BatScript%"
echo $host.UI.RawUI.WindowTitle = "Montag Battery Timer" > "%BatScript%"
echo $log = "C:\MontagBatteryLog.txt" >> "%BatScript%"
echo $sys = (Get-CimInstance Win32_ComputerSystem).Model.Trim() >> "%BatScript%"
echo $ser = (Get-CimInstance Win32_Bios).SerialNumber.Trim() >> "%BatScript%"
echo $start = Get-Date >> "%BatScript%"
echo Add-Content $log "==========================================" >> "%BatScript%"
echo Add-Content $log "      MONTAG STORE - BATTERY TEST" >> "%BatScript%"
echo Add-Content $log "==========================================" >> "%BatScript%"
echo Add-Content $log "Device : $sys" >> "%BatScript%"
echo Add-Content $log "Serial : $ser" >> "%BatScript%"
echo Add-Content $log "Started: $start" >> "%BatScript%"
echo Add-Content $log "------------------------------------------" >> "%BatScript%"
echo Write-Host "`n   MONTAG STORE - BATTERY STOPWATCH" -ForegroundColor Magenta >> "%BatScript%"
echo while ($true) { >> "%BatScript%"
echo     $now = Get-Date >> "%BatScript%"
echo     $diff = $now - $start >> "%BatScript%"
echo     $b = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue >> "%BatScript%"
echo     $bat = if ($b) { $b.EstimatedChargeRemaining } else { '??' } >> "%BatScript%"
echo     $str = "{0:hh\:mm\:ss}          {1}%%" -f $diff, $bat >> "%BatScript%"
echo     Write-Host "`r   $str" -NoNewline -ForegroundColor Cyan >> "%BatScript%"
echo     $logLine = "$($now.ToString('HH:mm:ss')) | Elapsed: $($diff.ToString('hh\:mm')) | Battery: $bat%%" >> "%BatScript%"
echo     Add-Content $log $logLine -ErrorAction SilentlyContinue >> "%BatScript%"
echo     Start-Sleep -Seconds 60 >> "%BatScript%"
echo } >> "%BatScript%"
cls
echo.
echo   [ MONTAG BATTERY TEST - DO NOT CLOSE ]
echo   Initializing Logger...
echo.
powershell -nop -ep bypass -File "%BatScript%"
goto :EOF

:DO_CHARGER
set "PSChg=%ToolDir%\MontagCharger.ps1"
if exist "%PSChg%" del "%PSChg%"
echo $host.UI.RawUI.WindowTitle = "Montag Lab - Charger Stress Test" > "%PSChg%"
echo Write-Host "`n   [16] CHARGER STRESS (30 Seconds Load Test)" -ForegroundColor Cyan >> "%PSChg%"
echo Write-Host "   Putting system under 100%% CPU load to verify AC Adapter capacity...`n" -ForegroundColor Gray >> "%PSChg%"
echo $b_init = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue >> "%PSChg%"
echo if (-not $b_init) { Write-Host "   [ERROR] No Battery Detected!" -ForegroundColor Red; Start-Sleep 3; exit } >> "%PSChg%"
echo $initCharge = $b_init.EstimatedChargeRemaining >> "%PSChg%"
echo Write-Host "   Initial Charge: $initCharge%%`n" -ForegroundColor White >> "%PSChg%"
echo $jobs = @() >> "%PSChg%"
echo 1..([Environment]::ProcessorCount) ^| ForEach-Object { $jobs += Start-Job -ScriptBlock { while($true){ $n=[math]::Sqrt([math]::PI) } } } >> "%PSChg%"
echo $sw = [Diagnostics.Stopwatch]::StartNew() >> "%PSChg%"
echo $failed = $false >> "%PSChg%"
echo try { >> "%PSChg%"
echo     while($sw.Elapsed.TotalSeconds -lt 30) { >> "%PSChg%"
echo         $b = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue >> "%PSChg%"
echo         $status = $b.BatteryStatus >> "%PSChg%"
echo         $pct = $b.EstimatedChargeRemaining >> "%PSChg%"
echo         if ($pct -lt $initCharge) { $failed = $true } >> "%PSChg%"
echo         $rem = 30 - [math]::Round($sw.Elapsed.TotalSeconds) >> "%PSChg%"
echo         if ($status -eq 1) { $stStr = "DISCHARGING (Weak/Unplugged) " ; $col = "Red" } >> "%PSChg%"
echo         elseif ($status -eq 2) { $stStr = "CHARGING (Holding Load)      " ; $col = "Green" } >> "%PSChg%"
echo         else { $stStr = "PLUGGED IN (Status Stable)   " ; $col = "Yellow" } >> "%PSChg%"
echo         Write-Host -NoNewline "`r   [LIVE] $stStr | Charge: $pct%% | Time: $rem s   " -ForegroundColor $col >> "%PSChg%"
echo         Start-Sleep -Milliseconds 500 >> "%PSChg%"
echo     } >> "%PSChg%"
echo } finally { $jobs ^| Stop-Job ^| Out-Null } >> "%PSChg%"
echo Write-Host "`n`n   ==========================================" -ForegroundColor Cyan >> "%PSChg%"
echo if ($failed) { >> "%PSChg%"
echo     Write-Host "   [RESULT] CHARGER FAILED / WEAK" -ForegroundColor Red >> "%PSChg%"
echo     Write-Host "   The battery drained while plugged in under load." -ForegroundColor Gray >> "%PSChg%"
echo } else { >> "%PSChg%"
echo     Write-Host "   [RESULT] CHARGER PASSED / GOOD" -ForegroundColor Green >> "%PSChg%"
echo     Write-Host "   The charger maintained battery power under load." -ForegroundColor Gray >> "%PSChg%"
echo } >> "%PSChg%"
echo Write-Host "   ==========================================" -ForegroundColor Cyan >> "%PSChg%"
echo Write-Host "`n   Closing in 5 seconds..." -ForegroundColor Gray >> "%PSChg%"
echo Start-Sleep -Seconds 5 >> "%PSChg%"
cls
echo.
echo   [ MONTAG CHARGER STRESS - DO NOT CLOSE ]
echo   Initializing Engine...
echo.
powershell -nop -ep bypass -File "%PSChg%"
goto :EOF

:DO_STRESS
set "PSStress=%ToolDir%\MontagStress.ps1"
if exist "%PSStress%" del "%PSStress%"
echo param($Type, $Duration) > "%PSStress%"
echo $Duration = [int]$Duration >> "%PSStress%"
echo $host.UI.RawUI.WindowTitle = "Montag Store - $Type Stress Test" >> "%PSStress%"
echo Write-Host "`n   [ MONTAG EXTREME $Type STRESS TEST ]" -ForegroundColor Red >> "%PSStress%"
echo if ($Duration -eq 0) { Write-Host "   Mode: INFINITE (Close window to stop)`n" -ForegroundColor Yellow } else { Write-Host "   Mode: $Duration Seconds`n" -ForegroundColor Yellow } >> "%PSStress%"
echo if ($Type -eq 'CPU') { >> "%PSStress%"
echo     $jobs = @() >> "%PSStress%"
echo     1..([Environment]::ProcessorCount) ^| ForEach-Object { $jobs += Start-Job -ScriptBlock { while($true){ $n=[math]::Sqrt([math]::PI) } } } >> "%PSStress%"
echo     $s = [Diagnostics.Stopwatch]::StartNew() >> "%PSStress%"
echo     while ($true) { >> "%PSStress%"
echo         $el = $s.Elapsed.TotalSeconds >> "%PSStress%"
echo         if ($Duration -gt 0 -and $el -ge $Duration) { break } >> "%PSStress%"
echo         $max = if ($Duration -eq 0) { "INF" } else { $Duration } >> "%PSStress%"
echo         Write-Host -NoNewline "`r   Stressing CPU (100%% Load)... $([math]::Round($el))s / $($max)s " >> "%PSStress%"
echo         Start-Sleep -Milliseconds 500 >> "%PSStress%"
echo     } >> "%PSStress%"
echo     $jobs ^| Stop-Job >> "%PSStress%"
echo } elseif ($Type -eq 'RAM') { >> "%PSStress%"
echo     $a = @() >> "%PSStress%"
echo     $s = [Diagnostics.Stopwatch]::StartNew() >> "%PSStress%"
echo     while ($true) { >> "%PSStress%"
echo         $el = $s.Elapsed.TotalSeconds >> "%PSStress%"
echo         if ($Duration -gt 0 -and $el -ge $Duration) { break } >> "%PSStress%"
echo         try { $a += New-Object byte[] (50MB) } catch {} >> "%PSStress%"
echo         $free = [math]::Round(((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024), 2) >> "%PSStress%"
echo         $max = if ($Duration -eq 0) { "INF" } else { $Duration } >> "%PSStress%"
echo         Write-Host -NoNewline "`r   Stressing RAM (Filling Memory)... $([math]::Round($el))s / $($max)s | Free: $free MB " >> "%PSStress%"
echo         Start-Sleep -Milliseconds 100 >> "%PSStress%"
echo     } >> "%PSStress%"
echo     $a = $null; [GC]::Collect() >> "%PSStress%"
echo } elseif ($Type -eq 'GPU') { >> "%PSStress%"
echo     Write-Host "   Launching WebGL Shader Engine... (DO NOT CLOSE THE BROWSER WINDOW)" -ForegroundColor Cyan >> "%PSStress%"
echo     $gpuHtml = "$env:SystemDrive\MontagTools\MontagGPU.html" >> "%PSStress%"
echo     $htmlContent = "<!DOCTYPE html><html><head><style>body{margin:0;overflow:hidden;background:#000;}canvas{width:100vw;height:100vh;display:block;}</style></head><body><canvas id='gl'></canvas><script>var c=document.getElementById('gl');var gl=c.getContext('webgl')||c.getContext('experimental-webgl');c.width=window.innerWidth;c.height=window.innerHeight;gl.viewport(0,0,c.width,c.height);var vs=gl.createShader(gl.VERTEX_SHADER);gl.shaderSource(vs,'attribute vec2 p;void main(){gl_Position=vec4(p,0,1);}');gl.compileShader(vs);var fs=gl.createShader(gl.FRAGMENT_SHADER);gl.shaderSource(fs,'precision highp float;uniform float t;uniform vec2 r;void main(){vec2 p=(gl_FragCoord.xy*2.-r)/min(r.x,r.y);float s=0.,v=0.;for(float i=0.;i<250.;i++){vec2 q=p+vec2(cos(t*0.1+i),sin(t*0.15+i))*0.5;float l=length(q);s+=exp(-l*10.);v+=sin(l*20.-t*4.);}gl_FragColor=vec4(vec3(s*0.5+v*0.2,s*0.2,v*0.5),1);}');gl.compileShader(fs);var p=gl.createProgram();gl.attachShader(p,vs);gl.attachShader(p,fs);gl.linkProgram(p);gl.useProgram(p);var b=gl.createBuffer();gl.bindBuffer(gl.ARRAY_BUFFER,b);gl.bufferData(gl.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1]),gl.STATIC_DRAW);var al=gl.getAttribLocation(p,'p');gl.enableVertexAttribArray(al);gl.vertexAttribPointer(al,2,gl.FLOAT,false,0,0);var ut=gl.getUniformLocation(p,'t');var ur=gl.getUniformLocation(p,'r');var start=Date.now();function f(){gl.uniform1f(ut,(Date.now()-start)*0.001);gl.uniform2f(ur,c.width,c.height);gl.drawArrays(gl.TRIANGLES,0,6);requestAnimationFrame(f);}f();</script></body></html>" >> "%PSStress%"
echo     Set-Content -Path $gpuHtml -Value $htmlContent -Encoding UTF8 >> "%PSStress%"
echo     Start-Process "msedge" -ArgumentList "--new-window --kiosk --edge-kiosk-type=fullscreen --disable-web-security --user-data-dir=`"$env:SystemDrive\MontagTools\EdgeGPU`" `"$gpuHtml`"" >> "%PSStress%"
echo     $s = [Diagnostics.Stopwatch]::StartNew() >> "%PSStress%"
echo     while ($true) { >> "%PSStress%"
echo         $el = $s.Elapsed.TotalSeconds >> "%PSStress%"
echo         if ($Duration -gt 0 -and $el -ge $Duration) { break } >> "%PSStress%"
echo         $max = if ($Duration -eq 0) { "INF" } else { $Duration } >> "%PSStress%"
echo         Write-Host -NoNewline "`r   Stressing GPU Graphics Core... $([math]::Round($el))s / $($max)s " >> "%PSStress%"
echo         Start-Sleep -Milliseconds 500 >> "%PSStress%"
echo     } >> "%PSStress%"
echo     Get-CimInstance Win32_Process -Filter "Name='msedge.exe' AND CommandLine LIKE '%%EdgeGPU%%'" ^| Invoke-CimMethod -MethodName Terminate ^| Out-Null >> "%PSStress%"
echo     del $gpuHtml -Force -ErrorAction SilentlyContinue >> "%PSStress%"
echo } >> "%PSStress%"
echo Write-Host "`n`n   [OK] TEST COMPLETED SUCCESSFULLY." -ForegroundColor Green >> "%PSStress%"
echo Start-Sleep -Seconds 4 >> "%PSStress%"
powershell -nop -ep bypass -File "%PSStress%" -Type "%SType%" -Duration "%SDur%"
del "%PSStress%" >nul 2>&1
goto :EOF

:: ==============================================================================
:::__HUB_CORE_START__:::
param($MFG)

Add-Type -Name ConsoleHider -Namespace Win32 -MemberDefinition '
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
[Win32.ConsoleHider]::ShowWindow([Win32.ConsoleHider]::GetConsoleWindow(), 0) | Out-Null

$GuiFile = "$env:SystemDrive\MontagTools\MontagDiagnosticUltimate.html"

# --- SALES & REPORTING CONFIGURATION ---
$GFormID = "1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"
$TechNum = "201040901444"
$IconDir = "$env:ProgramData\MontagStore"
$IconPath = "$IconDir\Montag.ico"
$UrlIcon = "https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1"
if (-not (Test-Path $IconDir)) { New-Item -ItemType Directory -Path $IconDir -Force | Out-Null }
if (-not (Test-Path $IconPath)) { Invoke-WebRequest -Uri $UrlIcon -OutFile $IconPath -UseBasicParsing -ErrorAction SilentlyContinue }

# --- LOGOS LOGIC ---
$LogoMontag = "https://www.dropbox.com/scl/fi/2qv201jvm18n3c971436o/Logo-purple.png?rlkey=b8n5e732fsepkadzg7y10gj1k&st=7q4k6jll&raw=1"
$BrandLogo = "https://cdn.simpleicons.org/windows/00e5ff" 
if ($MFG -match "Dell") { $BrandLogo = "https://cdn.simpleicons.org/dell/0076CE" }
elseif ($MFG -match "HP" -or $MFG -match "Hewlett") { $BrandLogo = "https://cdn.simpleicons.org/hp/0096D6" }
elseif ($MFG -match "Lenovo") { $BrandLogo = "https://cdn.simpleicons.org/lenovo/E2231A" }

# --- FAST HARDWARE SCAN FOR WELCOME SCREEN & REPORTS ---
$sys = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_Bios

$Mod = $sys.Model.Trim()
if ($Mod.StartsWith($sys.Manufacturer.Trim())) { $FullModel = $Mod } else { $FullModel = "$($sys.Manufacturer.Trim()) $Mod" }
$serialNum = $bios.SerialNumber

# Warranty Links
$WarrantyLink = "https://www.google.com/search?q=$($bios.SerialNumber)+warranty"
if ($MFG -match "Dell") { $WarrantyLink = "https://www.dell.com/support/home/en-us/product-support/servicetag/$($bios.SerialNumber)/overview" }
elseif ($MFG -match "HP" -or $MFG -match "Hewlett") { $WarrantyLink = "https://support.hp.com/us-en/checkwarranty" }
elseif ($MFG -match "Lenovo") { $WarrantyLink = "https://pcsupport.lenovo.com/us/en/warrantylookup" }

# CPU Info & Logo
$cpu = @(Get-CimInstance Win32_Processor)[0]
$cpuName = $cpu.Name.Trim() -replace '\s+', ' '
$maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cacheMB = [int]($cpu.L3CacheSize / 1024)
if ($cacheMB -eq 0 -and $cpu.L2CacheSize) { $cacheMB = [int]($cpu.L2CacheSize / 1024) }
$cacheStr = if ($cacheMB -gt 0) { " | $cacheMB MB Cache" } else { "" }
$cpuDetails = "$cpuName | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz$cacheStr"

$CpuLogo = "https://cdn.simpleicons.org/intel/0068B5"
if ($cpuName -match "AMD") { $CpuLogo = "https://cdn.simpleicons.org/amd/ED1C24" }

# RAM
$memArray = @(Get-CimInstance Win32_PhysicalMemoryArray)[0]
$mems = @(Get-CimInstance Win32_PhysicalMemory)
$totalSlots = if ($memArray) { $memArray.MemoryDevices } else { "?" }
$maxMem = if ($memArray) { [math]::Round($memArray.MaxCapacity / 1048576, 1) } else { "?" }
$usedSlots = $mems.Count
$speed = if ($mems) { $mems[0].Speed } else { "?" }
$totalRam = [math]::Round(($mems | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramDetailsUI = "$totalRam GB ($speed MHz) <br> <span style='color:#a0a0ab; font-size:13px;'>Slots: $usedSlots Used of $totalSlots | Max Upgrade: $maxMem GB</span>"
$ramDetails = "$totalRam GB Installed ($usedSlots Sticks) @ $speed MHz"

# Storage
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { ($_.MediaType -eq 'Fixed hard disk media') -and ($_.InterfaceType -ne 'USB') -and ($_.PNPDeviceID -notmatch 'USBSTOR') -and ($_.Model -notmatch 'USB') }
$totalDiskSize = 0
$diskCount = 0
$diskList = @()
foreach ($d in $disks) { 
    $s = [math]::Round($d.Size / 1GB, 0)
    $totalDiskSize += $s; 
    $diskCount++ 
    $diskList += "$($d.Model) ($s GB)" 
}
if ($totalDiskSize -eq 0) { 
    $storageStringUI = "No Internal Disk Detected" 
    $storageString = "No Internal Disk Detected"
} else { 
    $storageStringUI = "$totalDiskSize GB <br> <span style='color:#a0a0ab; font-size:13px;'>Installed Drives: $diskCount</span>" 
    $storageString = $diskList -join " | "
}

# GPU
$gpuList = @()
$regBase = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
Get-ChildItem $regBase -ErrorAction SilentlyContinue | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
    if ($props -and $props.DriverDesc) {
        $size = 0
        if ($null -ne $props.'HardwareInformation.QwMemorySize') { $size = $props.'HardwareInformation.QwMemorySize' }
        elseif ($null -ne $props.'HardwareInformation.MemorySize') { $size = $props.'HardwareInformation.MemorySize' }
        if ($size -is [array]) {
            try {
                if ($size.Count -ge 8) { $size = [BitConverter]::ToUInt64($size, 0) }
                elseif ($size.Count -ge 4) { $size = [BitConverter]::ToUInt32($size, 0) }
                else { $size = 0 }
            } catch { $size = 0 }
        }
        $gb = 0
        if ($size -gt 0) { $gb = [math]::Round([uint64]$size / 1GB) }
        if ($gb -gt 0) { $gpuList += "$($props.DriverDesc) ($gb GB)" } else { $gpuList += $props.DriverDesc }
    }
}
$gpuString = ($gpuList | Select-Object -Unique) -join " + "

# --- DISPLAY RESOLUTION ---
$resString = ""
try {
    $vid = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | Where-Object CurrentHorizontalResolution -ne $null | Select-Object -First 1
    if ($vid) {
        $w = $vid.CurrentHorizontalResolution
        $h = $vid.CurrentVerticalResolution
        $hz = $vid.CurrentRefreshRate
        $resType = "HD"
        if ($w -ge 1920) { $resType = "FHD" }
        if ($w -ge 2560) { $resType = "QHD" }
        if ($w -ge 3840) { $resType = "4K" }
        $resString = "$w x $h ($resType) @ $hz Hz"
    } else {
        $resString = "Standard Display"
    }
} catch { $resString = "Standard Display" }

# MERGE DISPLAY WITH GPU STRING FOR THE FINAL REPORT AND DB UPLOAD
$gpuString = "$gpuString | Display: $resString"

# --- TEMPERATURE DETECTION ---
$cpuTemp = "N/A"
$cpuTempColor = "#a0a0ab"
try {
    $tz = Get-CimInstance -Namespace "root/wmi" -ClassName "MSAcpi_ThermalZoneTemperature" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($tz -and $tz.CurrentTemperature) {
        $c = [math]::Round(($tz.CurrentTemperature / 10) - 273.15)
        if ($c -gt 0 -and $c -lt 150) {
            $cpuTemp = "$c C"
            if ($c -ge 85) { $cpuTempColor = "#ef4444" }
            elseif ($c -ge 75) { $cpuTempColor = "#f59e0b" }
            else { $cpuTempColor = "#28a745" }
        }
    }
} catch {}

$gpuTemp = "N/A"
$gpuTempColor = "#a0a0ab"
try {
    $nvsmi = "$env:windir\System32\nvidia-smi.exe"
    if (Test-Path $nvsmi) {
        $gInfo = &$nvsmi --query-gpu=temperature.gpu --format=csv,noheader
        if ($gInfo -match "\d+") {
            $gVal = [int]$matches[0]
            $gpuTemp = "$gVal C"
            if ($gVal -ge 85) { $gpuTempColor = "#ef4444" }
            elseif ($gVal -ge 75) { $gpuTempColor = "#f59e0b" }
            else { $gpuTempColor = "#28a745" }
        }
    }
} catch {}

$cpuDetailsUI = "$cpuName <br> <span style='color:#a0a0ab; font-size:13px;'>$($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz$cacheStr</span> <br> <span style='color:$cpuTempColor; font-size:13px; font-weight:800; margin-top:5px; display:inline-block;'>Temp: $cpuTemp</span>"
$gpuStringUI = ($gpuList | Select-Object -Unique) -join " <br> "
if (-not $gpuStringUI) { $gpuStringUI = "Standard Graphics Adapter" }
$gpuStringUI = "$gpuStringUI <br><span style='color:var(--secondary); font-size:12px; font-weight:800; letter-spacing:1px; margin-top:5px; display:inline-block;'>$resString</span> <br> <span style='color:$gpuTempColor; font-size:13px; font-weight:800; margin-top:5px; display:inline-block;'>Temp: $gpuTemp</span>"


# --- BATTERY HEALTH ---
$batHealth = "Unknown"
try {
    $full = (Get-WmiObject -Class BatteryFullCapacity -Namespace root\wmi -ErrorAction SilentlyContinue).FullChargeCapacity
    $design = (Get-WmiObject -Class BatteryStaticData -Namespace root\wmi -ErrorAction SilentlyContinue).DesignedCapacity
    if ($full -and $design -and $design -gt 0) {
        $pct = [math]::Round(($full / $design) * 100)
        if ($pct -gt 100) { $pct = 100 }
        $batHealth = "$pct% Excellent"
        if ($pct -lt 80) { $batHealth = "$pct% Good" }
        if ($pct -lt 50) { $batHealth = "$pct% Weak" }
    } else {
        $b2 = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
        if ($b2) { $batHealth = "Status OK" } else { $batHealth = "No Battery" }
    }
} catch { $batHealth = "No Battery" }

# --- STORAGE HEALTH (S.M.A.R.T) ---
$diskHealth = "100% Excellent"
try {
    $smart = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
    if ($smart) { foreach ($d in $smart) { if ($d.PredictFailure) { $diskHealth = "FAILING (Warning)" } } }
} catch { }

# --- AC ADAPTER STATUS ---
$acStatus = "Connected"
try {
    $batStatus = (Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue).BatteryStatus
    if ($batStatus -eq 1) { $acStatus = "Disconnected" }
    elseif ($batStatus -eq 2) { $acStatus = "Charging" }
    else { $acStatus = "Plugged In" }
} catch { $acStatus = "AC Power" }


# ==========================================================
# MASTER UI HTML CONSTRUCTION
# ==========================================================
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MONTAG_HUB_ACTIVE</title>
<style>
    :root { --primary: #8f00ff; --secondary: #00e5ff; --bg-deep: #050505; --card: rgba(15, 15, 20, 0.75); --success: #28a745; --error: #ef4444; }
    html, body { width: 100vw; height: 100vh; margin: 0; padding: 0; font-family: 'Outfit', sans-serif; background-color: var(--bg-deep); color: #fff; display: block; overflow: hidden; box-sizing: border-box; position: relative; z-index: 1; }

    body::before, body::after { content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%; filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate; pointer-events: none; }
    body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } 
    body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } 
    @keyframes floatOrbs { 0% { transform: translate(0, 0) scale(1); } 100% { transform: translate(5%, 5%) scale(1.15); } }

    #splash { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: #000; z-index: 10000; display: flex; flex-direction: column; align-items: center; justify-content: center; transition: opacity 0.8s ease-in-out; }
    .splash-logo { width: 630px; filter: drop-shadow(0 0 50px var(--primary)); animation: constantNeonPulse 2.5s infinite alternate ease-in-out, splashFinalZoom 3s forwards; opacity: 0; }
    @keyframes splashFinalZoom { 0% { transform: scale(0.75) translateY(20px); opacity: 0; filter: brightness(0) blur(25px); } 30% { opacity: 1; filter: brightness(1.8) blur(0px); } 100% { transform: scale(1) translateY(0); opacity: 1; } }
    @keyframes constantNeonPulse { 0% { filter: drop-shadow(0 0 30px var(--primary)) brightness(0.9); } 100% { filter: drop-shadow(0 0 80px var(--primary)) brightness(1.4); } }
    .master-loader-box { width: 420px; height: 3px; background: rgba(255,255,255,0.02); margin: 60px auto 0; border-radius: 10px; overflow: hidden; opacity: 0; animation: fadeIn 0.5s 0.5s forwards; }
    .master-loader-fill { width: 0%; height: 100%; background: linear-gradient(90deg, var(--primary), var(--secondary)); box-shadow: 0 0 25px var(--secondary); animation: loaderMasterFill 2.5s ease-in-out forwards; }
    @keyframes loaderMasterFill { 0% { width: 0%; } 100% { width: 100%; } }
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

    .sidebar { position: fixed; top: 0; left: 0; transform: translateX(calc(-100% + 15px)); width: 340px; height: 100vh; background: rgba(2, 2, 8, 0.98); border-right: 3px solid var(--primary); display: flex; flex-direction: column; padding: 30px 0; backdrop-filter: blur(80px); z-index: 9999; box-sizing: border-box; transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.4s; animation: sideBorderGlow 3s infinite alternate ease-in-out; }
    @keyframes sideBorderGlow { 0% { border-color: var(--primary); box-shadow: 5px 0 20px rgba(143,0,255,0.6), inset -3px 0 15px rgba(143,0,255,0.3); } 100% { border-color: var(--secondary); box-shadow: 8px 0 35px rgba(0,229,255,0.8), inset -5px 0 25px rgba(0,229,255,0.4); } }
    .sidebar::after { content: ''; position: absolute; top: 0; right: -60px; width: 60px; height: 100%; background: transparent; z-index: 10001; }
    .sidebar-trigger { position: absolute; left: 100%; top: 50%; transform: translateY(-50%); width: 85px; padding: 55px 0; background: rgba(2, 2, 8, 0.98); border: 3px solid var(--primary); border-left: none; border-radius: 0 20px 20px 0; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; color: var(--primary); font-weight: 950; font-size: 19px; cursor: pointer; transition: 0.3s; z-index: 10000; animation: triggerBtnGlow 3s infinite alternate ease-in-out; }
    @keyframes triggerBtnGlow { 0% { border-color: var(--primary); box-shadow: 10px 0 20px rgba(143,0,255,0.6), inset 0 0 15px rgba(143,0,255,0.4); color: var(--primary); text-shadow: 0 0 10px var(--primary); } 100% { border-color: var(--secondary); box-shadow: 15px 0 35px rgba(0,229,255,0.8), inset 0 0 20px rgba(0,229,255,0.6); color: var(--secondary); text-shadow: 0 0 15px var(--secondary); } }
    .sidebar:hover { transform: translateX(0); box-shadow: 20px 0 60px rgba(0,0,0,0.9); }
    .nav-btn { background: transparent; color: #666; border: none; padding: 22px 40px; text-align: left; font-family: inherit; font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.5s; border-left: 4px solid transparent; width: 100%; display: flex; justify-content: space-between; align-items: center; box-sizing: border-box; text-transform: uppercase; letter-spacing: 1px; }
    .nav-btn:hover { background: rgba(255,255,255,0.02); color: #fff; }
    .nav-btn.active { background: linear-gradient(90deg, rgba(143,0,255,0.12), transparent); color: #fff; border-left-color: var(--primary); font-weight: 800; }
    .done-badge { display: none; color: var(--success); font-size: 9px; font-weight: 900; border: 1px solid var(--success); padding: 2px 6px; border-radius: 4px; margin-left: 10px; flex-shrink: 0; }

    .panel { width: 100vw; height: 100vh; padding: 50px 80px 50px 100px; display: flex; flex-direction: column; align-items: center; overflow-y: auto; box-sizing: border-box; position: relative; }
    .header-system { width: 100%; display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.05); padding-bottom: 30px; margin-bottom: 45px; max-width: 1300px; }
    .montag-logo-main { grid-column: 1; justify-self: start; height: 130px; object-fit: contain; filter: drop-shadow(0 0 20px rgba(143, 0, 255, 0.7)); animation: neonPulseTop 1.5s infinite alternate ease-in-out; }
    .header-system img.brand { grid-column: 3; justify-self: end; height: 100px; filter: drop-shadow(0 0 15px rgba(0, 229, 255, 0.3)); }
    .header-system h1 { margin: 0; font-size: 32px; font-weight: 950; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; letter-spacing: 4px; text-align: center; }

    .section { display: none; width: 100%; flex-direction: column; align-items: center; animation: epicFadeIn 0.8s ease-out; max-width: 1300px; }
    .section.active { display: flex; }
    @keyframes epicFadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    .dash-grid { width: 100%; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; }
    .dash-card { background: var(--card); border: 1px solid rgba(255,255,255,0.05); padding: 35px; border-radius: 20px; cursor: pointer; transition: 0.3s; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; box-shadow: 0 15px 40px rgba(0,0,0,0.4); }
    .dash-card:hover { transform: translateY(-8px); border-color: var(--primary); box-shadow: 0 20px 50px rgba(143,0,255,0.3); }
    .dash-card h3 { margin: 0 0 10px 0; font-size: 20px; color: #fff; }
    .dash-card p { margin: 0; color: #777; font-size: 13px; }
    .card-status { margin-top: 20px; font-size: 11px; font-weight: 900; padding: 5px 15px; border-radius: 10px; background: rgba(255,255,255,0.05); color: #aaa; border: 1px solid #333; }
    .card-status.ok { background: rgba(40,167,69,0.1); color: var(--success); border-color: var(--success); }
	
    .welcome-container { display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%; max-width: 1000px; margin: 0 auto; animation: epicFadeIn 0.8s ease-out; }
    .welcome-header-row { display: flex; align-items: center; justify-content: center; width: 100%; margin-bottom: 45px; }
    .device-title { margin: 0; font-size: 45px; font-weight: 900; letter-spacing: 4px; text-align: center; color: #fff; line-height: 1.4; text-shadow: 0 0 20px rgba(0,229,255,0.5); padding: 0 40px; }
    
    .spec-grid-custom { display: flex; flex-direction: column; gap: 15px; width: 100%; margin-bottom: 45px; }
    .spec-row-split { display: flex; gap: 15px; width: 100%; }
    .spec-row-split > div { flex: 1; }
    .spec-card-mini { background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255,255,255,0.05); padding: 22px 30px; border-radius: 15px; border-left: 4px solid var(--primary); transition: 0.3s; display: flex; flex-direction: column; justify-content: center; }
    .spec-card-mini:hover { border-color: rgba(143,0,255,0.4); transform: translateY(-3px); box-shadow: 0 10px 25px rgba(143,0,255,0.2); background: rgba(0,0,0,0.6); }
    .spec-card-mini.accent { border-left-color: var(--secondary); align-items: center; flex-direction: row; justify-content: space-between; text-align: left; }
    .spec-label-mini { font-size: 11px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; font-weight: 800; display:block; }
    .spec-value-mini { font-size: 16px; font-weight: 500; color: #fff; line-height: 1.4; }
    
    @keyframes pulse-btn { 0% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0.4); } 70% { box-shadow: 0 0 0 15px rgba(143, 0, 255, 0); } 100% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0); } }
    @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(143, 0, 255, 0); } 100% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0); } }

    .btn-hero { width: 100%; background: linear-gradient(45deg, #ff007f, var(--primary)); color: #fff; border: none; padding: 25px; border-radius: 20px; font-size: 18px; font-weight: 950; text-transform: uppercase; letter-spacing: 2px; cursor: pointer; transition: 0.4s; box-shadow: 0 15px 40px rgba(143,0,255,0.4); margin-bottom: 25px; }
    .btn-hero:hover { transform: translateY(-4px); box-shadow: 0 20px 50px rgba(255,0,127,0.5); }
    .btn-grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; width: 100%; margin-top: 10px; }
    .btn-grid { background: rgba(255,255,255,0.03); color: #ccc; border: 1px solid rgba(255,255,255,0.06); padding: 22px 15px; border-radius: 15px; cursor: pointer; font-weight: 800; text-transform: uppercase; font-size: 13px; transition: 0.3s; display: flex; align-items: center; justify-content: center; letter-spacing: 1px; }
    .btn-grid:hover { background: linear-gradient(45deg, var(--primary), var(--secondary)); color: #fff; border-color: transparent; transform: translateY(-4px); box-shadow: 0 12px 25px rgba(143,0,255,0.3); }

    .test-view { display: none; width: 100%; flex-direction: column; align-items: center; animation: epicFadeIn 0.5s ease-out; }
    .test-view.active { display: flex; }
    .btn-back { align-self: flex-start; background: transparent; border: 1px solid #444; color: #aaa; padding: 10px 25px; border-radius: 30px; cursor: pointer; font-weight: 800; transition: 0.3s; margin-bottom: 30px; text-transform: uppercase; }
    .btn-back:hover { background: #222; color: #fff; border-color: #888; }
    
    .kb-frame { display: flex; gap: 15px; background: var(--card); padding: 40px; border-radius: 35px; border: 1px solid rgba(255,255,255,0.06); box-shadow: 0 45px 120px rgba(0,0,0,0.85); white-space: nowrap; }
    .kb-row { display: flex; gap: 8px; margin-bottom: 8px; justify-content: flex-start; }
    .key { background: #0f0f15; border: 1px solid #222; border-radius: 10px; color: #555; font-size: 8.5px; display: flex; align-items: center; justify-content: center; min-width: 50px; height: 50px; transition: 0.1s; font-weight: 750; }
    .key.pressed { background: var(--success) !important; color: #fff; box-shadow: 0 0 25px var(--success); border-color: var(--success); transform: translateY(4px) scale(0.92); }
    .nav-cluster { display: flex; flex-direction: column; gap: 8px; margin-left: 20px; border-left: 1px solid rgba(255,255,255,0.03); padding-left: 20px; }
    .nav-row-up { display: flex; justify-content: center; width: 100%; margin-top: 15px; }
    .nav-row-bottom { display: flex; gap: 8px; justify-content: center; margin-top: 8px; }
    .test-card-ultimate { background: var(--card); padding: 70px; border-radius: 40px; text-align: center; width: 100%; max-width: 800px; border: 1px solid rgba(255,255,255,0.05); box-shadow: 0 30px 90px rgba(0,0,0,0.6); }
    .btn-action-pro { margin-top: 35px; background: linear-gradient(45deg, var(--primary), var(--secondary)); color: #fff; border: none; padding: 22px 75px; font-size: 16px; font-weight: 950; border-radius: 50px; cursor: pointer; text-transform: uppercase; transition: 0.4s; }
    .btn-action-pro:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(143,0,255,0.4); }
    video { width: 100%; border-radius: 20px; margin-top: 30px; border: 4px solid var(--primary); background: #000; }

    .input-group { margin-bottom: 15px; width: 100%; text-align: left; }
    .input-group label { display: block; font-size: 12px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; font-weight: 800; }
    .input-group input, .input-group textarea { width: 100%; padding: 14px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255, 255, 255, 0.1); color: #00e5ff; border-radius: 8px; font-family: inherit; margin-bottom: 10px; outline: none; box-sizing: border-box; font-size: 14px; }
    .input-group input:focus, .input-group textarea:focus { border-color: var(--primary); box-shadow: 0 0 10px rgba(143, 0, 255, 0.2); }
    .static-box { background: rgba(0, 0, 0, 0.5); border: 1px solid rgba(0, 229, 255, 0.3); color: #00e5ff; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 500; text-align: left; }
    #clientSection, #stockSection, #notesSection { display: none; background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 10px; padding: 20px; margin-bottom: 15px; width: 100%; box-sizing: border-box; text-align: left; }
    .flex-row { display: flex; gap: 15px; } .flex-row .input-group { flex: 1; margin-bottom: 0; }
    .btn-group { display: flex; gap: 15px; width: 100%; margin-top: 15px; }
    .btn-sales { flex: 1; padding: 16px; border: none; border-radius: 10px; cursor: pointer; font-weight: 800; font-size: 14px; text-transform: uppercase; transition: 0.3s; color:#fff;}
    .btn-sell { background: linear-gradient(45deg, #10b981, #059669); }
    .btn-test { background: linear-gradient(45deg, #3b82f6, #2563eb); }
    .btn-confirm { background: linear-gradient(45deg, #8f00ff, #c026d3); animation: pulse 2s infinite; }
    .btn-issue { background: linear-gradient(45deg, #ef4444, #dc2626); }
    .btn-sales:hover { transform: translateY(-2px); filter: brightness(1.2); }
    .status-text { text-align: center; font-size: 14px; font-weight: 800; margin-top: 10px; padding: 12px; border-radius: 8px; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }

    @media (max-width: 1400px), (max-height: 850px) {
        .panel { padding: 30px 40px 30px 70px; }
        .montag-logo-main { height: 100px; }
        .header-system { margin-bottom: 30px; padding-bottom: 20px; }
        .header-system img.brand { height: 80px; }
        .header-system h1 { font-size: 26px; }
        .sidebar { width: 280px; }
        .nav-btn { padding: 18px 25px; font-size: 13px; }
        .device-title { font-size: 32px; letter-spacing: 1.5px; padding: 0 15px; }
        .spec-grid-custom { gap: 10px; margin-bottom: 30px; }
        .spec-card-mini { padding: 15px 20px; }
        .btn-action-pro { padding: 16px 50px; font-size: 14px; }
        .dash-card { padding: 25px; }
        .test-card-ultimate { padding: 40px; }
    }
</style>
</head>
<body>
<div id="splash"><div style="text-align:center;"><img src="$LogoMontag" class="splash-logo"><div class="master-loader-box"><div class="master-loader-fill"></div></div><p style="color:#555; font-size:12px; margin-top:35px; letter-spacing:8px; opacity:0; animation: fadeIn 0.8s 1s forwards;">INITIALIZING QUANTUM MASTER v22.0</p></div></div>

<div class="sidebar">
    <div class="sidebar-trigger"><span>M</span><span>E</span><span>N</span><span>U</span></div>
    <div style="text-align:center; padding: 20px 30px 40px 30px;"><img src="$LogoMontag" style="width:200px;"></div>
    
    <button class="nav-btn active" id="nav-hw" onclick="switchMainTab('tab-hw', this, 'Hardware Diagnostic Hub')"><span>[1] Hardware Tests</span><span class="done-badge" id="badge-hw">DONE</span></button>
    <button class="nav-btn" id="nav-stress" onclick="switchMainTab('tab-stress', this, 'Extreme Performance Stress')"><span>[2] Stress Tests</span></button>
    <button class="nav-btn" id="nav-win" onclick="switchMainTab('tab-win', this, 'Windows Setup Engine')"><span>[3] Windows Setup</span></button>
    <button class="nav-btn" id="nav-drv" onclick="switchMainTab('tab-drv', this, 'Drivers Center')"><span>[4] Drivers Center</span></button>
    <button class="nav-btn" id="nav-sw" onclick="switchMainTab('tab-sw', this, 'Software Hub')"><span>[5] Software Hub</span></button>
    
    <div style="flex:1"></div>
    <button class="nav-btn" id="nav-rep" onclick="switchMainTab('tab-rep', this, 'Final Report & Sales')" style="border-top: 1px solid rgba(255,255,255,0.05); color:var(--secondary);"><span>[6] Sales & Report</span></button>
    <button class="nav-btn" style="color:var(--error); font-weight:950; justify-content:center;" onclick="exitHub()">[X] TERMINATE HUB</button>
</div>

<div class="panel" id="mainContainer">
    <div class="header-system">
        <img src="$LogoMontag" class="montag-logo-main">
        <div style="grid-column:2; text-align:center;">
            <h1 id="main-title">Hardware Diagnostic Hub</h1>
            <p style="margin:10px 0 0; color:#444; font-size:12px; letter-spacing:4px;">PROPRIETARY QUANTUM PLATFORM</p>
        </div>
        <img src="$BrandLogo" class="brand">
    </div>

    <div id="tab-hw" class="section active">
        <div id="welcome-view" class="welcome-container">
            <div class="welcome-header-row"><h2 class="device-title">$FullModel</h2></div>
            <div class="spec-grid-custom">
                <div class="spec-card-mini accent">
                    <div><span class="spec-label-mini">Processor Engine (CPU)</span><div class="spec-value-mini">$cpuDetailsUI</div></div>
                    <img src="$CpuLogo" style="height: 50px; filter: drop-shadow(0 0 10px rgba(255,255,255,0.2));">
                </div>
                <div class="spec-card-mini">
                    <span class="spec-label-mini">Graphics Processor (GPU)</span>
                    <div class="spec-value-mini" style="color: #e0e0e0;">$gpuStringUI</div>
                </div>
                <div class="spec-row-split">
                    <div class="spec-card-mini"><span class="spec-label-mini">Installed Memory (RAM)</span><div class="spec-value-mini">$ramDetailsUI</div></div>
                    <div class="spec-card-mini"><span class="spec-label-mini">Internal Storage</span><div class="spec-value-mini">$storageStringUI</div></div>
                </div>
            </div>
            <button class="btn-action-pro" style="animation: pulse-btn 2s infinite; padding: 22px 90px; font-size: 16px; letter-spacing: 1px;" onclick="startDiagnosticHub()">PROCEED TO DIAGNOSTICS</button>
        </div>

        <div id="hw-dashboard" class="dash-grid" style="display: none;">
            <div class="dash-card" onclick="openTest('test-kb')"><h3>Keyboard Core</h3><p>Mechanical Mapping</p><div class="card-status" id="c-stat-kb">PENDING</div></div>
            <div class="dash-card" onclick="openTest('test-sc')"><h3>Display Integrity</h3><p>Pixel Analysis</p><div class="card-status" id="c-stat-sc">PENDING</div></div>
            <div class="dash-card" onclick="openTest('test-au')"><h3>Stereo Engine</h3><p>Acoustic Verification</p><div class="card-status" id="c-stat-au">PENDING</div></div>
            <div class="dash-card" onclick="openTest('test-to')"><h3>Touch Digitizer</h3><p>Matrix Scan</p><div class="card-status" id="c-stat-to">PENDING</div></div>
            <div class="dash-card" onclick="openTest('test-ca')"><h3>Webcam Sensor</h3><p>Visual Stream</p><div class="card-status" id="c-stat-ca">PENDING</div></div>
            <div class="dash-card" onclick="runCmd('BATTERY')" style="border-color:#ff007f;"><h3>Real Battery Drain</h3><p>Offline Video Logger</p><div class="card-status" style="border-color:#ff007f; color:#ff007f;">UTILITY</div></div>
        </div>

        <div id="test-kb" class="test-view">
            <button class="btn-back" onclick="closeTest()">BACK TO DASHBOARD</button>
            <button class="btn-action-pro" style="background:rgba(255,255,255,0.04); color:var(--secondary); border:1px solid var(--secondary); padding:14px 35px; margin-bottom:40px; font-weight:950;" onclick="toggleNumpad()">Enable Extended Numpad</button>
            <div class="kb-frame">
                <div style="display:flex; flex-direction:column; gap:8px;">
                    <div class="kb-row"><div class="key" id="Escape">Esc</div><div class="key" id="F1">F1</div><div class="key" id="F2">F2</div><div class="key" id="F3">F3</div><div class="key" id="F4">F4</div><div class="key" id="F5">F5</div><div class="key" id="F6">F6</div><div class="key" id="F7">F7</div><div class="key" id="F8">F8</div><div class="key" id="F9">F9</div><div class="key" id="F10">F10</div><div class="key" id="F11">F11</div><div class="key" id="F12">F12</div></div>
                    <div class="kb-row"><div class="key" id="Backquote">~</div><div class="key" id="Digit1">1</div><div class="key" id="Digit2">2</div><div class="key" id="Digit3">3</div><div class="key" id="Digit4">4</div><div class="key" id="Digit5">5</div><div class="key" id="Digit6">6</div><div class="key" id="Digit7">7</div><div class="key" id="Digit8">8</div><div class="key" id="Digit9">9</div><div class="key" id="Digit0">0</div><div class="key" id="Minus">-</div><div class="key" id="Equal">=</div><div class="key" style="min-width:82px;" id="Backspace">Back</div></div>
                    <div class="kb-row"><div class="key" style="min-width:70px;" id="Tab">Tab</div><div class="key" id="KeyQ">Q</div><div class="key" id="KeyW">W</div><div class="key" id="KeyE">E</div><div class="key" id="KeyR">R</div><div class="key" id="KeyT">T</div><div class="key" id="KeyY">Y</div><div class="key" id="KeyU">U</div><div class="key" id="KeyI">I</div><div class="key" id="KeyO">O</div><div class="key" id="KeyP">P</div><div class="key" id="BracketLeft">[</div><div class="key" id="BracketRight">]</div><div class="key" id="Backslash">\</div></div>
                    <div class="kb-row"><div class="key" style="min-width:85px;" id="CapsLock">Caps</div><div class="key" id="KeyA">A</div><div class="key" id="KeyS">S</div><div class="key" id="KeyD">D</div><div class="key" id="KeyF">F</div><div class="key" id="KeyG">G</div><div class="key" id="KeyH">H</div><div class="key" id="KeyJ">J</div><div class="key" id="KeyK">K</div><div class="key" id="KeyL">L</div><div class="key" id="Semicolon">;</div><div class="key" id="Quote">'</div><div class="key" style="min-width:100px;" id="Enter">Enter</div></div>
                    <div class="kb-row"><div class="key" style="min-width:115px;" id="ShiftLeft">Shift</div><div class="key" id="KeyZ">Z</div><div class="key" id="KeyX">X</div><div class="key" id="KeyC">C</div><div class="key" id="KeyV">V</div><div class="key" id="KeyB">B</div><div class="key" id="KeyN">N</div><div class="key" id="KeyM">M</div><div class="key" id="Comma">,</div><div class="key" id="Period">.</div><div class="key" id="Slash">/</div><div class="key" style="min-width:115px;" id="ShiftRight">Shift</div></div>
                    <div class="kb-row"><div class="key" style="min-width:62px;" id="ControlLeft">Ctrl</div><div class="key" style="min-width:62px;" id="MetaLeft">Win</div><div class="key" style="min-width:62px;" id="AltLeft">Alt</div><div class="key" style="min-width:320px;" id="Space">Space</div><div class="key" style="min-width:62px;" id="AltRight">Alt</div><div class="key" style="min-width:62px;" id="ControlRight">Ctrl</div></div>
                </div>
                <div class="nav-cluster"><div class="kb-row"><div class="key" id="Insert">Ins</div><div class="key" id="Home">Hm</div><div class="key" id="PageUp">PU</div></div><div class="kb-row"><div class="key" id="Delete">Del</div><div class="key" id="End">End</div><div class="key" id="PageDown">PD</div></div><div class="nav-row-up"><div class="key" id="ArrowUp">Up</div></div><div class="nav-row-bottom"><div class="key" id="ArrowLeft">L</div><div class="key" id="ArrowDown">D</div><div class="key" id="ArrowRight">R</div></div></div>
                <div id="numpad-master" style="display:none; flex-direction:column; gap:8px; border-left:1px solid #333; padding-left:20px;"><div class="kb-row"><div class="key" id="NumLock">N</div><div class="key" id="NumpadDivide">/</div><div class="key" id="NumpadMultiply">*</div></div><div class="kb-row"><div class="key" id="Numpad7">7</div><div class="key" id="Numpad8">8</div><div class="key" id="Numpad9">9</div></div><div class="kb-row"><div class="key" id="Numpad4">4</div><div class="key" id="Numpad5">5</div><div class="key" id="Numpad6">6</div></div><div class="kb-row"><div class="key" id="Numpad1">1</div><div class="key" id="Numpad2">2</div><div class="key" id="Numpad3">3</div></div></div>
            </div>
            <button class="btn-action-pro" onclick="manualKBFinish()">Finalize Keyboard Check</button>
        </div>

        <div id="test-sc" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO DASHBOARD</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px;">Display Integrity Engine</h2><p style="color:#666; margin-bottom:45px;">Execute a 100% surface scan to detect pixel anomalies.</p><button class="btn-action-pro" onclick="startSC()">Initiate Vision Scan</button><div id="scDec" style="display:none; margin-top:45px; border-top:1px solid rgba(255,255,255,0.05); padding-top:40px;"><h3 style="letter-spacing:3px; margin-bottom:30px;">VERIFY DISPLAY QUALITY?</h3><button class="btn-action-pro" style="background:var(--success); padding:20px 50px; margin-right:15px;" onclick="verifySC('OK')">YES - PERFECT</button><button class="btn-action-pro" style="background:var(--error); padding:20px 50px;" onclick="verifySC('X')">NO - DEFECT</button></div></div></div>
        <div id="test-au" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO DASHBOARD</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px;">Stereo Sound Engine</h2><p style="color:#666; margin-bottom:45px;">Verify acoustic channels and crackling distortion.</p><div style="display:flex; gap:15px; justify-content:center; margin-bottom:30px; flex-wrap:wrap;"><button class="btn-action-pro" style="background:#3b82f6; margin-top:0;" onclick="playT(-1)">Left Channel</button><button class="btn-action-pro" style="background:#10b981; margin-top:0;" onclick="playT(1)">Right Channel</button><button class="btn-action-pro" style="background:#f59e0b; margin-top:0;" onclick="playBassSweep()">Crackle/Bass Test</button></div><div style="margin-top:40px; border-top:1px solid rgba(255,255,255,0.05); padding-top:40px;"><h3 style="letter-spacing:3px; margin-bottom:30px;">AUDIO INTEGRITY?</h3><button class="btn-action-pro" style="background:var(--success); padding:20px 50px; margin-right:15px;" onclick="verifyAU('OK')">YES - CLEAR</button><button class="btn-action-pro" style="background:var(--error); padding:20px 50px;" onclick="verifyAU('X')">NO - DEFECT</button></div></div></div>
        <div id="test-to" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO DASHBOARD</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px;">Digitizer Matrix Scanner</h2><p style="color:#666; margin-bottom:45px;">Perform a full coverage sweep of the touch layer.</p><button class="btn-action-pro" onclick="startTO()">Launch Matrix Scan</button></div></div>
        <div id="test-ca" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO DASHBOARD</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px;">Visual Stream Analyzer</h2><button class="btn-action-pro" id="cBtn" onclick="toggleC()" style="margin-top:0;">Open Live Sensor</button><div style="width:100%; border-radius:20px; border:4px solid var(--primary); margin-top:35px; overflow:hidden; background:#000;"><video id="vid" autoplay playsinline style="display:none; width:100%; height:auto;"></video></div><div id="caDec" style="display:none; margin-top:45px;"><h3 style="letter-spacing:2px; margin-bottom:30px;">SENSOR CLARITY OK?</h3><button class="btn-action-pro" style="background:var(--success); padding:20px 50px; margin-right:15px;" onclick="verifyCA('OK')">YES - PERFECT</button><button class="btn-action-pro" style="background:var(--error); padding:20px 50px;" onclick="verifyCA('X')">NO - DEFECT</button></div></div></div>
    </div>

    <div id="tab-stress" class="section">
        <div id="stress-dashboard" class="dash-grid" style="width: 100%; max-width: 1300px;">
            <div class="dash-card" onclick="openTest('test-cpu')" style="border-color:var(--secondary);"><h3 style="color:var(--secondary);">CPU Core Stress</h3><p>Multi-threaded Math Calculations</p><div class="card-status" style="border-color:var(--secondary); color:var(--secondary);">UTILITY</div></div>
            <div class="dash-card" onclick="openTest('test-ram')" style="border-color:var(--success);"><h3 style="color:var(--success);">RAM Memory Load</h3><p>Physical Memory Allocation</p><div class="card-status" style="border-color:var(--success); color:var(--success);">UTILITY</div></div>
            <div class="dash-card" onclick="openTest('test-gpu')" style="border-color:var(--primary);"><h3 style="color:var(--primary);">GPU Render Stress</h3><p>Direct3D Engine Load</p><div class="card-status" style="border-color:var(--primary); color:var(--primary);">UTILITY</div></div>
            <div class="dash-card" onclick="openTest('test-charger')" style="border-color:#f59e0b;"><h3 style="color:#f59e0b;">AC Adapter Test</h3><p>Live Charging Stability</p><div class="card-status" style="border-color:#f59e0b; color:#f59e0b;">UTILITY</div></div>
        </div>

        <div id="stress-status-cards" style="width: 100%; max-width: 1300px; margin-top: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
             <div style="background: rgba(0,0,0,0.3); padding: 20px; border-radius: 15px; border: 1px solid rgba(40, 167, 69, 0.4); text-align: center;"><h4 style="margin: 0 0 10px 0; color: var(--success); text-transform: uppercase; font-size: 13px; letter-spacing: 1px;">Battery Health</h4><span style="font-size: 22px; font-weight: 800; color: #fff;">$batHealth</span></div>
            <div style="background: rgba(0,0,0,0.3); padding: 20px; border-radius: 15px; border: 1px solid rgba(0, 229, 255, 0.4); text-align: center;"><h4 style="margin: 0 0 10px 0; color: var(--secondary); text-transform: uppercase; font-size: 13px; letter-spacing: 1px;">Storage Health</h4><span style="font-size: 22px; font-weight: 800; color: #fff;">$diskHealth</span></div>
            <div style="background: rgba(0,0,0,0.3); padding: 20px; border-radius: 15px; border: 1px solid rgba(245, 158, 11, 0.4); text-align: center;"><h4 style="margin: 0 0 10px 0; color: #f59e0b; text-transform: uppercase; font-size: 13px; letter-spacing: 1px;">Charger (AC)</h4><span style="font-size: 20px; font-weight: 800; color: #fff;">$acStatus</span></div>
        </div>

        <div id="test-cpu" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO STRESS HUB</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px; color:var(--secondary);">CPU (Processor Core Stress)</h2><p style="color:#666; margin-bottom:45px;">Forces all logical cores to 100% via multi-threaded math calculations.</p><div class="btn-grid-container"><button class="btn-grid" onclick="runCmd('CPU_30')">30 Seconds</button><button class="btn-grid" onclick="runCmd('CPU_60')">60 Seconds</button><button class="btn-grid" style="border-color:#ff007f; color:#ff007f;" onclick="runCmd('CPU_INF')">Infinite Load</button></div></div></div>
        <div id="test-ram" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO STRESS HUB</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px; color:var(--success);">RAM (Memory Allocation Load)</h2><p style="color:#666; margin-bottom:45px;">Rapidly allocates large byte arrays to fill up physical memory.</p><div class="btn-grid-container"><button class="btn-grid" onclick="runCmd('RAM_30')">30 Seconds</button><button class="btn-grid" onclick="runCmd('RAM_60')">60 Seconds</button><button class="btn-grid" style="border-color:#ff007f; color:#ff007f;" onclick="runCmd('RAM_INF')">Infinite Load</button></div></div></div>
        <div id="test-gpu" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO STRESS HUB</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px; color:var(--primary);">GPU (Graphics Render Load)</h2><p style="color:#666; margin-bottom:45px;">Initiates Direct3D Engine to stress Dedicated/Integrated Graphics.</p><div class="btn-grid-container"><button class="btn-grid" onclick="runCmd('GPU_30')">30 Seconds</button><button class="btn-grid" onclick="runCmd('GPU_60')">60 Seconds</button><button class="btn-grid" style="border-color:#ff007f; color:#ff007f;" onclick="runCmd('GPU_INF')">Infinite Load</button></div></div></div>
        <div id="test-charger" class="test-view"><button class="btn-back" onclick="closeTest()">BACK TO STRESS HUB</button><div class="test-card-ultimate"><h2 style="margin-bottom:20px; color:#f59e0b;">AC Adapter (Charger Live Test)</h2><p style="color:#666; margin-bottom:45px;">30s CPU Load test to verify charging capacity and stability.</p><div class="btn-grid-container"><button class="btn-grid" style="border-color:#f59e0b; color:#f59e0b;" onclick="runCmd('CHARGER_TEST')">Launch 30s Charger Stress</button></div></div></div>
    </div>

    <div id="tab-win" class="section">
        <div class="test-card-ultimate" style="max-width: 900px; padding: 50px;">
            <h2 style="margin-bottom: 30px; letter-spacing: 2px;">Windows Configuration Engine</h2>
            <button class="btn-hero" onclick="runCmd('AUTOPILOT')">PREPARE FOR SALE (AUTO-PILOT)</button>
            <div class="btn-grid-container">
                <button class="btn-grid" onclick="runCmd('THISPC')">Show This PC Icon</button>
                <button class="btn-grid" onclick="runCmd('HIGHPERF')">High Performance Mode</button>
                <button class="btn-grid" onclick="runCmd('ARABIC')">Arabic + Egypt Region</button>
                <button class="btn-grid" onclick="runCmd('ACTIVATE')">Activate OEM Key</button>
                <button class="btn-grid" onclick="runCmd('BLOAT')">Remove Bloatware</button>
                <button class="btn-grid" onclick="runCmd('BOOST')">Quick Boost & Fix</button>
                <button class="btn-grid" onclick="runCmd('RENAME')">Rename PC & User</button>
                <button class="btn-grid" onclick="runCmd('CLASSIC')">Classic Win11 Menu</button>
                <button class="btn-grid" onclick="runCmd('SAC')">Disable Smart App Control</button>
            </div>
        </div>
    </div>

    <div id="tab-drv" class="section">
        <div class="test-card-ultimate" style="max-width: 900px; padding: 50px;">
            <h2 style="margin-bottom: 30px; letter-spacing: 2px;">Driver Management Center</h2>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;">
                <button class="btn-grid" style="font-size: 15px; padding: 25px; border-color: var(--primary);" onclick="runCmd('DRV_BACKUP')">SMART BACKUP DRIVERS</button>
                <button class="btn-grid" style="font-size: 15px; padding: 25px; border-color: var(--secondary);" onclick="runCmd('DRV_RESTORE')">SMART RESTORE DRIVERS</button>
            </div>
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                <button class="btn-grid" style="background:rgba(0,118,206,0.1); border-color:#0076CE;" onclick="runCmd('OEM_DELL')">Dell Support</button>
                <button class="btn-grid" style="background:rgba(0,150,214,0.1); border-color:#0096D6;" onclick="runCmd('OEM_HP')">HP Support</button>
                <button class="btn-grid" style="background:rgba(226,35,26,0.1); border-color:#E2231A;" onclick="runCmd('OEM_LENOVO')">Lenovo Support</button>
            </div>
        </div>
    </div>

    <div id="tab-sw" class="section">
        <div class="test-card-ultimate" style="max-width: 900px; padding: 50px;">
            <h2 style="margin-bottom: 30px; letter-spacing: 2px;">Software Installation Hub</h2>
            <div class="btn-grid-container">
                <button class="btn-grid" onclick="runCmd('APP_BUNDLE')">Install Essential Apps</button>
                <button class="btn-grid" onclick="runCmd('APP_OFFICE')">Install Office Suite</button>
                <button class="btn-grid" onclick="runCmd('APP_DEFCONT')">Install Defender Control</button>
                <button class="btn-grid" onclick="runCmd('APP_GAMING')">Install Gaming Libraries</button>
            </div>
        </div>
    </div>

    <div id="tab-rep" class="section">
        <div class="test-card-ultimate" style="max-width: 900px; padding: 40px; width: 100%;">
            <h2 style="margin-bottom: 30px; letter-spacing: 2px;">Sales & Reporting Engine</h2>
            
            <div class="input-group">
                <label>Tester Name</label>
                <input type="text" id="testerName" placeholder="Enter your name..." required>
            </div>
            
            <div class="input-group">
                <label>Live System Checks</label>
                <div id="checklistDisplay" class="static-box">Awaiting Test Completion...</div>
            </div>
            
            <div id="clientSection">
                <label style="color: #10b981; margin-bottom: 10px; font-size: 13px;">Customer Details</label>
                <div class="flex-row">
                    <div class="input-group"><input type="text" id="clientName" placeholder="Customer Name"></div>
                    <div class="input-group"><input type="text" id="clientPhone" placeholder="Phone (e.g., 01xxxxxxxxx)"></div>
                </div>
            </div>

            <div id="stockSection">
                <label style="color: #3b82f6; text-align: center; display:block; font-size: 15px; margin-bottom: 10px;">Stock Condition Check</label>
                <div class="btn-group" id="stockButtons">
                    <button class="btn-sales btn-sell" onclick="submitStock('GOOD')">GOOD / PASS</button>
                    <button class="btn-sales btn-issue" onclick="showNotesForIssue()">HAS ISSUES</button>
                </div>
                <div id="stockFeedback" class="status-text" style="display:none;">CONDITION: HAS ISSUES</div>
            </div>

            <div id="notesSection">
                <div class="input-group">
                    <label>Manual Notes / Issues</label>
                    <textarea id="userNotes" rows="3" placeholder="Write observation or problem details here..."></textarea>
                </div>
                <button id="btnSubmitIssue" class="btn-sales btn-issue" style="display:none; width:100%; margin-top:10px;" onclick="submitStock('ISSUE')">CONFIRM & UPLOAD REPORT</button>
            </div>

            <div class="btn-group" id="mainButtons">
                <button id="btnSell" class="btn-sales btn-sell" onclick="handleSell()">SELL TO CUSTOMER</button>
                <button id="btnTest" class="btn-sales btn-test" onclick="handleStock()">STOCK TEST ONLY</button>
            </div>
        </div>
    </div>
</div>

<div id="fs-overlay" style="position:fixed; top:0; left:0; width:100vw; height:100vh; z-index:99999; display:none; cursor:pointer;" onclick="nextC()"></div>

<div id="touch-surface-master" style="position:fixed; top:0; left:0; width:100vw; height:100vh; z-index:99999; display:none; background:#000; touch-action:none; overflow:hidden; font-family:sans-serif;">
    <div id="touch-info" style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); color:#fff; pointer-events:none; text-align:center; mix-blend-mode:difference; z-index:2;">
        <h1 style="font-size:60px; margin:0;">TOUCH TEST</h1>
        <p style="color:#aaa; font-size:20px; margin-top:10px;">Swipe to fill squares</p>
    </div>
    <div id="touch-grid" style="display:grid; grid-template-columns:repeat(20, 1fr); grid-template-rows:repeat(12, 1fr); width:100%; height:100%; z-index:1;"></div>
</div>

<script>
    window.moveTo(0,0); window.resizeTo(screen.availWidth, screen.availHeight);
    const pressedKeys = new Set(); let doneTests = { kb:false, sc:false, au:false, to:false, ca:false }; let stream;
    let diagStarted = false;

    function playQuantumChime() {
        try {
            const ctx = new (window.AudioContext || window.webkitAudioContext)();
            const osc = ctx.createOscillator(); const gain = ctx.createGain();
            osc.type = 'sine'; osc.frequency.setValueAtTime(440, ctx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 1.0);
            gain.gain.setValueAtTime(0, ctx.currentTime);
            gain.gain.linearRampToValueAtTime(0.3, ctx.currentTime + 0.1);
            gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + 1.5);
            osc.connect(gain); gain.connect(ctx.destination);
            osc.start(); osc.stop(ctx.currentTime + 1.5);
        } catch(e) {}
    }
    setTimeout(() => { playQuantumChime(); document.getElementById('splash').style.opacity = '0'; setTimeout(() => document.getElementById('splash').style.display = 'none', 800); }, 3200);

    function startDiagnosticHub() {
        diagStarted = true;
        document.getElementById('welcome-view').style.display = 'none';
        document.getElementById('hw-dashboard').style.display = 'grid';
    }

    function getFullStatusText(id) {
        let st = document.getElementById(id).innerText;
        if(st === 'OK') return 'Passed [OK]';
        if(st === 'X') return 'Failed [X]';
        return 'Pending';
    }

    function updateLiveChecklist() {
        let kb = getFullStatusText('c-stat-kb');
        let sc = getFullStatusText('c-stat-sc');
        let au = getFullStatusText('c-stat-au');
        let to = getFullStatusText('c-stat-to');
        let ca = getFullStatusText('c-stat-ca');
        let res = "Keyboard: " + kb + " | Screen: " + sc + " | Audio: " + au + " | Touch: " + to + " | Camera: " + ca;
        document.getElementById('checklistDisplay').innerText = res;
        return res;
    }

    function switchMainTab(id, el, title) {
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
        document.getElementById(id).classList.add('active'); el.classList.add('active');
        document.getElementById('main-title').innerText = title;
        if(id === 'tab-rep') updateLiveChecklist();
        closeTest();
    }

    function openTest(t) { 
        if(document.getElementById('hw-dashboard')) document.getElementById('hw-dashboard').style.display = 'none';
        if(document.getElementById('stress-dashboard')) {
            document.getElementById('stress-dashboard').style.display = 'none';
            document.getElementById('stress-status-cards').style.display = 'none';
        }
        document.querySelectorAll('.test-view').forEach(v => v.classList.remove('active')); 
        document.getElementById(t).classList.add('active');
    }
    
    function closeTest() { 
        document.querySelectorAll('.test-view').forEach(v => v.classList.remove('active'));
        if (document.getElementById('tab-hw').classList.contains('active')) {
            if (diagStarted) {
                document.getElementById('welcome-view').style.display = 'none';
                document.getElementById('hw-dashboard').style.display = 'grid';
            } else {
                document.getElementById('welcome-view').style.display = 'flex';
                document.getElementById('hw-dashboard').style.display = 'none';
            }
        }
        if (document.getElementById('tab-stress').classList.contains('active')) {
            if(document.getElementById('stress-dashboard')) document.getElementById('stress-dashboard').style.display = 'grid';
            if(document.getElementById('stress-status-cards')) document.getElementById('stress-status-cards').style.display = 'grid';
        }
    }

    function runCmd(actionName) {
        let originalTitle = document.title;
        document.title = "MONTAG_CMD_" + actionName;
        setTimeout(() => { document.title = originalTitle; }, 1500);
    }

    const masterReq = ['F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','Escape','Delete','Insert','Home','PageUp','PageDown','End','Digit1','Digit2','Digit3','Digit4','Digit5','Digit6','Digit7','Digit8','Digit9','Digit0','Minus','Equal','Backspace','KeyQ','KeyW','KeyE','KeyR','KeyT','KeyY','KeyU','KeyI','KeyO','KeyP','BracketLeft','BracketRight','Backslash','KeyA','KeyS','KeyD','KeyF','KeyG','KeyH','KeyJ','KeyK','KeyL','Semicolon','Quote','Enter','KeyZ','KeyX','KeyC','KeyV','KeyB','KeyN','KeyM','Comma','Period','Slash','ShiftLeft','ShiftRight','ControlLeft','ControlRight','AltLeft','AltRight','MetaLeft','Space','ArrowUp','ArrowDown','ArrowLeft','ArrowRight'];
    function checkHubStatus() { if(Object.values(doneTests).every(s => s === true)) { document.getElementById('badge-hw').style.display = 'inline-block'; } }
    
    window.addEventListener('keydown', e => { 
        if(e.code === 'F11') e.preventDefault();
        const k = document.getElementById(e.code); 
        if(k && document.getElementById('test-kb').classList.contains('active')) { 
            e.preventDefault(); 
            k.classList.add('pressed'); 
            pressedKeys.add(e.code); 
            if(masterReq.filter(key => !pressedKeys.has(key)).length === 0) manualKBFinish(); 
        } 
    });

    window.addEventListener('keyup', e => { 
        if(e.code === 'F11') { 
            e.preventDefault();
            const k = document.getElementById(e.code); 
            if(k && document.getElementById('test-kb').classList.contains('active') && !k.classList.contains('pressed')) { 
                k.classList.add('pressed'); 
                pressedKeys.add(e.code); 
                if(masterReq.filter(key => !pressedKeys.has(key)).length === 0) manualKBFinish(); 
            } 
        } 
    });

    function toggleNumpad() { const n = document.getElementById('numpad-master'); n.style.display = (n.style.display === 'none' ? 'flex' : 'none'); }
    function manualKBFinish() { let isOK = masterReq.filter(k => !pressedKeys.has(k)).length === 0; let res = isOK ? "OK" : "X"; document.getElementById('c-stat-kb').innerText = res; document.getElementById('c-stat-kb').className = isOK ? "card-status ok" : "card-status"; doneTests.kb = true; document.title = "MONTAG_KB_" + res; checkHubStatus(); closeTest(); }

    const sCols = ['red','green','blue','white','black']; let sIdx = 0;
    function startSC() { sIdx = 0; const o = document.getElementById('fs-overlay'); o.style.display = 'block'; o.style.background = sCols[0]; o.requestFullscreen(); }
    function nextC() { sIdx++; if(sIdx >= sCols.length) { document.exitFullscreen(); document.getElementById('fs-overlay').style.display = 'none'; document.getElementById('scDec').style.display = 'block'; } else { document.getElementById('fs-overlay').style.background = sCols[sIdx]; } }
    function verifySC(st) { doneTests.sc = true; document.getElementById('scDec').style.display = 'none'; document.getElementById('c-stat-sc').innerText = st; document.getElementById('c-stat-sc').className = st === "OK" ? "card-status ok" : "card-status"; document.title = "MONTAG_SC_" + st; checkHubStatus(); closeTest(); }

    function playT(p) { 
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        const panNode = ctx.createStereoPanner();
        panNode.pan.value = p; panNode.connect(ctx.destination);
        const notes = [523.25, 659.25, 783.99, 1046.50]; 
        let t = ctx.currentTime;
        notes.forEach((freq, i) => {
            const osc = ctx.createOscillator(); const gain = ctx.createGain();
            osc.type = 'sine'; osc.frequency.value = freq;
            gain.gain.setValueAtTime(0, t + (i * 0.15));
            gain.gain.linearRampToValueAtTime(0.4, t + (i * 0.15) + 0.02);
            gain.gain.exponentialRampToValueAtTime(0.001, t + (i * 0.15) + 1.2);
            osc.connect(gain); gain.connect(panNode);
            osc.start(t + (i * 0.15)); osc.stop(t + (i * 0.15) + 1.3);
        });
    }

    function playBassSweep() {
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        const osc = ctx.createOscillator(); const gain = ctx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(20, ctx.currentTime);
        osc.frequency.linearRampToValueAtTime(200, ctx.currentTime + 3);
        gain.gain.setValueAtTime(0.8, ctx.currentTime);
        osc.connect(gain); gain.connect(ctx.destination);
        osc.start(); osc.stop(ctx.currentTime + 3);
    }

    function verifyAU(st) { doneTests.au = true; document.getElementById('c-stat-au').innerText = st; document.getElementById('c-stat-au').className = st === "OK" ? "card-status ok" : "card-status"; document.title = "MONTAG_AU_" + st; checkHubStatus(); closeTest(); }

    function startTO() { 
        const surface = document.getElementById('touch-surface-master');
        const grid = document.getElementById('touch-grid'); 
        surface.style.display = 'block'; grid.innerHTML = ''; 
        let infoH1 = document.querySelector('#touch-info h1');
        if(infoH1) { infoH1.innerText = 'TOUCH TEST'; infoH1.style.color = '#fff'; }
        for(let i=0; i<240; i++) { 
            let cell = document.createElement('div');
            cell.className = 't-cell'; cell.style.border = '1px solid #333'; cell.style.transition = '0s'; grid.appendChild(cell);
        } 
        try { surface.requestFullscreen(); } catch(e){} 
    }

    function actTouch(e) {
        e.preventDefault();
        let t = e.touches || [e];
        for(let i=0; i<t.length; i++) {
            let el = document.elementFromPoint(t[i].clientX, t[i].clientY);
            if(el && el.classList.contains('t-cell') && !el.classList.contains('touched')) {
                el.style.background = '#0f0'; el.style.boxShadow = '0 0 10px #0f0'; el.style.borderColor = '#0f0'; el.classList.add('touched');
            }
        }
        checkTouchComp();
    }

    function checkTouchComp() {
        let t = document.querySelectorAll('.t-cell').length;
        let a = document.querySelectorAll('.touched').length;
        let p = Math.round((a/t)*100);
        let infoH1 = document.querySelector('#touch-info h1');
        if(infoH1) { infoH1.innerText = p + '%'; if(p >= 100) infoH1.style.color = '#0f0'; }
        if(p >= 100) { if(document.fullscreenElement) document.exitFullscreen(); finalizeTouch("OK"); }
    }

    window.addEventListener('touchmove', function(e) { if(document.getElementById('touch-surface-master').style.display === 'block') actTouch(e); }, {passive: false});
    window.addEventListener('mousemove', function(e) { if(document.getElementById('touch-surface-master').style.display === 'block' && e.buttons === 1) actTouch(e); });
    function finalizeTouch(st) { document.getElementById('touch-surface-master').style.display = 'none'; doneTests.to = true; document.getElementById('c-stat-to').innerText = st; document.getElementById('c-stat-to').className = st === "OK" ? "card-status ok" : "card-status"; document.title = "MONTAG_TO_" + st; checkHubStatus(); closeTest(); }
    document.addEventListener('fullscreenchange', () => { if(!document.fullscreenElement && document.getElementById('touch-surface-master').style.display === 'block') { let a = document.querySelectorAll('.touched').length; finalizeTouch(a >= 238 ? "OK" : "X"); } });
    
    async function toggleC() { try { stream = await navigator.mediaDevices.getUserMedia({video:true}); document.getElementById('vid').srcObject = stream; document.getElementById('vid').style.display = 'block'; document.getElementById('caDec').style.display = 'block'; } catch(e) { alert('Lens Sensor Denied.'); } }
    function verifyCA(st) { if(stream) { stream.getTracks().forEach(t => t.stop()); stream = null; } document.getElementById('vid').style.display = 'none'; document.getElementById('caDec').style.display = 'none'; doneTests.ca = true; document.getElementById('c-stat-ca').innerText = st; document.getElementById('c-stat-ca').className = st === "OK" ? "card-status ok" : "card-status"; document.title = "MONTAG_CA_" + st; checkHubStatus(); closeTest(); }

    function handleSell() {
        var section = document.getElementById('clientSection');
        var btn = document.getElementById('btnSell');
        var notes = document.getElementById('notesSection');
        document.getElementById('stockSection').style.display = 'none'; 
        document.getElementById('btnTest').style.display = 'none'; 
        notes.style.display = 'block';
        
        if (section.style.display === 'none' || section.style.display === '') {
            section.style.display = 'block';
            btn.innerText = "CONFIRM & UPLOAD"; btn.className = "btn-sales btn-confirm"; 
            document.getElementById('clientName').focus();
            setTimeout(function() {
                var container = document.getElementById('mainContainer');
                if(container) { container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' }); }
            }, 100);
        } else {
            if (!document.getElementById('clientName').value || !document.getElementById('clientPhone').value) { alert("Please enter Client Details!"); return; }
            sendData('SELL');
        }
    }

    function handleStock() {
        document.getElementById('clientSection').style.display = 'none';
        document.getElementById('notesSection').style.display = 'none';
        document.getElementById('mainButtons').style.display = 'none';
        document.getElementById('stockSection').style.display = 'block';
    }

    function showNotesForIssue() {
        document.getElementById('stockButtons').style.display = 'none';
        document.getElementById('stockFeedback').style.display = 'block';
        document.getElementById('notesSection').style.display = 'block';
        document.getElementById('btnSubmitIssue').style.display = 'block';
        document.getElementById('userNotes').focus();
        setTimeout(function() {
            var container = document.getElementById('mainContainer');
            if(container) { container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' }); }
        }, 100);
    }

    function submitStock(condition) {
        if (condition === 'ISSUE') {
            var notes = document.getElementById('userNotes').value.trim();
            if (notes.length < 5) { alert("Please write details in the NOTES field!"); document.getElementById('userNotes').focus(); return; }
            sendData('TEST-ISSUE');
        } else { sendData('TEST-GOOD'); }
    }

    function sendData(type) {
        var tester = document.getElementById('testerName').value;
        if(!tester) { alert("Tester Name Required!"); return; }
        
        var finalStatus = updateLiveChecklist();
        var userNotes = document.getElementById('userNotes').value.trim();
        var clientInfo = "";
        
        if (type === 'SELL') {
            clientInfo = document.getElementById('clientName').value + " - " + document.getElementById('clientPhone').value;
            if (userNotes) { finalStatus += " | NOTES: " + userNotes; }
        } else {
            if (userNotes) { clientInfo = userNotes; } else { clientInfo = "Stock"; }
        }

        var url = "https://docs.google.com/forms/d/e/$GFormID/formResponse?usp=pp_url";
        url += "&entry.371291262=" + type;
        url += "&entry.392302034=" + encodeURIComponent(tester);
        url += "&entry.517500793=" + encodeURIComponent(clientInfo);
        url += "&entry.531158115=" + encodeURIComponent("$FullModel");
        url += "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)");
        url += "&entry.1462565184=" + encodeURIComponent("$cpuDetails | Temp: $cpuTemp");
        url += "&entry.212987726=" + encodeURIComponent("$ramDetails");
        url += "&entry.1717831234=" + encodeURIComponent("$storageString");
        url += "&entry.2044586469=" + encodeURIComponent("$gpuString | Temp: $gpuTemp");
        url += "&entry.310563239=" + encodeURIComponent(finalStatus);
        
        fetch(url, { mode: 'no-cors' }).then(() => {
            document.getElementById('tab-rep').innerHTML = "<div class='test-card-ultimate' style='max-width: 900px; padding: 40px; width: 100%; text-align:center;'><h1 style='color:var(--secondary); font-size:40px; margin-bottom:20px;'>UPLOAD SUCCESSFUL!</h1><p style='color:#aaa; font-size:16px;'>Data has been saved to the Sales Database.</p><button class='btn-action-pro' onclick='exitHub()'>CLOSE DIAGNOSTIC HUB</button></div>";
        }).catch(e => {
            alert("Upload failed! Please check your internet connection.");
        });
    }

    function exitHub() { document.title = "MONTAG_CMD_EXIT"; setTimeout(() => window.close(), 1500); }
</script>
</body>
</html>
"@
$html | Out-File $GuiFile -Encoding UTF8

Start-Process "msedge" -ArgumentList "--new-window --kiosk --edge-kiosk-type=fullscreen `"$GuiFile`""
Start-Sleep -Seconds 2
while ($true) {
    $activeWins = Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match "MONTAG_" }
    if ($activeWins) {
        foreach ($e in $activeWins) {
            $title = $e.MainWindowTitle
            if ($title -match "MONTAG_KB_") { $title.Split("_")[-1] | Out-File "$env:SystemDrive\MontagTools\kb_status.txt" -Encoding ASCII }
            if ($title -match "MONTAG_SC_") { $title.Split("_")[-1] | Out-File "$env:SystemDrive\MontagTools\sc_status.txt" -Encoding ASCII }
            if ($title -match "MONTAG_AU_") { $title.Split("_")[-1] | Out-File "$env:SystemDrive\MontagTools\au_status.txt" -Encoding ASCII }
            if ($title -match "MONTAG_TO_") { $title.Split("_")[-1] | Out-File "$env:SystemDrive\MontagTools\to_status.txt" -Encoding ASCII }
            if ($title -match "MONTAG_CA_") { $title.Split("_")[-1] | Out-File "$env:SystemDrive\MontagTools\ca_status.txt" -Encoding ASCII }
            if ($title -match "MONTAG_CMD_(.+)") { 
                $cmd = $matches[1]
                if ($cmd -eq "EXIT") { 
                    Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match "MONTAG_" } | Stop-Process -Force -ErrorAction SilentlyContinue
                    break
                }
                Start-Process cmd -ArgumentList "/c `"`"$env:SystemDrive\MontagTools\MontagCore.bat`" CMD_$cmd`"" -WindowStyle Normal
                Start-Sleep -Seconds 2
            }
        }
    }
    if (-not (Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match "MONTAG" })) { break }
    Start-Sleep -Milliseconds 500
}

# --- GENERATE DESKTOP CLIENT REPORT ---
$kb_st = if (Test-Path "$env:SystemDrive\MontagTools\kb_status.txt") { Get-Content "$env:SystemDrive\MontagTools\kb_status.txt" } else { "PENDING" }
$sc_st = if (Test-Path "$env:SystemDrive\MontagTools\sc_status.txt") { Get-Content "$env:SystemDrive\MontagTools\sc_status.txt" } else { "PENDING" }
$au_st = if (Test-Path "$env:SystemDrive\MontagTools\au_status.txt") { Get-Content "$env:SystemDrive\MontagTools\au_status.txt" } else { "PENDING" }
$to_st = if (Test-Path "$env:SystemDrive\MontagTools\to_status.txt") { Get-Content "$env:SystemDrive\MontagTools\to_status.txt" } else { "PENDING" }
$ca_st = if (Test-Path "$env:SystemDrive\MontagTools\ca_status.txt") { Get-Content "$env:SystemDrive\MontagTools\ca_status.txt" } else { "PENDING" }

function Get-FullTextStatus($st) {
    if ($st -match "OK") { return "Passed [OK]" }
    if ($st -match "X") { return "Failed [X]" }
    return "Pending"
}

$FinalStatusLog = "Keyboard: $(Get-FullTextStatus $kb_st) | Screen: $(Get-FullTextStatus $sc_st) | Audio: $(Get-FullTextStatus $au_st) | Touch: $(Get-FullTextStatus $to_st) | Camera: $(Get-FullTextStatus $ca_st)"

$SafeModel = $FullModel -replace '[\\/:*?"<>|]','_'
$DesktopPath = [Environment]::GetFolderPath("Desktop")

# Save to ProgramData to hide it, then create a shortcut on Desktop
$ReportDir = "$env:ProgramData\MontagStore"
if (-not (Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }
$RealHtmlFile = "$ReportDir\Montag_$($bios.SerialNumber).html"
$DesktopShortcut = "$DesktopPath\Report - $SafeModel.url"

$ClientReport = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Montag Store - Premium Report</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;500;800&display=swap" rel="stylesheet">
<style>
    :root { --primary: #8f00ff; --secondary: #00e5ff; --bg: #050505; --card-bg: rgba(15, 15, 20, 0.75); }
    body { font-family: 'Outfit', sans-serif; background-color: var(--bg); color: #fff; margin: 0; padding: 20px; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; overflow-x: hidden; overflow-y: auto; position: relative; z-index: 1; }

    body::before, body::after { content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%; filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate; }
    body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } 
    body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } 
    @keyframes floatOrbs { 0% { transform: translate(0, 0) scale(1); } 100% { transform: translate(5%, 5%) scale(1.15); } }

    .outside-logo { display: flex; justify-content: center; margin-bottom: 15px; z-index: 10; }
    .outside-logo img { height: 200px; filter: drop-shadow(0 0 20px rgba(143, 0, 255, 0.7)); animation: neonPulseTop 1.5s infinite alternate ease-in-out; }
    @keyframes neonPulseTop { 0% { filter: drop-shadow(0 0 10px rgba(143, 0, 255, 0.5)) scale(1); } 100% { filter: drop-shadow(0 0 40px rgba(143, 0, 255, 1)) scale(1.08); } }

    .container { max-width: 780px; width: 100%; background: var(--card-bg); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 20px; padding: 25px 30px; box-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.6); max-height: 85vh; overflow-y: auto; }
    .container::-webkit-scrollbar { width: 8px; }
    .container::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 4px; }
    
    .header { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 15px; margin-bottom: 20px; }
    
    .header img.brand { justify-self: start; height: 110px; width: auto; max-width: 140px; object-fit: contain; filter: drop-shadow(0 0 15px rgba(0, 229, 255, 0.4)); }
    .header .title-box { justify-self: center; text-align: center; }
    .header img.cpu-logo { justify-self: end; height: 80px; width: auto; max-width: 120px; object-fit: contain; filter: drop-shadow(0 0 15px rgba(255, 255, 255, 0.15)); }

    .title-box h1 { margin: 0; font-size: 24px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; letter-spacing: 1px; }
    .title-box p { margin: 5px 0 0 0; color: #a0a0ab; font-size: 13px; letter-spacing: 1px; }

    .specs-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 12px; }
    .spec-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 12px 18px; transition: all 0.3s ease; position: relative; overflow: hidden; border-left: 4px solid var(--primary); }
    .spec-card:hover { transform: translateY(-3px); border-color: rgba(143, 0, 255, 0.5); box-shadow: 0 10px 20px rgba(143, 0, 255, 0.15); background: rgba(255, 255, 255, 0.05); }
    .spec-label { font-size: 11px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; display: block; font-weight: 800; }
    .spec-value { font-size: 15px; font-weight: 500; color: #fff; }
    
    .actions { margin-top: 25px; display: flex; gap: 12px; flex-wrap: wrap; }
    .btn { flex: 1; min-width: 180px; padding: 12px; border: none; border-radius: 8px; font-family: inherit; font-size: 13px; font-weight: 800; cursor: pointer; text-transform: uppercase; transition: all 0.3s ease; text-align: center; text-decoration: none; display: flex; justify-content: center; align-items: center; gap: 10px; }
    .btn-copy { background: rgba(255, 255, 255, 0.1); color: #fff; border: 1px solid rgba(255, 255, 255, 0.2); }
    .btn-copy:hover { background: rgba(255, 255, 255, 0.2); transform: translateY(-2px); }
    .btn-warranty { background: linear-gradient(45deg, #007bff, #00d2ff); color: #fff; box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3); }
    .btn-warranty:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0, 123, 255, 0.5); }
    .btn-whatsapp { background: linear-gradient(45deg, #25D366, #128C7E); color: #fff; box-shadow: 0 5px 15px rgba(37, 211, 102, 0.3); }
    .btn-whatsapp:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(37, 211, 102, 0.5); }
</style>
</head>
<body>

<div class="outside-logo">
    <img src="$LogoMontag" alt="Montag Store">
</div>

<div class="container">
    <div class="header">
        <img src="$BrandLogo" alt="Brand" class="brand">
        <div class="title-box">
            <h1>Device Inspection</h1>
            <p>Tested and Verified By Montag Store</p>
        </div>
        <img src="$CpuLogo" alt="CPU" class="cpu-logo">
    </div>

    <div class="specs-grid" id="specsData">
       
        <div class="spec-card" style="grid-column: 1 / -1; border-color: var(--secondary);">
            <span class="spec-label">Model</span>
            <div class="spec-value" style="font-size: 20px; font-weight: bold;">$FullModel</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Serial Number</span>
            <div class="spec-value" style="color:var(--secondary); font-size: 17px; font-weight:800;">$($bios.SerialNumber)</div>
        </div>
      
        <div class="spec-card">
            <span class="spec-label">Processor (CPU)</span>
            <div class="spec-value">$cpuDetails <br><span style="color:$cpuTempColor; font-size:13px; font-weight:800;">Temp: $cpuTemp</span></div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Graphics (GPU)</span>
            <div class="spec-value">$gpuString <br><span style="color:$gpuTempColor; font-size:13px; font-weight:800;">Temp: $gpuTemp</span></div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Installed RAM</span>
            <div class="spec-value">$ramDetails</div>
        </div>
        <div class="spec-card" style="border-color: #ff007f;">
            <span class="spec-label">Primary Storage</span>
            <div class="spec-value">$storageString</div>
        
        </div>
        <div class="spec-card" style="grid-column: 1 / -1; border-color: #00e5ff;">
            <span class="spec-label" style="color:#00e5ff;">Inspection Checklist / Condition</span>
            <div class="spec-value" style="font-family: monospace; color:#ccc;">$FinalStatusLog</div>
        </div>
    </div>

    <div class="actions">
        <button class="btn btn-copy" onclick="copySpecs(this)">COPY SPECS</button>
        <button class="btn btn-warranty" onclick="handleWarranty(this)">CHECK WARRANTY</button>
        <a href="https://wa.me/$TechNum" target="_blank" class="btn btn-whatsapp">CONTACT SUPPORT</a>
    </div>
</div>

<script>
    window.moveTo(0, 0); window.resizeTo(screen.availWidth, screen.availHeight);

    function forceCopyText(text) {
        var textArea = document.createElement("textarea"); textArea.value = text;
        textArea.style.position = "fixed"; textArea.style.left = "-999999px"; 
 
        document.body.appendChild(textArea); textArea.focus(); textArea.select();
        document.execCommand("copy"); document.body.removeChild(textArea);
    }

    function copySpecs(btn) {
        var textToCopy = "[ Montag Store - Device Specs ]\n\n" +
                         "*Model:* $FullModel\n" +
                         "*Serial:* $($bios.SerialNumber)\n" 
                         +
                         "*CPU:* $cpuDetails | Temp: $cpuTemp\n" +
                         "*RAM:* $ramDetails\n" +
                         "*GPU:* $gpuString | Temp: $gpuTemp\n" +
                         "*Storage:* $storageString\n\n" +
                         "*Status:* $FinalStatusLog\n\n" +
                         "Verified by Montag Store System [OK]";
        forceCopyText(textToCopy);
      
        
        var originalText = btn.innerHTML;
        btn.innerHTML = "Copied to Clipboard! [OK]";
        btn.style.background = "#28a745";
        btn.style.borderColor = "#28a745";
        setTimeout(function() { 
            btn.innerHTML = originalText; 
            btn.style.background = ""; 
            btn.style.borderColor = ""; 
        }, 3000);
    }

    function handleWarranty(btn) {
      
        forceCopyText("$($bios.SerialNumber)");
        var originalText = btn.innerHTML;
        btn.innerHTML = "Serial Copied! Opening...";
        setTimeout(function() { window.open("$WarrantyLink", "_blank"); btn.innerHTML = originalText; }, 800);
    }
</script>
</body>
</html>
"@

$ClientReport | Out-File "$RealHtmlFile" -Encoding UTF8
$ShortcutContent = "[InternetShortcut]`r`nURL=file:///$RealHtmlFile`r`nIconIndex=0`r`nIconFile=$IconPath"
[System.IO.File]::WriteAllText($DesktopShortcut, $ShortcutContent)

# --- CLEANUP ROUTINE ---
Remove-Item -Path "$env:SystemDrive\MontagTools" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemDrive\MontagReports" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemDrive\MontagOffice" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemDrive\MontagBatteryLog.txt" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\Montag*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*status.txt" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\action_report.txt" -Force -ErrorAction SilentlyContinue

exit