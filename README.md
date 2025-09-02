# Django + PostgreSQL + Nginx (Docker Compose)

Цей проєкт містить базову конфігурацію для запуску Django-застосунку з PostgreSQL та Nginx у Docker.

## Сервіси
- **web** — Django (Python 3.12, Gunicorn)
- **db** — PostgreSQL 16
- **nginx** — реверс-проксі

## Запуск

```bash
# Зібрати та запустити контейнери
docker compose up -d --build

# Виконати міграції
docker compose exec web python manage.py migrate

# Створити суперкористувача
docker compose exec web python manage.py createsuperuser
