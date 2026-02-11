<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION & CONFIG
:: ============================================================
cd /d "%~dp0"
chcp 65001 >nul
mode con: cols=80 lines=25
title Montag Store - Sales & Finishing System (Purple Logo)
color 0B

:: Google Form ID
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"

:: Paths & URLs
set "IconDir=%ProgramData%\MontagStore"
set "IconPath=%IconDir%\Montag.ico"
set "LogoPath=%IconDir%\Logo.png"
set "SupportNum=201040901444"

:: New Logo URL (Purple)
set "UrlLogo=https://www.dropbox.com/scl/fi/2qv201jvm18n3c971436o/Logo-purple.png?rlkey=b8n5e732fsepkadzg7y10gj1k&st=7q4k6jll&dl=1"

:: --- DOWNLOAD ASSETS (Icon + New Logo) ---
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
if not exist "%LogoPath%" curl -L -k -s -o "%LogoPath%" "%UrlLogo%" >nul 2>&1

:: --- READ STATUS FROM LOG FILE ---
set "LogFile=%SystemDrive%\MontagTools\MontagLog.txt"
set "IncomingLog=Manual Inspection"
if exist "%LogFile%" (set /p IncomingLog=<"%LogFile%")

:: ============================================================
:: [1] APPLY SYSTEM BRANDING
:: ============================================================
cls
echo.
echo      =============================================
echo            MONTAG STORE - FINALIZING SYSTEM       
echo      =============================================
echo.
echo      [1/3] Applying OEM Branding (System Properties)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "Montag Store" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "Certified Refurbished" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /t REG_SZ /d "%SupportNum%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "https://wa.me/%SupportNum%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportHours /t REG_SZ /d "12 PM - 10 PM" /f >nul 2>&1
if exist "%IconPath%" reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Logo /t REG_SZ /d "%IconPath%" /f >nul 2>&1

echo      [2/3] Adding Support to Right-Click Menu...
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /ve /t REG_SZ /d "Contact Montag Support" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /v "Icon" /t REG_SZ /d "%IconPath%" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport\command" /ve /t REG_SZ /d "explorer \"https://wa.me/%SupportNum%\"" /f >nul 2>&1

:: --- EXTRACT REPORT ENGINE ---
set "ReportEngine=%TEMP%\MontagReportEngine.ps1"
if exist "%ReportEngine%" del "%ReportEngine%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__REPORT_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%ReportEngine%"

echo      [3/3] Launching Sales Interface...
echo.
powershell -ExecutionPolicy Bypass -File "%ReportEngine%" -StatusLog "%IncomingLog%" -FormID "%GFormID%" -IconPath "%IconPath%" -LogoPath "%LogoPath%"

exit
:: ============================================================
::  POWERSHELL REPORT ENGINE
:: ============================================================
:::__REPORT_START__:::
param($StatusLog, $FormID, $IconPath, $LogoPath)
$ErrorActionPreference = 'SilentlyContinue'

# --- 1. GATHER SPECS ---
$sys = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor
$bios = Get-CimInstance Win32_Bios

# Model
$Man = $sys.Manufacturer.Trim()
$Mod = $sys.Model.Trim()
if ($Mod.StartsWith($Man)) { $FullModel = $Mod } else { $FullModel = "$Man $Mod" }

# CPU
$maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cacheMB = [int]($cpu.L3CacheSize / 1024)
if ($cacheMB -eq 0) { $cacheMB = [int]($cpu.L2CacheSize / 1024) }
$cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz | $cacheMB MB Cache"

# RAM
$mem = Get-CimInstance Win32_PhysicalMemory
$memArray = @($mem)
$stickCount = $memArray.Count
$totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramSpeed = 0
foreach ($s in $memArray) { if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } }
if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" }
$ramDetails = "$totalRam GB ($stickCount Sticks) @ $ramSpeed MHz"

