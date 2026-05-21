/**
 * vorschlaege.js – Logik für Seite 3: Essensvorschläge
 */

(function vorschlaegeModule() {

  // ── DOM-Referenzen ───────────────────────────────────────
  const form         = document.getElementById('proposal-form');
  const propName     = document.getElementById('prop-name');
  const propCategory = document.getElementById('prop-category');
  const propDesc     = document.getElementById('prop-description');
  const propReason   = document.getElementById('prop-reason');
  const submitFeedback = document.getElementById('proposal-feedback');
  const submitError    = document.getElementById('proposal-error');
  const loading        = document.getElementById('proposals-loading');
  const errorEl        = document.getElementById('proposals-error');
  const listEl         = document.getElementById('proposals-list');
  const countBadge     = document.getElementById('proposals-count');

  // Fehlerfelder
  const errName     = document.getElementById('err-name');
  const errCategory = document.getElementById('err-category');

  // ── Vorschläge laden ─────────────────────────────────────
  async function loadProposals() {
    loading.classList.remove('hidden');
    errorEl.classList.add('hidden');
    listEl.classList.add('hidden');

    try {
      const proposals = await api.getProposals();
      countBadge.textContent = proposals.length;
      renderProposals(proposals);
    } catch (err) {
      console.error('Vorschläge laden fehlgeschlagen:', err);
      loading.classList.add('hidden');
      errorEl.classList.remove('hidden');
    }
  }

  // ── Vorschläge rendern ───────────────────────────────────
  function renderProposals(proposals) {
    loading.classList.add('hidden');

    if (!proposals || proposals.length === 0) {
      listEl.innerHTML = `
        <div class="empty-state">
          <div class="empty-state__icon">💡</div>
          <div class="empty-state__text">
            Noch keine Vorschläge – sei der Erste!
          </div>
        </div>`;
      listEl.classList.remove('hidden');
      return;
    }

    listEl.innerHTML = proposals.map(p => {
      const tagClass = `tag--${p.kategorie || 'default'}`;
      const date     = p.erstellt_am ? formatDate(p.erstellt_am) : '';

      return `
        <div class="proposal-card">
          <div class="proposal-card__header">
            <div class="proposal-card__name">${escHtml(p.name)}</div>
            <span class="proposal-card__tag ${tagClass}">
              ${escHtml(p.kategorie || 'Sonstiges')}
            </span>
          </div>
          ${p.beschreibung
            ? `<div class="proposal-card__description">${escHtml(p.beschreibung)}</div>`
            : ''}
          ${p.begruendung
            ? `<div class="proposal-card__reason"><em>„${escHtml(p.begruendung)}"</em></div>`
            : ''}
          ${date ? `<div class="proposal-card__date">📅 ${date}</div>` : ''}
        </div>`;
    }).join('');

    listEl.classList.remove('hidden');
  }

  // ── Datum formatieren ────────────────────────────────────
  function formatDate(isoString) {
    try {
      return new Date(isoString).toLocaleDateString('de-DE', {
        day: '2-digit', month: '2-digit', year: 'numeric',
      });
    } catch {
      return '';
    }
  }

  // ── Formular validieren ──────────────────────────────────
  function validate() {
    let valid = true;

    errName.textContent     = '';
    errCategory.textContent = '';

    if (!propName.value.trim()) {
      errName.textContent = 'Bitte einen Gerichtsnamen eingeben.';
      propName.focus();
      valid = false;
    }

    if (!propCategory.value) {
      errCategory.textContent = 'Bitte eine Kategorie auswählen.';
      if (valid) propCategory.focus();
      valid = false;
    }

    return valid;
  }

  // ── Formular absenden ────────────────────────────────────
  form.addEventListener('submit', async e => {
    e.preventDefault();
    submitFeedback.classList.add('hidden');
    submitError.classList.add('hidden');

    if (!validate()) return;

    const submitBtn = form.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Wird eingereicht…';

    try {
      await api.postProposal({
        name:         propName.value.trim(),
        kategorie:    propCategory.value,
        beschreibung: propDesc.value.trim() || null,
        begruendung:  propReason.value.trim() || null,
      });

      submitFeedback.classList.remove('hidden');
      form.reset();
      loadProposals();

    } catch (err) {
      console.error('Vorschlag einreichen fehlgeschlagen:', err);
      submitError.classList.remove('hidden');
    } finally {
      submitBtn.disabled = false;
      submitBtn.textContent = 'Vorschlag einreichen ✓';
    }
  });

  // ── Öffentliche Schnittstelle ────────────────────────────
  window.vorschlaegeModule = { load: loadProposals };

})();
