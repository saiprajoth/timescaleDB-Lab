cat > docs/fox-40-plan.md <<'EOF'
# FOX-40 Build Plan

## F — Frame

Build a PostgreSQL + TimescaleDB support lab that matches the TigerData Database Support Engineer role.

## O — Optimize

Optimize for:
- query debugging proof
- 1M+ row dataset
- EXPLAIN ANALYZE before/after
- continuous aggregates
- compression and retention
- support-style documentation

## X — Execute

Build in 14 strict steps:

1. Repo foundation
2. Docker Compose
3. Database schema
4. Hypertable setup
5. 1M+ seed data
6. Basic analytics queries
7. Go API
8. Grafana dashboard
9. Indexing v1
10. Continuous aggregate v1
11. Compression / columnstore
12. Retention policy
13. First performance case
14. Final README

## 40 — Offer-level signal

The strongest proof points are:
- 1M+ telemetry rows
- real TimescaleDB hypertable
- slow query case
- EXPLAIN ANALYZE before/after
- continuous aggregate optimization
- compression + retention
- customer support explanation
EOF