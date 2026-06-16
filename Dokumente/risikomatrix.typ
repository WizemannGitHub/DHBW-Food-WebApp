#set page(flipped: true, margin: 2cm)
#set text(font: "Arial", size: 10pt)

#let gruen = rgb("#4caf50")
#let gelb  = rgb("#ffa726")
#let rot   = rgb("#e53935")

#let farbe(e, s) = {
  let p = e * s
  if p <= 4 { gruen } else if p <= 12 { gelb } else { rot }
}

#align(center)[#text(size: 14pt, weight: "bold")[Risikomatrix]]
#v(1cm)

#let schadenshoehen = (
  (5, [> 30 Stunden]),
  (4, [< 30 Stunden ]),
  (3, [< 15 Stunden ]),
  (2, [< 5 Stunden]),
  (1, [< 1 Stunde]),
)

#align(center)[
#table(
  columns: (1cm, 3cm, 2.5cm, 2.5cm, 2.5cm, 2.5cm, 2.5cm),
  rows: (auto, 1.5cm, 1.5cm, 1.5cm, 1.5cm, 1.5cm, auto, auto),
  align: center + horizon,
  stroke: white + 1pt,

  // Header-Zeile
  [], [],
  table.cell(fill: rgb("#eeeeee"))[*< 0,1 %*],
  table.cell(fill: rgb("#eeeeee"))[*< 1 %*],
  table.cell(fill: rgb("#eeeeee"))[*< 10 %*],
  table.cell(fill: rgb("#eeeeee"))[*< 20 %*],
  table.cell(fill: rgb("#eeeeee"))[*> 20 %*],

  // Matrix-Zeilen
  ..schadenshoehen.map(((s, wert)) => (
    table.cell(fill: rgb("#eeeeee"))[*#s*],
    table.cell(align: right + horizon, fill: rgb("#eeeeee"))[#wert],
    ..range(1, 6).map(e => table.cell(fill: farbe(e, s))[]),
  )).flatten(),

  // Klassen-Zeile
  [], [],
  [*1*], [*2*], [*3*], [*4*], [*5*],

  // Achsenbeschriftung
  table.cell(colspan: 7)[
    #align(center)[*Eintrittswahrscheinlichkeit*]
  ],
)
]

#v(0.5cm)

// Legende
#grid(
  columns: (auto, auto, auto),
  column-gutter: 2cm,
  ..((rot, [*Inakzeptabel* – Gegenmaßnahmen dringend erforderlich]),
     (gelb, [*Näher untersuchen* – Monitoring im Projekt-Team]),
     (gruen, [*Akzeptabel* – Änderungen im Auge behalten]),
  ).map(((f, txt)) =>
    grid(
      columns: (0.7cm, auto),
      column-gutter: 0.4cm,
      align: horizon,
      rect(width: 0.7cm, height: 0.7cm, fill: f, stroke: none),
      txt,
    )
  ),
)
