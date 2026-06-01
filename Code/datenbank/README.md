# Datenbank – DHBW Food App

PostgreSQL 16 als relationale Datenbank. Das Schema und die Beispieldaten werden beim ersten Container-Start automatisch aus `init.sql` eingespielt.

---

## Struktur

```
datenbank/
├── init.sql        # Schema-Definition + Beispieldaten
└── Containerfile   # Podman-Container-Definition (basiert auf postgres:16-alpine)
```

---

## Schema

### Tabelle `gerichte`

Speichert alle Gerichte, die in der App angezeigt und bewertet werden können.

| Spalte         | Typ                  | Beschreibung                                      |
|----------------|----------------------|---------------------------------------------------|
| `id`           | `SERIAL PRIMARY KEY` | Auto-incrementing ID                              |
| `name`         | `VARCHAR(200)`       | Name des Gerichts (Pflichtfeld)                   |
| `kategorie`    | `VARCHAR(50)`        | Kategorie (siehe erlaubte Werte unten)            |
| `beschreibung` | `TEXT`               | Kurze Beschreibung (optional)                     |
| `preis`        | `NUMERIC(6,2)`       | Preis in Euro (optional)                          |
| `verfuegbar_am`| `DATE`               | Datum der Verfügbarkeit; `NULL` = immer verfügbar |
| `aktiv`        | `BOOLEAN`            | Ob das Gericht angezeigt wird (Standard: `TRUE`)  |
| `erstellt_am`  | `TIMESTAMPTZ`        | Zeitstempel der Erstellung                        |

**Erlaubte Kategorien:** `fleisch`, `vegetarisch`, `vegan`, `pasta`, `salat`, `suppe`, `dessert`

---

### Tabelle `bewertungen`

Speichert alle abgegebenen Bewertungen. Eine Bewertung gehört immer zu einem Gericht.

| Spalte       | Typ                  | Beschreibung                                      |
|--------------|----------------------|---------------------------------------------------|
| `id`         | `SERIAL PRIMARY KEY` | Auto-incrementing ID                              |
| `gericht_id` | `INTEGER`            | Fremdschlüssel auf `gerichte.id` (CASCADE DELETE) |
| `gesamt`     | `SMALLINT`           | Gesamteindruck 1–5 (Pflichtfeld)                  |
| `geschmack`  | `SMALLINT`           | Geschmack 1–5 (optional)                          |
| `portion`    | `SMALLINT`           | Portionsgröße 1–5 (optional)                      |
| `kommentar`  | `TEXT`               | Freitext-Kommentar (optional)                     |
| `erstellt_am`| `TIMESTAMPTZ`        | Zeitstempel der Bewertung                         |

Wird ein Gericht gelöscht (`DELETE FROM gerichte`), werden alle zugehörigen Bewertungen automatisch mitgelöscht (`ON DELETE CASCADE`).

---

### Tabelle `vorschlaege`

Speichert alle von Studierenden eingereichten Essensvorschläge.

| Spalte        | Typ                  | Beschreibung                           |
|---------------|----------------------|----------------------------------------|
| `id`          | `SERIAL PRIMARY KEY` | Auto-incrementing ID                   |
| `name`        | `VARCHAR(200)`       | Name des vorgeschlagenen Gerichts      |
| `kategorie`   | `VARCHAR(50)`        | Kategorie (gleiche Werte wie Gerichte) |
| `beschreibung`| `TEXT`               | Beschreibung des Gerichts (optional)   |
| `begruendung` | `TEXT`               | Begründung des Vorschlags (optional)   |
| `erstellt_am` | `TIMESTAMPTZ`        | Zeitstempel der Einreichung            |

---

## Indizes

| Index                         | Tabelle      | Spalte(n)                  | Zweck                                     |
|-------------------------------|--------------|----------------------------|-------------------------------------------|
| `idx_bewertungen_gericht_id`  | bewertungen  | `gericht_id`               | Schnelle JOIN-Abfragen                    |
| `idx_bewertungen_erstellt_am` | bewertungen  | `erstellt_am`              | Trending-Filter (7-Tage-Fenster)          |
| `idx_gerichte_aktiv`          | gerichte     | `aktiv`, `verfuegbar_am`   | Filtern aktiver Tagesgerichte             |
| `idx_vorschlaege_erstellt_am` | vorschlaege  | `erstellt_am`              | Sortierung nach Einreichungsdatum         |

---

## Beispieldaten

`init.sql` legt beim ersten Start automatisch folgende Daten an:

- **8 Gerichte** für den aktuellen Tag (Spaghetti Bolognese, Gemüse-Curry, Schweinebraten, Caprese-Salat, Tomatensuppe, Käsespätzle, Hähnchenschnitzel, Obstsalat)
- **12 Bewertungen** verteilt auf alle Gerichte
- **4 Vorschläge** (Falafel, Linsensuppe, Shakshuka, Flammkuchen)

---

## Konfiguration

Die Verbindungsdaten werden als Umgebungsvariablen an den Container übergeben (via `podman-compose.yml`):

| Variable            | Wert         |
|---------------------|--------------|
| `POSTGRES_DB`       | `dhbw_food`  |
| `POSTGRES_USER`     | `dhbw`       |
| `POSTGRES_PASSWORD` | `dhbw_secret`|

---

## Datenpersistenz

Die Datenbankdaten werden in einem benannten Podman-Volume gespeichert:

```
dhbw_food_db_data → /var/lib/postgresql/data
```

Das Volume überlebt `podman-compose down`. Nur `podman-compose down -v` löscht es.

---

## Datenbank zurücksetzen

```bash
# Volume löschen und neu anlegen (init.sql wird erneut ausgeführt)
podman-compose down -v
podman-compose up --build
```

## Direkt verbinden (Debugging)

```bash
podman exec -it dhbw_food_db psql -U dhbw -d dhbw_food
```
