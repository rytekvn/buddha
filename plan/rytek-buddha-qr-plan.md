# Trust Page – Buddha QR (plan v4)

Domain: **trustpage.info**

> Thay thế `OLD-rytek-buddha-ar-plan.md` (iOS + AR + CMS). Bản cũ giữ lại để tham khảo.

## 1. Mục tiêu

Quét QR đặt cạnh tượng → mở web app trên trình duyệt điện thoại → xem video thuyết
minh và thông tin về vị Phật đó. Không cài app, không đăng nhập, không CMS.

Giao diện làm giống app native: header, vùng nội dung, **tab bar cố định dưới đáy**.

## 2. Cơ chế quét QR

App **tự quét** bằng camera trong trang (tab 1), không nhờ camera hệ thống.

QR vẫn chứa URL đầy đủ `https://<domain>/?v=1`, nên **một mã dùng được cả hai đường**:

```
(a) Quét trong app:      tab Quét QR → jsQR đọc khung hình → lấy ?v=1 → mở tab Giới thiệu
(b) Quét bằng camera máy: iOS/Android mở Safari → /?v=1 → app vào thẳng tab Giới thiệu
```

Đường (b) miễn phí, không tốn dòng code nào thêm — chỉ vì QR chứa URL chứ không chứa
mỗi con số. Khách quen quét bằng camera máy vẫn dùng được, khách đã mở app thì quét
liên tục nhiều tượng không phải thoát ra vào.

**1 QR = 1 vị Phật.** Id không có trong `data.js` → báo "Mã QR không thuộc hệ thống",
vẫn quét tiếp, không trắng màn hình.

Thư viện giải mã: **jsQR**, vendor sẵn vào `web/lib/jsQR.js` (251 KB, ~70 KB sau gzip),
không CDN, chạy offline. Không dùng `BarcodeDetector` của trình duyệt vì iOS Safari
không có — sẽ phải nuôi hai đường code cho cùng một việc.

Id là **slug** (`dia-tang`) chứ không phải số, để URL đọc được và không phụ thuộc thứ tự.

Sinh QR:

```bash
./qr.sh                    # https://trustpage.info/?v=<id> cho mọi id trong content.json
```

In tối thiểu 3×3 cm để bắt được ở khoảng cách 20–30 cm.

## 3. Kiến trúc

Web tĩnh, không backend, không database, không build step, không framework.

```
web/
  index.html      # toàn bộ app: layout + CSS + 4 tab + scanner + renderer
  content.json    # TOÀN BỘ nội dung — chỗ duy nhất sửa khi thêm/đổi tượng
  lib/jsQR.js     # thư viện giải mã QR, vendor sẵn
  videos/*.mp4
qr.sh             # sinh QR cho mọi id trong content.json
dev.sh            # chạy local có HTTPS
DEPLOY.md         # đưa lên trustpage.info
```

Nội dung nằm trong **JSON chứ không phải JS** — sửa được mà không sợ làm hỏng cú pháp
code, và sau này nếu cần CMS thì chỉ việc sinh ra đúng file JSON đó, app không phải đổi.

Thêm tượng mới = copy mp4 vào `videos/` + thêm 1 key vào `content.json` + chạy
`./qr.sh`. Không đụng `index.html`. Đây là "CMS" cho tới khi số tượng vượt ~50 hoặc
người không biết code phải tự cập nhật.

Một file JSON cho tất cả, không tách file/tượng: nội dung là text nên nhẹ, ~5 KB/tượng.
50 tượng vẫn dưới 300 KB, tải một lần rồi cache. Tách file chỉ thêm việc quản lý mà
chưa giải quyết vấn đề nào.

Không dùng React/Vue: app chỉ có 4 panel bật/tắt và một renderer JSON→HTML, framework
thêm build step và vài trăm KB JS mà không giải quyết vấn đề nào.

## 3b. Cấu trúc JSON

Đặc tả đầy đủ ở [spec/README.md](../spec/README.md). Ý chính:

Mỗi vị Phật có `sections[]`, mỗi section là `{title, body[]}`. Phần tử trong `body`
**tự khai kiểu bằng chính kiểu dữ liệu**, không cần trường `"type"`:

