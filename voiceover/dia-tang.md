# Lời thuyết minh — Địa Tạng Vương Bồ Tát

Ba độ dài. Chọn bản khớp với video rồi dán vào công cụ TTS.
Thời lượng ước tính đã tính cả ngắt nghỉ giữa câu, ở tốc độ đọc trang nghiêm
(~3,7 âm tiết/giây).

| Bản | Âm tiết | Thời lượng ước tính | Dùng khi |
|---|---|---|---|
| Ngắn | 42 | **~13 giây** | video 15s (bản tạm hiện tại) |
| Vừa | 119 | **~36 giây** | video 40–45s |
| Đầy đủ | 249 | **~77 giây** | video 80–90s |

---

## Prompt điều khiển giọng

Dán khối này vào phần mô tả giọng / style của công cụ (ElevenLabs Voice Design,
Play.ht, Google TTS…), rồi dán lời đọc bên dưới vào ô văn bản.

```
Giọng đọc thuyết minh cho video giới thiệu tượng Phật trong chùa Việt Nam.

Giọng:      nam trung niên, trầm, ấm, hơi khàn nhẹ. Giọng Bắc chuẩn hoặc trung tính.
Cảm xúc:    trang nghiêm, từ tốn, thành kính. Kể chuyện chứ không thuyết giảng.
            Không kịch tính, không lên giọng, không hùng biện.
Tốc độ:     chậm, khoảng 3,5–4 âm tiết mỗi giây. Chậm hơn giọng đọc tin tức rõ rệt.
Ngắt nghỉ:  nghỉ 0,5 giây sau mỗi câu. Nghỉ 1 giây trước và sau câu nguyện.
Nhấn:       hạ giọng và chậm lại ở hai câu nguyện, coi đó là cao trào của bài.
Kết thúc:   nhẹ dần, không cắt cụt.
```

Công cụ nào hỗ trợ SSML thì dùng thẻ ngắt thay vì tả bằng lời:
`<break time="0.5s"/>` sau mỗi câu, `<break time="1s"/>` quanh câu nguyện.

---

## Bản ngắn — ~13 giây

```
Địa Tạng Vương Bồ Tát — bậc đại nguyện mang lòng bao dung như đất.
Ngài tự nguyện bước vào những cảnh giới tối tăm nhất, nơi khổ đau còn dày đặc,
để không một chúng sinh nào bị bỏ lại phía sau.
```

## Bản vừa — ~36 giây

```
Địa Tạng Vương Bồ Tát. "Địa" là đất, "Tạng" là kho tàng.
Danh hiệu ấy nói về một tâm nguyện sâu dày, bao dung như lòng đất, và chứa đựng vô lượng công đức.
Trong tay Ngài là cây tích trượng, dùng để mở cửa địa ngục, dẫn đường cho những ai đang lạc lối.
Tay kia nâng viên Như Ý Châu, ánh sáng của trí tuệ và từ bi, soi tan bóng tối vô minh.
Ngài tự nguyện bước vào những nơi khổ đau dày đặc nhất, và phát lời nguyện rộng lớn:
Nếu địa ngục còn chưa trống, con nguyện chưa thành Phật.
Chỉ khi cứu độ hết thảy chúng sinh, con mới chứng quả Bồ đề.
```

## Bản đầy đủ — ~77 giây

```
Địa Tạng Vương Bồ Tát. "Địa" là đất, "Tạng" là kho tàng.
Danh hiệu ấy nói về một tâm nguyện sâu dày, bao dung như lòng đất, và chứa đựng vô lượng công đức.
Trong tay Ngài là cây tích trượng, dùng để mở cửa địa ngục, dẫn đường cho những ai đang lạc lối.
Tay kia nâng viên Như Ý Châu, ánh sáng của trí tuệ và từ bi, soi tan bóng tối vô minh.
Dưới chân Ngài là đài sen, biểu tượng của sự thanh tịnh giữa chốn bụi trần.
Trong tất cả các vị Bồ Tát, Ngài chọn con đường khó nhất.
Ngài tự nguyện bước vào những cảnh giới tối tăm nhất, nơi khổ đau còn dày đặc nhất, và ở lại đó.
Lời nguyện của Ngài được truyền tụng suốt bao đời:
Nếu địa ngục còn chưa trống, con nguyện chưa thành Phật.
Chỉ khi cứu độ hết thảy chúng sinh, con mới chứng quả Bồ đề.
Người đời tìm đến Ngài để cầu cho người đã khuất được nhẹ nhàng siêu thoát,
và cũng để tự nhắc mình sống hiếu kính với cha mẹ khi hãy còn có thể.
Ngài dạy ta rằng làm việc thiện không cần chờ đủ đầy mới làm,
và rằng lòng kiên nhẫn cũng là một cách của từ bi.
Học theo hạnh nguyện của Ngài, là không quay lưng với nỗi khổ của bất cứ ai,
và kiên trì cho tới khi việc lành được hoàn tất.
```

---

## Mấy chỗ TTS hay đọc sai

- **Viết "Bồ đề", không viết "Bồ-đề".** Dấu gạch nối làm nhiều engine tách thành hai
  từ rời hoặc đọc luôn cả dấu. Bản trên đã bỏ gạch nối sẵn.
- **Câu nguyện dùng bản nghĩa tiếng Việt, không dùng bản Hán-Việt.** Nguyên văn
  *"Địa ngục vị không, thệ bất thành Phật"* nghe rất mạnh nhưng TTS tiếng Việt đọc
  Hán-Việt thường sai thanh điệu và ngắt sai nhịp. Nếu vẫn muốn giữ nguyên văn thì
  thu riêng câu đó bằng giọng người thật rồi ghép vào — đừng để máy đọc.
- **"Như Ý Châu"** viết hoa cả ba chữ để engine không đọc "như ý" thành liên từ.
- Nghe lại toàn bộ trước khi ghép vào video. Sai một chữ trong văn bản giáo lý là
  chuyện lớn với chùa.

## Ghép vào video

```bash
# thay hẳn tiếng gốc bằng file thuyết minh
ffmpeg -y -i video-goc.mp4 -i thuyetminh.mp3 -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 96k -shortest web/videos/dia-tang.mp4

# hoặc trộn thuyết minh lên trên nhạc nền có sẵn (nhạc nhỏ lại còn 25%)
ffmpeg -y -i video-goc.mp4 -i thuyetminh.mp3 \
  -filter_complex "[0:a]volume=0.25[bg];[bg][1:a]amix=inputs=2:duration=first[a]" \
  -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 96k web/videos/dia-tang.mp4
```

Nhớ giữ `crf 30` khi nén lại video (xem `DEPLOY.md`) — đó là điều kiện để chịu được
1000 lượt/ngày trong hạn mức Vercel.

---

Bốn vị còn lại (`thich-ca`, `a-di-da`, `quan-am`, `di-lac`) chưa có lời thuyết minh.
Nội dung nguồn đã có sẵn trong `web/content.json`, soạn theo đúng khuôn này là được.
