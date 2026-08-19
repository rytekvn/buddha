# Spec – Trust Page (Buddha QR)

Domain: **trustpage.info**. Quy mô nhỏ: không backend, không database, không phân
quyền → chỉ cần file này + `PROGRESS.md`. Lý do các quyết định:
[plan/rytek-buddha-qr-plan.md](../plan/rytek-buddha-qr-plan.md). Deploy: [DEPLOY.md](../DEPLOY.md).

## Hợp đồng

| Thứ | Giá trị |
|---|---|
| Nội dung QR | `https://trustpage.info/?v=<id>` |
| `<id>` hợp lệ | key trong `buddhas` của [web/content.json](../web/content.json) |
| Quét trong app | tab 1, camera + jsQR, lấy `?v=` từ URL đọc được |
| Quét bằng camera máy | mở `/?v=<id>` → app vào thẳng tab 2 |
| Vào app không có `?v=` | mở tab 1 (Quét QR) |
| Id sai | "Mã QR không thuộc hệ thống", vẫn quét tiếp |
| Lịch sử | `localStorage` key `buddha.history`, tối đa 100, mới nhất lên đầu |

---

## Cấu trúc JSON

Một file duy nhất `web/content.json`. Không database — đây là toàn bộ "CMS".

```jsonc
{
  "temple": {
    "name": "...",
    "address": "...",
    "maps": "",            // URL Google Maps; rỗng thì ẩn nút Chỉ đường
    "sections": [ ... ]    // giống hệt sections của vị Phật
  },

  "ads": {                 // rỗng client = tắt hoàn toàn, không tải script bên thứ ba
    "client": "",          // "ca-pub-XXXXXXXXXXXXXXXX"
    "slots": { "hist": "", "temple": "" }
  },

  "buddhas": {
    "<id>": {              // id = slug, cũng là giá trị ?v= trong QR
      "name": "Địa Tạng Vương Bồ Tát",
      "han": "地藏王菩薩",
      "sanskrit": "Kṣitigarbha",
      "summary": "...",    // một dòng, hiện ở tab Lịch sử
      "video": "videos/1.mp4",
      "sections": [ ... ]
    }
  }
}
```

### Section

```jsonc
{ "title": "Hạnh nguyện", "body": [ ... ] }
```

### Bốn kiểu phần tử trong `body`

Kiểu tự khai bằng chính kiểu dữ liệu, không cần trường `"type"`:

| Viết thế này | Ra thế nào |
|---|---|
| `"Một đoạn văn."` | đoạn văn `<p>` |
| `["Cứu độ người đã khuất."]` | gạch đầu dòng |
| `["Tích trượng (錫杖)", "Mở cửa địa ngục…"]` | gạch đầu dòng, **thuật ngữ** in đậm rồi tới giải thích |
| `{"quote": "…", "nghia": "…"}` | khối trích dẫn có vạch vàng; `nghia` là phần dịch, in mờ bên dưới |

Quy tắc:

- **Thứ tự trong `body` là thứ tự hiển thị.** Đoạn văn đặt sau trích dẫn thì hiện sau —
  không bị ép về đầu.
- Các gạch đầu dòng liền nhau tự gom thành một danh sách.
- `\n` trong chuỗi xuống dòng thật (dùng cho câu kệ hai vế).
- `nghia` bỏ được nếu trích dẫn không cần dịch.

### Ví dụ đầy đủ một section

```json
{
  "title": "Hạnh nguyện",
  "body": [
    "Địa Tạng Vương Bồ Tát nổi tiếng với đại nguyện cứu độ tất cả chúng sinh.",
    "Ngài phát lời nguyện rộng lớn:",
    {
      "quote": "Địa ngục vị không, thệ bất thành Phật;\nChúng sinh độ tận, phương chứng Bồ-đề.",
      "nghia": "Nếu địa ngục còn chưa trống, con nguyện chưa thành Phật;\nChỉ khi cứu độ hết thảy chúng sinh, con mới chứng quả Bồ-đề."
    },
    "Đây là một trong những đại nguyện nổi tiếng nhất trong Phật giáo Đại thừa."
  ]
}
```

