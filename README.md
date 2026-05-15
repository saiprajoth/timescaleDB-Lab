# TimescaleDB Real-Time Analytics Support Lab

A PostgreSQL + TimescaleDB support-engineering lab focused on real-time analytics, query optimization, execution plans, indexing, continuous aggregates, compression, retention, and customer-style debugging.

## Why this project exists

This project is built to practice real skills needed for a Database Support Engineer role working with PostgreSQL/TimescaleDB systems.

The goal is not to build a fancy frontend.

The goal is to prove:

- PostgreSQL knowledge
- TimescaleDB experience
- time-series schema design
- hypertables
- indexing strategies
- query optimization
- `EXPLAIN ANALYZE`
- continuous aggregates
- compression and retention
- CLI/debugging comfort
- support-style customer explanations

## FOX-40 Build Method

```txt
F = Frame the project around the target job
O = Optimize for performance, debugging, proof, and interview signal
X = Execute step-by-step with commits, scripts, docs, and demos
40 = Build to a serious database-support portfolio signal
```

## Project status

| Step | Name | Status |
|---:|---|---|
| 1 | Repo foundation | In progress |
| 2 | Docker Compose | Not started |
| 3 | Database schema | Not started |
| 4 | Hypertable setup | Not started |
| 5 | Seed 1M+ rows | Not started |
| 6 | Basic analytics queries | Not started |
| 7 | Go API | Not started |
| 8 | Grafana dashboard | Not started |
| 9 | Indexing v1 | Not started |
| 10 | Continuous aggregate v1 | Not started |
| 11 | Compression / columnstore | Not started |
| 12 | Retention policy | Not started |
| 13 | First performance case | Not started |
| 14 | Final README | Not started |

## Repository structure

```txt
apps/
  api/          Go API starts in Step 7

db/
  migrations/  SQL migrations start in Step 3
  seeds/       Seed scripts start in Step 5

queries/
  basic/       Basic analytics queries start in Step 6
  performance/ Slow-query cases start in Step 13
  explain/     Saved EXPLAIN ANALYZE outputs

grafana/
  dashboards/     Dashboard JSON starts in Step 8
  provisioning/   Grafana datasource/dashboard provisioning

docs/
  architecture.md
  job-skill-map.md
  fox-40-build-plan.md
  phase-1-notes.md

support-cases/
  Customer-style support cases start after performance cases
```

## Current step

Step 1: Repo foundation.

No database schema is implemented yet.

Schema begins in Step 3 after Docker Compose and TimescaleDB are running.

## Commands

```bash
npm install
make check
make docs-check
make tree
```

## Final target

By the end of Project 1, this lab will include:

- TimescaleDB running locally
- EV charger telemetry schema
- `charger_metrics` hypertable
- 1M+ generated telemetry rows
- analytics SQL queries
- Go API endpoints
- Grafana dashboard
- indexes
- continuous aggregates
- compression policy
- retention policy
- one full slow-query performance case with `EXPLAIN ANALYZE` before/after
- support-style customer explanation