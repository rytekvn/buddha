#!/bin/sh
# Đẩy toàn bộ video trong web/videos/ lên bucket R2.
#
#   npx wrangler login        # làm 1 lần, mở trình duyệt để đăng nhập Cloudflare
#   ./upload-r2.sh            # bucket mặc định: buddha-video
#   ./upload-r2.sh <bucket>
#
# Tên file = tên key trên R2 = id trong content.json, nên URL cuối cùng là
#   https://video.trustpage.info/<id>.mp4
set -e
BUCKET=${1:-buddha-video}

for f in web/videos/*.mp4; do
  key=$(basename "$f")
  npx --yes wrangler r2 object put "$BUCKET/$key" \
    --file="$f" --content-type=video/mp4 --remote
  echo "  ✓ $key"
done

echo
echo "Xong. Kiểm tra: https://video.trustpage.info/$(basename "$(ls web/videos/*.mp4 | head -1)")"
