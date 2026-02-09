<# :
@echo off
setlocal EnableDelayedExpansion
title Montag Store - Office Module (V 1.0)
color 0F

:: ============================================================
:: [0] PREPARATION & ADMIN CHECK
:: ============================================================
cd /d "%~dp0"
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: Whitelist Temp Folder
if not exist "%SystemDrive%\MontagOffice" mkdir "%SystemDrive%\MontagOffice" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemDrive%\MontagOffice'" >nul 2>&1

:: --- EXTRACT POWERSHELL ENGINE ---
set "EngineScript=%TEMP%\MontagOfficeEngine.ps1"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__POWERSHELL_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [1] OFFICE MENU
:: ============================================================
:OfficeMenu
cls
echo.
echo      [ MONTAG STORE - OFFICE MANAGER ]
echo.
echo      [1] INSTALL FROM USB (OFFLINE)      ^<-- Scans all drives for 'Office\Setup.exe'
echo      [2] INSTALL OFFICE 2019 (ONLINE)    ^<-- Stable Download (Egypt Fix)
echo      [3] INSTALL OFFICE 2021 (ONLINE)    ^<-- Latest Version (Egypt Fix)
echo.
echo      [4] FORCE UNINSTALL (DEEP CLEAN)    ^<-- Removes old traces
echo.
echo      [0] EXIT
echo.
set /p "choice=^> Select Option: "

if "%choice%"=="0" exit
if "%choice%"=="4" goto Uninstall
if "%choice%"=="3" set "Ver=2021" & goto InstallOnline
if "%choice%"=="2" set "Ver=2019" & goto InstallOnline
if "%choice%"=="1" goto InstallOffline
goto OfficeMenu

:: ============================================================
:: [2] EXECUTION LOGIC
:: ============================================================
:InstallOffline
cls
echo.
echo      [!] SEARCHING FOR OFFLINE INSTALLER...
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOffline"
echo.
pause
goto OfficeMenu

:InstallOnline
cls
echo.
echo      [!] STARTING DOWNLOAD ENGINE (%Ver%)...
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOnline" -Version "%Ver%"
echo.
pause
goto OfficeMenu

:Uninstall
cls
echo.
echo      [!] STARTING NUCLEAR CLEANER...
echo      --------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "NukeOffice"
echo.
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

# --- 1. OFFLINE INSTALLER (USB HUNTER) ---
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

# --- 3. UNINSTALLER (NUCLEAR) ---
if ($Task -eq 'NukeOffice') {
    Write-Host "   [1/2] Stopping Services..." -ForegroundColor Yellow
    Get-Process "WINWORD","EXCEL","POWERPNT","OUTLOOK","OFFICECLICKTORUN" -ErrorAction SilentlyContinue | Stop-Process -Force

    $c2r = "${env:ProgramFiles}\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
    if (Test-Path $c2r) {
        Write-Host "   [2/2] Running Microsoft Force Uninstall..." -ForegroundColor Green
        Start-Process -FilePath $c2r -ArgumentList "/origin7 /forceuninstall" -Wait 
    } else {
        Write-Host "   [!] Native tool not found. Cleaning Registry..." -ForegroundColor Red
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Host "   [OK] Cleaned." -ForegroundColor Green
}