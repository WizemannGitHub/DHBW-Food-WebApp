#set document(title: "Ablaufkonzept: Ablaufdiagramm der Funktion Essen Bewerten")
#set page(margin: (x: 2.5cm, y: 1.5cm))
#set text(font: "Arial", size: 11pt)

#align(center)[
  #text(size: 18pt, weight: "bold")[Ablaufkonzept: Ablaufdiagramm \ der Funktion \"Essen Bewerten\"]
  #v(0.2cm)
  #text(size: 13pt)[DHBW Food Web App]
  #v(0.3cm)
  #line(length: 100%)
]

#v(0.5cm)

#let step(body) = align(center)[
  #rect(width: 8cm, radius: 0.3cm, fill: rgb("#d9e1f2"), stroke: 0.8pt, inset: 0.35cm)[
    #align(center)[#body]
  ]
]

#let decision(body) = align(center)[
  #rect(width: 8cm, radius: 0.3cm, fill: rgb("#fff2cc"), stroke: 0.8pt, inset: 0.35cm)[
    #align(center)[⬦ #body]
  ]
]

#let arrow = align(center)[#v(-0.4cm) #text(size: 18pt)[↓] #v(-0.1cm)]

#align(center)[
  #rect(width: 8cm, radius: 0.8cm, fill: rgb("#70ad47"), stroke: 0.8pt, inset: 0.35cm)[
    #align(center)[#text(weight: "bold", fill: white)[START]]
  ]
]

#arrow
#step[*Schritt 1:* Sektion „Bewertung" auswählen]
#arrow
#step[*Schritt 2:* Kantine auswählen]
#arrow
#step[*Schritt 3:* Essen auswählen]
#arrow
#step[*Schritt 4:* Essen nach Kategorien bewerten \ #text(size: 9pt, fill: rgb("#595959"))[(z. B. Geschmack, Preis, Qualität)]]
#arrow
#decision[Kommentar schreiben? *(optional)*]
#arrow
#step[*Schritt 5:* Bewertung abschicken]
#arrow
#step[*Schritt 6:* Bestätigung wird angezeigt]
#arrow

#align(center)[
  #rect(width: 8cm, radius: 0.8cm, fill: rgb("#c00000"), stroke: 0.8pt, inset: 0.35cm)[
    #align(center)[#text(weight: "bold", fill: white)[ENDE]]
  ]
]
