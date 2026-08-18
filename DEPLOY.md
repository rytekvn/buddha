# Deploy lên Vercel (domain trustpage.info)

Trang tĩnh thuần: không backend, không build step, không database. Vercel chỉ việc
phục vụ nguyên thư mục `web/`.

## Vì sao Vercel chứ không Cloudflare Pages

Vì `trustpage.info` **đã trỏ sẵn vào Vercel**:

```
trustpage.info      A     76.76.21.21          (Vercel)
www.trustpage.info  CNAME cname.vercel-dns.com (Vercel)
nameserver          ns1/ns2.matbao.com
MX                  mx.zoho.com                (email đang chạy)
```

Dùng Vercel thì việc đổi domain sang dự án này **không đụng gì tới DNS ở Mat Bao** —
chỉ là gỡ domain khỏi project cũ rồi gắn vào project mới, ngay trong dashboard Vercel.

Nếu chuyển sang Cloudflare Pages thì phải dời nameserver về Cloudflare, kéo theo phải
tạo lại `MX → mx.zoho.com` và TXT xác minh Zoho. Thiếu là **mất email của cả domain**.
Đổi lấy rủi ro đó mà chẳng được thêm gì cho một trang tĩnh.

## Băng thông: 1000 lượt/ngày có sao không

Gói Hobby cho **100 GB Fast Data Transfer/tháng**. Số liệu thật của dự án:

| Thành phần | Mỗi lượt |
|---|---|
| Video (crf 30, 720×1280) | 2,00 MB |
| jsQR.js (đã gzip) | 57 KB |
| index.html + content.json (gzip) | 8 KB |
| **Tổng** | **2,06 MB** |

| Lưu lượng | GB/tháng | Trạng thái |
|---|---|---|
| 500 lượt/ngày | 32,5 | thoải mái |
| **1000 lượt/ngày** | **65,0** | **ổn, còn dư 35%** |
| 1500 lượt/ngày | 97,4 | sát trần |

**1000 lượt/ngày liên tục thì không sao.** Và đây là con số xấu nhất — thực tế còn
thấp hơn vì người xem bỏ giữa chừng chỉ tải một phần video (HTTP Range), còn
jsQR/html/json thì lượt sau đã nằm trong cache trình duyệt.

Trước khi nén lại ở crf 30, video là 3,3 MB và 1000 lượt/ngày ra **105 GB — vượt trần**.
Nên giữ đúng lệnh nén ở mục dưới khi thay video thật.

Vượt hạn mức trên Hobby thì tính năng ngưng tới hết chu kỳ 30 ngày, **không** tự tính
tiền. Nhưng ngưng nghĩa là khách đứng trước tượng quét ra trang chết — nên đừng để chạm trần.

### Lệnh nén video (bắt buộc dùng khi thay video thật)

```bash
ffmpeg -y -i "nguồn.mp4" -vcodec libx264 -crf 30 -preset slow   -movflags +faststart -acodec aac -b:a 96k web/videos/<id>.mp4
```

`crf 30` giữ nguyên độ phân giải gốc, nhìn gần như không khác `crf 26` nhưng nhẹ hơn
40%. Đã soi khung hình cạnh nhau để chọn: hạ xuống 540px thì nhẹ hơn nữa nhưng hoa văn
trên áo tượng nhoè thấy rõ, không đáng.

`+faststart` bắt buộc — đẩy metadata lên đầu file để video phát trước khi tải xong.

### Nếu sau này thật sự vượt trần

Đường thoát rẻ nhất, **không phải đổi code**: đưa video sang **Cloudflare R2** —
egress miễn phí hoàn toàn, 10 GB lưu trữ và 10 triệu lượt đọc/tháng đều free.

Trường `video` trong `content.json` chỉ là một chuỗi URL, nên đổi thành URL R2 đầy đủ
là xong:

```json
"video": "https://<bucket>.r2.dev/dia-tang.mp4"
```

Lúc đó Vercel chỉ còn phục vụ ~64 KB/lượt → 1000 lượt/ngày chỉ tốn **1,9 GB/tháng**,
coi như không giới hạn. Đây là lý do nội dung để trong JSON chứ không nhúng cứng vào code.

