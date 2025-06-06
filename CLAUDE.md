# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

```bash
# Development
npm run dev              # Start Next.js development server (http://localhost:3000)
npm run build            # Build production bundle
npm run start            # Start production server

# Supabase Local Development
npx supabase start       # Start local Supabase instance
npx supabase stop        # Stop local Supabase instance
npx supabase db reset    # Reset database and apply migrations
npx supabase migration new <name>  # Create new migration

# Type checking (no lint script configured)
npx tsc --noEmit         # Run TypeScript type checking
```

## Architecture Overview

This is a Next.js 15 application using App Router with Supabase for authentication and database. Key architectural decisions:

### Authentication Flow
- Server-side authentication using Supabase SSR
- Middleware (`middleware.ts`) manages session refresh
- Protected routes under `/protected/*` require authentication
- Auth pages: `/sign-in`, `/sign-up`, `/forgot-password`
- Server actions in `app/actions.ts` handle auth operations

### Supabase Integration
- Separate client utilities:
  - `utils/supabase/client.ts` - Browser client
  - `utils/supabase/server.ts` - Server Components client
  - `utils/supabase/middleware.ts` - Middleware client
- Local development on ports: API (54321), DB (54322), Studio (54323)
- Custom schema `new_schema` with RLS-enabled `user_info` table

### Component Architecture
- Server Components by default for data fetching
- Client Components marked with `"use client"` 
- UI components from shadcn/ui in `components/ui/`
- Form handling via Server Actions
- Theme switching via next-themes

### Key Patterns
- Environment variables checked via `utils/supabase/check-env-vars.ts`
- Form messages passed via URL search params
- Tutorial components demonstrate Supabase integration
- Deploy button for one-click Vercel deployment

## Environment Variables

Required for development:
```
NEXT_PUBLIC_SUPABASE_URL=<your-supabase-url>
NEXT_PUBLIC_SUPABASE_ANON_KEY=<your-anon-key>
```

Additional for deployment:
```
SUPABASE_ACCESS_TOKEN=<for-github-actions>
SUPABASE_DB_PASSWORD=<database-password>
SERVICE_ROLE_KEY=<service-role-key>
```

## Database Migrations

Migrations are in `supabase/migrations/`. The custom schema includes:
- `new_schema.user_info` table with user profile data
- Row Level Security (RLS) enabled
- Policies for authenticated user access

## Deployment

GitHub Actions workflow (`.github/workflows/deploy.yml`) handles Supabase deployment on push to main branch.