#!/usr/bin/env bash

# ==============================================================================
# TOOL FIX THÔNG BÁO CHO MÁY NỘI ĐỊA TRUNG (COLOROS / OXYGENOS / REALMEUI)
# Hỗ trợ: macOS & Linux
# Tính năng: Quét tự động app trên máy + Chọn app cần fix bằng số
# Tác giả: Vũ Đỗ (vudovn)
# GitHub: https://github.com/vudovn
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}======================================================================${NC}"
echo -e "${GREEN}        COLOROS NOTIFICATION FIX TOOL (macOS / Linux)                ${NC}"
echo -e "${YELLOW}     Fix trễ thông báo cho OPPO / OnePlus / Realme nội địa Trung     ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

# 1. KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ADB
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

# =====================================================================
# BẢNG TRA TÊN APP (package → tên tiếng Việt)
# =====================================================================
get_app_name() {
    case "$1" in
        "com.google.android.gms") echo "Google Play Services" ;;
        "com.google.android.gsf") echo "Google Services Framework" ;;
        "com.android.vending") echo "Google Play Store" ;;
        "com.zing.zalo") echo "Zalo" ;;
        "com.facebook.orca") echo "Messenger" ;;
        "com.facebook.katana") echo "Facebook" ;;
        "com.facebook.pages.app") echo "Meta Business Suite" ;;
        "org.telegram.messenger") echo "Telegram" ;;
        "com.whatsapp") echo "WhatsApp" ;;
        "com.whatsapp.w4b") echo "WhatsApp Business" ;;
        "com.viber.voip") echo "Viber" ;;
        "com.instagram.android") echo "Instagram" ;;
        "com.instagram.barcelona") echo "Threads" ;;
        "com.twitter.android") echo "X / Twitter" ;;
        "com.discord") echo "Discord" ;;
        "com.locket.Locket") echo "Locket" ;;
        "com.ss.android.ugc.trill") echo "TikTok" ;;
        "com.ss.android.ugc.aweme") echo "Douyin (TikTok CN)" ;;
        "com.tencent.mm") echo "WeChat" ;;
        "jp.naver.line.android") echo "LINE" ;;
        "com.skype.raider") echo "Skype" ;;
        "com.microsoft.teams") echo "Microsoft Teams" ;;
        "com.Slack") echo "Slack" ;;
        "com.linkedin.android") echo "LinkedIn" ;;
        "com.google.android.gm") echo "Gmail" ;;
        "com.microsoft.office.outlook") echo "Outlook" ;;
        "com.android.email") echo "Email mặc định" ;;
        "com.yahoo.mobile.client.android.mail") echo "Yahoo Mail" ;;
        "notion.id") echo "Notion" ;;
        "com.openai.chatgpt") echo "ChatGPT" ;;
        "ai.x.grok") echo "Grok" ;;
        "com.google.android.apps.bard") echo "Google Gemini" ;;
        "com.anthropic.claude") echo "Claude" ;;
        "com.github.android") echo "GitHub Mobile" ;;
        "com.vnid") echo "VNeID" ;;
        "com.etax.icanhan") echo "eTax Mobile (Thuế)" ;;
        "vss.gov.vssapp") echo "VssID (BHXH)" ;;
        "com.windyty.android") echo "Windy" ;;
        "com.grabtaxi.passenger") echo "Grab" ;;
        "com.gsm.customer") echo "Taxi Xanh SM" ;;
        "com.shopee.vn") echo "Shopee" ;;
        "com.deliverynow") echo "ShopeeFood" ;;
        "com.be.customer") echo "Be" ;;
        "com.gojek.app") echo "Gojek" ;;
        "vn.ahamove.buyer") echo "AhaMove" ;;
        "vn.giaohangtietkiem.app") echo "GHTK" ;;
        "com.chotot.vn") echo "Chợ Tốt" ;;
        "com.bachhoaxanh") echo "Bách Hóa Xanh" ;;
        "com.alibaba.aliexpresshd") echo "AliExpress" ;;
        "com.lazada.android") echo "Lazada" ;;
        "vn.tiki.app.tikiandroid") echo "Tiki" ;;
        "com.mcdonalds.mobileapp") echo "McDonald's" ;;
        "com.mbmobile") echo "MB Bank" ;;
        "com.vnpay.vpbankonline") echo "VPBank NEO" ;;
        "com.VCB") echo "Vietcombank" ;;
        "vn.com.techcombank.bb.app") echo "Techcombank" ;;
        "com.vnpay.bidv") echo "BIDV SmartBanking" ;;
        "com.vietinbank.ipay") echo "VietinBank iPay" ;;
        "mobile.acb.com.vn") echo "ACB ONE" ;;
        "vn.tpbank.mb") echo "TPBank" ;;
        "com.mservice.momotransfer") echo "MoMo" ;;
        "vn.com.vng.zalopay") echo "ZaloPay" ;;
        "vn.viettel.viettelpay") echo "Viettel Money" ;;
        "vn.com.hdsaison.hpo") echo "HD SAISON" ;;
        "com.paypal.android.p2pmobile") echo "PayPal" ;;
        "com.sepay.trans") echo "SePay" ;;
        "com.binance.dev") echo "Binance" ;;
        "com.bybit.app") echo "Bybit" ;;
        "com.okinc.okex.gp") echo "OKX" ;;
        "io.metamask") echo "MetaMask" ;;
        "app.phantom") echo "Phantom" ;;
        "com.wallet.crypto.trustapp") echo "Trust Wallet" ;;
        "com.coinbase.android") echo "Coinbase" ;;
        "org.toshi") echo "Coinbase Wallet" ;;
        "com.batonresearch.pump") echo "Pump.fun" ;;
        "com.google.android.apps.authenticator2") echo "Google Authenticator" ;;
        "com.azure.authenticator") echo "Microsoft Authenticator" ;;
        "com.valvesoftware.android.steam.community") echo "Steam Guard" ;;
        "com.google.android.googlequicksearchbox") echo "Google Search" ;;
        "com.google.android.apps.maps") echo "Google Maps" ;;
        *) echo "" ;;
    esac
}

