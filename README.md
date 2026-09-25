# 🔔 Fix Thông Báo Android ROM Nội Địa Trung Quốc

[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://github.com/vudovn/fix-thong-bao-rom-noi-dia)
[![Support](https://img.shields.io/badge/Support-OPPO%20%7C%20OnePlus%20%7C%20Realme%20%7C%20Xiaomi%20%7C%20Vivo-green)](https://github.com/vudovn/fix-thong-bao-rom-noi-dia)
[![Author](https://img.shields.io/badge/Author-Vũ%20Đỗ%20(vudovn)-orange)](https://github.com/vudovn)
[![License](https://img.shields.io/badge/License-MIT-purple)](LICENSE)

> **Công cụ mã nguồn mở giúp khắc phục triệt để tình trạng trễ, mất thông báo (Zalo, Messenger, Telegram, Gmail, App Ngân hàng...) trên các dòng điện thoại Android ROM nội địa Trung Quốc.**
>
> 👨‍💻 **Tác giả:** Vũ Đỗ ([@vudovn](https://github.com/vudovn))

---

## 📂 Danh Sách Hỗ Trợ Theo Từng Hãng

Dự án được phân chia theo từng thư mục chuyên biệt cho từng dòng máy để đảm bảo độ tương thích và an toàn tối đa:

| Thư mục | Dòng máy / Giao diện | Trạng thái | Nền tảng hỗ trợ |
| :--- | :--- | :--- | :--- |
| **[`oppo-oneplus-realme/`](oppo-oneplus-realme/)** | OPPO, OnePlus, Realme *(ColorOS / OxygenOS / RealmeUI)* | 🟢 **Sẵn sàng 100%** | Windows (`.bat`) & macOS/Linux (`.sh`) |
| **[`xiaomi-redmi/`](xiaomi-redmi/)** | Xiaomi, Redmi, POCO *(HyperOS / MIUI)* | 🟢 **Sẵn sàng 100%** | Windows (`.bat`) & macOS/Linux (`.sh`) |
| **[`vivo-iqoo/`](vivo-iqoo/)** | Vivo, iQOO *(OriginOS / FuntouchOS)* | 🟡 **Đang phát triển** | Sắp ra mắt |

---

## ✨ Tính Năng Nổi Bật

* ⚡ **Tự động 100% (Zero Configuration):** Tự động phát hiện và tải bộ công cụ Google ADB chính thức về máy tính nếu chưa có. Người dùng không cần cài đặt môi trường lập trình hay biến môi trường phức tạp!
* 🔍 **Quét thông minh & Tự do chọn App:**
  * Tự động quét toàn bộ ứng dụng người dùng đã cài trên điện thoại.
  * Hiển thị danh sách đánh số trực quan kèm tên gói ứng dụng (hoặc tên app thân thiện).
  * Cho phép bạn nhập số để chọn chính xác app bạn muốn fix (ví dụ: `1,3,5` hoặc dải số `1-10`) hoặc gõ `all` để chọn tất cả.
* 🛑 **Vô hiệu hóa trình diệt ngầm hung hãn:**
  * **OPPO / OnePlus / Realme:** Tắt triệt để `com.oplus.athena` (trên cả User chính và Không gian nhân bản / Clone App 999) — nguyên nhân cốt lõi khiến các app bị ép dừng `force-stop`.
  * **Xiaomi / Redmi / POCO:** Nới lỏng Phantom Process Killer, tắt Adaptive Battery, tối ưu Standby Bucket sang `ACTIVE`, giữ kết nối WiFi liên tục khi tắt màn hình, tối ưu JobScheduler.
* 🛡️ **Tự động Whitelist Google Push (FCM / GMS):** Luôn tự động đưa `com.google.android.gms`, `com.google.android.gsf`, `com.android.vending` vào danh sách ngoại lệ tiết kiệm pin (Doze Whitelist) để đảm bảo kết nối push notification không bao giờ bị gián đoạn.
* 🔄 **Khôi phục nguyên trạng (Safe Undo):** Tích hợp sẵn chức năng hoàn tác 100% mọi cài đặt về mặc định của nhà sản xuất bất cứ khi nào bạn muốn.

---

## 📱 Chuẩn Bị Trên Điện Thoại (Bắt buộc)

Trước khi kết nối với máy tính, bạn cần bật chế độ **Gỡ lỗi USB (USB Debugging)**:

### 1. Đối với OPPO / OnePlus / Realme:
1. Vào **Cài đặt** > **Giới thiệu thiết bị** > **Phiên bản** > Nhấn 7 lần liên tục vào **Số bản dựng** (Build number).
2. Quay lại **Cài đặt bổ sung** > **Tùy chọn nhà phát triển** > Bật **Gỡ lỗi USB**.
3. Cắm cáp kết nối với máy tính, trên màn hình điện thoại chọn **Luôn cho phép từ máy tính này** rồi bấm **OK**.

### 2. Đối với Xiaomi / Redmi / POCO:
1. Vào **Cài đặt** > **Giới thiệu điện thoại** > Nhấn 7 lần liên tục vào **Phiên bản OS / MIUI**.
2. Vào **Cài đặt bổ sung** > **Tùy chọn nhà phát triển**:
   * Bật **Gỡ lỗi USB**.
   * Bật **Cài đặt qua USB** (nếu có).
   * Bật **Gỡ lỗi USB (Cài đặt bảo mật)**.
3. Cắm cáp kết nối với máy tính, chọn **Luôn cho phép từ máy tính này** rồi bấm **OK**.

---

## 💻 Hướng Dẫn Sử Dụng

### Dành cho Windows 🪟
1. Tải dự án này về máy tính (bấm nút xanh **Code** > **Download ZIP** rồi giải nén).
2. Nhấp đúp chuột vào tệp: **`run_windows.bat`** ở thư mục gốc (hoặc vào thẳng thư mục hãng máy của bạn và chạy `run_windows.bat`).
3. Chọn hãng điện thoại của bạn, sau đó chọn chức năng **[1] Fix thông báo**.
4. Chọn danh sách các ứng dụng bạn muốn cấp quyền chạy nền không bị trễ thông báo.

### Dành cho macOS / Linux 🍏
1. Tải về và mở ứng dụng **Terminal** tại thư mục dự án.
2. Cấp quyền thực thi và khởi chạy script:
   ```bash
   chmod +x run_mac.sh
   ./run_mac.sh
   ```
3. Chọn hãng điện thoại tương ứng và làm theo hướng dẫn hiển thị trên màn hình.

---

## 📌 3 Bước Quan Trọng Trên Điện Thoại Sau Khi Fix

Sau khi tool chạy xong, để đảm bảo 100% ứng dụng nhận thông báo tức thì như máy chính hãng:
1. **Bật Tự khởi chạy (Auto-launch / Tự khởi động):** Trong Cài đặt > Ứng dụng > Quản lý tự khởi chạy > Bật các app quan trọng (Zalo, Messenger...).
2. **Cho phép hoạt động nền (Không hạn chế pin):** Vào thông tin ứng dụng > Mức sử dụng pin > Chọn *Không hạn chế / Cho phép hoạt động dưới nền*.

---

## 👨‍💻 Tác Giả & Đóng Góp

- Dự án được phát triển và duy trì bởi **Vũ Đỗ ([@vudovn](https://github.com/vudovn))**.
- Mọi đóng góp, báo lỗi (Issue) hoặc đề xuất tính năng mới xin vui lòng gửi về trang GitHub của dự án.

---

## 📄 Giấy Phép (License)

Dự án được phát hành theo giấy phép mã nguồn mở [MIT License](LICENSE). Hoàn toàn miễn phí cho cộng đồng người dùng Android tại Việt Nam!
