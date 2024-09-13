# Указываем базовый образ
FROM alpine:latest

# Устанавливаем nginx
RUN apk add --no-cache nginx

# Создаем папку для файлов веб-сервера
RUN mkdir -p /opt/www

# Добавляем простой HTML-файл
RUN echo '<h1>Hello from Alpine Nginx</h1>' > /opt/www/index.html

# Создаем директорию для конфигурации nginx
RUN mkdir -p /etc/nginx/conf.d

# Настраиваем конфигурацию nginx
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    location / { \
        root /opt/www; \
        index index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Открываем порт 80 для доступа к nginx
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
