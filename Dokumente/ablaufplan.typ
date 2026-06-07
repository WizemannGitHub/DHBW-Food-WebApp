#set document(title: "Ablaufplan – Gantt-Diagramm")
#set page(paper: "a4", flipped: true, margin: (x: 1.5cm, y: 1.5cm))
#set text(font: "Arial", size: 8.5pt)

// ═══ Farben (konsistent mit PSP) ═══════════════════════════════════════════════
#let c-pm        = rgb("#2e74b5")
#let c-ana       = rgb("#c00000")
#let c-des       = rgb("#375623")
#let c-imp       = rgb("#7030a0")
#let c-test      = rgb("#833c00")
#let c-header    = rgb("#1a3a5c")
#let c-ms        = rgb("#c00000")
#let c-krit      = rgb("#c00000")   // kritischer Pfad: ROT (wie in Vorlesung Folie 25)
#let c-normal    = rgb("#70ad47")   // nicht-kritisch: GRÜN (wie in Vorlesung Folie 25)

// ═══ Hilfsfunktionen ══════════════════════════════════════════════════════════
// Einzelner Gantt-Balken; crit=true → rot, sonst phasenfarbe (grün für nicht-krit.)
#let gantt-bar(phase-color, crit: false) = rect(
  width: 100%,
  height: 13pt,
  fill: if crit { c-krit } else { c-normal },
  radius: 2pt,
)

// Gibt 9 Zellenwerte zurück (eine pro KW)
#let task-cells(phase-color, sw, ew, crit: false) = range(1, 10).map(w => {
  if w >= sw and w <= ew { gantt-bar(phase-color, crit: crit) } else { [] }
})

// Phasen-Trennzeile
#let ph-header(name, color) = table.cell(
  colspan: 13,
  fill: color.lighten(62%),
  text(weight: "bold", fill: color.darken(25%))[#name],
)

// ═══ Seitenkopf ════════════════════════════════════════════════════════════════
#align(center)[
  #text(size: 16pt, weight: "bold")[Ablaufplan mit kritischem Pfad]
  #v(0.05cm)
  #text(size: 11pt)[DHBW Food Web App · Gantt-Diagramm]
  #v(0.2cm)
  #line(length: 100%)
]

#v(0.2cm)

// ═══ Legende ══════════════════════════════════════════════════════════════════
#grid(
  columns: (auto, 0.2cm, auto, 1.5cm, auto, 0.2cm, auto),
  align: horizon,
  rect(width: 0.9cm, height: 0.3cm, fill: c-krit,   radius: 2pt), [],
  text[*Vorgang auf dem kritischen Pfad*],
  [],
  rect(width: 0.9cm, height: 0.3cm, fill: c-normal, radius: 2pt), [],
  text[Vorgang nicht auf kritischem Pfad],
)

#v(0.3cm)

