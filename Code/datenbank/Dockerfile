# ── Datenbank – PostgreSQL-Container (Podman-kompatibel) ────
# Das offizielle Postgres-Image wird direkt genutzt.
# Das Init-Script wird automatisch beim ersten Start ausgeführt.

FROM postgres:16-alpine

# Init-Script ins Initialisierungsverzeichnis kopieren
COPY init.sql /docker-entrypoint-initdb.d/01_init.sql

EXPOSE 5432

# Healthcheck mit explizitem Nutzer (kein Env-Expansion-Problem in Podman)
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U dhbw -d dhbw_food || exit 1
