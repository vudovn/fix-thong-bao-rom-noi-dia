# 🟡 Module Xiaomi / Redmi / POCO (HyperOS / MIUI)

> ✅ **Trạng thái:** Đã hoàn thiện & Sẵn sàng sử dụng cho HyperOS và MIUI  
> 👨‍💻 **Tác giả:** Vũ Đỗ ([@vudovn](https://github.com/vudovn))

---

Bộ công cụ tối ưu hóa thông báo chuyên sâu cho các dòng máy **Xiaomi, Redmi, POCO** xách tay chạy ROM nội địa Trung Quốc.

---

### 🌟 Cơ chế tối ưu hóa chuyên sâu:

1. **Nới lỏng Phantom Process Killer:**
   * Mở giới hạn tiến trình ngầm (`max_phantom_processes = vô hạn`).
   * Tăng bộ nhớ đệm tiến trình (`max_cached_processes = 256`).
   * Giữ ứng dụng trong RAM lên đến 12 giờ (`max_empty_time_millis = 43200000`).
2. **Tắt hạn chế pin hệ thống:**
   * Tắt `adaptive_battery_management_enabled` & `app_standby_enabled`.
   * Tắt cơ chế `aggressive_battery`.
3. **Tự động quét ứng dụng & Doze Whitelist:**
   * Tự động quét toàn bộ ứng dụng cài trên máy và cho phép người dùng chọn app cần cấp quyền chạy nền.
   * Whitelist tự động các dịch vụ khung của Xiaomi: `com.xiaomi.xmsf`, `com.xiaomi.xmsfkeeper`, `com.miui.notification`.
   * Whitelist tự động các dịch vụ của Google: Google Play Services, Google Framework, Google Play Store.
4. **Kích hoạt Standby Bucket = ACTIVE:**
   * Ép hệ thống Android luôn xếp các app đã chọn vào nhóm ưu tiên cao nhất (ACTIVE).
5. **Giữ kết nối WiFi & Google FCM khi tắt màn hình:**
   * `wifi_sleep_policy = 2` (Không bao giờ ngắt kết nối WiFi khi tắt màn hình).
   * Giữ socket push notification liên tục.
6. **Nới lỏng JobScheduler của HyperOS / MIUI:**
   * Không trì hoãn tác vụ push của các app liên lạc quan trọng.

---

### 💻 Cách sử dụng:

* **Trên Windows:** Nhấp đúp chuột vào file **`run_windows.bat`**.
* **Trên macOS / Linux:** Cấp quyền và chạy **`./run_mac.sh`**.
