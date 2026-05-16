#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-ev_analytics}"

echo "Seeding small development dataset..."
echo "Expected charger_metrics rows: around 115,200"

docker compose exec -T timescaledb \
  psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -v ON_ERROR_STOP=1 -v seed_days=4 \
  < db/004_seed.sql
