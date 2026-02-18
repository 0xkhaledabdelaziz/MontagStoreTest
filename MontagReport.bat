<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] SELF-PROTECTION & CONFIG
:: ============================================================
if /i "%~dp0" neq "%TEMP%\" (
    copy /y "%~f0" "%TEMP%\%~nx0" >nul
    "%TEMP%\%~nx0"
    exit
)

FSUTIL dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Maximized"
    exit
)

cd /d "%~dp0"
chcp 65001 >nul
mode con: cols=80 lines=25
title Montag Store - Sales System (V 130.22 Final Stable)
color 0B

:: --- BRANDING DATA ---
set "BrandName=Montag Store"
set "BrandPhone=Manager: 01090040022 - 01144566115 | Tech: 01040901444"
set "BrandURL=https://montagstore.com"
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"
set "TechSupportNumber=201040901444"
set "WorkHours=12 PM - 9 PM"

:: Paths
set "IconDir=%ProgramData%\MontagStore"
set "IconPath=%IconDir%\Montag.ico"
set "LogoPath=%IconDir%\Logo.png"

:: URLs
set "UrlLogo=https://www.dropbox.com/scl/fi/2qv201jvm18n3c971436o/Logo-purple.png?rlkey=b8n5e732fsepkadzg7y10gj1k&st=7q4k6jll&dl=1"
set "UrlIcon=https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1"

:: --- DOWNLOAD ASSETS ---
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
if not exist "%IconPath%" curl -L -k -s -o "%IconPath%" "%UrlIcon%" >nul 2>&1
if not exist "%LogoPath%" curl -L -k -s -o "%LogoPath%" "%UrlLogo%" >nul 2>&1

:: --- GENERATE SPLASH SCRIPT ---
set "SplashScript=%TEMP%\MontagSplash.ps1"
(
echo Add-Type -AssemblyName System.Windows.Forms
echo Add-Type -AssemblyName System.Drawing
echo $form = New-Object System.Windows.Forms.Form
echo $form.FormBorderStyle = 'None'
echo $form.BackColor = [System.Drawing.Color]::Black
echo $form.WindowState = 'Maximized'
echo $form.TopMost = $true
echo $form.ShowInTaskbar = $false
echo $form.Opacity = 0
echo $pb = New-Object System.Windows.Forms.PictureBox
echo $pb.Image = [System.Drawing.Image]::FromFile^('%LogoPath%'^)
echo $pb.SizeMode = 'Zoom'
echo $pb.Dock = 'Fill'
echo $pb.BackColor = [System.Drawing.Color]::Transparent
echo $form.Controls.Add^($pb^)
echo $form.Show^(^)
echo for ^($i = 0; $i -le 1; $i += 0.05^) { $form.Opacity = $i; [System.Windows.Forms.Application]::DoEvents^(^); Start-Sleep -Milliseconds 15 }
echo Start-Sleep -Seconds 2
echo for ^($i = 1; $i -ge 0; $i -= 0.05^) { $form.Opacity = $i; [System.Windows.Forms.Application]::DoEvents^(^); Start-Sleep -Milliseconds 15 }
echo $form.Close^(^)
echo $pb.Dispose^(^)
echo $form.Dispose^(^)
) > "%SplashScript%"

:: ============================================================
:: [1] CINEMATIC START
:: ============================================================
cls
if exist "%LogoPath%" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SplashScript%" >nul 2>&1
)

:: --- READ LOG ---
set "LogFile=%SystemDrive%\MontagTools\MontagLog.txt"
set "IncomingLog=Manual Inspection"
if exist "%LogFile%" (set /p IncomingLog=<"%LogFile%")

:: ============================================================
:: [2] PREPARE SYSTEM
:: ============================================================
echo.
echo      =============================================
echo            MONTAG STORE - SALES INTERFACE       
echo      =============================================
echo.
echo      [1/3] Setting up Environment...

:: Branding Registry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "%BrandName%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "Certified Refurbished" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /t REG_SZ /d "%BrandPhone%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "%BrandURL%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportHours /t REG_SZ /d "%WorkHours%" /f >nul 2>&1
if exist "%IconPath%" reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Logo /t REG_SZ /d "%IconPath%" /f >nul 2>&1

