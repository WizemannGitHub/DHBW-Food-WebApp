#set document(title: "API-Nutzungsvertrag Vorlage")
#set page(margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "Arial", size: 10pt)
#set par(justify: true)

#align(center)[
  #text(size: 16pt, weight: "bold")[API-Nutzungsvertrag]
  #v(0.2cm)
  #text(size: 10pt, style: "italic")[— Vorlage / Muster —]
]

#v(0.6cm)

*zwischen*

#v(0.3cm)

*API-Anbieter:* \[Name des Anbieters\], \[Adresse\] — nachfolgend „Anbieter" \
*API-Nutzer:* DHBW-Food-WebApp-Team, \[Adresse\] — nachfolgend „Nutzer"

#v(0.5cm)
#line(length: 100%, stroke: 0.5pt)
#v(0.4cm)

*§ 1 — Gegenstand*

Der Anbieter stellt dem Nutzer Zugang zur Mensa-Plan-API (erreichbar unter `https://mensa-api.fnka.de`) bereit. Der Nutzer darf die API ausschließlich für den Betrieb der DHBW-Food-WebApp verwenden.

#v(0.4cm)

*§ 2 — Beschreibung der API-Schnittstelle*

Der Nutzer greift ausschließlich über folgenden Endpunkt auf die API zu:

#block(
  fill: rgb("#f5f5f5"),
  inset: (x: 10pt, y: 8pt),
  radius: 4pt,
  [
    `GET /plans/{datum}` \
    #text(size: 9pt)[Parameter: `datum` im Format `YYYY-MM-DD` (z. B. `2025-05-12`)] \
    #text(size: 9pt)[Rückgabe: JSON-Array mit Gerichten des jeweiligen Tages]
  ]
)

#v(0.2cm)

Die Antwortstruktur enthält mindestens folgende Felder je Gericht:

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.4pt,
  inset: (x: 6pt, y: 5pt),
  fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
  [*Feld*], [*Typ*], [*Beschreibung*],
  [`name`],       [`string`],  [Bezeichnung des Gerichts],
  [`kategorie`],  [`string`],  [Kategorie (z. B. Fleisch, Vegan, …)],
  [`preis`],      [`number`],  [Preis in Euro],
  [`beschreibung`],[`string`], [Kurzbeschreibung / Zutaten (optional)],
)

#v(0.4cm)

*§ 3 — Verfügbarkeit & Reaktionszeit*

Der Anbieter gewährleistet eine Verfügbarkeit von mindestens *95 %* pro Monat (gemessen außerhalb geplanter Wartungsfenster). Geplante Ausfälle werden dem Nutzer mindestens *48 Stunden* vorab per E-Mail angekündigt.

#v(0.4cm)

*§ 4 — Änderungen an der API*

Der Anbieter verpflichtet sich, strukturelle Änderungen (neue Pflichtfelder, geänderte Feldnamen, geänderte URL-Struktur) mindestens *4 Wochen* vor Inkrafttreten schriftlich anzukündigen. Während dieser Frist wird die bisherige Version parallel weiterbetrieben.

#v(0.4cm)

*§ 5 — Nutzungsgrenzen*

Der Nutzer darf die API mit maximal \[X\] Anfragen pro Minute abrufen. Ein automatisiertes Caching auf Nutzerseite ist ausdrücklich erlaubt und erwünscht, um die Last zu minimieren.

#v(0.4cm)
#pagebreak()

*§ 6 — Haftung*

Der Anbieter haftet nicht für Schäden, die aus vorübergehender Nichtverfügbarkeit der API oder fehlerhaften Daten entstehen, sofern § 3 eingehalten wurde. Der Nutzer stellt sicher, dass seine Anwendung mit einem Fallback-Mechanismus betrieben wird (z. B. Anzeige eines Hinweistexts bei Nicht-Erreichbarkeit der API).

#v(0.4cm)

*§ 7 — Laufzeit & Kündigung*

Der Vertrag läuft auf unbestimmte Zeit. Jede Partei kann mit einer Frist von *4 Wochen* zum Monatsende schriftlich kündigen.

#v(0.4cm)
#line(length: 100%, stroke: 0.5pt)
#v(0.5cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  [
    Ort, Datum: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ \
    #v(1cm)
    Unterschrift Anbieter \
    #v(0.6cm)
    \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ],
  [
    Ort, Datum: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ \
    #v(1cm)
    Unterschrift Nutzer \
    #v(0.6cm)
    \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ]
)