| Viết | Ra |
|---|---|
| `"đoạn văn"` | `<p>` |
| `["mục"]` | gạch đầu dòng |
| `["thuật ngữ", "giải thích"]` | gạch đầu dòng có thuật ngữ in đậm |
| `{"quote":"…","nghia":"…"}` | trích dẫn có vạch vàng + phần dịch |

Thứ tự trong `body` là thứ tự hiển thị. Đây là điểm quan trọng: nội dung thật hay có
dạng "đoạn văn → câu kệ → đoạn văn kết", nếu ép thứ tự cố định (text trước, quote sau)
thì đoạn kết bị nhảy lên trên. Nên `body` là mảng có thứ tự chứ không phải object nhiều
trường.

Bốn kiểu này đủ cho toàn bộ 7 section của Địa Tạng Vương Bồ Tát. Thêm kiểu mới chỉ khi
gặp nội dung thật sự không diễn đạt được — đừng thêm trước.

## 4. Layout

```
┌──────────────────────────┐
│ Phật A Di Đà             │  header: tên + tên Phạn/Hán
│ Amitābha · 阿彌陀佛        │
├──────────────────────────┤
│                          │
│      nội dung tab        │  cuộn được
│                          │
├──────────────────────────┤
│  ▶     ▤     ▣     ⌾    │  tab bar, dính đáy, tránh safe-area
│Thuyết Giới  Hình   Chùa  │
│ minh  thiệu  ảnh         │
└──────────────────────────┘
```

Tone tối + nhấn vàng đồng: video là trung tâm, nền tối đỡ chói trong chánh điện.

## 5. Bốn tab

| # | Tab | Nội dung | Nguồn dữ liệu |
|---|---|---|---|
| 1 | **Quét QR** | camera trực tiếp + khung ngắm. Quét ra → nhảy sang tab 2 | — |
| 2 | **Giới thiệu** | tên tượng, **video thuyết minh**, các mục text | `BUDDHAS[id]` |
| 3 | **Lịch sử** | danh sách tượng đã quét, chỉ tên + tóm tắt + thời điểm, **không có video** | `localStorage` |
| 4 | **Thông tin chùa** | tên, địa chỉ, nút Chỉ đường, các mục giới thiệu chùa | `TEMPLE` |

Tab mặc định khi mở app: **tab 1**. Trừ khi vào bằng link `?v=<id>` thì vào thẳng tab 2.

Bấm một dòng trong Lịch sử → mở lại tab 2 của tượng đó. Lịch sử lưu `localStorage`,
quét lại tượng cũ thì đẩy lên đầu chứ không nhân bản, giữ tối đa 100 dòng. Id đã gỡ
khỏi `data.js` thì tự biến mất khỏi danh sách.

Camera chỉ bật khi đang ở tab 1. Rời tab, khoá máy hoặc chuyển app → nhả camera ngay,
không để đèn báo camera sáng dai. Rời tab 2 → video tự pause.

Đổi số lượng hoặc tên tab: sửa mảng `TABS` trong `index.html`.

## 6. Hai rào cản của trình duyệt

### 6.1. Camera bắt buộc HTTPS

`getUserMedia` chỉ chạy trên secure context. `http://192.168.x.x:8000` bị iOS Safari
chặn thẳng, **không hỏi quyền luôn** — rất dễ tưởng code sai. Chỉ `https://` hoặc
`localhost` mới được.

Hệ quả: không test được tab Quét QR bằng cách mở IP LAN trên điện thoại. Phải qua
tunnel HTTPS — xem mục 8.

App tự phát hiện và báo rõ "Camera cần HTTPS" thay vì im lặng hỏng.

### 6.2. Autoplay có tiếng

iOS Safari chặn video tự phát khi có âm thanh, trừ khi người dùng chạm màn hình.

**Quyết định:** thẻ `<video controls>` + thử `play()` khi mở tab 2. Chạy được thì tốt;
bị chặn thì nút play mặc định của trình duyệt đã nằm sẵn đó, người dùng bấm 1 lần.
Không tự vẽ overlay riêng nữa — controls có sẵn làm đúng việc đó và còn cho tua.

## 7. Video

