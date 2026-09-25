#!/usr/bin/env bash

# ==============================================================================
# TOOL FIX THÔNG BÁO & DỌN APP RÁC CHO XIAOMI / REDMI / POCO (HYPEROS / MIUI)
# Hỗ trợ: macOS & Linux
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
echo -e "${GREEN}    XIAOMI / REDMI NOTIFICATION FIX & DEBLOAT TOOL (macOS / Linux)    ${NC}"
echo -e "${YELLOW}       Hỗ trợ tối ưu thông báo & dọn rác cho HyperOS & MIUI           ${NC}"
echo -e "${CYAN}======================================================================${NC}"
echo ""

# 1. KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ADB NẾU CHƯA CÓ
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
        echo -e "     - Bật ${GREEN}'Gỡ lỗi USB (Cài đặt bảo mật)'${NC} (Yêu cầu lắp SIM và đăng nhập tài khoản Mi)."
        echo -e "  3. Cắm cáp, chọn ${GREEN}'Luôn cho phép từ máy tính này'${NC} rồi bấm OK."
        echo ""
        read -p "Sau khi cắm và cho phép xong, nhấn [Enter] để thử lại..."
        check_device
        return
    fi
    
    if echo "$DEVICES_OUTPUT" | grep -q "unauthorized"; then
        echo -e "${YELLOW}⚠️ Thiết bị chưa được ủy quyền! Mở khóa màn hình điện thoại và bấm Cho phép.${NC}"
        read -p "Nhấn [Enter] sau khi đã bấm cho phép trên điện thoại..."
        check_device
        return
    fi
    
    DEV_MODEL=$($ADB_BIN shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEV_ROM=$($ADB_BIN shell getprop ro.build.display.id 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}✔ Đã kết nối:${NC} ${CYAN}$DEV_MODEL${NC} (ROM: ${YELLOW}$DEV_ROM${NC})\n"
}

# DANH SÁCH APP CẦN BẢO VỆ THÔNG BÁO (50+ APPS)
APP_LIST=(
    # Hệ thống Xiaomi & Google
    "com.google.android.gms"
    "com.google.android.gsf"
    "com.android.vending"
    "com.google.android.googlequicksearchbox"
    "com.google.android.apps.maps"
    "com.xiaomi.xmsf"
    "com.xiaomi.xmsfkeeper"
    "com.miui.notification"

    # Nhắn tin & MXH
    "com.zing.zalo"
    "com.facebook.orca"
    "com.facebook.katana"
    "com.facebook.pages.app"
    "org.telegram.messenger"
    "com.whatsapp"
    "com.whatsapp.w4b"
    "com.viber.voip"
    "com.instagram.android"
    "com.instagram.barcelona"
    "com.twitter.android"
    "com.discord"
    "com.locket.Locket"
    "com.ss.android.ugc.trill"
    "com.ss.android.ugc.aweme"
    "com.tencent.mm"
    "jp.naver.line.android"
    "com.skype.raider"
    "com.microsoft.teams"
    "com.Slack"
    "com.linkedin.android"

    # Email & Công việc
    "com.google.android.gm"
    "com.microsoft.office.outlook"
    "com.openai.chatgpt"
    "ai.x.grok"
    "com.google.android.apps.bard"
    "com.anthropic.claude"
    "com.github.android"

    # Dịch vụ công & Đời sống
    "com.vnid"
    "com.etax.icanhan"
    "vss.gov.vssapp"
    "com.windyty.android"

    # Mua sắm & Đặt xe
    "com.grabtaxi.passenger"
    "com.gsm.customer"
    "com.shopee.vn"
    "com.deliverynow"
    "com.be.customer"
    "com.chotot.vn"
    "com.bachhoaxanh"
    "com.alibaba.aliexpresshd"
    "com.lazada.android"
    "vn.tiki.app.tikiandroid"

    # Ngân hàng & Tài chính
    "com.mbmobile"
    "com.vnpay.vpbankonline"
    "com.VCB"
    "vn.com.techcombank.bb.app"
    "com.vnpay.bidv"
    "com.vietinbank.ipay"
    "mobile.acb.com.vn"
    "vn.tpbank.mb"
    "com.mservice.momotransfer"
    "vn.com.vng.zalopay"
    "vn.viettel.viettelpay"
    "vn.com.hdsaison.hpo"
    "com.paypal.android.p2pmobile"
    "com.sepay.trans"

    # Tiền mã hóa & Bảo mật 2FA
    "com.binance.dev"
    "com.bybit.app"
    "io.metamask"
    "app.phantom"
    "com.google.android.apps.authenticator2"
    "com.azure.authenticator"
    "com.valvesoftware.android.steam.community"
)

