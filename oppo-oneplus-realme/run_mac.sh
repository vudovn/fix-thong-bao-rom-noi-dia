#!/usr/bin/env bash

# ==============================================================================
# TOOL FIX THÔNG BÁO & DỌN APP RÁC CHO MÁY NỘI ĐỊA TRUNG (COLOROS / OXYGENOS / REALMEUI)
# Hỗ trợ: macOS & Linux
# ==============================================================================

# Màu sắc hiển thị
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}======================================================================${NC}"
echo -e "${GREEN}      COLOROS NOTIFICATION FIX & DEBLOAT TOOL (macOS / Linux)        ${NC}"
echo -e "${YELLOW}   Hỗ trợ tối ưu thông báo & dọn app rác cho OPPO / OnePlus / Realme  ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

# 1. KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ADB NẾU CHƯA CÓ
BIN_DIR="$(pwd)/bin"
ADB_BIN=""

if command -v adb >/dev/null 2>&1; then
    ADB_BIN="$(command -v adb)"
    echo -e "${GREEN}✔ Đã tìm thấy ADB trên hệ thống:${NC} $ADB_BIN"
elif [ -f "$BIN_DIR/platform-tools/adb" ]; then
    ADB_BIN="$BIN_DIR/platform-tools/adb"
    echo -e "${GREEN}✔ Đã tìm thấy ADB cục bộ:${NC} $ADB_BIN"
else
    echo -e "${YELLOW}⚡ Máy bạn chưa có ADB. Đang tự động tải Google Platform-Tools về...${NC}"
    mkdir -p "$BIN_DIR"
    
    # Xác định hệ điều hành (macOS hay Linux)
    OS_TYPE="$(uname -s)"
    if [ "$OS_TYPE" = "Darwin" ]; then
        DOWNLOAD_URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    else
        DOWNLOAD_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
    fi
    
    echo -e "   Đang tải từ: ${CYAN}$DOWNLOAD_URL${NC}"
    curl -L -o "$BIN_DIR/platform-tools.zip" "$DOWNLOAD_URL" --progress-bar
    
    echo -e "   Đang giải nén..."
    unzip -q -o "$BIN_DIR/platform-tools.zip" -d "$BIN_DIR"
    rm -f "$BIN_DIR/platform-tools.zip"
    chmod +x "$BIN_DIR/platform-tools/adb"
    
    ADB_BIN="$BIN_DIR/platform-tools/adb"
    echo -e "${GREEN}✔ Đã thiết lập xong ADB sẵn sàng sử dụng!${NC}\n"
fi