:: Right Click
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /ve /t REG_SZ /d "Contact Montag Support" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport" /v "Icon" /t REG_SZ /d "%IconPath%" /f >nul 2>&1
reg add "HKCR\DesktopBackground\Shell\MontagSupport\command" /ve /t REG_SZ /d "explorer \"https://wa.me/%TechSupportNumber%\"" /f >nul 2>&1

:: --- EXTRACT & RUN REPORT ENGINE ---
echo      [2/3] Deep Scanning Hardware...
set "ReportEngine=%TEMP%\MontagReportEngine.ps1"
if exist "%ReportEngine%" del "%ReportEngine%"
for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__REPORT_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%ReportEngine%"

echo      [3/3] Waiting for User Input...
:: Launch PowerShell
powershell -ExecutionPolicy Bypass -File "%ReportEngine%" -StatusLog "%IncomingLog%" -FormID "%GFormID%" -IconPath "%IconPath%" -LogoPath "%LogoPath%" -TechNum "%TechSupportNumber%"

:: ============================================================
:: [3] CINEMATIC EXIT & FINAL CLEANUP
:: ============================================================
cls
color 00
:: REMOVED TASKKILL TO PREVENT AUTO-CLOSING
if exist "%LogoPath%" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SplashScript%" >nul 2>&1
)

:: --- THE CLEANUP ---
rmdir /s /q "%SystemDrive%\MontagTools" >nul 2>&1
exit

:: ============================================================
::  POWERSHELL REPORT ENGINE
:: ============================================================
:::__REPORT_START__:::
param($StatusLog, $FormID, $IconPath, $LogoPath, $TechNum)
$ErrorActionPreference = 'SilentlyContinue'