# DANH SÁCH APP RÁC QUẢNG CÁO NỘI ĐỊA XIAOMI (DEBLOAT)
XIAOMI_BLOAT_LIST=(
    "com.miui.analytics"                    # Thu thập dữ liệu & theo dõi quảng cáo
    "com.miui.systemAdSolution"             # Dịch vụ phân phối quảng cáo cốt lõi (MSA)
    "com.miui.msa.global"                   # MSA Global
    "com.android.browser"                   # Trình duyệt Mi Browser (toàn tin tức TQ)
    "com.miui.video"                        # Mi Video
    "com.miui.player"                       # Mi Music TQ
    "com.miui.yellowpage"                   # Trang vàng Trung Quốc
    "com.xiaomi.mirecycle"                  # Thu cũ đổi mới TQ
    "com.miui.bugreport"                    # Báo cáo lỗi chạy ngầm
    "com.xiaomi.gamecenter"                 # Game Center TQ
    "com.miui.hybrid"                       # Quick App / Ứng dụng tức thì quảng cáo
    "com.miui.hybrid.accessory"             # Quick App Engine
)

# 1. FIX THÔNG BÁO CHUYÊN SÂU CHO XIAOMI / HYPEROS
fix_xiaomi_notifications() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}       TIẾN HÀNH FIX TRỄ THÔNG BÁO CHO XIAOMI (HYPEROS / MIUI)        ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}[1/6] Nới lỏng Phantom Process Killer...${NC}"
    $ADB_BIN shell /system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1
    $ADB_BIN shell device_config put activity_manager max_cached_processes 256 >/dev/null 2>&1
    $ADB_BIN shell device_config put activity_manager max_empty_time_millis 43200000 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã mở giới hạn tiến trình ảo (Phantom Process Killer = vô hạn)${NC}"

    echo -e "\n${BLUE}[2/6] Tắt cơ chế ép ngủ Adaptive Battery & App Standby...${NC}"
    $ADB_BIN shell settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global app_standby_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global forced_app_standby_enabled 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global aggressive_battery 0 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã tắt giới hạn ngủ sâu Adaptive Battery${NC}"

    echo -e "\n${BLUE}[3/6] Cấp quyền miễn ngủ đông (Doze Whitelist) cho 50+ app...${NC}"
    count=0
    for pkg in "${APP_LIST[@]}"; do
        if $ADB_BIN shell pm path "$pkg" >/dev/null 2>&1; then
            $ADB_BIN shell dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
            echo -e "  ${GREEN}✔ Doze Whitelist:${NC} $pkg"
            ((count++))
        fi
    done

    echo -e "\n${BLUE}[4/6] Thiết lập Standby Bucket = ACTIVE cho các app liên lạc...${NC}"
    for pkg in "${APP_LIST[@]}"; do
        if $ADB_BIN shell pm path "$pkg" >/dev/null 2>&1; then
            $ADB_BIN shell am set-standby-bucket "$pkg" active >/dev/null 2>&1
        fi
    done
    echo -e "  ${GREEN}✔ Đã kích hoạt Standby Bucket ACTIVE${NC}"

    echo -e "\n${BLUE}[5/6] Tối ưu hóa giữ kết nối WiFi & Google FCM khi màn hình tắt...${NC}"
    $ADB_BIN shell settings put global wifi_sleep_policy 2 >/dev/null 2>&1
    $ADB_BIN shell settings put global wifi_idle_ms 2147483647 >/dev/null 2>&1
    $ADB_BIN shell settings put global always_finish_activities 0 >/dev/null 2>&1
    $ADB_BIN shell settings put global wifi_wakeup_enabled 1 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã bật giữ kết nối mạng WiFi/FCM liên tục${NC}"

    echo -e "\n${BLUE}[6/6] Tối ưu hóa HyperOS / MIUI PowerKeeper & JobScheduler...${NC}"
    $ADB_BIN shell setprop persist.sys.max_bg_processes 60 >/dev/null 2>&1
    $ADB_BIN shell settings put global restrict_background 0 >/dev/null 2>&1
    $ADB_BIN shell device_config put jobscheduler qc_timing_constraints_enabled false >/dev/null 2>&1
    $ADB_BIN shell device_config put jobscheduler qc_updated_jobs_per_uid_window 99999 >/dev/null 2>&1
    echo -e "  ${GREEN}✔ Đã tối ưu hóa lịch trình tác vụ JobScheduler${NC}"

    echo -e "\n${GREEN}🎉 HOÀN TẤT FIX THÔNG BÁO CHO XIAOMI! (Đã tối ưu $count app)${NC}"
}