Bốn kiểu này đủ cho toàn bộ nội dung mẫu của Địa Tạng (7 section: Danh hiệu, Hạnh
nguyện, Biểu tượng, Công hạnh, Kinh điển, Danh hiệu thường niệm, Ý nghĩa đối với
người Phật tử). Thêm kiểu mới chỉ khi có nội dung thật sự không diễn đạt được.

---

## Bốn tab

| # | Tab | Nội dung |
|---|---|---|
| 1 | Quét QR | camera + khung ngắm, quét ra thì sang tab 2 |
| 2 | Giới thiệu | tên + Hán + Phạn, video thuyết minh, các section |
| 3 | Lịch sử | list tượng đã quét — tên, `summary`, thời điểm. **Không có video** |
| 4 | Thông tin chùa | tên, địa chỉ, Chỉ đường, các section của chùa, link Chính sách riêng tư |

### Quảng cáo

Banner AdSense **chỉ** ở tab 3 và tab 4. Không bao giờ ở tab 1 (đang mở camera) và
tab 2 (có video, hình tượng). Giới hạn nằm ở hằng `AD_TABS` trong `index.html`.
Hướng dẫn bật: [ADSENSE.md](../ADSENSE.md).

## Acceptance

**Quét**
1. Mở app không kèm `?v=` → vào tab 1, camera bật, có khung ngắm.
2. Chĩa vào QR hợp lệ → nhảy sang tab 2 đúng tượng, camera tắt.
3. Chĩa vào QR lạ → báo "Mã QR không thuộc hệ thống", vẫn quét tiếp được.
4. Chạy qua http (không phải localhost) → báo rõ "Camera cần HTTPS".
5. Từ chối quyền camera → báo rõ cách bật lại, không màn hình đen.
6. Rời tab 1 / khoá máy / chuyển app → camera nhả, đèn báo camera tắt.
7. Quét bằng camera hệ thống → Safari mở `/?v=<id>` → vào thẳng tab 2.

**Nội dung**
8. Tab 2 hiện tên + `han · sanskrit`, video, rồi các section theo đúng thứ tự JSON.
9. Trong một section, đoạn văn đặt sau `quote` phải hiện **sau** khối trích dẫn.
10. Các gạch đầu dòng liền nhau gom vào một danh sách, không tách rời.
11. `\n` trong `quote` xuống dòng thật.
12. Video thử tự phát; Safari chặn thì nút play mặc định vẫn dùng được.
13. Rời tab 2 → video dừng.
14. Chưa quét gì mà vào tab 2 → "Chưa quét tượng nào", không lỗi.
15. `content.json` hỏng hoặc tải không được → báo "Không tải được nội dung", không trắng màn hình.

**Lịch sử**
16. Sau mỗi lần quét, tượng đó lên đầu danh sách tab 3.
17. Quét lại tượng cũ → đẩy lên đầu, **không** tạo dòng trùng.
18. Bấm một dòng → mở tab 2 của tượng đó.
19. Tab 3 không nhúng video.
20. Id đã gỡ khỏi `content.json` tự biến mất khỏi danh sách.

**Chùa & chung**
21. Tab 4 hiện tên + địa chỉ + các section; `maps` rỗng thì ẩn nút Chỉ đường.
22. Tab bar không bị home indicator của iPhone che (safe-area).
23. Tab 4 có link "Chính sách riêng tư" mở được `privacy.html`.

**Quảng cáo**
24. `ads.client` rỗng → **không** tải script AdSense, **không** có thẻ `<ins>` nào.
25. `ads.client` có giá trị → script nạp 1 lần duy nhất, đúng `?client=`.
26. Thẻ quảng cáo chỉ xuất hiện ở tab 3 và tab 4; tab 1 và tab 2 luôn bằng 0.
27. Đổi tab qua lại nhiều lần → mỗi ô quảng cáo chỉ gọi **một lần**
    (chặn bằng `data-pushed`; gọi lại liên tục là vi phạm chính sách AdSense).
28. Ô quảng cáo chỉ được gọi khi panel đã hiện và có bề ngang > 0 — AdSense từ chối
    render trong khung rộng 0px, mà panel lúc ẩn là `display:none`.
29. Mỗi ô quảng cáo có nhãn "Quảng cáo" phía trên.
30. `ads.txt` mở được tại gốc domain.
