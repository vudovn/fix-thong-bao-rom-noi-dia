#!/usr/bin/env bash

# ==============================================================================
# TOOL FIX THÔNG BÁO CHO XIAOMI / REDMI / POCO (HYPEROS / MIUI)
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
echo -e "${GREEN}    XIAOMI / REDMI NOTIFICATION FIX TOOL (macOS / Linux)              ${NC}"
echo -e "${YELLOW}         Fix trễ thông báo cho HyperOS & MIUI nội địa Trung          ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

# 1. KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ADB
BIN_DIR="$(pwd)/../bin"
ADB_BIN=""

if command -v adb >/dev/null 2>&1; then
    ADB_BIN="$(command -v adb)"
    echo -e "${GREEN}✔ Đã tìm thấy ADB trên hệ thống:${NC} $ADB_BIN"
elif [ -f "$BIN_DIR/platform-tools/adb" ]; then
    ADB_BIN="$BIN_DIR/platform-tools/adb"
    echo -e "${GREEN}✔ Đã tìm thấy ADB cục bộ:${NC} $ADB_BIN"
else
    echo -e "${YELLOW}⚡ Chưa có ADB. Đang tự động tải Google Platform-Tools về...${NC}"
    mkdir -p "$BIN_DIR"
    OS_TYPE="$(uname -s)"
    if [ "$OS_TYPE" = "Darwin" ]; then
        DOWNLOAD_URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    else
        DOWNLOAD_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
    fi
    curl -L -o "$BIN_DIR/platform-tools.zip" "$DOWNLOAD_URL" --progress-bar
    unzip -q -o "$BIN_DIR/platform-tools.zip" -d "$BIN_DIR"
    rm -f "$BIN_DIR/platform-tools.zip"
    chmod +x "$BIN_DIR/platform-tools/adb"
    ADB_BIN="$BIN_DIR/platform-tools/adb"
    echo -e "${GREEN}✔ Đã thiết lập xong ADB!${NC}\n"
fi

# 2. KIỂM TRA KẾT NỐI THIẾT BỊ
check_device() {
    echo -e "${BLUE}▶ Đang kiểm tra kết nối điện thoại Xiaomi qua USB...${NC}"
    $ADB_BIN start-server >/dev/null 2>&1
    DEVICES_OUTPUT=$($ADB_BIN devices | grep -v "List" | grep -v "^$" || true)

    if [ -z "$DEVICES_OUTPUT" ]; then
        echo -e "${RED}❌ Chưa phát hiện điện thoại nào kết nối!${NC}"
        echo -e "${YELLOW}👉 Hướng dẫn bật Gỡ lỗi trên Xiaomi / HyperOS:${NC}"
        echo -e "  1. Vào ${CYAN}Cài đặt > Giới thiệu điện thoại${NC} > Bấm 7 lần vào ${CYAN}'Phiên bản OS / MIUI'${NC}."
        echo -e "  2. Vào ${CYAN}Cài đặt bổ sung > Tùy chọn nhà phát triển${NC}:"
        echo -e "     - Bật ${GREEN}'Gỡ lỗi USB'${NC}."
        echo -e "     - Bật ${GREEN}'Cài đặt qua USB'${NC}."
        echo -e "     - Bật ${GREEN}'Gỡ lỗi USB (Cài đặt bảo mật)'${NC} (Yêu cầu đăng nhập tài khoản Mi)."
        echo -e "  3. Cắm cáp, chọn ${GREEN}'Luôn cho phép từ máy tính này'${NC} rồi bấm OK."
        echo ""
        read -p "Sau khi cắm và cho phép xong, nhấn [Enter] để thử lại..."
        check_device
        return
    fi

    if echo "$DEVICES_OUTPUT" | grep -q "unauthorized"; then
        echo -e "${YELLOW}⚠️ Thiết bị chưa được ủy quyền! Mở khóa màn hình và bấm Cho phép.${NC}"
        read -p "Nhấn [Enter] sau khi đã bấm cho phép trên điện thoại..."
        check_device
        return
    fi

    DEV_MODEL=$($ADB_BIN shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEV_ROM=$($ADB_BIN shell getprop ro.build.display.id 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}✔ Đã kết nối:${NC} ${CYAN}$DEV_MODEL${NC} (ROM: ${YELLOW}$DEV_ROM${NC})\n"
}

# =====================================================================
# BẢNG TRA TÊN APP
# =====================================================================
get_app_name() {
    case "$1" in
        "com.google.android.gms") echo "Google Play Services" ;;
        "com.google.android.gsf") echo "Google Services Framework" ;;
        "com.android.vending") echo "Google Play Store" ;;
        "com.xiaomi.xmsf") echo "Xiaomi Push Service" ;;
        "com.xiaomi.xmsfkeeper") echo "Xiaomi Push Keeper" ;;
        "com.miui.notification") echo "MIUI Notification" ;;
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
        "com.chotot.vn") echo "Chợ Tốt" ;;
        "com.bachhoaxanh") echo "Bách Hóa Xanh" ;;
        "com.alibaba.aliexpresshd") echo "AliExpress" ;;
        "com.lazada.android") echo "Lazada" ;;
        "vn.tiki.app.tikiandroid") echo "Tiki" ;;
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
        "io.metamask") echo "MetaMask" ;;
        "app.phantom") echo "Phantom" ;;
        "com.google.android.apps.authenticator2") echo "Google Authenticator" ;;
        "com.azure.authenticator") echo "Microsoft Authenticator" ;;
        "com.valvesoftware.android.steam.community") echo "Steam Guard" ;;
        "com.google.android.googlequicksearchbox") echo "Google Search" ;;
        "com.google.android.apps.maps") echo "Google Maps" ;;
        *) echo "" ;;
    esac
}

