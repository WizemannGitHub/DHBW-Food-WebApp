/**
 * ranking.js – Logik für Seite 2: Rankings & Statistiken
 */

(function rankingModule() {

  // ── DOM-Referenzen ───────────────────────────────────────
  const loading      = document.getElementById('ranking-loading');
  const error        = document.getElementById('ranking-error');
  const list         = document.getElementById('ranking-list');
  const statsGrid    = document.getElementById('stats-grid');
  const distSection  = document.getElementById('distribution-section');
  const distChart    = document.getElementById('rating-distribution');
  const filterBtns   = document.querySelectorAll('.filter-btn');

  // Statistik-Felder
  const statTotal    = document.getElementById('stat-total-ratings');
  const statAvg      = document.getElementById('stat-avg-score');
  const statDishes   = document.getElementById('stat-dishes-count');
  const statProposals = document.getElementById('stat-proposals');

  let currentFilter = 'top';

  // ── Rankings laden ───────────────────────────────────────
  async function loadRankings(filter = 'top') {
    currentFilter = filter;
    loading.classList.remove('hidden');
    error.classList.add('hidden');
    list.classList.add('hidden');

    try {
      const data = await api.getRankings(filter);
      renderRankings(data);
    } catch (err) {
      console.error('Rankings laden fehlgeschlagen:', err);
      loading.classList.add('hidden');
      error.classList.remove('hidden');
    }
  }

  // ── Statistiken laden ────────────────────────────────────
  async function loadStats() {
    try {
      const stats = await api.getStats();
      statTotal.textContent     = stats.total_ratings ?? '–';
      statAvg.textContent       = stats.avg_score ? parseFloat(stats.avg_score).toFixed(1) : '–';
      statDishes.textContent    = stats.rated_dishes ?? '–';
      statProposals.textContent = stats.total_proposals ?? '–';
      statsGrid.classList.remove('hidden');

      // Verteilungs-Chart
      if (stats.distribution) {
        renderDistribution(stats.distribution);
        distSection.classList.remove('hidden');
      }
    } catch (err) {
      console.error('Statistiken laden fehlgeschlagen:', err);
    }
  }

  // ── Rankings rendern ─────────────────────────────────────
  function renderRankings(items) {
    loading.classList.add('hidden');

    if (!items || items.length === 0) {
      list.innerHTML = `
        <div class="empty-state">
          <div class="empty-state__icon">📊</div>
          <div class="empty-state__text">Noch keine Daten vorhanden.</div>
        </div>`;
      list.classList.remove('hidden');
      return;
    }

    const MEDAL = ['🥇', '🥈', '🥉'];
    const RANK_CLASS = ['ranking-item--gold', 'ranking-item--silver', 'ranking-item--bronze'];

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

    list.innerHTML = items.map((item, idx) => {
      const rankClass = idx < 3 ? RANK_CLASS[idx] : '';
      const emoji     = CATEGORY_EMOJI[item.kategorie] || CATEGORY_EMOJI.default;
      const score     = parseFloat(item.avg_rating || 0).toFixed(1);
      const count     = item.rating_count || 0;
      const stars     = starsFromScore(parseFloat(score));
      const pos       = idx < 3 ? MEDAL[idx] : `#${idx + 1}`;

      return `
        <div class="ranking-item ${rankClass}">
          <div class="ranking-item__pos">${pos}</div>
          <div class="ranking-item__emoji">${emoji}</div>
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

  // ── Sterne aus Score ─────────────────────────────────────
  function starsFromScore(score) {
    const full  = Math.round(score);
    const empty = 5 - full;
    return '★'.repeat(Math.max(0, full)) + '☆'.repeat(Math.max(0, empty));
  }

  // ── Verteilungs-Chart rendern ────────────────────────────
  function renderDistribution(distribution) {
    // distribution = { "1": 3, "2": 5, "3": 12, "4": 28, "5": 45 }
    const max = Math.max(1, ...Object.values(distribution));
    const labels = { '5': '5 ★', '4': '4 ★', '3': '3 ★', '2': '2 ★', '1': '1 ★' };

    distChart.innerHTML = ['5','4','3','2','1'].map(star => {
      const count   = distribution[star] || 0;
      const pct     = Math.round((count / max) * 100);
      return `
        <div class="bar-chart__row">
          <div class="bar-chart__label">${labels[star]}</div>
          <div class="bar-chart__track">
            <div class="bar-chart__fill" style="width: ${pct}%"></div>
          </div>
          <div class="bar-chart__count">${count}</div>
        </div>`;
    }).join('');
  }

  // ── Filter-Buttons ───────────────────────────────────────
  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      loadRankings(btn.dataset.filter);
    });
  });

  // ── Öffentliche Schnittstelle für app.js ─────────────────
  window.rankingModule = {
    load() {
      loadRankings(currentFilter);
      loadStats();
    },
  };

})();
