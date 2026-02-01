@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [1] VISUAL SETUP (SAFE MODE)
:: ============================================================
:: No Admin Force Loop to prevent crashing
chcp 65001 >nul
color 07
title Montag Store - Enterprise System (V 194.0 Stable)
cls

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

:: Download Icon (Silent)
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
for %%i in (WiFi Key Screen Cam Audio Batt Specs Sensor WinUpd OEM Arab DriverBack DriverRest HighPerf Label WinRAR DefCont Revo Brand Apps Disk Mic Intake Clean Name Warranty Active Bloat Stress) do if not defined mark_%%i set "mark_%%i=   "

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
echo %PAD%    %Bold%%White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%       %Bold%%White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%
echo %PAD%    %Bold%%White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%       %Bold%%White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%
echo %PAD%    %Bold%%White%[5]%Reset% %Cyan%PRINT SPEC LABEL%Reset%
echo.
echo %PAD%%Cyan%--------------------------------------------------------------------------------------------------------%Reset%
echo %PAD%    %Green%[R] FINISH + UPLOAD REPORT%Reset%     %Red%[X] EXIT%Reset%
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> Option:%Reset% 
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
echo %PAD% [1] KEYBOARD      %mark_Key%      [2] SCREEN        %mark_Screen%
echo %PAD% [3] CAMERA        %mark_Cam%      [4] AUDIO         %mark_Audio%
echo %PAD% [5] BATTERY       %mark_Batt%     [6] SENSORS       %mark_Sensor%
echo %PAD% [7] WARRANTY      %mark_Warranty% [8] STRESS TEST   %mark_Stress%
echo.
echo %PAD%                                  %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Yellow%^> Test:%Reset% 
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
echo %PAD%%Red%[STRESS TEST] CPU 100% Load for 60s...%Reset%
powershell -Command "$s=[System.Diagnostics.Stopwatch]::StartNew();$j=@();1..[Environment]::ProcessorCount|%%{$j+=Start-Job -ScriptBlock{$r=1;while($true){$r=$r*1.000001}}};Write-Host 'Running...';while($s.Elapsed.TotalSeconds -lt 60){Start-Sleep 1};$j|Stop-Job|Remove-Job"
set "mark_Stress=[OK]"
goto Menu_Hardware

:CheckWarranty
cls
echo %PAD%Checking Serial...
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_Bios).SerialNumber"`) do set "SN=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-WmiObject Win32_ComputerSystem).Manufacturer"`) do set "MFG=%%a"
echo %PAD%Serial: %SN%
if /i "%MFG%"=="Dell Inc." start "" "https://www.dell.com/support/home/en-us/product-support/servicetag/%SN%/overview"
if /i "%MFG%"=="HP" start "" "https://support.hp.com/us-en/checkwarranty"
if /i "%MFG%"=="Lenovo" start "" "https://pcsupport.lenovo.com/us/en/warrantylookup"
set "mark_Warranty=[OK]"
goto Menu_Hardware

:DownloadAndRun
set "Exe=%ToolDir%\%ExeName%"
if not exist "%ToolDir%" mkdir "%ToolDir%"
if exist "%Exe%" (start "" "%Exe%" & goto ReturnPoint)
echo %PAD%Downloading %ExeName%...
curl -L -k -# -o "%Exe%" "%TargetUrl%"
if exist "%Exe%" (start "" "%Exe%") else (echo %PAD%Failed. & pause)
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
echo %PAD% [1] HIGH PERF     %mark_HighPerf% [2] ARABIC KEY    %mark_Arab%
echo %PAD% [3] WIN UPDATE    %mark_WinUpd%   [4] RENAME PC     %mark_Name%
echo %PAD% [5] ACTIVATE      %mark_Active%   [6] DEBLOAT       %mark_Bloat%
echo.
echo %PAD%                                  %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Yellow%^> Option:%Reset% 
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
echo %PAD%Removing Apps...
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage; Get-AppxPackage *solitaire* | Remove-AppxPackage; Get-AppxPackage *bingweather* | Remove-AppxPackage" >nul 2>&1
set "mark_Bloat=[OK]"
goto Menu_Windows

:ActivateOEM
echo %PAD%Activating...
set "BiosKey="
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "BiosKey=%%a"
if "%BiosKey%"=="" (echo %PAD%No BIOS Key Found. & pause) else (
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %BiosKey%
    cscript //nologo %windir%\system32\slmgr.vbs /ato
    set "mark_Active=[OK]"
    echo %PAD%Done.
    timeout /t 2 >nul
)
goto Menu_Windows

:RenameUser
set "ClientName="
set /p ClientName="%PAD%Client Name: "
if "%ClientName%"=="" goto Menu_Windows
powershell -Command "Rename-Computer -NewName '%ClientName%-PC' -Force -ErrorAction SilentlyContinue"
net user "%USERNAME%" /fullname:"%ClientName%" >nul 2>&1
set "mark_Name=[OK]"
goto Menu_Windows

:AddArabic
powershell -Command "$l=Get-WinUserLanguageList; if($l.LanguageTag -notcontains 'ar-EG'){$l.Add('ar-EG'); Set-WinUserLanguageList $l -Force}"
goto Menu_Windows

:HighPerf
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
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
echo %PAD% [1] BACKUP        %mark_DriverBack% [2] RESTORE       %mark_DriverRest%
echo %PAD% [3] DELL WEB                      [4] HP WEB
echo.
echo %PAD%                                  %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Yellow%^> Option:%Reset% 
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
echo $model = (Get-WmiObject Win32_ComputerSystem).Model.Trim() > "%PSDr%"
echo $drv = Read-Host "Enter Drive (e.g. D)" >> "%PSDr%"
echo $path = "$($drv):\$($model.Replace(' ', '_'))_Drivers" >> "%PSDr%"
echo New-Item -ItemType Directory -Force -Path $path ^| Out-Null >> "%PSDr%"
echo pnputil /export-driver * "$path" >> "%PSDr%"
echo Write-Host "Done." >> "%PSDr%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PSDr%"
del "%PSDr%"
goto Menu_Drivers