# Storage
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { 
    ($_.MediaType -eq 'Fixed hard disk media') -and 
    ($_.InterfaceType -ne 'USB') -and 
    ($_.PNPDeviceID -notmatch 'USBSTOR') -and
    ($_.Model -notmatch 'USB')
}
$diskList = @()
foreach ($d in $disks) { $s = [math]::Round($d.Size / 1GB, 0); $diskList += "$($d.Model) ($s GB)" }
if ($diskList.Count -eq 0) { $storageString = "No Internal Disk Detected" } else { $storageString = $diskList -join " | " }

# GPU
$gpuList = @()
$regBase = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
Get-ChildItem $regBase -ErrorAction SilentlyContinue | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath
    if ($props.DriverDesc) {
        $size = 0
        if ($props.'HardwareInformation.QwMemorySize') { $size = $props.'HardwareInformation.QwMemorySize' }
        elseif ($props.'HardwareInformation.MemorySize') { $size = $props.'HardwareInformation.MemorySize' }
        $gb = [math]::Round($size / 1GB)
        if ($gb -gt 0) { $gpuList += "$($props.DriverDesc) ($gb GB)" } else { $gpuList += $props.DriverDesc }
    }
}
$gpuString = ($gpuList | Select-Object -Unique) -join " + "

# --- FIXED LOGO LOGIC START ---
$LaptopLogo = "https://cdn-icons-png.flaticon.com/512/900/900782.png"
$WarrantyLink = "https://www.google.com/search?q=$($bios.SerialNumber)+warranty"

if ($Man -match "Dell") { 
    $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Dell_Logo.svg/1024px-Dell_Logo.svg.png"
    $WarrantyLink = "https://www.dell.com/support/home/en-us/product-support/servicetag/$($bios.SerialNumber)/overview"
}
elseif ($Man -match "HP" -or $Man -match "Hewlett") { 
    $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/HP_logo_2012.svg/1024px-HP_logo_2012.svg.png" 
    $WarrantyLink = "https://support.hp.com/us-en/checkwarranty"
}
elseif ($Man -match "Lenovo") { 
    # Updated Link for Stability
    $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Lenovo_logo_2015.svg/1280px-Lenovo_logo_2015.svg.png" 
    $WarrantyLink = "https://pcsupport.lenovo.com/us/en/warrantylookup"
}
elseif ($Man -match "Microsoft" -or $Man -match "Surface") {
    $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Microsoft_logo_%282012%29.svg/1024px-Microsoft_logo_%282012%29.svg.png"
    $WarrantyLink = "https://mybusinessservice.surface.com/en-US/CheckWarranty/CheckWarranty"
}
# --- FIXED LOGO LOGIC END ---

