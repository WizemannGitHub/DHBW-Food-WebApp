(function vorschlaegeModule() {

  const form        = document.getElementById('proposal-form');
  const nameInput   = document.getElementById('prop-name');
  const catInput    = document.getElementById('prop-category');
  const descInput   = document.getElementById('prop-description');
  const reasonInput = document.getElementById('prop-reason');
  const successMsg  = document.getElementById('proposal-feedback');
  const errorMsg    = document.getElementById('proposal-error');
  const loading     = document.getElementById('proposals-loading');
  const errorEl     = document.getElementById('proposals-error');
  const listEl      = document.getElementById('proposals-list');
  const countBadge  = document.getElementById('proposals-count');

  // ── Vorschläge laden ───────────────────────────────────────

  async function loadProposals() {
    loading.classList.remove('hidden');
    errorEl.classList.add('hidden');
    listEl.classList.add('hidden');
    try {
      const proposals = await api.getProposals();
      countBadge.textContent = proposals.length;
      renderProposals(proposals);
    } catch (err) {
      console.error(err);
      loading.classList.add('hidden');
      errorEl.classList.remove('hidden');
    }
  }

  function renderProposals(proposals) {
    loading.classList.add('hidden');

    if (!proposals || proposals.length === 0) {
      listEl.innerHTML = `<div class="empty-state"><div class="empty-state__icon">💡</div><div class="empty-state__text">Noch keine Vorschläge – sei der Erste!</div></div>`;
      listEl.classList.remove('hidden');
      return;
    }

    listEl.innerHTML = proposals.map(p => {
      const date = p.erstellt_am
        ? new Date(p.erstellt_am).toLocaleDateString('de-DE', { day: '2-digit', month: '2-digit', year: 'numeric' })
        : '';
      return `
        <div class="proposal-card">
          <div class="proposal-card__header">
            <div class="proposal-card__name">${escHtml(p.name)}</div>
            <span class="proposal-card__tag tag--${p.kategorie || 'default'}">${escHtml(p.kategorie || 'Sonstiges')}</span>
          </div>
          ${p.beschreibung ? `<div class="proposal-card__description">${escHtml(p.beschreibung)}</div>` : ''}
          ${p.begruendung  ? `<div class="proposal-card__reason"><em>„${escHtml(p.begruendung)}"</em></div>` : ''}
          ${date           ? `<div class="proposal-card__date">📅 ${date}</div>` : ''}
        </div>`;
    }).join('');

    listEl.classList.remove('hidden');
  }

  // ── Formular absenden ──────────────────────────────────────

  form.addEventListener('submit', async e => {
    e.preventDefault();
    successMsg.classList.add('hidden');
    errorMsg.classList.add('hidden');

    // Validierung
    document.getElementById('err-name').textContent     = '';
    document.getElementById('err-category').textContent = '';
    if (!nameInput.value.trim()) {
      document.getElementById('err-name').textContent = 'Bitte einen Gerichtsnamen eingeben.';
      nameInput.focus();
      return;
    }
    if (!catInput.value) {
      document.getElementById('err-category').textContent = 'Bitte eine Kategorie auswählen.';
      catInput.focus();
      return;
    }

    const submitBtn = form.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Wird eingereicht…';
    try {
      await api.postProposal({
        name:         nameInput.value.trim(),
        kategorie:    catInput.value,
        beschreibung: descInput.value.trim() || null,
        begruendung:  reasonInput.value.trim() || null,
      });
      successMsg.classList.remove('hidden');
      form.reset();
      loadProposals();
    } catch (err) {
      console.error(err);
      errorMsg.classList.remove('hidden');
    } finally {
      submitBtn.disabled = false;
      submitBtn.textContent = 'Vorschlag einreichen ✓';
    }
  });

  window.vorschlaegeModule = { load: loadProposals };

})();
