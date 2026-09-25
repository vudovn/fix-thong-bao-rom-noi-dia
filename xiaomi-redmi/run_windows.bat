@echo off
chcp 65001 >nul
title Xiaomi / Redmi Notification Fix ^& Debloat Tool (Windows)
color 0e

echo ======================================================================
echo    XIAOMI / REDMI NOTIFICATION FIX ^& DEBLOAT TOOL (WINDOWS)
echo       Hỗ trợ tối ưu thông báo ^& dọn rác cho HyperOS ^& MIUI
echo ======================================================================
echo.

:: 1. KIỂM TRA VÀ TỰ TẢI ADB CHO WINDOWS NẾU CHƯA CÓ
set "BIN_DIR=%~dp0..\bin"
set "ADB_BIN=adb"

where adb >nul 2>nul
if %errorlevel% equ 0 (
    echo [✔] Đã tìm thấy ADB trên hệ thống Windows!
    goto :CHECK_DEVICE
)

if exist "%BIN_DIR%\platform-tools\adb.exe" (
    set "ADB_BIN=%BIN_DIR%\platform-tools\adb.exe"
    echo [✔] Đã tìm thấy ADB cục bộ trong thư mục bin!
    goto :CHECK_DEVICE
)

echo [!] Máy tính chưa có ADB. Đang tự động tải Google Platform-Tools về...
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

set "URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
set "ZIP_PATH=%BIN_DIR%\platform-tools.zip"

echo [*] Đang tải từ máy chủ Google: %URL%
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%URL%', '%ZIP_PATH%')"

echo [*] Đang giải nén ADB...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%BIN_DIR%' -Force"
del /f /q "%ZIP_PATH%" >nul 2>nul

set "ADB_BIN=%BIN_DIR%\platform-tools\adb.exe"
echo [✔] Đã thiết lập xong ADB cho Windows thành công!
echo.

:: 2. KIỂM TRA THIẾT BỊ
:CHECK_DEVICE
echo [*] Đang kiểm tra kết nối điện thoại Xiaomi qua USB...
"%ADB_BIN%" start-server >nul 2>nul

for /f "tokens=1,2" %%A in ('"%ADB_BIN%" devices ^| findstr /v "List" ^| findstr /r "[a-zA-Z0-9]"') do (
    if "%%B"=="device" (
        goto :DEVICE_OK
    )
    if "%%B"=="unauthorized" (
        echo [!] CẢNH BÁO: Thiết bị chưa được ủy quyền!
        echo [?] Hãy mở khóa màn hình điện thoại, tích vào 'Luôn cho phép từ máy tính này' rồi bấm OK.
        pause
        goto :CHECK_DEVICE
    )
)

echo [X] Chưa phát hiện điện thoại nào kết nối!
echo.
echo [?] Hướng dẫn bật Gỡ lỗi trên Xiaomi / HyperOS / MIUI:
echo   1. Vào Cài đặt ^> Giới thiệu điện thoại ^> Bấm 7 lần vào 'Phiên bản OS / MIUI'.
echo   2. Vào Cài đặt bổ sung ^> Tùy chọn nhà phát triển:
echo      - Bật 'Gỡ lỗi USB'.
echo      - Bật 'Cài đặt qua USB'.
echo      - Bật 'Gỡ lỗi USB (Cài đặt bảo mật)' (Yêu cầu đăng nhập tài khoản Mi).
echo   3. Cắm cáp, chọn 'Luôn cho phép từ máy tính này' rồi nhấn OK.
echo.
pause
goto :CHECK_DEVICE

:DEVICE_OK
for /f "delims=" %%I in ('"%ADB_BIN%" shell getprop ro.product.model') do set "DEV_MODEL=%%I"
for /f "delims=" %%I in ('"%ADB_BIN%" shell getprop ro.build.display.id') do set "DEV_ROM=%%I"
echo [✔] Đã kết nối thiết bị: %DEV_MODEL% (ROM: %DEV_ROM%)
echo.

