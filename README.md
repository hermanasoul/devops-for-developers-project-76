### Hexlet tests and linter status:
[![Actions Status](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/hermanasoul/devops-for-developers-project-76/actions)

[![Deploy](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/deploy.yml/badge.svg)](https://github.com/hermanasoul/devops-for-developers-project-76/actions/workflows/deploy.yml)

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

