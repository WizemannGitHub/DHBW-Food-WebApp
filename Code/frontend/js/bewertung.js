(function bewertungModule() {

  let activeDishId = null;

  const ratings = { gesamt: 0, geschmack: 0, portion: 0 };

  const loading     = document.getElementById('bewertung-loading');
  const error       = document.getElementById('bewertung-error');
  const container   = document.getElementById('dishes-container');
  const modal       = document.getElementById('rating-modal');
  const modalClose  = document.getElementById('modal-close');
  const modalName   = document.getElementById('modal-dish-name');
  const modalCat    = document.getElementById('modal-dish-category');
  const submitBtn   = document.getElementById('submit-rating');
  const feedback    = document.getElementById('rating-feedback');
  const commentArea = document.getElementById('modal-comment');

  const EMOJI = {
    fleisch: '🥩', vegetarisch: '🥗', vegan: '🌱',
    pasta: '🍝', salat: '🥙', suppe: '🍲', dessert: '🍰', default: '🍽',
  };

  async function loadDishes() {
    loading.classList.remove('hidden');
    error.classList.add('hidden');
    container.classList.add('hidden');
    try {
      renderDishes(await api.getDishes());
    } catch (err) {
      console.error(err);
      loading.classList.add('hidden');
      error.classList.remove('hidden');
    }
  }

  function renderDishes(dishes) {
    loading.classList.add('hidden');

    if (!dishes || dishes.length === 0) {
      container.innerHTML = `<div class="empty-state"><div class="empty-state__icon">🍽</div><div class="empty-state__text">Heute sind keine Gerichte verfügbar.</div></div>`;
      container.classList.remove('hidden');
      return;
    }

    container.innerHTML = dishes.map(dish => {
      const emoji    = EMOJI[dish.kategorie] || EMOJI.default;
      const stars    = renderStars(dish.avg_rating || 0);
      const count    = dish.rating_count || 0;
      const priceStr = dish.preis ? `${parseFloat(dish.preis).toFixed(2)} €` : '';
      return `
        <div class="dish-card" data-id="${dish.id}" data-name="${escHtml(dish.name)}" data-category="${escHtml(dish.kategorie || '')}">
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
    container.querySelectorAll('.dish-card').forEach(card => {
      card.addEventListener('click', () => openModal(card.dataset.id, card.dataset.name, card.dataset.category));
    });
  }

  function renderStars(avg) {
    const full  = Math.floor(avg);
    const half  = avg - full >= 0.5 ? 1 : 0;
    const empty = 5 - full - half;
    return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(empty);
  }

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
        star.addEventListener('mouseenter', () => stars.forEach(s => s.classList.toggle('active', +s.dataset.val <= +star.dataset.val)));
        star.addEventListener('mouseleave', () => stars.forEach(s => s.classList.toggle('active', +s.dataset.val <= ratings[field])));
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

  modalClose.addEventListener('click', closeModal);
  modal.querySelector('.modal__backdrop').addEventListener('click', closeModal);
  submitBtn.addEventListener('click', submitRating);
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && !modal.classList.contains('hidden')) closeModal();
  });

  initStarRows();
  window.bewertungModule = { load: loadDishes };

})();
