# Gắn Google AdSense

App đã cài sẵn. **Chưa bật** — `ads.client` trong `web/content.json` còn rỗng nên trang
không tải một dòng script bên thứ ba nào. Điền ID vào là bật, xoá đi là tắt.

## Vị trí quảng cáo (đã cố định trong code)

| Tab | Có quảng cáo |
|---|---|
| 1. Quét QR | **Không** — đang mở camera |
| 2. Giới thiệu | **Không** — có video thuyết minh và hình tượng |
| 3. Lịch sử | Có, cuối danh sách |
| 4. Thông tin chùa | Có, cuối trang |

Giới hạn này nằm trong hằng `AD_TABS` ở `web/index.html`. Đặt quảng cáo cạnh hình
tượng là rủi ro uy tín cho chùa — quảng cáo tự động không chọn được nội dung, cờ bạc
hay vay tiền nhanh hiện ra là chuyện bình thường.

---

## Trước khi đăng ký

AdSense duyệt **site đang chạy thật**, nên phải xong mấy việc này trước:

- [ ] Deploy lên `trustpage.info` (xem `DEPLOY.md`)
- [ ] Điền hết nội dung TODO trong `content.json` — ít nhất `temple` và vài vị Phật
- [ ] `privacy.html` đã mở được tại `https://trustpage.info/privacy.html`

**Nói thẳng về khả năng bị từ chối:** AdSense yêu cầu nội dung gốc đủ dày. Trang này
chủ yếu là video và vài đoạn text, lại là ứng dụng một trang — khả năng bị đánh
"thin content" hoặc "low value content" là có thật. Càng nhiều tượng với nội dung
đầy đủ như Địa Tạng thì cửa duyệt càng sáng. Đừng nộp khi mới có 1–2 tượng.

## Đăng ký và lấy ID

1. [adsense.google.com](https://adsense.google.com) → đăng ký, khai `trustpage.info`.
2. Nó bảo chèn đoạn mã xác minh vào site. **Không phải chèn tay** — app đã tự chèn
   đúng đoạn đó khi `ads.client` có giá trị. Cứ điền publisher ID vào `content.json`
   rồi deploy, sau đó bấm xác minh.
3. Chờ duyệt (vài ngày tới vài tuần).
4. Duyệt xong: **Ads → By ad unit → Display ads**, tạo **2 ad unit**:
   - tên `hist` → lấy `data-ad-slot`
   - tên `temple` → lấy `data-ad-slot`

## Điền vào `web/content.json`

```json
"ads": {
  "client": "ca-pub-XXXXXXXXXXXXXXXX",
  "slots": {
    "hist": "1234567890",
    "temple": "0987654321"
  }
}
```

`client` lấy ở **Account → Settings → Account information**. Để rỗng `client` là tắt
toàn bộ quảng cáo. Để rỗng riêng một `slot` là tắt riêng chỗ đó.

## `ads.txt`

Sửa `web/ads.txt`, bỏ dấu `#` ở dòng cuối và thay ID thật:

```
google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
```

Thiếu file này thì AdSense giới hạn doanh thu. File phải nằm ở gốc domain — vì Vercel
đặt Root Directory là `web` nên `web/ads.txt` sẽ ra đúng `https://trustpage.info/ads.txt`.

## Cookie consent

**Đừng tự viết banner.** Bật cái có sẵn: AdSense → **Privacy & messaging** → **GDPR**
(và **CCPA** nếu cần) → tạo message → publish. Google tự hiện banner đúng chuẩn IAB TCF
cho khách ở khu vực cần, khách Việt Nam thì không thấy gì.

`privacy.html` đã có sẵn phần khai báo về cookie quảng cáo và link tắt quảng cáo cá
nhân hoá, và đã được link ở cuối tab Thông tin chùa.

---

## Kiểm tra sau khi bật

```bash
curl -s https://trustpage.info/ads.txt          # phải thấy dòng google.com, pub-...
curl -s https://trustpage.info/privacy.html | head -5
```

Trên điện thoại:

- [ ] Tab Quét QR: **không** có quảng cáo, camera vẫn chạy
- [ ] Tab Giới thiệu: **không** có quảng cáo, video vẫn phát
- [ ] Tab Lịch sử: có ô quảng cáo dưới danh sách, có nhãn "Quảng cáo"
- [ ] Tab Thông tin chùa: có ô quảng cáo, có link Chính sách riêng tư
- [ ] Đổi qua lại giữa các tab nhiều lần: **không** gọi lại quảng cáo mỗi lần
      (đã chặn bằng `data-pushed`; gọi lại liên tục là vi phạm chính sách)

## Muốn tắt

Xoá giá trị `ads.client` trong `content.json` rồi push. Trang trở lại không có script
quảng cáo nào.
