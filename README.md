# 🚀 ColorOS Notification Fix & Debloat Tool

[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://github.com/)
[![Devices](https://img.shields.io/badge/Supports-OPPO%20%7C%20OnePlus%20%7C%20Realme-green)](https://github.com/)
[![ColorOS](https://img.shields.io/badge/ColorOS-14%20%7C%2015%20%7C%2016%20%7C%2017-orange)](https://github.com/)
[![License](https://img.shields.io/badge/License-MIT-purple)](LICENSE)

Bộ công cụ mã nguồn mở **tự động hóa 1-Click** giúp **khắc phục triệt để tình trạng chậm/mất thông báo** (Zalo, Messenger, Telegram, Gmail...) và **dọn sạch ứng dụng rác nội địa Trung Quốc** trên các dòng điện thoại **OPPO, OnePlus, Realme** chạy **ColorOS / OxygenOS / RealmeUI** bản nội địa Trung.

---

## ✨ Tính Năng Nổi Bật

* ⚡ **Tự động 100% (Zero Configuration):** Tự động phát hiện, tải và cài đặt bộ công cụ Google ADB chính thức nếu máy tính của bạn chưa có. Không cần cài đặt thủ công phức tạp!
* 🛑 **Vô hiệu hóa trình diệt ngầm Athena (`com.oplus.athena`):** Triệt tiêu "đao phủ" ngầm chuyên đóng băng và ép dừng (`force-stop`) các ứng dụng quốc tế khi tắt màn hình.
* 🛡️ **Doze Whitelist cho hơn 50+ ứng dụng:** Cấp quyền miễn ngủ đông cho toàn bộ các app liên lạc, ngân hàng, ví điện tử, sàn TMĐT, đặt xe và dịch vụ công phổ biến tại Việt Nam (Zalo, Messenger, Telegram, VNeID, eTax, MB Bank, Techcombank, Grab, Shopee...).
* 🧹 **Dọn sạch app rác nội địa Trung (Debloat):** Vô hiệu hóa tạp chí màn hình khóa tự nhảy hình nền quảng cáo tiếng Trung, trình duyệt HeyTap, màn hình tin tức bên trái...
* 🤖 **Tùy chọn thông minh:** Cho phép lựa chọn **giữ lại nguyên vẹn Trợ lý ảo tiếng Trung (Breeno / AI Voice)** nếu người dùng có nhu cầu sử dụng các tính năng AI của ColorOS.
* 🔄 **Hoàn tác an toàn 100%:** Tích hợp sẵn chức năng khôi phục nguyên trạng gốc của máy bất cứ lúc nào chỉ với 1 click.

---

## 📱 Chuẩn Bị Trên Điện Thoại (Bắt buộc)

Trước khi kết nối với máy tính, bạn cần bật chế độ **Gỡ lỗi USB**:
1. Vào **Cài đặt (Settings)** > **Giới thiệu thiết bị (About device)** > **Phiên bản (Version)**.
2. Nhấn liên tục **7 lần** vào dòng **Số bản dựng (Build number)** cho đến khi máy báo *Bạn đã là nhà phát triển*.
3. Quay lại: **Cài đặt bổ sung (Additional settings)** > **Tùy chọn nhà phát triển (Developer options)**:
   * Bật **Gỡ lỗi USB (USB Debugging)**.
   * *(Nếu có)* Bật thêm: **Gỡ lỗi USB (Cài đặt bảo mật)**.
   * *(Nếu có)* Tắt mục: **Giám sát quyền truy cập (Permission Monitoring)**.
4. Cắm cáp USB nối điện thoại với máy tính. Trên màn hình điện thoại sẽ hiện hộp thoại hỏi *"Cho phép gỡ lỗi USB từ máy tính này?"* -> Tích vào ô **Luôn cho phép từ máy tính này** rồi nhấn **Cho phép (OK)**.

---

## 💻 Hướng Dẫn Sử Dụng

### Dành cho Windows 🪟
1. Tải toàn bộ thư mục mã nguồn này về máy tính (hoặc bấm `Code` > `Download ZIP` rồi giải nén).
2. Nhấp đúp chuột vào tệp: **`run_windows.bat`**.
3. Nếu máy chưa có ADB, công cụ sẽ tự động tải từ Google trong vài giây.
4. Chọn phím **`[1]`** để chạy tự động toàn bộ (Fix thông báo + Dọn app rác).

### Dành cho macOS / Linux 🍏
1. Mở cửa sổ **Terminal** tại thư mục dự án.
2. Cấp quyền thực thi và chạy lệnh:
   ```bash
   chmod +x run_mac.sh
   ./run_mac.sh
   ```
3. Nếu máy chưa có ADB, công cụ sẽ tự động tải về và chạy ngay.
4. Chọn phím **`[1]`** để chạy tự động toàn bộ.

---

## 📌 3 Bước Quan Trọng Trên Điện Thoại Sau Khi Chạy Tool

Để thông báo nổ tức thì 100% như phiên bản quốc tế, bạn hãy thực hiện thêm 3 thiết lập nhỏ này trên máy:

1. **Bật Tự khởi chạy (Auto-launch):**
   * Vào **Cài đặt** > **Ứng dụng** > **Khởi chạy tự động**.
   * Bật công tắc cho các app cần nhận thông báo: *Zalo, Messenger, Telegram, Gmail...*
2. **Cho phép hoạt động dưới nền (Allow background activity):**
   * **Nhấn giữ icon app** (ví dụ Messenger) > Chọn **(i)** (*Thông tin ứng dụng*).
   * Vào **Mức sử dụng pin (Battery usage)** > Bật **Cho phép hoạt động dưới nền** và **Cho phép tự động khởi chạy**.
3. **Khóa đa nhiệm (Lock in Recents 🔒):**
   * Vuốt mở danh sách đa nhiệm các ứng dụng gần đây.
   * Bấm vào dấu **3 chấm** ở góc trên cửa sổ app > Chọn **Khóa (Lock)** (sẽ hiện biểu tượng ổ khóa 🔒).

---

## ❓ Câu Hỏi Thường Gặp (FAQ)

<details>
<summary><b>1. Khởi động lại máy có bị mất cài đặt không?</b></summary>
<b>KHÔNG.</b> Toàn bộ trạng thái vô hiệu hóa Athena, dọn app rác và danh sách Whitelist đều được ghi vào phân vùng hệ thống của Android và giữ nguyên 100% sau khi khởi động lại máy.
</details>

<details>
<summary><b>2. Khi nào thì cài đặt bị mất?</b></summary>
Cài đặt chỉ bị khôi phục lại khi bạn <b>Cập nhật hệ điều hành (OTA Update)</b> lên phiên bản ColorOS mới hoặc <b>Khôi phục cài đặt gốc</b>. Khi nâng cấp ColorOS mới, bạn chỉ cần cắm máy vào máy tính và chạy lại tool 1 lần (mất 5 giây).
</details>

<details>
<summary><b>3. Tool có làm mất bảo hành hay mất dữ liệu không?</b></summary>
<b>HOÀN TOÀN KHÔNG.</b> Tool chỉ sử dụng các tập lệnh ADB chuẩn (`pm disable-user`, `dumpsys deviceidle`) do Google cung cấp, không can thiệp root máy, không mở bootloader và không tác động đến dữ liệu cá nhân của bạn.
</details>

---

## 📄 License
Phát hành theo giấy phép [MIT License](LICENSE). Hoàn toàn miễn phí cho cộng đồng người dùng Android Việt Nam và quốc tế!
