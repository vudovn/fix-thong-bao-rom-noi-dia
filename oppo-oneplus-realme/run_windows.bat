@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title ColorOS Notification Fix Tool (Windows) - Auto Scan
color 0b

echo ======================================================================
echo        COLOROS NOTIFICATION FIX TOOL (WINDOWS)
echo     Fix tre thong bao cho OPPO / OnePlus / Realme noi dia Trung
echo     Tinh nang: Quet tu dong app tren may + Chon app bang so
echo     Tac gia: Vu Do (vudovn) - github.com/vudovn
echo ======================================================================
echo.

:: 1. KIỂM TRA VÀ TỰ TẢI ADB
set "BIN_DIR=%~dp0bin"
set "ADB_BIN=adb"

where adb >nul 2>nul
if %errorlevel% equ 0 (
    echo [✔] Da tim thay ADB tren he thong!
    goto :CHECK_DEVICE
)

if exist "%BIN_DIR%\platform-tools\adb.exe" (
    set "ADB_BIN=%BIN_DIR%\platform-tools\adb.exe"
    echo [✔] Da tim thay ADB cuc bo!
    goto :CHECK_DEVICE
)

echo [!] Chua co ADB. Dang tu dong tai Google Platform-Tools ve...
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
set "URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
set "ZIP_PATH=%BIN_DIR%\platform-tools.zip"
echo [*] Dang tai tu: %URL%
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%URL%', '%ZIP_PATH%')"
echo [*] Dang giai nen ADB...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%BIN_DIR%' -Force"
del /f /q "%ZIP_PATH%" >nul 2>nul
set "ADB_BIN=%BIN_DIR%\platform-tools\adb.exe"
echo [✔] Da thiet lap xong ADB!
echo.

:: 2. KIỂM TRA THIẾT BỊ
:CHECK_DEVICE
echo [*] Dang kiem tra ket noi dien thoai qua USB...
"%ADB_BIN%" start-server >nul 2>nul

for /f "tokens=1,2" %%A in ('"%ADB_BIN%" devices ^| findstr /v "List" ^| findstr /r "[a-zA-Z0-9]"') do (
    if "%%B"=="device" goto :DEVICE_OK
    if "%%B"=="unauthorized" (
        echo [!] Thiet bi chua duoc uy quyen! Mo khoa man hinh va bam Cho phep.
        pause
        goto :CHECK_DEVICE
    )
)
echo [X] Chua phat hien dien thoai nao!
echo   1. Cam cap ket noi dien thoai voi may tinh.
echo   2. Bat Go loi USB trong Cai dat ^> Tuy chon nha phat trien.
echo   3. Chon 'Luon cho phep tu may tinh nay' roi nhan OK.
pause
goto :CHECK_DEVICE

:DEVICE_OK
for /f "delims=" %%I in ('"%ADB_BIN%" shell getprop ro.product.model') do set "DEV_MODEL=%%I"
for /f "delims=" %%I in ('"%ADB_BIN%" shell getprop ro.build.display.id') do set "DEV_ROM=%%I"
echo [✔] Da ket noi: %DEV_MODEL% (ROM: %DEV_ROM%)
echo.

:: 3. MENU CHÍNH
:MENU
cls
echo ======================================================================
echo        COLOROS NOTIFICATION FIX TOOL (WINDOWS)
echo        Thiet bi: %DEV_MODEL% ^| ROM: %DEV_ROM%
echo ======================================================================
echo.
echo VUI LONG CHON CHUC NANG:
echo   [1] 🔔 Fix thong bao (Quet app tren may → Chon app can whitelist)
echo   [2] 🔍 Kiem tra trang thai thiet bi ^& ket noi Google Push
echo   [3] 🔄 Khoi phuc he thong ve mac dinh
echo   [0] ❌ Thoat
echo ======================================================================
set /p choice="Nhap lua chon [0-3]: "

if "%choice%"=="1" goto :FIX_NOTI
if "%choice%"=="2" goto :STATUS
if "%choice%"=="3" goto :RESTORE
if "%choice%"=="0" goto :EXIT
goto :MENU

:: =====================================================================
:: FIX THÔNG BÁO - QUÉT TỰ ĐỘNG
:: =====================================================================
:FIX_NOTI
echo.
echo ======================================================================
echo       FIX TRE THONG BAO COLOROS (QUET TU DONG)
echo ======================================================================

echo [*] [1/3] Tat trinh diet ngam (com.oplus.athena)...
"%ADB_BIN%" shell pm disable-user --user 0 com.oplus.athena >nul 2>nul
"%ADB_BIN%" shell pm disable-user --user 999 com.oplus.athena >nul 2>nul
echo   [✔] Da tat com.oplus.athena

