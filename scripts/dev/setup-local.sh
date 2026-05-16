#!/usr/bin/env bash
set -euo pipefail

echo "Setting up TimescaleDB Support Lab locally..."

if [ ! -f .env ]; then
  cp .env.example .env
fi

npm install

docker compose up -d

echo "Waiting for TimescaleDB..."
until docker compose exec -T timescaledb pg_isready -U postgres -d ev_analytics > /dev/null 2>&1; do
  sleep 2
done

npm run db:setup
npm run db:timescale
npm run db:verify
npm run db:verify-timescale

echo ""
echo "Local setup complete."
echo "Grafana: http://localhost:3000"
echo "Login: admin / admin"
