-- Emergency fix: Recreate supabase_migrations schema and table
-- This is needed because the previous migration accidentally dropped it

CREATE SCHEMA IF NOT EXISTS supabase_migrations;

CREATE TABLE IF NOT EXISTS supabase_migrations.schema_migrations (
    version text NOT NULL PRIMARY KEY,
    statements text[],
    name text
);

-- Insert records for migrations that should be marked as applied
-- We'll mark the problematic migrations as applied to prevent re-running
INSERT INTO supabase_migrations.schema_migrations (version, name, statements) 
VALUES 
    ('20250528121334', 'remote_schema', ARRAY['-- Migration already reverted']),
    ('20250528121831', 'create_new_schema', ARRAY['-- Already applied']),
    ('20250529050628', 'remote_schema', ARRAY['-- Already applied']),
    ('20250606181720', 'cleanup_all_schemas', ARRAY['-- Migration already reverted']),
    ('20250606181721', 'comprehensive_cleanup', ARRAY['-- Already applied'])
ON CONFLICT (version) DO NOTHING;