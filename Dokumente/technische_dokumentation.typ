#set document(title: "Technische Dokumentation – DHBW Food App")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  numbering: "1",
  header: [
    #set text(size: 9pt, fill: luma(130))
    #grid(columns: (1fr, 1fr),
      [DHBW Food App],
      align(right)[Technische Dokumentation]
    )
    #line(length: 100%, stroke: 0.5pt + luma(200))
  ]
)
#set text(font: "New Computer Modern", size: 11pt, lang: "de")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.2em)
  text(size: 14pt, weight: "bold", fill: rgb("#E2001A"), it)
  v(0.4em)
}
#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", it)
  v(0.2em)
}
#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", style: "italic", it)
  v(0.1em)
}

// ── Titelseite ─────────────────────────────────────────────────
#align(center)[
  #v(1cm)
  #text(size: 28pt, weight: "bold", fill: rgb("#E2001A"))[DHBW Food App]
  #v(0.3cm)
  #text(size: 18pt, weight: "bold")[Technische Dokumentation]
  #v(0.2cm)
  #text(size: 12pt)[Gruppe H]
  #v(0.1cm)
  #text(size: 12pt)[Jan Kugler, Cristian Zanfir, Ben Szephan, Robin van Nuis und Erik Wizemann]
  #v(0.4cm)
  #line(length: 60%, stroke: 1.5pt + rgb("#E2001A"))
  #v(0.4cm)
  #text(size: 11pt, fill: luma(80))[
    Projektmanagement · 2. Semester · DHBW Karlsruhe \
    #datetime.today().display("[day]. [month repr:long] [year]")
  ]
  #v(0.6cm)
]

#outline(title: "Inhaltsverzeichnis", indent: 1.5em)

#pagebreak()

// ── 1. Projektübersicht ────────────────────────────────────────
= Projektübersicht

Die *DHBW Food App* ist eine webbasierte Anwendung für Studierende der DHBW Karlsruhe. Sie ermöglicht das Einsehen des tagesaktuellen Mensaplans, das Bewerten von Gerichten sowie das Einreichen von Essensvorschlägen. Ziel ist es, Studierenden eine einfache Möglichkeit zu bieten, Feedback zur Mensa zu geben und so zur Qualitätsverbesserung beizutragen.

== Funktionsumfang

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + luma(200),
  fill: (_, row) => if row == 0 { rgb("#fff5f5") } else { white },
  [*Funktion*], [*Beschreibung*],
  [Tagesmenü], [Live-Abruf des aktuellen Mensaplans über eine externe API; Anzeige nach Kantine gefiltert],
  [Datums-Navigation], [Navigation zwischen Werktagen; vergangene Tage bewertbar, zukünftige Tage nur zur Vorschau],
  [Bewertung], [Sternbewertung (1–5) für Gesamteindruck, Geschmack und Portionsgröße inkl. optionalem Kommentar],
  [Rankings], [Anzeige der Top-, Flop- und Trend-Gerichte basierend auf gespeicherten Bewertungen],
  [Statistiken], [Gesamtanzahl Bewertungen, Durchschnittswert, Bewertungsverteilung als Balkendiagramm],
  [Vorschläge], [Formular zum Einreichen neuer Gerichtsideen; Übersicht aller bisherigen Vorschläge],
)

// ── 2. Systemarchitektur ───────────────────────────────────────
= Systemarchitektur

== Überblick

Die Anwendung folgt einer klassischen *3-Tier-Architektur* und wird vollständig in Containern betrieben.

#align(center)[
  #block(
    fill: luma(248),
    stroke: 0.5pt + luma(200),
    radius: 6pt,
    inset: 10pt,
    width: 62%
  )[
    #set text(size: 8.5pt, font: "Courier New")
    ```
┌───────────────────────────────┐
│        Browser (Client)       │
│  Plain HTML · CSS · JavaScript│
└──────────────┬────────────────┘
               │ HTTP :8080
┌──────────────▼────────────────┐
│   Frontend-Container (nginx)  │
│  Statische Dateien · Rev.Proxy│
└──────────────┬────────────────┘
               │ HTTP :3000
┌──────────────▼────────────────┐
│  Backend-Container (Node.js)  │
│  Express API · Mensa-Proxy    │
└───────┬─────────────────┬─────┘
        │ TCP :5432       │ HTTPS
┌───────▼───────┐  ┌──────▼─────┐
│ DB-Container  │  │ Mensa-API  │
│(PostgreSQL 16)│  │(fnka.de)   │
└───────────────┘  └────────────┘
    ```
  ]
]

== Container-Setup