// ═══ Gantt-Tabelle ════════════════════════════════════════════════════════════
// Spalten: ID(0.6) + Name(4.0) + Dauer(1.1) + Vorgänger(1.3) + 9×KW(1.95) = 0.6+4+1.1+1.3+17.55 = 24.55cm
#table(
  columns: (0.6cm, 4.0cm, 1.1cm, 1.5cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm, 1.95cm),
  rows: auto,
  stroke: 0.4pt + rgb("#bbbbbb"),
  inset: (x: 3pt, y: 4pt),
  align: (col, row) => if col <= 1 { left + horizon } else { center + horizon },

  // ─── Spaltenköpfe ─────────────────────────────────────────────────────────
  table.cell(fill: c-header, text(fill: white, weight: "bold")[ID]),
  table.cell(fill: c-header, text(fill: white, weight: "bold")[Vorgang / Arbeitspaket]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[Dauer]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[Vorg.]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 20 \ 13.05]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 21 \ 18.05]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 22 \ 25.05]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 23 \ 01.06]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 24 \ 08.06]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 25 \ 15.06]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 26 \ 22.06]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 27 \ 29.06]),
  table.cell(fill: c-header, text(fill: white, weight: "bold", size: 7.5pt)[KW 28 \ 06.07]),

  // ─── 1 · Projektmanagement ────────────────────────────────────────────────
  ph-header("1 · Projektmanagement", c-pm),
  [1.1], [Projektplanung],           [1 KW], [–],    ..task-cells(c-pm, 1, 1),
  [1.2], [Projektsteuerung],         [9 KW], [1.1],  ..task-cells(c-pm, 1, 9),
  [1.3], [Technische Dokumentation], [3 KW], [1.1],  ..task-cells(c-pm, 6, 8),
  [1.4], [Projektabschluss],         [2 KW], [5.4],  ..task-cells(c-pm, 8, 9),

  // ─── 2 · Anforderungsanalyse ──────────────────────────────────────────────
  ph-header("2 · Anforderungsanalyse", c-ana),
  [2.1], [Ist-Analyse],           [2 KW], [1.1],      ..task-cells(c-ana, 1, 2, crit: true),
  [2.2], [Anforderungen erheben], [1 KW], [2.1],      ..task-cells(c-ana, 2, 2, crit: true),
  [2.3], [Risikoanalyse],         [1 KW], [2.1],      ..task-cells(c-ana, 2, 3),

  // ─── 3 · Implementierung ──────────────────────────────────────────────────
  ph-header("3 · Implementierung", c-imp),
  [3.1], [Frontend],  [4 KW], [4.1, 4.2],             ..task-cells(c-imp, 3, 6, crit: true),
  [3.2], [Backend],   [4 KW], [4.2],                  ..task-cells(c-imp, 3, 6, crit: true),
  [3.3], [Datenbank], [3 KW], [4.2],                  ..task-cells(c-imp, 3, 5, crit: true),

  // ─── 4 · Design ───────────────────────────────────────────────────────────
  ph-header("4 · Design", c-des),
  [4.1], [UI/UX Design],      [3 KW], [2.2],          ..task-cells(c-des, 2, 4),
  [4.2], [Systemarchitektur], [2 KW], [2.2],          ..task-cells(c-des, 2, 3, crit: true),
  [4.3], [Integration],       [2 KW], [3.1, 3.2],     ..task-cells(c-des, 7, 8),

  // ─── 5 · Test & Deployment ────────────────────────────────────────────────
  ph-header("5 · Test & Deployment", c-test),
  [5.1], [Testplanung],          [2 KW], [3.1, 3.2], ..task-cells(c-test, 4, 5),
  [5.2], [Funktionstests],       [2 KW], [5.1],      ..task-cells(c-test, 5, 6, crit: true),
  [5.3], [Abnahmetest],          [1 KW], [5.2],      ..task-cells(c-test, 7, 7, crit: true),
  [5.4], [Deployment & Go-Live], [1 KW], [5.3],      ..task-cells(c-test, 8, 8, crit: true),

  // ─── Meilensteine ─────────────────────────────────────────────────────────
  table.cell(colspan: 4, fill: rgb("#f0f0f0"),
    text(weight: "bold", size: 8pt)[Meilensteine ◆]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M0 \ Start]),
  [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M1 \ Anford.]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M2 \ Design]),
  [], [],
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M3 \ Impl.]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M4 \ Abgabe \ 29.06]),
  table.cell(fill: rgb("#ffeaea"),
    text(fill: c-ms, weight: "bold", size: 7.5pt)[◆ M5 \ Präsent. \ 08.07]),
)

#v(0.2cm)
#line(length: 100%)
#v(0.12cm)

// ─── Kritischer Pfad (Erläuterung) + Footer ───────────────────────────────────
#grid(
  columns: (58%, 42%),
  [
    #text(size: 7.5pt)[
      *Kritischer Pfad (14 Vorgänge gesamt):*
      2.1 Ist-Analyse → 2.2 Anforderungen → 4.2 Systemarchitektur
      → 3.1 Frontend / 3.2 Backend / 3.3 Datenbank → 5.2 Funktionstests → 5.3 Abnahmetest → 5.4 Deployment
    ]
  ],
  align(right,
    text(size: 7.5pt)[
      *Projektleiter:* Erik Wizemann #h(0.4cm)
      *Auftraggeber:* Mikka Jenne #h(0.4cm)
      *Abgabe:* 29.06.2026 · *Präsentation:* 08.07.2026 #h(0.4cm)
      *Stand:* #datetime.today().display("[day].[month].[year]")
    ]
  ),
)
