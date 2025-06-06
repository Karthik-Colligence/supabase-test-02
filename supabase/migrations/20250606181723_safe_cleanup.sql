-- Safe cleanup migration: Remove only known custom schemas and tables
-- This version carefully avoids system schemas

-- Drop known custom schemas only
DROP SCHEMA IF EXISTS new_schema CASCADE;
DROP SCHEMA IF EXISTS my_schema CASCADE;

-- Drop known tables from public schema (from the deleted migration)
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.memberships CASCADE;
DROP TABLE IF EXISTS public.channels CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Log what remains
DO $$
DECLARE
    remaining_schemas TEXT;
    remaining_tables TEXT;
BEGIN
    -- Check for any remaining custom schemas (excluding all known system schemas)
    SELECT string_agg(schema_name, ', ') INTO remaining_schemas
    FROM information_schema.schemata 
    WHERE schema_name NOT IN (
        'public', 'pg_catalog', 'information_schema', 'pg_toast',
        'auth', 'storage', 'graphql', 'graphql_public', 
        'realtime', 'supabase_functions', 'extensions',
        'pgbouncer', 'pgsodium', 'pgsodium_masks', 'vault',
        'supabase_migrations', 'pg_temp_1', 'pg_toast_temp_1'
    )
    AND schema_name NOT LIKE 'pg_temp%'
    AND schema_name NOT LIKE 'pg_toast_temp%';
    
    -- Check for remaining tables in public schema
    SELECT string_agg(tablename, ', ') INTO remaining_tables
    FROM pg_tables 
    WHERE schemaname = 'public';
    
    IF remaining_schemas IS NOT NULL THEN
        RAISE NOTICE 'Remaining non-system schemas: %', remaining_schemas;
    ELSE
        RAISE NOTICE 'All custom schemas have been removed';
    END IF;
    
    IF remaining_tables IS NOT NULL THEN
        RAISE NOTICE 'Tables in public schema: %', remaining_tables;
    END IF;
END $$;