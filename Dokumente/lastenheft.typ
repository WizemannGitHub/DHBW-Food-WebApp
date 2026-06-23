#set document(title: "Lastenheft")
#set page(margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "Arial", size: 11pt)

#align(center)[
  #text(size: 18pt, weight: "bold")[Lastenheft]
  #v(0.3cm)
  #text(size: 13pt)[DHBW Food Web App]
  #v(0.5cm)
  #line(length: 100%)
]

#v(0.8cm)

// ─── 1. Einleitung ───────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[1. Einleitung]
#v(0.3cm)

Die DHBW Food Web App ist eine webbasierte Anwendung, die im Rahmen der
Lehrveranstaltung "Webengineering und Projektmanagement" an der DHBW Karlsruhe
entwickelt wird. Der Handlungsbedarf ergibt sich daraus, dass Studierende bisher
keine strukturierte Möglichkeit haben, Meinungen zum Mensaessen zu teilen oder
Einblick in die Bewertungen anderer Studierender zu erhalten. Der Ist-Zustand ist das
Fehlen eines digitalen Feedbacksystems für die Mensa. Ziel ist es, durch eine moderne
Webanwendung mit Bewertungsfunktion, Rankings und Speisevorschlägen einen
Mehrwert für die Studierenden zu schaffen und gleichzeitig der Mensa
handlungsrelevantes Feedback bereitzustellen.

#v(0.8cm)

// ─── 2. Ziel ─────────────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[2. Ziel]
#v(0.3cm)

Bis zum 08.07.2026 soll eine funktionierende Webanwendung vorliegen.
Studierende sollen Mensagerichte bewerten und Feedback hinterlassen können.
Die App soll intuitiv, browserbasiert und optisch ansprechend gestaltet sein.
Die Anwendung soll Transparenz über die Qualität des Mensaessens schaffen und
Studierenden helfen, informierte Entscheidungen zu treffen.

#v(0.8cm)

// ─── 3. Zweck ────────────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[3. Zweck]
#v(0.3cm)

Die Anwendung dient der Verbesserung der Essenssituation an der DHBW Karlsruhe
durch strukturiertes Feedback und Bewertungen. Sie richtet sich an alle Studierenden
der DHBW Karlsruhe, die regelmäßig die Mensa besuchen oder besuchen möchten.

#v(0.8cm)

// ─── 4. Funktionale Anforderungen ────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[4. Funktionale Anforderungen]
#v(0.3cm)

#table(
  columns: (10%, 92%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Anforderung*],
  [FA-01], [Wenn ein Nutzer die Anwendung öffnet, dann soll das aktuelle Mensaangebot des heutigen Tages angezeigt werden.],
  [FA-02], [Wenn ein Nutzer ein Gericht auswählt, dann soll er eine Bewertung mit 1–5 Sternen für Gesamteindruck, Geschmack und Portionsgröße abgeben können.],
  [FA-03], [Wenn ein Nutzer eine Bewertung abgibt, dann kann er optional einen Kommentar hinterlassen.],
  [FA-04], [Wenn ein Nutzer die Rankings-Seite aufruft, dann sollen die Top-Gerichte, Flop-Gerichte sowie Trend-Gerichte der letzten 7 Tage angezeigt werden.],
  [FA-05], [Wenn ein Nutzer Statistiken abruft, dann sollen die Gesamtanzahl der Bewertungen, die Durchschnittsbewertung, die Anzahl der bewerteten Gerichte und die Anzahl der Vorschläge angezeigt werden.],
  [FA-06], [Wenn ein Nutzer einen Speisevorschlag einreicht, dann soll dieser mit Name, Kategorie und optionaler Begründung gespeichert werden.],
  [FA-07], [Wenn ein Nutzer zwischen Wochentagen navigiert, dann sollen Gerichte vergangener und zukünftiger Werktage (bis 5 Werktage voraus) einsehbar sein.],
  [FA-08], [Der Nutzer soll intuitiv einfach nach der Kantine filtern können.],
  [FA-09], [Gerichte vergangener Tage und des aktuellen Tages sind bewertbar; zukünftige Gerichte sind nur als Vorschau sichtbar.],
  [FA-10], [Die Mensa-API wird als Proxy über das Backend abgerufen, um CORS-Probleme zu vermeiden.],
)

