/**
 * utils.js – globale Hilfsfunktionen
 * Muss als erste JS-Datei geladen werden.
 */

/**
 * Escaped HTML-Sonderzeichen um XSS zu verhindern.
 * @param {string} str
 * @returns {string}
 */
function escHtml(str) {
  const el = document.createElement('div');
  el.appendChild(document.createTextNode(String(str)));
  return el.innerHTML;
}
