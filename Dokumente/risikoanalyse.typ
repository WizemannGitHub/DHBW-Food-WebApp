#set document(title: "Risikoanalyse")
#set page(flipped: true)
#set text(font: "Arial", size: 9pt)

#align(center)[
  #text(size: 18pt, weight: "bold")[Risikoanalyse]
]

#v(0.8cm)

#let header-color = rgb("#c0392b")
#let row-odd    = rgb("#f2c6c6")
#let row-even   = rgb("#fae8e8")

#table(
  columns: (2fr, 1.8fr, auto, auto, auto, 2.5fr, 1fr, auto),
  stroke: none,
  inset: (x: 6pt, y: 10pt),
  fill: (col, row) =>
    if row == 0 { header-color }
    else if calc.odd(row) { row-odd }
    else { row-even },

  // Header
  table.cell(text(fill: white, weight: "bold")[Risiko]),
  table.cell(text(fill: white, weight: "bold")[Ursache]),
  table.cell(text(fill: white, weight: "bold")[Eintritts-\ klasse]),
  table.cell(text(fill: white, weight: "bold")[Schadens-\ klasse]),
  table.cell(text(fill: white, weight: "bold")[Risiko-\ Index]),
  table.cell(text(fill: white, weight: "bold")[Mitigation /\ Gegenmaßnahme]),
  table.cell(text(fill: white, weight: "bold")[Kosten der\ Maßnahme]),
  table.cell(text(fill: white, weight: "bold")[Stakeholder]),

  // Zeile 1
  [
    Unerwartete Änderungen an der Mensa-API (Wechsel zu einem privaten Zugang oder Änderungen der Antwortstruktur)
  ],
  [
    Fehlende vertragliche Absicherung
  ],
  [10% (3)], [35 AS (5)], [15], [Abschluss eines Vertrags mit dem API-Anbieter zur Festlegung der Nutzungsbedingungen; Entwicklung eines Fallback-Mechanismus für strukturelle Änderungen (siehe Vertragvorschalg)], [AS], [Entwicklungsteam],

  // Zeile 2
  [
    Ausfall des Hosting-Anbieters
  ],
  [
    Technische Störungen, Wartungsarbeiten oder Insolvenz des Anbieters
  ],
  [1% (2)], [25 AS (4)], [8], [Wahl eines zuverlässigen Anbieters], [AS + ggf. Mehrkosten], [Entwicklungsteam],

  // Zeile 3
  [
    Beleidigende und unangebrachte Kommentare
  ],
  [
    Nutzerfrust über das Essensangebot der Mensa
  ], [25% (5)], [10 AS (3)], [15], [Überwachung von Kommentaren und Sperrung von Accounts; Implementierung einer Meldefunktion für unangemessene Inhalte], [AS], [Nutzer / Moderatoren],

  // Zeile 4
  [
    Unstimmigkeiten mit der DHBW Mensa
  ],
  [
    Rückgang der Besucherzahlen veranlasst die Mensaleitung zu Einwänden gegen die App
  ], [5% (3)], [8 AS (3)], [9], [Frühzeitige Absprache mit der Mensa über Ziele und Funktionsweise der App], [AS], [DHBW Mensa],
)

#v(0.4cm)
#text(size: 8pt)[*Legende:* AS = Arbeitsstunden]
