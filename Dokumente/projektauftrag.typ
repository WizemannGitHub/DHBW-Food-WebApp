#set document(title: "Projektauftrag")
#set page(margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "Arial", size: 11pt)

#align(center)[
  #text(size: 18pt, weight: "bold")[Projektauftrag]
  #v(0.3cm)
  #text(size: 13pt)[DHBW Food Web App]
  #v(0.5cm)
  #line(length: 100%)
]

#v(0.8cm)

// ─── Allgemeine Informationen ───────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[1. Allgemeine Informationen]
#v(0.3cm)

#table(
  columns: (40%, 60%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Feld*], [*Inhalt*],
  [Projektname], [DHBW Food Web App],
  [Projektnummer], [01101110],
  [Auftraggeber], [Mikka Jenne],
  [Projektleiter], [Erik Wizemann],
  [Projektteam], [Robin van Nuis, Jan Kugler, Cristian Zanfir, Ben Szepan],
  [Abteilung / Kurs], [TINF25B2],
  [Startdatum], [],
  [Enddatum (geplant)], [08.07.26],
  [Version], [1.0],
  [Stand], [#datetime.today().display("[day].[month].[year]")],
)

#v(0.8cm)

// ─── Ausgangssituation & Problemstellung ────────────────────────────────────
#text(weight: "bold", size: 12pt)[2. Ausgangssituation & Problemstellung]
#v(0.3cm)

#table(
  columns: (100%,),
  stroke: 0.5pt,
  [An der DHBW gibt es derzeit keine Möglichkeit, einen Überblick über die Meinungen der Studenten zum angebotenen Essen zu erhalten. Ein solcher Überblick würde die Essenswahl für Studenten erleichtern. Außerdem könnte dadurch verhindert werden, dass Studenten Geld für Essen ausgeben, das ihnen nicht schmeckt, was das allgemeine Wohlbefinden verbessert.

    Zudem bietet es der Kantine die Möglichkeit auf Vorschläge und Feedback der Studierenden einzugehen und es umzusetzen.],
)

#v(0.8cm)
#pagebreak()

// ─── Projektziele ────────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[3. Projektziele]
#v(0.3cm)

#table(
  columns: (10%, 70%, 20%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Ziel*], [*Priorität*],
  [1], [Entwicklung einer webbasierten App zur Bewertung von Speisen an der DHBW], [Hoch],
  [2], [Erweiterung der App um die Funktion "Feedback geben"], [Hoch],
  [3], [Erweiterung der App um die Funktion "Essen vorschlagen"], [Mittel],
  [4], [Erweiterung der App um die Funktion "Erfassung von Nährwerten"], [Gering],
)
#v(0.8cm)

// ─── Projektumfang (In-Scope / Out-of-Scope) ─────────────────────────────────
#text(weight: "bold", size: 12pt)[4. Projektumfang]
#v(0.3cm)

#table(
  columns: (50%, 50%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else { white },

  [*Im Projektumfang (In-Scope)*], [*Nicht im Projektumfang (Out-of-Scope)*],
  [
    *Kernfunktionen:*
    - Übersicht über alle Bewertungen mit Text und Score
    - Eigene Bewertungen schreiben
    - Einfaches Benutzerkonto anlegen

    *Technische Infrastruktur:*
    - Backend entwickeln
    - Webanwendung hosten
    - Datenbank hosten

    *Erweiterungsfunktionen:*
    - Vorschlagen von neuen Essensgerichten
    - Erfassung von Nährwerten
  ],
  [
    - Admin-Konto anlegen
    - Admin-Ansicht
    - Sicherheitsmaßnahmen bezüglich der Accounts
    - Sicherheitsmaßnahmen bezüglich des Backends
  ],
)

#v(0.8cm)

// ─── Meilensteine ────────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[5. Meilensteine]
#v(0.3cm)

#table(
  columns: (10%, 50%, 20%, 20%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Nr.*], [*Meilenstein*], [*Geplant*], [*Erreicht*],
  [M1], [Projektmanagement], [29.06.2026], [28.06.2026],
  [M2], [Anforderungsanalyse], [28.05.2026], [29.05.2026],
  [M3], [Design], [01.06.2026], [01.06.2026],
  [M4], [Implementierung], [03.08.2026], [],
  [M5], [Testing & Deployment], [03.08.2026], [],
)

#pagebreak()

// ─── Ressourcen & Budget ──────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[6. Ressourcen & Budget]
#v(0.3cm)

#table(
  columns: (30%, 40%, 30%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Ressource*], [*Beschreibung*], [*Aufwand / Kosten*],
  [Personalaufwand], [5 Personen als Entwickler und Projektmanager], [...],
  [Hardware], [5 Arbeitslaptops], [bereits vorhanden],
  [Software / Lizenzen], [Podman], [kostenloser Account],
  [Sonstiges], [], [],
)

#v(0.8cm)

// ─── Genehmigung ─────────────────────────────────────────────────────────────
#text(weight: "bold", size: 12pt)[7. Genehmigung]
#v(0.3cm)

#table(
  columns: (33%, 33%, 34%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else { white },

  [*Rolle*], [*Name*], [*Unterschrift & Datum*],
  [Auftraggeber], [Mika Jenne, Dr. Arno Mielke], [],
  [Projektleiter], [Erik Wizemann], [],
  [Betreuer / Dozent], [Mikka Jenne, Dr. Arno Mielke], [],
)
