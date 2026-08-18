#!/bin/sh
# Dev local. Chạy web server + tunnel HTTPS + sinh QR trỏ đúng URL hiện tại.
#
#   ./dev.sh              # có HTTPS qua ngrok — tab "Quét QR" mở được camera
#   NO_TUNNEL=1 ./dev.sh  # chỉ LAN http, nhanh hơn nhưng KHÔNG quét được trong app
#   PORT=9000 ./dev.sh    # ép port
#
# Vì sao phải HTTPS: getUserMedia (camera) chỉ chạy trên secure context.
# http://192.168.x.x bị iOS Safari chặn thẳng, không hỏi quyền luôn.
set -e

# Port bận thì nhích lên, khỏi phải đi kill tiến trình của người khác.
PORT=${PORT:-8000}
while lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; do
  PORT=$((PORT + 1))
done

SRV=""; TUN=""
cleanup() { [ -n "$SRV" ] && kill "$SRV" 2>/dev/null; [ -n "$TUN" ] && kill "$TUN" 2>/dev/null; exit 0; }
trap cleanup INT TERM EXIT

# http-server chứ KHÔNG phải `python3 -m http.server`: python trả 200 thay vì
# 206 Partial Content cho request Range, iOS Safari không phát được video.
npx --yes http-server web -p "$PORT" -c-1 --silent &
SRV=$!
sleep 2

if [ -n "$NO_TUNNEL" ]; then
  IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1)
  [ -n "$IP" ] || { echo "Không lấy được IP LAN."; exit 1; }
  BASE="http://$IP:$PORT"
  echo
  echo "  ⚠️  Chế độ http: tab 'Quét QR' sẽ báo cần HTTPS, camera không mở được."
  echo "      Bỏ NO_TUNNEL đi nếu cần test quét."
else
  ngrok http "$PORT" --log stdout >/tmp/buddha-ngrok.log 2>&1 &
  TUN=$!
  BASE=""
  i=0
  while [ $i -lt 30 ]; do
    BASE=$(curl -s --max-time 2 http://127.0.0.1:4040/api/tunnels 2>/dev/null \
      | python3 -c 'import json,sys;print(next((t["public_url"] for t in json.load(sys.stdin)["tunnels"] if t["public_url"].startswith("https")),""))' 2>/dev/null) || BASE=""
    [ -n "$BASE" ] && break
    i=$((i + 1)); sleep 1
  done
  [ -n "$BASE" ] || { echo "ngrok không lên được. Xem /tmp/buddha-ngrok.log"; exit 1; }
fi

echo
echo "  App:  $BASE"
echo
sh qr.sh "$BASE" "local-"
echo
echo "  Mở App trên điện thoại (ngrok free hiện trang cảnh báo -> bấm Visit Site,"
echo "  chỉ 1 lần), rồi dùng tab Quét QR chĩa vào ảnh QR trên màn hình Mac."
echo "  Ctrl-C để dừng."
echo

wait $SRV
