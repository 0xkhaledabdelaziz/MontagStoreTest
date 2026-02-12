@echo off
title Montag Label Printer (Standalone)
color 0B
mode con: cols=60 lines=15

:: --- CHECK ADMIN ---
FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit
)

echo.
echo      =========================================
echo           MONTAG STORE - SPEC LABEL PRINT
echo      =========================================
echo.
echo      Generating Label Preview...
echo.

:: --- POWERSHELL LABEL GENERATOR ---
set "LabelScript=%TEMP%\LabelGen.ps1"
(
echo $sys = Get-CimInstance Win32_ComputerSystem
echo $bio = Get-CimInstance Win32_Bios
echo $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory ^| Measure-Object -Property Capacity -Sum^).Sum / 1GB^)
echo $dsk = [math]::Round((Get-CimInstance Win32_DiskDrive ^| Select-Object -First 1^).Size / 1GB^)
echo $gpu = (Get-CimInstance Win32_VideoController ^| Select-Object -ExpandProperty Name -First 1^) -replace "Intel\(R\) ","" -replace "NVIDIA ",""
echo $qr = "https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=$($sys.Model) $($bio.SerialNumber)"
echo $HTML = "<body style='font-family:Arial;width:60mm;text-align:center'><h3>Montag Store</h3><img src='$qr'><br><br><b>$($sys.Model)</b><br>SN: $($bio.SerialNumber)<br><br><b>Specs:</b><br>RAM: $ram GB | SSD: $dsk GB<br>$gpu<script>window.print()</script></body>"
echo $HTML ^| Out-File "$env:TEMP\Label.html"
echo Start-Process "$env:TEMP\Label.html"
) > "%LabelScript%"

powershell -ExecutionPolicy Bypass -File "%LabelScript%"

echo      [OK] Print Dialog Opened.
echo.
echo      Press any key to exit...
pause >nul
del "%LabelScript%" >nul 2>&1
exit