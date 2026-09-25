@echo off
chcp 65001 >nul
title Fix Thong Bao Android ROM Noi Dia Trung Quoc (Windows)
color 0b

set "ROOT_DIR=%~dp0"

:BRAND_MENU
cls
echo ======================================================================
echo    CÔNG CỤ FIX THÔNG BÁO ^& DỌN RÁC ANDROID ROM NỘI ĐỊA TRUNG QUỐC
echo           Dành cho các dòng máy xách tay tại Việt Nam (Windows)
echo ======================================================================
echo.
echo VUI LÒNG CHỌN HÃNG ĐIỆN THOẠI CỦA BẠN:
echo   [1] 🟢 OPPO / OnePlus / Realme (ColorOS / OxygenOS / RealmeUI) [SẴN SÀNG]
echo   [2] 🟡 Xiaomi / Redmi / POCO (HyperOS / MIUI) [Đang phát triển]
echo   [3] 🟡 Vivo / iQOO (OriginOS / FuntouchOS) [Đang phát triển]
echo   [0] ❌ Thoát
echo ======================================================================
set /p brand="Nhập lựa chọn của bạn [0-3]: "

if "%brand%"=="1" (
    echo.
    echo [*] Đang khởi động bộ công cụ cho OPPO / OnePlus / Realme...
    cd /d "%ROOT_DIR%oppo-oneplus-realme"
    call run_windows.bat
    cd /d "%ROOT_DIR%"
    goto :BRAND_MENU
)

if "%brand%"=="2" (
    echo.
    echo [!] Module Xiaomi / Redmi (HyperOS / MIUI) đang được hoàn thiện!
    echo Hãy theo dõi các bản cập nhật mới nhất trên GitHub repository.
    echo.
    pause
    goto :BRAND_MENU
)

if "%brand%"=="3" (
    echo.
    echo [!] Module Vivo / iQOO (OriginOS) đang được hoàn thiện!
    echo Hãy theo dõi các bản cập nhật mới nhất trên GitHub repository.
    echo.
    pause
    goto :BRAND_MENU
)

if "%brand%"=="0" (
    echo.
    echo Cảm ơn bạn đã sử dụng tool! Tạm biệt!
    timeout /t 2 >nul
    exit /b
)

goto :BRAND_MENU
