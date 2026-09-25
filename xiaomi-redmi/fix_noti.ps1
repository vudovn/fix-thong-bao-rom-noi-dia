# ============================================================
#  FIX THONG BAO XIAOMI - ROM NOI DIA CN (HYPEROS / MIUI)
#  Ho tro: HyperOS / MIUI tren Android 12, 13, 14, 15, 16, 17
#  Chay bang: powershell -ExecutionPolicy Bypass -File fix_noti.ps1
# ============================================================

# 1. TIM HOAC TU DONG TAI ADB
$ADB = "adb"
if (Get-Command "adb" -ErrorAction SilentlyContinue) {
    $ADB = "adb"
} elseif (Test-Path "$PSScriptRoot\..\bin\platform-tools\adb.exe") {
    $ADB = "$PSScriptRoot\..\bin\platform-tools\adb.exe"
} else {
    Write-Host "[!] Dang tu dong tai Google Platform-Tools ve..." -ForegroundColor Yellow
    $binDir = "$PSScriptRoot\..\bin"
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
    $zipPath = "$binDir\platform-tools.zip"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    (New-Object System.Net.WebClient).DownloadFile("https://dl.google.com/android/repository/platform-tools-latest-windows.zip", $zipPath)
    Expand-Archive -Path $zipPath -DestinationPath $binDir -Force
    Remove-Item -Force $zipPath -ErrorAction SilentlyContinue
    $ADB = "$binDir\platform-tools\adb.exe"
}

function Write-Step($msg) {
    Write-Host "`n>>> $msg" -ForegroundColor Cyan
}

function Write-OK($msg) {
    Write-Host "    [OK] $msg" -ForegroundColor Green
}

function Write-WARN($msg) {
    Write-Host "    [!!] $msg" -ForegroundColor Yellow
}

# ─────────────────────────────────────────
# KIEM TRA KET NOI
# ─────────────────────────────────────────
Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "   FIX THONG BAO XIAOMI - ROM NOI DIA CN   " -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

Write-Step "Kiem tra ket noi ADB..."
& $ADB start-server 2>&1 | Out-Null
Start-Sleep -Seconds 1
$devices = & $ADB devices 2>&1
if ($devices -notmatch "\tdevice") {
    Write-Host "    [FAIL] Khong tim thay thiet bi! Kiem tra lai ket noi USB & Bat USB Debugging." -ForegroundColor Red
    exit 1
}
Write-OK "Da ket noi thanh cong!"

# ─────────────────────────────────────────
# BUOC 1: FIX PHANTOM PROCESS KILLER
# ─────────────────────────────────────────
Write-Step "BUOC 1/6 - Fix Phantom Process Killer..."
& $ADB shell /system/bin/device_config put activity_manager max_phantom_processes 2147483647 2>&1 | Out-Null
Write-OK "max_phantom_processes = 2147483647 (vo han)"

& $ADB shell device_config put activity_manager max_cached_processes 256 2>&1 | Out-Null
Write-OK "max_cached_processes = 256"

& $ADB shell device_config put activity_manager max_empty_time_millis 43200000 2>&1 | Out-Null
Write-OK "max_empty_time_millis = 12 gio"

# ─────────────────────────────────────────
# BUOC 2: TAT ADAPTIVE BATTERY & BATTERY OPTIMIZATION
# ─────────────────────────────────────────
Write-Step "BUOC 2/6 - Tat Adaptive Battery..."
& $ADB shell settings put global adaptive_battery_management_enabled 0 2>&1 | Out-Null
Write-OK "adaptive_battery_management_enabled = 0"

& $ADB shell settings put global app_standby_enabled 0 2>&1 | Out-Null
Write-OK "app_standby_enabled = 0"

& $ADB shell settings put global forced_app_standby_enabled 0 2>&1 | Out-Null
Write-OK "forced_app_standby_enabled = 0"

& $ADB shell settings put global aggressive_battery 0 2>&1 | Out-Null
Write-OK "aggressive_battery = 0"

# ─────────────────────────────────────────
# BUOC 3: WHITELIST DOZE MODE (50+ APPS)
# ─────────────────────────────────────────
Write-Step "BUOC 3/6 - Whitelist Doze Mode cho cac app quan trong..."