# Google services luôn tự động whitelist
GOOGLE_AUTO_WHITELIST=(
    "com.google.android.gms"
    "com.google.android.gsf"
    "com.android.vending"
)

# =====================================================================
# HÀM FIX THÔNG BÁO - QUÉT TỰ ĐỘNG + CHỌN BẰNG SỐ
# =====================================================================
fix_notifications() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           FIX TRỄ THÔNG BÁO COLOROS (QUÉT TỰ ĐỘNG)                  ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    # Bước 1: Tắt Athena
    echo -e "\n${BLUE}[1/3] Vô hiệu hóa trình diệt ngầm (com.oplus.athena)...${NC}"
    $ADB_BIN shell pm disable-user --user 0 com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt com.oplus.athena (User 0)${NC}" || echo -e "  ${YELLOW}- Đã tắt trước đó hoặc không tìm thấy${NC}"
    $ADB_BIN shell pm disable-user --user 999 com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã tắt com.oplus.athena (User 999)${NC}" || true

    # Bước 2: Tự động whitelist Google Services
    echo -e "\n${BLUE}[2/3] Tự động whitelist các dịch vụ Google (bắt buộc)...${NC}"
    for pkg in "${GOOGLE_AUTO_WHITELIST[@]}"; do
        $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
        echo -e "  ${GREEN}✔ Auto whitelist:${NC} $pkg"
    done

    # Bước 3: Quét app → hiển thị danh sách → chọn số
    echo -e "\n${BLUE}[3/3] Quét tất cả ứng dụng đã cài trên máy...${NC}"
    echo -e "${YELLOW}⏳ Đang quét, vui lòng chờ...${NC}\n"

    SCAN_LIST=()
    SCAN_NAMES=()
    while IFS= read -r line; do
        pkg=$(echo "$line" | sed 's/package://' | tr -d '\r')
        [ -z "$pkg" ] && continue
        # Bỏ qua Google services đã auto whitelist
        skip=0
        for g in "${GOOGLE_AUTO_WHITELIST[@]}"; do
            [ "$pkg" = "$g" ] && skip=1 && break
        done
        [ $skip -eq 1 ] && continue
        app_title=$(get_app_name "$pkg")
        if [ -n "$app_title" ]; then
            display_name="$app_title"
        else
            display_name="$pkg"
        fi
        SCAN_LIST+=("$pkg")
        SCAN_NAMES+=("$display_name")
    done < <($ADB_BIN shell pm list packages -3 -e 2>/dev/null)

    TOTAL=${#SCAN_LIST[@]}
    if [ "$TOTAL" -eq 0 ]; then
        echo -e "${YELLOW}Không tìm thấy app bên thứ 3 nào trên máy.${NC}"
        return
    fi

    echo -e "${GREEN}Tìm thấy ${CYAN}$TOTAL${GREEN} ứng dụng bên thứ 3 trên máy:${NC}\n"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    for i in "${!SCAN_LIST[@]}"; do
        NUM=$((i + 1))
        printf "  ${GREEN}[%3d]${NC} %-35s ${PURPLE}%s${NC}\n" "$NUM" "${SCAN_NAMES[$i]}" "${SCAN_LIST[$i]}"
    done
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"

    echo ""
    echo -e "${YELLOW}📌 Hướng dẫn chọn:${NC}"
    echo -e "  • Nhập số cách nhau bằng dấu phẩy: ${CYAN}1,3,5,7${NC}"
    echo -e "  • Nhập khoảng: ${CYAN}1-10${NC} (chọn từ 1 đến 10)"
    echo -e "  • Nhập ${CYAN}all${NC} hoặc nhấn ${CYAN}Enter${NC} để chọn TẤT CẢ"
    echo ""
    read -p "Nhập số app cần fix thông báo: " selection

    # Parse selection
    SELECTED=()
    if [ -z "$selection" ] || [ "$selection" = "all" ]; then
        for i in "${!SCAN_LIST[@]}"; do SELECTED+=("$i"); done
    else
        IFS=',' read -ra PARTS <<< "$selection"
        for part in "${PARTS[@]}"; do
            part=$(echo "$part" | tr -d ' ')
            if [[ "$part" == *-* ]]; then
                START=$(echo "$part" | cut -d'-' -f1)
                END=$(echo "$part" | cut -d'-' -f2)
                for ((n=START; n<=END; n++)); do
                    [ "$n" -ge 1 ] && [ "$n" -le "$TOTAL" ] && SELECTED+=("$((n - 1))")
                done
            else
                [ "$part" -ge 1 ] 2>/dev/null && [ "$part" -le "$TOTAL" ] && SELECTED+=("$((part - 1))")
            fi
        done
    fi

    # Áp dụng whitelist
    echo -e "\n${BLUE}Đang thêm ${#SELECTED[@]} app vào Doze Whitelist...${NC}"
    count=0
    for idx in "${SELECTED[@]}"; do
        pkg="${SCAN_LIST[$idx]}"
        $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
        echo -e "  ${GREEN}✔ Whitelist:${NC} ${SCAN_NAMES[$idx]} ($pkg)"
        ((count++))
    done

    echo -e "\n${GREEN}🎉 HOÀN TẤT! Đã thêm ${CYAN}$count${GREEN} app vào Doze Whitelist + Tắt Athena.${NC}"
}

