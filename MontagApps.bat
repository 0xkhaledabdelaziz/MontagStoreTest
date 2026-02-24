<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION
:: ============================================================
chcp 65001 >nul
cd /d "%~dp0"

:: Generate ESC Character for Colors
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "ESC=%%b")

mode con: cols=85 lines=40
title Montag Store - Apps Manager (V 1.4 Stable)
color 0B

set "Args=-e --accept-source-agreements --accept-package-agreements"
set "ToolDir=%SystemDrive%\MontagTools"
if not exist "%ToolDir%" mkdir "%ToolDir%" >nul 2>&1

:: ============================================================
:: [1] APPS MENU
:: ============================================================
:AppsMenu
cls
echo.
echo.
echo       %ESC%[96m █████╗ ██████╗ ██████╗ ███████╗ %ESC%[0m
echo       %ESC%[96m██╔══██╗██╔══██╗██╔══██╗██╔════╝ %ESC%[0m
echo       %ESC%[96m███████║██████╔╝██████╔╝███████╗ %ESC%[0m
echo       %ESC%[96m██╔══██║██╔═══╝ ██╔═══╝ ╚════██║ %ESC%[0m
echo       %ESC%[96m██║  ██║██║     ██║     ███████║ %ESC%[0m
echo       %ESC%[96m╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝ %ESC%[0m
echo.
echo       %ESC%[90m==================================================== %ESC%[0m
echo.
echo       %ESC%[1m[1] %ESC%[0m INSTALL ALL BASIC APPS (BUNDLE)
echo       %ESC%[90m    (Chrome, VLC, WinRAR, AnyDesk, WhatsApp, Zoom) %ESC%[0m
echo.
echo       %ESC%[90m---------------------------------------------------- %ESC%[0m
echo       %ESC%[1m[2] %ESC%[0m Google Chrome        %ESC%[1m[3] %ESC%[0m VLC Player
echo       %ESC%[1m[4] %ESC%[0m WinRAR               %ESC%[1m[5] %ESC%[0m AnyDesk
echo       %ESC%[1m[6] %ESC%[0m WhatsApp             %ESC%[1m[7] %ESC%[0m Zoom
echo       %ESC%[1m[8] %ESC%[0m Brave Browser        %ESC%[1m[9] %ESC%[0m Revo Uninstaller
echo       %ESC%[1m[10]%ESC%[0m Adobe Reader         %ESC%[1m[11]%ESC%[0m 7-Zip
echo       %ESC%[1m[12]%ESC%[0m Notepad++
echo.
echo       %ESC%[1m[0] %ESC%[0m BACK TO MAIN MENU
echo.
echo       %ESC%[90m==================================================== %ESC%[0m
echo.
set "user_choice="
set /p "user_choice=%ESC%[33m> Type a number and press Enter: %ESC%[0m"

if "!user_choice!"=="0" goto CloseScript
if "!user_choice!"=="1" goto InstallAll
if "!user_choice!"=="2" goto InstallChrome
if "!user_choice!"=="3" goto InstallVLC
if "!user_choice!"=="4" goto InstallWinRAR
if "!user_choice!"=="5" goto InstallAnyDesk
if "!user_choice!"=="6" goto InstallWhats
if "!user_choice!"=="7" goto InstallZoom
if "!user_choice!"=="8" goto InstallBrave
if "!user_choice!"=="9" goto InstallRevo
if "!user_choice!"=="10" goto InstallAdobe
if "!user_choice!"=="11" goto Install7Zip
if "!user_choice!"=="12" goto InstallNotepad
goto AppsMenu

:: ============================================================
:: [2] INSTALLERS
:: ============================================================
:InstallAll
cls
echo.
echo  %ESC%[93m[1/6] Installing Chrome... %ESC%[0m
winget install --id Google.Chrome %Args%
echo.
echo  %ESC%[93m[2/6] Installing VLC... %ESC%[0m
winget install --id VideoLAN.VLC %Args%
echo.
echo  %ESC%[93m[3/6] Installing WinRAR... %ESC%[0m
winget install --id RARLab.WinRAR %Args%
echo.
echo  %ESC%[93m[4/6] Installing AnyDesk... %ESC%[0m
winget install --id AnyDeskSoftwareGmbH.AnyDesk %Args%
echo.
echo  %ESC%[93m[5/6] Installing WhatsApp... %ESC%[0m
winget install --id WhatsApp.WhatsApp %Args%
echo.
echo  %ESC%[93m[6/6] Installing Zoom... %ESC%[0m
winget install --id Zoom.Zoom %Args%
echo.
echo  %ESC%[92m[OK] Bundle Installation Complete. %ESC%[0m
pause
goto AppsMenu

:InstallChrome
cls & echo  %ESC%[93mInstalling Google Chrome... %ESC%[0m & winget install --id Google.Chrome %Args% & pause & goto AppsMenu
:InstallVLC
cls & echo  %ESC%[93mInstalling VLC... %ESC%[0m & winget install --id VideoLAN.VLC %Args% & pause & goto AppsMenu
:InstallWinRAR
cls & echo  %ESC%[93mInstalling WinRAR... %ESC%[0m & winget install --id RARLab.WinRAR %Args% & pause & goto AppsMenu
:InstallAnyDesk
cls & echo  %ESC%[93mInstalling AnyDesk... %ESC%[0m & winget install --id AnyDeskSoftwareGmbH.AnyDesk %Args% & pause & goto AppsMenu
:InstallWhats
cls & echo  %ESC%[93mInstalling WhatsApp... %ESC%[0m & winget install --id WhatsApp.WhatsApp %Args% & pause & goto AppsMenu
:InstallZoom
cls & echo  %ESC%[93mInstalling Zoom... %ESC%[0m & winget install --id Zoom.Zoom %Args% & pause & goto AppsMenu
:InstallBrave
cls & echo  %ESC%[93mInstalling Brave... %ESC%[0m & winget install --id BraveSoftware.BraveBrowser %Args% & pause & goto AppsMenu
:InstallAdobe
cls & echo  %ESC%[93mInstalling Adobe Acrobat Reader... %ESC%[0m & winget install --id Adobe.Acrobat.Reader.64-bit %Args% & pause & goto AppsMenu
:Install7Zip
cls & echo  %ESC%[93mInstalling 7-Zip... %ESC%[0m & winget install --id 7zip.7zip %Args% & pause & goto AppsMenu
:InstallNotepad
cls & echo  %ESC%[93mInstalling Notepad++... %ESC%[0m & winget install --id Notepad++.Notepad++ %Args% & pause & goto AppsMenu

:InstallRevo
cls
echo.
echo  %ESC%[93mDownloading Revo Uninstaller Pro... %ESC%[0m
curl -L -k -# -o "%ToolDir%\RevoUninstallerPro5.rar" "https://www.dropbox.com/scl/fi/e0x2yjrnhi6qgx9k6ltxg/RevoUninstallerPro5.rar?rlkey=vq4zsk9x1uyco7ratzkhw62f1&st=1037j19v&dl=1"
if exist "%ToolDir%\RevoUninstallerPro5.rar" (
    echo.
    echo  %ESC%[92m[OK] Download Complete! Opening folder... %ESC%[0m
    explorer "%ToolDir%"
) else (
    echo.
    echo  %ESC%[31m[ERROR] Download failed. Check your internet connection. %ESC%[0m
)
pause
goto AppsMenu

:CloseScript
:: This command ensures we return to the Launcher instead of killing the window
exit /b