# --- 2. GENERATE HTML UI (SALES INTERFACE) ---
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Montag Sales</title>
<link rel="icon" type="image/x-icon" href="$IconPath">
<style>
    @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
    body { background-color: #050505; color: #8f00ff; font-family: 'Share Tech Mono', monospace; text-align: center; padding: 20px; }
    .container { max-width: 700px; margin: auto; background: rgba(20, 20, 20, 0.95); padding: 30px; border: 1px solid #333; box-shadow: 0 0 30px rgba(143, 0, 255, 0.2); border-radius: 10px; }
    .header { font-size: 36px; font-weight: bold; text-shadow: 2px 2px 0px #ff00ff; margin-bottom: 25px; color: #fff; letter-spacing: 2px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; text-align: left; margin-bottom: 25px; }
    .card { background: #111; border: 1px solid #444; padding: 12px; border-left: 4px solid #8f00ff; border-radius: 4px; }
    .card h4 { margin: 0 0 5px 0; color: #888; font-size: 12px; letter-spacing: 1px; }
    .card p { margin: 0; font-size: 13px; color: #fff; font-weight: bold; word-wrap: break-word; }
    .input-section { text-align: left; margin-bottom: 20px; }
    label { display: block; color: #fff; margin-bottom: 8px; font-size: 14px; }
    input, textarea { width: 95%; padding: 12px; background: #000; border: 1px solid #555; color: #00ff00; font-family: inherit; font-size: 16px; border-radius: 4px; outline: none; transition: 0.3s; }
    input:focus, textarea:focus { border-color: #8f00ff; box-shadow: 0 0 8px rgba(143, 0, 255, 0.3); }
    #clientSection { display: none; background: rgba(0, 255, 0, 0.05); padding: 20px; border: 1px dashed #00ff00; border-radius: 8px; margin-bottom: 25px; }
    .btn-group { display: flex; gap: 15px; margin-top: 10px; }
    button { flex: 1; padding: 18px; font-size: 18px; font-family: inherit; font-weight: bold; border: none; cursor: pointer; color: #fff; text-transform: uppercase; border-radius: 6px; transition: 0.2s; }
    .btn-sell { background: #28a745; box-shadow: 0 4px 0 #1e7e34; }
    .btn-test { background: #17a2b8; box-shadow: 0 4px 0 #117a8b; }
    .btn-confirm { background: #d63384; box-shadow: 0 4px 0 #a61e61; animation: pulse 1.5s infinite; }
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.02); } 100% { transform: scale(1); } }
</style>
</head>
<body>
    <div class="container">
        <div class="header">MONTAG STORE SYSTEM</div>
        <div class="input-section"><label>TESTER NAME:</label><input type="text" id="testerName" placeholder="Who are you?" required></div>
        <div class="info-grid">
            <div class="card"><h4>MODEL</h4><p>$FullModel</p></div>
            <div class="card"><h4>SERIAL</h4><p>$($bios.SerialNumber)</p></div>
            <div class="card"><h4>PROCESSOR</h4><p>$cpuDetails</p></div>
            <div class="card"><h4>GRAPHICS</h4><p>$gpuString</p></div>
            <div class="card"><h4>MEMORY</h4><p>$ramDetails</p></div>
            <div class="card"><h4>STORAGE</h4><p>$storageString</p></div>
        </div>
        <div id="clientSection">
            <div class="input-section"><label style="color: #00ff00;">CLIENT NAME:</label><input type="text" id="clientName" placeholder="Customer Name"></div>
            <div class="input-section"><label style="color: #00ff00;">PHONE NUMBER:</label><input type="text" id="clientPhone" placeholder="01xxxxxxxxx"></div>
        </div>
        <div class="input-section"><label>NOTES / LOGS:</label><textarea id="status" rows="2">$StatusLog</textarea></div>
        <div class="btn-group">
            <button id="btnSell" class="btn-sell" onclick="handleSell()">SELL (Customer)</button>
            <button id="btnTest" class="btn-test" onclick="sendData('TEST')">TEST (Stock)</button>
        </div>
    </div>
    <script>
        function handleSell() {
            var section = document.getElementById('clientSection');
            var btn = document.getElementById('btnSell');
            if (section.style.display === 'none' || section.style.display === '') {
                section.style.display = 'block';
                btn.innerText = "CONFIRM & UPLOAD"; btn.className = "btn-confirm"; document.getElementById('clientName').focus();
            } else {
                if (!document.getElementById('clientName').value || !document.getElementById('clientPhone').value) { alert("Enter Client Details!"); return; }
                sendData('SELL');
            }
        }
        function sendData(type) {
            var tester = document.getElementById('testerName').value;
            if (!tester) { alert("Enter Tester Name!"); return; }
            var clientInfo = (type === 'SELL') ? document.getElementById('clientName').value + " - " + document.getElementById('clientPhone').value : "Stock";
            var url = "https://docs.google.com/forms/d/e/$FormID/formResponse?usp=pp_url&entry.371291262=" + type + "&entry.392302034=" + encodeURIComponent(tester) + "&entry.517500793=" + encodeURIComponent(clientInfo) + "&entry.531158115=" + encodeURIComponent("$FullModel") + "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)") + "&entry.1462565184=" + encodeURIComponent("$cpuDetails") + "&entry.212987726=" + encodeURIComponent("$ramDetails") + "&entry.1717831234=" + encodeURIComponent("$storageString") + "&entry.2044586469=" + encodeURIComponent("$gpuString") + "&entry.310563239=" + encodeURIComponent(document.getElementById('status').value);
            fetch(url, { mode: 'no-cors' }).then(function() {
                document.body.innerHTML = "<h1 style='color:#0f0;margin-top:20%'>UPLOAD SUCCESSFUL!</h1><p style='color:#fff'>Saving Report to C:\\MontagReports...</p>";
                setTimeout(() => { window.close(); }, 2500);
            });
        }
    </script>
</body>
</html>
"@
$htmlContent | Out-File "$env:TEMP\MontagSales.html" -Encoding UTF8
Start-Process "$env:TEMP\MontagSales.html"

# --- 3. GENERATE CLIENT REPORT HTML (SAFE SAVE TO C:) ---
$ReportDir = "C:\MontagReports"
if (-not (Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }

# This file stays hidden in C:
$RealHtmlFile = "$ReportDir\Montag_$($bios.SerialNumber).html"

# SANITIZE MODEL NAME
$SafeModel = $FullModel -replace '[\\/:*?"<>|]',' '
$DesktopShortcut = "$env:USERPROFILE\Desktop\Report - $SafeModel.url"

# IMPORTANT: Increased Both Logos Sizes
$ClientReport = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Montag Report - $($bios.SerialNumber)</title>
<link rel="icon" type="image/x-icon" href="$IconPath">
<style>
body { font-family: 'Segoe UI', sans-serif; background: #f4f4f9; padding: 40px; }
.container { max-width: 700px; margin: auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
.header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
.brand-logo { height: 100px; width: auto; } /* Montag Logo */
.laptop-logo { height: 90px; width: auto; } /* Laptop Brand Logo (Increased to 90px) */
.specs-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
.specs-table td { padding: 12px; border-bottom: 1px solid #eee; }
.specs-table td:first-child { font-weight: bold; color: #666; width: 140px; }
.btn-group { display: flex; gap: 10px; margin-top: 20px; }
.btn { flex: 1; text-align: center; color: #fff; padding: 12px; text-decoration: none; border-radius: 6px; font-weight: bold; }
.btn-warranty { background: #007bff; }
.btn-warranty:hover { background: #0056b3; }
.btn-support { background: #25D366; } 
.btn-support:hover { background: #128C7E; }
.footer { margin-top: 30px; font-size: 12px; color: #999; text-align: center; }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <img src="$LogoPath" class="brand-logo" alt="Montag Store">
        <img src="$LaptopLogo" class="laptop-logo" alt="$Man">
    </div>
    <table class="specs-table">
        <tr><td>Model</td><td>$FullModel</td></tr>
        <tr><td>Serial</td><td>$($bios.SerialNumber)</td></tr>
        <tr><td>Processor</td><td>$cpuDetails</td></tr>
        <tr><td>RAM</td><td>$ramDetails</td></tr>
        <tr><td>Storage</td><td>$storageString</td></tr>
        <tr><td>Graphics</td><td>$gpuString</td></tr>
        <tr><td>Checklist</td><td>$StatusLog</td></tr>
    </table>
    
    <div class="btn-group">
        <a href="$WarrantyLink" target="_blank" class="btn btn-warranty">CHECK WARRANTY</a>
        <a href="https://wa.me/201040901444" target="_blank" class="btn btn-support">CONTACT SUPPORT</a>
    </div>

    <div class="footer">Generated by Montag Store System</div>
</div>
</body>
</html>
"@
$ClientReport | Out-File "$RealHtmlFile" -Encoding UTF8

# --- CREATE SHORTCUT ON DESKTOP ---
$ShortcutContent = "[InternetShortcut]`r`nURL=file:///$RealHtmlFile`r`nIconIndex=0`r`nIconFile=$IconPath"
$ShortcutContent | Out-File "$DesktopShortcut" -Encoding UTF8