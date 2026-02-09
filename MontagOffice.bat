<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION
:: ============================================================
:: Force UTF-8 for the Logo
chcp 65001 >nul
cd /d "%~dp0"

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
echo      [96m ██████╗ ███████╗███████╗██╗ ██████╗███████╗[0m
echo      [96m██╔═══██╗██╔════╝██╔════╝██║██╔════╝██╔════╝[0m
echo      [96m██║   ██║█████╗  █████╗  ██║██║     █████╗  [0m
echo      [96m██║   ██║██╔══╝  ██╔══╝  ██║██║     ██╔══╝  [0m
echo      [96m╚██████╔╝██║     ██║     ██║╚██████╗███████╗[0m
echo      [96m ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚══════╝[0m
echo.
echo      [90m====================================================[0m
echo.
echo      [1m[1][0m INSTALL FROM USB (OFFLINE)
echo      [90m    (Auto-scans all drives for 'Office\Setup.exe')[0m
echo.
echo      [1m[2][0m DOWNLOAD OFFICE 2019 (ONLINE)
echo      [90m    (Work In Progress - Coming Soon)[0m
echo.
echo      [31m[3] FORCE UNINSTALL (NUCLEAR)[0m
echo      [90m    (Removes Registry, Files and Services)[0m
echo.
echo      [1m[0][0m EXIT
echo.
echo      [90m====================================================[0m
echo.
echo      [33m^> Press a number...[0m

choice /c 1230 /n

if %errorlevel%==4 exit
if %errorlevel%==3 goto Uninstall
if %errorlevel%==2 goto InstallOnline
if %errorlevel%==1 goto InstallOffline

:: ============================================================
:: [2] FUNCTIONS
:: ============================================================
:InstallOffline
cls
echo.
echo      [33m[!] SEARCHING DRIVES...[0m
echo      -----------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "InstallOffline"
echo.
pause
goto MainMenu

:InstallOnline
cls
echo.
echo.
echo      [93m[!] SORRY, THIS FEATURE IS UNDER MAINTENANCE.[0m
echo.
echo      Please use the Offline (USB) method for now.
echo      We are updating the servers for better stability.
echo.
echo      [90m(Feature disabled temporarily)[0m
echo.
pause
goto MainMenu

:Uninstall
cls
echo.
echo      [31m[!] STARTING DEEP CLEAN...[0m
echo      --------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%EngineScript%" -Task "NukeOffice"
echo.
echo      [32m[OK] System Cleaned.[0m
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