# 2. DỌN APP RÁC QUẢNG CÁO XIAOMI (DEBLOAT)
debloat_xiaomi() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           TIẾN HÀNH DỌN APP RÁC QUẢNG CÁO XIAOMI / HYPEROS           ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}Đang vô hiệu hóa các dịch vụ quảng cáo và app rác...${NC}"
    for pkg in "${XIAOMI_BLOAT_LIST[@]}"; do
        if $ADB_BIN shell pm path "$pkg" >/dev/null 2>&1; then
            $ADB_BIN shell pm disable-user --user 0 "$pkg" >/dev/null 2>&1
            echo -e "  ${GREEN}✔ Đã tắt app rác/quảng cáo:${NC} $pkg"
        fi
    done
    echo -e "\n${GREEN}🎉 Đã dọn dẹp sạch sẽ quảng cáo và app rác MIUI/HyperOS!${NC}"
}

# 3. KHÔI PHỤC MẶC ĐỊNH
restore_xiaomi() {
    echo -e "\n${CYAN}======================================================================${NC}"
    echo -e "${YELLOW}           KHÔI PHỤC CÀI ĐẶT GỐC CHO XIAOMI                          ${NC}"
    echo -e "${CYAN}======================================================================${NC}"

    echo -e "\n${BLUE}Đang bật lại các ứng dụng hệ thống đã tắt...${NC}"
    for pkg in "${XIAOMI_BLOAT_LIST[@]}"; do
        $ADB_BIN shell pm enable "$pkg" 2>/dev/null && echo -e "  ${GREEN}✔ Đã bật lại:${NC} $pkg" || true
    done
    echo -e "\n${GREEN}🎉 Đã khôi phục các ứng dụng hệ thống về mặc định!${NC}"
}

# MENU CHÍNH
check_device

while true; do
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}CHỨC NĂNG DÀNH CHO XIAOMI / REDMI / POCO:${NC}"
    echo -e "  ${GREEN}[1]${NC} 🚀 ${GREEN}CHẠY TẤT CẢ (Khuyên dùng):${NC} Fix 6 bước thông báo + Dọn rác quảng cáo"
    echo -e "  ${CYAN}[2]${NC} 🔔 Chỉ Fix trễ thông báo 6 bước (Phantom killer, Doze, Standby, WiFi)"
    echo -e "  ${CYAN}[3]${NC} 🧹 Chỉ Dọn app rác & quảng cáo MIUI/HyperOS (MSA, Analytics, Mi Video...)"
    echo -e "  ${YELLOW}[4]${NC} 🔄 Khôi phục các app hệ thống đã tắt"
    echo -e "  ${RED}[0]${NC} ❌ Thoát"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Nhập lựa chọn của bạn [0-4]: " choice

    case $choice in
        1)
            fix_xiaomi_notifications
            debloat_xiaomi
            ;;
        2)
            fix_xiaomi_notifications
            ;;
        3)
            debloat_xiaomi
            ;;
        4)
            restore_xiaomi
            ;;
        0)
            echo -e "\n${GREEN}Tạm biệt! Cảm ơn bạn đã sử dụng tool.${NC}\n"
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ!${NC}"
            ;;
    esac
    echo ""
    read -p "Nhấn [Enter] để quay lại menu..."
    clear
done