Alle drei Container werden über eine einzige `docker-compose.yml` definiert und über ein internes Bridge-Netzwerk (`dhbw_food_network`) verbunden. Der Datenbankcontainer ist mit einem Health-Check ausgestattet; das Backend startet erst, wenn die Datenbank bereit ist (`depends_on: condition: service_healthy`).

#table(
  columns: (auto, auto, auto, 1fr),
  stroke: 0.5pt + luma(200),
  fill: (_, row) => if row == 0 { rgb("#fff5f5") } else { white },
  [*Container*], [*Image*], [*Port*], [*Aufgabe*],
  [`dhbw_food_frontend`], [`nginx:alpine`], [`8080:80`], [Ausliefern der statischen Dateien],
  [`dhbw_food_backend`], [`node:alpine`], [`3000:3000`], [REST-API & Mensa-Proxy],
  [`dhbw_food_db`], [`postgres:16-alpine`], [intern], [Datenpersistenz],
)

Der Datenbankinhalt wird in einem benannten Docker-Volume (`dhbw_food_db_data`) gespeichert und überlebt Container-Neustarts.

== CORS und Proxy

Die externe Mensa-API erlaubt keine direkten Browser-Anfragen (kein CORS-Header für `localhost`). Das Backend fungiert daher als *transparenter Proxy*: Der Endpunkt `GET /api/mensa-plan/:date` leitet die Anfrage serverseitig weiter und gibt das Ergebnis an den Browser zurück. Dadurch wird das CORS-Problem vollständig umgangen.

// ── 3. Backend ─────────────────────────────────────────────────
= Backend

== Technologie

Das Backend basiert auf *Node.js* mit dem *Express*-Framework. Die Datenbankanbindung erfolgt über den offiziellen `pg`-Treiber mit Connection Pooling (`pg.Pool`).

== REST-API-Endpunkte

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt + luma(200),
  fill: (_, row) => if row == 0 { rgb("#fff5f5") } else { white },
  [*Methode*], [*Endpunkt*], [*Beschreibung*],
  [`GET`],  [`/health`],                   [Health-Check; gibt `{ status: "ok" }` zurück],
  [`GET`],  [`/api/mensa-plan/:date`],     [Proxy zur externen Mensa-API für das angegebene Datum (Format: `YYYY-MM-DD`)],
  [`POST`], [`/api/mensa-dishes/sync`],    [Upsert von Mensa-Gerichten in die DB; gibt `{ name → id }`-Mapping zurück],
  [`GET`],  [`/api/dishes`],              [Alle heute verfügbaren Gerichte inkl. Durchschnittsbewertung],
  [`POST`], [`/api/ratings`],             [Neue Bewertung speichern (`dish_id`, `gesamt` sind Pflichtfelder)],
  [`GET`],  [`/api/rankings?filter=`],    [Top / Flop / Trend-Ranking (mind. 1 Bewertung erforderlich)],
  [`GET`],  [`/api/stats`],               [Gesamtstatistiken inkl. Bewertungsverteilung],
  [`GET`],  [`/api/proposals`],           [Alle eingereichten Vorschläge, absteigend nach Datum],
  [`POST`], [`/api/proposals`],           [Neuen Vorschlag einreichen (`name`, `kategorie` sind Pflichtfelder)],
)

== Datenbankschema

Die PostgreSQL-Datenbank besteht aus drei Tabellen:

- *`gerichte`* – Mensagerichte mit Name, Kategorie, Preis und Verfügbarkeitsdatum. Ein Unique-Index auf `(name, verfuegbar_am)` verhindert Duplikate beim täglichen Sync.
- *`bewertungen`* – Nutzerbewertungen mit Fremdschlüssel auf `gerichte`. Enthält Gesamt-, Geschmack- und Portionswertung (je 1–5) sowie einen optionalen Kommentar.
- *`vorschlaege`* – Frei einreichbare Gerichtsvorschläge mit Name, Kategorie und Begründung.

Das Schema wird beim ersten Start des Datenbankcontainers über `init.sql` automatisch angelegt (idempotent mit `IF NOT EXISTS`). Der Unique-Index auf `gerichte` wird zusätzlich beim Backend-Start idempotent migriert.

// ── 4. Frontend ────────────────────────────────────────────────
= Frontend

== Technologie und Aufbau

