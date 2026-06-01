# Frontend – DHBW Food App

Das Frontend ist eine Single Page Application (SPA) aus reinem HTML, CSS und JavaScript – ohne Frameworks oder Build-Tools. Es wird über einen nginx-Container ausgeliefert.

---

## Struktur

```
frontend/
├── index.html            # Einzige HTML-Datei, alle drei Seiten darin
├── nginx.conf            # nginx-Konfiguration
├── Containerfile         # Podman-Container-Definition
├── entrypoint.sh         # Setzt API-URL zur Laufzeit
├── css/
│   ├── style.css         # Layout, Variablen, Header, Navigation, Footer
│   └── components.css    # Karten, Modal, Sterne, Ranking, Charts, Formulare
└── js/
    ├── env.js            # API-URL (wird vom entrypoint.sh überschrieben)
    ├── utils.js          # escHtml() – XSS-Schutz, muss zuerst geladen werden
    ├── api.js            # Alle fetch()-Aufrufe gegen das Backend
    ├── bewertung.js      # Seite 1: Gerichtekarten + Bewertungs-Modal
    ├── ranking.js        # Seite 2: Rankings, Statistiken, Balkendiagramm
    ├── vorschlaege.js    # Seite 3: Vorschläge einreichen und anzeigen
    └── app.js            # Navigation und Hash-Routing
```

---

## Seiten

### Bewertung (`#bewertung`)
- Lädt alle heutigen Gerichte als Karten vom Backend
- Klick auf eine Karte öffnet ein Modal mit drei Stern-Dimensionen: Gesamteindruck, Geschmack, Portionsgröße
- Optionales Kommentarfeld
- Nach dem Absenden wird die Kartenansicht aktualisiert

### Rankings (`#ranking`)
- Drei Filter: **Top** (höchste Bewertung), **Trending** (meiste Bewertungen in 7 Tagen), **Verbesserungsbedarf** (niedrigste Bewertung)
- Statistik-Kacheln: Gesamtbewertungen, Durchschnitt, bewertete Gerichte, eingereichte Vorschläge
- Balkendiagramm der Bewertungsverteilung (1–5 Sterne), rein per CSS animiert

### Vorschläge (`#vorschlaege`)
- Formular mit clientseitiger Validierung (Name, Kategorie Pflichtfelder)
- Liste aller eingereichten Vorschläge mit farbigen Kategorie-Tags

---

## Design-System

Alle Farben, Abstände und Radien sind als CSS Custom Properties in `style.css` definiert:

| Variable              | Wert      | Verwendung              |
|-----------------------|-----------|-------------------------|
| `--color-primary`     | `#E2001A` | DHBW-Rot, Buttons, Akzente |
| `--color-bg`          | `#f8f9fa` | Seitenhintergrund       |
| `--color-surface`     | `#ffffff` | Karten, Modal           |
| `--color-text-muted`  | `#64748b` | Labels, Metainfo        |
| `--color-star-active` | `#f59e0b` | Aktive Sterne           |

---

## JavaScript-Architektur

Jede Seite ist ein IIFE-Modul (Immediately Invoked Function Expression), das seinen State kapselt und eine öffentliche Schnittstelle via `window.*Module` bereitstellt:

```js
window.bewertungModule   = { load() }
window.rankingModule     = { load() }
window.vorschlaegeModule = { load() }
```

`app.js` koordiniert die Navigation und ruft das jeweilige Modul beim ersten Seitenwechsel auf. Die Rankings werden bei jedem Besuch neu geladen (da sich Bewertungen ändern), die anderen Seiten nur einmal.

**Ladereihenfolge (wichtig!):**
```
env.js → utils.js → api.js → bewertung.js → ranking.js → vorschlaege.js → app.js
```

---

## API-URL konfigurieren

In der lokalen Entwicklung zeigt `env.js` auf `http://localhost:3000/api`.  
Im Container wird `entrypoint.sh` beim Start ausgeführt und schreibt die Umgebungsvariable `DHBW_API_URL` in `env.js`:

```sh
# entrypoint.sh
window.DHBW_API_URL = '${DHBW_API_URL}';
```

Die Variable wird in `podman-compose.yml` gesetzt:
```yaml
environment:
  DHBW_API_URL: "http://localhost:3000/api"
```

> **Wichtig:** Diese URL muss vom Browser des Nutzers aus erreichbar sein, nicht vom Container. Bei Remote-Deployments also die öffentliche Backend-URL eintragen.

---

## Lokal ohne Container testen

```bash
# Einfach index.html im Browser öffnen – kein Build-Schritt nötig.
# Das Frontend versucht dann http://localhost:3000/api zu erreichen.
open frontend/index.html
```
