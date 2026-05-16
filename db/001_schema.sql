-- Step 3: Database schema
-- TimescaleDB Real-Time Analytics Support Lab
-- Domain: EV charging telemetry
--
-- NOTE:
-- charger_metrics is intentionally designed with PRIMARY KEY (time, charger_id)
-- so it can be converted into a TimescaleDB hypertable in Step 4.

BEGIN;

CREATE TABLE IF NOT EXISTS stations (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  operator_name TEXT NOT NULL DEFAULT 'Tiger EV Network',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT stations_name_city_unique UNIQUE (name, city),
  CONSTRAINT stations_latitude_valid CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
  CONSTRAINT stations_longitude_valid CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);

CREATE TABLE IF NOT EXISTS chargers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  station_id BIGINT NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
  charger_code TEXT NOT NULL,
  connector_type TEXT NOT NULL,
  max_power_kw NUMERIC(8,2) NOT NULL,
  installed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_active BOOLEAN NOT NULL DEFAULT true,

  CONSTRAINT chargers_station_code_unique UNIQUE (station_id, charger_code),
  CONSTRAINT chargers_connector_type_valid CHECK (
    connector_type IN ('CCS2', 'CHAdeMO', 'Type2', 'Bharat AC001', 'Bharat DC001')
  ),
  CONSTRAINT chargers_max_power_positive CHECK (max_power_kw > 0)
);

CREATE TABLE IF NOT EXISTS charger_metrics (
  time TIMESTAMPTZ NOT NULL,
  station_id BIGINT NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
  charger_id BIGINT NOT NULL REFERENCES chargers(id) ON DELETE CASCADE,

  power_kw DOUBLE PRECISION NOT NULL,
  energy_kwh DOUBLE PRECISION NOT NULL,
  voltage_v DOUBLE PRECISION NOT NULL,
  current_a DOUBLE PRECISION NOT NULL,
  temperature_c DOUBLE PRECISION NOT NULL,
  status TEXT NOT NULL,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (time, charger_id),

  CONSTRAINT charger_metrics_power_valid CHECK (power_kw >= 0),
  CONSTRAINT charger_metrics_energy_valid CHECK (energy_kwh >= 0),
  CONSTRAINT charger_metrics_voltage_valid CHECK (voltage_v >= 0),
  CONSTRAINT charger_metrics_current_valid CHECK (current_a >= 0),
  CONSTRAINT charger_metrics_temperature_valid CHECK (temperature_c BETWEEN -20 AND 120),
  CONSTRAINT charger_metrics_status_valid CHECK (
    status IN ('available', 'charging', 'offline', 'faulted', 'maintenance')
  )
);

CREATE TABLE IF NOT EXISTS charging_sessions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  station_id BIGINT NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
  charger_id BIGINT NOT NULL REFERENCES chargers(id) ON DELETE CASCADE,

  session_code TEXT NOT NULL UNIQUE,
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  energy_kwh DOUBLE PRECISION NOT NULL DEFAULT 0,
  amount_inr NUMERIC(10,2) NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'active',

  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT charging_sessions_time_valid CHECK (ended_at IS NULL OR ended_at >= started_at),
  CONSTRAINT charging_sessions_energy_valid CHECK (energy_kwh >= 0),
  CONSTRAINT charging_sessions_amount_valid CHECK (amount_inr >= 0),
  CONSTRAINT charging_sessions_status_valid CHECK (
    status IN ('active', 'completed', 'failed', 'cancelled')
  )
);

CREATE TABLE IF NOT EXISTS alerts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  time TIMESTAMPTZ NOT NULL,
  station_id BIGINT NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
  charger_id BIGINT REFERENCES chargers(id) ON DELETE SET NULL,

  alert_type TEXT NOT NULL,
  severity TEXT NOT NULL,
  message TEXT NOT NULL,
  resolved_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT alerts_severity_valid CHECK (
    severity IN ('info', 'warning', 'critical')
  ),
  CONSTRAINT alerts_type_valid CHECK (
    alert_type IN ('over_temperature', 'offline', 'power_drop', 'voltage_anomaly', 'maintenance_due')
  ),
  CONSTRAINT alerts_resolved_time_valid CHECK (resolved_at IS NULL OR resolved_at >= time)
);

COMMIT;
