#!/bin/bash

domain="$1"              
port="${2:-443}"
chat_id="-"   # ID чата в Telegram
bot_token=""  # Токен бота

send_telegram() {
    local message="$1"
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"chat_id\":\"$chat_id\",\"text\":\"$message\",\"parse_mode\":\"Markdown\"}" \
        "https://api.telegram.org/bot$bot_token/sendMessage" >/dev/null
}

check_ssl() {
    cert_info=$(echo | openssl s_client -servername "$domain" -connect "$domain:$port" 2>/dev/null | openssl x509 -noout -dates 2>/dev/null)

    if [ -z "$cert_info" ]; then
        send_telegram "*Ошибка проверки SSL*
Домен: \`$domain\`
Не удалось получить информацию о сертификате"
        return 1
    fi

    end_date=$(echo "$cert_info" | grep 'notAfter' | cut -d= -f2)
    end_timestamp=$(date -d "$end_date" +%s)
    current_timestamp=$(date +%s)
    days_left=$(( (end_timestamp - current_timestamp) / 86400 ))

    if [ "$days_left" -le 0 ]; then
        message="*СРОЧНО! SSL сертификат просрочен!*
Домен: \`$domain\`
Дата окончания: \`$end_date\`
Требуется срочный перевыпуск!"
    elif [ "$days_left" -le 7 ]; then
        message="*Внимание! SSL сертификат истекает*
Домен: \`$domain\`
Осталось дней: \`$days_left\`
Дата окончания: \`$end_date\`
Рекомендуется обновить сертификат"
    else
        return 0
    fi

    send_telegram "$message"
}

if [ $# -eq 0 ]; then
    echo "Использование: $0 <домен> [порт]"
    echo "Пример: $0 example.com 443"
    exit 1
fi

if ! nc -z -w 3 "$domain" "$port"; then
    send_telegram "*Ошибка подключения*
Домен: \`$domain\`
Порт: \`$port\` недоступен!"
    exit 1
fi

check_ssl "$1" "$2"
