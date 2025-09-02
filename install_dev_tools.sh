#!/bin/bash

# Скрипт автоматичної установки інструментів для розробки

# Функція перевірки команди
check_and_install() {
    if ! command -v $1 &> /dev/null; then
        echo "🔹 $1 не знайдено, встановлюю..."
        eval $2
    else
        echo "✅ $1 вже встановлено"
    fi
}

echo "=== Починаю встановлення інструментів ==="

# Оновлення системи
sudo apt update && sudo apt -y upgrade

# Docker
check_and_install docker "sudo apt install -y docker.io"

# Docker Compose
check_and_install docker-compose "sudo apt install -y docker-compose"

# Python 3.9+
check_and_install python3 "sudo apt install -y python3"
check_and_install pip3 "sudo apt install -y python3-pip"

# Django (через pip)
if ! pip3 show django &> /dev/null; then
    echo "🔹 Django не знайдено, встановлюю..."
    pip3 install django
else
    echo "✅ Django вже встановлено"
fi

echo "=== Установка завершена ==="
