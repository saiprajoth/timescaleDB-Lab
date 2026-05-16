-- Verify Step 3 schema objects

SELECT
  table_schema,
  table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT
  conrelid::regclass::text AS table_name,
  conname AS constraint_name,
  CASE contype
    WHEN 'p' THEN 'primary_key'
    WHEN 'f' THEN 'foreign_key'
    WHEN 'u' THEN 'unique'
    WHEN 'c' THEN 'check'
    ELSE contype::text
  END AS constraint_type
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, conname;
