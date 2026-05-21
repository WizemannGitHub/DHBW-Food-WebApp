# ── Backend – Node.js-Container (Podman-kompatibel) ─────────
# Rootless Podman: kein explizites USER-Statement nötig,
# der Container läuft bereits ohne Root-Rechte.

FROM node:20-alpine

WORKDIR /app

# Abhängigkeiten zuerst für besseres Layer-Caching
COPY package.json ./
RUN npm install --omit=dev

# Quellcode
COPY server.js db.js ./

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
