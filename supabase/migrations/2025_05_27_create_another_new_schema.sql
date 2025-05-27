-- supabase/migrations/

CREATE SCHEMA IF NOT EXISTS new_schema;

CREATE TABLE new_schema.employee (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  department TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE new_schema.employee DISABLE ROW LEVEL SECURITY;
