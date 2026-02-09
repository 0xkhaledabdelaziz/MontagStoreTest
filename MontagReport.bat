<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREP & ARGS
:: ============================================================
chcp 65001 >nul
cd /d "%~dp0"
mode con: cols=100 lines=30
title Montag Store - Report Generator
color 0B

:: Receive Status Log from Main Script
set "IncomingLog=%~1"
if "%IncomingLog%"=="" set "IncomingLog=Manual Run - No Data"

set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"

:: --- EXTRACT REPORT ENGINE ---
set "ReportEngine=%TEMP%\MontagReportEngine.ps1"
if exist "%ReportEngine%" del "%ReportEngine%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__REPORT_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%ReportEngine%"

:: ============================================================
:: [1] GENERATE REPORT
:: ============================================================
cls
echo.
echo      [96m=============================================[0m
echo      [97m        GENERATING SYSTEM REPORT...          [0m
echo      [96m=============================================[0m
echo.
echo      [93m[!] Gathering Hardware IDs...[0m
echo      [93m[!] Analyzing Performance...[0m
echo      [93m[!] Preparing Google Form...[0m
echo.

powershell -ExecutionPolicy Bypass -File "%ReportEngine%" -StatusLog "%IncomingLog%" -FormID "%GFormID%"

echo.
echo      [92m[OK] Report Interface Closed.[0m
timeout /t 2 >nul
exit /b

:: ============================================================
::  POWERSHELL REPORT ENGINE
:: ============================================================
:::__REPORT_START__:::
param($StatusLog, $FormID)
$ErrorActionPreference = 'SilentlyContinue'

# --- GATHER SPECS ---
$sys = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_Bios
$cpu = Get-CimInstance Win32_Processor
$mem = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$ram = [math]::Round($mem.Sum / 1GB, 1)
$dsk = [math]::Round((Get-CimInstance Win32_DiskDrive | Select-Object -First 1).Size / 1GB)
$gpu = Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name -First 1
$FullModel = "$($sys.Manufacturer) $($sys.Model)".Trim()
$cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores"
$ramDetails = "$ram GB"
$storageString = "$($dsk) GB"
$gpuString = "$gpu"

# --- GENERATE HTML UI ---
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Montag Store System</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
    body { background-color: #050505; color: #8f00ff; font-family: 'Share Tech Mono', monospace; text-align: center; padding: 20px; overflow-x: hidden; 
           background-image: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06)); background-size: 100% 2px, 3px 100%; }
    .container { max-width: 700px; margin: auto; background: rgba(20, 20, 20, 0.9); padding: 30px; border: 1px solid #333; box-shadow: 0 0 20px rgba(143, 0, 255, 0.2); border-radius: 10px; position: relative; }
    .glitch-header { font-size: 40px; font-weight: bold; text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff; letter-spacing: 3px; margin-bottom: 20px; animation: glitch 1s infinite alternate; color: #fff; }
    @keyframes glitch { 0% { text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff; } 100% { text-shadow: -2px -2px 0px #ff00ff, 2px 2px 0px #00ffff; } }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; text-align: left; direction: ltr; margin-bottom: 20px; }
    .card { background: #111; border: 1px solid #8f00ff; padding: 15px; border-radius: 5px; box-shadow: inset 0 0 10px rgba(143, 0, 255, 0.1); transition: 0.3s; }
    .card:hover { transform: translateY(-3px); box-shadow: 0 0 15px rgba(143, 0, 255, 0.4); }
    .card h4 { margin: 0 0 5px 0; color: #fff; font-size: 14px; text-transform: uppercase; border-bottom: 1px solid #444; padding-bottom: 5px; }
    .card p { margin: 0; font-size: 13px; color: #ccc; word-wrap: break-word; }
    .input-group { margin-bottom: 20px; text-align: left; }
    label { display: block; color: #fff; margin-bottom: 5px; font-size: 18px; }
    input, textarea { width: 95%; padding: 15px; background: #000; border: 2px solid #444; color: #8f00ff; font-family: inherit; font-size: 16px; border-radius: 5px; outline: none; transition: 0.3s; }
    input:focus, textarea:focus { border-color: #8f00ff; box-shadow: 0 0 10px #8f00ff; }
    .btn-group { display: flex; gap: 20px; }
    button { flex: 1; padding: 20px; font-size: 20px; font-family: inherit; font-weight: bold; border: none; cursor: pointer; color: #fff; text-transform: uppercase; border-radius: 5px; position: relative; overflow: hidden; transition: 0.3s; }
    .btn-sell { background: linear-gradient(45deg, #1e7e34, #28a745); box-shadow: 0 5px 0 #155724; }
    .btn-test { background: linear-gradient(45deg, #117a8b, #17a2b8); box-shadow: 0 5px 0 #0f6674; }
    button:active { transform: translateY(4px); box-shadow: none; }
    button:hover { filter: brightness(1.2); }
</style>
</head>
<body>
    <div class="container">
        <div class="glitch-header">MONTAG STORE REPORT</div>
        <div class="input-group">
            <label>TESTER NAME:</label>
            <input type="text" id="testerName" placeholder="Type your name here..." autofocus required>
        </div>
        <div class="info-grid">
            <div class="card"><h4>MODEL</h4><p>$FullModel</p></div>
            <div class="card"><h4>SERIAL</h4><p>$($bios.SerialNumber)</p></div>
            <div class="card"><h4>CPU</h4><p>$cpuDetails</p></div>
            <div class="card"><h4>RAM</h4><p>$ramDetails</p></div>
            <div class="card"><h4>GRAPHICS</h4><p>$gpuString</p></div>
            <div class="card"><h4>STORAGE</h4><p>$storageString</p></div>
        </div>
        <div class="input-group">
            <label>INSPECTION LOGS (STATUS):</label>
            <textarea id="status" rows="2">$StatusLog</textarea>
        </div>
        <div class="btn-group">
            <button class="btn-sell" onclick="sendData('SELL')">SELL (CUSTOMER)</button>
            <button class="btn-test" onclick="sendData('TEST')">TEST (STOCK)</button>
        </div>
    </div>
    <script>
        function sendData(type) {
            var testerRaw = document.getElementById('testerName').value;
            var statusRaw = document.getElementById('status').value;
            if (testerRaw.trim() === "") { alert("Please enter tester name first!"); return; }
            
            var mergedTesterName = testerRaw + " - " + type;
            var baseURL = "https://docs.google.com/forms/d/e/$FormID/formResponse?usp=pp_url";
            var finalURL = baseURL + 
                "&entry.371291262=" + type +
                "&entry.392302034=" + encodeURIComponent(mergedTesterName) +
                "&entry.531158115=" + encodeURIComponent("$FullModel") +
                "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)") +
                "&entry.1462565184=" + encodeURIComponent("$cpuDetails") +
                "&entry.212987726=" + encodeURIComponent("$ramDetails") +
                "&entry.1717831234=" + encodeURIComponent("$storageString") +
                "&entry.2044586469=" + encodeURIComponent("$gpuString") +
                "&entry.310563239=" + encodeURIComponent(statusRaw);
            
            fetch(finalURL, { mode: 'no-cors' });
            setTimeout(function(){ window.close(); }, 1000);
        }
    </script>
</body>
</html>
"@
$htmlContent | Out-File "$env:TEMP\SystemReport.html" -Encoding UTF8
Start-Process "$env:TEMP\SystemReport.html"