echo [*] [2/3] Tu dong whitelist dich vu Google (bat buoc)...
for %%P in (com.google.android.gms com.google.android.gsf com.android.vending) do (
    "%ADB_BIN%" shell dumpsys deviceidle whitelist +%%P >nul 2>nul
    echo   [✔] Auto whitelist: %%P
)

echo [*] [3/3] Quet tat ca ung dung da cai tren may...
echo [*] Dang quet, vui long cho...
echo.

set "APP_COUNT=0"
for /f "tokens=*" %%A in ('"%ADB_BIN%" shell pm list packages -3 -e 2^>nul') do (
    set "RAW=%%A"
    set "PKG=!RAW:package:=!"
    if /i not "!PKG!"=="com.google.android.gms" if /i not "!PKG!"=="com.google.android.gsf" if /i not "!PKG!"=="com.android.vending" (
        set /a APP_COUNT+=1
        set "APP_!APP_COUNT!=!PKG!"
        echo   [!APP_COUNT!] !PKG!
    )
)

if %APP_COUNT% equ 0 (
    echo [!] Khong tim thay app ben thu 3 nao.
    pause
    goto :MENU
)

echo.
echo ─────────────────────────────────────────────────────
echo Tim thay %APP_COUNT% ung dung ben thu 3 tren may.
echo.
echo 📌 Huong dan chon:
echo   • Nhap so cach nhau bang dau phay: 1,3,5,7
echo   • Nhap "all" hoac nhan Enter de chon TAT CA
echo.
set /p "NOTI_SEL=Nhap so app can fix thong bao: "

if "%NOTI_SEL%"=="" set "NOTI_SEL=all"

echo.
echo [*] Dang them app vao Doze Whitelist...

if /i "%NOTI_SEL%"=="all" (
    for /L %%i in (1,1,%APP_COUNT%) do (
        "%ADB_BIN%" shell dumpsys deviceidle whitelist +!APP_%%i! >nul 2>nul
        echo   [✔] Whitelist: !APP_%%i!
    )
) else (
    for %%N in (%NOTI_SEL%) do (
        set "IDX=%%N"
        set "IDX=!IDX: =!"
        if defined APP_!IDX! (
            "%ADB_BIN%" shell dumpsys deviceidle whitelist +!APP_%%N! >nul 2>nul
            echo   [✔] Whitelist: !APP_%%N!
        )
    )
)

echo.
echo [🎉] DA HOAN TAT FIX THONG BAO!
pause
goto :MENU

:: =====================================================================
:: KIỂM TRA TRẠNG THÁI
:: =====================================================================
:STATUS
echo.
echo ======================================================================
echo            KIEM TRA TRANG THAI THIET BI
echo ======================================================================
echo 1. Trinh diet ngam com.oplus.athena:
"%ADB_BIN%" shell pm list packages -d | findstr /i "com.oplus.athena" >nul 2>nul
if %errorlevel% equ 0 (
    echo    [✔] DANG TAT (Tot - Khong bi kill app ngam)
) else (
    echo    [!] DANG BAT (Co the lam tre thong bao)
)

echo 2. Ket noi Google Push (FCM):
for /f "delims=" %%I in ('"%ADB_BIN%" shell dumpsys activity service com.google.android.gms/.gcm.GcmService ^| findstr /i "connected="') do (
    echo    [✔] %%I
)

echo 3. Doze Whitelist (user):
for /f "delims=" %%I in ('"%ADB_BIN%" shell dumpsys deviceidle whitelist ^| findstr "user,"') do (
    echo    [✔] %%I
)
echo.
pause
goto :MENU

:: =====================================================================
:: KHÔI PHỤC
:: =====================================================================
:RESTORE
echo.
echo ======================================================================
echo            KHOI PHUC TRANG THAI GOC
echo ======================================================================
echo [*] Bat lai Athena...
"%ADB_BIN%" shell pm enable com.oplus.athena >nul 2>nul
echo   [✔] Da bat lai com.oplus.athena

echo [*] Xoa toan bo Doze Whitelist (user)...
for /f "delims=" %%I in ('"%ADB_BIN%" shell dumpsys deviceidle whitelist ^| findstr "user,"') do (
    set "LINE=%%I"
    for /f "tokens=2 delims=," %%P in ("!LINE!") do (
        "%ADB_BIN%" shell dumpsys deviceidle whitelist -%%P >nul 2>nul
        echo   [✔] Xoa whitelist: %%P
    )
)
echo [🎉] Da khoi phuc cai dat goc!
pause
goto :MENU

:EXIT
echo Tam biet! Cam on ban da su dung tool.
timeout /t 2 >nul
exit /b
