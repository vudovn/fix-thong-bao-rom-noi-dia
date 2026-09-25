@echo off
chcp 65001 >nul
title ColorOS Notification Fix ^& Debloat Tool (Windows)
color 0b

echo ======================================================================
echo       COLOROS NOTIFICATION FIX ^& DEBLOAT TOOL (WINDOWS)
echo    Hỗ trợ tối ưu thông báo ^& dọn app rác cho OPPO / OnePlus / Realme
echo ======================================================================
echo.

:: 1. KIỂM TRA VÀ TỰ TẢI ADB CHO WINDOWS NẾU CHƯA CÓ
set "BIN_DIR=%~dp0bin"
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

echo [!] Máy tính của bạn chưa có ADB. Đang tự động tải Google Platform-Tools về...
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
echo [*] Đang kiểm tra kết nối điện thoại qua USB...
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
echo [?] Hướng dẫn bật gỡ lỗi USB:
echo   1. Cắm cáp kết nối điện thoại với máy tính.
echo   2. Vào Cài đặt ^> Giới thiệu thiết bị ^> Bấm 7 lần vào 'Số bản dựng'.
echo   3. Vào Cài đặt bổ sung ^> Tùy chọn nhà phát triển ^> Bật 'Gỡ lỗi USB'.
echo   4. Mở khóa màn hình điện thoại, chọn 'Luôn cho phép từ máy tính này' rồi nhấn OK.
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
echo       COLOROS NOTIFICATION FIX ^& DEBLOAT TOOL (WINDOWS)
echo       Thiết bị: %DEV_MODEL% ^| ROM: %DEV_ROM%
echo ======================================================================
echo.
echo VUI LÒNG CHỌN CHỨC NĂNG:
echo   [1] 🚀 CHẠY TẤT CẢ (Khuyên dùng): Fix thông báo + Dọn app rác (Giữ AI)
echo   [2] 🔔 Chỉ Fix trễ thông báo (Tắt Athena + Whitelist 50+ app)
echo   [3] 🧹 Chỉ Dọn app rác nội địa Trung (Tùy chọn giữ/tắt Trợ lý ảo)
echo   [4] 🔍 Kiểm tra trạng thái thiết bị ^& kết nối Google Push
echo   [5] 🔄 Khôi phục hệ thống về mặc định (Hoàn tác mọi cài đặt)
echo   [0] ❌ Thoát
echo ======================================================================
set /p choice="Nhập lựa chọn của bạn [0-5]: "

if "%choice%"=="1" goto :ALL_IN_ONE
if "%choice%"=="2" goto :FIX_NOTI
if "%choice%"=="3" goto :DEBLOAT
if "%choice%"=="4" goto :STATUS
if "%choice%"=="5" goto :RESTORE
if "%choice%"=="0" goto :EXIT
goto :MENU

:: --------------------------------------------------------------------------
:ALL_IN_ONE
call :DO_FIX_NOTI
call :DO_DEBLOAT 1
echo.
echo [🎉] ĐÃ HOÀN TẤT CẢ HAI BƯỚC THÀNH CÔNG!
pause
goto :MENU

:FIX_NOTI
call :DO_FIX_NOTI
pause
goto :MENU

:DO_FIX_NOTI
echo.
echo ======================================================================
echo            TIẾN HÀNH FIX TRỄ THÔNG BÁO COLOROS
echo ======================================================================
echo [*] [1/2] Đang tắt trình diệt ngầm hung hãn (com.oplus.athena)...
"%ADB_BIN%" shell pm disable-user --user 0 com.oplus.athena >nul 2>nul
"%ADB_BIN%" shell pm disable-user --user 999 com.oplus.athena >nul 2>nul
echo [✔] Đã tắt com.oplus.athena trên User 0 và User 999.

echo [*] [2/2] Cấp quyền miễn ngủ đông (Doze Whitelist) cho 50+ app phổ biến...
for %%P in (
    com.zing.zalo com.facebook.orca com.facebook.katana com.facebook.pages.app
    org.telegram.messenger com.whatsapp com.whatsapp.w4b com.viber.voip
    com.instagram.android com.instagram.barcelona com.twitter.android com.discord
    com.locket.Locket com.ss.android.ugc.trill com.ss.android.ugc.aweme com.tencent.mm
    jp.naver.line.android com.skype.raider com.microsoft.teams com.Slack com.linkedin.android
    com.google.android.gm com.microsoft.office.outlook com.android.email
    com.openai.chatgpt ai.x.grok com.google.android.apps.bard com.anthropic.claude com.github.android
    com.vnid com.etax.icanhan vss.gov.vssapp com.windyty.android
    com.grabtaxi.passenger com.gsm.customer com.shopee.vn com.deliverynow com.be.customer
    com.chotot.vn com.bachhoaxanh com.alibaba.aliexpresshd com.lazada.android vn.tiki.app.tikiandroid
    com.mbmobile com.vnpay.vpbankonline com.VCB vn.com.techcombank.bb.app com.vnpay.bidv
    com.vietinbank.ipay mobile.acb.com.vn vn.tpbank.mb com.mservice.momotransfer
    vn.com.vng.zalopay vn.viettel.viettelpay vn.com.hdsaison.hpo com.paypal.android.p2pmobile com.sepay.trans
    com.binance.dev com.bybit.app com.okinc.okex.gp io.metamask app.phantom
    com.google.android.apps.authenticator2 com.azure.authenticator com.valvesoftware.android.steam.community
    com.google.android.gms com.google.android.gsf com.android.vending com.google.android.apps.maps
) do (
    "%ADB_BIN%" shell pm path %%P >nul 2>nul
    if not errorlevel 1 (
        "%ADB_BIN%" shell dumpsys deviceidle whitelist +%%P >nul 2>nul
        echo   [✔] Đã thêm vào Whitelist: %%P
    )
)
echo [✔] Đã hoàn tất danh sách Whitelist!
goto :eof