:: 3. MENU CHÍNH
:MENU
cls
echo ======================================================================
echo    XIAOMI / REDMI NOTIFICATION FIX ^& DEBLOAT TOOL (WINDOWS)
echo    Thiết bị: %DEV_MODEL% ^| ROM: %DEV_ROM%
echo ======================================================================
echo.
echo VUI LÒNG CHỌN CHỨC NĂNG:
echo   [1] 🚀 CHẠY TẤT CẢ (Khuyên dùng): Fix 6 bước thông báo + Dọn rác quảng cáo
echo   [2] 🔔 Chỉ Fix trễ thông báo 6 bước (Phantom killer, Doze, Standby, WiFi)
echo   [3] 🧹 Chỉ Dọn app rác ^& quảng cáo MIUI/HyperOS (MSA, Analytics, Mi Video...)
echo   [4] 🔄 Khôi phục các app hệ thống đã tắt
echo   [0] ❌ Thoát
echo ======================================================================
set /p choice="Nhập lựa chọn của bạn [0-4]: "

if "%choice%"=="1" goto :ALL_IN_ONE
if "%choice%"=="2" goto :FIX_NOTI
if "%choice%"=="3" goto :DEBLOAT
if "%choice%"=="4" goto :RESTORE
if "%choice%"=="0" goto :EXIT
goto :MENU

:ALL_IN_ONE
call :DO_FIX_NOTI
call :DO_DEBLOAT
echo.
echo [🎉] ĐÃ HOÀN TẤT TOÀN BỘ CÁC BƯỚC CHO XIAOMI!
pause
goto :MENU

:FIX_NOTI
call :DO_FIX_NOTI
pause
goto :MENU

:DO_FIX_NOTI
echo.
echo ======================================================================
echo       TIẾN HÀNH FIX TRỄ THÔNG BÁO CHO XIAOMI (HYPEROS / MIUI)
echo ======================================================================
echo [*] [1/6] Nới lỏng Phantom Process Killer...
"%ADB_BIN%" shell /system/bin/device_config put activity_manager max_phantom_processes 2147483647 >nul 2>nul
"%ADB_BIN%" shell device_config put activity_manager max_cached_processes 256 >nul 2>nul
"%ADB_BIN%" shell device_config put activity_manager max_empty_time_millis 43200000 >nul 2>nul
echo   [✔] max_phantom_processes = vô hạn, max_cached_processes = 256

echo [*] [2/6] Tắt cơ chế ép ngủ Adaptive Battery ^& App Standby...
"%ADB_BIN%" shell settings put global adaptive_battery_management_enabled 0 >nul 2>nul
"%ADB_BIN%" shell settings put global app_standby_enabled 0 >nul 2>nul
"%ADB_BIN%" shell settings put global forced_app_standby_enabled 0 >nul 2>nul
"%ADB_BIN%" shell settings put global aggressive_battery 0 >nul 2>nul
echo   [✔] Đã tắt hạn chế ngủ sâu của pin.

echo [*] [3/6] Cấp quyền miễn ngủ đông (Doze Whitelist) cho 50+ app...
for %%P in (
    com.google.android.gms com.google.android.gsf com.android.vending
    com.google.android.googlequicksearchbox com.google.android.apps.maps
    com.xiaomi.xmsf com.xiaomi.xmsfkeeper com.miui.notification
    com.zing.zalo com.facebook.orca com.facebook.katana com.facebook.pages.app
    org.telegram.messenger com.whatsapp com.whatsapp.w4b com.viber.voip
    com.instagram.android com.instagram.barcelona com.twitter.android com.discord
    com.locket.Locket com.ss.android.ugc.trill com.ss.android.ugc.aweme com.tencent.mm
    jp.naver.line.android com.skype.raider com.microsoft.teams com.Slack com.linkedin.android
    com.google.android.gm com.microsoft.office.outlook
    com.openai.chatgpt ai.x.grok com.google.android.apps.bard com.anthropic.claude com.github.android
    com.vnid com.etax.icanhan vss.gov.vssapp com.windyty.android
    com.grabtaxi.passenger com.gsm.customer com.shopee.vn com.deliverynow com.be.customer
    com.chotot.vn com.bachhoaxanh com.alibaba.aliexpresshd com.lazada.android vn.tiki.app.tikiandroid
    com.mbmobile com.vnpay.vpbankonline com.VCB vn.com.techcombank.bb.app com.vnpay.bidv
    com.vietinbank.ipay mobile.acb.com.vn vn.tpbank.mb com.mservice.momotransfer
    vn.com.vng.zalopay vn.viettel.viettelpay vn.com.hdsaison.hpo com.paypal.android.p2pmobile com.sepay.trans
    com.binance.dev com.bybit.app io.metamask app.phantom
    com.google.android.apps.authenticator2 com.azure.authenticator com.valvesoftware.android.steam.community
) do (
    "%ADB_BIN%" shell pm path %%P >nul 2>nul
    if not errorlevel 1 (
        "%ADB_BIN%" shell dumpsys deviceidle whitelist +%%P >nul 2>nul
        echo   [✔] Doze Whitelist: %%P
    )
)

