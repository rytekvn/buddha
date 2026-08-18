# Deploy lên Cloudflare Pages

Trang tĩnh thuần, không backend, không build step → Cloudflare Pages chỉ việc phục vụ
nguyên thư mục `web/`.

---

## ⚠️ Đọc trước: apex `trustpage.info` ĐANG CÓ SẢN PHẨM KHÁC

Tính tới 18/08/2026:

| Thứ | Trạng thái |
|---|---|
| `trustpage.info` | đang chạy **"TrustPage — Đâu là thông tin chính thức?"**, host trên Vercel (A → `76.76.21.21`) |
| `www.trustpage.info` | CNAME → `cname.vercel-dns.com` |
| Nameserver | `ns1/ns2.matbao.com` — **không** ở Cloudflare |
| Email | `MX → mx.zoho.com`, có TXT xác minh Zoho |

Hệ quả:

- Trỏ apex sang Cloudflare Pages sẽ **thay thế trang đang sống**. Đừng làm trừ khi
  đó đúng là ý định.
- Muốn dùng apex trên Cloudflare thì phải chuyển nameserver về Cloudflare, và phải
  tạo lại **MX + TXT của Zoho** trong DNS Cloudflare, nếu không sẽ **mất email**.

→ Dùng **subdomain**. Không đụng trang đang chạy, không đụng email, không phải chuyển
nameserver. Dưới đây dùng `phat.trustpage.info` làm ví dụ.

---

## Bước 1 — Tạo project, nối thẳng repo GitHub

Nối Git thay vì kéo thả thư mục: về sau `git push` là tự deploy, không phải upload tay.

1. Vào [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages** →
   **Create** → tab **Pages** → **Connect to Git**.
2. Authorize GitHub. Repo `buddha` thuộc account **rytekvn**, nên khi GitHub hỏi cài
   Cloudflare app thì phải chọn đúng account `rytekvn` (không phải `ryantranvortech`),
   rồi cấp quyền cho repo `buddha`.
3. Chọn repo `rytekvn/buddha` → **Begin setup**.

## Bước 2 — Cấu hình build

Đây là bước duy nhất dễ sai. Điền đúng như sau:

| Trường | Giá trị |
|---|---|
| Production branch | `main` |
| Framework preset | **None** |
| Build command | **để trống** |
| Build output directory | **`web`** ← quan trọng nhất |
| Root directory | để mặc định (`/`) |

`web` là thư mục chứa `index.html`. Để trống ô này thì Cloudflare sẽ phục vụ gốc repo
và trang ra 404.

Bấm **Save and Deploy**. Xong sẽ có URL dạng `buddha-xxx.pages.dev`.

## Bước 3 — Test trên URL pages.dev trước

`*.pages.dev` đã có HTTPS nên camera chạy được. Mở trên iPhone và kiểm:

- [ ] Tab Quét QR xin quyền camera và mở được hình
- [ ] Chĩa vào `qr/dia-tang.png` → nhảy sang tab Giới thiệu đúng tượng
- [ ] Video phát được **có tiếng**
- [ ] Tab bar không bị thanh home indicator che
- [ ] Mở thẳng `<url>/?v=dia-tang` → vào ngay tab Giới thiệu

Hỏng ở bước này thì sửa rồi push, Cloudflare tự deploy lại.

## Bước 4 — Gắn subdomain

1. Trong project Pages → **Custom domains** → **Set up a domain** → nhập
   `phat.trustpage.info`.
2. Vì `trustpage.info` không nằm trong account Cloudflare, nó sẽ **không** tự tạo DNS
   mà đưa cho ông một giá trị CNAME (chính là `buddha-xxx.pages.dev`).
3. Vào trang quản trị **Mat Bao** → DNS của `trustpage.info` → thêm bản ghi:

   | Type | Name | Value | TTL |
   |---|---|---|---|
   | CNAME | `phat` | `buddha-xxx.pages.dev` | mặc định |

   Chỉ thêm bản ghi mới. **Không sửa, không xoá** bản ghi A của apex, CNAME `www`,
   hay MX/TXT của Zoho.
4. Quay lại Cloudflare bấm kiểm tra. Chờ từ vài phút tới vài tiếng tuỳ TTL.
   HTTPS Cloudflare tự cấp.

## Bước 5 — Cập nhật URL trong dự án

Sau khi subdomain chạy:

```bash
./qr.sh https://phat.trustpage.info    # sinh lại QR trỏ domain thật
```

Và sửa `og:url` trong `web/index.html` thành `https://phat.trustpage.info/`, rồi push.

In QR tối thiểu 3×3 cm để camera bắt được ở khoảng cách 20–30 cm.

---

## Không cần file `_headers`

Mặc định của Cloudflare Pages không chặn camera. **Đừng** copy header của trang
trustpage.info hiện tại sang — trang đó gửi `permissions-policy: camera=()`, bê sang
đây là tab Quét QR chết câm mà không báo lỗi gì.

## Cập nhật nội dung về sau

Sửa `web/content.json` (thêm mp4 vào `web/videos/` nếu có tượng mới) → `git push`.
Cloudflare tự deploy. Thêm tượng thì chạy lại `./qr.sh https://phat.trustpage.info`.

## Nếu vẫn muốn dùng apex `trustpage.info`

Phải chấp nhận cả ba việc sau, làm thiếu một là hỏng:

1. Trang TrustPage hiện tại trên Vercel sẽ bị thay thế — cần chốt là bỏ hẳn hay dời đi đâu.
2. Chuyển nameserver `trustpage.info` từ Mat Bao sang Cloudflare.
3. Trước khi chuyển, **chép lại toàn bộ bản ghi DNS hiện có** (nhất là `MX → mx.zoho.com`
   và TXT `zoho-verification=...`) rồi tạo lại đủ trong Cloudflare DNS. Thiếu MX là
   mất email của cả domain.

Rẻ hơn nhiều so với việc dùng subdomain, mà chẳng được thêm gì.
