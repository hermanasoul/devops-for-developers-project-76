### Hexlet tests and linter status:
[![Actions Status](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/hermanasoul/devops-for-developers-project-76/actions)

[![Deploy](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/deploy.yml/badge.svg)](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/deploy.yml)

Демо-приложение доступно по адресу: [http://mydevopsproject.ru/redmine](http://mydevopsproject.ru/redmine)

## Управление конфигурацией

Для автоматической настройки серверов используется Ansible. Перед запуском убедитесь, что у вас установлен Ansible и настроен SSH-доступ к серверам.

### Подготовка

1. Установите Ansible (если не установлен) и зависимости:
```bash
make install-deps
```
или вручную:
```bash
sudo apt update && sudo apt install -y ansible
ansible-galaxy install -r requirements.yml
ansible-galaxy collection install -r requirements.yml
```
Отредактируйте файл инвентаризации inventory.ini, указав актуальные IP-адреса ваших виртуальных машин и путь к SSH-ключу.

Запустите плейбук для настройки серверов:
```bash
make prepare
```
или:
```bash
ansible-playbook -i inventory.ini playbook.yml
```

## Деплой приложения

После настройки серверов (выполнения `make prepare`) можно развернуть приложение:
```bash
make deploy
```

Ручной запуск
```bash
ansible-playbook -i inventory.ini deploy.yml
```

Развёрнутое приложение Redmine доступно по адресу: [https://mydevopsproject.ru/redmine](https://mydevopsproject.ru/redmine)

## Управление секретами

Секретные данные (пароль БД Redmine) хранятся в зашифрованном файле `group_vars/webservers/vault.yml`. Для редактирования используйте команду:

```bash
make edit-vault
```

## Мониторинг

Для мониторинга используется Datadog. Агент установлен на всех серверах группы `webservers` и настроен на отправку метрик и HTTP-проверок для Redmine.

### Переменные

- `datadog_api_key` – зашифрован в `group_vars/webservers/vault.yml` (переменная `vault_datadog_api_key`).
- `datadog_site` – регион Datadog (по умолчанию `datadoghq.com`).
- `redmine_port` – порт, на котором доступен Redmine (8080).

### Установка и настройка

Для установки агента Datadog и настройки HTTP-проверки выполните:
```bash
make monitor
Эта команда:
```
Устанавливает зависимости Ansible.
Устанавливает коллекцию datadog.dd.
Запускает плейбук monitoring.yml, который:
Устанавливает Datadog Agent на всех серверах группы webservers.
Добавляет конфигурацию HTTP-проверки для Redmine (/etc/datadog-agent/conf.d/http_check.d/redmine.yaml).
Перезапускает агент.

### Проверка
После выполнения в интерфейсе Datadog (раздел Infrastructure) появятся ваши серверы. В разделе Monitors → HTTP Check можно увидеть статус проверки Redmine.

### Требования
Для работы проекта необходимы:
- Docker и Docker Compose (устанавливаются Ansible).
- Ansible версии 2.10 или выше.
- Python 3 и библиотека cryptography для работы с Ansible Vault.
- Доступ по SSH к виртуальным машинам с использованием ключа.
- Зарегистрированный домен и настроенная DNS-зона в Yandex Cloud.
- API-ключ Datadog (бесплатный аккаунт).

### Makefile команды
make install-deps – установка Ansible и зависимостей Galaxy.
make prepare – настройка серверов (Docker, Python, пользователь).
make deploy – деплой основного приложения.
make deploy-redmine – деплой Redmine.
make monitor – установка и настройка Datadog.
make edit-vault – редактирование зашифрованного файла секретов.

### Структура репозитория
```bash
├── .github/workflows/          # GitHub Actions (CI/CD)
├── app/                        # Исходный код основного приложения
├── group_vars/                 # Переменные Ansible
│   ├── all.yml                 # Общие переменные (несекретные)
│   └── webservers/             # Переменные для группы webservers
│       ├── vars.yml            # Открытые переменные
│       └── vault.yml           # Зашифрованные секреты (не коммитить!)
├── templates/                  # Шаблоны для .env файлов
├── inventory.ini               # Инвентаризация Ansible
├── playbook.yml                # Настройка серверов
├── deploy.yml                  # Деплой основного приложения
├── redmine-deploy.yml          # Деплой Redmine
├── monitoring.yml              # Установка Datadog
├── requirements.yml            # Зависимости Ansible Galaxy
├── Makefile                    # Утилиты для автоматизации
├── Dockerfile                  # Сборка образа приложения
└── README.md                   # Этот файл
```