<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION & ADMIN CHECK
:: ============================================================
cd /d "%~dp0"
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: Whitelist Temp Folder & Visuals
if not exist "%SystemDrive%\MontagOffice" mkdir "%SystemDrive%\MontagOffice" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemDrive%\MontagOffice'" >nul 2>&1
mode con: cols=120 lines=40
title Montag Store - Office Specialist (V 2.0)
color 0B

:: --- EXTRACT POWERSHELL ENGINE ---
set "EngineScript=%TEMP%\MontagOfficeEngine.ps1"
if exist "%EngineScript%" del "%EngineScript%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__POWERSHELL_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [1] OFFICE MENU (INSTANT SELECT)
:: ============================================================
:OfficeMenu
cls
echo.
echo  [95m███╗   ███╗ ██████╗ ███╗   ██╗████████╗ █████╗  ██████╗      ██████╗ ███████╗███████╗██╗ ██████╗███████╗[0m
echo  [95m████╗ ████║██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔════╝     ██╔═══██╗██╔════╝██╔════╝██║██╔════╝██╔════╝[0m
echo  [95m██╔████╔██║██║   ██║██╔██╗ ██║   ██║   ███████║██║  ███╗    ██║   ██║█████╗  █████╗  ██║██║     █████╗  [0m
echo  [95m██║╚██╔╝██║██║   ██║██║╚██╗██║   ██║   ██╔══██║██║   ██║    ██║   ██║██╔══╝  ██╔══╝  ██║██║     ██╔══╝  [0m
echo  [95m██║ ╚═╝ ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝    ╚██████╔╝██║     ██║     ██║╚██████╗███████╗[0m
echo  [95m╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚══════╝[0m
echo.
echo  [36m========================================================================================================[0m
echo.
echo      [1m[1][0m INSTALL FROM USB (OFFLINE)      [90m<-- Scans all drives for 'Office\Setup.exe'[0m
echo.
echo      [1m[2][0m INSTALL OFFICE 2019 (ONLINE)    [90m<-- Stable Download (Egypt Fix)[0m
echo      [1m[3][0m INSTALL OFFICE 2021 (ONLINE)    [90m<-- Latest Version (Egypt Fix)[0m
echo.
echo      [31m[4] FORCE UNINSTALL (DEEP CLEAN)[0m    [90m<-- Removes Roots (Registry/Files)[0m
echo.
echo      [1m[0][0m EXIT
echo.
echo  [36m========================================================================================================[0m
echo.
echo  [33m^> Press a number to start immediately...[0m

:: THIS COMMAND REMOVES THE NEED FOR ENTER
choice /c 12340 /n

if %errorlevel%==5 exit
if %errorlevel%==4 goto Uninstall
if %errorlevel%==3 set "Ver=2021" & goto InstallOnline
if %errorlevel%==2 set "Ver=2019" & goto InstallOnline
if %errorlevel%==1 goto InstallOffline

:: ============================================================
:: [2] EXECUTION LOGIC
:: ============================================================
:InstallOffline
cls
echo.
echo      [33m[!] SEARCHING FOR OFFLINE INSTALLER...[0m
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOffline"
echo.
echo      [32m[OK] Job Finished.[0m
pause
goto OfficeMenu

:InstallOnline
cls
echo.
echo      [33m[!] STARTING DOWNLOAD ENGINE (%Ver%)...[0m
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOnline" -Version "%Ver%"
echo.
echo      [32m[OK] Job Finished.[0m
pause
goto OfficeMenu

:Uninstall
cls
echo.
echo      [31m[!] STARTING NUCLEAR CLEANER...[0m
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "NukeOffice"
echo.
echo      [32m[OK] Office has been removed from roots.[0m
pause
goto OfficeMenu

:: ============================================================
::  POWERSHELL ENGINE (THE BRAIN)
:: ============================================================
:::__POWERSHELL_START__:::
param($Task, $Version)
$ErrorActionPreference = 'SilentlyContinue'
$WorkDir = "$env:SystemDrive\MontagOffice"
if (!(Test-Path $WorkDir)) { New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null }

# --- 1. OFFLINE INSTALLER (USB HUNTER) - UNTOUCHED AS REQUESTED ---
if ($Task -eq 'InstallOffline') {
    Write-Host "   [1/2] Scanning Drives (D: to Z:)..." -ForegroundColor Cyan
    $Drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[D-Z]$' }
    $Found = $false
    
    foreach ($d in $Drives) {
        $TestPath = "$($d.Root)Office\Setup.exe"
        if (Test-Path $TestPath) {
            Write-Host "   [OK] Found Installer at: $TestPath" -ForegroundColor Green
            Write-Host "   [2/2] Launching Setup..." -ForegroundColor Yellow
            Start-Process -FilePath $TestPath -Wait
            $Found = $true
            break
        }
    }
    
    if (-not $Found) {
        Write-Host "   [ERROR] 'Office\Setup.exe' not found on any USB/Drive." -ForegroundColor Red
    } else {
        Write-Host "   [SUCCESS] Installation Finished." -ForegroundColor Green
    }
}

# --- 2. ONLINE INSTALLER (SMART ODT) ---
if ($Task -eq 'InstallOnline') {
    $OdtPath = "$WorkDir\odt.exe"
    $SetupPath = "$WorkDir\setup.exe"
    
    # Download ODT if missing
    if (!(Test-Path $SetupPath)) {
        Write-Host "   [1/3] Downloading ODT Tool..." -ForegroundColor Cyan
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $WebClient = New-Object System.Net.WebClient
            $WebClient.Headers.Add("User-Agent", "Mozilla/5.0")
            # Official Microsoft LinkID for ODT
            $WebClient.DownloadFile("https://go.microsoft.com/fwlink/p/?LinkID=626065", $OdtPath)
            
            Write-Host "   [2/3] Extracting..." -ForegroundColor Yellow
            $proc = Start-Process -FilePath $OdtPath -ArgumentList "/quiet /extract:`"$WorkDir`"" -Wait -PassThru
        } catch {
            Write-Host "   [!] Download Failed. Check Internet." -ForegroundColor Red; return
        }
    }

    if (!(Test-Path $SetupPath)) { Write-Host "   [ERROR] Setup.exe extraction failed." -ForegroundColor Red; return }

    # Create Config
    Write-Host "   [3/3] Installing Office $Version (Please Wait)..." -ForegroundColor Green
    $PIDKey = if ($Version -eq "2019") { "ProPlus2019Volume" } else { "ProPlus2021Volume" }
    $ChnKey = if ($Version -eq "2019") { "PerpetualVL2019" } else { "PerpetualVL2021" }
    
    $ConfigContent = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="$ChnKey">
    <Product ID="$PIDKey">
      <Language ID="en-us" />
      <ExcludeApp ID="Lync" />
    </Product>
  </Add>
  <Display Level="Full" AcceptEULA="TRUE" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
</Configuration>
"@
    [IO.File]::WriteAllText("$WorkDir\config.xml", $ConfigContent)
    
    # Run Install
    Start-Process -FilePath $SetupPath -ArgumentList "/configure `"$WorkDir\config.xml`"" -Wait
    Write-Host "   [DONE] Installation Cycle Complete." -ForegroundColor Green
}

# --- 3. UNINSTALLER (NUCLEAR CLEAN) ---
if ($Task -eq 'NukeOffice') {
    Write-Host "   [1/4] Stopping Office Services..." -ForegroundColor Yellow
    Get-Process "WINWORD","EXCEL","POWERPNT","OUTLOOK","OFFICECLICKTORUN","ONENOTE","MSACCESS" -ErrorAction SilentlyContinue | Stop-Process -Force

    Write-Host "   [2/4] Running Microsoft Force Uninstall..." -ForegroundColor Cyan
    $c2r = "${env:ProgramFiles}\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
    if (Test-Path $c2r) {
        Start-Process -FilePath $c2r -ArgumentList "/origin7 /forceuninstall" -Wait 
    }

    Write-Host "   [3/4] Cleaning Registry (Roots)..." -ForegroundColor Magenta
    # Clean 64-bit keys
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform" -Recurse -Force -ErrorAction SilentlyContinue
    # Clean 32-bit keys (Wow6432Node)
    Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "   [4/4] Removing Files..." -ForegroundColor Magenta
    Remove-Item -Path "${env:ProgramFiles}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramFiles(x86)}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramData}\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "   [SUCCESS] System Cleaned Successfully." -ForegroundColor Green
}