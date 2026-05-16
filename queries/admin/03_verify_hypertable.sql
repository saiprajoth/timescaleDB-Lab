-- Verify TimescaleDB extension and charger_metrics hypertable

SELECT
  extname AS extension_name,
  extversion AS extension_version
FROM pg_extension
WHERE extname = 'timescaledb';

SELECT
  hypertable_schema,
  hypertable_name,
  owner,
  num_dimensions,
  num_chunks,
  compression_enabled
FROM timescaledb_information.hypertables
WHERE hypertable_name = 'charger_metrics';

SELECT
  hypertable_name,
  chunk_name,
  range_start,
  range_end
FROM timescaledb_information.chunks
WHERE hypertable_name = 'charger_metrics'
ORDER BY range_start
LIMIT 10;
