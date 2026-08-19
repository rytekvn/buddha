# PROGRESS

Cập nhật: 2026-08-18

## Đang ở đâu

Web app tĩnh, tự quét QR, 4 tab, nội dung trong 1 file JSON. Domain **trustpage.info**
đã có, chưa deploy. Không app iOS, không AR/3D, không CMS, không database.
Plan cũ archive ở `plan/OLD-rytek-buddha-ar-plan.md`.

Cấu trúc xong và chạy được. **Nội dung 5 vị đã đầy đủ**, mỗi vị 7 section. Phần
`temple` (thông tin chùa) còn TODO — user sẽ gửi sau.

## Cấu trúc JSON đã chuẩn hoá

`web/content.json` = `{ temple, buddhas }`. Mỗi vị có `sections[]`, mỗi section là
`{title, body[]}`. Phần tử trong `body` **tự khai kiểu bằng kiểu dữ liệu**:

| Viết | Ra |
|---|---|
| `"đoạn văn"` | `<p>` |
| `["mục"]` | gạch đầu dòng |
| `["thuật ngữ", "giải thích"]` | gạch đầu dòng, thuật ngữ in đậm |
| `{"quote":"…","nghia":"…"}` | trích dẫn vạch vàng + phần dịch mờ bên dưới |

Thứ tự trong `body` là thứ tự hiển thị. Đặc tả đầy đủ: `spec/README.md`.

## Đã xong

- Plan v4: `plan/rytek-buddha-qr-plan.md`
- Spec + 22 acceptance + đặc tả JSON: `spec/README.md`
- `DEPLOY.md` — các bước lên Cloudflare Pages + trustpage.info
- `web/index.html` — 4 tab, scanner, renderer JSON→HTML, lịch sử, xử lý lỗi
- `web/content.json` — 5 vị, mỗi vị đủ 7 section (~22 KB):

  | id | Tên | Video |
  |---|---|---|
  | `thich-ca` | Phật Thích Ca Mâu Ni | chưa có |
  | `a-di-da` | Phật A Di Đà | chưa có |
  | `quan-am` | Quán Thế Âm Bồ Tát | chưa có |
  | `dia-tang` | Địa Tạng Vương Bồ Tát | `dia-tang.mp4` |
  | `di-lac` | Di Lặc Bồ Tát | chưa có |

  ⚠️ **Nội dung 4 vị mới do tôi soạn theo khuôn Địa Tạng user đã gửi**, dựa trên tài
  liệu Phật giáo Đại thừa phổ thông. **Cần nhà chùa duyệt lại trước khi in QR** — đây
  là văn bản giáo lý, sai một chữ là chuyện lớn với chùa. Riêng Địa Tạng là nguyên văn
  user gửi, không sửa.
- `web/lib/jsQR.js` — vendor 251 KB, không CDN
- `web/videos/dia-tang.mp4`, `tuong-2.mp4` — nén 8.7 MB → 2.0 MB (crf 30, +faststart);
  tên file = id để khớp key trên R2
