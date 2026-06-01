-- ============================================================
-- DHBW Food App – Datenbankschema (PostgreSQL)
-- Wird beim Start des Postgres-Containers automatisch ausgeführt
-- ============================================================

-- ── Erweiterungen ─────────────────────────────────────────────
-- pgcrypto für gen_random_uuid() (optional, UUID-PKs)
-- Hier verwenden wir SERIAL für Einfachheit.

-- ── Tabelle: gerichte ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gerichte (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    kategorie       VARCHAR(50)  NOT NULL
                    CHECK (kategorie IN ('fleisch','vegetarisch','vegan',
                                         'pasta','salat','suppe','dessert')),
    beschreibung    TEXT,
    preis           NUMERIC(6,2),
    verfuegbar_am   DATE,          -- NULL = immer verfügbar
    aktiv           BOOLEAN NOT NULL DEFAULT TRUE,
    erstellt_am     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Tabelle: bewertungen ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS bewertungen (
    id              SERIAL PRIMARY KEY,
    gericht_id      INTEGER NOT NULL REFERENCES gerichte(id) ON DELETE CASCADE,
    gesamt          SMALLINT NOT NULL CHECK (gesamt BETWEEN 1 AND 5),
    geschmack       SMALLINT CHECK (geschmack BETWEEN 1 AND 5),
    portion         SMALLINT CHECK (portion BETWEEN 1 AND 5),
    kommentar       TEXT,
    erstellt_am     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Tabelle: vorschlaege ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS vorschlaege (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    kategorie       VARCHAR(50)  NOT NULL
                    CHECK (kategorie IN ('fleisch','vegetarisch','vegan',
                                         'pasta','salat','suppe','dessert')),
    beschreibung    TEXT,
    begruendung     TEXT,
    erstellt_am     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Indizes ───────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_bewertungen_gericht_id  ON bewertungen(gericht_id);
CREATE INDEX IF NOT EXISTS idx_bewertungen_erstellt_am ON bewertungen(erstellt_am);
CREATE INDEX IF NOT EXISTS idx_gerichte_aktiv          ON gerichte(aktiv, verfuegbar_am);
CREATE INDEX IF NOT EXISTS idx_vorschlaege_erstellt_am ON vorschlaege(erstellt_am);

-- ── Beispieldaten ─────────────────────────────────────────────
INSERT INTO gerichte (name, kategorie, beschreibung, preis, verfuegbar_am, aktiv)
VALUES
    ('Spaghetti Bolognese',       'pasta',        'Klassische Tomatensauce mit Hackfleisch',    3.80, CURRENT_DATE, TRUE),
    ('Gemüse-Curry',              'vegan',         'Saisonales Gemüse in Kokosmilch-Curry',      3.50, CURRENT_DATE, TRUE),
    ('Schweinebraten mit Knödeln','fleisch',       'Bayrischer Schweinebraten mit Semmelknödel', 4.20, CURRENT_DATE, TRUE),
    ('Caprese-Salat',             'vegetarisch',   'Tomate, Mozzarella, Basilikum',              2.80, CURRENT_DATE, TRUE),
    ('Tomatensuppe',              'vegan',         'Hausgemachte Tomatensuppe mit Croutons',     2.20, CURRENT_DATE, TRUE),
    ('Käsespätzle',               'vegetarisch',   'Selbstgemachte Spätzle mit Bergkäse',        3.60, CURRENT_DATE, TRUE),
    ('Hähnchenschnitzel',         'fleisch',       'Paniertes Hähnchen mit Pommes und Salat',    4.00, CURRENT_DATE, TRUE),
    ('Obstsalat',                 'dessert',       'Frischer Obstsalat der Saison',              1.50, CURRENT_DATE, TRUE);

-- Einige Bewertungen für Demo-Zwecke
INSERT INTO bewertungen (gericht_id, gesamt, geschmack, portion, kommentar) VALUES
    (1, 4, 5, 4, 'Sehr lecker, die Sauce ist top!'),
    (1, 5, 5, 3, 'Beste Bolognese der Mensa!'),
    (1, 3, 3, 4, 'Ganz okay, aber könnte würziger sein'),
    (2, 5, 5, 4, 'Tolles veganes Gericht!'),
    (2, 4, 4, 5, 'Großartige Portion, sehr sättigend'),
    (3, 4, 4, 4, 'Echter Genuss, wie bei Oma'),
    (3, 5, 5, 5, 'Absolut perfekt!'),
    (4, 3, 3, 2, 'Zu kleiner Salat für den Preis'),
    (5, 4, 4, 3, 'Schöne Suppe für kalte Tage'),
    (6, 5, 5, 4, 'Die Spätzle sind der Hammer!'),
    (7, 4, 4, 4, 'Klassiker, immer gut'),
    (8, 4, 5, 3, 'Erfrischend und lecker');

-- Beispiel-Vorschläge
INSERT INTO vorschlaege (name, kategorie, beschreibung, begruendung) VALUES
    ('Falafel mit Hummus',      'vegan',        'Knusprige Falafel mit cremigem Hummus und Pita', 'Wäre eine tolle vegane Option!'),
    ('Linsensuppe',             'vegan',        'Orientalische Linsensuppe mit Kreuzkümmel',      'Günstig, gesund und lecker'),
    ('Shakshuka',               'vegetarisch',  'Eier in gewürzter Tomatensauce',                 'Ausgefallen und nahrhaft'),
    ('Flammkuchen',             'vegetarisch',  'Elsässer Flammkuchen mit Crème fraîche',         'Wäre mal etwas anderes!');
