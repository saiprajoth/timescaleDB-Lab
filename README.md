# TimescaleDB Lab <img width="32" height="32" alt="timescaleDB-Lab-logo" src="https://github.com/user-attachments/assets/c2a4ad22-97ad-45da-8010-9bb512e38c3d" />


A PostgreSQL + TimescaleDB support-engineering lab focused on real-time analytics, query optimization, execution plans, indexing, continuous aggregates, compression, retention, and customer-style debugging.

<img width="1916" height="821" alt="a8c64460-fa68-4a89-ac24-bf892afc2e41" src="https://github.com/user-attachments/assets/8e2b1213-2911-46aa-b3e2-5e8e43f40c51" />


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
| 1 | Repo foundation | Done |
| 2 | Docker Compose | Done  |
| 3 | Database schema | Done  |
| 4 | Hypertable setup | Done  |
| 5 | Seed 1M+ rows | Done  |
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
## Architecture Diagrams

<img width="1536" height="1024" alt="timescaleDB-Lab-architecture-diagram" src="https://github.com/user-attachments/assets/451482eb-1f95-442e-803b-84a816d1d4d1" />

<img width="1536" height="1024" alt="imescaleDB-Lab-architecture-diagram-user-pov" src="https://github.com/user-attachments/assets/f6aba10a-e14f-4815-8515-daa3ded6a237" />

## Current step

Step 1: Repo foundation.

No database schema is implemented yet.

Schema begins in Step 3 after Docker Compose and TimescaleDB are running.

## Commands

```bash
make up
make db-setup
make db-timescale
make db-verify
make db-verify-timescale
make seed-small
make db-counts
make db-verify-timescale

```
Then:
```bash
make seed-interview
make db-counts
make db-verify-timescale
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