:RestoreDrivers
cls
set "PSDr=%TEMP%\DrvRest.ps1"
if exist "%PSDr%" del "%PSDr%"
echo $drv = Read-Host "Source Drive (e.g. D)" > "%PSDr%"
echo $term = Read-Host "Search Model (Enter for Auto)" >> "%PSDr%"
echo if (-not $term) { $term = (Get-WmiObject Win32_ComputerSystem).Model.Trim() } >> "%PSDr%"
echo $p = "$($drv):\*$($term.Replace(' ', '*'))*" >> "%PSDr%"
echo $f = Get-ChildItem -Path $p -Directory -Recurse -ErrorAction SilentlyContinue ^| Select -First 1 >> "%PSDr%"
echo if ($f) { pnputil /add-driver "$($f.FullName)\*.inf" /subdirs /install } else { Write-Host "Not Found" } >> "%PSDr%"
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
echo %PAD% [1] WINRAR        %mark_WinRAR%   [2] DEFENDER CTRL %mark_DefCont%
echo %PAD% [3] REVO UNINST   %mark_Revo%     [4] BASIC APPS    %mark_Apps%
echo.
echo %PAD%                                  %Gray%[0] BACK%Reset%
echo.
echo %PAD%%Yellow%^> Option:%Reset% 
choice /c 12340 /n
if %errorlevel%==5 goto MainMenu
if %errorlevel%==4 goto InstallWingetApps
if %errorlevel%==3 (set "mark_Revo=[OK]" & set "ExeName=Revo.rar" & set "TargetUrl=https://www.dropbox.com/scl/fi/e0x2yjrnhi6qgx9k6ltxg/RevoUninstallerPro5.rar?rlkey=vq4zsk9x1uyco7ratzkhw62f1&st=4f0776fb&dl=1" & goto DownloadAndRun)
if %errorlevel%==2 goto InstallDefControl
if %errorlevel%==1 (set "mark_WinRAR=[OK]" & set "ExeName=WinRAR.exe" & set "TargetUrl=https://www.dropbox.com/scl/fi/w8aw1ymsgtrd4oz46kd8m/winrar-x64-713.exe?rlkey=od8tf0lfmg50a6neh1xc672ja&st=pb6xko3k&dl=1" & goto DownloadAndRun)
goto Menu_Software

:InstallDefControl
cls
echo %PAD%Downloading DefControl...
curl -L -k -# -o "%ToolDir%\DefCont.rar" "https://www.dropbox.com/scl/fi/ek7g511arqlacuf8jblhx/Defender-Control-pass-1.rar?rlkey=wrpduzvs5gynt3nta96xfkxuh&st=369mh2n4&dl=1"
if exist "%ToolDir%\DefCont.rar" (set "mark_DefCont=[OK]" & explorer "%ToolDir%")
goto Menu_Software

:InstallWingetApps
echo %PAD%Installing Apps...
winget install -e --id Google.Chrome
winget install -e --id VideoLAN.VLC
set "mark_Apps=[OK]"
goto Menu_Software

:: ============================================================
:: [5] PRINT LABEL
:: ============================================================
:PrintLabel
cls
echo %PAD%Printing...
set "PSScript=%TEMP%\GenLabel.ps1"
if exist "%PSScript%" del "%PSScript%"
echo $brand="%BrandName%";$sys=(Get-CimInstance Win32_ComputerSystem).Model;$cpu=(Get-CimInstance Win32_Processor).Name.Replace("Intel(R) Core(TM) ","").Replace("CPU @ ","");$ram=[math]::Round((Get-CimInstance Win32_PhysicalMemory^|Measure-Object -Property Capacity -Sum).Sum/1GB);$disk=[math]::Round((Get-CimInstance Win32_DiskDrive^|Select -First 1).Size/1GB);$html="<body style='font-family:Arial;width:70mm;font-size:9pt'><h3 style='text-align:center'>$brand</h3><b>$sys</b><br>$cpu<br><b>RAM: $ram GB | SSD: $disk GB</b><script>window.print()</script></body>";$html^|Out-File "$env:TEMP\Label.html";Start-Process "$env:TEMP\Label.html" > "%PSScript%"
powershell -ExecutionPolicy Bypass -File "%PSScript%"
del "%PSScript%"
goto MainMenu

:: ============================================================
:: REPORT
:: ============================================================
:FinalReport
echo %PAD%Uploading Report...
set /p TesterName="%PAD%Tester Name: "
set "PSScript=%TEMP%\GenReport.ps1"
if exist "%PSScript%" del "%PSScript%"
echo $sys=Get-CimInstance Win32_ComputerSystem;$bios=Get-CimInstance win32_bios;$cpu=Get-CimInstance Win32_Processor;$mem=Get-CimInstance Win32_PhysicalMemory;$body=@{"entry.531158115"=$sys.Model;"entry.1203480099"=$bios.SerialNumber;"entry.392302034"="%TesterName%"};Invoke-WebRequest -Uri "https://docs.google.com/forms/d/e/%GFormID%/formResponse" -Method POST -Body $body -UseBasicParsing > "%PSScript%"
powershell -ExecutionPolicy Bypass -File "%PSScript%"
echo %PAD%Done.
timeout /t 3 >nul
:ExitCleanup
rmdir /s /q "%ToolDir%"
exit
