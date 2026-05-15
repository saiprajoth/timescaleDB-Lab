.PHONY: help install dev build lint test format db-setup db-reset db-psql seed-small seed-interview bench

help:
	@echo "TimescaleDB Real-Time Analytics Support Lab"
	@echo ""
	@echo "Core commands:"
	@echo "  make install          Install monorepo dependencies"
	@echo "  make dev              Run development tasks"
	@echo "  make build            Build all apps/packages"
	@echo "  make lint             Lint all apps/packages"
	@echo "  make test             Test all apps/packages"
	@echo ""
	@echo "Database commands:"
	@echo "  make db-setup         Apply DB setup scripts"
	@echo "  make db-reset         Reset local database"
	@echo "  make db-psql          Open psql shell"
	@echo ""
	@echo "Data and benchmark commands:"
	@echo "  make seed-small       Seed small development dataset"
	@echo "  make seed-interview   Seed 1M+ interview dataset"
	@echo "  make bench            Run benchmark scripts"

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

db-setup:
	npm run db:setup

db-reset:
	npm run db:reset

db-psql:
	npm run db:psql

seed-small:
	npm run seed:small

seed-interview:
	npm run seed:interview

bench:
	npm run bench