- `web/privacy.html` — chính sách riêng tư (camera, lịch sử localStorage, cookie quảng cáo)
- `web/ads.txt` — mẫu, còn comment; bỏ `#` sau khi có publisher ID
- `ADSENSE.md` — quy trình đăng ký, lấy ID, bật consent, kiểm tra
- `qr.sh` — sinh QR cho mọi id trong content.json
- `upload-r2.sh` — đẩy web/videos/*.mp4 lên bucket R2 bằng wrangler
- `R2.md` — quy trình dời nameserver + dựng R2 + bảng DNS phải tạo lại
- `dev.sh` — port rảnh + http-server + ngrok HTTPS + gọi qr.sh
- `qr/*.png` — 5 QR production trỏ `https://trustpage.info/?v=<id>`

## Đã tự kiểm tra (preview 375×812)

- Địa Tạng render đúng: 7 section, 3 trích dẫn, 4 danh sách, 18 gạch đầu dòng, 8 đoạn văn
- Header tab 2: `Địa Tạng Vương Bồ Tát` / `地藏王菩薩 · Kṣitigarbha`
- **Thứ tự trong section "Hạnh nguyện" đúng:** P → P → BLOCKQUOTE → P (đoạn kết nằm
  sau câu kệ, đây là lý do `body` phải là mảng có thứ tự)
- Tab 4: 3 section, ẩn nút Chỉ đường vì `maps` rỗng
- Rời tab 2 → `video.paused === true`
- Cả 5 vị render đúng 7 section; tượng chưa có video thì **bỏ hẳn thẻ `<video>`**,
  không để trình phát rỗng đen sì (chỉ `dia-tang` có thẻ video)
- `idFrom()` đúng 6 ca: URL có `?v=`, URL có port, id trần, id thừa khoảng trắng,
  URL thiếu param, chuỗi rác
- JS qua `node --check`, JSON qua `json.load`
- Không lỗi console

**Chưa test trên iPhone thật.** Ba thứ bắt buộc thử trên Safari thật: quét camera,
autoplay có tiếng, safe-area.

## Quyết định đã chốt

- Nội dung ở **JSON** chứ không phải JS: sửa không sợ hỏng cú pháp code, và nếu sau này
  có CMS thì chỉ cần sinh đúng file JSON đó, app không phải đổi.
- `body` là **mảng có thứ tự**, không phải object nhiều trường — vì nội dung thật có
  dạng "đoạn văn → câu kệ → đoạn kết", ép thứ tự cố định sẽ đảo mất đoạn kết.
- Kiểu phần tử suy ra từ kiểu dữ liệu, không có trường `"type"` — JSON viết tay gọn hơn.
- Một file JSON cho tất cả, không tách theo tượng. ~5 KB/tượng, 50 tượng vẫn < 300 KB.
- Id là slug (`dia-tang`), không phải số.
- App tự quét bằng jsQR, KHÔNG dùng `BarcodeDetector` (iOS Safari không có).
- QR chứa URL đầy đủ → dùng được cả 2 đường: quét trong app, và quét bằng camera hệ thống.
- Camera cần HTTPS → dev phải qua tunnel; `dev.sh` dùng ngrok (máy đã có authtoken).
- Video dùng `<video controls>`, không tự vẽ overlay.
- Server local `npx http-server`, KHÔNG `python3 -m http.server` (trả 200 thay vì 206
  cho request Range → iOS Safari không phát được video; đã đo bằng curl).
- Lịch sử: localStorage, dedup theo id, tối đa 100 dòng.
- Vanilla HTML/CSS/JS, không framework, không build step.
- Host: Cloudflare Pages + trustpage.info.

## Domain & hosting (chốt 18/08/2026)

`trustpage.info` **sẽ dùng cho dự án này**, trang TrustPage cũ bỏ.

Host: **Vercel**, không phải Cloudflare Pages. Lý do: domain đã trỏ sẵn Vercel
(A 76.76.21.21, www → cname.vercel-dns.com), nameserver ở Mat Bao, email chạy qua Zoho.
Đổi domain sang project mới chỉ là thao tác trong dashboard Vercel, **không đụng DNS ở
Mat Bao**, nên không có rủi ro mất email. Đi Cloudflare Pages thì phải dời nameserver và
tạo lại MX/TXT Zoho — rủi ro thật, đổi lại chẳng được gì cho một trang tĩnh.

Gói Hobby: 100 GB/tháng. Đã nén video lại ở **crf 30** (2,00 MB thay vì 3,3 MB) để chịu
được cao điểm 1000 lượt/ngày:

| Lưu lượng | GB/tháng |
|---|---|
| 500 lượt/ngày | 32,5 |
| 1000 lượt/ngày | 65,0 (dư 35%) |
| 1500 lượt/ngày | 97,4 (sát trần) |

Ở crf 26 cũ thì 1000 lượt/ngày ra 105 GB — vượt trần. Đã soi khung hình cạnh nhau để
chọn crf 30 ở 720 gốc thay vì hạ 540px (540px nhoè hoa văn áo tượng).

**Đã chốt: đưa video sang Cloudflare R2** để khỏi lo quá tải. Egress R2 miễn phí →
1000 lượt/ngày còn 1,9 GB/tháng trên Vercel. Lợi ích thứ hai: video ra khỏi git, khỏi
phình repo mỗi lần thay video.

Code đã sẵn sàng: `content.json` có trường `videoBase`, app ghép `videoBase + tên file`.
Chuyển host = sửa 1 dòng JSON, không đụng code. URL tuyệt đối trong `video` vẫn được
dùng nguyên (đã test cả 3 trường hợp).

**Điều kiện chưa làm được:** R2 custom domain đòi domain phải là zone trong Cloudflare,
mà partial CNAME setup cần Business, subdomain zone cần Enterprise → **phải dời
nameserver trustpage.info từ Mat Bao về Cloudflare**. URL `r2.dev` bị rate-limit, không
dùng cho production.

Đã kiểm kê đủ 5 bản ghi DNS hiện có (A, CNAME www, MX Zoho, TXT xác minh, TXT DKIM) và
ghi vào `R2.md` để tạo lại cho đúng, tránh mất email. Domain chưa có SPF — nên thêm luôn
lúc đụng DNS.

Chùa không bán gì nên không vướng điều khoản "non-commercial" của Hobby.

Hai điểm dễ vỡ, đã ghi trong DEPLOY.md:
- **Root Directory = `web`** khi tạo project, không thì Vercel phục vụ gốc repo → 404.
- Không thêm `vercel.json`. Trang cũ gửi `permissions-policy: camera=()`; bê sang là
  tab Quét QR chết câm mà không báo lỗi.

Thứ tự an toàn: deploy → test trên `*.vercel.app` → **rồi mới** gỡ domain khỏi project cũ
và gắn sang project mới. Không xoá project cũ, chỉ gỡ domain (xoá là không lùi được).

QR trong `qr/` và `og:url` đã trỏ đúng `https://trustpage.info` — không phải sinh lại.

## Quảng cáo AdSense (chốt 18/08/2026)

User quyết dùng AdSense sau khi đã nghe các rủi ro. Đã cài xong, **đang tắt**:
`ads.client` trong content.json rỗng → không tải script bên thứ ba nào.

Lưu ý đã nêu với user và user vẫn chọn tiếp tục:
- AdMob **không dùng cho web**, chỉ cho app native → phải là AdSense.
- Chi phí hạ tầng hiện tại là **0 USD/tháng**; sau khi sang R2 thì phải tới ~53.000
  lượt/ngày mới chạm trần Vercel. Tức là chưa có khoản nào cần bù.
- Rủi ro bị từ chối vì "thin content" là có thật — đừng nộp khi mới 1–2 tượng.

Giới hạn vị trí đã cứng trong code (hằng `AD_TABS`):
- Tab 1 Quét QR: **không** — đang mở camera
- Tab 2 Giới thiệu: **không** — có video và hình tượng
- Tab 3 Lịch sử + Tab 4 Thông tin chùa: có

Chi tiết kỹ thuật đáng nhớ:
- Panel lúc ẩn là `display:none`, AdSense từ chối render trong khung rộng 0px → chỉ
  push sau `requestAnimationFrame` và khi `offsetWidth > 0`. Nếu chưa có bề ngang thì
  **không** đánh dấu `data-pushed`, lần vào tab sau tự thử lại.
- Ô quảng cáo tab Lịch sử nằm ngoài phần render lại (`#histAd` tách khỏi `#histList`),
  nên đổi tab không gọi lại quảng cáo — gọi lại liên tục là vi phạm chính sách.
- Consent: bật CMP có sẵn của Google (AdSense → Privacy & messaging), **không tự viết
  banner cookie**.

## Việc còn lại

1. **Nhà chùa duyệt nội dung 4 vị tôi soạn** (thich-ca, a-di-da, quan-am, di-lac).
2. Điền `temple` trong `web/content.json` — user sẽ gửi thông tin chùa.
3. Quay/nén video cho 4 vị chưa có — **phải dùng crf 30**, đây là điều kiện để chịu
   1000 lượt/ngày trong hạn mức Vercel Hobby:
   `ffmpeg -y -i "nguồn.mp4" -vcodec libx264 -crf 30 -preset slow -movflags +faststart -acodec aac -b:a 96k web/videos/<id>.mp4`
   rồi sửa trường `video` trong content.json.
4. Test trên iPhone thật: `./dev.sh` → mở URL ngrok → quét QR trong app.
5. Deploy theo `DEPLOY.md`: import repo vào Vercel, **Root Directory = `web`**,
   test trên `*.vercel.app` trước, rồi mới chuyển domain sang.
6. In QR (đã sinh sẵn, trỏ đúng apex).
7. AdSense theo `ADSENSE.md`: deploy + điền nội dung xong đã, rồi mới đăng ký. Có ID
   thì điền vào `ads` trong content.json, sửa `web/ads.txt`, bật CMP.
8. R2 theo `R2.md`: dời nameserver về Cloudflare (đối chiếu đủ 5 bản ghi DNS, test
   email sau khi xong) → tạo bucket → `./upload-r2.sh` → gắn `video.trustpage.info` →
   sửa `videoBase` → gỡ video khỏi git.

## Chưa xác nhận với user

- **Chọn bản dựng nào cho Địa Tạng.** `Video 1.mp4` và `Video 3.mp4` đều là Địa Tạng
  Vương Bồ Tát, cùng 15,09s, cùng 720×1280, cùng có tiếng — chỉ khác góc máy:
  Video 1 zoom từ xa vào, Video 3 mở từ cận mặt rồi lùi ra.
  Đang dùng **Video 1**. Muốn đổi sang Video 3:
  `ffmpeg -y -i "Video 3.mp4" -vcodec libx264 -crf 30 -preset slow -movflags +faststart -acodec aac -b:a 96k web/videos/dia-tang.mp4`
  Đã gỡ `web/videos/tuong-2.mp4` (bản nén của Video 3) vì không id nào trỏ tới; nguồn
  vẫn còn trên máy.
- **Cả hai video có watermark "Ai" ở góc trên trái.** Cần bản sạch trước khi in QR.
- Thông tin chùa cho tab 4 (user sẽ gửi).
- Danh sách tượng thật của chùa — 5 vị hiện tại là những vị phổ biến nhất trong chùa
  Việt, có thể chùa có thêm hoặc không có vị nào trong số này.
