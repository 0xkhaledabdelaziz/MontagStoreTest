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
$cpuDetails = "$($cpu.Name) | $($cpu.NumberOfCores) Cores | $maxSpeed GHz | $cacheMB MB Cache"
$mem = Get-CimInstance Win32_PhysicalMemory
$memArray = @($mem)
$totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramSpeed = 0
foreach ($s in $memArray) { if ($s.Speed -gt 0) { $ramSpeed = [math]::Max($ramSpeed, $s.Speed) } }
if ($ramSpeed -eq 0) { $ramSpeed = "Unknown" }
$ramDetails = "$totalRam GB @ $ramSpeed MHz"
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { 
    ($_.MediaType -eq 'Fixed hard disk media') -and ($_.InterfaceType -ne 'USB')
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

# LOGOS & LINKS LOGIC 
$LaptopLogo = "https://cdn.simpleicons.org/windows/00e5ff" 
$WarrantyLink = "https://www.google.com/search?q=$($bios.SerialNumber)+warranty"

if ($Man -match "Dell") { 
    $LaptopLogo = "https://cdn.simpleicons.org/dell/0076CE"
    $WarrantyLink = "https://www.dell.com/support/home/en-us/product-support/servicetag/$($bios.SerialNumber)/overview" 
} elseif ($Man -match "HP" -or $Man -match "Hewlett") { 
    $LaptopLogo = "https://cdn.simpleicons.org/hp/0096D6"
    $WarrantyLink = "https://support.hp.com/us-en/checkwarranty" 
} elseif ($Man -match "Lenovo") { 
    $LaptopLogo = "https://cdn.simpleicons.org/lenovo/E2231A"
    $WarrantyLink = "https://pcsupport.lenovo.com/us/en/warrantylookup" 
} elseif ($Man -match "Microsoft") {
    $LaptopLogo = "https://cdn.simpleicons.org/microsoft/00A4EF"
    $WarrantyLink = "https://mybusinessservice.surface.com/en-US/CheckWarranty/CheckWarranty"
}

# ==========================================================
# 2. HTML UI (MODERN INTERNAL SALES DASHBOARD)
# ==========================================================
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Montag Sales</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;500;800&display=swap" rel="stylesheet">
<style>
    :root { --primary: #8f00ff; --secondary: #00e5ff; --bg: #050505; --card-bg: rgba(15, 15, 20, 0.75); }
    body {
        font-family: 'Outfit', sans-serif;
        background-color: var(--bg);
        color: #fff; margin: 0; padding: 20px; min-height: 100vh;
        display: flex; justify-content: center; align-items: center;
        overflow-x: hidden; position: relative; z-index: 1;
    }
    
    /* FAST ANIMATED BACKGROUND ORBS - SWAPPED COLORS */
    body::before, body::after {
        content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%;
        filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate;
    }
    body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } /* Cyan Left */
    body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } /* Purple Right */
    
    @keyframes floatOrbs {
        0% { transform: translate(0, 0) scale(1); }
        100% { transform: translate(5%, 5%) scale(1.15); }
    }

    .container {
        max-width: 850px; width: 100%; max-height: 95vh; overflow-y: auto;
        background: var(--card-bg); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 20px; padding: 30px 40px;
        box-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.6);
        animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
    }
    .container::-webkit-scrollbar { width: 8px; }
    .container::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 4px; }
    @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    
    .header { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 20px; margin-bottom: 25px; }
    .header img.brand { justify-self: start; height: 80px; width: auto; max-width: 100px; object-fit: contain; filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.1)); }
    .header .title-box { justify-self: center; text-align: center; }
    .header img.montag { justify-self: end; height: 140px; width: auto; max-width: 200px; filter: drop-shadow(0 0 15px rgba(143, 0, 255, 0.5)); }

    .title-box h1 { margin: 0; font-size: 26px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; }
    .title-box p { margin: 5px 0 0 0; color: #a0a0ab; font-size: 14px; letter-spacing: 1px; }

    .specs-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; margin-bottom: 20px; }
    .spec-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 15px; position: relative; overflow: hidden; transition: 0.3s; }
    .spec-card:hover { border-color: rgba(143, 0, 255, 0.5); background: rgba(255, 255, 255, 0.05); }
    .spec-card::before { content: ''; position: absolute; top: 0; left: 0; width: 3px; height: 100%; background: linear-gradient(to bottom, var(--primary), var(--secondary)); }
    .spec-label { font-size: 11px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; display: block; }
    .spec-value { font-size: 14px; font-weight: 500; color: #fff; }

    .input-group { margin-bottom: 20px; }
    label { display: block; font-size: 12px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; font-weight: 800; }
    input, textarea { width: 100%; padding: 12px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255, 255, 255, 0.1); color: #00e5ff; font-family: inherit; font-size: 14px; border-radius: 8px; outline: none; box-sizing: border-box; transition: all 0.3s ease; }
    input:focus, textarea:focus { border-color: var(--primary); box-shadow: 0 0 10px rgba(143, 0, 255, 0.2); background: rgba(0, 0, 0, 0.6); }
    
    .static-box { background: rgba(0, 0, 0, 0.5); border: 1px solid rgba(0, 229, 255, 0.3); color: #00e5ff; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 500; }

    #clientSection, #stockSection, #notesSection { display: none; background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; margin-bottom: 20px; }
    .flex-row { display: flex; gap: 15px; }
    .flex-row .input-group { flex: 1; margin-bottom: 0; }

    .btn-group { display: flex; gap: 15px; margin-top: 10px; }
    .btn { flex: 1; padding: 15px; border: none; border-radius: 8px; font-family: inherit; font-size: 14px; font-weight: 800; cursor: pointer; text-transform: uppercase; transition: all 0.3s ease; color: #fff; text-align: center; }
    
    .btn-sell { background: linear-gradient(45deg, #10b981, #059669); box-shadow: 0 5px 15px rgba(16, 185, 129, 0.2); }
    .btn-sell:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4); }
    
    .btn-test { background: linear-gradient(45deg, #3b82f6, #2563eb); box-shadow: 0 5px 15px rgba(59, 130, 246, 0.2); }
    .btn-test:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4); }
    
    .btn-confirm { background: linear-gradient(45deg, #8f00ff, #c026d3); box-shadow: 0 5px 15px rgba(143, 0, 255, 0.3); animation: pulse 2s infinite; }
    
    .btn-issue { background: linear-gradient(45deg, #ef4444, #dc2626); box-shadow: 0 5px 15px rgba(239, 68, 68, 0.2); }
    .btn-issue:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4); }

    @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(143, 0, 255, 0); } 100% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0); } }
    
    .status-text { text-align: center; font-size: 16px; font-weight: 800; margin-top: 15px; padding: 15px; border-radius: 8px; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="$LaptopLogo" alt="Brand" class="brand">
            <div class="title-box">
                <h1>Montag Dashboard</h1>
                <p>Internal Sales & Testing System</p>
            </div>
            <img src="$LogoPath" alt="Montag Store" class="montag">
        </div>

        <div class="input-group">
            <label>Tester Name</label>
            <input type="text" id="testerName" placeholder="Enter your name..." required>
        </div>
        
        <div class="specs-grid" id="specsData">
            <div class="spec-card"><span class="spec-label">Model</span><div class="spec-value">$FullModel</div></div>
            <div class="spec-card"><span class="spec-label">Serial</span><div class="spec-value">$($bios.SerialNumber)</div></div>
            <div class="spec-card"><span class="spec-label">CPU</span><div class="spec-value">$cpuDetails</div></div>
            <div class="spec-card"><span class="spec-label">RAM</span><div class="spec-value">$ramDetails</div></div>
            <div class="spec-card"><span class="spec-label">GPU</span><div class="spec-value">$gpuString</div></div>
            <div class="spec-card"><span class="spec-label">Storage</span><div class="spec-value">$storageString</div></div>
        </div>

        <div class="input-group">
            <label>System Checks (Read-Only)</label>
            <div id="checklistDisplay" class="static-box">$StatusLog</div>
        </div>
        
        <div id="clientSection">
            <label style="color: #10b981; margin-bottom: 15px; font-size: 14px;">Customer Details</label>
            <div class="flex-row">
                <div class="input-group"><input type="text" id="clientName" placeholder="Customer Name"></div>
                <div class="input-group"><input type="text" id="clientPhone" placeholder="Phone (e.g., 01xxxxxxxxx)"></div>
            </div>
        </div>

        <div id="stockSection">
            <label style="color: #3b82f6; text-align: center; font-size: 16px; margin-bottom: 15px;">Stock Condition Check</label>
            <div class="btn-group" id="stockButtons">
                <button class="btn btn-sell" onclick="submitStock('GOOD')">GOOD / PASS</button>
                <button class="btn btn-issue" onclick="showNotesForIssue()">HAS ISSUES</button>
            </div>
            <div id="stockFeedback" class="status-text" style="display:none;">
                CONDITION: HAS ISSUES
            </div>
        </div>

        <div id="notesSection">
            <div class="input-group">
                <label>Manual Notes / Issues</label>
                <textarea id="userNotes" rows="3" placeholder="Write observation or problem details here..."></textarea>
            </div>
            <button id="btnSubmitIssue" class="btn btn-issue" style="display:none; width:100%;" onclick="submitStock('ISSUE')">CONFIRM & UPLOAD REPORT</button>
        </div>
        
        <div class="btn-group" id="mainButtons">
            <button id="btnSell" class="btn btn-sell" onclick="handleSell()">SELL (Customer)</button>
            <button id="btnTest" class="btn btn-test" onclick="handleStock()">TEST (Stock)</button>
        </div>
    </div>

    <script>
        // FORCE FULL SCREEN JAVASCRIPT
        window.moveTo(0, 0);
        window.resizeTo(screen.availWidth, screen.availHeight);

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
                btn.className = "btn btn-confirm"; 
                document.getElementById('clientName').focus();
            } else {
                if (!document.getElementById('clientName').value || !document.getElementById('clientPhone').value) { alert("Please enter Client Details!"); return; }
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
            if (!tester) { alert("Please enter Tester Name!"); return; }
            
            var checklist = document.getElementById('checklistDisplay').innerText;
            var userNotes = document.getElementById('userNotes').value.trim();
            var finalStatus = checklist;
            var clientInfo = "";
            
            if (type === 'SELL') {
                clientInfo = document.getElementById('clientName').value + " - " + document.getElementById('clientPhone').value;
                if (userNotes) { finalStatus += " | NOTES: " + userNotes; }
            } else {
                if (userNotes) { clientInfo = userNotes; } else { clientInfo = "Stock"; }
                finalStatus = checklist;
            }

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
                document.title = "MONTAG_EXIT_TRIGGER";
                document.body.innerHTML = "<div style='text-align:center; margin-top:20vh;'><h1 style='color:#00e5ff; font-size:40px;'>UPLOAD SUCCESSFUL!</h1><p style='color:#a0a0ab; font-size:18px;'>System Finalized. You can close this window now.</p></div>";
            });
        }
    </script>