# 2. KIỂM TRA KẾT NỐI THIẾT BỊ
check_device() {
    echo -e "${BLUE}▶ Đang kiểm tra kết nối điện thoại qua USB...${NC}"
    $ADB_BIN start-server >/dev/null 2>&1
    
    DEVICES_OUTPUT=$($ADB_BIN devices | grep -v "List" | grep -v "^$" || true)
    
    if [ -z "$DEVICES_OUTPUT" ]; then
        echo -e "${RED}❌ Chưa phát hiện điện thoại nào kết nối!${NC}"
        echo -e "${YELLOW}👉 Hãy làm theo các bước sau:${NC}"
        echo -e "  1. Cắm cáp kết nối điện thoại với máy tính."
        echo -e "  2. Bật ${CYAN}Gỡ lỗi USB (USB Debugging)${NC} trong Cài đặt > Tùy chọn nhà phát triển."
        echo -e "  3. Nhìn màn hình điện thoại, chọn ${GREEN}'Luôn cho phép từ máy tính này'${NC} rồi bấm OK."
        echo ""
        read -p "Sau khi cắm và cho phép xong, nhấn [Enter] để thử lại..."
        check_device
        return
    fi
    
    if echo "$DEVICES_OUTPUT" | grep -q "unauthorized"; then
        echo -e "${YELLOW}⚠️ Thiết bị chưa được ủy quyền!${NC}"
        echo -e "👉 Hãy mở khóa điện thoại, tích vào ô ${GREEN}'Luôn cho phép từ máy tính này'${NC} và nhấn OK."
        read -p "Nhấn [Enter] sau khi đã bấm cho phép trên điện thoại..."
        check_device
        return
    fi
    
    DEV_MODEL=$($ADB_BIN shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEV_ROM=$($ADB_BIN shell getprop ro.build.display.id 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}✔ Đã kết nối thành công thiết bị:${NC} ${CYAN}$DEV_MODEL${NC} (ROM: ${YELLOW}$DEV_ROM${NC})\n"
}

# DANH SÁCH TOÀN BỘ CÁC ỨNG DỤNG CẦN WHITELIST (50+ APPS)
APP_LIST=(
    # --- Nhắn tin & Mạng xã hội ---
    "com.zing.zalo"                         # Zalo
    "com.facebook.orca"                     # Messenger
    "com.facebook.katana"                   # Facebook
    "com.facebook.pages.app"                # Meta Business Suite
    "org.telegram.messenger"                # Telegram
    "com.whatsapp"                          # WhatsApp
    "com.whatsapp.w4b"                      # WhatsApp Business
    "com.viber.voip"                        # Viber
    "com.instagram.android"                 # Instagram
    "com.instagram.barcelona"               # Threads
    "com.twitter.android"                   # X / Twitter
    "com.discord"                           # Discord
    "com.locket.Locket"                     # Locket
    "com.ss.android.ugc.trill"              # TikTok Global
    "com.ss.android.ugc.aweme"              # Douyin (TikTok CN)
    "com.tencent.mm"                        # WeChat
    "jp.naver.line.android"                 # LINE
    "com.skype.raider"                      # Skype
    "com.microsoft.teams"                   # Microsoft Teams
    "com.Slack"                             # Slack
    "com.linkedin.android"                  # LinkedIn

    # --- Email, Trợ lý & Công việc ---
    "com.google.android.gm"                 # Gmail
    "com.microsoft.office.outlook"          # Outlook
    "com.android.email"                     # Email mặc định
    "com.yahoo.mobile.client.android.mail"  # Yahoo Mail
    "notion.id"                             # Notion
    "com.openai.chatgpt"                    # ChatGPT
    "ai.x.grok"                             # Grok
    "com.google.android.apps.bard"          # Google Gemini
    "com.anthropic.claude"                  # Claude
    "com.github.android"                    # GitHub Mobile

    # --- Dịch vụ công & Đời sống ---
    "com.vnid"                              # VNeID
    "com.etax.icanhan"                      # eTax Mobile (Thuế)
    "vss.gov.vssapp"                        # VssID (Bảo hiểm xã hội)
    "com.windyty.android"                   # Windy

    # --- Đặt xe, Giao hàng & Mua sắm ---
    "com.grabtaxi.passenger"                # Grab
    "com.gsm.customer"                      # Taxi Xanh SM
    "com.shopee.vn"                         # Shopee
    "com.deliverynow"                       # ShopeeFood
    "com.be.customer"                       # Be
    "com.gojek.app"                         # Gojek
    "vn.ahamove.buyer"                      # AhaMove
    "vn.giaohangtietkiem.app"               # GHTK
    "com.chotot.vn"                         # Chợ Tốt
    "com.bachhoaxanh"                       # Bách Hóa Xanh
    "com.alibaba.aliexpresshd"              # AliExpress
    "com.lazada.android"                    # Lazada
    "vn.tiki.app.tikiandroid"               # Tiki
    "com.mcdonalds.mobileapp"               # McDonald's

    # --- Ngân hàng & Tài chính ---
    "com.mbmobile"                          # MB Bank
    "com.vnpay.vpbankonline"                # VPBank NEO
    "com.VCB"                               # Vietcombank
    "vn.com.techcombank.bb.app"             # Techcombank
    "com.vnpay.bidv"                        # BIDV SmartBanking
    "com.vietinbank.ipay"                   # VietinBank iPay
    "mobile.acb.com.vn"                     # ACB ONE
    "vn.tpbank.mb"                          # TPBank
    "com.mservice.momotransfer"             # MoMo
    "vn.com.vng.zalopay"                    # ZaloPay
    "vn.viettel.viettelpay"                 # Viettel Money
    "vn.com.hdsaison.hpo"                   # HD SAISON
    "com.paypal.android.p2pmobile"          # PayPal
    "com.sepay.trans"                       # SePay

    # --- Tiền mã hóa & Web3 ---
    "com.binance.dev"                       # Binance
    "com.bybit.app"                         # Bybit
    "com.okinc.okex.gp"                     # OKX
    "io.metamask"                           # MetaMask
    "app.phantom"                           # Phantom
    "com.wallet.crypto.trustapp"            # Trust Wallet
    "com.coinbase.android"                  # Coinbase
    "org.toshi"                             # Coinbase Wallet
    "com.batonresearch.pump"                # Pump.fun

    # --- Bảo mật & 2FA ---
    "com.google.android.apps.authenticator2"# Google Authenticator
    "com.azure.authenticator"               # Microsoft Authenticator
    "com.valvesoftware.android.steam.community"# Steam Guard

    # --- Dịch vụ Google ---
    "com.google.android.gms"                # Google Play Services
    "com.google.android.gsf"                # Google Services Framework
    "com.android.vending"                   # Google Play Store
    "com.google.android.googlequicksearchbox"# Google Search
    "com.google.android.apps.maps"          # Google Maps
)

# DANH SÁCH APP RÁC HỆ THỐNG NỘI ĐỊA CẦN TẮT
BLOAT_LIST=(
    "com.heytap.pictorial"                  # Tạp chí màn hình khóa (quảng cáo)
    "com.heytap.browser"                    # Trình duyệt HeyTap
    "com.coloros.assistantscreen"           # Bảng tin tiếng Trung bên trái
    "com.heytap.quicksearchbox"             # Thanh tìm kiếm nhanh Baidu
    "com.oplus.pay"                         # Ví tiền Trung Quốc
    "com.nearme.instant.platform"           # Nền tảng Quick App
    "com.oppo.instant.local.service"        # Dịch vụ Quick App
    "com.coloros.operationManual"           # Sách hướng dẫn tiếng Trung
    "com.coloros.karaoke"                   # ColorOS Karaoke
)

# HÀM 1: FIX THÔNG BÁO
fix_notifications() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           TIẾN HÀNH FIX TRỄ THÔNG BÁO COLOROS                       ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    
    echo -e "\n${BLUE}[1/2] Vô hiệu hóa trình diệt ngầm hung hãn (com.oplus.athena)...${NC}"
    $ADB_BIN shell pm disable-user --user 0 com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt com.oplus.athena (User chính)${NC}" || echo -e "  ${YELLOW}- Đã tắt trước đó hoặc không tìm thấy${NC}"
    $ADB_BIN shell pm disable-user --user 999 com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt com.oplus.athena (MultiApp / Không gian nhân bản)${NC}" || true

    echo -e "\n${BLUE}[2/2] Cấp quyền miễn ngủ đông (Doze Whitelist) cho các ứng dụng...${NC}"
    count=0
    for pkg in "${APP_LIST[@]}"; do
        if $ADB_BIN shell pm path "$pkg" >/dev/null 2>&1; then
            $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
            echo -e "  ${GREEN}✔ Đã thêm:${NC} $pkg"
            ((count++))
        fi
    done
    
    # Ép whitelist dịch vụ Google
    $ADB_BIN shell dumpsys deviceidle whitelist +com.google.android.gms >/dev/null 2>&1
    $ADB_BIN shell dumpsys deviceidle whitelist +com.google.android.gsf >/dev/null 2>&1
    
    echo -e "\n${GREEN}🎉 HOÀN TẤT! Đã tối ưu ${CYAN}$count${GREEN} ứng dụng tìm thấy trên máy của bạn.${NC}"
}

