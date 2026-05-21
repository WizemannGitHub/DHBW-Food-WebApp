/**
 * app.js – Haupt-Controller: Navigation & Seitenrouting
 */

(function app() {

  const pages   = document.querySelectorAll('.page');
  const navBtns = document.querySelectorAll('.nav__btn');

  // Welche Seite wurde bereits geladen?
  const loaded = { bewertung: false, ranking: false, vorschlaege: false };

  // ── Navigation ───────────────────────────────────────────
  function showPage(pageId) {
    // Seiten umschalten
    pages.forEach(p => p.classList.remove('page--active'));
    const target = document.getElementById(`page-${pageId}`);
    if (target) target.classList.add('page--active');

    // Nav-Buttons aktualisieren
    navBtns.forEach(btn => btn.classList.toggle('active', btn.dataset.page === pageId));

    // Daten laden (jeweils einmal beim ersten Besuch, danach bei Rankings/Vorschlägen neu)
    if (pageId === 'bewertung' && !loaded.bewertung) {
      loaded.bewertung = true;
      window.bewertungModule.load();
    }

    if (pageId === 'ranking') {
      window.rankingModule.load();
      loaded.ranking = true;
    }

    if (pageId === 'vorschlaege' && !loaded.vorschlaege) {
      loaded.vorschlaege = true;
      window.vorschlaegeModule.load();
    }

    // URL-Hash aktualisieren (schöner für Bookmarks)
    history.replaceState(null, '', `#${pageId}`);
  }

  // ── Events ───────────────────────────────────────────────
  navBtns.forEach(btn => {
    btn.addEventListener('click', () => showPage(btn.dataset.page));
  });

  // ── Fußzeilen-Jahr ───────────────────────────────────────
  const footerYear = document.getElementById('footer-year');
  if (footerYear) footerYear.textContent = new Date().getFullYear();

  // ── Start ─────────────────────────────────────────────────
  // Hash-basiertes Routing beim Laden
  const hash = window.location.hash.replace('#', '');
  const validPages = ['bewertung', 'ranking', 'vorschlaege'];
  const startPage  = validPages.includes(hash) ? hash : 'bewertung';

  showPage(startPage);

})();
