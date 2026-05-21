#!/bin/sh
API_URL="${DHBW_API_URL:-http://localhost:3000/api}"

cat > /usr/share/nginx/html/js/env.js <<EOF
window.DHBW_API_URL = '${API_URL}';
EOF

exec "$@"
