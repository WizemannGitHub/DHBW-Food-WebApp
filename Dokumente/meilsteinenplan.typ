#set page(paper: "a4", flipped: true, margin: (x: 1.5cm, y: 1.5cm))
#set text(font: "Arial", size: 10pt)

// ── Title ──────────────────────────────────────────────────────────────────
#align(center)[
  #text(size: 22pt, weight: "bold")[Phasen und Meilenstein Plan]
  #v(0pt)
]

#v(1.2cm)

// ── Data ───────────────────────────────────────────────────────────────────
// Edit these arrays to fill in your plan.
#let milestones = (
  (label: "Start",  date: "xx.xx.xxxx"),
  (label: "Anforderunganalyse",    date: "xx.xx.xxxx"),
  (label: "Protoype",   date: "xx.xx.xxxx"),
  (label: "Implementierung",    date: "xx.xx.xxxx"),
  (label: "Testen",    date: "xx.xx.xxxx"),
  (label: "Ende",   date: "xx.xx.xxxx"),
)

#let phases = (
  (name: "...", personal: "...", budget: "... €"),
  (name: "...", personal: "...", budget: "..."),
  (name: "...", personal: "...", budget: "..."),
  (name: "...", personal: "...", budget: "..."),
  (name: "...", personal: "...", budget: "..."),
)

// ── Layout constants ────────────────────────────────────────────────────────
#let diamond-size  = 14pt
#let arrow-h       = 28pt
#let arrow-w       = 3.8cm   // width of each phase arrow
#let arrow-gap     = 0pt
#let arrow-color   = rgb("#2e74b5")
#let diamond-color = rgb("#c00000")

// ── Helpers ─────────────────────────────────────────────────────────────────
#let diamond(size: 14pt, fill: diamond-color) = {
  box(width: size, height: size,
    rotate(45deg,
      rect(width: size * 0.72, height: size * 0.72, fill: fill, stroke: none)
    )
  )
}

// chevron arrow (last one has a flat right edge)
#let arrow-shape(label: "", last: false) = {
  let tip = if last { 0pt } else { 10pt }
  box(
    width: arrow-w + tip,
    height: arrow-h,
    clip: false,
    {
      // background polygon via path
      place(top + left,
        polygon(
          fill: arrow-color,
          stroke: none,
          (0pt,       0pt),
          (arrow-w,   0pt),
          (arrow-w + tip, arrow-h / 2),
          (arrow-w,   arrow-h),
          (0pt,       arrow-h),
          (tip,       arrow-h / 2),
        )
      )
      // centred label
      place(
        horizon + center,
        dx: tip / 2,
        text(fill: white, weight: "bold", size: 9pt)[#label]
      )
    }
  )
}

// ── Timeline row ────────────────────────────────────────────────────────────
// We use a fixed-width grid: 6 milestone columns + 5 phase columns.
// Widths: milestone cols narrow, phase cols = arrow-w + overlap.

#align(center, box(width: 22cm)[

// Top labels (milestone names)
#grid(
  columns: (1.5cm, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, 1.5cm),
  column-gutter: 0pt,
  align: (center,) * 7,
  ..milestones.map(m => text(size: 9pt)[#m.label])
)

#v(2pt)

// Diamond row
#grid(
  columns: (1.5cm, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, 1.5cm),
  column-gutter: 0pt,
  align: (center,) * 7,
  ..milestones.map(m => diamond())
)

#v(1pt)

// Date row
#grid(
  columns: (1.5cm, arrow-w, arrow-w, arrow-w, arrow-w, arrow-w, 1.5cm),
  column-gutter: 0pt,
  align: (center,) * 7,
  ..milestones.map(m => text(size: 8pt)[#m.date])
)

#v(4pt)

// Phase arrows (offset by half a milestone-column so arrows sit between diamonds)
#pad(left: 0.75cm,
  grid(
    columns: phases.map(_ => arrow-w),
    column-gutter: 2pt,
    align: horizon,
    ..phases.enumerate().map(((i, p)) => arrow-shape(label: p.name, last: i == phases.len() - 1))
  )
)

#v(0.8cm)

// ── Personal / Budget rows ───────────────────────────────────────────────────
#let label-col = 1.8cm
#let data-col  = arrow-w

#grid(
  columns: (label-col, data-col, data-col, data-col, data-col, data-col),
  column-gutter: 2pt,
  row-gutter: 4pt,
  align: (left, center, center, center, center, center),
  underline[*Personal:*], ..phases.map(p => text[#p.personal]),
  underline[*Budget:*],   ..phases.map(p => text[#p.budget]),
)

])