#v(0.8cm)

// ─── 5. Nicht-funktionale Anforderungen ──────────────────────────────────────
#text(weight: "bold", size: 12pt)[5. Nicht-funktionale Anforderungen]
#v(0.3cm)

#table(
  columns: (10%, 92%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Anforderung*],
  [NF-01], [Plattformunabhängigkeit: Die Anwendung läuft in jedem modernen Webbrowser.],
  [NF-02], [Responsives UI für verschiedene Gerätegrößen (Desktop und Mobilgeräte).],
  [NF-03], [Schnelle Reaktionszeit und geringe Ladezeiten durch effizienten API-Proxy und containerisierte Architektur.],
  [NF-04], [Stabiler Code (HTML/CSS/JS, Node.js), wartbar über Git und Containerisierung mit Podman/Docker.],
  [NF-05], [XSS-Schutz durch konsequentes HTML-Escaping aller Nutzer- und API-Daten.],
  [NF-06], [Nur manuelle Tests; keine automatisierte Testabdeckung.],
)

#v(0.8cm)

// ─── 6. Schnittstellen ───────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[6. Schnittstellen]
#v(0.3cm)

#table(
  columns: (30%, 70%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Schnittstelle*],       [*Beschreibung*],
  [REST-API (Backend)],    [Node.js/Express — JSON-Schnittstelle für alle Frontend-Anfragen.],
  [Mensa-API (extern)],    [OpenMensa o. Ä. — Datenquelle für den aktuellen Speiseplan.],
  [PostgreSQL-Datenbank],  [Speicherung von Gerichten, Bewertungen und Vorschlägen.],
  [Docker/Podman-Netzwerk],[Containerisierte Kommunikation über internes Netzwerk (dhbw_net).],
)

#v(0.8cm)

// ─── 7. Test- und Abnahmekriterien ───────────────────────────────────────────
#text(weight: "bold", size: 12pt)[7. Test- und Abnahmekriterien]
#v(0.3cm)

#table(
  columns: (8%, 92%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Kriterium*],
  [T-01],  [Manuelles Testen mit realen Nutzerdaten und echten Mensadaten.],
  [T-02],  [Vollständigkeit der Funktionen gemäß den funktionalen Anforderungen (FA-01 bis FA-10).],
  [T-03],  [Korrekte Darstellung und Filterung des Mensaplans nach Kantinen und Datum.],
  [T-04],  [Bewertungen werden korrekt gespeichert und in Rankings sowie Statistiken wiedergegeben.],
  [T-05],  [Technische Dokumentation im Umfang von 2–4 Seiten liegt vor.],
  [T-06],  [Einhaltung aller Abgabetermine.],
)

#v(0.8cm)

// ─── 8. Dokumentation ────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[8. Dokumentation]
#v(0.3cm)

Technische Dokumentation mit Systemarchitektur, Datenbankmodell, API-Endpunkten
und Screenshots, wird am 03.08.26 bei Mikka Jenna abgegeben und ist nicht teil des Projektmanagement-Teils.

#v(0.8cm)

// ─── 9. Randbedingungen ──────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[9. Randbedingungen]
#v(0.3cm)

#table(
  columns: (10%, 92%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Randbedingung*],
  [RB-01], [Es gelten die Vorgaben der Hochschule zur Dokumentation und Abgabe.],
  [RB-02], [Keine Nutzung von Frontend-Frameworks wie React oder Vue; Vanilla HTML/CSS/JavaScript.],
  [RB-03], [Keine Adminansichten oder Accountverwaltung im Projektumfang.],
  [RB-04], [Keine Backend-Sicherheitsmaßnahmen (Authentifizierung) im Projektumfang.],
  [RB-05], [Betrieb als lokale Anwendung via Podman/Docker Compose; kein öffentliches Hosting.],
)