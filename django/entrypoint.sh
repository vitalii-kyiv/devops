#!/usr/bin/env bash
set -e

# Чекаємо БД
echo "Waiting for PostgreSQL at ${POSTGRES_HOST}:${POSTGRES_PORT}..."
until nc -z "${POSTGRES_HOST}" "${POSTGRES_PORT}"; do
  sleep 0.5
done
echo "PostgreSQL is up."

# Якщо це перший запуск — створимо міграції/застосуємо
if [ ! -f "/app/.initialized" ]; then
  echo "Applying migrations..."
  python manage.py migrate --noinput || true
  touch /app/.initialized
fi

# Збираємо статичні (якщо потрібно)
python manage.py collectstatic --noinput || true

# --- Запуск сервера ---
# Варіант 1: gunicorn (рекомендовано з nginx)
exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3

# Варіант 2: dev-сервер Django
# exec python manage.py runserver 0.0.0.0:8000
