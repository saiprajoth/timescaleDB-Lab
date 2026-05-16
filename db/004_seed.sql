-- Step 5: Seed data
-- EV charging telemetry seed script.
--
-- Usage:
--   psql -v seed_days=4  < db/004_seed.sql   -- small mode, ~115k rows
--   psql -v seed_days=35 < db/004_seed.sql   -- interview mode, 1M+ rows

\echo 'Seeding EV charging telemetry data...'
\echo 'Seed days: ' :seed_days

BEGIN;

TRUNCATE TABLE
  alerts,
  charging_sessions,
  charger_metrics,
  chargers,
  stations
RESTART IDENTITY CASCADE;

INSERT INTO stations (
  name,
  city,
  state,
  latitude,
  longitude,
  operator_name
)
SELECT
  format('EV Hub %02s', station_no) AS name,
  CASE (station_no - 1) % 5
    WHEN 0 THEN 'Hyderabad'
    WHEN 1 THEN 'Warangal'
    WHEN 2 THEN 'Karimnagar'
    WHEN 3 THEN 'Nizamabad'
    ELSE 'Khammam'
  END AS city,
  'Telangana' AS state,
  17.3000 + (random() * 0.5000) AS latitude,
  78.3000 + (random() * 0.5000) AS longitude,
  'FOX-40 EV Network' AS operator_name
FROM generate_series(1, 20) AS station_no;

INSERT INTO chargers (
  station_id,
  charger_code,
  connector_type,
  max_power_kw,
  installed_at,
  is_active
)
SELECT
  s.id AS station_id,
  format('CHG-%02s-%02s', s.id, charger_no) AS charger_code,
  CASE (charger_no - 1) % 5
    WHEN 0 THEN 'CCS2'
    WHEN 1 THEN 'CHAdeMO'
    WHEN 2 THEN 'Type2'
    WHEN 3 THEN 'Bharat AC001'
    ELSE 'Bharat DC001'
  END AS connector_type,
  CASE (charger_no - 1) % 5
    WHEN 0 THEN 60.00
    WHEN 1 THEN 50.00
    WHEN 2 THEN 22.00
    WHEN 3 THEN 10.00
    ELSE 15.00
  END AS max_power_kw,
  now() - ((random() * 365)::int || ' days')::interval AS installed_at,
  true AS is_active
FROM stations s
CROSS JOIN generate_series(1, 5) AS charger_no;

WITH bounds AS (
  SELECT
    date_trunc('hour', now()) - (:seed_days::text || ' days')::interval AS start_time,
    date_trunc('hour', now()) AS end_time
),
ticks AS (
  SELECT generate_series(
    (SELECT start_time FROM bounds),
    (SELECT end_time FROM bounds) - INTERVAL '5 minutes',
    INTERVAL '5 minutes'
  ) AS metric_time
),
generated_metrics AS (
  SELECT
    t.metric_time AS time,
    c.station_id,
    c.id AS charger_id,
    c.max_power_kw,
    CASE
      WHEN random() < 0.55 THEN 'charging'
      WHEN random() < 0.82 THEN 'available'
      WHEN random() < 0.90 THEN 'offline'
      WHEN random() < 0.95 THEN 'maintenance'
      ELSE 'faulted'
    END AS status
  FROM chargers c
  CROSS JOIN ticks t
),
with_power AS (
  SELECT
    time,
    station_id,
    charger_id,
    status,
    CASE
      WHEN status = 'charging'
        THEN round((5 + random() * (max_power_kw::double precision - 5))::numeric, 2)::double precision
      WHEN status = 'available'
        THEN round((random() * 1.5)::numeric, 2)::double precision
      WHEN status = 'maintenance'
        THEN round((random() * 0.5)::numeric, 2)::double precision
      ELSE 0
    END AS power_kw
  FROM generated_metrics
)
INSERT INTO charger_metrics (
  time,
  station_id,
  charger_id,
  power_kw,
  energy_kwh,
  voltage_v,
  current_a,
  temperature_c,
  status
)
SELECT
  time,
  station_id,
  charger_id,
  power_kw,
  round((power_kw * (5.0 / 60.0))::numeric, 4)::double precision AS energy_kwh,
  round((220 + random() * 40)::numeric, 2)::double precision AS voltage_v,
  CASE
    WHEN power_kw = 0 THEN 0
    ELSE round(((power_kw * 1000) / (220 + random() * 40))::numeric, 2)::double precision
  END AS current_a,
  CASE
    WHEN status = 'charging'
      THEN round((35 + random() * 40)::numeric, 2)::double precision
    WHEN status = 'faulted'
      THEN round((65 + random() * 35)::numeric, 2)::double precision
    ELSE round((25 + random() * 20)::numeric, 2)::double precision
  END AS temperature_c,
  status
FROM with_power;

WITH session_base AS (
  SELECT
    session_no,
    c.station_id,
    c.id AS charger_id,
    date_trunc('hour', now())
      - ((random() * :seed_days)::int || ' days')::interval
      - ((random() * 24)::int || ' hours')::interval AS started_at,
    ((30 + random() * 180)::int || ' minutes')::interval AS duration
  FROM generate_series(1, 5000) AS session_no
  JOIN chargers c
    ON c.id = ((session_no - 1) % 100) + 1
)
INSERT INTO charging_sessions (
  station_id,
  charger_id,
  session_code,
  started_at,
  ended_at,
  energy_kwh,
  amount_inr,
  status
)
SELECT
  station_id,
  charger_id,
  format('SESSION-%06s', session_no) AS session_code,
  started_at,
  started_at + duration AS ended_at,
  round((5 + random() * 45)::numeric, 2)::double precision AS energy_kwh,
  round((100 + random() * 900)::numeric, 2) AS amount_inr,
  CASE
    WHEN random() < 0.92 THEN 'completed'
    WHEN random() < 0.96 THEN 'failed'
    ELSE 'cancelled'
  END AS status
FROM session_base;

INSERT INTO alerts (
  time,
  station_id,
  charger_id,
  alert_type,
  severity,
  message
)
SELECT
  time,
  station_id,
  charger_id,
  CASE
    WHEN temperature_c >= 75 THEN 'over_temperature'
    WHEN status = 'offline' THEN 'offline'
    WHEN status = 'faulted' THEN 'power_drop'
    ELSE 'maintenance_due'
  END AS alert_type,
  CASE
    WHEN temperature_c >= 85 OR status = 'faulted' THEN 'critical'
    WHEN status = 'offline' THEN 'warning'
    ELSE 'info'
  END AS severity,
  format(
    'Auto-generated alert for charger %s at %s. status=%s temp=%s',
    charger_id,
    time,
    status,
    temperature_c
  ) AS message
FROM charger_metrics
WHERE
  temperature_c >= 75
  OR status IN ('offline', 'faulted')
ORDER BY random()
LIMIT 5000;

ANALYZE stations;
ANALYZE chargers;
ANALYZE charger_metrics;
ANALYZE charging_sessions;
ANALYZE alerts;

COMMIT;

\echo 'Seed complete.'
\echo 'Final row counts:'

SELECT 'stations' AS table_name, count(*) FROM stations
UNION ALL
SELECT 'chargers' AS table_name, count(*) FROM chargers
UNION ALL
SELECT 'charger_metrics' AS table_name, count(*) FROM charger_metrics
UNION ALL
SELECT 'charging_sessions' AS table_name, count(*) FROM charging_sessions
UNION ALL
SELECT 'alerts' AS table_name, count(*) FROM alerts;
