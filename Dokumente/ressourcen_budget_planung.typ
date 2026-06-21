#set document(title: "Ressourcen- und Budgetplan")
#set page(margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "Arial", size: 11pt)

#align(center)[
  #text(size: 18pt, weight: "bold")[Ressourcen- & Budgetplan]
  #v(0.3cm)
  #text(size: 13pt)[DHBW Food Web App]
  #v(0.5cm)
  #line(length: 100%)
]

#v(0.8cm)

Dieses Dokument listet die für die Durchführung des Projekts benötigten Ressourcen und die damit verbundenen Kosten auf.

#v(0.5cm)

#table(
  columns: (30%, 45%, 25%),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { rgb("#d9e1f2") } else if calc.odd(row) { rgb("#f2f2f2") } else { white },

  [*Ressource*], [*Beschreibung*], [*Kosten*],
  [Personal], [5 Teammitglieder (Entwicklung & Projektmanagement)], [Keine (intern)],
  [Hardware], [5x Arbeitslaptops der Teammitglieder], [Bereits vorhanden],
  [Software & Tools], [Podman, Entwicklungsumgebungen (IDEs)], [0,00 € (Open Source)],
  [Infrastruktur], [Hosting & Datenbank nur lokal], [0,00 €],
  [*Gesamtbudget*], [*Finanzieller Mittelbedarf*], [*0,00 €*],
)