# Deploy lên trustpage.info

Trang tĩnh thuần, không backend, không build step → chỉ cần đẩy nguyên thư mục `web/`.

## Cloudflare Pages (khuyến nghị)

1. dash.cloudflare.com → **Workers & Pages** → **Create** → **Pages** →
   **Upload assets**.
2. Kéo thả thư mục `web/`. Build command: **để trống**. Output directory: `/`.
3. Deploy xong sẽ có URL `*.pages.dev` — test trước ở đó.
4. **Custom domains** → **Set up a domain** → nhập `trustpage.info`.
   - Nếu domain đã ở Cloudflare: bấm 1 nút là xong, DNS tự tạo.
   - Nếu chưa: đổi nameserver của `trustpage.info` sang Cloudflare (registrar hiện
     tại → Nameservers), chờ DNS lan, rồi làm lại bước này.
5. HTTPS tự cấp, không phải làm gì. **Bắt buộc phải có HTTPS** — tab Quét QR dùng
   camera, `getUserMedia` chỉ chạy trên secure context.

Băng thông không giới hạn ở gói free, hợp với việc phục vụ video.

## Sau khi domain chạy

```bash
./qr.sh
```

Sinh `qr/<id>.png` trỏ `https://trustpage.info/?v=<id>` cho mọi id trong
`content.json`. In tối thiểu 3×3 cm để camera bắt được ở khoảng cách 20–30 cm.

## Cập nhật nội dung về sau

Sửa `web/content.json` (và thêm mp4 vào `web/videos/` nếu có tượng mới) → upload lại
thư mục `web/`. Không cần build, không cần đụng code.

Thêm tượng mới thì chạy lại `./qr.sh` để có QR của tượng đó.

## Kiểm tra sau khi deploy

- [ ] `https://trustpage.info/` mở được, vào tab Quét QR, camera bật (Safari sẽ hỏi quyền)
- [ ] Quét `qr/dia-tang.png` → nhảy sang tab Giới thiệu đúng tượng
- [ ] Video phát được có tiếng (Cloudflare trả `206 Partial Content` cho request Range)
- [ ] `https://trustpage.info/?v=dia-tang` mở thẳng tab Giới thiệu
- [ ] Tab bar không bị home indicator che
