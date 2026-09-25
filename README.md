# 🚀 Fix Thông Báo Android ROM Nội Địa Trung Quốc

[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://github.com/)
[![Support](https://img.shields.io/badge/Support-OPPO%20%7C%20OnePlus%20%7C%20Realme%20%7C%20Xiaomi%20%7C%20Vivo-green)](https://github.com/)
[![License](https://img.shields.io/badge/License-MIT-purple)](LICENSE)

Bộ công cụ mã nguồn mở **tự động hóa 1-Click** giúp **khắc phục triệt để tình trạng chậm/mất thông báo** (Zalo, Messenger, Telegram, Gmail...) và **dọn sạch ứng dụng rác nội địa Trung Quốc** trên các dòng điện thoại Android xách tay nội địa Trung Quốc (OPPO, OnePlus, Realme, Xiaomi, Vivo...).

---

## 📂 Cấu Trúc Dự Án Theo Từng Hãng

Dự án được phân chia theo từng thư mục chuyên biệt cho từng dòng máy để đảm bảo độ tương thích và an toàn tối đa:

| Thư mục | Dòng máy / Hệ điều hành | Trạng thái |
| :--- | :--- | :--- |
| **[`oppo-oneplus-realme/`](oppo-oneplus-realme/)** | OPPO, OnePlus, Realme (ColorOS / OxygenOS / RealmeUI) | 🟢 **Sẵn sàng 100%** (ColorOS 14, 15, 16, 17) |
| **[`xiaomi-redmi/`](xiaomi-redmi/)** | Xiaomi, Redmi, POCO (HyperOS / MIUI) | 🟢 **Sẵn sàng 100%** (HyperOS & MIUI) |
| **[`vivo-iqoo/`](vivo-iqoo/)** | Vivo, iQOO (OriginOS / FuntouchOS) | 🟡 **Đang phát triển** |

---

## ✨ Tính Năng Nổi Bật

* ⚡ **Tự động 100% (Zero Configuration):** Tự động phát hiện, tải và cấu hình bộ công cụ Google ADB chính thức nếu máy tính chưa có. Người dùng không cần cài đặt môi trường phức tạp!
* 🛑 **Vô hiệu hóa trình diệt ngầm chuyên sâu:** 
  * **OPPO / OnePlus / Realme:** Vô hiệu hóa `com.oplus.athena` (nguyên nhân cốt lõi khiến app bị ép dừng `force-stop`).
  * **Xiaomi / Redmi / POCO:** Nới lỏng Phantom Process Killer, tắt Adaptive Battery, tối ưu Standby Bucket sang ACTIVE, khóa giữ kết nối WiFi liên tục.
* 🛡️ **Doze Whitelist cho hơn 50+ ứng dụng:** Cấp quyền miễn ngủ đông cho toàn bộ các app liên lạc, ngân hàng, ví điện tử, sàn TMĐT, đặt xe và dịch vụ công phổ biến tại Việt Nam (Zalo, Messenger, Telegram, VNeID, eTax, MB Bank, Techcombank, Grab, Shopee...).
* 🧹 **Dọn sạch app rác nội địa Trung (Debloat):** Tắt tạp chí màn hình khóa quảng cáo tiếng Trung, trình duyệt nội địa, màn hình tin tức bên trái, dịch vụ quảng cáo MSA/Analytics...
* 🤖 **Tùy chọn thông minh:** Cho phép lựa chọn giữ lại Trợ lý ảo AI nội địa nếu bạn có nhu cầu.
* 🔄 **Hoàn tác an toàn 100%:** Tích hợp sẵn chức năng khôi phục nguyên trạng gốc của máy bất cứ lúc nào chỉ với 1 click.

---

## 📱 Chuẩn Bị Trên Điện Thoại (Bắt buộc)

Trước khi kết nối với máy tính, bạn cần bật chế độ **Gỡ lỗi USB**:

### Với OPPO / OnePlus / Realme:
1. Vào **Cài đặt** > **Giới thiệu thiết bị** > **Phiên bản** > Nhấn 7 lần vào **Số bản dựng**.
2. Vào **Cài đặt bổ sung** > **Tùy chọn nhà phát triển** > Bật **Gỡ lỗi USB**.
3. Cắm cáp, chọn **Luôn cho phép từ máy tính này** rồi bấm **OK**.

### Với Xiaomi / Redmi / POCO:
1. Vào **Cài đặt** > **Giới thiệu điện thoại** > Nhấn 7 lần vào **Phiên bản OS / MIUI**.
2. Vào **Cài đặt bổ sung** > **Tùy chọn nhà phát triển**:
   * Bật **Gỡ lỗi USB**.
   * Bật **Cài đặt qua USB**.
   * Bật **Gỡ lỗi USB (Cài đặt bảo mật)**.
3. Cắm cáp, chọn **Luôn cho phép từ máy tính này** rồi bấm **OK**.

---

## 💻 Hướng Dẫn Sử Dụng

### Dành cho Windows 🪟
1. Tải toàn bộ thư mục mã nguồn này về máy tính (hoặc bấm `Code` > `Download ZIP` rồi giải nén).
2. Nhấp đúp chuột vào tệp: **`run_windows.bat`** ở thư mục gốc (hoặc vào thẳng thư mục hãng máy của bạn).
3. Chọn hãng điện thoại và chức năng bạn muốn chạy.

### Dành cho macOS / Linux 🍏
1. Mở cửa sổ **Terminal** tại thư mục dự án.
2. Cấp quyền thực thi và chạy lệnh:
   ```bash
   chmod +x run_mac.sh
   ./run_mac.sh
   ```
3. Chọn hãng điện thoại của bạn và làm theo hướng dẫn trên màn hình.

---

## 📌 3 Bước Quan Trọng Trên Điện Thoại Sau Khi Chạy Tool

1. **Bật Tự khởi chạy (Auto-launch / Tự khởi động).**
2. **Cho phép hoạt động dưới nền (Không hạn chế pin).**
3. **Khóa đa nhiệm (Lock in Recents 🔒).**

---

## 📄 License
Phát hành theo giấy phép [MIT License](LICENSE). Hoàn toàn miễn phí cho cộng đồng!
