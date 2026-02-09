<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] FIX ENCODING & ADMIN
:: ============================================================
:: Force UTF-8 for the Block Logo
chcp 65001 >nul
cd /d "%~dp0"

FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: Whitelist Temp Folder & Visuals
if not exist "%SystemDrive%\MontagOffice" mkdir "%SystemDrive%\MontagOffice" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemDrive%\MontagOffice'" >nul 2>&1

mode con: cols=110 lines=35
title Montag Store - Office Module (V 2.2 Rebranded)
color 0B

:: --- EXTRACT POWERSHELL ENGINE ---
set "EngineScript=%TEMP%\MontagOfficeEngine.ps1"
if exist "%EngineScript%" del "%EngineScript%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__POWERSHELL_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [1] OFFICE MENU (NEW LOGO - INSTANT ACTION)
:: ============================================================
:OfficeMenu
cls
echo.
echo.
echo      [95m ██████╗ ███████╗███████╗██╗ ██████╗███████╗[0m
echo      [95m██╔═══██╗██╔════╝██╔════╝██║██╔════╝██╔════╝[0m
echo      [95m██║   ██║█████╗  █████╗  ██║██║     █████╗  [0m
echo      [95m██║   ██║██╔══╝  ██╔══╝  ██║██║     ██╔══╝  [0m
echo      [95m╚██████╔╝██║     ██║     ██║╚██████╗███████╗[0m
echo      [95m ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚══════╝[0m
echo.
echo      [36m=======================================================[0m
echo.
echo      [1m[1][0m INSTALL FROM USB (OFFLINE)
echo.
echo      [1m[2][0m INSTALL OFFICE 2019 (ONLINE)
echo      [1m[3][0m INSTALL OFFICE 2021 (ONLINE)
echo.
echo      [31m[4] FORCE UNINSTALL (NUCLEAR)[0m
echo.
echo      [1m[0][0m EXIT
echo.
echo      [36m=======================================================[0m
echo.
echo      [33m^> Press a number (No Enter needed)...[0m

:: Choice command for Instant Action
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
echo      [33m[!] SEARCHING DRIVES FOR OFFICE SETUP...[0m
echo      ----------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOffline"
echo.
echo      [32m[OK] Process Finished.[0m
pause
goto OfficeMenu

:InstallOnline
cls
echo.
echo      [33m[!] STARTING DOWNLOAD ENGINE (OFFICE %Ver%)...[0m
echo      ----------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOnline" -Version "%Ver%"
echo.
echo      [32m[OK] Process Finished.[0m
pause
goto OfficeMenu

:Uninstall
cls
echo.
echo      [31m[!] STARTING NUCLEAR CLEANER...[0m
echo      ----------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "NukeOffice"
echo.
echo      [32m[OK] Cleanup Finished.[0m
pause
goto OfficeMenu

:: ============================================================
::  POWERSHELL ENGINE
:: ============================================================
:::__POWERSHELL_START__:::
param($Task, $Version)
$ErrorActionPreference = 'SilentlyContinue'
$WorkDir = "$env:SystemDrive\MontagOffice"
if (!(Test-Path $WorkDir)) { New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null }

# --- 1. OFFLINE ---
if ($Task -eq 'InstallOffline') {
    Write-Host "   [1/2] Scanning all drives..." -ForegroundColor Cyan
    $Drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[D-Z]$' }
    $Found = $false
    foreach ($d in $Drives) {
        $TestPath = "$($d.Root)Office\Setup.exe"
        if (Test-Path $TestPath) {
            Write-Host "   [OK] Found at: $TestPath" -ForegroundColor Green
            Write-Host "   [2/2] Launching..." -ForegroundColor Yellow
            Start-Process -FilePath $TestPath -Wait
            $Found = $true; break
        }
    }
    if (-not $Found) { Write-Host "   [!] 'Office\Setup.exe' not found on any drive." -ForegroundColor Red }
}

# --- 2. ONLINE (ODT) ---
if ($Task -eq 'InstallOnline') {
    $OdtPath = "$WorkDir\odt.exe"; $SetupPath = "$WorkDir\setup.exe"
    if (!(Test-Path $SetupPath)) {
        Write-Host "   [1/3] Downloading Tool..." -ForegroundColor Cyan
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $WebClient = New-Object System.Net.WebClient
            $WebClient.Headers.Add("User-Agent", "Mozilla/5.0")
            $WebClient.DownloadFile("https://go.microsoft.com/fwlink/p/?LinkID=626065", $OdtPath)
            Write-Host "   [2/3] Extracting..." -ForegroundColor Yellow
            Start-Process -FilePath $OdtPath -ArgumentList "/quiet /extract:`"$WorkDir`"" -Wait
        } catch { Write-Host "   [!] Internet/Download Error." -ForegroundColor Red; return }
    }
    Write-Host "   [3/3] Installing Office $Version..." -ForegroundColor Green
    $PIDKey = if($Version -eq "2019"){"ProPlus2019Volume"}else{"ProPlus2021Volume"}
    $ChnKey = if($Version -eq "2019"){"PerpetualVL2019"}else{"PerpetualVL2021"}
    $XML = "<Configuration><Add OfficeClientEdition='64' Channel='$ChnKey'><Product ID='$PIDKey'><Language ID='en-us'/><ExcludeApp ID='Lync'/></Product></Add><Display Level='Full' AcceptEULA='TRUE'/><Property Name='FORCEAPPSHUTDOWN' Value='TRUE'/></Configuration>"
    [IO.File]::WriteAllText("$WorkDir\config.xml", $XML)
    Start-Process -FilePath $SetupPath -ArgumentList "/configure `"$WorkDir\config.xml`"" -Wait
}

# --- 3. NUKE ---
if ($Task -eq 'NukeOffice') {
    Write-Host "   [1/3] Killing Apps..." -ForegroundColor Yellow
    Get-Process "WINWORD","EXCEL","POWERPNT","OUTLOOK","OFFICECLICKTORUN" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "   [2/3] Removing Files..." -ForegroundColor Magenta
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramFiles}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramFiles(x86)}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "   [OK] Cleaned." -ForegroundColor Green
}