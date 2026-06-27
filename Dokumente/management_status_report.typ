#set document(title: "Management Status Report")
#set page(margin: (x: 0.8cm, y: 0.8cm), paper: "a4", flipped: true)
#set text(font: "Arial", size: 7.5pt)

// ─── Ampel-Farben ────────────────────────────────────────────────────────────
#let rot = rgb("#cc0000")
#let gelb = rgb("#e6b800")
#let gruen = rgb("#00aa00")

#let ampel(farbe) = circle(radius: 6pt, fill: farbe, stroke: none)

// Ampel-Symbol (rot/gelb/gruen gestapelt, aktives Licht mit schwarzem X)
#let ampel-licht(farbe, aktiv) = {
  box(width: 12pt, height: 12pt)[
    #circle(radius: 6pt, fill: farbe, stroke: none)
    #if aktiv [
      #place(
        center + horizon,
        text(size: 18pt, fill: black, weight: "black")[✕],
      )
    ]
  ]
}

#let ampel-gesamt(status) = {
  stack(
    dir: ttb,
    spacing: 2pt,
    ampel-licht(rot, status == "rot"),
    ampel-licht(gelb, status == "gelb"),
    ampel-licht(gruen, status == "gruen"),
  )
}

// Kleine Status-Ampel (einzelner Kreis)
#let dot(farbe) = circle(radius: 5pt, fill: farbe, stroke: none)

// ─── KOPF ────────────────────────────────────────────────────────────────────
#text(size: 15pt, weight: "bold")[Management Status Report]
#v(0.2cm)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  [*Projektname: *#text(fill: rgb("#0070c0"))[DHBW Food Web App]],
  [*Projektmanager\*in:* #text(fill: rgb("#0070c0"))[Erik Wizemann]],
  [*Auftraggeber:* #text(fill: rgb("#0070c0"))[Mikka Jenne]],
  [*Datum:* #text(fill: rgb("#0070c0"))[16.06.2026]],
)

#v(0.15cm)

// ─── ZUSAMMENFASSUNG ─────────────────────────────────────────────────────────
#grid(
  columns: (1fr, auto),
  gutter: 0.3cm,
  [
    #rect(stroke: 0.5pt, inset: 5pt, width: 100%)[
      *Zusammenfassung*
      #v(0.1cm)
      #list(
        marker: sym.checkmark,
        [Projektplanung und Dokumentation (Auftrag, PSP, Ablaufplan, Risikoanalyse) weitesgehend fertig - Abgabe 29.06.2026 in Reichweite],
        [Kernfunktionen der Web-App (Bewertung, Ranking, Backend, Datenbank) implementiert und im lokalen Betrieb],
      )
    ]
  ],
  [
    #ampel-gesamt("gruen")
  ],
)

#v(0.15cm)

