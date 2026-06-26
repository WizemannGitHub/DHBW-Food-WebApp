#set document(title: "Phasen- und Meilensteinplan")
#set page(paper: "a4", flipped: true, margin: (x: 1.5cm, y: 1.5cm))
#set text(font: "Arial", size: 10pt)

// ── Farben ──────────────────────────────────────────────────────────────────
#let c-header      = rgb("#1a3a5c")
#let c-header-fill = rgb("#d9e1f2")
#let c-row-odd     = rgb("#f2f2f2")
#let arrow-color   = rgb("#2e74b5")
#let diamond-color = rgb("#c00000")

// ── Projektdaten ─────────────────────────────────────────────────────────────
#let project = (
  name:   "DHBW Food Web App",
  nr:     "01101110",
  leader: "Erik Wizemann",
  client: "Mikka Jenne",
  kurs:   "TINF25B2",
  start:  "12.05.2026",
  end:    "03.08.2026",
)

// ── Meilensteine ─────────────────────────────────────────────────────────────
#let milestones = (
  (nr: "M0", label: "Start",                      date: "12.05.2026", done: "12.05.2026", desc: "Kickoff-Meeting, Repository initialisiert, Rollen verteilt, Aufgabenteilung festgelegt"),
  (nr: "M1", label: "Anforderungs-\nanalyse",     date: "24.05.2026", done: "24.05.2026", desc: "Ist-Analyse abgeschlossen, Anforderungen erhoben, Risikoanalyse erstellt, Technologiestack entschieden"),
  (nr: "M2", label: "Fertiges\nDesignkonzept",    date: "07.06.2026", done: "07.06.2026", desc: "UI/UX-Design und Systemarchitektur fertiggestellt, fertiges Designkonzept abgenommen"),
  (nr: "M3", label: "Abgabe\nProjektmanagement",  date: "29.06.2026", done: "-",          desc: "Alle PM-Pflichtdokumente (Projektauftrag, PSP, Ablaufplan, Risikoanalyse, Meilensteinplan) fristgerecht abgegeben"),
  (nr: "M4", label: "Zwischen-\npräsentation",    date: "08.07.2026", done: "-",          desc: "Präsentation des Projektzwischenstands vor Auftraggeber und Betreuer"),
  (nr: "M5", label: "Funktions-\nfertige Webanw.", date: "15.07.2026", done: "-",          desc: "Frontend, Backend, Datenbank und Container vollständig implementiert und getestet"),
  (nr: "M6", label: "Abnahme\nMensaapp",          date: "28.07.2026", done: "-",          desc: "Funktionale und technische Abnahme der Webanwendung abgeschlossen"),
  (nr: "M7", label: "Tech.\nAbgabe",              date: "03.08.2026", done: "-",          desc: "Technische Dokumentation und finale Webanwendung abgegeben. Offizieller Projektabschluss"),
)

// ── Phasen mit zugehörigem Endmeilenstein ────────────────────────────────────
// Jede Phase endet mit dem Meilenstein am rechten Rand des Pfeils.
// Layout: [M(i)] --Phase-Pfeil--> [M(i+1)]
// phases(i) liegt zwischen milestones(i) und milestones(i+1)
#let phases = (
  (name: "Anforderungsanalyse",        w: 1, personal: "1,0 FTE"),
  (name: "Designkonzept",              w: 1, personal: "0,6 FTE"),
  (name: "Implementierung",            w: 3, personal: "2,0 FTE + 0,4 FTE"),
  (name: "Testing &\nFehlerbehebung",  w: 1, personal: "0,6 FTE"),
  (name: "Projektabschluss\n+ Review", w: 1, personal: "1,0 FTE"),
)

// ── Zweite Phasenreihe (frei verschiebbar) ───────────────────────────────────
// offset = Startposition in arrow-w-Einheiten (0.0 = ganz links, 1.5 = zwischen M1 und M2)
// span   = Breite des Pfeils in arrow-w-Einheiten (1.0 = eine Phase, 1.5 = anderthalb, usw.)
// Beispiel: (name: "PM-Abgabe", offset: 2.5, span: 1.5, personal: "Alle", budget: "entfällt")
#let phases2 = (
  (name: "Vorbereitung\nPräsentation", offset: 3, span: 1),
)

// ── Layout-Konstanten ────────────────────────────────────────────────────────
#let sc           = 1.15
#let diamond-size = 14pt  * sc
#let arrow-h      = 28pt  * sc
#let arrow-w      = 3.3cm * sc
#let ms-col-w     = 1.8cm * sc

// 8 Spalten: je eine pro Meilenstein; Pfeile füllen den Raum zwischen den Spalten-Grenzen
#let timeline-cols = (arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w)

