#!/bin/sh
# docker-entrypoint.sh
# Generiert js/env.js mit der aktuellen API-URL aus der Umgebungsvariable.
# Fallback: http://localhost:3000/api

API_URL="${DHBW_API_URL:-http://localhost:3000/api}"

cat > /usr/share/nginx/html/js/env.js <<EOF
// Automatisch generiert beim Container-Start
window.DHBW_API_URL = '${API_URL}';
EOF

echo "[entrypoint] API-URL gesetzt: ${API_URL}"

# Übergebene CMD ausführen (nginx)
exec "$@"