# HÀM 2: DỌN APP RÁC
debloat_apps() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           TIẾN HÀNH DỌN DẸP APP RÁC NỘI ĐỊA TRUNG                    ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    
    echo -e "\nBạn có muốn giữ lại Trợ lý ảo tiếng Trung (Breeno / AI Voice) không?"
    echo -e "  ${GREEN}[1] CÓ, giữ lại Trợ lý ảo (Khuyên dùng nếu bạn dùng AI OPPO)${NC}"
    echo -e "  ${RED}[2] KHÔNG, tắt luôn cả Trợ lý ảo tiếng Trung${NC}"
    read -p "Chọn (mặc định 1): " ai_choice
    
    echo -e "\n${BLUE}Đang tiến hành dọn app rác...${NC}"
    for pkg in "${BLOAT_LIST[@]}"; do
        if $ADB_BIN shell pm path "$pkg" >/dev/null 2>&1; then
            $ADB_BIN shell pm disable-user --user 0 "$pkg" >/dev/null 2>&1
            echo -e "  ${GREEN}✔ Đã tắt:${NC} $pkg"
        fi
    done
    
    if [ "$ai_choice" = "2" ]; then
        $ADB_BIN shell pm disable-user --user 0 com.heytap.speechassist 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt Trợ lý ảo: com.heytap.speechassist${NC}" || true
        $ADB_BIN shell pm disable-user --user 0 com.oplus.ovoicemanager 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt Giọng nói: com.oplus.ovoicemanager${NC}" || true
    else
        echo -e "  ${YELLOW}✔ Đã giữ nguyên Trợ lý ảo tiếng Trung (Breeno / AI Voice)${NC}"
    fi
    
    echo -e "\n${GREEN}🎉 Đã dọn dẹp sạch sẽ các ứng dụng rác quảng cáo!${NC}"
}

