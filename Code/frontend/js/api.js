/**
 * api.js – zentrales Modul für alle Backend-Requests
 * Basis-URL wird aus dem Window-Objekt gelesen, damit
 * sie über die Docker-Umgebung konfigurierbar ist.
 */

const API_BASE = window.DHBW_API_URL || 'http://localhost:3000/api';

const api = {
  /**
   * Heutige Gerichte abrufen
   */
  async getDishes() {
    const res = await fetch(`${API_BASE}/dishes`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  /**
   * Bewertung für ein Gericht abschicken
   */
  async postRating(dishId, payload) {
    const res = await fetch(`${API_BASE}/ratings`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ dish_id: dishId, ...payload }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  /**
   * Rankings abrufen  (filter: 'top' | 'trend' | 'flop')
   */
  async getRankings(filter = 'top') {
    const res = await fetch(`${API_BASE}/rankings?filter=${filter}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  /**
   * Gesamtstatistiken abrufen
   */
  async getStats() {
    const res = await fetch(`${API_BASE}/stats`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  /**
   * Alle Essensvorschläge abrufen
   */
  async getProposals() {
    const res = await fetch(`${API_BASE}/proposals`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  },

  /**
   * Neuen Essensvorschlag einreichen
   */
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
