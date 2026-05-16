#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-ev_analytics}"

echo "Verifying schema..."

docker compose exec -T timescaledb \
  psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -v ON_ERROR_STOP=1 \
  < queries/admin/01_verify_schema.sql

echo ""
echo "Checking table counts..."

docker compose exec -T timescaledb \
  psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -v ON_ERROR_STOP=1 \
  < queries/admin/02_table_counts.sql
