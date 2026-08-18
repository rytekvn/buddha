# Rytek – Buddha AR  
## Kế hoạch triển khai ứng dụng iOS quét QR hiển thị tượng Phật 3D

---

## 1. Mục tiêu sản phẩm

Xây dựng ứng dụng iOS cho phép người dùng:

1. Quét mã QR đặt tại tượng Phật, chùa, bảo tàng, sách hoặc vật phẩm.
2. Nhận diện vị Phật tương ứng.
3. Hiển thị mô hình 3D trong không gian AR.
4. Xoay, phóng to, thu nhỏ và quan sát mô hình.
5. Đọc hoặc nghe thông tin thuyết minh.
6. Hỗ trợ nhiều ngôn ngữ trong giai đoạn sau.

Sản phẩm gồm hai hệ thống:

- **Ứng dụng iOS** dành cho người tham quan.
- **CMS Web** dành cho người quản trị nội dung.

---

## 2. Phạm vi phiên bản MVP

MVP nên tập trung chứng minh ba chức năng cốt lõi:

> Quét QR → tải đúng dữ liệu → hiển thị tượng Phật 3D bằng AR.

### 2.1. Chức năng iOS MVP

#### Màn hình chính

- Logo và tên ứng dụng.
- Nút “Quét mã QR”.
- Danh sách một số vị Phật nổi bật.
- Hướng dẫn sử dụng ngắn.

#### Quét QR

- Mở camera.
- Nhận diện QR.
- Kiểm tra mã hợp lệ.
- Xử lý trường hợp QR không tồn tại.
- Chuyển đến màn hình thông tin tương ứng.

#### Hiển thị AR

- Phát hiện mặt phẳng.
- Đặt mô hình 3D lên mặt phẳng.
- Xoay mô hình.
- Phóng to, thu nhỏ.
- Di chuyển mô hình.
- Đặt lại vị trí.
- Chụp ảnh màn hình AR.

#### Thông tin vị Phật

- Tên vị Phật.
- Tên Hán – Việt.
- Tên tiếng Anh.
- Ảnh đại diện.
- Giới thiệu ngắn.
- Ý nghĩa hình tượng.
- Đặc điểm nhận diện.
- Thủ ấn.
- Pháp khí.
- Nội dung thuyết minh chi tiết.

#### Âm thanh

- Phát bài thuyết minh.
- Tạm dừng và tiếp tục.
- Hiển thị thời lượng.
- Tiếp tục phát khi người dùng xem mô hình AR.

### 2.2. Chức năng CMS MVP

- Đăng nhập quản trị viên.
- Tạo và chỉnh sửa thông tin vị Phật.
- Upload ảnh.
- Upload mô hình 3D.
- Upload file âm thanh.
- Tạo mã QR.
- Kích hoạt hoặc vô hiệu hóa mã QR.
- Xem số lượt quét cơ bản.

### 2.3. Chưa nên làm trong MVP

- Đăng nhập người dùng.
- Mạng xã hội nội bộ.
- Bình luận và đánh giá.
- Thanh toán, công đức hoặc mua vật phẩm.
- Nhận diện tượng bằng camera không cần QR.
- Tự động tạo mô hình 3D.
- Gamification phức tạp.
- Bản đồ toàn bộ chùa tại Việt Nam.

---

## 3. Luồng hoạt động chính

```text
Người dùng mở ứng dụng
        ↓
Chọn “Quét mã QR”
        ↓
Ứng dụng đọc QR Code
        ↓
Lấy mã định danh của nội dung
        ↓
Gọi API lấy thông tin vị Phật
        ↓
Hiển thị trang giới thiệu
        ↓
Người dùng chọn “Xem trong AR”
        ↓
Ứng dụng tải mô hình 3D
        ↓
Phát hiện mặt phẳng
        ↓
Đặt tượng Phật vào không gian thực
        ↓
Đọc thông tin hoặc nghe thuyết minh
```

Một QR không nên chứa toàn bộ dữ liệu. QR chỉ cần chứa đường dẫn hoặc mã định danh, ví dụ:

