(function rankingModule() {

  const loading     = document.getElementById('ranking-loading');
  const error       = document.getElementById('ranking-error');
  const list        = document.getElementById('ranking-list');
  const statsGrid   = document.getElementById('stats-grid');
  const distSection = document.getElementById('distribution-section');
  const distChart   = document.getElementById('rating-distribution');
  const filterBtns  = document.querySelectorAll('.filter-btn');

  const statTotal     = document.getElementById('stat-total-ratings');
  const statAvg       = document.getElementById('stat-avg-score');
  const statDishes    = document.getElementById('stat-dishes-count');
  const statProposals = document.getElementById('stat-proposals');

  let currentFilter = 'top';

  async function loadRankings(filter = 'top') {
    currentFilter = filter;
    loading.classList.remove('hidden');
    error.classList.add('hidden');
    list.classList.add('hidden');
    try {
      renderRankings(await api.getRankings(filter));
    } catch (err) {
      console.error(err);
      loading.classList.add('hidden');
      error.classList.remove('hidden');
    }
  }

  async function loadStats() {
    try {
      const stats = await api.getStats();
      statTotal.textContent     = stats.total_ratings ?? '–';
      statAvg.textContent       = stats.avg_score ? parseFloat(stats.avg_score).toFixed(1) : '–';
      statDishes.textContent    = stats.rated_dishes ?? '–';
      statProposals.textContent = stats.total_proposals ?? '–';
      statsGrid.classList.remove('hidden');
      if (stats.distribution) {
        renderDistribution(stats.distribution);
        distSection.classList.remove('hidden');
      }
    } catch (err) {
      console.error(err);
    }
  }

  function renderRankings(items) {
    loading.classList.add('hidden');

    if (!items || items.length === 0) {
      list.innerHTML = `<div class="empty-state"><div class="empty-state__icon">📊</div><div class="empty-state__text">Noch keine Daten vorhanden.</div></div>`;
      list.classList.remove('hidden');
      return;
    }

    const MEDAL      = ['🥇', '🥈', '🥉'];
    const RANK_CLASS = ['ranking-item--gold', 'ranking-item--silver', 'ranking-item--bronze'];
    const EMOJI      = {
      fleisch: '🥩', vegetarisch: '🥗', vegan: '🌱',
      pasta: '🍝', salat: '🥙', suppe: '🍲', dessert: '🍰', default: '🍽',
    };

    list.innerHTML = items.map((item, idx) => {
      const score = parseFloat(item.avg_rating || 0).toFixed(1);
      const count = item.rating_count || 0;
      const stars = '★'.repeat(Math.max(0, Math.round(parseFloat(score)))) + '☆'.repeat(Math.max(0, 5 - Math.round(parseFloat(score))));
      return `
        <div class="ranking-item ${idx < 3 ? RANK_CLASS[idx] : ''}">
          <div class="ranking-item__pos">${idx < 3 ? MEDAL[idx] : `#${idx + 1}`}</div>
          <div class="ranking-item__emoji">${EMOJI[item.kategorie] || EMOJI.default}</div>
          <div class="ranking-item__info">
            <div class="ranking-item__name">${escHtml(item.name)}</div>
            <div class="ranking-item__category">${escHtml(item.kategorie || '')}</div>
          </div>
          <div class="ranking-item__score">
            <span class="score-value">${score}</span>
            <div class="score-stars">${stars}</div>
            <div class="score-count">${count} Stimme${count !== 1 ? 'n' : ''}</div>
          </div>
        </div>`;
    }).join('');

    list.classList.remove('hidden');
  }

  function renderDistribution(distribution) {
    const max = Math.max(1, ...Object.values(distribution));
    distChart.innerHTML = ['5','4','3','2','1'].map(star => {
      const count = distribution[star] || 0;
      return `
        <div class="bar-chart__row">
          <div class="bar-chart__label">${star} ★</div>
          <div class="bar-chart__track"><div class="bar-chart__fill" style="width:${Math.round((count/max)*100)}%"></div></div>
          <div class="bar-chart__count">${count}</div>
        </div>`;
    }).join('');
  }

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      loadRankings(btn.dataset.filter);
    });
  });

  window.rankingModule = {
    load() { loadRankings(currentFilter); loadStats(); },
  };

})();
