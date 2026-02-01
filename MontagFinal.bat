@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [1] VISUAL SETUP (TEST V2)
:: ============================================================
chcp 65001 >nul
mode con: cols=150 lines=60
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d 1 /f >nul 2>&1

title Montag Store - Visual Test V2
color 07

:: ============================================================
:: [2] COLORS
:: ============================================================
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

:: ============================================================
:: [3] MAIN MENU (SAFE LOGO)
:: ============================================================
cls
echo.
echo %PAD%%Pink% __  __  ____  _   _  _____  ____   _____  _____  ____  _____  _____ %Reset%
echo %PAD%%Pink%|  \/  |/ __ \| \ | ||_   _|/ __ \ / ____|/ ____||_  _||_   _||_   _|%Reset%
echo %PAD%%Pink%| \  / | |  | |  \| |  | | | |  | | |  __| (___    ||    | |    | |  %Reset%
echo %PAD%%Pink%| |\/| | |  | | . ` |  | | | |  | | | |_ |\___ \   ||    | |    | |  %Reset%
echo %PAD%%Pink%| |  | | |__| | |\  |  | | | |__| | |__| |____) | _||_  _| |_  _| |_ %Reset%
echo %PAD%%Pink%|_|  |_|\____/|_| \_|  |_|  \____/ \_____|_____/ |____||_____||_____|%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%    %Bold%%White%[1]%Reset% %Cyan%HARDWARE TESTS%Reset%      %Gray%(Key/Screen)%Reset%            %Bold%%White%[2]%Reset% %Cyan%WINDOWS SETUP%Reset%       %Gray%(Perf/Name)%Reset%
echo.
echo %PAD%    %Bold%%White%[3]%Reset% %Cyan%DRIVERS CENTER%Reset%      %Gray%(Back/Rest)%Reset%             %Bold%%White%[4]%Reset% %Cyan%SOFTWARE HUB%Reset%        %Gray%(Apps/Winget)%Reset%
echo.
echo %PAD%    %Bold%%White%[5]%Reset% %Cyan%PRINT SPEC LABEL%Reset%    %Gray%(ZPL/Side)%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%           %Green%[R] FINISH + UPLOAD REPORT%Reset%                       %Red%[X] EXIT + WIPE CACHE%Reset%
echo.
echo %PAD%%Cyan%========================================================================================================%Reset%
echo.
echo %PAD%%Yellow%^> VISUAL TEST V2. PRESS ANY KEY...%Reset% 
pause >nul
exit