Phương án khác: lên Vercel Pro 20 USD/tháng cho 1 TB. Đắt hơn mà không cần thiết.

## Gói Hobby và chuyện thương mại

Tài liệu Vercel ghi gói Hobby *"restricts users to non-commercial, personal use only"*.
Trang thông tin của chùa, không bán gì, không thu phí — không thuộc diện này.

---

## Bước 1 — Tạo project mới từ repo GitHub

Nối Git chứ đừng upload tay: sau này `git push` là tự deploy.

1. [vercel.com/new](https://vercel.com/new) → **Import Git Repository**.
2. Nếu chưa thấy repo `buddha`: bấm **Adjust GitHub App Permissions**, chọn đúng
   account **`rytekvn`** (không phải `ryantranvortech`) và cấp quyền cho repo `buddha`.
3. Chọn `rytekvn/buddha` → **Import**.

## Bước 2 — Cấu hình

Bước duy nhất dễ sai:

| Trường | Giá trị |
|---|---|
| Framework Preset | **Other** |
| **Root Directory** | **`web`** ← quan trọng nhất |
| Build Command | để trống (tắt Override) |
| Output Directory | để trống |
| Install Command | để trống |

`web` là thư mục chứa `index.html`. Để nguyên gốc repo thì Vercel sẽ phục vụ cả
`plan/`, `spec/`, `dev.sh`… và trang ra 404.

Bấm **Deploy**. Xong có URL dạng `buddha-xxx.vercel.app`.

## Bước 3 — Test trên URL vercel.app TRƯỚC khi đổi domain

URL đó đã có HTTPS nên camera chạy được. Mở trên iPhone và kiểm:

- [ ] Tab Quét QR xin quyền camera, hiện được hình
- [ ] Chĩa vào `qr/dia-tang.png` → nhảy sang tab Giới thiệu đúng tượng
- [ ] Video phát được **có tiếng**
- [ ] Tab bar không bị thanh home indicator che
- [ ] Mở thẳng `<url>/?v=dia-tang` → vào ngay tab Giới thiệu

Hỏng thì sửa rồi push, Vercel tự deploy lại. **Chưa đụng tới domain ở bước này**, nên
trang TrustPage cũ vẫn chạy bình thường trong lúc test.

## Bước 4 — Chuyển domain sang project mới

Chỉ làm khi bước 3 đã đạt.

1. Project **cũ** (TrustPage) → **Settings** → **Domains** → gỡ `trustpage.info`
   và `www.trustpage.info`.
2. Project **mới** (buddha) → **Settings** → **Domains** → thêm `trustpage.info`,
   rồi thêm `www.trustpage.info` (để nó redirect về apex).
3. Xong. **Không cần sửa gì ở Mat Bao** — bản ghi A và CNAME đã trỏ đúng Vercel rồi.
   HTTPS Vercel tự cấp lại, thường trong vài phút.

**Đừng xoá project cũ.** Chỉ gỡ domain thôi. Nó vẫn sống ở URL `*.vercel.app` của nó,
lỡ cần lấy lại nội dung hay đổi ý thì gắn domain về là xong. Xoá project là không lùi được.

## Bước 5 — Sau khi domain chạy

Không phải sinh lại gì cả: `qr/dia-tang.png` và `qr/tuong-2.png` đã trỏ sẵn
`https://trustpage.info/?v=<id>`, và `og:url` trong `index.html` cũng đã đúng.

Chỉ việc in QR, tối thiểu 3×3 cm để camera bắt được ở khoảng cách 20–30 cm.

---

## Không thêm `vercel.json`

Repo cố tình không có file này. Trang TrustPage cũ gửi header
`permissions-policy: camera=()` — bê cấu hình đó sang là **tab Quét QR chết câm**, không
báo lỗi gì cả. Project mới dùng repo mới nên không kế thừa, cứ để mặc định.

## Cập nhật nội dung về sau

Sửa `web/content.json` (thêm mp4 vào `web/videos/` nếu có tượng mới) → `git push` →
Vercel tự deploy. Thêm tượng thì chạy `./qr.sh` để có QR của tượng đó.
