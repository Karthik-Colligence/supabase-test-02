-- Cleanup migration: Remove all previously created schemas and data

-- Drop tables from public schema (from first migration)
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.memberships CASCADE;
DROP TABLE IF EXISTS public.channels CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Drop new_schema and all its objects
DROP SCHEMA IF EXISTS new_schema CASCADE;

-- Drop my_schema and all its objects
DROP SCHEMA IF EXISTS my_schema CASCADE;

-- Note: Using CASCADE will automatically drop all dependent objects including:
-- - Tables within the schemas
-- - Sequences
-- - Constraints
-- - Indexes
-- - Any other dependent objects

-- Reset any RLS policies that might have been created
-- (These should be dropped with CASCADE, but being explicit for clarity)
DROP POLICY IF EXISTS "Allow all operations" ON public.users;
DROP POLICY IF EXISTS "Allow anonymous access for testing" ON public.users;
DROP POLICY IF EXISTS "Allow authenticated access" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;
DROP POLICY IF EXISTS "Users can update their own data" ON public.users;
DROP POLICY IF EXISTS "Users can view their own data" ON public.users;