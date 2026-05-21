# ── Frontend – nginx-Container (Podman-kompatibel) ──────────
# Statische Dateien werden von nginx ausgeliefert.
# Ein Entrypoint-Script setzt die API-URL dynamisch via env.js.

FROM nginx:1.25-alpine

# nginx-Konfiguration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Nur die App-Dateien kopieren (kein Dockerfile, kein nginx.conf erneut)
COPY css/   /usr/share/nginx/html/css/
COPY js/    /usr/share/nginx/html/js/
COPY index.html /usr/share/nginx/html/index.html

# Entrypoint-Script das env.js zur Laufzeit generiert
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -qO- http://localhost/health || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