# =====================================================================
# KIỂM TRA TRẠNG THÁI
# =====================================================================
check_status() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KIỂM TRA TRẠNG THÁI THIẾT BỊ                              ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -n -e "\n${BLUE}1. Trình diệt ngầm com.oplus.athena:${NC} "
    if $ADB_BIN shell pm list packages -d | grep -q "com.oplus.athena"; then
        echo -e "${GREEN}ĐANG TẮT ✔ (Tốt - Không bị kill app ngầm)${NC}"
    else
        echo -e "${RED}ĐANG BẬT ✗ (App ngầm có thể bị đóng băng/kill)${NC}"
    fi

    echo -n -e "\n${BLUE}2. Kết nối Google Push (FCM):${NC} "
    FCM_STATUS=$($ADB_BIN shell dumpsys activity service com.google.android.gms/.gcm.GcmService 2>/dev/null | grep -i "connected=" | head -n 1 || true)
    if [ -n "$FCM_STATUS" ]; then
        echo -e "${GREEN}Đang kết nối ($FCM_STATUS)${NC}"
    else
        echo -e "${YELLOW}Chưa xác định hoặc đang chờ kết nối${NC}"
    fi

    echo -e "\n${BLUE}3. Danh sách app đã vào Doze Whitelist:${NC}"
    WHITELIST_COUNT=$($ADB_BIN shell dumpsys deviceidle whitelist | grep -c "user," 2>/dev/null || echo "0")
    echo -e "   Tổng: ${CYAN}$WHITELIST_COUNT${NC} app"
    $ADB_BIN shell dumpsys deviceidle whitelist | grep "user," | while read -r line; do
        PKG=$(echo "$line" | cut -d',' -f2 | tr -d '\r')
        [ -z "$PKG" ] && continue
        app_title=$(get_app_name "$PKG")
        if [ -n "$app_title" ]; then
            echo -e "   ${GREEN}•${NC} $app_title ($PKG)"
        else
            echo -e "   ${GREEN}•${NC} $PKG"
        fi
    done
    echo ""
}

