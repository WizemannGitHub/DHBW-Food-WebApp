# DHBW Food App

Eine Webanwendung für Feedback zur DHBW-Mensa. Studierende können Gerichte bewerten, Rankings einsehen und neue Gerichte vorschlagen.

---

## Features

- **Gerichte bewerten** – Sterne für Gesamteindruck, Geschmack und Portionsgröße
- **Rankings & Statistiken** – Top, Trending (7 Tage) und Verbesserungsbedarf
- **Essensvorschläge** – Neue Gerichte vorschlagen und alle Vorschläge einsehen

---

## Technologie

| Schicht    | Technologie                        |
|------------|------------------------------------|
| Frontend   | HTML, CSS, JavaScript (kein Framework) |
| Backend    | Node.js + Express                  |
| Datenbank  | PostgreSQL 16                      |
| Container  | Podman + podman-compose            |

---

## Starten

```bash
# Voraussetzung: podman und podman-compose installiert
# macOS: brew install podman podman-compose

podman machine start
podman-compose up --build
```

| Dienst   | URL                        |
|----------|----------------------------|
| Frontend | http://localhost:8080       |
| Backend  | http://localhost:3000/api   |

### Stoppen

```bash
podman-compose down
```

### Datenbank zurücksetzen

```bash
podman-compose down -v
podman-compose up --build
```

---

## Projektstruktur

```
Code/
├── frontend/           # SPA – HTML, CSS, JS + nginx
│   └── README.md
├── backend/            # REST API – Node.js + Express
│   └── README.md
├── datenbank/          # PostgreSQL – Schema + Beispieldaten
│   └── README.md
├── podman-compose.yml  # Container-Orchestrierung
└── AI_LOG.md           # Entwicklungslog der KI
```

Detaillierte Dokumentation in den jeweiligen README-Dateien der Unterordner.
