# Указываем базовый образ
FROM debian:11

# Обновляем пакеты и устанавливаем nginx
RUN apt-get update && apt-get install -y nginx

# Создаем папку для файлов веб-сервера
RUN mkdir -p /opt/www

# Добавляем простой HTML-файл
RUN echo '<h1>Hello from Debian Nginx</h1>' > /opt/www/index.html

# Настраиваем конфигурацию nginx
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    location / { \
        root /opt/www; \
        index index.html; \
    } \
}' > /etc/nginx/sites-available/default

# Открываем порт 80 для доступа к nginx
EXPOSE 80

# Запускаем nginx через entrypoint
ENTRYPOINT ["nginx", "-g", "daemon off;"]