:: --------------------------------------------------------------------------
:DEBLOAT
echo.
echo Bạn có muốn giữ lại Trợ lý ảo tiếng Trung (Breeno / AI Voice) không?
echo   [1] CÓ, giữ lại Trợ lý ảo (Khuyên dùng)
echo   [2] KHÔNG, tắt luôn cả Trợ lý ảo
set /p ai_opt="Chọn [1 hoặc 2, mặc định 1]: "
if "%ai_opt%"=="" set "ai_opt=1"

call :DO_DEBLOAT %ai_opt%
pause
goto :MENU

:DO_DEBLOAT
echo.
echo ======================================================================
echo            TIẾN HÀNH DỌN DẸP APP RÁC NỘI ĐỊA TRUNG
echo ======================================================================
for %%P in (
    com.heytap.pictorial
    com.heytap.browser
    com.coloros.assistantscreen
    com.heytap.quicksearchbox
    com.oplus.pay
    com.nearme.instant.platform
    com.oppo.instant.local.service
    com.coloros.operationManual
    com.coloros.karaoke
) do (
    "%ADB_BIN%" shell pm path %%P >nul 2>nul
    if not errorlevel 1 (
        "%ADB_BIN%" shell pm disable-user --user 0 %%P >nul 2>nul
        echo   [✔] Đã tắt app rác: %%P
    )
)

if "%1"=="2" (
    "%ADB_BIN%" shell pm disable-user --user 0 com.heytap.speechassist >nul 2>nul
    "%ADB_BIN%" shell pm disable-user --user 0 com.oplus.ovoicemanager >nul 2>nul
    echo   [✔] Đã tắt Trợ lý ảo tiếng Trung.
) else (
    echo   [✔] Đã giữ nguyên Trợ lý ảo tiếng Trung (Breeno / AI).
)
echo [🎉] Đã dọn dẹp app rác hoàn tất!
goto :eof

:: --------------------------------------------------------------------------
:STATUS
echo.
echo ======================================================================
echo            KIỂM TRA TRẠNG THÁI THIẾT BỊ
echo ======================================================================
echo 1. Trình diệt ngầm com.oplus.athena:
"%ADB_BIN%" shell pm list packages -d | findstr /i "com.oplus.athena" >nul 2>nul
if %errorlevel% equ 0 (
    echo    [✔] ĐANG TẮT (Tốt - Không bị kill app ngầm)
) else (
    echo    [!] ĐANG BẬT (Có thể làm trễ thông báo)
)

echo 2. Cổng kết nối Google Push (FCM):
for /f "delims=" %%I in ('"%ADB_BIN%" shell dumpsys activity service com.google.android.gms/.gcm.GcmService ^| findstr /i "connected="') do (
    echo    [✔] %%I
)
echo.
pause
goto :MENU

:: --------------------------------------------------------------------------
:RESTORE
echo.
echo ======================================================================
echo            KHÔI PHỤC TRẠNG THÁI GỐC CỦA MÁY
echo ======================================================================
echo [*] Đang bật lại trình Athena...
"%ADB_BIN%" shell pm enable com.oplus.athena >nul 2>nul
"%ADB_BIN%" shell pm enable --user 999 com.oplus.athena >nul 2>nul

echo [*] Đang khôi phục lại các ứng dụng hệ thống đã tắt...
for %%P in (
    com.heytap.pictorial com.heytap.browser com.coloros.assistantscreen
    com.heytap.quicksearchbox com.oplus.pay com.nearme.instant.platform
    com.oppo.instant.local.service com.coloros.operationManual com.coloros.karaoke
    com.heytap.speechassist com.oplus.ovoicemanager
) do (
    "%ADB_BIN%" shell pm enable %%P >nul 2>nul
    echo   [✔] Đã bật lại: %%P
)
echo [🎉] Đã khôi phục cài đặt gốc thành công!
pause
goto :MENU

:EXIT
echo Tạm biệt! Cảm ơn bạn đã sử dụng tool.
timeout /t 2 >nul
exit /b