# Google + Xiaomi services luôn tự động whitelist
AUTO_WHITELIST=(
    "com.google.android.gms"
    "com.google.android.gsf"
    "com.android.vending"
    "com.xiaomi.xmsf"
    "com.xiaomi.xmsfkeeper"
    "com.miui.notification"
)

# =====================================================================
# FIX THÔNG BÁO - QUÉT TỰ ĐỘNG + CHỌN SỐ
# =====================================================================
fix_xiaomi_notifications() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}     FIX TRỄ THÔNG BÁO XIAOMI (HYPEROS / MIUI) - QUÉT TỰ ĐỘNG       ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}[1/6] Nới lỏng Phantom Process Killer...${NC}"
    $ADB_BIN shell /system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1
    $ADB_BIN shell device_config put activity_manager max_cached_processes 256 >/dev/null 2>&1
    $ADB_BIN shell device_config put activity_manager max_empty_time_millis 43200000 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ max_phantom_processes = vô hạn${NC}"

    echo -e "\n${BLUE}[2/6] Tắt Adaptive Battery & App Standby...${NC}"
    $ADB_BIN shell settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global app_standby_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global forced_app_standby_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global aggressive_battery 0 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã tắt ngủ sâu Adaptive Battery${NC}"

    echo -e "\n${BLUE}[3/6] Tự động whitelist dịch vụ Google & Xiaomi Push...${NC}"
    for pkg in "${AUTO_WHITELIST[@]}"; do
        $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
        echo -e "  ${GREEN}✔ Auto:${NC} $pkg"
    done

    # Quét app trên máy
    echo -e "\n${BLUE}[4/6] Quét tất cả ứng dụng bên thứ 3 trên máy...${NC}"
    echo -e "${YELLOW}⏳ Đang quét...${NC}\n"

    SCAN_LIST=()
    SCAN_NAMES=()
    while IFS= read -r line; do
        pkg=$(echo "$line" | sed 's/package://' | tr -d '\r')
        [ -z "$pkg" ] && continue
        skip=0
        for g in "${AUTO_WHITELIST[@]}"; do
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
        echo -e "${YELLOW}Không tìm thấy app bên thứ 3 nào.${NC}"
    else
        echo -e "${GREEN}Tìm thấy ${CYAN}$TOTAL${GREEN} ứng dụng bên thứ 3:${NC}\n"
        echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
        for i in "${!SCAN_LIST[@]}"; do
            NUM=$((i + 1))
            printf "  ${GREEN}[%3d]${NC} %-35s ${PURPLE}%s${NC}\n" "$NUM" "${SCAN_NAMES[$i]}" "${SCAN_LIST[$i]}"
        done
        echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"

        echo ""
        echo -e "${YELLOW}📌 Hướng dẫn chọn:${NC}"
        echo -e "  • Nhập số: ${CYAN}1,3,5,7${NC} hoặc khoảng: ${CYAN}1-10${NC}"
        echo -e "  • Nhập ${CYAN}all${NC} hoặc nhấn ${CYAN}Enter${NC} để chọn TẤT CẢ"
        echo ""
        read -p "Nhập số app cần fix thông báo: " selection

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

        echo -e "\n${BLUE}Đang whitelist ${#SELECTED[@]} app...${NC}"
        for idx in "${SELECTED[@]}"; do
            pkg="${SCAN_LIST[$idx]}"
            $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
            $ADB_BIN shell am set-standby-bucket "$pkg" active >/dev/null 2>&1
            echo -e "  ${GREEN}✔ Whitelist + Active:${NC} ${SCAN_NAMES[$idx]}"
        done
    fi

    echo -e "\n${BLUE}[5/6] Giữ kết nối WiFi & FCM khi tắt màn hình...${NC}"
    $ADB_BIN shell settings put global wifi_sleep_policy 2 >/dev/null 2>&1
    $ADB_BIN shell settings put global wifi_idle_ms 2147483647 >/dev/null 2>&1
    $ADB_BIN shell settings put global always_finish_activities 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global wifi_wakeup_enabled 1 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ WiFi luôn giữ kết nối${NC}"

    echo -e "\n${BLUE}[6/6] Tối ưu PowerKeeper & JobScheduler...${NC}"
    $ADB_BIN shell setprop persist.sys.max_bg_processes 60 >/dev/null 2>&1
    $ADB_BIN shell settings put global restrict_background 0 >/dev/null 2>&1
    $ADB_BIN shell device_config put jobscheduler qc_timing_constraints_enabled false >/dev/null 2>&1
    $ADB_BIN shell device_config put jobscheduler qc_updated_jobs_per_uid_window 99999 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã tối ưu JobScheduler${NC}"

    echo -e "\n${GREEN}🎉 HOÀN TẤT FIX THÔNG BÁO XIAOMI!${NC}"
}

