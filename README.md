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
| **[`xiaomi-redmi/`](xiaomi-redmi/)** | Xiaomi, Redmi, POCO (HyperOS / MIUI) | 🟡 **Đang phát triển** |
| **[`vivo-iqoo/`](vivo-iqoo/)** | Vivo, iQOO (OriginOS / FuntouchOS) | 🟡 **Đang phát triển** |

---

## ✨ Tính Năng Nổi Bật

* ⚡ **Tự động 100% (Zero Configuration):** Tự động phát hiện, tải và cấu hình bộ công cụ Google ADB chính thức nếu máy tính chưa có. Người dùng không cần cài đặt môi trường phức tạp!
* 🛑 **Vô hiệu hóa trình diệt ngầm chuyên sâu:** 
  * Với OPPO/OnePlus/Realme: Vô hiệu hóa `com.oplus.athena` (nguyên nhân cốt lõi khiến app bị ép dừng `force-stop`).
* 🛡️ **Doze Whitelist cho hơn 50+ ứng dụng:** Cấp quyền miễn ngủ đông cho toàn bộ các app liên lạc, ngân hàng, ví điện tử, sàn TMĐT, đặt xe và dịch vụ công phổ biến tại Việt Nam (Zalo, Messenger, Telegram, VNeID, eTax, MB Bank, Techcombank, Grab, Shopee...).
* 🧹 **Dọn sạch app rác nội địa Trung (Debloat):** Tắt tạp chí màn hình khóa quảng cáo tiếng Trung, trình duyệt nội địa, màn hình tin tức bên trái...
* 🤖 **Tùy chọn thông minh:** Cho phép lựa chọn **giữ lại nguyên vẹn Trợ lý ảo tiếng Trung (Breeno / AI Voice)** nếu bạn muốn sử dụng các tính năng AI.
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
2. Nhấp đúp chuột vào tệp: **`run_windows.bat`** ở thư mục gốc (hoặc vào thẳng thư mục hãng máy của bạn).
3. Tool sẽ tự động nhận diện thiết bị và hướng dẫn từng bước trên màn hình.

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

## 🤝 Đóng Góp Phát Triển (Contributions)
Nếu bạn có kinh nghiệm tối ưu cho các dòng máy **Xiaomi / HyperOS** hoặc **Vivo / OriginOS**, mọi đóng góp (Pull Request / Issue) từ bạn đều rất đáng trân trọng để hoàn thiện công cụ cho cộng đồng người dùng Android tại Việt Nam!

---

## 📄 License
Phát hành theo giấy phép [MIT License](LICENSE). Hoàn toàn miễn phí cho cộng đồng!
