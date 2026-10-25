#!/bin/bash
# 双击这个文件，会用「本地网址」打开拼读小工坊。
# 好处：所有页面共用同一个网站地址，错词本和学习报告一定能保存下来、下次还在。
# 关闭方法：关掉这个终端窗口即可（网页可以先留着）。

cd "$(dirname "$0")" || exit 1

find_free_port() {
  for p in 8765 8766 8767 8768 8769 8770; do
    if ! curl -s -o /dev/null --max-time 0.4 "http://127.0.0.1:$p/" 2>/dev/null; then
      echo "$p"
      return 0
    fi
  done
  echo "8765"
}

PORT="$(find_free_port)"
URL="http://127.0.0.1:$PORT/index.html"

if ! curl -s -o /dev/null --max-time 0.4 "http://127.0.0.1:$PORT/index.html" 2>/dev/null; then
  nohup /usr/bin/python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
  sleep 1
fi

open "$URL"

echo ""
echo "拼读小工坊已在本机打开：$URL"
echo "这个窗口可以最小化；关掉窗口后，下次再双击本文件即可。"
