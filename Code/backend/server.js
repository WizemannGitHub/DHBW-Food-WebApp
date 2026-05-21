'use strict';

const express = require('express');
const cors    = require('cors');
const pool    = require('./db');

const app  = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());

app.get('/health', (_req, res) => res.json({ status: 'ok' }));

app.get('/api/dishes', async (_req, res) => {
  try {
    const result = await pool.query(`
      SELECT g.id, g.name, g.kategorie, g.beschreibung, g.preis, g.verfuegbar_am,
        ROUND(AVG(b.gesamt)::numeric, 1) AS avg_rating,
        COUNT(b.id)::int                 AS rating_count
      FROM gerichte g
      LEFT JOIN bewertungen b ON b.gericht_id = g.id
      WHERE g.aktiv = TRUE
        AND (g.verfuegbar_am IS NULL OR g.verfuegbar_am = CURRENT_DATE)
      GROUP BY g.id
      ORDER BY g.name
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

app.post('/api/ratings', async (req, res) => {
  const { dish_id, gesamt, geschmack, portion, kommentar } = req.body;
  if (!dish_id || !gesamt)       return res.status(400).json({ error: 'dish_id und gesamt sind Pflichtfelder.' });
  if (gesamt < 1 || gesamt > 5) return res.status(400).json({ error: 'gesamt muss zwischen 1 und 5 liegen.' });
  try {
    const result = await pool.query(`
      INSERT INTO bewertungen (gericht_id, gesamt, geschmack, portion, kommentar)
      VALUES ($1, $2, $3, $4, $5) RETURNING id
    `, [dish_id, gesamt, geschmack || null, portion || null, kommentar || null]);
    res.status(201).json({ success: true, id: result.rows[0].id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

// filter: top = höchste Bewertung, flop = niedrigste, trend = meiste in 7 Tagen
app.get('/api/rankings', async (req, res) => {
  const filter = req.query.filter || 'top';
  let having, order;

  if (filter === 'top') {
    having = 'HAVING COUNT(b.id) >= 1';
    order  = 'ORDER BY avg_rating DESC, rating_count DESC';
  } else if (filter === 'flop') {
    having = 'HAVING COUNT(b.id) >= 1';
    order  = 'ORDER BY avg_rating ASC, rating_count DESC';
  } else if (filter === 'trend') {
    having = `HAVING COUNT(CASE WHEN b.erstellt_am >= NOW() - INTERVAL '7 days' THEN 1 END) >= 1`;
    order  = `ORDER BY COUNT(CASE WHEN b.erstellt_am >= NOW() - INTERVAL '7 days' THEN 1 END) DESC, avg_rating DESC`;
  } else {
    return res.status(400).json({ error: 'Ungültiger filter-Parameter.' });
  }

  try {
    const result = await pool.query(`
      SELECT g.id, g.name, g.kategorie,
        ROUND(AVG(b.gesamt)::numeric, 1) AS avg_rating,
        COUNT(b.id)::int                 AS rating_count
      FROM gerichte g
      LEFT JOIN bewertungen b ON b.gericht_id = g.id
      WHERE g.aktiv = TRUE
      GROUP BY g.id
      ${having}
      ${order}
      LIMIT 20
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

app.get('/api/stats', async (_req, res) => {
  try {
    const [statsRes, distRes, propRes] = await Promise.all([
      pool.query(`
        SELECT COUNT(b.id)::int AS total_ratings,
          ROUND(AVG(b.gesamt)::numeric, 2) AS avg_score,
          COUNT(DISTINCT b.gericht_id)::int AS rated_dishes
        FROM bewertungen b
      `),
      pool.query(`SELECT gesamt::text AS star, COUNT(*)::int AS count FROM bewertungen GROUP BY gesamt ORDER BY gesamt`),
      pool.query(`SELECT COUNT(*)::int AS total FROM vorschlaege`),
    ]);
    const distribution = {};
    distRes.rows.forEach(row => { distribution[row.star] = row.count; });
    res.json({ ...statsRes.rows[0], total_proposals: propRes.rows[0].total, distribution });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

app.get('/api/proposals', async (_req, res) => {
  try {
    const result = await pool.query(`
      SELECT id, name, kategorie, beschreibung, begruendung, erstellt_am
      FROM vorschlaege ORDER BY erstellt_am DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

const VALID_KATEGORIEN = ['fleisch','vegetarisch','vegan','pasta','salat','suppe','dessert'];

app.post('/api/proposals', async (req, res) => {
  const { name, kategorie, beschreibung, begruendung } = req.body;
  if (!name || !name.trim())                  return res.status(400).json({ error: 'name ist ein Pflichtfeld.' });
  if (!kategorie)                             return res.status(400).json({ error: 'kategorie ist ein Pflichtfeld.' });
  if (!VALID_KATEGORIEN.includes(kategorie))  return res.status(400).json({ error: 'Ungültige Kategorie.' });
  try {
    const result = await pool.query(`
      INSERT INTO vorschlaege (name, kategorie, beschreibung, begruendung)
      VALUES ($1, $2, $3, $4) RETURNING id
    `, [name.trim(), kategorie, beschreibung || null, begruendung || null]);
    res.status(201).json({ success: true, id: result.rows[0].id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Datenbankfehler.' });
  }
});

app.use((_req, res) => res.status(404).json({ error: 'Endpunkt nicht gefunden.' }));

app.listen(PORT, () => console.log(`[Backend] läuft auf Port ${PORT}`));