echo [*] [4/6] Thiết lập Standby Bucket = ACTIVE cho các app liên lạc...
for %%P in (
    com.google.android.gms com.google.android.gsf com.xiaomi.xmsf
    com.zing.zalo com.facebook.orca com.facebook.katana org.telegram.messenger
    com.whatsapp com.google.android.gm com.vnid com.mbmobile
) do (
    "%ADB_BIN%" shell pm path %%P >nul 2>nul
    if not errorlevel 1 (
        "%ADB_BIN%" shell am set-standby-bucket %%P active >nul 2>nul
    )
)
echo   [✔] Đã đưa các app chính vào trạng thái Standby ACTIVE.

echo [*] [5/6] Tối ưu hóa giữ kết nối WiFi ^& Google FCM khi màn hình tắt...
"%ADB_BIN%" shell settings put global wifi_sleep_policy 2 >nul 2>nul
"%ADB_BIN%" shell settings put global wifi_idle_ms 2147483647 >nul 2>nul
"%ADB_BIN%" shell settings put global always_finish_activities 0 >nul 2>nul
"%ADB_BIN%" shell settings put global wifi_wakeup_enabled 1 >nul 2>nul
echo   [✔] WiFi luôn giữ kết nối ngầm nhận thông báo.

echo [*] [6/6] Tối ưu hóa HyperOS / MIUI PowerKeeper ^& JobScheduler...
"%ADB_BIN%" shell setprop persist.sys.max_bg_processes 60 >nul 2>nul
"%ADB_BIN%" shell settings put global restrict_background 0 >nul 2>nul
"%ADB_BIN%" shell device_config put jobscheduler qc_timing_constraints_enabled false >nul 2>nul
"%ADB_BIN%" shell device_config put jobscheduler qc_updated_jobs_per_uid_window 99999 >nul 2>nul
echo   [✔] Đã tối ưu hóa lịch trình tác vụ JobScheduler.

echo [🎉] ĐÃ HOÀN TẤT FIX THÔNG BÁO CHO XIAOMI!
goto :eof

:DEBLOAT
call :DO_DEBLOAT
pause
goto :MENU

:DO_DEBLOAT
echo.
echo ======================================================================
echo       TIẾN HÀNH DỌN DẸP APP RÁC ^& QUẢNG CÁO XIAOMI / HYPEROS
echo ======================================================================
for %%P in (
    com.miui.analytics
    com.miui.systemAdSolution
    com.miui.msa.global
    com.android.browser
    com.miui.video
    com.miui.player
    com.miui.yellowpage
    com.xiaomi.mirecycle
    com.miui.bugreport
    com.xiaomi.gamecenter
    com.miui.hybrid
    com.miui.hybrid.accessory
) do (
    "%ADB_BIN%" shell pm path %%P >nul 2>nul
    if not errorlevel 1 (
        "%ADB_BIN%" shell pm disable-user --user 0 %%P >nul 2>nul
        echo   [✔] Đã tắt app rác/quảng cáo: %%P
    )
)
echo [🎉] Đã dọn dẹp sạch sẽ quảng cáo MIUI/HyperOS!
goto :eof

:RESTORE
echo.
echo ======================================================================
echo            KHÔI PHỤC CÁC APP HỆ THỐNG GỐC CỦA XIAOMI
echo ======================================================================
for %%P in (
    com.miui.analytics com.miui.systemAdSolution com.miui.msa.global
    com.android.browser com.miui.video com.miui.player com.miui.yellowpage
    com.xiaomi.mirecycle com.miui.bugreport com.xiaomi.gamecenter
    com.miui.hybrid com.miui.hybrid.accessory
) do (
    "%ADB_BIN%" shell pm enable %%P >nul 2>nul
    echo   [✔] Đã bật lại: %%P
)
echo [🎉] Đã khôi phục các app hệ thống về mặc định!
pause
goto :MENU

:EXIT
echo Tạm biệt! Cảm ơn bạn đã sử dụng tool.
timeout /t 2 >nul
exit /b