Das Frontend ist eine *Single-Page Application (SPA)* ohne JavaScript-Framework. Es basiert auf Plain HTML, CSS und JavaScript nach dem *IIFE-Modulpattern* (Immediately Invoked Function Expression). Jede Seite der App ist als eigenes Modul gekapselt, das seine öffentliche Schnittstelle über `window.*Module` exponiert.

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + luma(200),
  fill: (_, row) => if row == 0 { rgb("#fff5f5") } else { white },
  [*Datei*], [*Aufgabe*],
  [`env.js`],         [Laufzeitkonfiguration (Backend-URL); wird vor allen anderen Skripten geladen],
  [`utils.js`],       [Geteilte Hilfsfunktionen: `escHtml()` (XSS-Schutz), `KATEGORIE_EMOJI`-Mapping],
  [`api.js`],         [Alle HTTP-Aufrufe ans Backend (`mensaApi`, `api`); Mensa-Daten-Parsing und DB-Sync],
  [`bewertung.js`],   [Tagesmenü-Ansicht, Datums-Navigation, Kantinenfilter, Nutzungshinweis-Modal, Bewertungs-Modal],
  [`ranking.js`],     [Rankings-Ansicht, Statistik-Karten, Bewertungsverteilung als CSS-Balkendiagramm],
  [`vorschlaege.js`], [Vorschlagsformular mit clientseitiger Validierung, Vorschlags-Übersicht],
  [`app.js`],         [Seitennavigation (Hash-Routing), Lazy-Loading der Module],
)

== Seitenstruktur und Navigation

Die App besteht aus einer einzigen HTML-Datei (`index.html`) mit vier `<section>`-Bereichen sowie einer separaten `impressum.html`. Die Navigation erfolgt über Hash-Routing in `app.js`: Ein Klick auf einen Navigations-Button setzt den URL-Hash (z. B. `#bewertung`) und blendet die entsprechende Section ein, während alle anderen ausgeblendet werden.

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt + luma(200),
  fill: (_, row) => if row == 0 { rgb("#fff5f5") } else { white },
  [*Seite*], [*Section-ID*], [*Inhalt*],
  [Start],       [`#page-start`],       [Willkommensseite mit Feature-Karten und Kurzanleitung für jede Funktion],
  [Bewertung],   [`#page-bewertung`],   [Datums-Navigator, Kantinenfilter, Gerichtekarten, Bewertungs-Modal],
  [Rankings],    [`#page-ranking`],     [Top-/Trend-/Flop-Liste, Statistik-Karten, CSS-Balkendiagramm],
  [Vorschläge],  [`#page-vorschlaege`], [Einreich-Formular, Übersicht bisheriger Vorschläge],
  [Impressum],   [`impressum.html`],    [Separate Seite; im Footer verlinkt],
)

Jede Seite teilt denselben strukturellen Aufbau: ein *Header* mit Logo und Navigationsleiste, ein *Hero-Bereich* mit Seitentitel und Untertitel, der eigentliche *Seiteninhalt* (Cards, Listen, Formulare) sowie ein gemeinsamer *Footer* mit Jahreszahl und Impressum-Link.

== Design-System

Das UI folgt einem einheitlichen Design-System mit *DHBW-Rot (\#E2001A)* als Primärfarbe. Alle Abstände, Radien, Schatten und Farben sind als CSS Custom Properties in `:root` definiert. Komponenten-Styles sind in `components.css` ausgelagert, globale Basis-Styles in `style.css`.

== Datums-Navigation

Die Bewertungsseite enthält einen Werktags-Navigator (Vor/Zurück-Pfeile). Wochenenden werden beim Navigieren automatisch übersprungen. Gerichte vergangener Tage und des aktuellen Tages sind bewertbar. Für zukünftige Tage (bis 5 Werktage im Voraus) werden die Gerichte nur zur Vorschau angezeigt – der Bewerten-Button ist ausgeblendet und die Karten sind nicht klickbar.

== XSS-Schutz

Alle dynamisch eingefügten Nutzer- oder API-Daten werden über `escHtml()` escaped, bevor sie als HTML gerendert werden. Die Funktion nutzt die native DOM-API (`createTextNode`) und ist damit sicherer als reguläre Ausdrücke.

// ── 5. Lokale Entwicklung ──────────────────────────────────────
= Lokale Entwicklung

*Voraussetzungen:* Podman oder Docker mit Compose-Plugin; Ports 8080 und 3000 müssen frei sein.

```bash
cd DHBW-Food-WebApp/Code
podman-compose up --build   # oder: docker compose up --build
```

Die App ist anschließend unter `http://localhost:8080` erreichbar, das Backend unter `http://localhost:3000`. Für einen vollständigen Reset der Datenbank: `podman volume rm dhbw_food_db_data`. An Wochenenden ist die Mensa geschlossen – die App zeigt dann eine entsprechende Meldung.
