-- supabase/migrations/2024_05_21_create_new_schema_and_table.sql

CREATE SCHEMA IF NOT EXISTS my_schema;

CREATE TABLE my_schema.employee (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  department TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE my_schema.employee ENABLE ROW LEVEL SECURITY;

