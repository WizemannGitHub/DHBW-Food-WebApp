# DHBW-Food-WebApp
Abschlussprojekt Projektmanagement + WebEngineering – DHBW Karlsruhe, 2. Semester.

Eine Web-App mit der Studierende das Mensaessen bewerten, Rankings einsehen und neue Gerichte vorschlagen können.

---

## Features

- Tagesmenü wird live von der echten Mensa-API geladen (alle Karlsruher Kantinen)
- Kantinen einzeln oder kombiniert filtern
- Gerichte bewerten (Gesamt, Geschmack, Portion + Kommentar)
- Rankings: Top-Gerichte, Trending, Verbesserungsbedarf
- Essensvorschläge einreichen und einsehen

---

## Tech-Stack

| Bereich    | Technologie                                  |
|------------|----------------------------------------------|
| Frontend   | HTML, CSS, plain JavaScript (kein Framework) |
| Backend    | Node.js + Express                            |
| Datenbank  | PostgreSQL 16                                |
| Container  | Podman / Docker (3 Container)                |

---

## Projektstruktur

```
Code/
├── frontend/          # nginx-Container (statische Dateien)
│   ├── css/           # style.css + components.css
│   ├── js/            # env.js, utils.js, api.js, bewertung.js, ranking.js, vorschlaege.js, app.js
│   ├── index.html
│   ├── nginx.conf
│   └── Dockerfile
│
├── backend/           # Node.js REST API
│   ├── server.js      # Express + alle Endpunkte inkl. Mensa-Proxy
│   ├── db.js          # PostgreSQL-Pool
│   └── Dockerfile
│
├── datenbank/         # PostgreSQL
│   ├── init.sql       # Schema + Beispieldaten
│   └── Dockerfile
│
└── podman-compose.yml
```

---

## Starten

```bash
# Im Verzeichnis Code/
podman-compose up --build

# Frontend:  http://localhost:8080
# Backend:   http://localhost:3000/api
```

```bash
# Stoppen
podman-compose down

# Datenbank zurücksetzen
podman-compose down -v
```

> Alternativ funktioniert auch `docker compose up --build`.

---

## API-Endpunkte

| Method | Endpoint                  | Beschreibung                              |
|--------|---------------------------|-------------------------------------------|
| GET    | `/health`                 | Health-Check                              |
| GET    | `/api/dishes`             | Beispielgerichte aus der DB               |
| POST   | `/api/ratings`            | Neue Bewertung speichern                  |
| GET    | `/api/rankings`           | Rankings (top / trend / flop)             |
| GET    | `/api/stats`              | Gesamtstatistiken                         |
| GET    | `/api/proposals`          | Alle Vorschläge                           |
| POST   | `/api/proposals`          | Neuen Vorschlag einreichen                |
| GET    | `/api/mensa-plan/:date`   | Proxy zur Mensa-API (YYYY-MM-DD)          |

---

## Mensa-API Proxy

Die externe API `https://mensa-api.fnka.de/plans/:date` erlaubt kein CORS für `localhost`.
Der Backend-Endpunkt `/api/mensa-plan/:date` leitet den Request serverseitig weiter.

Rückgabe-Struktur der externen API:
```json
{
  "success": true,
  "data": [
    {
      "canteen": { "id": "adenauerring", "name": "Mensa am Adenauerring" },
      "lines": [
        {
          "name": "Linie 1",
          "meals": [
            { "name": "Spaghetti Bolognese", "price": "3,80 €", "classifiers": ["VEG"] }
          ]
        }
      ]
    }
  ]
}
```

Gerichte ohne `price` (z.B. "zu jedem Gericht reichen wir…") werden im Frontend gefiltert.

Classifier-Mapping:
- `VG` → vegan
- `VEG` → vegetarisch
- alles andere → fleisch
