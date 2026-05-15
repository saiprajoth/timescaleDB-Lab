cat > docs/architecture.md <<'EOF'
# Architecture

## System overview

```txt
EV Charging Telemetry Generator
        ↓
PostgreSQL + TimescaleDB
        ↓
charger_metrics hypertable
        ↓
SQL analytics queries
        ↓
Go API
        ↓
Grafana dashboard