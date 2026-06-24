#set document(title: "Arbeitspakete")
#set page(paper: "a4", margin: (x: 2cm, y: 1.5cm))
#set text(font: "Arial", size: 10pt)

// ── Farben ────────────────────────────────────────────────────────────────────
#let c-header      = rgb("#1a3a5c")
#let c-row-odd     = rgb("#f2f2f2")
#let c-pm          = rgb("#2e74b5")
#let c-ana         = rgb("#c00000")
#let c-design      = rgb("#375623")
#let c-impl        = rgb("#7030a0")
#let c-test        = rgb("#833c00")

// ── Projektdaten ──────────────────────────────────────────────────────────────
#let project = (
  name:   "DHBW Food Web App",
  nr:     "01101110",
  leader: "Erik Wizemann",
  client: "Mikka Jenne",
  kurs:   "TINF25B2",
)

// ── AP-Tabellen-Funktion ──────────────────────────────────────────────────────
// Erzeugt ein vollständiges Arbeitspaket-Formular als Tabelle.
#let ap(
  code:         "",
  name:         "",
  color:        c-header,
  verantwortl:  "",
  vertretung:   "",
  beschreibung: "",
  ergebnis:     "",
  vorgaenger:   "",
  nachfolger:   "",
  schnittstellen: "",
  ressourcen:   "",
  randbeding:   "",
  aufwand:      "",
  start:        "",
  ende:         "",
  kosten:       "",
  status:       "",
) = {
  block(
    breakable: false,
    width: 100%,
    {
      // ── AP-Header ──────────────────────────────────────────────────────────
      table(
        columns: (100%,),
        stroke: 0.6pt,
        inset: (x: 6pt, y: 5pt),
        fill: color,
        table.cell(
          text(fill: white, weight: "bold", size: 11pt)[
            #code #h(0.6cm) #name
          ]
        ),
      )

      // ── AP-Felder ──────────────────────────────────────────────────────────
      table(
        columns: (4.5cm, 1fr),
        stroke: 0.6pt,
        inset: (x: 6pt, y: 4pt),
        fill: (col, row) =>
          if col == 0 { color.lighten(82%) }
          else if calc.odd(row) { c-row-odd }
          else { white },

        [*Verantwortlich*],        [#verantwortl],
        [*Vertretung*],            [#vertretung],
        [*Beschreibung*],          [#beschreibung],
        [*Ergebnis / Lieferobjekte*], [#ergebnis],
        [*Vorgänger (Abhängigk.)*],[#vorgaenger],
        [*Nachfolger*],            [#nachfolger],
        [*Schnittstellen*],        [#schnittstellen],
        [*Spez. Ressourcenanford.*],[#ressourcen],
        [*Randbedingungen*],       [#randbeding],
        [*Aufwand (Personentage)*],[#aufwand],
        [*Starttermin*],           [#start],
        [*Endtermin*],             [#ende],
        [*Kosten*],                [#kosten],
        [*Status / Freigabe*],     [#status],
      )
    }
  )
}

// ══════════════════════════════════════════════════════════════════════════════
// SEITE: TITEL
// ══════════════════════════════════════════════════════════════════════════════

#align(center)[
  #text(size: 20pt, weight: "bold")[Arbeitspakete]
  #v(0.1cm)
  #text(size: 13pt)[#project.name]
  #v(0.3cm)
  #line(length: 100%)
]

#v(0.3cm)
#text(size: 9pt, fill: rgb("#555555"))[
  Dieses Dokument beschreibt 10 ausgewählte Arbeitspakete aus dem Projektstrukturplan der *#project.name* (Kurs #project.kurs). Jedes Arbeitspaket ist mit Verantwortlichen, Tätigkeiten, Lieferobjekten, Abhängigkeiten, Ressourcen sowie Terminen ausformuliert.
]
#v(0.5cm)

// ══════════════════════════════════════════════════════════════════════════════
// PHASE 1 – PROJEKTMANAGEMENT
// ══════════════════════════════════════════════════════════════════════════════

#block(breakable: false)[
#text(size: 13pt, weight: "bold", fill: c-pm)[Phase 1 – Projektmanagement]
#v(0.25cm)

// ── AP 1.1 Projektplanung ─────────────────────────────────────────────────────
#ap(
  code:           "1.1",
  name:           "Projektplanung",
  color:          c-pm,
  verantwortl:    "Erik Wizemann (Projektleiter)",
  vertretung:     "Robin van Nuis",
  beschreibung:   "Erstellung aller Planungsdokumente: Projektauftrag, Projektstrukturplan (PSP), Phasen- und Meilensteinplan, Ablaufplan sowie initiale Ressourcen- und Risikoplanung. Koordination der Aufgabenverteilung im Team.",
  ergebnis:       "Genehmigter Projektauftrag, fertiggestellter PSP, Meilensteinplan, Ablaufplan, dokumentierte Aufgabenverteilung",
  vorgaenger:     "Keiner (Start des Projekts, M0 = Kickoff 12.05.2026)",
  nachfolger:     "1.2 Projektsteuerung, 2.1 Ist-Analyse, 2.2 Anforderungen erheben",
  schnittstellen: "Alle Arbeitspakete (Planung ist Grundlage des gesamten Projekts)",
  ressourcen:     "1 Person (Projektleiter) mit Vollzugriff auf Projektmanagement-Tools; GitHub Repository, Typst",
  randbeding:     "Abgabefrist Projektmanagement-Dokumente: 29.06.2026 (M3); Vorgaben der DHBW Karlsruhe einhalten",
  aufwand:        "5 Personentage",
  start:          "12.05.2026",
  ende:           "29.06.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "In Bearbeitung; Teilfreigabe nach M3 (29.06.2026) durch Auftraggeber Mikka Jenne",
)
]

#v(0.5cm)

// ── AP 1.2 Projektsteuerung ───────────────────────────────────────────────────
#ap(
  code:           "1.2",
  name:           "Projektsteuerung",
  color:          c-pm,
  verantwortl:    "Erik Wizemann (Projektleiter)",
  vertretung:     "Jan Kugler",
  beschreibung:   "Kontinuierliche Überwachung des Projektfortschritts anhand des Ablaufplans und der Meilensteine. Durchführung regelmäßiger Teamabstimmungen, Statusberichte, Anpassung des Plans bei Abweichungen sowie Kommunikation mit dem Auftraggeber.",
  ergebnis:       "Wöchentliche Statusupdates, protokollierte Teambesprechungen, aktualisierter Projektplan bei Abweichungen",
  vorgaenger:     "1.1 Projektplanung (Basisplan muss vorhanden sein)",
  nachfolger:     "1.3 Projektabschluss",
  schnittstellen: "Alle Arbeitspakete (Fortschritt wird aus allen APs zusammengeführt); Auftraggeber Mikka Jenne",
  ressourcen:     "1 Person (Projektleiter); Zugang zu GitHub Issues/Projects für Tracking",
  randbeding:     "Laufend über gesamte Projektlaufzeit (12.05. – 03.08.2026); Eskalationspfad über Dr. Arno Mielke bei kritischen Problemen",
  aufwand:        "3 Personentage (verteilt über gesamte Laufzeit)",
  start:          "12.05.2026",
  ende:           "03.08.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Laufend; keine formale Einzelfreigabe – Ergebnisse fließen in Abschlussdokumentation ein",
)

#pagebreak()

// ══════════════════════════════════════════════════════════════════════════════
// PHASE 2 – ANFORDERUNGSANALYSE
// ══════════════════════════════════════════════════════════════════════════════

#block(breakable: false)[
#text(size: 13pt, weight: "bold", fill: c-ana)[Phase 2 – Anforderungsanalyse]
#v(0.25cm)

// ── AP 2.1 Ist-Analyse ────────────────────────────────────────────────────────
#ap(
  code:           "2.1",
  name:           "Ist-Analyse",
  color:          c-ana,
  verantwortl:    "Robin van Nuis",
  vertretung:     "Ben Szepan",
  beschreibung:   "Analyse des aktuellen Zustands der Mensa-Infrastruktur: Recherche zur bestehenden Mensa-API (GitHub, Karlsruhe), Prüfung der Datenverfügbarkeit (Speisepläne, Öffnungszeiten), Analyse vergleichbarer Bewertungsplattformen sowie Dokumentation von Lücken und Verbesserungspotenzialen.",
  ergebnis:       "Ist-Analyse-Dokument: Beschreibung der Ausgangslage, verfügbare API-Endpunkte, Bewertung bestehender Lösungen, identifizierte Defizite",
  vorgaenger:     "1.1 Projektplanung (Kickoff und Aufgabenverteilung abgeschlossen)",
  nachfolger:     "2.2 Anforderungen erheben (Ist-Analyse ist Grundlage für Anforderungen)",
  schnittstellen: "2.2 Anforderungen erheben, 3.2 Systemarchitektur (API-Erkenntnisse fließen ein)",
  ressourcen:     "1–2 Personen; Internetzugang, GitHub-Zugriff auf Mensa-API-Repository",
  randbeding:     "Mensa-API muss öffentlich zugänglich sein; Abschluss bis M1 (24.05.2026)",
  aufwand:        "3 Personentage",
  start:          "12.05.2026",
  ende:           "24.05.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Abgeschlossen (M1 erreicht am 24.05.2026)",
)
]

#v(0.5cm)

// ── AP 2.2 Anforderungen erheben ──────────────────────────────────────────────
#ap(
  code:           "2.2",
  name:           "Anforderungen erheben",
  color:          c-ana,
  verantwortl:    "Jan Kugler",
  vertretung:     "Cristian Zanfir",
  beschreibung:   "Erhebung und Dokumentation aller funktionalen und nicht-funktionalen Anforderungen: Interviews/Abstimmung mit Auftraggeber, Erstellung des Lastenhefts (FA-01 bis FA-10, NFA), Definition von In-Scope und Out-of-Scope, Entscheidung über den Technologiestack.",
  ergebnis:       "Vollständiges Lastenheft mit funktionalen Anforderungen (FA-01–FA-10), nicht-funktionalen Anforderungen, Abgrenzung (In/Out of Scope), abgestimmter Technologiestack (HTML/CSS/JS, Node.js, PostgreSQL, Docker)",
  vorgaenger:     "2.1 Ist-Analyse (Ausgangslage bekannt)",
  nachfolger:     "2.3 Risikoanalyse, 3.1 UI/UX Design, 3.2 Systemarchitektur",
  schnittstellen: "2.1 Ist-Analyse (Eingabe), 3.1 UI/UX Design, 3.2 Systemarchitektur (Anforderungen als Grundlage)",
  ressourcen:     "2 Personen; Typst für Dokumentation; Abstimmungstermin mit Auftraggeber Mikka Jenne",
  randbeding:     "Auftraggeber muss Lastenheft abnehmen; Abschluss bis M1 (24.05.2026); Kein React/Vue erlaubt (Vorgabe Auftraggeber)",
  aufwand:        "4 Personentage",
  start:          "14.05.2026",
  ende:           "24.05.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Abgeschlossen und abgenommen (M1 erreicht am 24.05.2026)",
)

#pagebreak()

// ── AP 2.3 Risikoanalyse ──────────────────────────────────────────────────────
#ap(
  code:           "2.3",
  name:           "Risikoanalyse",
  color:          c-ana,
  verantwortl:    "Cristian Zanfir",
  vertretung:     "Erik Wizemann",
  beschreibung:   "Identifikation, Bewertung und Dokumentation von Projektrisiken: technische Risiken (API-Verfügbarkeit, Technologieprobleme), organisatorische Risiken (Ausfall von Teammitgliedern, Terminverzug), Erstellung einer Risikomatrix (Eintrittswahrscheinlichkeit × Auswirkung) sowie Definition von Gegenmaßnahmen.",
  ergebnis:       "Risikoanalysedokument mit priorisierten Risiken, Risikomatrix, dokumentierten Gegenmaßnahmen und Verantwortlichkeiten",
  vorgaenger:     "2.2 Anforderungen erheben (Scope muss bekannt sein)",
  nachfolger:     "1.2 Projektsteuerung (Risiken fließen in laufendes Monitoring ein), 3.1 UI/UX Design",
  schnittstellen: "1.2 Projektsteuerung (Risikoverfolgung), 4.1–4.3 Implementierung (techn. Risiken)",
  ressourcen:     "1–2 Personen; Typst für Dokumentation",
  randbeding:     "Abschluss bis M1 (24.05.2026); Risiken müssen realistisch und projektspezifisch sein",
  aufwand:        "2 Personentage",
  start:          "14.05.2026",
  ende:           "24.05.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Abgeschlossen (M1 erreicht am 24.05.2026)",
)

#v(0.5cm)

// ══════════════════════════════════════════════════════════════════════════════
// PHASE 3 – DESIGNKONZEPT
// ══════════════════════════════════════════════════════════════════════════════

#block(breakable: false)[
#text(size: 13pt, weight: "bold", fill: c-design)[Phase 3 – Designkonzept]
#v(0.25cm)

// ── AP 3.1 UI/UX Design ───────────────────────────────────────────────────────
#ap(
  code:           "3.1",
  name:           "UI/UX Design",
  color:          c-design,
  verantwortl:    "Ben Szepan",
  vertretung:     "Robin van Nuis",
  beschreibung:   "Erstellung des visuellen Designkonzepts: Wireframes und Mockups aller Seiten (Tagesmenü, Bewertungsformular, Rankings, Statistiken, Vorschläge), Definition der Farbpalette, Typografie und Komponentenbibliothek, Sicherstellung der Responsivität (Desktop & Mobile).",
  ergebnis:       "Vollständige Wireframes/Mockups aller App-Seiten, Designdokumentation (Farben, Schriften, Abstände), abgenommenes Designkonzept",
  vorgaenger:     "2.2 Anforderungen erheben (FA-01–FA-10 als Grundlage)",
  nachfolger:     "4.2 Frontend (Mockups als Implementierungsvorlage)",
  schnittstellen: "4.2 Frontend (Design wird direkt umgesetzt); 3.2 Systemarchitektur (Datenfluss muss mit UI harmonieren)",
  ressourcen:     "1 Person; Design-Tool (z. B. Figma oder vergleichbar); kein Lizenzbudget verfügbar",
  randbeding:     "Kein React/Vue – Design muss mit Vanilla HTML/CSS/JS umsetzbar sein; Responsive Design Pflicht; Abschluss bis M2 (07.06.2026)",
  aufwand:        "5 Personentage",
  start:          "25.05.2026",
  ende:           "07.06.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Abgeschlossen und abgenommen (M2 erreicht am 07.06.2026)",
)
]

#pagebreak()

// ── AP 3.2 Systemarchitektur ──────────────────────────────────────────────────
#ap(
  code:           "3.2",
  name:           "Systemarchitektur",
  color:          c-design,
  verantwortl:    "Erik Wizemann",
  vertretung:     "Jan Kugler",
  beschreibung:   "Entwurf der technischen Gesamtarchitektur: Datenbankschema (PostgreSQL), API-Endpunkte des Backends (Node.js/Express), Komponentenstruktur des Frontends, Containerisierungskonzept (Docker/Podman Compose), CORS-Proxylösung für die Mensa-API sowie Sicherheitsmaßnahmen (XSS-Schutz).",
  ergebnis:       "Architekturdokument mit ER-Diagramm, API-Spezifikation (Endpunkte, Request/Response), Komponentendiagramm, Docker-Compose-Konzept",
  vorgaenger:     "2.1 Ist-Analyse (API-Kenntnisse), 2.2 Anforderungen erheben (technischer Scope)",
  nachfolger:     "4.1 Datenbank, 4.2 Frontend, 4.3 Backend (Architektur ist Implementierungsgrundlage)",
  schnittstellen: "4.1 Datenbank (Schema), 4.2 Frontend (API-Vertrag), 4.3 Backend (Endpunktdefinition), 3.1 UI/UX Design",
  ressourcen:     "1–2 Personen; Typst/Diagramm-Tool für Dokumentation",
  randbeding:     "Technologiestack festgelegt: Vanilla JS, Node.js, PostgreSQL, Docker; Abschluss bis M2 (07.06.2026)",
  aufwand:        "4 Personentage",
  start:          "25.05.2026",
  ende:           "07.06.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Abgeschlossen und abgenommen (M2 erreicht am 07.06.2026)",
)

#v(0.5cm)

// ══════════════════════════════════════════════════════════════════════════════
// PHASE 4 – IMPLEMENTIERUNG
// ══════════════════════════════════════════════════════════════════════════════

#block(breakable: false)[
#text(size: 13pt, weight: "bold", fill: c-impl)[Phase 4 – Implementierung]
#v(0.25cm)

// ── AP 4.2 Frontend ───────────────────────────────────────────────────────────
#ap(
  code:           "4.2",
  name:           "Frontend",
  color:          c-impl,
  verantwortl:    "Robin van Nuis",
  vertretung:     "Ben Szepan",
  beschreibung:   "Implementierung der vollständigen Web-Oberfläche in Vanilla HTML/CSS/JavaScript: Tagesmenü-Ansicht mit Wochentagsnavigation (FA-01, FA-07), Bewertungsformular (1–5 Sterne, Kommentar, FA-02, FA-03), Rankings-Seite (FA-04), Statistiken (FA-05), Speisevorschläge (FA-06), Kantinenfilter (FA-08), XSS-Schutz (HTML-Escaping).",
  ergebnis:       "Lauffähige, responsive Weboberfläche (Desktop & Mobile) mit allen geforderten Seiten und Funktionen; integriert mit Backend-API",
  vorgaenger:     "3.1 UI/UX Design (Mockups), 3.2 Systemarchitektur (API-Vertrag), 4.3 Backend (API muss bereitgestellt werden)",
  nachfolger:     "5.1 Testing & Fehlerbehebung",
  schnittstellen: "4.3 Backend (REST-API-Aufrufe), 4.1 Datenbank (indirekt über Backend)",
  ressourcen:     "1–2 Personen; VS Code oder vergleichbarer Editor; Browser für manuelle Tests; Node.js/npm für lokale Entwicklung",
  randbeding:     "Kein React/Vue/Framework erlaubt; alle modernen Browser müssen unterstützt werden; Responsivität Pflicht; XSS-Schutz durch HTML-Escaping erforderlich; Abschluss bis M5 (15.07.2026)",
  aufwand:        "12 Personentage",
  start:          "08.06.2026",
  ende:           "15.07.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "In Bearbeitung; Freigabe nach erfolgreichem Testing (5.1)",
)
]

