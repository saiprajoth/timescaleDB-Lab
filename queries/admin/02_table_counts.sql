-- Basic table counts after schema creation

SELECT 'stations' AS table_name, count(*) FROM stations
UNION ALL
SELECT 'chargers' AS table_name, count(*) FROM chargers
UNION ALL
SELECT 'charger_metrics' AS table_name, count(*) FROM charger_metrics
UNION ALL
SELECT 'charging_sessions' AS table_name, count(*) FROM charging_sessions
UNION ALL
SELECT 'alerts' AS table_name, count(*) FROM alerts;
