#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-ev_analytics}"

docker compose exec timescaledb psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"
