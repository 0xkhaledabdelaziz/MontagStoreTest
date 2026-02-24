<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION
:: ============================================================
:: Force UTF-8 for the Logo
chcp 65001 >nul
cd /d "%~dp0"

:: Generate ESC Character for Colors
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")

:: Admin Check
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

:: Setup Folders
set "WorkDir=%SystemDrive%\MontagOffice"
if not exist "%WorkDir%" mkdir "%WorkDir%" >nul 2>&1
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%WorkDir%'" >nul 2>&1

mode con: cols=100 lines=35
title Montag Store - Office Module (V 3.6 Stable)
color 0B

:: --- EXTRACT POWERSHELL ENGINE ---
set "EngineScript=%TEMP%\MontagOfficeEngine.ps1"
if exist "%EngineScript%" del "%EngineScript%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__POWERSHELL_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%EngineScript%"

:: ============================================================
:: [1] MAIN MENU
:: ============================================================
:MainMenu
cls
echo.
echo.
echo       %ESC%[96m ██████╗ ███████╗███████╗██╗ ██████╗███████╗ %ESC%[0m
echo       %ESC%[96m██╔═══██╗██╔════╝██╔════╝██║██╔════╝██╔════╝ %ESC%[0m
echo       %ESC%[96m██║   ██║█████╗  █████╗  ██║██║     █████╗   %ESC%[0m
echo       %ESC%[96m██║   ██║██╔══╝  ██╔══╝  ██║██║     ██╔══╝   %ESC%[0m
echo       %ESC%[96m╚██████╔╝██║     ██║     ██║╚██████╗███████╗ %ESC%[0m
echo       %ESC%[96m ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚══════╝ %ESC%[0m
echo.
echo       %ESC%[90m==================================================== %ESC%[0m
echo.
echo       %ESC%[1m[1] %ESC%[0m INSTALL FROM USB (OFFLINE)
echo       %ESC%[90m    (Auto-scans all drives for 'Office\Setup.exe') %ESC%[0m
echo.
echo       %ESC%[1m[2] %ESC%[0m DOWNLOAD OFFICE 2019 (ONLINE)
echo       %ESC%[90m    (Work In Progress - Coming Soon) %ESC%[0m
echo.
echo       %ESC%[31m[3] FORCE UNINSTALL (NUCLEAR) %ESC%[0m
echo       %ESC%[90m    (Removes Registry, Files and Services) %ESC%[0m
echo.
echo       %ESC%[92m[4] ACTIVATE (Office ^& Windows) %ESC%[0m
echo       %ESC%[90m    (Download and run MAS Activator) %ESC%[0m
echo.
echo       %ESC%[1m[0] %ESC%[0m EXIT
echo.
echo       %ESC%[90m==================================================== %ESC%[0m
echo.
echo       %ESC%[33m^> Press a number... %ESC%[0m

choice /c 12340 /n

if %errorlevel%==5 exit
if %errorlevel%==4 goto Activate
if %errorlevel%==3 goto Uninstall
if %errorlevel%==2 goto InstallOnline
if %errorlevel%==1 goto InstallOffline

:: ============================================================
:: [2] FUNCTIONS
:: ============================================================
:InstallOffline
cls
echo.
echo       %ESC%[33m[!] SEARCHING DRIVES... %ESC%[0m
echo      -----------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOffline"
echo.
pause
goto MainMenu

:InstallOnline
cls
echo.
echo.
echo       %ESC%[93m[!] SORRY, THIS FEATURE IS UNDER MAINTENANCE. %ESC%[0m
echo.
echo      Please use the Offline (USB) method for now.
echo      We are updating the servers for better stability.
echo.
echo       %ESC%[90m(Feature disabled temporarily) %ESC%[0m
echo.
pause
goto MainMenu

:Uninstall
cls
echo.
echo       %ESC%[31m[!] STARTING DEEP CLEAN... %ESC%[0m
echo      --------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "NukeOffice"
echo.
echo       %ESC%[32m[OK] System Cleaned. %ESC%[0m
pause
goto MainMenu

:Activate
cls
echo.
echo       %ESC%[92m[!] DOWNLOADING AND LAUNCHING ACTIVATOR... %ESC%[0m
echo      --------------------------------------------
set "MASPath=%WorkDir%\MAS_AIO.cmd"
:: Using dl=1 to ensure direct download
curl -L -k -# -o "!MASPath!" "https://www.dropbox.com/scl/fi/cnj7x4fp8zqksmeewhsmg/MAS_AIO.cmd?rlkey=1zr26qvm9l7r26iaw52czjmt9&st=2ivywsiz&dl=1"
if exist "!MASPath!" (
    echo.
    echo       %ESC%[92m[OK] Launching MAS... Please follow the prompt. %ESC%[0m
    start /wait "" "!MASPath!"
) else (
    echo.
    echo       %ESC%[31m[ERROR] Download failed. Check your internet connection. %ESC%[0m
)
echo.
pause
goto MainMenu

:: ============================================================
::  POWERSHELL ENGINE
:: ============================================================
:::__POWERSHELL_START__:::
param($Task)
$ErrorActionPreference = 'SilentlyContinue'
$WorkDir = "$env:SystemDrive\MontagOffice"

# --- 1. OFFLINE ---
if ($Task -eq 'InstallOffline') {
    Write-Host "   Scanning..." -ForegroundColor Cyan
    $Drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[D-Z]$' }
    $Found = $false
    foreach ($d in $Drives) {
        $TestPath = "$($d.Root)Office\Setup.exe"
        if (Test-Path $TestPath) {
            Write-Host "   [FOUND] $TestPath" -ForegroundColor Green
            Write-Host "   Launching..." -ForegroundColor Yellow
            Start-Process -FilePath $TestPath -Wait
        
            $Found = $true; break
        }
    }
    if (-not $Found) { Write-Host "   [ERROR] 'Office\Setup.exe' not found on any drive." -ForegroundColor Red }
}

# --- 3. NUCLEAR UNINSTALL ---
if ($Task -eq 'NukeOffice') {
    Write-Host "   [1/3] Killing Services..." -ForegroundColor Yellow
    Get-Process "WINWORD","EXCEL","POWERPNT","OUTLOOK","OFFICECLICKTORUN","MSACCESS" -ErrorAction SilentlyContinue | Stop-Process -Force

    Write-Host "   [2/3] Registry Sweep..." -ForegroundColor Cyan
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "   [3/3] File Sweep..." -ForegroundColor Cyan
    Remove-Item -Path "${env:ProgramFiles}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramFiles(x86)}\Microsoft Office" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "${env:ProgramData}\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
}