// ── Hilfsfunktionen ──────────────────────────────────────────────────────────
#let diamond(size: 14pt, fill: diamond-color) = box(
  width: size, height: size,
  rotate(45deg,
    rect(width: size * 0.72, height: size * 0.72, fill: fill, stroke: none)
  )
)

#let arrow-shape(label: "", last: false, w: arrow-w) = {
  let tip = if last { 0pt } else { 10pt }
  box(
    width: w + tip,
    height: arrow-h,
    clip: false,
    {
      place(top + left,
        polygon(
          fill: arrow-color, stroke: none,
          (0pt,       0pt),
          (w,         0pt),
          (w + tip,   arrow-h / 2),
          (w,         arrow-h),
          (0pt,       arrow-h),
          (tip,       arrow-h / 2),
        )
      )
      place(
        horizon + center, dx: tip / 2,
        text(fill: white, weight: "bold", size: 8.5pt * sc)[#label]
      )
    }
  )
}

// ── Seite 1: Phasen- und Meilensteinplan ─────────────────────────────────────

// ── Titel ─────────────────────────────────────────────────────────────────────
#align(center)[
  #text(size: 20pt, weight: "bold")[Phasen- und Meilensteinplan]
  #v(0.1cm)
  #text(size: 13pt)[#project.name]
  #v(0.3cm)
  #line(length: 100%)
]

#v(0.4cm)

// ── Timeline ─────────────────────────────────────────────────────────────────
#let timeline-w = arrow-w * 8

#align(center, box(width: timeline-w)[

  // Meilenstein-Nummer (rot, fett)
  #grid(
    columns: timeline-cols, column-gutter: 0pt, align: (center,) * 8,
    ..milestones.map(m => text(weight: "bold", size: 8pt * sc, fill: diamond-color)[#m.nr])
  )
  #v(1pt)

  // Meilenstein-Label
  #grid(
    columns: timeline-cols, column-gutter: 0pt, align: (center,) * 8,
    ..milestones.map(m => text(size: 8pt * sc)[#m.label])
  )
  #v(3pt)

  // Diamanten
  #grid(
    columns: timeline-cols, column-gutter: 0pt, align: (center,) * 8,
    ..milestones.map(_ => diamond())
  )
  #v(2pt)

  // Datum
  #grid(
    columns: timeline-cols, column-gutter: 0pt, align: (center,) * 8,
    ..milestones.map(m => text(size: 7.5pt * sc, fill: rgb("#444444"))[#m.date])
  )

  #v(5pt)

  // Phasen-Pfeile Reihe 1 (zwischen den Diamanten, leicht nach rechts versetzt)
  #pad(left: ms-col-w / 2,
    grid(
      columns: phases.map(p => arrow-w * p.w),
      column-gutter: 2pt,
      align: horizon,
      ..phases.map(p =>
        arrow-shape(label: p.name, last: false, w: arrow-w * p.w)
      )
    )
  )

  // Phasen-Pfeile Reihe 2 (frei verschiebbar per offset/span)
  #if phases2.len() > 0 [
    #v(-0.3cm)
    #pad(left: ms-col-w / 2,
      box(width: arrow-w * 7, height: arrow-h, {
        for p in phases2 {
          let w = arrow-w * p.span
          place(top + left,
            dx: arrow-w * p.offset,
            box(width: w, height: arrow-h, clip: false, {
              place(top + left,
                polygon(
                  fill: arrow-color, stroke: none,
                  (0pt,       0pt),
                  (w - 10pt,  0pt),
                  (w,         arrow-h / 2),
                  (w - 10pt,  arrow-h),
                  (0pt,       arrow-h),
                  (10pt,      arrow-h / 2),
                )
              )
              place(horizon + center,
                text(fill: white, weight: "bold", size: 8.5pt)[#p.name]
              )
            })
          )
        }
      })
    )
  ]

  #v(0.5cm)

  // Personal / Budget
  #grid(
    columns: (2.1cm * sc, ..phases.map(p => arrow-w * p.w)),
    column-gutter: 2pt,
    row-gutter: 5pt,
    align: (left, ..phases.map(_ => center)),
    text(weight: "bold", size: 9pt * sc)[Personal:],
    ..phases.map(p => text(size: 8.5pt * sc)[#p.personal]),
    text(weight: "bold", size: 9pt * sc)[Budget:],
    grid.cell(colspan: 5,
      text(size: 8.5pt * sc)[Kein Sachbudget erforderlich - Studienleistung ohne verfügbares Budget.]
    ),
  )

])

#v(1fr)