```text
https://buddha.rytek.vn/q/amida-001
```

Hoặc:

```text
rytek-buddha://scan/amida-001
```

Nên ưu tiên đường dẫn HTTPS vì người chưa cài app vẫn có thể mở trang web giới thiệu.

---

## 4. Kiến trúc hệ thống đề xuất

```text
                    ┌──────────────────────┐
                    │      CMS Web         │
                    │ Quản lý nội dung     │
                    └──────────┬───────────┘
                               │
                               ▼
┌──────────────┐       ┌───────────────────┐
│   iOS App    │──────▶│      Backend      │
│ SwiftUI      │       │ API + Auth + QR   │
│ ARKit        │       └─────────┬─────────┘
└──────┬───────┘                 │
       │                         ▼
       │                 ┌───────────────────┐
       │                 │     Database      │
       │                 │ Buddha, QR, Scan  │
       │                 └───────────────────┘
       │
       ▼
┌───────────────────┐
│ Object Storage    │
│ USDZ, ảnh, audio  │
└───────────────────┘
```

### 4.1. Công nghệ iOS

- Swift 6.
- SwiftUI.
- ARKit.
- RealityKit.
- AVFoundation để quét QR.
- AVFoundation hoặc AVPlayer để phát âm thanh.
- SwiftData hoặc Core Data để cache dữ liệu.
- URLSession cho API.
- USDZ làm định dạng mô hình chính.

### 4.2. Backend

#### Phương án nhanh cho MVP

- Supabase.
- PostgreSQL.
- Supabase Auth.
- Supabase Storage.
- Edge Functions hoặc API nhỏ riêng.

Ưu điểm:

- Triển khai nhanh.
- Ít DevOps.
- Phù hợp giai đoạn thử nghiệm.
- Có sẵn database, storage và authentication.

#### Phương án chủ động lâu dài

- Backend: Hono, NestJS hoặc FastAPI.
- PostgreSQL.
- S3-compatible storage.
- CloudFront hoặc CDN.
- Docker.
- AWS, Cloudflare hoặc VPS phù hợp.

Khuyến nghị:

> Bắt đầu bằng Supabase kết hợp API riêng nhỏ, sau đó tách thành kiến trúc đầy đủ khi số lượng đối tác tăng.

### 4.3. CMS Web

- Next.js.
- TypeScript.
- Tailwind CSS.
- Supabase hoặc API riêng.
- Vercel để triển khai.

---

## 5. Thiết kế dữ liệu cơ bản

### 5.1. Bảng `buddhas`

```text
id
slug
name_vi
name_en
name_han_viet
short_description
full_description
meaning
mudra
symbol
history
thumbnail_url
model_3d_url
audio_vi_url
audio_en_url
status
created_at
updated_at
```

### 5.2. Bảng `qr_codes`

```text
id
code
buddha_id
temple_id
location_description
status
created_at
expires_at
```

### 5.3. Bảng `temples`

```text
id
name
address
latitude
longitude
description
logo_url
status
```

### 5.4. Bảng `scan_events`

```text
id
qr_code_id
buddha_id
device_id_anonymous
app_version
language
scanned_at
```

### 5.5. Bảng `admins`

```text
id
email
name
role
status
created_at
```

---

## 6. Chuẩn bị nội dung

Mỗi vị Phật cần một bộ nội dung hoàn chỉnh:

- Tên chính thức.
- Tên gọi khác.
- Tên Hán – Việt.
- Tên tiếng Anh.
- Nguồn gốc.
- Ý nghĩa tôn giáo.
- Đặc điểm nhận diện.
- Tư thế.
- Thủ ấn.
- Pháp khí.
- Hình tượng đi kèm.
- Nội dung thuyết minh ngắn.
- Nội dung thuyết minh chi tiết.
- File âm thanh.
- Ảnh đại diện.
- Mô hình 3D.

Nội dung nên được kiểm duyệt bởi người có kiến thức Phật học hoặc đại diện cơ sở Phật giáo.

Không nên để AI tự tạo và xuất bản trực tiếp các nội dung liên quan đến giáo lý, tên gọi, biểu tượng hoặc nghi thức.

