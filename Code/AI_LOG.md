# AI-Entwicklungslog – DHBW Food App

Dieses Dokument protokolliert alle Entscheidungen und Schritte, die ich (Claude / KI) beim Aufbau der DHBW Food WebApp getroffen habe.

---

## 2026-05-21 – Initiale Erstellung

### Aufgabe
Erstelle eine erste vollständige Webanwendung für die DHBW Food App mit:
- Bewertung aktueller Gerichte
- Gesamtrankings und Statistiken der Speisen
- Einreichung von Essensvorschlägen

Technologie-Einschränkung: **Nur plain JavaScript, HTML, CSS** – keine Frameworks.

---

### Entscheidungen & Begründungen

#### Projektstruktur
```
Code/
├── frontend/          # Statische Dateien (nginx)
│   ├── css/
│   │   ├── style.css       # Basis-Styles, Custom Properties, Layout
│   │   └── components.css  # Komponenten: Cards, Modal, Sterne, Charts
│   ├── js/
│   │   ├── env.js          # API-URL Konfiguration (docker-injectable)
│   │   ├── api.js          # Zentrales API-Modul (fetch-basiert)
│   │   ├── bewertung.js    # Seite 1: Gerichte & Bewertungslogik
│   │   ├── ranking.js      # Seite 2: Rankings & Statistiken
│   │   ├── vorschlaege.js  # Seite 3: Vorschläge einreichen & anzeigen
│   │   └── app.js          # Navigation & Seitenrouting
│   ├── index.html          # Single Page App
│   ├── nginx.conf          # nginx-Konfiguration
│   └── Dockerfile          # nginx:1.25-alpine
│
├── backend/           # Node.js REST API
│   ├── server.js           # Express-Server mit allen Endpunkten
│   ├── db.js               # PostgreSQL Pool (pg-Bibliothek)
│   ├── package.json
│   └── Dockerfile          # node:20-alpine
│
├── datenbank/         # PostgreSQL
│   ├── init.sql            # Schema + Beispieldaten
│   └── Dockerfile          # postgres:16-alpine
│
├── podman-compose.yml  # Orchestrierung aller drei Container
└── AI_LOG.md           # Dieses Dokument
```

#### Frontend-Entscheidungen
- **Single Page App mit Hash-Routing**: Kein Server-Side-Routing nötig, funktioniert auch ohne Backend rein lokal.
- **CSS Custom Properties**: Statt eines CSS-Frameworks (Bootstrap etc.) verwende ich CSS-Variablen für konsistentes Design-System (DHBW-Rot `#E2001A` als Primärfarbe).
- **Module-Pattern (IIFE)**: Jede JS-Datei kapselt ihre Logik in einer sofort aufgerufenen Funktion – verhindert globale Variablen-Konflikte ohne Bundler.
- **Stern-Bewertung**: Rein HTML/CSS/JS implementiert, keine externe Library.
- **CSS-Bar-Chart**: Verteilungsdiagramm ohne Canvas oder SVG-Framework, nur CSS-Balken mit animierten Breiten.
- **env.js**: API-URL ist über eine separate Datei konfigurierbar, damit der Docker-Container die URL zur Laufzeit injizieren kann.

#### Backend-Entscheidungen
- **Express.js**: Minimaler Overhead, kein Overkill für eine REST API dieser Größe.
- **pg (node-postgres)**: Direkter PostgreSQL-Treiber statt ORM – transparenter SQL, kein Abstraktions-Overhead.
- **CORS**: Konfigurierbar via Umgebungsvariable `CORS_ORIGIN` für sicheren Docker-Betrieb.
- **Keine Authentifizierung (MVP)**: Für die erste Version wird keine Nutzer-Authentifizierung implementiert. Kann in späteren Iterationen ergänzt werden.

#### Datenbank-Entscheidungen
- **PostgreSQL**: Robuste relationale Datenbank, gut geeignet für aggregierte Abfragen (Rankings, Statistiken).
- **SERIAL PKs**: Einfacher als UUIDs für diese Größe.
- **Referentielle Integrität**: `ON DELETE CASCADE` für Bewertungen → wird ein Gericht gelöscht, gehen auch seine Bewertungen weg.
- **CHECK-Constraints**: Kategorien und Sterne-Werte werden direkt in der DB validiert.
- **Beispieldaten**: 8 Gerichte + 12 Bewertungen + 4 Vorschläge für sofortige Demo-Bereitschaft.

#### Podman-Entscheidungen
- **3-Container-Architektur**: Frontend (nginx), Backend (Node.js), Datenbank (PostgreSQL) – klare Trennung, unabhängig skalierbar.
- **depends_on mit healthcheck**: Backend wartet auf gesunde DB, Frontend wartet auf Backend.
- **Named Volume**: `dhbw_food_db_data` – Daten überleben `docker compose down`.
- **Bridge-Netzwerk**: Alle Container im selben Netzwerk `dhbw_food_network`, können sich per Service-Namen ansprechen.

---

### API-Endpunkte (implementiert)

| Method | Endpoint         | Beschreibung                              |
|--------|------------------|-------------------------------------------|
| GET    | `/health`        | Health-Check für Docker                   |
| GET    | `/api/dishes`    | Heutige aktive Gerichte mit Bewertungen   |
| POST   | `/api/ratings`   | Neue Bewertung speichern                  |
| GET    | `/api/rankings`  | Rankings (filter: top/trend/flop)         |
| GET    | `/api/stats`     | Statistiken + Bewertungsverteilung        |
| GET    | `/api/proposals` | Alle Essensvorschläge                     |
| POST   | `/api/proposals` | Neuen Vorschlag einreichen                |

