-- Cleanup migration: Remove all previously created schemas and data

-- Drop tables from public schema (from first migration)
-- Note: CASCADE will automatically drop all dependent objects including policies
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.memberships CASCADE;
DROP TABLE IF EXISTS public.channels CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Drop new_schema and all its objects
DROP SCHEMA IF EXISTS new_schema CASCADE;

-- Drop my_schema and all its objects
DROP SCHEMA IF EXISTS my_schema CASCADE;

-- Note: Using CASCADE automatically drops:
-- - All tables within the schemas
-- - All sequences
-- - All constraints
-- - All indexes
-- - All policies
-- - Any other dependent objects