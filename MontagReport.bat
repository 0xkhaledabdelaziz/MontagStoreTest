<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] PREPARATION & CONFIG
:: ============================================================
cd /d "%~dp0"
chcp 437 >nul
mode con: cols=80 lines=25
title Montag Store - Sales Report System (Final Fix)
color 0B

:: Receive Status Log from Main Script
set "IncomingLog=%~1"
if "%IncomingLog%"=="" set "IncomingLog=Manual Inspection"

:: Google Form ID
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
echo      =============================================
echo            MONTAG STORE - SYSTEM REPORT           
echo      =============================================
echo.
echo      [!] Filtering Internal Storage (No USB)...
echo      [!] Analyzing RAM Speed & Modules...
echo      [!] Detecting CPU Cores & Cache...
echo      [!] Launching Sales Interface...
echo.

powershell -ExecutionPolicy Bypass -File "%ReportEngine%" -StatusLog "%IncomingLog%" -FormID "%GFormID%"

exit
:: ============================================================
::  POWERSHELL REPORT ENGINE
:: ============================================================
:::__REPORT_START__:::
param($StatusLog, $FormID)
$ErrorActionPreference = 'SilentlyContinue'

# --- 1. GATHER SPECS ---
$sys = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor
$bios = Get-CimInstance Win32_Bios

# Model
$Man = $sys.Manufacturer.Trim()
$Mod = $sys.Model.Trim()
if ($Mod.StartsWith($Man)) { $FullModel = $Mod } else { $FullModel = "$Man $Mod" }

# CPU (Full Details)
$maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cacheMB = [int]($cpu.L3CacheSize / 1024)
if ($cacheMB -eq 0) { $cacheMB = [int]($cpu.L2CacheSize / 1024) }
$cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz | $cacheMB MB Cache"

# RAM (Speed + Capacity)
$mem = Get-CimInstance Win32_PhysicalMemory
$memArray = @($mem)
$stickCount = $memArray.Count
$totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramSpeed = 0
foreach ($s in $memArray) { 
    if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } 
}
if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" }
$ramDetails = "$totalRam GB ($stickCount Sticks) @ $ramSpeed MHz"

# Storage (STRICT FILTER: No USB / No External / Fixed Only)
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { 
    ($_.MediaType -like '*Fixed*') -and 
    ($_.InterfaceType -notmatch 'USB') -and 
    ($_.PNPDeviceID -notmatch 'USBSTOR') -and
    ($_.Model -notmatch 'USB') -and
    ($_.Model -notmatch 'Card')
}
$diskList = @()
foreach ($d in $disks) { 
    $s = [math]::Round($d.Size / 1GB, 0)
    $diskList += "$($d.Model) ($s GB)" 
}
if ($diskList.Count -eq 0) { 
    $storageString = "No Internal Disk Detected" 
} else {
    $storageString = $diskList -join " | "
}