### Bộ nội dung thử nghiệm ban đầu

Nên chọn khoảng 5 vị:

1. Phật Thích Ca Mâu Ni.
2. Phật A Di Đà.
3. Phật Dược Sư.
4. Quán Thế Âm Bồ Tát.
5. Địa Tạng Vương Bồ Tát.

Năm mô hình là đủ để kiểm tra toàn bộ quy trình mà không làm chi phí 3D tăng quá cao.

---

## 7. Quy trình sản xuất mô hình 3D

### Yêu cầu cho mỗi mô hình

- Đúng hình tượng.
- Khuôn mặt và tư thế trang nghiêm.
- Tỷ lệ phù hợp.
- Không quá nhiều polygon.
- Texture được tối ưu cho thiết bị di động.
- Ánh sáng và vật liệu hiển thị tốt trong RealityKit.
- File cuối cùng ở định dạng USDZ.
- Dung lượng mục tiêu khoảng 10–40 MB mỗi mô hình.

### Quy trình

```text
Thu thập tài liệu tham khảo
        ↓
Dựng mẫu 3D ban đầu
        ↓
Kiểm tra hình tượng Phật giáo
        ↓
Sculpt và retopology
        ↓
Tạo UV và texture
        ↓
Tối ưu polygon
        ↓
Xuất USDZ
        ↓
Kiểm tra trên nhiều iPhone
        ↓
Điều chỉnh vật liệu và dung lượng
```

Cần đặc biệt tránh lấy trực tiếp mô hình không rõ bản quyền trên Internet.

---

## 8. Kế hoạch triển khai theo giai đoạn

### Giai đoạn 0 — Xác định sản phẩm

**Thời gian: 1 tuần**

Công việc:

- Chốt tên dự án.
- Xác định đối tượng người dùng.
- Xác định môi trường sử dụng.
- Chọn 5 vị Phật đầu tiên.
- Chốt nội dung MVP.
- Xác định đối tác thử nghiệm.
- Xây dựng quy chuẩn nội dung và mô hình 3D.

Kết quả:

- Product brief.
- Danh sách chức năng.
- User flow.
- Danh sách nội dung thử nghiệm.
- Tiêu chuẩn mô hình 3D.

### Giai đoạn 1 — Prototype kỹ thuật

**Thời gian: 2–3 tuần**

Mục tiêu là chứng minh công nghệ hoạt động.

Công việc:

- Tạo dự án SwiftUI.
- Tích hợp camera quét QR.
- Tạo một QR thử nghiệm.
- Hiển thị một mô hình USDZ.
- Đặt mô hình trong AR.
- Xoay, thu phóng và di chuyển mô hình.
- Kiểm tra hiệu năng trên thiết bị thật.

Kết quả:

- Ứng dụng prototype.
- Một QR hoạt động.
- Một mô hình 3D hoạt động.
- Báo cáo hiệu năng và các giới hạn kỹ thuật.

Đây là mốc quan trọng nhất. Chỉ nên phát triển hệ thống lớn sau khi prototype này chạy ổn định.

### Giai đoạn 2 — Thiết kế UI/UX

**Thời gian: 1–2 tuần, có thể làm song song**

Thiết kế các màn hình:

- Splash screen.
- Trang chủ.
- Camera quét QR.
- Kết quả quét.
- Chi tiết vị Phật.
- AR Viewer.
- Audio Player.
- Lịch sử đã xem.
- Hướng dẫn sử dụng.
- Cài đặt ngôn ngữ.
- Trạng thái mất mạng và lỗi tải mô hình.

Kết quả:

- Wireframe.
- UI Design.
- Design system.
- Icon và App Store assets cơ bản.

### Giai đoạn 3 — Backend và CMS

**Thời gian: 3–4 tuần**

Công việc backend:

- Thiết kế database.
- API lấy thông tin vị Phật.
- API tra cứu QR.
- API ghi nhận lượt quét.
- Upload và phân phối mô hình 3D.
- Upload audio và hình ảnh.
- Authentication cho quản trị viên.

Công việc CMS:

