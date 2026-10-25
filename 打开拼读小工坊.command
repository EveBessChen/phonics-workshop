#!/bin/bash
# 双击这个文件，用「本地网址」打开拼读小工坊。
# 好处：页面走 http:// 而不是 file://，任何浏览器（含 Safari）都能把错词本和学习报告存住，下次打开还在。
# 关闭：关掉这个终端窗口即可（网页可以先留着，但关掉窗口后下次要重新双击本文件）。

cd "$(dirname "$0")" || exit 1

PREFERRED=8765
URL=""

# 1) 已经有服务在跑就直接复用，不重复开端口
for p in 8765 8766 8767 8768 8769 8770; do
  if curl -s --max-time 0.5 "http://127.0.0.1:$p/index.html" 2>/dev/null | grep -q "拼读小工坊"; then
    URL="http://127.0.0.1:$p/index.html"
    break
  fi
done

# 2) 没有就起一个
if [ -z "$URL" ]; then
  PORT="$PREFERRED"
  for p in 8765 8766 8767 8768 8769 8770; do
    if ! curl -s -o /dev/null --max-time 0.4 "http://127.0.0.1:$p/" 2>/dev/null; then PORT="$p"; break; fi
  done
  nohup /usr/bin/python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
  sleep 1
  URL="http://127.0.0.1:$PORT/index.html"
fi

# 3) 有 Chrome 就用 Chrome（最稳），没有就用默认浏览器
if [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" "$URL"
else
  open "$URL"
fi

echo ""
echo "拼读小工坊已打开：$URL"
echo "这个窗口可以最小化。关掉它以后，下次再双击本文件即可，记录不会丢。"
