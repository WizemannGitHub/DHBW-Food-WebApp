#set page(margin: (x: 2.5cm, y: 2.5cm), height: 297mm, width: 210mm)
#set text(font: "Arial", size: 11pt)

#v(0.5cm)

#grid(
  columns: (1fr, 1fr),
  align(left)[
    #image("Bilder/ProjektLogo.png", width: 7cm)
  ],
  align(right)[
    #image("Bilder/DHBW-Logo.png", width: 4cm)
  ]
)

#v(1.5cm)

#align(center)[
  #text(size: 28pt, weight: "bold")[DHBW Food Web App]

  #v(0.5cm)

  #text(size: 14pt, weight: "bold")[Projekthandbuch Web-Engineering]

  #v(0.4cm)

  #text(size: 11pt)[Im Rahmen der Prüfung:]
  #linebreak()
  #text(size: 11pt, weight: "bold")[Bachelor of Science (B. Sc.)]

  #v(0.4cm)

  #text(size: 13pt)[des Studienganges Informatik]
  #linebreak()
  #text(size: 10pt)[an der Dualen Hochschule Baden-Württemberg Karlsruhe]

  #v(0.6cm)

  #text(size: 10pt)[von]

  #v(0.2cm)

  #text(size: 13pt, weight: "bold")[
    Robin van Nuis, Jan Kugler, Cristian Zanfir,\
    Ben Szepan, Erik Wizemann
  ]
]

#v(1.2cm)

#align(center)[
  #table(
    columns: (45%, 55%),
    stroke: none,
    inset: (y: 5pt),

    [*Abgabedatum*], [29.06.2026],
    [*Bearbeitungszeitraum*], [12.05.2026 – 29.06.2026],
    [*Teammitglieder*],
    [
      #grid(
        columns: (4cm, auto),
        align: (left, left),
        row-gutter: 8pt,
        [Robin van Nuis:], [*\8\7\7\1\2\9\3*],
        [Jan Kugler:], [*\5\3\5\7\2\0\1*],
        [Cristian Zanfir:], [*\_\_\_\_\_\_\_*],
        [Ben Szepan:], [*\_\_\_\_\_\_\_*],
        [Erik Wizemann:], [*\9\4\3\4\6\2\0*],
      )
    ],
    [*Kurs*], [TINF25B2],
    [*Gutachter der Dualen Hochschule*], [Dr. Arno Mielke, Mikka Jenne],
  )
]
