#!/usr/bin/env bash

# ==============================================================================
# OPPO COLOROS DEBLOAT SCRIPT (AN TOÀN - ĐÃ GIỮ LẠI TRỢ LÝ ẢO BREENO / AI)
# ==============================================================================

set -e

echo "=========================================================="
echo "    BẮT ĐẦU DỌN DẸP APP RÁC NỘI ĐỊA TRUNG (COLOROS)       "
echo "=========================================================="

DEVICE_COUNT=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "❌ Lỗi: Không tìm thấy thiết bị Android nào!"
    exit 1
fi

# DANH SÁCH APP RÁC CẦN TẮT (ĐÃ LOẠI TRỪ TRỢ LÝ ẢO TIẾNG TRUNG THEO YÊU CẦU)
BLOAT_LIST=(
    "com.heytap.pictorial"                  # Tạp chí màn hình khóa (quảng cáo hình nền)
    "com.heytap.browser"                    # Trình duyệt HeyTap nội địa (tin tức tiếng Trung)
    "com.coloros.assistantscreen"           # Màn hình tin tức vuốt bên trái
    "com.heytap.quicksearchbox"             # Thanh tìm kiếm tiếng Trung (Baidu)
    "com.oplus.pay"                         # Ví tiền nội địa Trung Quốc
    "com.nearme.instant.platform"           # Nền tảng Quick App quảng cáo
    "com.oppo.instant.local.service"        # Dịch vụ Quick App
    "com.coloros.operationManual"           # Hướng dẫn sử dụng tiếng Trung
    "com.coloros.karaoke"                   # ColorOS Karaoke
)

for pkg in "${BLOAT_LIST[@]}"; do
    if adb shell pm path "$pkg" >/dev/null 2>&1; then
        adb shell pm disable-user --user 0 "$pkg" >/dev/null 2>&1 && echo "  ✔ Đã vô hiệu hóa: $pkg" || true
    fi
done

echo "----------------------------------------------------------"
echo "✅ ĐÃ DỌN XONG APP RÁC! (TRỢ LÝ ẢO BREENO/AI ĐÃ ĐƯỢC GIỮ NGUYÊN)"
echo "=========================================================="