---

### Datenbank-Schema (Tabellen)

| Tabelle       | Felder                                                          |
|---------------|-----------------------------------------------------------------|
| `gerichte`    | id, name, kategorie, beschreibung, preis, verfuegbar_am, aktiv  |
| `bewertungen` | id, gericht_id, gesamt, geschmack, portion, kommentar           |
| `vorschlaege` | id, name, kategorie, beschreibung, begruendung, erstellt_am     |

---

### Offene Punkte / Nächste Schritte

- [ ] Nutzer-Authentifizierung (damit jeder nur einmal pro Gericht abstimmt)
- [ ] Admin-Interface für Gerichte-Verwaltung (Gerichte hinzufügen/deaktivieren)
- [ ] Wochentag-basierte Speisepläne (mehrtägige Planung)
- [ ] E-Mail-Benachrichtigungen bei neuen Vorschlägen
- [ ] Bildupload für Gerichte
- [ ] Kommentarmoderation
- [ ] Export-Funktion (CSV/PDF für Mensa-Betreiber)
- [ ] Unit-Tests für Backend-Endpunkte
- [ ] CI/CD-Pipeline

---

## 2026-05-21 – Review & Podman-Umstellung

### Gefundene und behobene Fehler

| # | Datei | Problem | Fix |
|---|-------|---------|-----|
| 1 | `js/bewertung.js` | `escHtml()` war am Ende der Datei global definiert – fehleranfällig, da andere Module implizit auf die Ladereihenfolge angewiesen waren | In `js/utils.js` ausgelagert, wird als erstes Script geladen |
| 2 | `js/ranking.js`, `js/vorschlaege.js` | `escHtml()` genutzt ohne eigene Definition – funktionierte nur zufällig durch Ladereihenfolge | Durch utils.js-Fix behoben |
| 3 | `datenbank/init.sql` (3×) | `ON CONFLICT DO NOTHING` ist bei `SERIAL`-PKs ohne Unique-Constraint ungültig → PostgreSQL-Fehler beim Init | Klauseln entfernt (init.sql läuft nur einmal) |
| 4 | `frontend/Dockerfile` | `COPY . /usr/share/nginx/html` kopierte auch Dockerfile & nginx.conf doppelt | Explizites COPY nach Verzeichnis: `css/`, `js/`, `index.html` |
| 5 | `frontend/js/env.js` | Hardcodierte URL, kein Mechanismus zur Laufzeitkonfiguration | `docker-entrypoint.sh` generiert env.js aus `DHBW_API_URL`-Env-Variable |
| 6 | `backend/Dockerfile` | `USER node` kann in rootless Podman Berechtigungsprobleme bei npm verursachen | Entfernt – rootless Podman braucht das nicht |
| 7 | `datenbank/Dockerfile` | `HEALTHCHECK` nutzte `${POSTGRES_USER}` – Env-Expansion in Podman nicht garantiert | Auf explizite Werte `-U dhbw -d dhbw_food` geändert |
| 8 | `docker-compose.yml` | `version:` Feld ist veraltet (Compose Spec) | Entfernt in neuem `podman-compose.yml` |

### Neue Dateien
- `frontend/js/utils.js` – globale Hilfsfunktionen (escHtml)
- `frontend/docker-entrypoint.sh` – generiert env.js zur Laufzeit
- `podman-compose.yml` – ersetzt docker-compose.yml

### Podman-Entscheidungen
- **podman-compose statt docker-compose**: Gleiche YAML-Syntax, aber kein Docker-Daemon nötig; rootless-by-default.
- **Kein `version:` Feld**: Modernes Compose-Spec-Format.
- **Kein `USER node`** im Backend: Rootless Podman mappt den Container-Root automatisch auf den Host-Nutzer via User-Namespace – explizites `USER` ist unnötig und kann Probleme bei Volume-Mounts verursachen.
- **Explizite Healthcheck-Werte** in DB-Dockerfile: Env-Variable-Expansion in Podman-HEALTHCHECK ist nicht zuverlässig.

---

### Projektstruktur (aktuell)
```
Code/
├── frontend/
│   ├── css/
│   │   ├── style.css
│   │   └── components.css
│   ├── js/
│   │   ├── env.js                 # Zur Laufzeit generiert vom Entrypoint
│   │   ├── utils.js               # escHtml() – muss zuerst geladen werden
│   │   ├── api.js
│   │   ├── bewertung.js
│   │   ├── ranking.js
│   │   ├── vorschlaege.js
│   │   └── app.js
│   ├── index.html
│   ├── nginx.conf
│   ├── docker-entrypoint.sh       # Generiert env.js aus DHBW_API_URL
│   └── Dockerfile
│
├── backend/
│   ├── server.js
│   ├── db.js
│   ├── package.json
│   └── Dockerfile
│
├── datenbank/
│   ├── init.sql
│   └── Dockerfile
│
├── podman-compose.yml             # Ersetzt docker-compose.yml
└── AI_LOG.md
```

---

### Wie starten (Podman)

```bash
# Im Verzeichnis Code/
podman-compose up --build

# Dann erreichbar unter:
# Frontend:  http://localhost:8080
# Backend:   http://localhost:3000/api
# Health:    http://localhost:3000/health

# Stoppen:
podman-compose down

# Datenbank zurücksetzen (Volume löschen):
podman-compose down -v
```
