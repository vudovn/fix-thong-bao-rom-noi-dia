# 🟡 Module Xiaomi / Redmi / POCO (HyperOS / MIUI)

> ✅ **Trạng thái:** Đã hoàn thiện & Sẵn sàng sử dụng cho HyperOS và MIUI

Bộ công cụ tối ưu hóa thông báo chuyên sâu cho các dòng máy **Xiaomi, Redmi, POCO** xách tay chạy ROM nội địa Trung Quốc.

---

### 🌟 6 Bước tối ưu hóa chuyên sâu:

1. **Nới lỏng Phantom Process Killer:**
   * Mở giới hạn tiến trình ngầm (`max_phantom_processes = vô hạn`).
   * Tăng bộ nhớ đệm tiến trình (`max_cached_processes = 256`).
   * Giữ ứng dụng trong RAM lên đến 12 giờ (`max_empty_time_millis = 43200000`).
2. **Tắt hạn chế pin gắt gao:**
   * Tắt `adaptive_battery_management_enabled` & `app_standby_enabled`.
   * Tắt cơ chế `aggressive_battery`.
3. **Doze Whitelist 50+ ứng dụng:**
   * Cấp quyền không ngủ đông cho toàn bộ các app liên lạc, ngân hàng, ví điện tử, sàn TMĐT tại Việt Nam (Zalo, Messenger, Telegram, VNeID, eTax, Grab, Shopee...).
   * Whitelist các dịch vụ khung của Xiaomi: `com.xiaomi.xmsf`, `com.xiaomi.xmsfkeeper`, `com.miui.notification`.
4. **Kích hoạt Standby Bucket = ACTIVE:**
   * Ép hệ thống Android luôn xếp các app liên lạc vào nhóm ưu tiên cao nhất (ACTIVE).
5. **Giữ kết nối WiFi & Google FCM khi tắt màn hình:**
   * `wifi_sleep_policy = 2` (Không bao giờ ngắt WiFi khi tắt màn hình).
   * Giữ kết nối socket push notification liên tục.
6. **Tối ưu hóa JobScheduler & PowerKeeper của HyperOS / MIUI:**
   * Nới lỏng lịch trình tác vụ ngầm của HyperOS.
   * Dọn dẹp các dịch vụ quảng cáo cốt lõi: MSA, MIUI Analytics, Mi Video...

---

### 💻 Cách sử dụng:

* **Trên Windows:** Nhấp đúp chuột vào file **`run_windows.bat`** (hoặc chạy qua PowerShell với `fix_noti.ps1`).
* **Trên macOS / Linux:** Chạy **`./run_mac.sh`**.