Nguồn 720×1280 dọc, H.264 + AAC, 4.6 Mbps (8.7 MB). Đã nén còn **2.0 MB**:

```bash
ffmpeg -y -i "nguồn.mp4" -vcodec libx264 -crf 30 -preset slow -movflags +faststart -acodec aac -b:a 96k web/videos/<id>.mp4
```

Chọn `crf 30` ở độ phân giải gốc chứ không hạ xuống 540px: đã soi khung hình cạnh nhau,
crf30-720 (2.0 MB) gần như không khác bản gốc, còn 540px (1.6 MB) thì hoa văn trên áo
tượng nhoè thấy rõ. Ép xuống 2.0 MB là điều kiện để chịu được 1000 lượt/ngày trong hạn
mức 100 GB/tháng của Vercel Hobby — ở 3.3 MB thì mức đó ra 105 GB, vượt trần.

`+faststart` bắt buộc — đẩy metadata lên đầu file để video phát trước khi tải xong.

Video hiện tại chỉ là bản tạm để dựng khung.

## 8. Chạy local khi đang làm

```bash
./dev.sh
```

Script làm 4 việc: tìm port rảnh → chạy `http-server` → dựng tunnel HTTPS bằng ngrok →
sinh QR vào `qr/` trỏ đúng URL https vừa có. Mở URL đó trên điện thoại (ngrok bản free
chèn 1 trang cảnh báo, bấm "Visit Site", chỉ 1 lần), rồi dùng tab Quét QR chĩa vào ảnh
QR đang mở trên màn hình Mac.

```bash
NO_TUNNEL=1 ./dev.sh   # chỉ LAN http — nhanh hơn, nhưng tab Quét QR sẽ báo cần HTTPS
PORT=9000 ./dev.sh     # ép port
```

URL ngrok đổi mỗi lần chạy, nên QR sinh lại mỗi lần — đó là lý do việc sinh QR nằm
trong script chứ không làm tay.

**Không dùng `python3 -m http.server`.** Nó trả `200 OK` thay vì `206 Partial Content`
cho request có header Range, mà iOS Safari bắt buộc phải có Range mới phát được video —
màn hình đen thui, không báo lỗi gì. `http-server` (npx) trả 206 đúng chuẩn, đã đo
bằng curl chứ không phải đoán.

QR sinh bằng `uvx --from segno segno ...`, không cài gì vĩnh viễn vào máy.

## 9. Hosting

Domain đã có: **trustpage.info**. Host: Cloudflare Pages — miễn phí, CDN toàn cầu,
băng thông không giới hạn, HTTPS tự cấp (bắt buộc, vì camera cần secure context).
Kéo thả thư mục `web/` là xong, không build.

Tránh GitHub Pages: giới hạn băng thông mềm 100 GB/tháng, video nặng dễ chạm trần.

Thống kê lượt quét dùng analytics sẵn của Cloudflare, không cần viết gì.

Các bước cụ thể: [DEPLOY.md](../DEPLOY.md).

## 10. Việc còn lại

- [x] Chuẩn hoá cấu trúc JSON, dựng nội dung đầy đủ cho Địa Tạng Vương Bồ Tát
- [ ] Điền `temple` và các vị còn lại trong `web/content.json` (đang là TODO)
- [ ] Video thật thay bản tạm
- [ ] Test trên iPhone Safari thật: **quét QR trong app**, autoplay, tiếng, safe-area
- [ ] Deploy Cloudflare Pages + trỏ trustpage.info (xem DEPLOY.md)
- [ ] `./qr.sh` rồi in QR (tối thiểu 3×3 cm)

## 11. Đã bỏ so với plan cũ

App iOS, ARKit, mô hình 3D, CMS, đăng nhập admin, API, database, đa ngôn ngữ, màn hình
danh sách Phật, audio player riêng, tab thư viện ảnh.

Khi nào cần lại: **AR/3D** khi khách thật sự muốn xoay tượng chứ không chỉ xem video —
đó là dự án khác, không phải mở rộng của cái này. **CMS** khi vượt ~50 tượng hoặc người
không biết code phải tự sửa nội dung. **Đa ngôn ngữ** thì thêm `?lang=` và nhân đôi
key trong `data.js`, chưa cần hạ tầng i18n.