- Đăng nhập.
- Danh sách vị Phật.
- Form tạo và chỉnh sửa.
- Upload media.
- Quản lý QR.
- Tải file QR để in.
- Thống kê lượt quét.

Kết quả:

- Backend staging.
- CMS staging.
- API documentation.
- Database migration.

### Giai đoạn 4 — Phát triển ứng dụng iOS MVP

**Thời gian: 4–5 tuần**

Công việc:

- Xây dựng kiến trúc ứng dụng.
- Kết nối API.
- Quét QR.
- Màn hình thông tin.
- AR Viewer.
- Audio Player.
- Cache mô hình.
- Quản lý trạng thái tải.
- Xử lý mất mạng.
- Theo dõi analytics.
- Hỗ trợ tiếng Việt.
- Deep link từ QR HTTPS vào ứng dụng.

Kết quả:

- Bản TestFlight nội bộ.
- Đầy đủ luồng MVP.
- Có ít nhất 5 vị Phật.

### Giai đoạn 5 — Kiểm thử thực tế

**Thời gian: 2 tuần**

Kiểm thử:

- Trong nhà.
- Ngoài trời.
- Ánh sáng yếu.
- Nền nhà sáng và tối.
- Camera rung.
- Internet yếu.
- Thiết bị dung lượng thấp.
- Mô hình tải lần đầu.
- Mô hình đã cache.
- QR bị trầy hoặc in nhỏ.

Thiết bị kiểm thử nên gồm:

- Một iPhone đời cũ còn hỗ trợ ARKit.
- Một iPhone tầm trung.
- Một iPhone mới.
- Ít nhất hai phiên bản iOS.

Kết quả:

- Danh sách lỗi.
- Báo cáo hiệu năng.
- Bản release candidate.

### Giai đoạn 6 — Pilot tại một địa điểm

**Thời gian: 2–4 tuần**

Nên triển khai thử tại:

- Một ngôi chùa.
- Một phòng trưng bày.
- Một khu vực có 5–10 tượng.
- Một sự kiện Phật giáo.

Công việc:

- In QR.
- Gắn bảng hướng dẫn.
- Theo dõi lượt quét.
- Phỏng vấn người sử dụng.
- Đo tỷ lệ quét thành công.
- Kiểm tra thời gian tải mô hình.
- Ghi nhận phản hồi về nội dung.

Chỉ số cần theo dõi:

- Tổng lượt quét.
- Tỷ lệ quét thành công.
- Thời gian tải mô hình.
- Tỷ lệ mở AR.
- Thời gian xem.
- Tỷ lệ nghe thuyết minh.
- Tỷ lệ người dùng quay lại.
- Số lỗi ứng dụng.

### Giai đoạn 7 — Phát hành App Store

**Thời gian: 1–2 tuần**

Công việc:

- Chuẩn bị tên và mô tả ứng dụng.
- App icon.
- Screenshot.
- Chính sách quyền riêng tư.
- Khai báo quyền camera.
- Khai báo dữ liệu analytics.
- Kiểm tra nội dung tôn giáo.
- TestFlight bên ngoài.
- Gửi App Review.
- Theo dõi crash sau phát hành.

---

## 9. Lộ trình tổng thể

| Giai đoạn | Thời gian |
|---|---:|
| Xác định sản phẩm | 1 tuần |
| Prototype kỹ thuật | 2–3 tuần |
| UI/UX | 1–2 tuần |
| Backend và CMS | 3–4 tuần |
| iOS MVP | 4–5 tuần |
| Kiểm thử | 2 tuần |
| Pilot | 2–4 tuần |
| Phát hành | 1–2 tuần |

Nếu thực hiện song song, MVP có thể hoàn thành trong khoảng:

> **10–14 tuần**

Nếu chỉ có một lập trình viên và phải tự xử lý cả iOS, backend, CMS, nội dung và 3D:

> **16–24 tuần** sẽ thực tế hơn.

---

## 10. Nhân sự đề xuất

### Đội hình tối thiểu