#pagebreak()

// ── AP 4.3 Backend ────────────────────────────────────────────────────────────
#ap(
  code:           "4.3",
  name:           "Backend",
  color:          c-impl,
  verantwortl:    "Jan Kugler",
  vertretung:     "Cristian Zanfir",
  beschreibung:   "Implementierung des Node.js/Express-Backends: REST-API-Endpunkte für Speiseplan, Bewertungen, Rankings, Statistiken und Vorschläge; CORS-Proxy zur Mensa-API (FA-10); Datenbankanbindung (PostgreSQL); KI-gestützte Speisevorschläge mit Nährwertangaben (FA-06); Containerisierung mit Docker/Podman Compose.",
  ergebnis:       "Vollständig lauffähiges Backend mit dokumentierten REST-Endpunkten, Datenbankanbindung, Mensa-API-Proxy, Docker-Compose-Konfiguration",
  vorgaenger:     "3.2 Systemarchitektur (API-Spezifikation), 4.1 Datenbank (Schema muss bereitstehen)",
  nachfolger:     "4.2 Frontend (Backend liefert Daten), 5.1 Testing & Fehlerbehebung",
  schnittstellen: "4.1 Datenbank (Datenbankzugriff), 4.2 Frontend (API-Bereitstellung), externe Mensa-API (Karlsruhe)",
  ressourcen:     "1–2 Personen; Node.js, npm, PostgreSQL, Docker/Podman; Serverzugang für Hosting",
  randbeding:     "Keine Admin-Accounts oder Admin-Views (Out of Scope); keine Backend-Sicherheitsmaßnahmen über XSS hinaus (Out of Scope); Mensa-API muss erreichbar sein; Abschluss bis M5 (15.07.2026)",
  aufwand:        "10 Personentage",
  start:          "08.06.2026",
  ende:           "15.07.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "In Bearbeitung; Freigabe nach erfolgreichem Testing (5.1)",
)

