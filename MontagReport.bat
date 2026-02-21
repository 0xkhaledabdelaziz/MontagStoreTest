<# :
@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: [0] ORIGINAL CORE & EXTRACTOR (ULTRA STABLE)
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
mode con: cols=85 lines=25
title Montag Store - Premium Sales Dashboard
color 0B

:: --- BRANDING DATA ---
set "GFormID=1FAIpQLSeQzAlNJupT5zEfjYxoQMbTupHd3gEPgdConPG_ySOdVFyhkA"
set "TechSupportNumber=201040901444"
set "UrlLogo=https://www.dropbox.com/scl/fi/2qv201jvm18n3c971436o/Logo-purple.png?rlkey=b8n5e732fsepkadzg7y10gj1k&st=7q4k6jll&dl=1"

:: --- ICON DOWNLOAD & SETUP ---
set "IconDir=%ProgramData%\MontagStore"
set "IconPath=%IconDir%\Montag.ico"
set "UrlIcon=https://www.dropbox.com/scl/fi/hjwoi8763lc1d5uyw7vhd/Montag.ico.ico?rlkey=ilxkmhhwqbaygjwhyycz5mqz0&st=siotxftu&dl=1"
if not exist "%IconDir%" mkdir "%IconDir%" >nul 2>&1
if not exist "%IconPath%" curl -L -k -s -o "%IconPath%" "%UrlIcon%" >nul 2>&1

set "LogFile=%SystemDrive%\MontagTools\MontagLog.txt"
set "IncomingLog=Manual Inspection"
if exist "%LogFile%" (
    set /p IncomingLog=<"%LogFile%"
)

echo.
echo      =============================================
echo            MONTAG STORE - SALES INTERFACE       
echo      =============================================
echo.
echo      [1/2] Setting up Environment...
echo      [2/2] Deep Scanning Hardware...

:: --- ORIGINAL BULLETPROOF EXTRACTOR ---
set "ReportEngine=%TEMP%\MontagReportEngine.ps1"
if exist "%ReportEngine%" del "%ReportEngine%"

for /f "tokens=1 delims=:" %%a in ('findstr /n "^:::__REPORT_START__:::$" "%~f0"') do set "StartLine=%%a"
more +%StartLine% "%~f0" > "%ReportEngine%"

powershell -ExecutionPolicy Bypass -File "%ReportEngine%" -StatusLog "%IncomingLog%" -FormID "%GFormID%" -TechNum "%TechSupportNumber%" -UrlLogo "%UrlLogo%" -IconPath "%IconPath%"

rmdir /s /q "%SystemDrive%\MontagTools" >nul 2>&1
exit
:: ============================================================
::  POWERSHELL REPORT ENGINE
:: ============================================================
:::__REPORT_START__:::
param(
    $StatusLog, 
    $FormID, 
    $TechNum, 
    $UrlLogo,
    $IconPath
)
$ErrorActionPreference = 'SilentlyContinue'

# Fallback for IconPath if missing
if (-not $IconPath) { $IconPath = "C:\ProgramData\MontagStore\Montag.ico" }

# --- 1. GATHER FULL SPECS ---
$sys = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_Bios
$Man = $sys.Manufacturer.Trim()
$Mod = $sys.Model.Trim()

if ($Mod.StartsWith($Man)) { 
    $FullModel = $Mod 
} else { 
    $FullModel = "$Man $Mod" 
}

# --- CPU ---
$cpu = @(Get-CimInstance Win32_Processor)[0]
$cpuName = $cpu.Name.Trim() -replace '\s+', ' '
$maxSpeed = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cacheMB = [int]($cpu.L3CacheSize / 1024)

if ($cacheMB -eq 0 -and $cpu.L2CacheSize) { 
    $cacheMB = [int]($cpu.L2CacheSize / 1024) 
}

$cacheStr = ""
if ($cacheMB -gt 0) { 
    $cacheStr = " | $cacheMB MB Cache" 
}

$cpuDetails = "$cpuName | $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads | $maxSpeed GHz$cacheStr"

$CpuLogo = "https://cdn.simpleicons.org/intel/0068B5"
if ($cpuName -match "AMD") { 
    $CpuLogo = "https://cdn.simpleicons.org/amd/ED1C24" 
}

