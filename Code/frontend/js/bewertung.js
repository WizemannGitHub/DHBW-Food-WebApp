/**
 * bewertung.js – Logik für Seite 1: Gerichte bewerten
 */

(function bewertungModule() {

  // ── State ────────────────────────────────────────────────
  let activeDishId   = null;
  let activeDishName = null;

  const ratings = {
    gesamt:    0,
    geschmack: 0,
    portion:   0,
  };

  // ── DOM-Referenzen ───────────────────────────────────────
  const loading      = document.getElementById('bewertung-loading');
  const error        = document.getElementById('bewertung-error');
  const container    = document.getElementById('dishes-container');
  const modal        = document.getElementById('rating-modal');
  const modalClose   = document.getElementById('modal-close');
  const modalDishName = document.getElementById('modal-dish-name');
  const modalDishCat  = document.getElementById('modal-dish-category');
  const submitBtn    = document.getElementById('submit-rating');
  const feedback     = document.getElementById('rating-feedback');
  const commentArea  = document.getElementById('modal-comment');

  // ── Emoji-Map nach Kategorie ─────────────────────────────
  const CATEGORY_EMOJI = {
    fleisch:      '🥩',
    vegetarisch:  '🥗',
    vegan:        '🌱',
    pasta:        '🍝',
    salat:        '🥙',
    suppe:        '🍲',
    dessert:      '🍰',
    default:      '🍽',
  };

  // ── Gerichte laden ───────────────────────────────────────
  async function loadDishes() {
    loading.classList.remove('hidden');
    error.classList.add('hidden');
    container.classList.add('hidden');

    try {
      const dishes = await api.getDishes();
      renderDishes(dishes);
    } catch (err) {
      console.error('Gerichte laden fehlgeschlagen:', err);
      loading.classList.add('hidden');
      error.classList.remove('hidden');
    }
  }

  // ── Gerichte rendern ─────────────────────────────────────
  function renderDishes(dishes) {
    loading.classList.add('hidden');

    if (!dishes || dishes.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state__icon">🍽</div>
          <div class="empty-state__text">Heute sind keine Gerichte verfügbar.</div>
        </div>`;
      container.classList.remove('hidden');
      return;
    }

    container.innerHTML = dishes.map(dish => {
      const emoji    = CATEGORY_EMOJI[dish.kategorie] || CATEGORY_EMOJI.default;
      const stars    = renderStarDisplay(dish.avg_rating || 0);
      const count    = dish.rating_count || 0;
      const priceStr = dish.preis ? `${parseFloat(dish.preis).toFixed(2)} €` : '';

      return `
        <div class="dish-card" data-id="${dish.id}" data-name="${escHtml(dish.name)}"
             data-category="${escHtml(dish.kategorie || '')}">
          <div class="dish-card__thumb">${emoji}</div>
          <div class="dish-card__body">
            <div class="dish-card__category">${escHtml(dish.kategorie || 'Gericht')}</div>
            <div class="dish-card__name">${escHtml(dish.name)}</div>
            <div class="dish-card__meta">
              <span class="dish-card__stars">${stars}</span>
              <span class="dish-card__count">${count} Bewertung${count !== 1 ? 'en' : ''}</span>
            </div>
            ${priceStr ? `<div class="dish-card__price">${priceStr}</div>` : ''}
            <button class="btn btn--primary btn--full">Jetzt bewerten</button>
          </div>
        </div>`;
    }).join('');

    container.classList.remove('hidden');

    // Click-Events auf alle Karten
    container.querySelectorAll('.dish-card').forEach(card => {
      card.addEventListener('click', () => openModal(
        card.dataset.id,
        card.dataset.name,
        card.dataset.category
      ));
    });
  }

  // ── Sterne-Anzeige (schreibgeschützt) ───────────────────
  function renderStarDisplay(avg) {
    const full  = Math.floor(avg);
    const half  = avg - full >= 0.5 ? 1 : 0;
    const empty = 5 - full - half;
    return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(empty);
  }

  // ── Modal öffnen ─────────────────────────────────────────
  function openModal(dishId, dishName, category) {
    activeDishId   = dishId;
    activeDishName = dishName;

    // Reset
    ratings.gesamt    = 0;
    ratings.geschmack = 0;
    ratings.portion   = 0;
    commentArea.value = '';
    feedback.classList.add('hidden');
    resetAllStars();

    modalDishName.textContent = dishName;
    modalDishCat.textContent  = category || '';
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';
  }

  // ── Modal schließen ──────────────────────────────────────
  function closeModal() {
    modal.classList.add('hidden');
    document.body.style.overflow = '';
    activeDishId = null;
  }

  // ── Star-Rows initialisieren ─────────────────────────────
  function initStarRows() {
    document.querySelectorAll('.star-row').forEach(row => {
      const field = row.dataset.field;
      const stars = row.querySelectorAll('.star');

      stars.forEach(star => {
        star.addEventListener('mouseenter', () => highlightStars(stars, +star.dataset.val));
        star.addEventListener('mouseleave', () => highlightStars(stars, ratings[field]));
        star.addEventListener('click', () => {
          ratings[field] = +star.dataset.val;
          highlightStars(stars, ratings[field]);
        });
      });
    });
  }

  function highlightStars(stars, value) {
    stars.forEach(s => {
      s.classList.toggle('active', +s.dataset.val <= value);
    });
  }

  function resetAllStars() {
    document.querySelectorAll('.star-row').forEach(row => {
      const stars = row.querySelectorAll('.star');
      stars.forEach(s => s.classList.remove('active'));
    });
  }

  // ── Bewertung abschicken ─────────────────────────────────
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

      // Modal nach kurzer Pause schließen & Gerichte neu laden
      setTimeout(() => {
        closeModal();
        submitBtn.disabled = false;
        submitBtn.textContent = 'Bewertung abschicken';
        submitBtn.style.background = '';
        loadDishes();
      }, 1500);

    } catch (err) {
      console.error('Bewertung senden fehlgeschlagen:', err);
      alert('Fehler beim Senden der Bewertung. Bitte versuche es erneut.');
      submitBtn.disabled = false;
      submitBtn.textContent = 'Bewertung abschicken';
    }
  }

  // ── Events ───────────────────────────────────────────────
  modalClose.addEventListener('click', closeModal);
  modal.querySelector('.modal__backdrop').addEventListener('click', closeModal);
  submitBtn.addEventListener('click', submitRating);

  // ESC-Taste
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && !modal.classList.contains('hidden')) closeModal();
  });

  // ── Init ─────────────────────────────────────────────────
  initStarRows();

  // Öffentliche Schnittstelle für app.js
  window.bewertungModule = { load: loadDishes };

})();