#v(0.5cm)

// ══════════════════════════════════════════════════════════════════════════════
// PHASE 5 – TESTING & FEHLERBEHEBUNG
// ══════════════════════════════════════════════════════════════════════════════

#block(breakable: false)[
#text(size: 13pt, weight: "bold", fill: c-test)[Phase 5 – Testing & Fehlerbehebung]
#v(0.25cm)

// ── AP 5.1 Testing & Fehlerbehebung ───────────────────────────────────────────
#ap(
  code:           "5.1",
  name:           "Testing & Fehlerbehebung",
  color:          c-test,
  verantwortl:    "Cristian Zanfir",
  vertretung:     "Ben Szepan",
  beschreibung:   "Manuelles Testen aller Funktionen gemäß Lastenheft (FA-01–FA-10): Speiseplan-Anzeige, Bewertungsabgabe, Rankings, Statistiken, Speisevorschläge, Kantinenfilter, Browser-Kompatibilität (Desktop & Mobile). Dokumentation gefundener Fehler, Koordination der Fehlerbehebung mit Frontend- und Backend-Team.",
  ergebnis:       "Testprotokoll mit Testergebnissen je Anforderung, Liste behobener Fehler, freigegebene und voll funktionsfähige Webanwendung",
  vorgaenger:     "4.1 Datenbank, 4.2 Frontend, 4.3 Backend (alle Implementierungspakete abgeschlossen)",
  nachfolger:     "5.2 Deployment, 5.3 Abgabe & Präsentation",
  schnittstellen: "4.2 Frontend, 4.3 Backend (Fehler werden direkt zurückgespielt); Auftraggeber Mikka Jenne (Abnahme M6)",
  ressourcen:     "2 Personen; mehrere Endgeräte/Browser für Kompatibilitätstests; kein automatisiertes Test-Framework (manuelles Testing)",
  randbeding:     "Nur manuelles Testing (kein automatisiertes Testing laut Projektumfang); alle modernen Browser müssen getestet werden; Abschluss bis M6 (28.07.2026)",
  aufwand:        "5 Personentage",
  start:          "16.07.2026",
  ende:           "28.07.2026",
  kosten:         "Kein Sachbudget – Studienleistung",
  status:         "Ausstehend; Freigabe durch Auftraggeber bei Abnahme M6 (28.07.2026)",
)
]

// ── Footer ────────────────────────────────────────────────────────────────────
#v(1fr)
#line(length: 100%)
#v(0.15cm)
#grid(
  columns: (33%, 34%, 33%),
  align(left,   text(size: 8pt)[*Projektleiter:* #project.leader]),
  align(center, text(size: 8pt)[*Auftraggeber:* #project.client]),
  align(right,  text(size: 8pt)[*Kurs:* #project.kurs]),
)
