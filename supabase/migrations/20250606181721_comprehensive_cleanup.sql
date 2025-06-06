-- Comprehensive cleanup migration: Remove ALL unwanted schemas and objects
-- This migration safely removes all custom schemas and tables

-- 1. Log current state before cleanup
DO $$
BEGIN
    RAISE NOTICE 'Starting comprehensive cleanup...';
    RAISE NOTICE 'Current schemas: %', (
        SELECT string_agg(schema_name, ', ') 
        FROM information_schema.schemata 
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    );
END $$;

-- 2. Drop all known custom schemas with CASCADE
-- This will automatically drop all tables, sequences, constraints, indexes, and policies
DROP SCHEMA IF EXISTS new_schema CASCADE;
DROP SCHEMA IF EXISTS my_schema CASCADE;

-- 3. Drop any other unexpected custom schemas (safety net)
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT schema_name 
             FROM information_schema.schemata 
             WHERE schema_name NOT IN ('public', 'pg_catalog', 'information_schema', 'pg_toast', 
                                     'auth', 'storage', 'graphql', 'graphql_public', 
                                     'realtime', 'supabase_functions', 'extensions', 
                                     'pgbouncer', 'pgsodium', 'pgsodium_masks', 'vault')
    LOOP
        EXECUTE 'DROP SCHEMA IF EXISTS ' || quote_ident(r.schema_name) || ' CASCADE';
        RAISE NOTICE 'Dropped unexpected schema: %', r.schema_name;
    END LOOP;
END $$;

-- 4. Clean up public schema tables (from the deleted migration)
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.memberships CASCADE;
DROP TABLE IF EXISTS public.channels CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- 5. Drop any orphaned sequences in public schema
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT sequence_name 
             FROM information_schema.sequences 
             WHERE sequence_schema = 'public'
               AND sequence_name NOT LIKE 'pg_%'
    LOOP
        EXECUTE 'DROP SEQUENCE IF EXISTS public.' || quote_ident(r.sequence_name) || ' CASCADE';
        RAISE NOTICE 'Dropped orphaned sequence: public.%', r.sequence_name;
    END LOOP;
END $$;

-- 6. Final verification
DO $$
DECLARE
    remaining_schemas TEXT;
    remaining_tables TEXT;
BEGIN
    -- Check for remaining custom schemas
    SELECT string_agg(schema_name, ', ') INTO remaining_schemas
    FROM information_schema.schemata 
    WHERE schema_name NOT IN ('public', 'pg_catalog', 'information_schema', 'pg_toast',
                             'auth', 'storage', 'graphql', 'graphql_public', 
                             'realtime', 'supabase_functions', 'extensions',
                             'pgbouncer', 'pgsodium', 'pgsodium_masks', 'vault');
    
    -- Check for remaining tables in public
    SELECT string_agg(tablename, ', ') INTO remaining_tables
    FROM pg_tables 
    WHERE schemaname = 'public'
      AND tablename NOT IN ('schema_migrations', 'supabase_migrations');
    
    IF remaining_schemas IS NOT NULL THEN
        RAISE NOTICE 'Warning: Remaining custom schemas: %', remaining_schemas;
    ELSE
        RAISE NOTICE 'Success: All custom schemas removed';
    END IF;
    
    IF remaining_tables IS NOT NULL THEN
        RAISE NOTICE 'Info: Remaining tables in public: %', remaining_tables;
    ELSE
        RAISE NOTICE 'Success: Public schema cleaned';
    END IF;
END $$;