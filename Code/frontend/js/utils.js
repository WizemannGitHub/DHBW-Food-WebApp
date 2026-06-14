function escHtml(str) {
  const el = document.createElement('div');
  el.appendChild(document.createTextNode(String(str)));
  return el.innerHTML;
}

const KATEGORIE_EMOJI = {
  fleisch: '🥩', vegetarisch: '🥗', vegan: '🌱',
  pasta: '🍝', salat: '🥙', suppe: '🍲', dessert: '🍰', default: '🍽',
};
