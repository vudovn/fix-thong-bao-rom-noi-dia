#!/usr/bin/env bash

# ==============================================================================
# KHÔI PHỤC ATHENA COLOROS VỀ MẶC ĐỊNH
# ==============================================================================

set -e

echo "Khôi phục lại com.oplus.athena..."
adb shell pm enable com.oplus.athena 2>/dev/null && echo "  ✔ Đã bật lại com.oplus.athena cho User 0" || true
adb shell pm enable --user 999 com.oplus.athena 2>/dev/null && echo "  ✔ Đã bật lại com.oplus.athena cho User 999" || true

echo "Đã khôi phục trạng thái ban đầu!"
