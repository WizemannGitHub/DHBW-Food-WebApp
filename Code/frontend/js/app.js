(function app() {

  const pages   = document.querySelectorAll('.page');
  const navBtns = document.querySelectorAll('.nav__btn');
  const loaded  = { bewertung: false, ranking: false, vorschlaege: false };

  function showPage(pageId) {
    pages.forEach(p => p.classList.remove('page--active'));
    const target = document.getElementById(`page-${pageId}`);
    if (target) target.classList.add('page--active');

    navBtns.forEach(btn => btn.classList.toggle('active', btn.dataset.page === pageId));

    if (pageId === 'bewertung' && !loaded.bewertung) {
      loaded.bewertung = true;
      window.bewertungModule.load();
    }
    if (pageId === 'ranking') {
      window.rankingModule.load();
    }
    if (pageId === 'vorschlaege' && !loaded.vorschlaege) {
      loaded.vorschlaege = true;
      window.vorschlaegeModule.load();
    }

    history.replaceState(null, '', `#${pageId}`);
  }

  navBtns.forEach(btn => btn.addEventListener('click', () => showPage(btn.dataset.page)));

  // Feature-Card-Buttons auf der Startseite
  document.querySelectorAll('[data-page]').forEach(el => {
    if (el.tagName === 'BUTTON' && !el.classList.contains('nav__btn')) {
      el.addEventListener('click', () => showPage(el.dataset.page));
    }
  });

  document.getElementById('footer-year').textContent = new Date().getFullYear();

  const hash = window.location.hash.replace('#', '');
  showPage(['start', 'bewertung', 'ranking', 'vorschlaege'].includes(hash) ? hash : 'start');

})();