# --- RAM ---
$memArray = @(Get-CimInstance Win32_PhysicalMemory)
$stickCount = $memArray.Count
$totalRam = [math]::Round(($memArray | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
$ramSpeed = 0

foreach ($s in $memArray) { 
    if ($s.Speed -gt 0) { 
        $ramSpeed = [math]::Max($ramSpeed, $s.Speed) 
    } 
}

if ($ramSpeed -eq 0) { 
    $ramSpeed = "Unknown" 
}

$ramDetails = "$totalRam GB Installed ($stickCount Sticks) @ $ramSpeed MHz"

# --- STORAGE (FIXED CLEAN OUTPUT) ---
$disks = Get-CimInstance Win32_DiskDrive | Where-Object { 
    ($_.MediaType -eq 'Fixed hard disk media') -and 
    ($_.InterfaceType -ne 'USB') 
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

# --- GPU ---
$gpuList = @()
$regBase = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'

Get-ChildItem $regBase -ErrorAction SilentlyContinue | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
    if ($props -and $props.DriverDesc) {
        $size = 0
        if ($null -ne $props.'HardwareInformation.QwMemorySize') { 
            $size = $props.'HardwareInformation.QwMemorySize' 
        } elseif ($null -ne $props.'HardwareInformation.MemorySize') { 
            $size = $props.'HardwareInformation.MemorySize' 
        }
        
        if ($size -is [array]) {
            try {
                if ($size.Count -ge 8) { $size = [BitConverter]::ToUInt64($size, 0) }
                elseif ($size.Count -ge 4) { $size = [BitConverter]::ToUInt32($size, 0) }
                else { $size = 0 }
            } catch { $size = 0 }
        }
        
        $gb = 0
        if ($size -gt 0) { 
            $gb = [math]::Round([uint64]$size / 1GB) 
        }
        
        if ($gb -gt 0) { 
            $gpuList += "$($props.DriverDesc) ($gb GB)" 
        } else { 
            $gpuList += $props.DriverDesc 
        }
    }
}

$gpuString = ($gpuList | Select-Object -Unique) -join " + "
if (-not $gpuString) { 
    $gpuString = "Standard Graphics Adapter" 
}

# --- BRAND LOGO ---
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
}
# ==========================================================
# 2. HTML UI (MAIN DASHBOARD - REDUCED LAPTOP GLOW)
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
        body { font-family: 'Outfit', sans-serif; background-color: var(--bg); color: #fff; margin: 0; padding: 20px; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; overflow-x: hidden; overflow-y: auto; position: relative; z-index: 1; }
        
        body::before, body::after { content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%; filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate; pointer-events: none; }
        body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } 
        body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } 
        @keyframes floatOrbs { 0% { transform: translate(0, 0) scale(1); } 100% { transform: translate(5%, 5%) scale(1.15); } }

        #splash { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: #000; z-index: 10000; display: flex; flex-direction: column; align-items: center; justify-content: center; transition: opacity 0.8s ease-in-out; }
        .splash-logo { width: 450px; filter: drop-shadow(0 0 40px var(--primary)); animation: constantNeonPulse 2.5s infinite alternate ease-in-out, splashFinalZoom 3s forwards; opacity: 0; }
        @keyframes splashFinalZoom { 0% { transform: scale(0.75) translateY(20px); opacity: 0; filter: brightness(0) blur(25px); } 30% { opacity: 1; filter: brightness(1.8) blur(0px); } 100% { transform: scale(1) translateY(0); opacity: 1; } }
        @keyframes constantNeonPulse { 0% { filter: drop-shadow(0 0 20px var(--primary)) brightness(0.9); } 100% { filter: drop-shadow(0 0 60px var(--primary)) brightness(1.4); } }
        
        .master-loader-box { width: 350px; height: 3px; background: rgba(255,255,255,0.02); margin: 40px auto 0; border-radius: 10px; overflow: hidden; opacity: 0; animation: fadeIn 0.5s 0.5s forwards; }
        .master-loader-fill { width: 0%; height: 100%; background: linear-gradient(90deg, var(--primary), var(--secondary)); box-shadow: 0 0 20px var(--secondary); animation: loaderMasterFill 2.5s ease-in-out forwards; }
        @keyframes loaderMasterFill { 0% { width: 0%; } 100% { width: 100%; } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        /* --- THE LOGO OUTSIDE --- */
        .outside-logo { display: flex; justify-content: center; margin-bottom: 20px; z-index: 10; }
        .outside-logo img { height: 200px; filter: drop-shadow(0 0 20px rgba(143, 0, 255, 0.8)); animation: pulseLogo 1.5s infinite alternate ease-in-out; }
        @keyframes pulseLogo { 0% { transform: scale(1); filter: drop-shadow(0 0 15px var(--primary)); } 100% { transform: scale(1.06); filter: drop-shadow(0 0 40px var(--primary)); } }

        /* --- MAIN CONTAINER --- */
        .container { max-width: 900px; width: 100%; background: var(--card-bg); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; padding: 35px 45px; box-shadow: 0 25px 60px -10px rgba(0,0,0,0.7); max-height: 85vh; overflow-y: auto; scroll-behavior: smooth; }
        .container::-webkit-scrollbar { width: 8px; }
        .container::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 4px; }

        .header-bar { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px; margin-bottom: 20px; }
        
        /* LAPTOP LOGO GLOW REDUCED */
        .header-bar img.laptop { justify-self: start; height: 110px; filter: drop-shadow(0 0 15px rgba(0, 229, 255, 0.5)); }
        
        .header-bar .title-box { justify-self: center; text-align: center; }
        .header-bar img.cpu { justify-self: end; height: 90px; filter: drop-shadow(0 0 15px rgba(255,255,255,0.2)); }

        .title-box h1 { margin: 0; font-size: 26px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; }
        .title-box p { margin: 4px 0 0 0; color: #a0a0ab; font-size: 13px; letter-spacing: 1px; }

        .specs-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .spec-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; padding: 15px 20px; border-left: 4px solid var(--primary); }
        .spec-label { font-size: 12px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; display: block; font-weight: 800; }
        .spec-value { font-size: 15px; font-weight: 500; }

        .input-group { margin-bottom: 15px; }
        label { display: block; font-size: 12px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; font-weight: 800; }
        
        input, textarea { width: 100%; padding: 14px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255, 255, 255, 0.1); color: #00e5ff; border-radius: 8px; font-family: inherit; margin-bottom: 10px; outline: none; box-sizing: border-box; font-size: 14px; }
        input:focus, textarea:focus { border-color: var(--primary); box-shadow: 0 0 10px rgba(143, 0, 255, 0.2); }

        .static-box { background: rgba(0, 0, 0, 0.5); border: 1px solid rgba(0, 229, 255, 0.3); color: #00e5ff; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 500; }

        #clientSection, #stockSection, #notesSection { display: none; background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 10px; padding: 15px; margin-bottom: 15px; }
        .flex-row { display: flex; gap: 15px; } .flex-row .input-group { flex: 1; margin-bottom: 0; }

        .btn-group { display: flex; gap: 15px; }
        .btn { flex: 1; padding: 16px; border: none; border-radius: 10px; cursor: pointer; font-weight: 800; font-size: 14px; text-transform: uppercase; transition: 0.3s; }
        .btn-sell { background: linear-gradient(45deg, #10b981, #059669); color: #fff; }
        .btn-test { background: linear-gradient(45deg, #3b82f6, #2563eb); color: #fff; }
        .btn-confirm { background: linear-gradient(45deg, #8f00ff, #c026d3); color: #fff; animation: pulse 2s infinite; }
        .btn-issue { background: linear-gradient(45deg, #ef4444, #dc2626); color: #fff; }

        .btn:hover { transform: translateY(-2px); }
        @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(143, 0, 255, 0); } 100% { box-shadow: 0 0 0 0 rgba(143, 0, 255, 0); } }
        
        .status-text { text-align: center; font-size: 14px; font-weight: 800; margin-top: 10px; padding: 12px; border-radius: 8px; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
    </style>
</head>
<body>
    <div id="splash">
        <div style="text-align:center;">
            <img src="$UrlLogo" class="splash-logo">
            <div class="master-loader-box"><div class="master-loader-fill"></div></div>
            <p style="color:#555; font-size:12px; margin-top:25px; letter-spacing:8px; opacity:0; animation: fadeIn 0.8s 1s forwards;">INITIALIZING SALES SYSTEM</p>
        </div>
    </div>

    <div class="outside-logo">
        <img src="$UrlLogo" alt="Montag Logo">
    </div>

    <div class="container" id="mainContainer">
        <div class="header-bar">
            <img src="$LaptopLogo" class="laptop">
            <div class="title-box">
                <h1>Montag Dashboard</h1>
                <p>Internal Sales & Testing System</p>
            </div>
            <img src="$CpuLogo" class="cpu">
        </div>

        <div class="input-group">
            <label>Tester Name</label>
            <input type="text" id="testerName" placeholder="Enter your name..." required>
        </div>
        
        <div class="specs-grid" id="specsData">
            <div class="spec-card" style="grid-column: 1 / -1; border-color: var(--secondary); padding: 15px;">
                <span class="spec-label">Model</span>
                <div class="spec-value" style="font-size: 20px; font-weight: bold;">$FullModel</div>
            </div>
            <div class="spec-card"><span class="spec-label">Serial</span><div class="spec-value" style="color:var(--secondary); font-size: 18px; font-weight:800;">$($bios.SerialNumber)</div></div>
            <div class="spec-card"><span class="spec-label">CPU</span><div class="spec-value">$cpuDetails</div></div>
            <div class="spec-card"><span class="spec-label">RAM</span><div class="spec-value">$ramDetails</div></div>
            <div class="spec-card"><span class="spec-label">GPU</span><div class="spec-value">$gpuString</div></div>
            <div class="spec-card" style="grid-column: 1 / -1; border-color: #ff007f;"><span class="spec-label">Storage</span><div class="spec-value">$storageString</div></div>
        </div>

        <div class="input-group">
            <label>System Checks (Read-Only)</label>
            <div id="checklistDisplay" class="static-box">$StatusLog</div>
        </div>
        
        <div id="clientSection">
            <label style="color: #10b981; margin-bottom: 10px; font-size: 13px;">Customer Details</label>
            <div class="flex-row">
                <div class="input-group"><input type="text" id="clientName" placeholder="Customer Name"></div>
                <div class="input-group"><input type="text" id="clientPhone" placeholder="Phone (e.g., 01xxxxxxxxx)"></div>
            </div>
        </div>

        <div id="stockSection">
            <label style="color: #3b82f6; text-align: center; font-size: 15px; margin-bottom: 10px;">Stock Condition Check</label>
            <div class="btn-group" id="stockButtons">
                <button class="btn btn-sell" onclick="submitStock('GOOD')">GOOD / PASS</button>
                <button class="btn btn-issue" onclick="showNotesForIssue()">HAS ISSUES</button>
            </div>
            <div id="stockFeedback" class="status-text" style="display:none;">CONDITION: HAS ISSUES</div>
        </div>

        <div id="notesSection">
            <div class="input-group">
                <label>Manual Notes / Issues</label>
                <textarea id="userNotes" rows="2" placeholder="Write observation or problem details here..."></textarea>
            </div>
            <button id="btnSubmitIssue" class="btn btn-issue" style="display:none; width:100%;" onclick="submitStock('ISSUE')">CONFIRM & UPLOAD REPORT</button>
        </div>

        <div class="btn-group" id="mainButtons">
            <button id="btnSell" class="btn btn-sell" onclick="handleSell()">SELL TO CUSTOMER</button>
            <button id="btnTest" class="btn btn-test" onclick="handleStock()">STOCK TEST ONLY</button>
        </div>
    </div>

    <script>
        window.moveTo(0, 0); window.resizeTo(screen.availWidth, screen.availHeight);

        setTimeout(function() { 
            var splashEl = document.getElementById('splash');
            if(splashEl) {
                splashEl.style.opacity = '0'; 
                setTimeout(function() { splashEl.style.display = 'none'; }, 800); 
            }
        }, 3000);

        function handleSell() {
            var section = document.getElementById('clientSection');
            var btn = document.getElementById('btnSell');
            var notes = document.getElementById('notesSection');
            
            document.getElementById('stockSection').style.display = 'none'; 
            document.getElementById('btnTest').style.display = 'none'; 
            notes.style.display = 'block';
            
            if (section.style.display === 'none' || section.style.display === '') {
                section.style.display = 'block';
                btn.innerText = "CONFIRM & UPLOAD"; btn.className = "btn btn-confirm"; 
                document.getElementById('clientName').focus();
                
                setTimeout(function() {
                    var container = document.getElementById('mainContainer');
                    if(container) { container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' }); }
                }, 100);
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
            
            setTimeout(function() {
                var container = document.getElementById('mainContainer');
                if(container) { container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' }); }
            }, 100);
        }

        function submitStock(condition) {
            if (condition === 'ISSUE') {
                var notes = document.getElementById('userNotes').value.trim();
                if (notes.length < 5) { alert("Please write details in the NOTES field!"); document.getElementById('userNotes').focus(); return; }
                sendData('TEST-ISSUE');
            } else { sendData('TEST-GOOD'); }
        }

        function sendData(type) {
            var tester = document.getElementById('testerName').value;
            if(!tester) { alert("Tester Name Required!"); return; }
            
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
            
            fetch(url, { mode: 'no-cors' }).then(() => {
                document.title = "MONTAG_EXIT_TRIGGER";
                document.body.innerHTML = "<h1 style='text-align:center; margin-top:20vh; color:var(--secondary);'>UPLOAD SUCCESSFUL!</h1>";
            });
        }
    </script>
</body>
</html>
"@

$htmlContent | Out-File "$env:TEMP\MontagSales.html" -Encoding UTF8

Start-Process "msedge" -ArgumentList "--new-window --start-maximized --app=`"$env:TEMP\MontagSales.html`""
Start-Sleep -Seconds 2

while ($true) {
    $edgeProcs = Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match "Montag Sales|MONTAG_EXIT_TRIGGER" }
    if ($edgeProcs) {
        if ($edgeProcs.MainWindowTitle -match "MONTAG_EXIT_TRIGGER") {
            Start-Sleep -Seconds 1 
            $edgeProcs | Stop-Process -Force -ErrorAction SilentlyContinue
            break 
        }
    } else {
        break 
    }
    Start-Sleep -Milliseconds 500
}
# ==========================================================
# 4. GENERATE COMPACT CLIENT REPORT (DESKTOP)
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
    body { font-family: 'Outfit', sans-serif; background-color: var(--bg); color: #fff; margin: 0; padding: 20px; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; overflow-x: hidden; overflow-y: auto; position: relative; z-index: 1; }

    body::before, body::after { content: ''; position: absolute; width: 60vw; height: 60vw; border-radius: 50%; filter: blur(120px); z-index: -1; animation: floatOrbs 3.5s infinite ease-in-out alternate; }
    body::before { background: rgba(0, 229, 255, 0.12); top: -15%; left: -10%; } 
    body::after { background: rgba(143, 0, 255, 0.20); bottom: -15%; right: -10%; animation-delay: -1.5s; } 
    @keyframes floatOrbs { 0% { transform: translate(0, 0) scale(1); } 100% { transform: translate(5%, 5%) scale(1.15); } }

    /* MONTAG LOGO ENLARGED TO MATCH DASHBOARD */
    .outside-logo { display: flex; justify-content: center; margin-bottom: 15px; z-index: 10; }
    .outside-logo img { height: 200px; filter: drop-shadow(0 0 20px rgba(143, 0, 255, 0.7)); animation: neonPulseTop 1.5s infinite alternate ease-in-out; }
    @keyframes neonPulseTop { 0% { filter: drop-shadow(0 0 10px rgba(143, 0, 255, 0.5)) scale(1); } 100% { filter: drop-shadow(0 0 40px rgba(143, 0, 255, 1)) scale(1.08); } }

    .container { max-width: 780px; width: 100%; background: var(--card-bg); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 20px; padding: 25px 30px; box-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.6); max-height: 85vh; overflow-y: auto; }
    .container::-webkit-scrollbar { width: 8px; }
    .container::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 4px; }
    
    .header { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 15px; margin-bottom: 20px; }
    
    /* LAPTOP GLOW REDUCED TO BE SUBTLE AND ELEGANT */
    .header img.brand { justify-self: start; height: 110px; width: auto; max-width: 140px; object-fit: contain; filter: drop-shadow(0 0 15px rgba(0, 229, 255, 0.4)); }
    
    .header .title-box { justify-self: center; text-align: center; }
    .header img.cpu-logo { justify-self: end; height: 80px; width: auto; max-width: 120px; object-fit: contain; filter: drop-shadow(0 0 15px rgba(255, 255, 255, 0.15)); }

    .title-box h1 { margin: 0; font-size: 24px; font-weight: 800; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-transform: uppercase; letter-spacing: 1px; }
    .title-box p { margin: 5px 0 0 0; color: #a0a0ab; font-size: 13px; letter-spacing: 1px; }

    .specs-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 12px; }
    .spec-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 12px 18px; transition: all 0.3s ease; position: relative; overflow: hidden; border-left: 4px solid var(--primary); }
    .spec-card:hover { transform: translateY(-3px); border-color: rgba(143, 0, 255, 0.5); box-shadow: 0 10px 20px rgba(143, 0, 255, 0.15); background: rgba(255, 255, 255, 0.05); }
    .spec-label { font-size: 11px; color: #a0a0ab; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; display: block; font-weight: 800; }
    .spec-value { font-size: 15px; font-weight: 500; color: #fff; }
    
    .actions { margin-top: 25px; display: flex; gap: 12px; flex-wrap: wrap; }
    .btn { flex: 1; min-width: 180px; padding: 12px; border: none; border-radius: 8px; font-family: inherit; font-size: 13px; font-weight: 800; cursor: pointer; text-transform: uppercase; transition: all 0.3s ease; text-align: center; text-decoration: none; display: flex; justify-content: center; align-items: center; gap: 10px; }
    .btn-copy { background: rgba(255, 255, 255, 0.1); color: #fff; border: 1px solid rgba(255, 255, 255, 0.2); }
    .btn-copy:hover { background: rgba(255, 255, 255, 0.2); transform: translateY(-2px); }
    .btn-warranty { background: linear-gradient(45deg, #007bff, #00d2ff); color: #fff; box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3); }
    .btn-warranty:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0, 123, 255, 0.5); }
    .btn-whatsapp { background: linear-gradient(45deg, #25D366, #128C7E); color: #fff; box-shadow: 0 5px 15px rgba(37, 211, 102, 0.3); }
    .btn-whatsapp:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(37, 211, 102, 0.5); }
</style>
</head>
<body>

<div class="outside-logo">
    <img src="$UrlLogo" alt="Montag Store">
</div>

<div class="container">
    <div class="header">
        <img src="$LaptopLogo" alt="Brand" class="brand">
        <div class="title-box">
            <h1>Device Inspection</h1>
            <p>Tested and Verified By Montag Store</p>
        </div>
        <img src="$CpuLogo" alt="CPU" class="cpu-logo">
    </div>

    <div class="specs-grid" id="specsData">
        <div class="spec-card" style="grid-column: 1 / -1; border-color: var(--secondary);">
            <span class="spec-label">Model</span>
            <div class="spec-value" style="font-size: 20px; font-weight: bold;">$FullModel</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Serial Number</span>
            <div class="spec-value" style="color:var(--secondary); font-size: 17px; font-weight:800;">$($bios.SerialNumber)</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Processor (CPU)</span>
            <div class="spec-value">$cpuDetails</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Graphics (GPU)</span>
            <div class="spec-value">$gpuString</div>
        </div>
        <div class="spec-card">
            <span class="spec-label">Installed RAM</span>
            <div class="spec-value">$ramDetails</div>
        </div>
        <div class="spec-card" style="border-color: #ff007f;">
            <span class="spec-label">Primary Storage</span>
            <div class="spec-value">$storageString</div>
        </div>
        <div class="spec-card" style="grid-column: 1 / -1; border-color: #00e5ff;">
            <span class="spec-label" style="color:#00e5ff;">Inspection Checklist / Condition</span>
            <div class="spec-value" style="font-family: monospace; color:#ccc;">$StatusLog</div>
        </div>
    </div>

    <div class="actions">
        <button class="btn btn-copy" onclick="copySpecs(this)">COPY SPECS</button>
        <button class="btn btn-warranty" onclick="handleWarranty(this)">CHECK WARRANTY</button>
        <a href="https://wa.me/$TechNum" target="_blank" class="btn btn-whatsapp">CONTACT SUPPORT</a>
    </div>
</div>

<script>
    window.moveTo(0, 0); window.resizeTo(screen.availWidth, screen.availHeight);

    function forceCopyText(text) {
        var textArea = document.createElement("textarea"); textArea.value = text;
        textArea.style.position = "fixed"; textArea.style.left = "-999999px"; 
        document.body.appendChild(textArea); textArea.focus(); textArea.select();
        document.execCommand("copy"); document.body.removeChild(textArea);
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
        setTimeout(function() { window.open("$WarrantyLink", "_blank"); btn.innerHTML = originalText; }, 800);
    }
</script>
</body>
</html>
"@

$ClientReport | Out-File "$RealHtmlFile" -Encoding UTF8

# === ORIGINAL ICON FIX ===
$ShortcutContent = "[InternetShortcut]`r`nURL=file:///$RealHtmlFile`r`nIconIndex=0`r`nIconFile=$IconPath"
[System.IO.File]::WriteAllText($DesktopShortcut, $ShortcutContent)