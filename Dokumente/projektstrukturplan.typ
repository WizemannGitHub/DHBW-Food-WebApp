#set document(title: "Projektstrukturplan")
#set page(paper: "a4", flipped: true, margin: (x: 2cm, y: 1.5cm))
#set text(font: "Arial", size: 10pt)

// ══════════════════════════════════════════════════════════════════════════════
// PROJEKTDATEN — hier alles anpassen
// ══════════════════════════════════════════════════════════════════════════════

#let project = (
  name: "DHBW Food Web App",
  nr: "01101110",
  leader: "Erik Wizemann",
  client: "Mikka Jenne",
  startdate: "12.05.2026",
)

// Jede Phase hat: id, name, color und eine Liste von Arbeitspaketen (id + name).
#let psp = (
  (
    id: "1",
    name: "Projektmanagement",
    color: rgb("#2e74b5"),
    packages: (
      (id: "1.1", name: "Projektplanung"),
      (id: "1.2", name: "Projektsteuerung"),
      (id: "1.3", name: "Projektabschluss"),
    ),
  ),
  (
    id: "2",
    name: "Anforderungsanalyse",
    color: rgb("#c00000"),
    packages: (
      (id: "2.1", name: "Ist-Analyse"),
      (id: "2.2", name: "Anforderungen erheben"),
      (id: "2.3", name: "Risikoanalyse"),
    ),
  ),
  (
    id: "3",
    name: "Designkonzept",
    color: rgb("#375623"),
    packages: (
      (id: "3.1", name: "UI/UX Design"),
      (id: "3.2", name: "Systemarchitektur"),
    ),
  ),
  (
    id: "4",
    name: "Implementierung",
    color: rgb("#7030a0"),
    packages: (
      (id: "4.1", name: "Datenbank"),
      (id: "4.2", name: "Frontend"),
      (id: "4.3", name: "Backend"),
    ),
  ),
  (
    id: "5",
    name: "Testing & Fehlerbehebung",
    color: rgb("#833c00"),
    packages: (
      (id: "5.1", name: "Testing & QA"),
      (id: "5.2", name: "Deployment"),
      (id: "5.3", name: "Abgabe & Präsentation"),
    ),
  ),
)

// ══════════════════════════════════════════════════════════════════════════════
// LAYOUT-KONSTANTEN
// ══════════════════════════════════════════════════════════════════════════════

#let root-w = 7cm
#let root-h = 0.9cm
#let phase-w = 4.5cm
#let phase-h = 0.85cm
#let pkg-w = 4.5cm
#let pkg-h = 0.8cm
#let col-gap = 0.8cm    // Abstand zwischen den Phasenspalten
#let row-gap = 0.25cm   // Abstand zwischen Paketen innerhalb einer Phase
#let v-conn = 0.4cm    // Länge vertikaler Verbindungslinien
#let lc = rgb("#555555")  // Linienfarbe

// ══════════════════════════════════════════════════════════════════════════════
// HILFSFUNKTIONEN
// ══════════════════════════════════════════════════════════════════════════════

#let node(body, fill: white, text-color: black, width: auto, height: auto) = box(
  width: width,
  height: height,
  fill: fill,
  stroke: 0.7pt,
  inset: 5pt,
  radius: 2pt,
  align(center + horizon, text(fill: text-color, size: 8.5pt, body)),
)

#let vline(h: v-conn) = align(center, box(width: 1pt, height: h, fill: lc))

#let hline(w: 100%) = place(top + center, box(width: w, height: 1pt, fill: lc))

// Zeichnet eine Phase-Box + alle ihre Pakete untereinander
#let phase-column(phase) = {
  // vertikale Linie von Root-Balken zur Phase
  vline()
  node(
    [*#phase.id* #h(0.3cm) #phase.name],
    fill: phase.color,
    text-color: white,
    width: phase-w,
    height: phase-h,
  )

  // Verbindungslinie Phase → erstes Paket
  vline()

  // Alle Pakete untereinander
  stack(spacing: row-gap, ..phase.packages.map(pkg => node(
    [*#pkg.id* #h(0.3cm) #pkg.name],
    fill: phase.color.lighten(68%),
    width: pkg-w,
    height: pkg-h,
  )))
}

// ══════════════════════════════════════════════════════════════════════════════
// DIAGRAMM
// ══════════════════════════════════════════════════════════════════════════════

#let n-phases = psp.len()
#let tree-w = n-phases * phase-w + (n-phases - 1) * col-gap

#align(center)[

  // Titel
  #text(size: 18pt, weight: "bold")[Projektstrukturplan]
  #v(0.1cm)
  #text(size: 13pt, weight: "bold")[DHBW Food Web App]
  #v(0.3cm)
  #line(length: 100%)
  #v(0.5cm)

  // Root-Node
  #node(
    [*#project.name*],
    fill: rgb("#1a3a5c"),
    text-color: white,
    width: root-w,
    height: root-h,
  )

  // Vertikale Linie Root → horizontaler Balken
  #vline()

  // Horizontaler Balken über alle Phasen
  #box(width: tree-w)[
    #hline(w: tree-w)

    // Phasenspalten nebeneinander, Pakete jeweils untereinander
    #grid(
      columns: (phase-w,) * n-phases,
      column-gutter: col-gap,
      align: top,
      ..psp.map(phase => phase-column(phase))
    )
  ]

  #v(0.6cm)
  #line(length: 100%)
  #v(0.15cm)

  // Footer
  #grid(
    columns: (33%, 34%, 33%),
    align(left, text(size: 8pt)[*Projektleiter:* #project.leader]),
    align(center, text(size: 8pt)[*Auftraggeber:* #project.client]),
    align(right, text(size: 8pt)[*Startdatum:* #project.startdate]),
  )
]
