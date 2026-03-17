# Используем официальный образ Node.js
FROM node:18-alpine

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /usr/src/app

# Копируем файлы зависимостей
COPY app/package*.json ./

# Устанавливаем зависимости
RUN npm ci --only=production

# Копируем исходный код приложения
COPY app/index.js .

# Открываем порт, который слушает приложение
EXPOSE 3000

# Команда запуска
CMD ["node", "index.js"]