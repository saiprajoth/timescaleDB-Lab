#!/usr/bin/env bash
set -euo pipefail

echo "WARNING: This will remove TimescaleDB and Grafana local volumes."
echo "Press Ctrl+C to cancel, or wait 3 seconds to continue."
sleep 3

docker compose down -v
docker compose up -d

echo "Local stack reset complete."
