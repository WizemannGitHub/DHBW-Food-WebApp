/**
 * env.js – wird vom Docker-Entrypoint bei Bedarf generiert,
 * um die Backend-URL in den Frontend-Container zu injizieren.
 *
 * Im Entwicklungsmodus zeigt die URL auf localhost:3000.
 * Im Docker-Betrieb wird diese Datei durch den Container-Start überschrieben.
 *
 * Dieses Skript muss VOR allen anderen JS-Dateien in der index.html
 * eingebunden werden (es ist bereits der Fall – see index.html).
 */
window.DHBW_API_URL = 'http://localhost:3000/api';
