FROM python:3.11-slim
WORKDIR /app
COPY app/ /app/app/
RUN pip install gunicorn django==4.2.*
EXPOSE 8000
CMD ["gunicorn", "app.wsgi:application", "-b", "0.0.0.0:8000"]


