.PHONY: help install dev build lint test format setup-local setup-interview up down logs-db logs-grafana db-setup db-timescale db-reset db-psql db-verify db-verify-timescale db-counts seed-small seed-interview bench

help:
	@echo "TimescaleDB Real-Time Analytics Support Lab"
	@echo ""
	@echo "Setup commands:"
	@echo "  make setup-local          Install deps, start Docker, apply schema, setup hypertable, verify"
	@echo "  make setup-interview      Full setup with 1M+ telemetry rows"
	@echo ""
	@echo "Core commands:"
	@echo "  make install              Install monorepo dependencies"
	@echo "  make dev                  Run development tasks"
	@echo "  make build                Build all apps/packages"
	@echo "  make lint                 Lint all apps/packages"
	@echo "  make test                 Test all apps/packages"
	@echo ""
	@echo "Docker commands:"
	@echo "  make up                   Start TimescaleDB + Grafana"
	@echo "  make down                 Stop local stack"
	@echo "  make logs-db              Show TimescaleDB logs"
	@echo "  make logs-grafana         Show Grafana logs"
	@echo ""
	@echo "Database commands:"
	@echo "  make db-setup             Apply DB schema"
	@echo "  make db-timescale         Apply TimescaleDB hypertable setup"
	@echo "  make db-reset             Reset local database volumes"
	@echo "  make db-psql              Open psql shell"
	@echo "  make db-verify            Verify schema and constraints"
	@echo "  make db-verify-timescale  Verify TimescaleDB hypertable"
	@echo "  make db-counts            Show table row counts"
	@echo ""
	@echo "Data and benchmark commands:"
	@echo "  make seed-small           Seed small development dataset"
	@echo "  make seed-interview       Seed 1M+ interview dataset"
	@echo "  make bench                Run benchmark scripts"

install:
	npm install

dev:
	npm run dev

build:
	npm run build

lint:
	npm run lint

test:
	npm run test

format:
	npm run format

setup-local:
	npm run setup:local

setup-interview:
	npm run setup:interview

up:
	docker compose up -d

down:
	docker compose down

logs-db:
	docker compose logs -f timescaledb

logs-grafana:
	docker compose logs -f grafana

db-setup:
	npm run db:setup

db-timescale:
	npm run db:timescale

db-reset:
	npm run db:reset

db-psql:
	npm run db:psql

db-verify:
	npm run db:verify

db-verify-timescale:
	npm run db:verify-timescale

db-counts:
	npm run db:counts

seed-small:
	npm run seed:small

seed-interview:
	npm run seed:interview

bench:
	npm run bench
