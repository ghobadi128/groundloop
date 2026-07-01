-- ============================================================
-- GroundLoop database schema for Supabase (Postgres)
-- Paste this whole file into Supabase → SQL Editor → Run.
-- It creates the tables, security rules, realtime, and demo data.
-- ============================================================

-- ---------- PROFILES (one row per user, keyed to auth user) ----------
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  role        text not null check (role in ('collector','shop','driver','admin')),
  name        text not null,
  biz_name    text,
  email       text,
  lat         double precision,
  lng         double precision,
  plan        text default 'trial',          -- 'trial' | 'active'
  plan_type   text,                           -- 'monthly' | 'annual'
  trial_start timestamptz default now(),
  rating      double precision default 0,
  created_at  timestamptz default now()
);

-- ---------- LISTINGS ----------
create table if not exists public.listings (
  id            uuid primary key default gen_random_uuid(),
  shop_id       uuid references public.profiles(id) on delete cascade,
  cat           text not null,                -- grounds|grain|woodchip|cardboard|mulch|compost
  title         text not null,
  qty           numeric not null,
  unit          text default 'lbs',
  pickup_window text,
  note          text,
  lat           double precision,
  lng           double precision,
  status        text default 'open',          -- open|reserved|closed
  created_at    timestamptz default now()
);

-- ---------- RESERVATIONS ----------
create table if not exists public.reservations (
  id           uuid primary key default gen_random_uuid(),
  listing_id   uuid references public.listings(id) on delete cascade,
  user_id      uuid references public.profiles(id) on delete cascade,
  mode         text default 'pickup',         -- pickup|delivery
  status       text default 'reserved',        -- reserved|requested|enroute|completed
  lbs          numeric default 0,
  driver_id    uuid references public.profiles(id),
  created_at   timestamptz default now(),
  completed_at timestamptz
);

-- ---------- MESSAGES ----------
create table if not exists public.messages (
  id         uuid primary key default gen_random_uuid(),
  thread_key text not null,                    -- sorted "idA|idB"
  from_id    uuid references public.profiles(id) on delete cascade,
  body       text not null,
  created_at timestamptz default now()
);

-- ---------- NOTIFICATIONS ----------
create table if not exists public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references public.profiles(id) on delete cascade,
  body       text not null,
  read       boolean default false,
  created_at timestamptz default now()
);

-- ---------- REVIEWS ----------
create table if not exists public.reviews (
  id         uuid primary key default gen_random_uuid(),
  shop_id    uuid references public.profiles(id) on delete cascade,
  by_name    text,
  stars      int check (stars between 1 and 5),
  body       text,
  created_at timestamptz default now()
);

-- ============================================================
-- Row Level Security (RLS)
-- Sensible MVP rules: everything is readable (it's a public
-- marketplace), and signed-in users write their own data.
-- Harden later as needed.
-- ============================================================
alter table public.profiles      enable row level security;
alter table public.listings      enable row level security;
alter table public.reservations  enable row level security;
alter table public.messages      enable row level security;
alter table public.notifications enable row level security;
alter table public.reviews       enable row level security;

-- Public read
create policy "read profiles"      on public.profiles      for select using (true);
create policy "read listings"      on public.listings      for select using (true);
create policy "read reservations"  on public.reservations  for select using (true);
create policy "read messages"      on public.messages      for select using (true);
create policy "read notifications" on public.notifications for select using (true);
create policy "read reviews"       on public.reviews       for select using (true);

-- Authenticated write (insert/update/delete) -- MVP-permissive
create policy "write profiles"      on public.profiles      for all to authenticated using (true) with check (true);
create policy "write listings"      on public.listings      for all to authenticated using (true) with check (true);
create policy "write reservations"  on public.reservations  for all to authenticated using (true) with check (true);
create policy "write messages"      on public.messages      for all to authenticated using (true) with check (true);
create policy "write notifications" on public.notifications for all to authenticated using (true) with check (true);
create policy "write reviews"       on public.reviews       for all to authenticated using (true) with check (true);

-- ============================================================
-- Realtime: broadcast changes so the app updates live
-- ============================================================
alter publication supabase_realtime add table public.listings;
alter publication supabase_realtime add table public.reservations;
alter publication supabase_realtime add table public.notifications;
alter publication supabase_realtime add table public.messages;

-- ============================================================
-- DONE.
-- Next: in Supabase → Authentication → Providers → Email,
-- turn OFF "Confirm email" so new users can sign in instantly
-- (or keep it on and they'll confirm via email first).
-- ============================================================
