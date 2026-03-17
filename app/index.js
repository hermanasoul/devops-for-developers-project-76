const express = require('express');
const { Pool } = require('pg');
const os = require('os');

const app = express();
const port = process.env.PORT || 3000;

// Настройки подключения к БД берутся из переменных окружения
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Корневой маршрут: информация о сервере и статус БД
app.get('/', async (req, res) => {
  const hostname = os.hostname();
  try {
    // Проверяем подключение к БД
    const client = await pool.connect();
    const result = await client.query('SELECT NOW() as time');
    client.release();
    res.json({
      message: 'Hello from DevOps project!',
      hostname,
      database: 'connected',
      dbTime: result.rows[0].time,
    });
  } catch (err) {
    res.status(500).json({
      message: 'Hello from DevOps project!',
      hostname,
      database: 'disconnected',
      error: err.message,
    });
  }
});

// Маршрут для health check балансировщика
app.get('/health', (req, res) => {
  res.status(200).send('healthy');
});

// Запуск сервера
app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});