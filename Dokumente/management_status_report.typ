#set document(title: "Management Status Report")
#set page(margin: (x: 1.5cm, y: 1.5cm), paper: "a4", flipped: true)
#set text(font: "Arial", size: 9pt)

// ─── Ampel-Farben ────────────────────────────────────────────────────────────
#let rot    = rgb("#cc0000")
#let gelb   = rgb("#e6b800")
#let gruen  = rgb("#00aa00")

#let ampel(farbe) = circle(radius: 6pt, fill: farbe, stroke: none)

// Ampel-Symbol (rot/gelb/gruen gestapelt, aktive Farbe ausgefüllt)
#let ampel-gesamt(status) = {
  let r = if status == "rot"   { rot   } else { rgb("#eeaaaa") }
  let g = if status == "gelb"  { gelb  } else { rgb("#eee8aa") }
  let b = if status == "gruen" { gruen } else { rgb("#aaddaa") }
  stack(
    dir: ttb,
    spacing: 2pt,
    circle(radius: 6pt, fill: r, stroke: none),
    circle(radius: 6pt, fill: g, stroke: none),
    circle(radius: 6pt, fill: b, stroke: none),
  )
}

// Kleine Status-Ampel (einzelner Kreis)
#let dot(farbe) = circle(radius: 5pt, fill: farbe, stroke: none)

// ─── KOPF ────────────────────────────────────────────────────────────────────
#text(size: 16pt, weight: "bold")[Management Status Report]
#v(0.4cm)

#grid(
  columns: (1fr, 1fr, 1fr),
  [*Projektname:* #text(fill: rgb("#0070c0"))[DHBW Food Web App]],
  [*Projektmanager\*in:* #text(fill: rgb("#0070c0"))[Erik Wizemann]],
  [*Datum:* #text(fill: rgb("#0070c0"))[#datetime.today().display("[day].[month].[year]")]],
)

#v(0.3cm)

// ─── ZUSAMMENFASSUNG ─────────────────────────────────────────────────────────
#grid(
  columns: (1fr, auto),
  gutter: 0.5cm,
  [
    #rect(stroke: 0.5pt, inset: 8pt, width: 100%)[
      *Zusammenfassung*
      #v(0.2cm)
      #list(
        marker: sym.checkmark,
        [#text(fill: rgb("#0070c0"))[...]],
        [#text(fill: rgb("#0070c0"))[...]],
        [#text(fill: rgb("#0070c0"))[...]],
        [#text(fill: rgb("#0070c0"))[...]],
      )
    ]
  ],
  [
    // Gesamt-Ampel — passe "rot" / "gelb" / "gruen" an
    #ampel-gesamt("gelb")
  ],
)

#v(0.3cm)

// ─── STATUS + RISIKEN ────────────────────────────────────────────────────────
#grid(
  columns: (1fr, 1fr),
  gutter: 0.4cm,

  // ── Status-Box ──
  rect(stroke: 0.5pt, inset: 0pt)[
    #rect(fill: none, stroke: none, inset: 4pt)[*Status*]
    #table(
      columns: (auto, 1fr, auto),
      stroke: 0.5pt,
      fill: (col, row) => if row == 0 { rgb("#1f5c99") } else { white },
      inset: 5pt,

      text(fill: white, weight: "bold")[Bereich],
      text(fill: white, weight: "bold")[Status],
      [],

      [1. Scope],        [Zeitplan wird gut eingehalten. Keine wesentlichen Verzögerungen],      dot(gruen),
      [2. Umsetzung],    [#text(fill: rgb("#0070c0"))[...]],        dot(gelb),
      [3. Kosten / Termine], [#text(fill: rgb("#0070c0"))[...]],    dot(gelb),
      [4. Team],         [#text(fill: rgb("#0070c0"))[...]],        dot(rot),
      [5. Stakeholder],  [#text(fill: rgb("#0070c0"))[...]],        dot(gruen),
    )
  ],

  // ── Risiken-Box ──
  rect(stroke: 0.5pt, inset: 0pt)[
    #rect(fill: none, stroke: none, inset: 4pt)[*Risiken und Hindernisse*]
    #table(
      columns: (1fr, 1fr, auto, auto, auto),
      stroke: 0.5pt,
      fill: (col, row) => if row == 0 { rgb("#cc0000") } else if calc.odd(row) { rgb("#ffeeee") } else { white },
      inset: 5pt,

      text(fill: white, weight: "bold")[Risko / Konflikt / Problem],
      text(fill: white, weight: "bold")[Gegenmaßnahme],
      text(fill: white, weight: "bold")[Verantwortlich],
      text(fill: white, weight: "bold")[Bis wann],
      [],

      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      dot(rot),

      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      [#text(fill: rgb("#0070c0"))[...]],
      dot(gelb),

      [...],
      [...],
      [...],
      [...],
      [],
    )
  ],
)

#v(0.3cm)

// ─── DETAILS ─────────────────────────────────────────────────────────────────
#rect(stroke: 0.5pt, inset: 0pt, width: 100%)[
  #rect(fill: none, stroke: none, inset: 4pt)[*Details*]
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0pt,

    // Erreichte Ergebnisse
    rect(stroke: (right: 0.5pt), inset: 8pt)[
      *Erreichte Ergebnisse*
      #v(0.2cm)
      #list(
        marker: sym.checkmark,
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
      )
    ],

    // Nächste Schritte
    rect(stroke: (right: 0.5pt), inset: 8pt)[
      *Nächste Schritte*
      #v(0.2cm)
      #list(
        marker: sym.arrow.r,
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
        text(fill: rgb("#0070c0"))[...],
      )
    ],

    // Meilensteine
    rect(inset: 8pt)[
      *Meilensteine*
      #v(0.2cm)
      #table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 2pt, y: 2pt),

        // Format: Datum | Bezeichnung (Farbe zeigt Status)
        // gruen = erreicht, gelb = in Verzug, rot = kritisch, schwarz = geplant
        [#text(fill: gruen)[01.01.26]], [#text(fill: gruen)[Projektstart]],
        [#text(fill: gruen)[26.03.26]], [#text(fill: gruen)[#text(fill: rgb("#0070c0"))[...]]],
        [#text(fill: gelb)[23.04.26]],  [#text(fill: gelb)[#text(fill: rgb("#0070c0"))[...]]],
        [#text(fill: rot)[02.07.26]],   [#text(fill: rot)[#text(fill: rgb("#0070c0"))[...]]],
        [08.07.26],                      [Projektabschluss],
      )
    ],
  )
]

#v(0.5cm)

// ─── Legende ─────────────────────────────────────────────────────────────────
#align(right)[
  #set text(size: 7pt)
  #grid(
    columns: (auto, auto, auto, auto, auto, auto),
    gutter: 4pt,
    align: horizon,
    dot(gruen), [Im Plan],
    dot(gelb),  [kritisch innerhalb des Projektes lösbar],
    dot(rot),   [Kritisch nicht innerhalb des Projektes lösbar],
  )
]
