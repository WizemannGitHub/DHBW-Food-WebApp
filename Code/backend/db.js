/**
 * db.js – PostgreSQL-Verbindungspool
 * Konfiguration über Umgebungsvariablen (Docker-friendly)
 */

const { Pool } = require('pg');

const pool = new Pool({
  host:     process.env.PGHOST     || 'localhost',
  port:     parseInt(process.env.PGPORT || '5432'),
  database: process.env.PGDATABASE || 'dhbw_food',
  user:     process.env.PGUSER     || 'dhbw',
  password: process.env.PGPASSWORD || 'dhbw_secret',
});

pool.on('error', (err) => {
  console.error('[DB] Unerwarteter Pool-Fehler:', err.message);
});

module.exports = pool;
