#!/bin/bash

inputLog="/var/log/auth.log"
outputLog="/var/log/sudo_monitoring"
chat_id="-"   # ID чата в Telegram
bot_token=""  # Токен бота
exec >> "$outputLog" 2>&1

send_telegram() {
    local message="$1"
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"chat_id\":\"$chat_id\",\"text\":\"$message\",\"parse_mode\":\"Markdown\"}" \
        "https://api.telegram.org/bot$bot_token/sendMessage" >/dev/null
}

main() {
  tail -F "$inputLog" | grep --line-buffered -w "sudo" | while IFS= read -r line; do
      echo "[ALERT] $(date '+%Y-%m-%d %H:%M:%S'): $line"
      send_telegram "[ALERT] $(date '+%Y-%m-%d %H:%M:%S'): $line"
  done
}