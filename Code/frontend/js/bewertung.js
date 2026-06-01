(function bewertungModule() {

  let allCanteens = [];
  let selectedIds = new Set(); // leere Menge = alle anzeigen

  const ratings = { gesamt: 0, geschmack: 0, portion: 0 };
  let activeDishId = null;

  const EMOJI = {
    fleisch: '🥩', vegetarisch: '🥗', vegan: '🌱',
    pasta: '🍝', salat: '🥙', suppe: '🍲', dessert: '🍰', default: '🍽',
  };

  // DOM-Elemente
  const loading     = document.getElementById('bewertung-loading');
  const errorEl     = document.getElementById('bewertung-error');
  const container   = document.getElementById('dishes-container');
  const filterBar   = document.getElementById('canteen-filter');
  const modal       = document.getElementById('rating-modal');
  const modalName   = document.getElementById('modal-dish-name');
  const modalCat    = document.getElementById('modal-dish-category');
  const submitBtn   = document.getElementById('submit-rating');
  const feedback    = document.getElementById('rating-feedback');
  const commentArea = document.getElementById('modal-comment');

  // ── Laden ──────────────────────────────────────────────────

  async function loadDishes() {
    loading.classList.remove('hidden');
    errorEl.classList.add('hidden');
    container.classList.add('hidden');
    filterBar.classList.add('hidden');
    try {
      allCanteens = await mensaApi.getDishes();
      renderFilterBar();
      renderDishes();
    } catch (err) {
      console.error('Mensa-API Fehler:', err);
      loading.classList.add('hidden');
      errorEl.classList.remove('hidden');
    }
  }

  // ── Kantinenfilter ─────────────────────────────────────────

  function renderFilterBar() {
    if (allCanteens.length === 0) return;

    filterBar.innerHTML = allCanteens.map(c =>
      `<button class="filter-btn filter-btn--canteen" data-canteen="${escHtml(c.id)}">${escHtml(c.name)}</button>`
    ).join('');

    filterBar.querySelectorAll('.filter-btn--canteen').forEach(btn => {
      btn.addEventListener('click', () => {
        const id = btn.dataset.canteen;
        if (selectedIds.has(id)) {
          selectedIds.delete(id);
          btn.classList.remove('active');
        } else {
          selectedIds.add(id);
          btn.classList.add('active');
        }
        renderDishes();
      });
    });

    filterBar.classList.remove('hidden');
  }

  // ── Gerichte anzeigen ──────────────────────────────────────

  function renderDishes() {
    loading.classList.add('hidden');

    // Nichts ausgewählt = alle Kantinen zeigen
    const visible = selectedIds.size === 0
      ? allCanteens
      : allCanteens.filter(c => selectedIds.has(c.id));

    if (visible.length === 0) {
      container.innerHTML = `<div class="empty-state"><div class="empty-state__icon">🍽</div><div class="empty-state__text">Heute keine Gerichte verfügbar.</div></div>`;
      container.classList.remove('hidden');
      return;
    }

    container.innerHTML = visible.map(canteen => `
      <div class="canteen-section">
        <h3 class="canteen-section__title">${escHtml(canteen.name)}</h3>
        <div class="canteen-section__grid">
          ${canteen.meals.map(dish => dishCardHtml(dish)).join('')}
        </div>
      </div>
    `).join('');

    container.querySelectorAll('.dish-card').forEach(card => {
      card.addEventListener('click', () =>
        openModal(card.dataset.id, card.dataset.name, card.dataset.category)
      );
    });

    container.classList.remove('hidden');
  }

  function dishCardHtml(dish) {
    const emoji = EMOJI[dish.kategorie] || EMOJI.default;
    const preis = dish.preis ? `${parseFloat(dish.preis).toFixed(2)} €` : '';
    return `
      <div class="dish-card" data-id="${dish.id}" data-name="${escHtml(dish.name)}" data-category="${escHtml(dish.kategorie || '')}">
        <div class="dish-card__thumb">${emoji}</div>
        <div class="dish-card__body">
          <div class="dish-card__category">${escHtml(dish.kategorie || 'Gericht')}</div>
          <div class="dish-card__name">${escHtml(dish.name)}</div>
          ${preis ? `<div class="dish-card__price">${preis}</div>` : ''}
          <button class="btn btn--primary btn--full">Jetzt bewerten</button>
        </div>
      </div>`;
  }

  // ── Bewertungs-Modal ───────────────────────────────────────

  function openModal(dishId, dishName, category) {
    activeDishId = dishId;
    ratings.gesamt = ratings.geschmack = ratings.portion = 0;
    commentArea.value = '';
    feedback.classList.add('hidden');
    document.querySelectorAll('.star-row .star').forEach(s => s.classList.remove('active'));
    modalName.textContent = dishName;
    modalCat.textContent  = category || '';
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';
  }

  function closeModal() {
    modal.classList.add('hidden');
    document.body.style.overflow = '';
    activeDishId = null;
  }

  function initStarRows() {
    document.querySelectorAll('.star-row').forEach(row => {
      const field = row.dataset.field;
      const stars = row.querySelectorAll('.star');
      stars.forEach(star => {
        star.addEventListener('mouseenter', () =>
          stars.forEach(s => s.classList.toggle('active', +s.dataset.val <= +star.dataset.val))
        );
        star.addEventListener('mouseleave', () =>
          stars.forEach(s => s.classList.toggle('active', +s.dataset.val <= ratings[field]))
        );
        star.addEventListener('click', () => {
          ratings[field] = +star.dataset.val;
          stars.forEach(s => s.classList.toggle('active', +s.dataset.val <= ratings[field]));
        });
      });
    });
  }

  async function submitRating() {
    if (ratings.gesamt === 0) {
      alert('Bitte mindestens den Gesamteindruck bewerten.');
      return;
    }
    submitBtn.disabled = true;
    submitBtn.textContent = 'Wird gesendet…';
    try {
      await api.postRating(activeDishId, {
        gesamt:    ratings.gesamt,
        geschmack: ratings.geschmack || null,
        portion:   ratings.portion   || null,
        kommentar: commentArea.value.trim() || null,
      });
      feedback.classList.remove('hidden');
      submitBtn.textContent = 'Bewertet ✓';
      submitBtn.style.background = 'var(--color-success)';
      setTimeout(() => {
        closeModal();
        submitBtn.disabled = false;
        submitBtn.textContent = 'Bewertung abschicken';
        submitBtn.style.background = '';
        loadDishes();
      }, 1500);
    } catch (err) {
      console.error(err);
      alert('Fehler beim Senden. Bitte erneut versuchen.');
      submitBtn.disabled = false;
      submitBtn.textContent = 'Bewertung abschicken';
    }
  }

  // ── Event Listener ─────────────────────────────────────────

  document.getElementById('modal-close').addEventListener('click', closeModal);
  modal.querySelector('.modal__backdrop').addEventListener('click', closeModal);
  submitBtn.addEventListener('click', submitRating);
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && !modal.classList.contains('hidden')) closeModal();
  });

  initStarRows();
  window.bewertungModule = { load: loadDishes };

})();
