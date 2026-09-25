#!/usr/bin/env bash

# ==============================================================================
# KHÔI PHỤC CÁC ỨNG DỤNG HỆ THỐNG ĐÃ TẮT
# ==============================================================================

set -e

echo "Đang khôi phục lại các ứng dụng hệ thống..."

RESTORE_LIST=(
    "com.heytap.pictorial"
    "com.heytap.browser"
    "com.coloros.assistantscreen"
    "com.heytap.quicksearchbox"
    "com.oplus.pay"
    "com.nearme.instant.platform"
    "com.oppo.instant.local.service"
    "com.coloros.operationManual"
    "com.coloros.karaoke"
)

for pkg in "${RESTORE_LIST[@]}"; do
    adb shell pm enable "$pkg" 2>/dev/null && echo "  ✔ Đã bật lại: $pkg" || true
done

echo "Hoàn tất khôi phục!"
