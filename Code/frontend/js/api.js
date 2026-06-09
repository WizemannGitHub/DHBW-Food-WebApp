const API_BASE = window.DHBW_API_URL || 'http://localhost:3000/api';

function todayStr() {
  const d = new Date();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${d.getFullYear()}-${m}-${day}`;
}

// Holt den Tagesplan von der Mensa-API (über unseren Backend-Proxy)
// Gibt ein Array von Kantinen zurück: [{ id, name, meals: [...] }]
const mensaApi = {
  async getDishes() {
    const res = await fetch(`${API_BASE}/mensa-plan/${todayStr()}`);
    if (!res.ok) throw new Error(`Mensa-Proxy HTTP ${res.status}`);
    const json = await res.json();

    if (!json.success || !Array.isArray(json.data)) return [];

    const canteens = [];
    const allMeals = [];

    for (const entry of json.data) {
      const meals = [];
      for (const line of entry.lines) {
        for (const meal of line.meals) {
          if (!meal.price) continue; // Infotexte ohne Preis überspringen
          const parsed = {
            name:      meal.name,
            kategorie: toKategorie(meal.classifiers),
            preis:     parsePreis(meal.price),
          };
          meals.push(parsed);
          allMeals.push(parsed);
        }
      }
      if (meals.length > 0) {
        canteens.push({ id: entry.canteen.id, name: entry.canteen.name, meals });
      }
    }

    // Gerichte in DB speichern und echte IDs holen
    try {
      const syncRes = await fetch(`${API_BASE}/mensa-dishes/sync`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(allMeals),
      });
      if (syncRes.ok) {
        const nameToId = await syncRes.json();
        for (const canteen of canteens) {
          for (const meal of canteen.meals) {
            meal.id = nameToId[meal.name] ?? meal.name;
          }
        }
      }
    } catch (e) {
      console.warn('Sync mit DB fehlgeschlagen, Bewertungen nicht möglich:', e);
    }

    return canteens;
  },
};

function toKategorie(classifiers) {
  if (!classifiers || !classifiers.length) return 'fleisch';
  const c = classifiers.map(x => x.toUpperCase());
  if (c.includes('VG'))  return 'vegan';
  if (c.includes('VEG')) return 'vegetarisch';
  return 'fleisch';
}

function parsePreis(str) {
  if (!str) return null;
  const n = parseFloat(str.replace(',', '.').replace(/[^\d.]/g, ''));
  return isNaN(n) ? null : n;
}

// REST-API für Bewertungen, Rankings, Stats und Vorschläge
const api = {
  async getDishes() {
    const res = await fetch(`${API_BASE}/dishes`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  async postRating(dishId, payload) {
    const res = await fetch(`${API_BASE}/ratings`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ dish_id: dishId, ...payload }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  async getRankings(filter = 'top') {
    const res = await fetch(`${API_BASE}/rankings?filter=${filter}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  async getStats() {
    const res = await fetch(`${API_BASE}/stats`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  async getProposals() {
    const res = await fetch(`${API_BASE}/proposals`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  async postProposal(payload) {
    const res = await fetch(`${API_BASE}/proposals`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },
};
