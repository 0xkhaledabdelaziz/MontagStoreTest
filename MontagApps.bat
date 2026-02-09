<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION
:: ============================================================
chcp 65001 >nul
cd /d "%~dp0"
mode con: cols=80 lines=40
title Montag Store - Apps Manager (V 1.2 Stable Fix)
color 0B

set "Args=-e --accept-source-agreements --accept-package-agreements"

:: ============================================================
:: [1] APPS MENU
:: ============================================================
:AppsMenu
cls
echo.
echo.
echo      [96m █████╗ ██████╗ ██████╗ ███████╗[0m
echo      [96m██╔══██╗██╔══██╗██╔══██╗██╔════╝[0m
echo      [96m███████║██████╔╝██████╔╝███████╗[0m
echo      [96m██╔══██║██╔═══╝ ██╔═══╝ ╚════██║[0m
echo      [96m██║  ██║██║     ██║     ███████║[0m
echo      [96m╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝[0m
echo.
echo      [90m==========================================[0m
echo.
echo      [1m[1][0m INSTALL ALL BASIC APPS (BUNDLE)
echo      [90m    (Chrome, VLC, WinRAR, AnyDesk, WhatsApp, Zoom)[0m
echo.
echo      [90m------------------------------------------[0m
echo      [1m[2][0m Google Chrome       [1m[3][0m VLC Player
echo      [1m[4][0m WinRAR              [1m[5][0m AnyDesk
echo      [1m[6][0m WhatsApp            [1m[7][0m Zoom
echo      [1m[8][0m Brave Browser
echo.
echo      [1m[0][0m BACK TO MAIN MENU
echo.
echo      [90m==========================================[0m
echo.
echo      [33m^> Press a number...[0m

:: Choice Logic
choice /c 123456780 /n

:: Errorlevel 9 corresponds to '0' because it's the 9th character
if %errorlevel%==9 goto CloseScript
if %errorlevel%==8 goto InstallBrave
if %errorlevel%==7 goto InstallZoom
if %errorlevel%==6 goto InstallWhats
if %errorlevel%==5 goto InstallAnyDesk
if %errorlevel%==4 goto InstallWinRAR
if %errorlevel%==3 goto InstallVLC
if %errorlevel%==2 goto InstallChrome
if %errorlevel%==1 goto InstallAll

:: ============================================================
:: [2] INSTALLERS
:: ============================================================
:InstallAll
cls
echo.
echo [93m[1/6] Installing Chrome...[0m
winget install --id Google.Chrome %Args%
echo.
echo [93m[2/6] Installing VLC...[0m
winget install --id VideoLAN.VLC %Args%
echo.
echo [93m[3/6] Installing WinRAR...[0m
winget install --id RARLab.WinRAR %Args%
echo.
echo [93m[4/6] Installing AnyDesk...[0m
winget install --id AnyDeskSoftwareEvents.AnyDesk %Args%
echo.
echo [93m[5/6] Installing WhatsApp...[0m
winget install --id WhatsApp.WhatsApp %Args%
echo.
echo [93m[6/6] Installing Zoom...[0m
winget install --id Zoom.Zoom %Args%
echo.
echo [92m[OK] Bundle Installation Complete.[0m
pause
goto AppsMenu

:InstallChrome
cls & echo [93mInstalling Google Chrome...[0m & winget install --id Google.Chrome %Args% & pause & goto AppsMenu
:InstallVLC
cls & echo [93mInstalling VLC...[0m & winget install --id VideoLAN.VLC %Args% & pause & goto AppsMenu
:InstallWinRAR
cls & echo [93mInstalling WinRAR...[0m & winget install --id RARLab.WinRAR %Args% & pause & goto AppsMenu
:InstallAnyDesk
cls & echo [93mInstalling AnyDesk...[0m & winget install --id AnyDeskSoftwareEvents.AnyDesk %Args% & pause & goto AppsMenu
:InstallWhats
cls & echo [93mInstalling WhatsApp...[0m & winget install --id WhatsApp.WhatsApp %Args% & pause & goto AppsMenu
:InstallZoom
cls & echo [93mInstalling Zoom...[0m & winget install --id Zoom.Zoom %Args% & pause & goto AppsMenu
:InstallBrave
cls & echo [93mInstalling Brave...[0m & winget install --id Brave.Brave %Args% & pause & goto AppsMenu

:CloseScript
:: This command ensures we return to the Launcher instead of killing the window
exit /b