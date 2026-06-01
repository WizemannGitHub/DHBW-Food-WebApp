# Backend – DHBW Food App

Das Backend ist eine REST API auf Basis von Node.js und Express. Es verbindet sich mit der PostgreSQL-Datenbank und stellt alle Endpunkte für das Frontend bereit.

---

## Struktur

```
backend/
├── server.js       # Express-Server mit allen API-Endpunkten
├── db.js           # PostgreSQL-Verbindungspool
├── package.json    # Abhängigkeiten
└── Containerfile   # Podman-Container-Definition
```

---

## Abhängigkeiten

| Paket     | Zweck                        |
|-----------|------------------------------|
| `express` | HTTP-Server und Routing      |
| `cors`    | Cross-Origin-Anfragen erlauben |
| `pg`      | PostgreSQL-Treiber (kein ORM) |

---

## API-Endpunkte

### `GET /health`
Health-Check für den Container-Orchestrator.

**Response:**
```json
{ "status": "ok" }
```

---

### `GET /api/dishes`
Gibt alle heute verfügbaren und aktiven Gerichte zurück, inklusive ihrer Durchschnittsbewertung.

Ein Gericht wird angezeigt, wenn `aktiv = TRUE` und `verfuegbar_am` entweder `NULL` (immer) oder das aktuelle Datum ist.

**Response:**
```json
[
  {
    "id": 1,
    "name": "Spaghetti Bolognese",
    "kategorie": "pasta",
    "beschreibung": "...",
    "preis": "3.80",
    "avg_rating": "4.3",
    "rating_count": 5
  }
]
```

---

### `POST /api/ratings`
Speichert eine neue Bewertung für ein Gericht.

**Body:**
```json
{
  "dish_id": 1,
  "gesamt": 4,
  "geschmack": 5,
  "portion": 3,
  "kommentar": "Sehr lecker!"
}
```

- `dish_id` und `gesamt` (1–5) sind Pflichtfelder
- `geschmack`, `portion`, `kommentar` sind optional

**Response:** `201 Created`
```json
{ "success": true, "id": 42 }
```

---

### `GET /api/rankings?filter=top|trend|flop`
Gibt eine sortierte Rangliste der Gerichte zurück (max. 20).

| Filter  | Sortierung |
|---------|------------|
| `top`   | Höchste Durchschnittsbewertung (mind. 1 Bewertung) |
| `flop`  | Niedrigste Durchschnittsbewertung (mind. 1 Bewertung) |
| `trend` | Meiste Bewertungen in den letzten 7 Tagen |

**Response:**
```json
[
  {
    "id": 6,
    "name": "Käsespätzle",
    "kategorie": "vegetarisch",
    "avg_rating": "5.0",
    "rating_count": 2
  }
]
```

---

### `GET /api/stats`
Aggregierte Statistiken über alle Bewertungen und Vorschläge.

**Response:**
```json
{
  "total_ratings": 12,
  "avg_score": "4.08",
  "rated_dishes": 8,
  "total_proposals": 4,
  "distribution": {
    "3": 1,
    "4": 7,
    "5": 4
  }
}
```

---

### `GET /api/proposals`
Gibt alle Essensvorschläge zurück, neueste zuerst.

**Response:**
```json
[
  {
    "id": 1,
    "name": "Falafel mit Hummus",
    "kategorie": "vegan",
    "beschreibung": "...",
    "begruendung": "...",
    "erstellt_am": "2026-05-21T14:00:00Z"
  }
]
```

---

### `POST /api/proposals`
Reicht einen neuen Essensvorschlag ein.

**Body:**
```json
{
  "name": "Falafel mit Hummus",
  "kategorie": "vegan",
  "beschreibung": "Knusprige Falafel mit cremigem Hummus",
  "begruendung": "Wäre eine tolle vegane Option!"
}
```

- `name` und `kategorie` sind Pflichtfelder
- Erlaubte Kategorien: `fleisch`, `vegetarisch`, `vegan`, `pasta`, `salat`, `suppe`, `dessert`

**Response:** `201 Created`
```json
{ "success": true, "id": 5 }
```

---

## Konfiguration (Umgebungsvariablen)

| Variable      | Standard         | Beschreibung                        |
|---------------|------------------|-------------------------------------|
| `PORT`        | `3000`           | Port des HTTP-Servers               |
| `PGHOST`      | `localhost`      | Hostname der Datenbank              |
| `PGPORT`      | `5432`           | Port der Datenbank                  |
| `PGDATABASE`  | `dhbw_food`      | Datenbankname                       |
| `PGUSER`      | `dhbw`           | Datenbanknutzer                     |
| `PGPASSWORD`  | `dhbw_secret`    | Datenbankpasswort                   |
| `CORS_ORIGIN` | `*`              | Erlaubte CORS-Origin (Frontend-URL) |

---

## Lokal starten (ohne Container)

```bash
cd backend
npm install
PGHOST=localhost PGUSER=dhbw PGPASSWORD=dhbw_secret node server.js
```