</body>
</html>
"@
$htmlContent | Out-File "$env:TEMP\MontagSales.html" -Encoding UTF8
# ==========================================================
# 3. Launch UI & FAST SMART WATCHER
# ==========================================================
Start-Process "msedge" -ArgumentList "--new-window --app=`"$env:TEMP\MontagSales.html`""
Start-Sleep -Seconds 2

$loop = $true
$misses = 0
while ($loop) {
    $edgeProcs = Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match "Montag Sales|MONTAG_EXIT_TRIGGER" }
    
    if ($edgeProcs) {
        $misses = 0 
        if ($edgeProcs.MainWindowTitle -match "MONTAG_EXIT_TRIGGER") {
            Start-Sleep -Seconds 1 
            $edgeProcs | Stop-Process -Force -ErrorAction SilentlyContinue
            break 
        }
    } else {
        $misses++
        if ($misses -gt 3) { break } 
    }
    Start-Sleep -Milliseconds 500
}

# ==========================================================
# 4. GENERATE MODERN CLIENT REPORT (DESKTOP)
# ==========================================================
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Montag Store - Premium Report</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;500;800&display=swap" rel="stylesheet">
<style>
    :root { --primary: #8f00ff; --secondary: #00e5ff; --bg: #050505; --card-bg: rgba(15, 15, 20, 0.75); }
    body {
        font-family: 'Outfit', sans-serif;
        background-color: var(--bg);
        color: #fff; margin: 0; padding: 40px 20px; min-height: 100vh;
        display: flex; justify-content: center; align-items: center;
        overflow-x: hidden; position: relative; z-index: 1;
    }

    /* FAST ANIMATED BACKGROUND ORBS - SWAPPED COLORS */
    body::before, body::after {
        content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%;
        filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate;
    }
    body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } /* Cyan Left */
    body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } /* Purple Right */
    
    @keyframes floatOrbs {
        0% { transform: translate(0, 0) scale(1); }
        100% { transform: translate(5%, 5%) scale(1.15); }
    }

    .container {
        max-width: 850px; width: 100%;
        background: var(--card-bg); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 20px; padding: 40px;
        box-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.6);
        animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
    }
    @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    
    .header { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 20px; margin-bottom: 30px; }
    .header img.brand { justify-self: start; height: 80px; width: auto; max-width: 100px; object-fit: contain; filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.1)); }
    .header .title-box { justify-self: center; text-align: center; }
    .header img.montag { justify-self: end; height: 140px; width: auto; max-width: 200px; filter: drop-shadow(0 0 15px rgba(143, 0, 255, 0.5)); }

    .title-box h1 { margin: 0; font-size: 28px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; }
    .title-box p { margin: 5px 0 0 0; color: #a0a0ab; font-size: 14px; letter-spacing: 1px; }

    .specs-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px; }
    .spec-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; transition: all 0.3s ease; position: relative; overflow: hidden; }
    .spec-card:hover { transform: translateY(-5px); border-color: rgba(143, 0, 255, 0.5); box-shadow: 0 10px 20px rgba(143, 0, 255, 0.15); background: rgba(255, 255, 255, 0.05); }
    .spec-card::before { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: linear-gradient(to bottom, var(--primary), var(--secondary)); }
    .spec-label { font-size: 12px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; display: block; }
    .spec-value { font-size: 16px; font-weight: 500; color: #fff; }
    
    .actions { margin-top: 40px; display: flex; gap: 15px; flex-wrap: wrap; }
    .btn { flex: 1; min-width: 200px; padding: 15px; border: none; border-radius: 8px; font-family: inherit; font-size: 14px; font-weight: 800; cursor: pointer; text-transform: uppercase; transition: all 0.3s ease; text-align: center; text-decoration: none; display: flex; justify-content: center; align-items: center; gap: 10px; }
    .btn-copy { background: rgba(255, 255, 255, 0.1); color: #fff; border: 1px solid rgba(255, 255, 255, 0.2); }
    .btn-copy:hover { background: rgba(255, 255, 255, 0.2); }
    .btn-warranty { background: linear-gradient(45deg, #007bff, #00d2ff); color: #fff; box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3); }
    .btn-warranty:hover { transform: scale(1.02); box-shadow: 0 8px 20px rgba(0, 123, 255, 0.5); }
    .btn-whatsapp { background: linear-gradient(45deg, #25D366, #128C7E); color: #fff; box-shadow: 0 5px 15px rgba(37, 211, 102, 0.3); }
    .btn-whatsapp:hover { transform: scale(1.02); box-shadow: 0 8px 20px rgba(37, 211, 102, 0.5); }
</style>
</head>
<body>

<div class="container">
    <div class="header">
        <img src="$LaptopLogo" alt="Brand" class="brand">
        <div class="title-box">
            <h1>Device Inspection</h1>
            <p>Tested and Verified By Montag Store</p>
        </div>
        <img src="$LogoPath" alt="Montag Store" class="montag">
    </div>

    <div class="specs-grid" id="specsData">
        <div class="spec-card">
            <span class="spec-label">Model Name</span>
            <div class="spec-value">$FullModel</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Serial Number</span>
            <div class="spec-value">$($bios.SerialNumber)</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Processor (CPU)</span>
            <div class="spec-value">$cpuDetails</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Installed RAM</span>
            <div class="spec-value">$ramDetails</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Graphics (GPU)</span>
            <div class="spec-value">$gpuString</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Primary Storage</span>
            <div class="spec-value">$storageString</div>
        </div>
        <div class="spec-card" style="grid-column: 1 / -1; border-color: #00e5ff;">
            <span class="spec-label" style="color:#00e5ff;">Inspection Checklist / Condition</span>
            <div class="spec-value" style="font-family: monospace; color:#ccc;">$StatusLog</div>
        </div>
    </div>

    <div class="actions">
        <button class="btn btn-copy" onclick="copySpecs(this)">
            COPY SPECS
        </button>
        <button class="btn btn-warranty" onclick="handleWarranty(this)">
            CHECK WARRANTY
        </button>
        <a href="https://wa.me/$TechNum" target="_blank" class="btn btn-whatsapp">
            CONTACT SUPPORT
        </a>
    </div>
</div>

<script>
    // FORCE FULL SCREEN JAVASCRIPT
    window.moveTo(0, 0);
    window.resizeTo(screen.availWidth, screen.availHeight);

    function forceCopyText(text) {
        var textArea = document.createElement("textarea");
        textArea.value = text;
        textArea.style.position = "fixed"; 
        textArea.style.left = "-999999px"; 
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        document.execCommand("copy");
        document.body.removeChild(textArea);
    }

    function copySpecs(btn) {
        var textToCopy = "[ Montag Store - Device Specs ]\n\n" +
                         "*Model:* $FullModel\n" +
                         "*Serial:* $($bios.SerialNumber)\n" +
                         "*CPU:* $cpuDetails\n" +
                         "*RAM:* $ramDetails\n" +
                         "*GPU:* $gpuString\n" +
                         "*Storage:* $storageString\n\n" +
                         "*Status:* $StatusLog\n\n" +
                         "Verified by Montag Store System [OK]";
        
        forceCopyText(textToCopy);
        
        var originalText = btn.innerHTML;
        btn.innerHTML = "Copied to Clipboard! [OK]";
        btn.style.background = "#28a745";
        btn.style.borderColor = "#28a745";
        
        setTimeout(function() { 
            btn.innerHTML = originalText; 
            btn.style.background = ""; 
            btn.style.borderColor = ""; 
        }, 3000);
    }

    function handleWarranty(btn) {
        forceCopyText("$($bios.SerialNumber)");
        
        var originalText = btn.innerHTML;
        btn.innerHTML = "Serial Copied! Opening...";
        
        setTimeout(function() {
            window.open("$WarrantyLink", "_blank");
            btn.innerHTML = originalText;
        }, 800);
    }
</script>
</body>
</html>
"@

$ClientReport | Out-File "$RealHtmlFile" -Encoding UTF8
$ShortcutContent = "[InternetShortcut]
URL=file:///$RealHtmlFile
IconIndex=0
IconFile=$IconPath"
$ShortcutContent | Out-File "$DesktopShortcut" -Encoding UTF8