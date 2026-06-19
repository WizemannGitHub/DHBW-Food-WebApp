#set document(title: "Ablaufplan – Gantt-Diagramm")
#set page(paper: "a4", flipped: true, margin: (x: 1.3cm, y: 1.3cm))
#set text(font: "Arial", size: 8pt)

// ═══ Farben (konsistent mit PSP & Protokoll) ══════════════════════════════════
#let c-pm     = rgb("#2e74b5")
#let c-ana    = rgb("#c00000")
#let c-des    = rgb("#375623")
#let c-imp    = rgb("#7030a0")
#let c-test   = rgb("#833c00")
#let c-header = rgb("#1a3a5c")
#let c-ms     = rgb("#c00000")
#let c-krit   = rgb("#c00000")   // kritischer Pfad: ROT (wie in Vorlesung Folie 25)
#let c-normal = rgb("#70ad47")   // nicht-kritisch: GRÜN (wie in Vorlesung Folie 25)

// ═══ Hilfsfunktionen ═════════════════════════════════════════════════════════

#let gantt-bar(crit: false) = rect(
  width: 100%,
  height: 12pt,
  fill: if crit { c-krit } else { c-normal },
  radius: 2pt,
)

// 13 KW-Zellen; w1 = KW 20 (12.05.) … w13 = KW 32 (03.08.)
#let task-cells(sw, ew, crit: false) = range(1, 14).map(w => {
  if w >= sw and w <= ew { gantt-bar(crit: crit) } else { [] }
})

// Phasen-Trennzeile (16 Spalten: 4 Fix + 12 KW)
#let ph-header(name, color) = table.cell(
  colspan: 17,
  fill: color.lighten(62%),
  text(weight: "bold", fill: color.darken(25%))[#name],
)

// ═══ Seitenkopf ═══════════════════════════════════════════════════════════════
#align(center)[
  #text(size: 15pt, weight: "bold")[Ablaufplan mit kritischem Pfad]
  #v(0.05cm)
  #text(size: 10pt)[DHBW Food Web App · Gantt-Diagramm · KW 20–32 (12.05.–03.08.2026)]
  #v(0.15cm)
  #line(length: 100%)
]

#v(0.15cm)

// ═══ Legende ═════════════════════════════════════════════════════════════════
#grid(
  columns: (auto, 0.2cm, auto, 1.8cm, auto, 0.2cm, auto),
  align: horizon,
  rect(width: 0.9cm, height: 0.3cm, fill: c-krit,   radius: 2pt), [],
  text[*Vorgang auf dem kritischen Pfad*],
  [],
  rect(width: 0.9cm, height: 0.3cm, fill: c-normal, radius: 2pt), [],
  text[Vorgang nicht auf kritischem Pfad],
)

#v(0.2cm)

// ═══ Gantt-Tabelle ════════════════════════════════════════════════════════════
// Spalten: ID(0.55) + Name(3.8) + Dauer(0.9) + Vorg.(1.2) + 12×KW(1.7) = 26.85 cm
#table(
  columns: (0.55cm, 3.2cm, 2.0cm, 1.1cm,
            1fr, 1fr, 1fr, 1fr, 1fr, 1fr,
            1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  rows: auto,
  stroke: 0.4pt + rgb("#bbbbbb"),
  inset: (x: 3pt, y: 3pt),
  align: (col, row) => if col <= 1 { left + horizon } else { center + horizon },

  // ─── Spaltenköpfe ──────────────────────────────────────────────────────────
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[ID]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[Vorgang / Arbeitspaket]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[Zeitraum]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[Vorg.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 20 \ 12.05.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 21 \ 18.05.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 22 \ 25.05.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 23 \ 01.06.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 24 \ 08.06.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 25 \ 15.06.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 26 \ 22.06.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 27 \ 29.06.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 28 \ 06.07.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 29 \ 13.07.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 30 \ 20.07.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 31 \ 27.07.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7pt)[KW 32 \ 03.08.]),

  // ─── 1 · Projektmanagement ─────────────────────────────────────────────────
  ph-header("1 · Projektmanagement", c-pm),
  [1.1], [Projektplanung],   [12.05.–16.05.], [–],    ..task-cells(1,  1),
  [1.2], [Projektsteuerung], [12.05.–03.08.], [1.1],  ..task-cells(1, 13),
  [1.3], [Projektabschluss], [27.07.–03.08.], [5.3],  ..task-cells(12, 13, crit: true),

  // ─── 2 · Anforderungsanalyse ───────────────────────────────────────────────
  ph-header("2 · Anforderungsanalyse", c-ana),
  [2.1], [Ist-Analyse],           [12.05.–20.05.], [1.1], ..task-cells(1, 2, crit: true),
  [2.2], [Anforderungen erheben], [18.05.–22.05.], [2.1], ..task-cells(2, 2, crit: true),
  [2.3], [Risikoanalyse],         [18.05.–24.05.], [2.1], ..task-cells(2, 2),

  // ─── 3 · Design ────────────────────────────────────────────────────────────
  ph-header("3 · Design", c-des),
  [3.1], [UI/UX Design],      [25.05.–05.06.], [2.2], ..task-cells(3, 4),
  [3.2], [Systemarchitektur], [25.05.–05.06.], [2.1], ..task-cells(3, 4, crit: true),

  // ─── 4 · Implementierung ───────────────────────────────────────────────────
  ph-header("4 · Implementierung", c-imp),
  [4.1], [Datenbank], [08.06.–14.06.], [3.2], ..task-cells(5, 5, crit: true),
  [4.2], [Frontend],  [15.06.–12.07.], [4.1], ..task-cells(6, 9, crit: true),
  [4.3], [Backend],   [15.06.–12.07.], [4.1],  ..task-cells(6, 9, crit: true),

  // ─── 5 · Testing & Deployment ──────────────────────────────────────────────
  ph-header("5 · Testing & Deployment", c-test),
  [5.1], [Testing & Fehlerbehebung], [13.07.–24.07.], [4.2 + 4.3],      ..task-cells(10, 11, crit: true),
  [5.2], [Deployment],            [20.07.–31.07.], [5.1],      ..task-cells(11, 12, crit: true),
  [5.3], [Abgabe & Präsentation], [20.07.–03.08.], [5.1],      ..task-cells(11, 13, crit: true),

  // ─── Meilensteine ──────────────────────────────────────────────────────────
  // w1:M0  w2:M1  w3:–  w4:M2  w5:–  w6:–  w7:M3  w8:–  w9:M4  w10:M5  w11:–  w12:M6  w13:M7
  table.cell(colspan: 4, fill: rgb("#f0f0f0"),
    text(weight: "bold", size: 7.5pt)[Meilensteine ◆]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M0 \ Start]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M1 \ Anford.]),
  [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M2 \ Design]),
  [], [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M3 \ PM-Abg.]),
  [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M4 \ Präsent.]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M5 \ Fkt.-fertig]),
  [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M6 \ Abnahme]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7pt)[◆ M7 \ Abgabe]),
)

#v(0.15cm)
#line(length: 100%)
#v(0.1cm)

// ─── Kritischer Pfad ─────────────────────────────────────────────────────────
#text(size: 7pt)[
  *Kritischer Pfad:*
  2.1 Ist-Analyse → 2.2 Anforderungen → 3.2 Systemarchitektur → 4.1 Datenbank  → 4.2 Frontend + 4.3 Backend → 5.1 Testing & Fehlerbehebung → 5.2 Deployment → 5.3 Abgabe & Präsentation + 1.3 Projektabschluss
]
