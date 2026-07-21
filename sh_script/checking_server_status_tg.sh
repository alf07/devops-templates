#!/bin/bash

domain="$1"
status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://$domain/")
chat_id="-"   # ID чата в Telegram
bot_token=""  # Токен бота

send_telegram() {
    local message="$1"
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"chat_id\":\"$chat_id\",\"text\":\"$message\",\"parse_mode\":\"Markdown\"}" \
        "https://api.telegram.org/bot$bot_token/sendMessage" >/dev/null
}

if [ "$status_code" != "200" ]; then
  message="*СРОЧНО! Сайт не доступен!*
  Домен: \`$domain\`
  Код ошибки: \`$status_code\`
  Требуется срочно выяснить причину и устранить!"

  send_telegram "$message"
fi