// ─── STATUS + RISIKEN ────────────────────────────────────────────────────────
#grid(
  columns: (1fr, 1fr),
  gutter: 0.25cm,

  // ── Status-Box ──
  rect(stroke: 0.5pt, inset: 0pt, width: 100%)[
    #rect(fill: none, stroke: none, inset: 4pt)[*Status*]
    #table(
      columns: (auto, 1fr, auto),
      stroke: 0.5pt,
      fill: (col, row) => if row == 0 { rgb("#1f5c99") } else { white },
      inset: 3pt,

      text(fill: white, weight: "bold")[Bereich], text(fill: white, weight: "bold")[Status], [],

      [1. Scope],
      [#text(fill: rgb("#0070c0"))[Zeitplan wird gut eingehalten. Keine wesentlichen Verzögerungen]],
      dot(gruen),

      [2. Umsetzung],
      [#text(
        fill: rgb("#0070c0"),
      )[Implementierung und Umsetzung der Ideen ist weitesgehend problemlos verlaufen. Kleine Features noch nicht fertiggestellt]],
      dot(gelb),

      [3. Kosten / Termine], [#text(fill: rgb("#0070c0"))[Keine Kosten angefallen]], dot(gruen),
      [4. Team],
      [#text(
        fill: rgb("#0070c0"),
      )[Teamarbeit lief ohne Probleme. Regelmäßige Kommunikation und Absprechung des Fortschritt]],
      dot(gruen),

      [5. Stakeholder],
      [#text(fill: rgb("#0070c0"))[Endnutzer (Studierende) noch nicht eingebunden. Noch kein Test-Feedback vorhanden]],
      dot(gelb),
    )
  ],

  // ── Risiken-Box ──
  rect(stroke: 0.5pt, inset: 0pt, width: 100%)[
    #rect(fill: none, stroke: none, inset: 4pt)[*Risiken und Hindernisse*]
    #table(
      columns: (1fr, 1fr, 1fr, auto, auto),
      stroke: 0.5pt,
      fill: (col, row) => if row == 0 { rgb("#cc0000") } else if calc.odd(row) { rgb("#ffeeee") } else { white },
      inset: 5pt,

      text(fill: white, weight: "bold")[Risko / Konflikt / Problem],
      text(fill: white, weight: "bold")[Gegenmaßnahme],
      text(fill: white, weight: "bold")[Verantwortlich],
      text(fill: white, weight: "bold")[Bis wann],
      [],

      [#text(fill: rgb("#f00"))[Problem: Essenseinträge sind in der API schlecht Kategorisiert]],
      [#text(
        fill: rgb("#0070c0"),
      )[Anbieter der API wegen möglichen Änderungen kontaktieren, sonst Darstellung der Essen wie in der API gegeben]],
      [#text(fill: rgb("#0070c0"))[Robin van Nuis]],
      [#text(fill: rgb("#0070c0"))[29.06.2026]],
      dot(gelb),

      [#text(fill: rgb("#f00"))[Risiko: Testing der Web-App deckt Probleme im Backend/Frontend auf]],
      [#text(fill: rgb("#0070c0"))[Einplanung von genügend Zeit zur Fehlerbehebung]],
      [#text(fill: rgb("#0070c0"))[Erik Wizemann, Cristian Zanfir]],
      [#text(fill: rgb("#0070c0"))[03.08.2026]],
      dot(gruen),
    )
  ],
)

#v(0.3cm)

// ─── DETAILS ─────────────────────────────────────────────────────────────────
#rect(stroke: 1pt, inset: 0pt, width: 100%)[
  #rect(fill: none, stroke: none, inset: 4pt)[*Details*]
  #table(
    columns: (1fr, 1fr, 1fr),
    gutter: 0pt,

    // Erreichte Ergebnisse
    rect(stroke: none, inset: 3pt)[
      *Erreichte Ergebnisse*
      #v(0.2cm)
      #list(
        marker: sym.checkmark,
        [Projektmanagement-Dokumente größtenteils fertiggestellt (Projektauftrag, Risikoanalyse, PSP, Ablaufplan/Gantt)],
        [Backend mit REST-API entwickelt und in Betrieb],
        [Frontend (Bewertung, Ranking, Tagesansicht) implementiert],
        [Bewertungslogik eingeschränkt - nur Gerichte von heute/Vergangenheit bewertbar, Wochenende ausgeblendet],
        [Technische Dokumentation fertiggestellt],
      )
    ],

    // Nächste Schritte
    rect(stroke: none, inset: 8pt)[
      *Nächste Schritte*
      #v(0.2cm)
      #list(
        marker: sym.arrow.r,
        [Meilensteinplan vervollständigen — fehlende Daten nachtragen (bis 22.06.)],
        [Zukunftsaussichten der App planen],
        [Alle PM-Dokumente final zusammenstellen und auf Konsistenz prüfen (bis 24.06.)],
        [Abgabe in Moodle (bis 29.06.)],
        [Präsentation vorbereiten und Redeaufteilung festlegen (bis 06.07.)],
      )
    ],

    // Meilensteine
    rect(stroke: none, inset: 8pt)[
      *Meilensteine*
      #v(0.2cm)
      #table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 2pt, y: 2pt),

        // Format: Datum | Bezeichnung (Farbe zeigt Status)
        // gruen = erreicht, gelb = in Verzug, rot = kritisch, schwarz = geplant
        [#text(fill: gruen)[12.05.26]], [#text(fill: gruen)[M0 - Projektstart]],
        [#text(fill: gruen)[24.05.26]], [#text(fill: gruen)[M1 - Anforderungsanalyse abgeschlossen]],
        [#text(fill: gruen)[07.06.26]], [#text(fill: gruen)[M2 - Fertiges Designkonzept abgenommen]],
        [#text(fill: gelb)[29.06.26]], [#text(fill: gelb)[M3 - Abgabe Projektmanagement]],
        [08.07.26], [M4 - Zwischenpräsentation],
        [15.07.26], [M5 - Funktionsfertige Webanwendung],
        [28.07.26], [M6 - Abnahme Mensaapp],
        [03.08.26], [M7 - Technische Abgabe / Projektabschluss],
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
    dot(gruen),
    [Im Plan],
    dot(gelb),
    [kritisch innerhalb des Projektes lösbar],
    dot(rot),
    [Kritisch nicht innerhalb des Projektes lösbar],
  )
]
