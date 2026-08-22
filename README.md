<img width="3750" height="1969" alt="devops-templates" src="https://github.com/user-attachments/assets/bbba9363-6349-4fa5-9829-a77c9329628c" />


# DevOps Templates

Обобщённые и обезличенные примеры конфигураций CI/CD и скриптов автоматизации, которые я использовал в реальных коммерческих проектах.

> **⚠️ Важно:** Все данные (IP-адреса, домены, пути, имена пользователей, токены) заменены на шаблонные. Применяйте эти шаблоны как основу для своих проектов, подставляя свои значения. Никогда не загружайте реальные секреты в репозиторий.

---

## 📁 Содержание

- **`.github/workflows/`** — примеры GitHub Actions workflow:
    - [`ssh_matrix.yml`](github/ssh_matrix.yml) – деплой на сервер через `rsync` + выполнение команд по SSH (очистка кеша, перезапуск).
    - [`ftp.yml`](github/ftp.yml) – деплой на сервер по FTP + выполнение команд по SSH (сборка фронта, очистка кеша).
- **`scripts/`** — bash-скрипты для администрирования:
    - [`check_ssl.sh`](scripts/check_ssl.sh) – мониторинг срока действия SSL-сертификата с уведомлением в Telegram.
    - [`check_http.sh`](scripts/check_http.sh) – мониторинг HTTP-статуса сайта с уведомлением в Telegram.
    - [`sudo_monitor.sh`](https://github.com/alf07/devops-templates/blob/main/scripts/sudo_monitor.sh) – мониторинг использования `sudo` в реальном времени с уведомлением в Telegram.

---

## 🚀 Как использовать

### 1. CI/CD (GitHub Actions)

1. Скопируйте нужный workflow-файл в свой репозиторий (в папку `.github/workflows/`).
2. Замените все плейсхолдеры (домены, пути, имена пользователей) на свои реальные значения.
3. Настройте секреты в GitHub (`Settings → Secrets and variables → Actions`):
    - `SSH_KEY` — приватный ключ для доступа к серверу (для `ssh_matrix.yml`).
    - `FTP_SERVER`, `FTP_USERNAME`, `FTP_PASSWORD`, `SSH_PASSWORD` и другие — для `ftp.yml`.
4. Адаптируйте команды под свой стек (версия PHP, менеджер пакетов, фреймворк).

### 2. Скрипты мониторинга (Telegram-уведомления)

1. Скопируйте нужный скрипт из папки `scripts/` на сервер.
2. Создайте Telegram-бота (через [@BotFather](https://t.me/botfather)) и получите `bot_token`.
3. Получите свой `chat_id` (можно написать боту любое сообщение и вызвать `getUpdates`).
4. Вставьте `bot_token` и `chat_id` в переменные внутри скрипта (в начале файла).
5. Дайте скрипту права на выполнение: `chmod +x check_*.sh`
6. Запустите вручную для проверки:
   ```bash
   ./scripts/check_ssl.sh example.com 443
   ./scripts/check_http.sh example.com
   ./scripts/sudo_monitor.sh
