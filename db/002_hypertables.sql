-- Step 4: Hypertable setup
-- Converts charger_metrics into a TimescaleDB hypertable.

BEGIN;

CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

SELECT create_hypertable(
  'charger_metrics',
  'time',
  if_not_exists => TRUE,
  chunk_time_interval => INTERVAL '1 day'
);

COMMIT;
