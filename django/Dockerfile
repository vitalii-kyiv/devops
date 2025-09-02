FROM python:3.12-slim

# Системні пакети (бібліотеки для psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Встановлюємо залежності
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Код проєкту будемо монтувати volume'ом (див. docker-compose)
EXPOSE 8000

# Команда визначена в docker-compose (entrypoint.sh)