$dozeApps = @(
    "com.google.android.gms",
    "com.google.android.gsf",
    "com.android.vending",
    "com.google.android.googlequicksearchbox",
    "com.google.android.apps.maps",
    "com.xiaomi.xmsf",
    "com.xiaomi.xmsfkeeper",
    "com.miui.notification",
    "com.zing.zalo",
    "vn.com.vng.zalopay",
    "com.facebook.orca",
    "com.facebook.katana",
    "com.facebook.pages.app",
    "org.telegram.messenger",
    "com.whatsapp",
    "com.whatsapp.w4b",
    "com.viber.voip",
    "com.instagram.android",
    "com.instagram.barcelona",
    "com.twitter.android",
    "com.discord",
    "com.locket.Locket",
    "com.ss.android.ugc.trill",
    "com.ss.android.ugc.aweme",
    "com.tencent.mm",
    "com.google.android.gm",
    "com.microsoft.office.outlook",
    "com.openai.chatgpt",
    "ai.x.grok",
    "com.google.android.apps.bard",
    "com.github.android",
    "com.vnid",
    "com.etax.icanhan",
    "vss.gov.vssapp",
    "com.windyty.android",
    "com.grabtaxi.passenger",
    "com.gsm.customer",
    "com.shopee.vn",
    "com.deliverynow",
    "com.be.customer",
    "com.chotot.vn",
    "com.bachhoaxanh",
    "com.alibaba.aliexpresshd",
    "com.mbmobile",
    "com.vnpay.vpbankonline",
    "com.VCB",
    "vn.com.techcombank.bb.app",
    "com.vnpay.bidv",
    "com.vietinbank.ipay",
    "mobile.acb.com.vn",
    "vn.tpbank.mb",
    "com.mservice.momotransfer",
    "vn.com.hdsaison.hpo",
    "com.paypal.android.p2pmobile",
    "com.sepay.trans",
    "com.binance.dev",
    "com.bybit.app",
    "io.metamask",
    "app.phantom",
    "com.google.android.apps.authenticator2",
    "com.azure.authenticator",
    "com.valvesoftware.android.steam.community"
)

foreach ($pkg in $dozeApps) {
    & $ADB shell dumpsys deviceidle whitelist "+$pkg" 2>&1 | Out-Null
    Write-OK "Doze whitelist: $pkg"
}

# ─────────────────────────────────────────
# BUOC 4: DAT STANDBY BUCKET -> ACTIVE
# ─────────────────────────────────────────
Write-Step "BUOC 4/6 - Dat standby bucket ACTIVE cho cac app..."

foreach ($pkg in $dozeApps) {
    & $ADB shell am set-standby-bucket $pkg active 2>&1 | Out-Null
}
Write-OK "Da dat Standby Bucket ACTIVE"

# ─────────────────────────────────────────
# BUOC 5: FIX WIFI DOZE
# ─────────────────────────────────────────
Write-Step "BUOC 5/6 - Fix WiFi Doze & ket noi FCM..."

& $ADB shell settings put global wifi_sleep_policy 2 2>&1 | Out-Null
Write-OK "wifi_sleep_policy = 2 (khong ngu)"

& $ADB shell settings put global wifi_idle_ms 2147483647 2>&1 | Out-Null
Write-OK "wifi_idle_ms = max (khong ngat wifi)"

& $ADB shell settings put global always_finish_activities 0 2>&1 | Out-Null
Write-OK "always_finish_activities = 0"

& $ADB shell settings put global wifi_wakeup_enabled 1 2>&1 | Out-Null
Write-OK "wifi_wakeup_enabled = 1"

# ─────────────────────────────────────────
# BUOC 6: TOI UU MIUI/HYPEROS POWERKEEPER
# ─────────────────────────────────────────
Write-Step "BUOC 6/6 - Toi uu HyperOS PowerKeeper..."

& $ADB shell setprop persist.sys.max_bg_processes 60 2>&1 | Out-Null
Write-OK "max_bg_processes = 60"

& $ADB shell settings put global restrict_background 0 2>&1 | Out-Null
Write-OK "restrict_background = 0"

& $ADB shell device_config put jobscheduler qc_timing_constraints_enabled false 2>&1 | Out-Null
Write-OK "jobscheduler qc_timing_constraints = disabled"

& $ADB shell device_config put jobscheduler qc_updated_jobs_per_uid_window 99999 2>&1 | Out-Null
Write-OK "jobscheduler jobs per uid = 99999"

# ─────────────────────────────────────────
# HOAN THANH
# ─────────────────────────────────────────
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   HOAN THANH! Da fix xong thong bao Xiaomi " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
