-- ==========================================================
-- DOCECERTA — schema do Supabase
-- Rode este script inteiro em: Supabase > SQL Editor > New query
-- ==========================================================

-- 1) Tabela com uma linha por dose marcada como tomada
create table if not exists public.dose_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  dose_key text not null,
  checked boolean not null default true,
  updated_at timestamptz not null default now(),
  unique (user_id, date, dose_key)
);

-- 2) Tabela com os ajustes de cada usuário (1 linha por pessoa)
create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  weekly_day int not null default 1,
  alt_reference_date date not null default current_date,
  b12_start date not null default current_date,
  updated_at timestamptz not null default now()
);

-- 3) Segurança: cada pessoa só enxerga e altera os próprios dados
alter table public.dose_log enable row level security;
alter table public.user_settings enable row level security;

drop policy if exists "dose_log_select_own" on public.dose_log;
create policy "dose_log_select_own" on public.dose_log
  for select using (auth.uid() = user_id);

drop policy if exists "dose_log_insert_own" on public.dose_log;
create policy "dose_log_insert_own" on public.dose_log
  for insert with check (auth.uid() = user_id);

drop policy if exists "dose_log_update_own" on public.dose_log;
create policy "dose_log_update_own" on public.dose_log
  for update using (auth.uid() = user_id);

drop policy if exists "dose_log_delete_own" on public.dose_log;
create policy "dose_log_delete_own" on public.dose_log
  for delete using (auth.uid() = user_id);

drop policy if exists "settings_select_own" on public.user_settings;
create policy "settings_select_own" on public.user_settings
  for select using (auth.uid() = user_id);

drop policy if exists "settings_insert_own" on public.user_settings;
create policy "settings_insert_own" on public.user_settings
  for insert with check (auth.uid() = user_id);

drop policy if exists "settings_update_own" on public.user_settings;
create policy "settings_update_own" on public.user_settings
  for update using (auth.uid() = user_id);

-- ==========================================================
-- PASSO SEGUINTE (depois de rodar o script acima):
--
-- 1. No app, crie a conta da Poliana normalmente (tela de login > Criar conta).
-- 2. No Supabase, vá em Authentication > Users e copie o "User UID" dela.
-- 3. Cole esse UID no lugar de SEU_USER_ID_AQUI abaixo e rode o bloco
--    seguinte UMA VEZ para restaurar o histórico já registrado
--    (anteontem, ontem e a B12 de hoje).
-- ==========================================================

/*
insert into public.user_settings (user_id, weekly_day, alt_reference_date, b12_start)
values ('SEU_USER_ID_AQUI', 1, '2026-09-04', '2026-09-05')
on conflict (user_id) do update set
  weekly_day = excluded.weekly_day,
  alt_reference_date = excluded.alt_reference_date,
  b12_start = excluded.b12_start;

insert into public.dose_log (user_id, date, dose_key, checked) values
  ('SEU_USER_ID_AQUI', '2026-09-03', 'systemPatch__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-03', 'ginobiotta__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-03', 'diosmin__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'ginobiotta__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'diosmin__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'oxandrolona__1', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'magnesio__1', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'omega3__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'dim__1', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'gestrinona__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-04', 'testosterona__0', true),
  ('SEU_USER_ID_AQUI', '2026-09-05', 'b12__0', true)
on conflict (user_id, date, dose_key) do nothing;
*/