# --- 1. GATHER FULL SPECS ---
$sys = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor
$bios = Get-CimInstance Win32_Bios
$Man = $sys.Manufacturer.Trim()
$Mod = $sys.Model.Trim()
if ($Mod.StartsWith($Man)) { $FullModel = $Mod } else { $FullModel = "$Man $Mod" }
$maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cacheMB = [int]($cpu.L3CacheSize / 1024)
if ($cacheMB -eq 0) { $cacheMB = [int]($cpu.L2CacheSize / 1024) }
$cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz | $cacheMB MB Cache"
$mem = Get-CimInstance Win32_PhysicalMemory
$memArray = @($mem)
$stickCount = $memArray.Count
$totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramSpeed = 0
foreach ($s in $memArray) { if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } }
if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" }
$ramDetails = "$totalRam GB ($stickCount Sticks) @ $ramSpeed MHz"
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { 
    ($_.MediaType -eq 'Fixed hard disk media') -and ($_.InterfaceType -ne 'USB') -and ($_.PNPDeviceID -notmatch 'USBSTOR') -and ($_.Model -notmatch 'USB')
}
$diskList = @()
foreach ($d in $disks) { $s = [math]::Round($d.Size / 1GB, 0); $diskList += "$($d.Model) ($s GB)" }
if ($diskList.Count -eq 0) { $storageString = "No Internal Disk Detected" } else { $storageString = $diskList -join " | " }
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
$LaptopLogo = "https://cdn-icons-png.flaticon.com/512/900/900782.png" 
$WarrantyLink = "https://www.google.com/search?q=$($bios.SerialNumber)+warranty"
if ($Man -match "Dell") { $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Dell_Logo.svg/200px-Dell_Logo.svg.png"; $WarrantyLink = "https://www.dell.com/support/home/en-us/product-support/servicetag/$($bios.SerialNumber)/overview" }
elseif ($Man -match "HP" -or $Man -match "Hewlett") { $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/HP_logo_2012.svg/200px-HP_logo_2012.svg.png"; $WarrantyLink = "https://support.hp.com/us-en/checkwarranty" }
elseif ($Man -match "Lenovo") { $LaptopLogo = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Lenovo_logo_2015.svg/200px-Lenovo_logo_2015.svg.png"; $WarrantyLink = "https://pcsupport.lenovo.com/us/en/warrantylookup" }

# 2. HTML UI
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Montag Sales</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
    body { background-color: #050505; color: #8f00ff; font-family: 'Share Tech Mono', monospace; text-align: center; margin: 0; padding: 0; height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
    .container { width: 700px; max-width: 90%; background: rgba(20, 20, 20, 0.95); padding: 40px; border: 1px solid #333; box-shadow: 0 0 40px rgba(143, 0, 255, 0.3); border-radius: 12px; animation: fadeIn 1s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; opacity: 0; transform: scale(0.95); }
    @keyframes fadeIn { to { opacity: 1; transform: scale(1); } }
    .header { font-size: 45px; font-weight: bold; color: #fff; margin-top: 10px; margin-bottom: 35px; text-transform: uppercase; animation: neon 1.5s ease-in-out infinite alternate; }
    @keyframes neon { from { text-shadow: 0 0 10px #8f00ff, 0 0 20px #8f00ff; } to { text-shadow: 0 0 5px #fff, 0 0 10px #ff00ff, 0 0 20px #ff00ff; } }
    .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; text-align: left; margin-bottom: 25px; }
    .card { background: #111; border: 1px solid #444; padding: 12px; border-left: 4px solid #8f00ff; border-radius: 4px; }
    .card h4 { margin: 0 0 5px 0; color: #888; font-size: 12px; }
    .card p { margin: 0; font-size: 13px; color: #fff; font-weight: bold; }
    .input-section { text-align: left; margin-bottom: 20px; }
    label { display: block; color: #fff; margin-bottom: 8px; font-size: 14px; }
    input, textarea { width: 95%; padding: 12px; background: #000; border: 1px solid #555; color: #00ff00; font-family: inherit; font-size: 16px; border-radius: 4px; outline: none; }
    input:focus { border-color: #8f00ff; box-shadow: 0 0 8px rgba(143, 0, 255, 0.3); }
    
    /* SECTIONS */
    #clientSection, #stockSection, #notesSection { display: none; padding: 20px; border-radius: 8px; margin-bottom: 25px; }
    #clientSection { background: rgba(0, 255, 0, 0.05); border: 1px dashed #00ff00; }
    #stockSection { background: rgba(0, 255, 255, 0.05); border: 1px dashed #00ffff; transition: 0.3s; }
    #notesSection { background: rgba(255, 0, 255, 0.05); border: 1px dashed #ff00ff; }

    /* STATIC READ ONLY BOX */
    .static-box { background: #111; padding: 12px; border: 1px solid #333; color: #0f0; font-weight: bold; border-radius: 4px; white-space: pre-wrap; font-size: 14px; }

    .btn-group { display: flex; gap: 15px; margin-top: 20px; }
    button { flex: 1; padding: 18px; font-size: 18px; font-family: inherit; font-weight: bold; border: none; cursor: pointer; color: #fff; text-transform: uppercase; border-radius: 6px; transition: 0.2s; }
    .btn-sell { background: #28a745; box-shadow: 0 4px 0 #1e7e34; }
    .btn-test { background: #17a2b8; box-shadow: 0 4px 0 #117a8b; }
    .btn-confirm { background: #d63384; box-shadow: 0 4px 0 #a61e61; animation: pulse 1s infinite; }
    .btn-issue { background: #dc3545; box-shadow: 0 4px 0 #a71d2a; animation: pulse 1s infinite; }
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.02); } 100% { transform: scale(1); } }
    
    .status-text { text-align: center; font-size: 20px; font-weight: bold; margin-top: 10px; padding: 10px; border: 2px solid; border-radius: 5px; }
</style>
</head>
<body>
    <div class="container">
        <div class="header">MONTAG STORE SYSTEM</div>
        <div class="input-section"><label>TESTER NAME:</label><input type="text" id="testerName" placeholder="Who are you?" required></div>
        
        <div class="info-grid" id="specsGrid">
            <div class="card"><h4>MODEL</h4><p>$FullModel</p></div>
            <div class="card"><h4>SERIAL</h4><p>$($bios.SerialNumber)</p></div>
            <div class="card"><h4>CPU</h4><p>$cpuDetails</p></div>
            <div class="card"><h4>RAM</h4><p>$ramDetails</p></div>
            <div class="card"><h4>GPU</h4><p>$gpuString</p></div>
            <div class="card"><h4>DISK</h4><p>$storageString</p></div>
        </div>

        <div class="input-section">
            <label>SYSTEM CHECKS (READ-ONLY):</label>
            <div id="checklistDisplay" class="static-box">$StatusLog</div>
        </div>
        
        <div id="clientSection">
            <div class="input-section"><label style="color: #00ff00;">CLIENT NAME:</label><input type="text" id="clientName" placeholder="Customer Name"></div>
            <div class="input-section"><label style="color: #00ff00;">PHONE NUMBER:</label><input type="text" id="clientPhone" placeholder="01xxxxxxxxx"></div>
        </div>

        <div id="stockSection">
            <label style="color: #00ffff; margin-bottom: 25px; font-size: 20px; text-align:center; display:block;">STOCK CONDITION CHECK</label>
            
            <div class="btn-group" id="stockButtons" style="margin-top: 15px;">
                <button onclick="submitStock('GOOD')" style="background:#28a745; box-shadow: 0 4px 0 #1e7e34;">GOOD / PASS</button>
                <button onclick="showNotesForIssue()" style="background:#dc3545; box-shadow: 0 4px 0 #a71d2a;">HAS ISSUES</button>
            </div>

            <div id="stockFeedback" class="status-text" style="display:none; color: #ff4444; border-color: #ff4444;">
                [X] CONDITION: HAS ISSUES
            </div>
        </div>

        <div id="notesSection">
            <div class="input-section"><label>MANUAL NOTES / ISSUES:</label><textarea id="userNotes" rows="3" placeholder="Write observation or problem details here..."></textarea></div>
            <button id="btnSubmitIssue" class="btn-issue" style="display:none; width:100%; margin-top:10px;" onclick="submitStock('ISSUE')">CONFIRM & UPLOAD REPORT</button>
        </div>
        
        <div class="btn-group" id="mainButtons">
            <button id="btnSell" class="btn-sell" onclick="handleSell()">SELL (Customer)</button>
            <button id="btnTest" class="btn-test" onclick="handleStock()">TEST (Stock)</button>
        </div>
    </div>
    <script>
        function handleSell() {
            var section = document.getElementById('clientSection');
            var btn = document.getElementById('btnSell');
            var notes = document.getElementById('notesSection');
            
            document.getElementById('stockSection').style.display = 'none'; 
            document.getElementById('btnTest').style.display = 'none'; 
            notes.style.display = 'block'; 
            
            if (section.style.display === 'none' || section.style.display === '') {
                section.style.display = 'block';
                btn.innerText = "CONFIRM & UPLOAD"; 
                btn.className = "btn-confirm"; 
                document.getElementById('clientName').focus();
            } else {
                if (!document.getElementById('clientName').value || !document.getElementById('clientPhone').value) { alert("Enter Client Details!"); return; }
                sendData('SELL');
            }
        }

        function handleStock() {
            document.getElementById('clientSection').style.display = 'none';
            document.getElementById('notesSection').style.display = 'none';
            document.getElementById('mainButtons').style.display = 'none';
            document.getElementById('stockSection').style.display = 'block';
        }

        function showNotesForIssue() {
            document.getElementById('stockButtons').style.display = 'none';
            document.getElementById('stockFeedback').style.display = 'block';
            document.getElementById('notesSection').style.display = 'block';
            document.getElementById('btnSubmitIssue').style.display = 'block';
            document.getElementById('userNotes').focus();
        }

        function submitStock(condition) {
            if (condition === 'ISSUE') {
                var notes = document.getElementById('userNotes').value.trim();
                if (notes.length < 5) {
                    alert("Please write the problem details in the NOTES field!");
                    document.getElementById('userNotes').focus();
                    return;
                }
                sendData('TEST-ISSUE');
            } else {
                sendData('TEST-GOOD');
            }
        }

        function sendData(type) {
            var tester = document.getElementById('testerName').value;
            if (!tester) { alert("Enter Tester Name!"); return; }
            
            var checklist = document.getElementById('checklistDisplay').innerText;
            var userNotes = document.getElementById('userNotes').value.trim();
            var finalStatus = checklist;
            var clientInfo = "";

            if (type === 'SELL') {
                clientInfo = document.getElementById('clientName').value + " - " + document.getElementById('clientPhone').value;
                if (userNotes) { finalStatus += " | NOTES: " + userNotes; }
            } else {
                if (userNotes) {
                    clientInfo = userNotes; 
                } else {
                    clientInfo = "Stock";
                }
                finalStatus = checklist;
            }

            // CHUNKED URL 
            var url = "https://docs.google.com/forms/d/e/$FormID/formResponse?usp=pp_url";
            url += "&entry.371291262=" + type;
            url += "&entry.392302034=" + encodeURIComponent(tester);
            url += "&entry.517500793=" + encodeURIComponent(clientInfo);
            url += "&entry.531158115=" + encodeURIComponent("$FullModel");
            url += "&entry.1203480099=" + encodeURIComponent("$($bios.SerialNumber)");
            url += "&entry.1462565184=" + encodeURIComponent("$cpuDetails");
            url += "&entry.212987726=" + encodeURIComponent("$ramDetails");
            url += "&entry.1717831234=" + encodeURIComponent("$storageString");
            url += "&entry.2044586469=" + encodeURIComponent("$gpuString");
            url += "&entry.310563239=" + encodeURIComponent(finalStatus);

            fetch(url, { mode: 'no-cors' }).then(function() {
                document.title = "MONTAG_EXIT_TRIGGER"; // Trigger close
                document.body.innerHTML = "<h1 style='color:#0f0;margin-top:20%;font-family:sans-serif'>UPLOAD SUCCESSFUL!</h1><p style='color:#fff'>System Finalized.</p>";
            });
        }
    </script>
</body>
</html>
"@
$htmlContent | Out-File "$env:TEMP\MontagSales.html" -Encoding UTF8

# 3. Launch UI & SMART WATCHER
Start-Process "msedge" -ArgumentList "--new-window --app=$env:TEMP\MontagSales.html --start-fullscreen"

# WATCHER
$foundWindow = $false
$missedCount = 0
while ($true) {
    # Check for window presence (Title or Trigger)
    $w = Get-Process | Where-Object { $_.MainWindowTitle -like '*Montag Sales*' -or $_.MainWindowTitle -eq 'MONTAG_EXIT_TRIGGER' } | Select-Object -First 1
    
    if ($w) {
        $foundWindow = $true
        $missedCount = 0 # Reset miss counter if found
        
        # Check for upload trigger
        if ($w.MainWindowTitle -eq 'MONTAG_EXIT_TRIGGER') {
            Start-Sleep -Seconds 2 # Wait for user to see success msg
            $w | Stop-Process -Force
            break # Exit loop -> Show Logo
        }
    } else {
        # Window not found (either not started yet OR closed by user)
        if ($foundWindow) {
            # Was found before, now missing?
            $missedCount++
            # Only assume closed if missing for 5 cycles (approx 2.5 sec) to prevent accidental close on glitch
            if ($missedCount -gt 5) { break } 
        } else {
            # Startup phase (wait longer)
            $missedCount++
            if ($missedCount -gt 120) { break } # 60 sec timeout at startup
        }
    }
    Start-Sleep -Milliseconds 500
}

# 4. Generate Client Report
$ReportDir = "C:\MontagReports"
if (-not (Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }
$RealHtmlFile = "$ReportDir\Montag_$($bios.SerialNumber).html"
$SafeModel = $FullModel -replace '[\\/:*?"<>|]',' '
$DesktopShortcut = "$env:USERPROFILE\Desktop\Report - $SafeModel.url"

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
.brand-logo { height: 100px; width: auto; }
.laptop-logo { height: 90px; width: auto; }
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
        <a href="https://wa.me/$TechNum" target="_blank" class="btn btn-support">CONTACT SUPPORT</a>
    </div>
    <div class="footer">Generated by Montag Store System</div>
</div>
</body>
</html>
"@
$ClientReport | Out-File "$RealHtmlFile" -Encoding UTF8
$ShortcutContent = "[InternetShortcut]
URL=file:///$RealHtmlFile
IconIndex=0
IconFile=$IconPath"
$ShortcutContent | Out-File "$DesktopShortcut" -Encoding UTF8