# =====================================================================
# KHÔI PHỤC MẶC ĐỊNH
# =====================================================================
restore_default() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KHÔI PHỤC CÀI ĐẶT GỐC COLOROS                            ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}Đang bật lại trình quản lý Athena...${NC}"
    $ADB_BIN shell pm enable com.oplus.athena 2>/dev/null && echo -e "  ${GREEN}✔ Đã bật lại com.oplus.athena${NC}" || echo -e "  ${YELLOW}- Không tìm thấy hoặc đã bật${NC}"

    echo -e "\n${BLUE}Đang xóa toàn bộ Doze Whitelist do user thêm...${NC}"
    count=0
    while IFS= read -r line; do
        PKG=$(echo "$line" | grep "user," | cut -d',' -f2 | tr -d '\r')
        [ -z "$PKG" ] && continue
        $ADB_BIN shell dumpsys deviceidle whitelist -"$PKG" >/dev/null 2>&1
        echo -e "  ${GREEN}✔ Đã xóa khỏi whitelist:${NC} $PKG"
        ((count++))
    done < <($ADB_BIN shell dumpsys deviceidle whitelist 2>/dev/null)

    if [ "$count" -eq 0 ]; then
        echo -e "  ${YELLOW}Không có app nào trong whitelist cần xóa.${NC}"
    else
        echo -e "\n${GREEN}🎉 Đã khôi phục! Bật lại Athena + Xóa ${CYAN}$count${GREEN} app khỏi whitelist.${NC}"
    fi
}

# =====================================================================
# MENU CHÍNH
# =====================================================================
check_device

while true; do
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}VUI LÒNG CHỌN CHỨC NĂNG:${NC}"
    echo -e "  ${GREEN}[1]${NC} 🔔 ${GREEN}Fix thông báo${NC} (Quét app trên máy → Chọn app cần whitelist)"
    echo -e "  ${BLUE}[2]${NC} 🔍 Kiểm tra trạng thái thiết bị & kết nối Google Push"
    echo -e "  ${YELLOW}[3]${NC} 🔄 Khôi phục hệ thống về mặc định (Hoàn tác mọi cài đặt)"
    echo -e "  ${RED}[0]${NC} ❌ Thoát"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Nhập số lựa chọn của bạn [0-3]: " menu_choice

    case $menu_choice in
        1) fix_notifications ;;
        2) check_status ;;
        3) restore_default ;;
        0) echo -e "\n${GREEN}Cảm ơn bạn đã sử dụng tool! Tạm biệt!${NC}\n"; exit 0 ;;
        *) echo -e "${RED}Lựa chọn không hợp lệ, vui lòng chọn từ 0 đến 3!${NC}" ;;
    esac
    echo ""
    read -p "Nhấn [Enter] để quay lại menu chính..."
    clear
done
