#!/usr/bin/env bash

# ==============================================================================
# OPPO COLOROS NOTIFICATION FIX SCRIPT (UPDATED FOR COLOROS 17 / ANDROID 17)
# Thiết bị hỗ trợ: OPPO / OnePlus / Realme (ColorOS / OxygenOS / RealmeUI)
# ==============================================================================

set -e

echo "=========================================================="
echo "    BẮT ĐẦU FIX THÔNG BÁO CHO MÁY NỘI ĐỊA TRUNG (COLOROS) "
echo "=========================================================="

DEVICE_COUNT=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "❌ Lỗi: Không tìm thấy thiết bị Android nào được kết nối và mở USB Debugging!"
    exit 1
fi

MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
ROM_VER=$(adb shell getprop ro.build.display.id | tr -d '\r')
echo "📱 Thiết bị: $MODEL"
echo "⚙️ Phiên bản ROM: $ROM_VER"
echo "----------------------------------------------------------"

# 1. VÔ HIỆU HÓA TRÌNH DIỆT NỀN GẮT GAO ATHENA
echo "[1/3] Vô hiệu hóa trình đóng băng / diệt tiến trình ngầm (com.oplus.athena)..."
adb shell pm disable-user --user 0 com.oplus.athena 2>/dev/null && echo "  -> Đã tắt com.oplus.athena cho User chính (User 0)" || echo "  -> Không tìm thấy hoặc đã tắt com.oplus.athena"
adb shell pm disable-user --user 999 com.oplus.athena 2>/dev/null && echo "  -> Đã tắt com.oplus.athena cho Không gian nhân bản (User 999)" || true

# 2. ĐƯA CÁC ỨNG DỤNG QUỐC TẾ & LIÊN LẠC VÀO DANH SÁCH TRẮNG (DOZE WHITELIST)
echo "----------------------------------------------------------"
echo "[2/3] Đưa các ứng dụng nhận thông báo vào danh sách không ngủ đông (Doze Whitelist)..."

APP_LIST=(
    # Nhắn tin / Mạng xã hội
    "com.facebook.orca"                     # Messenger
    "com.facebook.katana"                   # Facebook
    "com.facebook.pages.app"                # Meta Business Suite
    "org.telegram.messenger"                # Telegram
    "com.zing.zalo"                         # Zalo
    "com.whatsapp"                          # WhatsApp
    "com.whatsapp.w4b"                      # WhatsApp Business
    "com.instagram.android"                 # Instagram
    "com.instagram.barcelona"               # Threads
    "com.twitter.android"                   # X / Twitter
    "com.discord"                           # Discord
    "com.locket.Locket"                     # Locket
    "com.ss.android.ugc.trill"              # TikTok
    "com.ss.android.ugc.aweme"              # Douyin
    "com.tencent.mm"                        # WeChat
    "com.linkedin.android"                  # LinkedIn

    # Email & Trợ lý & Công việc
    "com.google.android.gm"                 # Gmail
    "com.microsoft.office.outlook"          # Outlook
    "com.android.email"                     # Email
    "com.openai.chatgpt"                    # ChatGPT
    "ai.x.grok"                             # Grok
    "com.google.android.apps.bard"          # Google Gemini
    "com.github.android"                    # GitHub Mobile

    # Mua sắm & Giao hàng / Di chuyển / Đặt xe
    "com.shopee.vn"                         # Shopee
    "com.deliverynow"                       # ShopeeFood
    "com.grabtaxi.passenger"                # Grab
    "com.gsm.customer"                      # Xanh SM
    "com.chotot.vn"                         # Chợ Tốt
    "com.bachhoaxanh"                       # Bách Hóa Xanh
    "com.alibaba.aliexpresshd"              # AliExpress
    "com.mcdonalds.mobileapp"               # McDonald's

    # Dịch vụ công & Đời sống
    "com.vnid"                              # VNeID (Định danh điện tử)
    "com.etax.icanhan"                      # eTax Mobile (Thuế điện tử)
    "com.windyty.android"                   # Windy (Dự báo thời tiết / bão)

    # Ngân hàng / Ví điện tử / Tài chính / Crypto
    "com.mbmobile"                          # MB Bank
    "com.vnpay.vpbankonline"                # VPBank NEO
    "com.mservice.momotransfer"             # MoMo
    "vn.com.vng.zalopay"                    # ZaloPay
    "vn.com.hdsaison.hpo"                   # HD SAISON
    "com.paypal.android.p2pmobile"          # PayPal
    "com.sepay.trans"                       # SePay
    "com.binance.dev"                       # Binance
    "com.bybit.app"                         # Bybit
    "io.metamask"                           # MetaMask
    "app.phantom"                           # Phantom
    "com.coinbase.android"                  # Coinbase
    "org.toshi"                             # Coinbase Wallet
    "com.batonresearch.pump"                # Pump.fun

    # Xác thực 2FA & Bảo mật
    "com.google.android.apps.authenticator2"# Google Authenticator
    "com.valvesoftware.android.steam.community"# Steam Guard

    # Dịch vụ nền tảng Google
    "com.google.android.gms"                # Google Play Services
    "com.google.android.gsf"                # Google Services Framework
    "com.android.vending"                   # Google Play Store
    "com.google.android.googlequicksearchbox"# Google Search
    "com.google.android.apps.maps"          # Google Maps
)

for pkg in "${APP_LIST[@]}"; do
    if adb shell pm path "$pkg" >/dev/null 2>&1; then
        adb shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
        echo "  ✔ Đã thêm vào Whitelist: $pkg"
    fi
done

# 3. ĐẢM BẢO DỊCH VỤ GOOGLE KHÔNG BỊ GIỚI HẠN
echo "----------------------------------------------------------"
echo "[3/3] Tối ưu kết nối Google Play Services & FCM..."
adb shell dumpsys deviceidle whitelist +com.google.android.gms >/dev/null 2>&1
adb shell dumpsys deviceidle whitelist +com.google.android.gsf >/dev/null 2>&1

echo "----------------------------------------------------------"
echo "✅ HOÀN TẤT CÁC THIẾT LẬP QUA ADB!"
echo "=========================================================="
