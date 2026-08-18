#!/bin/sh
# Sinh QR cho mọi id có trong web/content.json.
#
#   ./qr.sh                                  -> qr/<id>.png       (https://trustpage.info)
#   ./qr.sh https://abc.ngrok-free.app local- -> qr/local-<id>.png (dev.sh gọi cái này)
#
# Thêm tượng vào content.json rồi chạy lại là có QR mới, không phải nhớ id nào đã sinh.
set -e
BASE=${1:-https://trustpage.info}
PREFIX=$2
mkdir -p qr

python3 -c 'import json;print("\n".join(json.load(open("web/content.json"))["buddhas"]))' \
| while IFS= read -r id; do
  [ -n "$id" ] || continue
  uvx --from segno segno "$BASE/?v=$id" -o "qr/$PREFIX$id.png" -s 12 --border 3
  echo "  qr/$PREFIX$id.png   ->   $BASE/?v=$id"
done