# HÀM 3: KHÔI PHỤC MẶC ĐỊNH
restore_default() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KHÔI PHỤC CÀI ĐẶT GỐC COLOROS                            ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    
    echo -e "\n${BLUE}Đang bật lại trình quản lý Athena...${NC}"
    $ADB_BIN shell pm enable com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã bật lại com.oplus.athena (User 0)${NC}" || true
    $ADB_BIN shell pm enable --user 999 com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã bật lại com.oplus.athena (User 999)${NC}" || true
    
    echo -e "\n${BLUE}Đang khôi phục lại các ứng dụng rác đã tắt...${NC}"
    for pkg in "${BLOAT_LIST[@]}"; do
        $ADB_BIN shell pm enable "$pkg" 2>/dev/null && echo -e "  ${GREEN}✔ Đã bật lại:${NC} $pkg" || true
    done
    $ADB_BIN shell pm enable com.heytap.speechassist 2>/dev/null || true
    $ADB_BIN shell pm enable com.oplus.ovoicemanager 2>/dev/null || true
    
    echo -e "\n${GREEN}🎉 Đã khôi phục toàn bộ trạng thái ban đầu của máy!${NC}"
}

# HÀM 4: KIỂM TRA TRẠNG THÁI
check_status() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KIỂM TRA TRẠNG THÁI THIẾT BỊ                              ${NC}"
    echo -e "${CYAN}======================================================================${NC}"
    
    echo -n "1. Trình diệt ngầm com.oplus.athena: "
    if $ADB_BIN shell pm list packages -d | grep -q "com.oplus.athena"; then
        echo -e "${GREEN}ĐANG BỊ TẮT (Tốt - Không bị kill app ngầm)${NC}"
    else
        echo -e "${RED}ĐANG BẬT (App ngầm có thể bị đóng băng/kill)${NC}"
    fi
    
    echo -n "2. Kết nối Google Push (FCM): "
    FCM_STATUS=$($ADB_BIN shell dumpsys activity service com.google.android.gms/.gcm.GcmService 2>/dev/null | grep -i "connected=" | head -n 1 || true)
    if [ -n "$FCM_STATUS" ]; then
        echo -e "${GREEN}Đang kết nối ($FCM_STATUS)${NC}"
    else
        echo -e "${YELLOW}Chưa xác định hoặc đang chờ kết nối${NC}"
    fi
    
    echo -e "\n3. Danh sách app quan trọng đã vào Whitelist không ngủ đông:"
    $ADB_BIN shell dumpsys deviceidle whitelist | grep "user," | cut -d',' -f2 | tr '\n' ' '
    echo -e "\n"
}

# MENU CHÍNH
check_device

while true; do
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}VUI LÒNG CHỌN CHỨC NĂNG:${NC}"
    echo -e "  ${GREEN}[1]${NC} 🚀 ${GREEN}CHẠY TẤT CẢ (Khuyên dùng):${NC} Fix thông báo + Dọn app rác (Giữ AI)"
    echo -e "  ${CYAN}[2]${NC} 🔔 Chỉ Fix trễ thông báo (Tắt Athena + Whitelist 50+ app)"
    echo -e "  ${CYAN}[3]${NC} 🧹 Chỉ Dọn app rác nội địa Trung (Tùy chọn giữ/tắt trợ lý ảo)"
    echo -e "  ${BLUE}[4]${NC} 🔍 Kiểm tra trạng thái thiết bị & cổng kết nối Google Push"
    echo -e "  ${YELLOW}[5]${NC} 🔄 Khôi phục hệ thống về mặc định (Hoàn tác mọi cài đặt)"
    echo -e "  ${RED}[0]${NC} ❌ Thoát"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Nhập số lựa chọn của bạn [0-5]: " menu_choice
    
    case $menu_choice in
        1)
            fix_notifications
            debloat_apps
            ;;
        2)
            fix_notifications
            ;;
        3)
            debloat_apps
            ;;
        4)
            check_status
            ;;
        5)
            restore_default
            ;;
        0)
            echo -e "\n${GREEN}Cảm ơn bạn đã sử dụng tool! Tạm biệt!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ, vui lòng chọn từ 0 đến 5!${NC}"
            ;;
    esac
    echo ""
    read -p "Nhấn [Enter] để quay lại menu chính..."
    clear
done
