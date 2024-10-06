# Используем официальный образ Python
FROM python:3.9-slim

# Устанавливаем необходимые зависимости для работы с PostgreSQL и виртуальным окружением
RUN apt-get update && apt-get install -y \
    libpq-dev gcc python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Создаем виртуальное окружение
RUN python3 -m venv /opt/venv

# Активируем виртуальное окружение и устанавливаем необходимые библиотеки
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install Flask psycopg2-binary ConfigParser

# Копируем код приложения
COPY /app/web.py /app/web.py
COPY /app/conf/web.conf /app/conf/web.conf

# Указываем рабочую директорию
WORKDIR /app

# Устанавливаем переменные окружения для работы приложения и активируем виртуальное окружение
ENV APP_CONFIG=/app/conf/web.conf
ENV PATH="/opt/venv/bin:$PATH"

# Запускаем приложение при старте контейнера
CMD ["python", "web.py"]