- 1 Product Owner.
- 1 iOS Developer.
- 1 Backend/Web Developer.
- 1 UI/UX Designer bán thời gian.
- 1 3D Artist.
- 1 người biên soạn hoặc kiểm duyệt nội dung Phật học.
- 1 QA bán thời gian.

### Đội hình cực gọn

- 1 Full-stack Developer phụ trách iOS, API và CMS.
- 1 3D Artist.
- 1 cố vấn nội dung.
- 1 người phụ trách sản phẩm và kiểm thử.

Với đội hình cực gọn, cần giữ MVP rất nhỏ.

---

## 11. Các rủi ro chính

### 11.1. Chất lượng mô hình 3D

Mô hình không trang nghiêm hoặc sai đặc điểm có thể ảnh hưởng nghiêm trọng đến sản phẩm.

Giải pháp:

- Có quy trình kiểm duyệt trước khi đưa lên ứng dụng.

### 11.2. Dung lượng mô hình lớn

Mô hình quá nặng gây tải chậm và làm app tốn bộ nhớ.

Giải pháp:

- Tải mô hình theo nhu cầu.
- Không đóng gói tất cả mô hình trong app.
- Dùng CDN.
- Cache có giới hạn.
- Tự động xóa mô hình lâu không sử dụng.

### 11.3. AR không ổn định

Nền bóng, thiếu sáng hoặc camera chuyển động mạnh làm việc đặt tượng khó khăn.

Giải pháp:

- Hiển thị hướng dẫn quét mặt phẳng.
- Có nút đặt lại.
- Có chế độ xem 3D không dùng AR.

### 11.4. Nội dung thiếu chính xác

Các truyền thống Phật giáo có thể có cách mô tả khác nhau.

Giải pháp:

- Ghi rõ nguồn.
- Cho phép quản lý phiên bản nội dung.
- Có người kiểm duyệt chuyên môn.
- Không để nội dung AI tự động xuất bản.

### 11.5. Phụ thuộc QR

QR bị hỏng hoặc đặt sai vị trí sẽ làm trải nghiệm thất bại.

Giải pháp:

- QR có mã nhận dạng bên dưới.
- Có danh sách tìm kiếm thủ công.
- CMS cho phép in lại QR.
- Theo dõi QR không còn hoạt động.

---

## 12. Định hướng sau MVP

Sau khi MVP được xác nhận, có thể phát triển:

- Hỗ trợ tiếng Anh, Nhật, Hàn, Trung.
- Bản đồ các chùa.
- Tour tham quan theo tuyến.
- Thuyết minh tự động theo vị trí.
- Nhận diện tượng bằng hình ảnh.
- Không gian trưng bày Phật giáo ảo.
- Bộ sưu tập các vị Phật đã khám phá.
- Chế độ dành cho trường học và bảo tàng.
- QR riêng cho từng chùa.
- White-label cho cơ sở Phật giáo.
- CMS nhiều tổ chức.
- Báo cáo thống kê cho từng địa điểm.
- Phiên bản Android.
- Apple Vision Pro trong giai đoạn dài hạn.

---

## 13. Việc nên bắt đầu ngay

Thứ tự thực hiện phù hợp nhất:

1. Chọn một vị Phật để làm prototype.
2. Chuẩn bị một mô hình USDZ thử nghiệm.
3. Tạo ứng dụng iOS quét QR.
4. Hiển thị mô hình trong RealityKit.
5. Kiểm tra trực tiếp trên iPhone.
6. Sau khi AR hoạt động ổn định mới xây backend và CMS.
7. Chuẩn hóa dữ liệu cho 5 vị Phật đầu tiên.
8. Triển khai pilot tại một địa điểm nhỏ.

### Mốc thành công đầu tiên

```text
Một mã QR thật
    ↓
Quét bằng iPhone
    ↓
Hiện đúng tên vị Phật
    ↓
Nhấn “Xem AR”
    ↓
Tượng Phật 3D xuất hiện ổn định
    ↓
Có thể xoay, phóng to và nghe thuyết minh
```

Khi hoàn thành được luồng này, dự án đã chứng minh được phần cốt lõi và có thể bước sang giai đoạn xây dựng sản phẩm chính thức.