# GPU (Registry Deep Scan + WMI Fallback)
$gpuList = @()
$regBase = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
$regKeys = Get-ChildItem $regBase -ErrorAction SilentlyContinue
if ($regKeys) {
    $regKeys | ForEach-Object {
        $props = Get-ItemProperty $_.PSPath
        if ($props.DriverDesc) {
            $size = 0
            if ($props.'HardwareInformation.QwMemorySize') { $size = $props.'HardwareInformation.QwMemorySize' }
            elseif ($props.'HardwareInformation.MemorySize') { $size = $props.'HardwareInformation.MemorySize' }
            
            $gb = [math]::Round($size / 1GB)
            if ($gb -gt 0) { 
                $gpuList += "$($props.DriverDesc) ($gb GB)" 
            } else {
                # Try match with WMI for iGPU size
                $wmiGPU = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -eq $props.DriverDesc } | Select-Object -First 1
                if ($wmiGPU.AdapterRAM -gt 0) {
                     $wmiGB = [math]::Round($wmiGPU.AdapterRAM / 1GB)
                     if ($wmiGB -gt 0) { $gpuList += "$($props.DriverDesc) ($wmiGB GB)" } else { $gpuList += $props.DriverDesc }
                } else {
                     $gpuList += $props.DriverDesc
                }
            }
        }
    }
} else {
    # Absolute Fallback if Registry Fails
    $gpus = Get-CimInstance Win32_VideoController
    foreach ($g in $gpus) { $gpuList += $g.Name }
}
$gpuString = ($gpuList | Select-Object -Unique) -join " + "
# --- 2. GENERATE HTML UI ---
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Montag Store Report</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
    body { background-color: #050505; color: #8f00ff; font-family: 'Share Tech Mono', monospace; text-align: center; padding: 20px; overflow-x: hidden; 
           background-image: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06)); background-size: 100% 2px, 3px 100%; }
    
    .container { max-width: 750px; margin: auto; background: rgba(20, 20, 20, 0.95); padding: 30px; border: 1px solid #333; box-shadow: 0 0 30px rgba(143, 0, 255, 0.2); border-radius: 10px; }
    
    .header { font-size: 36px; font-weight: bold; text-shadow: 2px 2px 0px #ff00ff; margin-bottom: 25px; color: #fff; letter-spacing: 2px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; text-align: left; margin-bottom: 25px; }
    .card { background: #111; border: 1px solid #444; padding: 12px; border-left: 4px solid #8f00ff; border-radius: 4px; }
    .card h4 { margin: 0 0 5px 0; color: #888; font-size: 12px; letter-spacing: 1px; }
    .card p { margin: 0; font-size: 13px; color: #fff; font-weight: bold; word-wrap: break-word; }

    .input-section { text-align: left; margin-bottom: 20px; }
    label { display: block; color: #fff; margin-bottom: 8px; font-size: 14px; }
    input, textarea { width: 95%; padding: 12px; background: #000; border: 1px solid #555; color: #00ff00; font-family: inherit; font-size: 16px; border-radius: 4px; outline: none; transition: 0.3s; }
    input:focus, textarea:focus { border-color: #8f00ff; box-shadow: 0 0 8px rgba(143, 0, 255, 0.3); }

    /* Client Info Section */
    #clientSection { 
        display: none; 
        background: rgba(0, 255, 0, 0.05); 
        padding: 20px; 
        border: 1px dashed #00ff00; 
        border-radius: 8px;
        margin-bottom: 25px; 
        animation: fadeIn 0.4s ease-out;
    }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    .btn-group { display: flex; gap: 15px; margin-top: 10px; }
    button { flex: 1; padding: 18px; font-size: 18px; font-family: inherit; font-weight: bold; border: none; cursor: pointer; color: #fff; text-transform: uppercase; border-radius: 6px; transition: 0.2s; }
    .btn-sell { background: #28a745; box-shadow: 0 4px 0 #1e7e34; }
    .btn-test { background: #17a2b8; box-shadow: 0 4px 0 #117a8b; }
    .btn-confirm { background: #d63384; box-shadow: 0 4px 0 #a61e61; animation: pulse 1.5s infinite; }
    
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.02); } 100% { transform: scale(1); } }
    
    button:active { transform: translateY(4px); box-shadow: none; }
    button:hover { filter: brightness(1.2); }

</style>
</head>
<body>
    <div class="container">
        <div class="header">MONTAG STORE SYSTEM</div>
        
        <div class="input-section">
            <label>TESTER NAME:</label>
            <input type="text" id="testerName" placeholder="Who are you?" required>
        </div>

        <div class="info-grid">
            <div class="card"><h4>MODEL</h4><p>$FullModel</p></div>
            <div class="card"><h4>SERIAL</h4><p>$($bios.SerialNumber)</p></div>
            <div class="card"><h4>PROCESSOR</h4><p>$cpuDetails</p></div>
            <div class="card"><h4>GRAPHICS</h4><p>$gpuString</p></div>
            <div class="card"><h4>MEMORY (SPEED)</h4><p>$ramDetails</p></div>
            <div class="card"><h4>INTERNAL STORAGE</h4><p>$storageString</p></div>
        </div>

        <div id="clientSection">
            <div class="input-section">
                <label style="color: #00ff00;">CLIENT NAME:</label>
                <input type="text" id="clientName" placeholder="Enter Customer Name">
            </div>
            <div class="input-section">
                <label style="color: #00ff00;">PHONE NUMBER:</label>
                <input type="text" id="clientPhone" placeholder="01xxxxxxxxx">
            </div>
        </div>

        <div class="input-section">
            <label>NOTES / STATUS LOG:</label>
            <textarea id="status" rows="2">$StatusLog</textarea>
        </div>

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
                btn.innerText = "CONFIRM & UPLOAD";
                btn.className = "btn-confirm";
                document.getElementById('clientName').focus();
            } else {
                var cName = document.getElementById('clientName').value;
                var cPhone = document.getElementById('clientPhone').value;
                
                if (cName.trim() === "" || cPhone.trim() === "") {
                    alert("Please enter Client Name and Phone Number!");
                    return;
                }
                sendData('SELL');
            }
        }

        function sendData(type) {
            var tester = document.getElementById('testerName').value;
            var logs = document.getElementById('status').value;
            
            if (tester.trim() === "") { alert("Please enter Tester Name!"); return; }

            var clientInfo = "";
            
            if (type === 'SELL') {
                var cName = document.getElementById('clientName').value;
                var cPhone = document.getElementById('clientPhone').value;
                clientInfo = cName + " - " + cPhone;
            } else {
                clientInfo = "Stock";
            }

            var finalName = tester + " - " + type;
            
            var url = "https://docs.google.com/forms/d/e/$FormID/formResponse?usp=pp_url" +
                "&entry.371291262=" + type +
                "&entry.392302034=" + encodeURIComponent(finalName) +
                "&entry.517500793=" + encodeURIComponent(clientInfo) +
                "&entry.531158115=" + encodeURIComponent("$FullModel") +
                "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)") +
                "&entry.1462565184=" + encodeURIComponent("$cpuDetails") +
                "&entry.212987726=" + encodeURIComponent("$ramDetails") +
                "&entry.1717831234=" + encodeURIComponent("$storageString") +
                "&entry.2044586469=" + encodeURIComponent("$gpuString") +
                "&entry.310563239=" + encodeURIComponent(logs);
            
            fetch(url, { mode: 'no-cors' }).then(function() {
                document.body.innerHTML = "<h1 style='color:#00ff00;margin-top:20%'>UPLOAD SUCCESSFUL!</h1><p style='color:#fff'>Closing window...</p>";
                setTimeout(function(){ window.close(); }, 2000);
            }).catch(function() {
                alert("Connection Error! Check Internet.");
            });
        }
    </script>
</body>
</html>
"@
$htmlContent | Out-File "$env:TEMP\MontagReport.html" -Encoding UTF8
Start-Process "$env:TEMP\MontagReport.html"