# =====================================================================
# KIỂM TRA TRẠNG THÁI
# =====================================================================
check_xiaomi_status() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KIỂM TRA TRẠNG THÁI THIẾT BỊ XIAOMI                       ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}1. Phantom Process Killer:${NC}"
    PHANTOM_VAL=$($ADB_BIN shell /system/bin/device_config get activity_manager max_phantom_processes 2>/dev/null | tr -d '\r')
    if [ "$PHANTOM_VAL" = "2147483647" ]; then
        echo -e "   ${GREEN}✔ ĐÃ MỞ GIỚI HẠN (vô hạn)${NC}"
    else
        echo -e "   ${YELLOW}⚠️ Giới hạn: $PHANTOM_VAL (nên chạy Fix)${NC}"
    fi

    echo -e "\n${BLUE}2. Adaptive Battery:${NC}"
    ADAPTIVE=$($ADB_BIN shell settings get global adaptive_battery_management_enabled 2>/dev/null | tr -d '\r')
    STANDBY=$($ADB_BIN shell settings get global app_standby_enabled 2>/dev/null | tr -d '\r')
    [ "$ADAPTIVE" = "0" ] && [ "$STANDBY" = "0" ] && echo -e "   ${GREEN}✔ ĐÃ TẮT${NC}" || echo -e "   ${RED}✗ ĐANG BẬT${NC}"

    echo -e "\n${BLUE}3. WiFi Sleep:${NC}"
    WIFI=$($ADB_BIN shell settings get global wifi_sleep_policy 2>/dev/null | tr -d '\r')
    [ "$WIFI" = "2" ] && echo -e "   ${GREEN}✔ LUÔN GIỮ KẾT NỐI${NC}" || echo -e "   ${YELLOW}⚠️ Có thể ngắt khi tắt màn hình${NC}"

    echo -e "\n${BLUE}4. Google Push (FCM):${NC}"
    FCM=$($ADB_BIN shell dumpsys activity service com.google.android.gms/.gcm.GcmService 2>/dev/null | grep -i "connected=" | head -n 1 || true)
    [ -n "$FCM" ] && echo -e "   ${GREEN}✔ $FCM${NC}" || echo -e "   ${YELLOW}⚠️ Chưa xác định${NC}"

    echo -e "\n${BLUE}5. Doze Whitelist:${NC}"
    WL=$($ADB_BIN shell dumpsys deviceidle whitelist | grep -c "user," 2>/dev/null || echo "0")
    echo -e "   Tổng: ${CYAN}$WL${NC} app"
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
restore_xiaomi() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KHÔI PHỤC CÀI ĐẶT GỐC XIAOMI                              ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}Đang khôi phục cài đặt hệ thống...${NC}"
    $ADB_BIN shell /system/bin/device_config put activity_manager max_phantom_processes 32 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Phantom Process Killer → mặc định (32)${NC}"
    $ADB_BIN shell settings put global adaptive_battery_management_enabled 1 >/dev/null 2>&1
    $ADB_BIN shell settings put global app_standby_enabled 1 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Adaptive Battery → bật lại${NC}"
    $ADB_BIN shell settings put global wifi_sleep_policy 0 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ WiFi Sleep Policy → mặc định${NC}"

    echo -e "\n${BLUE}Đang xóa toàn bộ Doze Whitelist do user thêm...${NC}"
    count=0
    while IFS= read -r line; do
        PKG=$(echo "$line" | grep "user," | cut -d',' -f2 | tr -d '\r')
        [ -z "$PKG" ] && continue
        $ADB_BIN shell dumpsys deviceidle whitelist -"$PKG" >/dev/null 2>&1
        echo -e "  ${GREEN}✔ Xóa whitelist:${NC} $PKG"
        ((count++))
    done < <($ADB_BIN shell dumpsys deviceidle whitelist 2>/dev/null)

    [ "$count" -eq 0 ] && echo -e "  ${YELLOW}Không có app nào cần xóa.${NC}" || echo -e "\n${GREEN}🎉 Đã khôi phục toàn bộ!${NC}"
}

# =====================================================================
# MENU CHÍNH
# =====================================================================
check_device

while true; do
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}CHỨC NĂNG DÀNH CHO XIAOMI / REDMI / POCO:${NC}"
    echo -e "  ${GREEN}[1]${NC} 🔔 ${GREEN}Fix thông báo${NC} (Quét app trên máy → Chọn app cần whitelist)"
    echo -e "  ${BLUE}[2]${NC} 🔍 Kiểm tra trạng thái thiết bị & kết nối Google Push"
    echo -e "  ${YELLOW}[3]${NC} 🔄 Khôi phục hệ thống về mặc định"
    echo -e "  ${RED}[0]${NC} ❌ Thoát"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Nhập lựa chọn của bạn [0-3]: " choice

    case $choice in
        1) fix_xiaomi_notifications ;;
        2) check_xiaomi_status ;;
        3) restore_xiaomi ;;
        0) echo -e "\n${GREEN}Tạm biệt!${NC}\n"; exit 0 ;;
        *) echo -e "${RED}Lựa chọn không hợp lệ!${NC}" ;;
    esac
    echo ""
    read -p "Nhấn [Enter] để quay lại menu..."
    clear
done
