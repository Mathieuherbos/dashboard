-- Schéma du dashboard personnel : une ligne de données JSON par utilisateur.
-- À exécuter dans Supabase → SQL Editor (ou via le CLI). Sécurisé par Row Level Security :
-- chaque utilisateur ne peut lire/écrire QUE sa propre ligne.

create table if not exists dashboards (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb,
  updated_at timestamptz default now()
);

alter table dashboards enable row level security;

drop policy if exists "lire sa ligne"     on dashboards;
drop policy if exists "creer sa ligne"    on dashboards;
drop policy if exists "modifier sa ligne" on dashboards;

create policy "lire sa ligne"     on dashboards for select using (auth.uid() = user_id);
create policy "creer sa ligne"    on dashboards for insert with check (auth.uid() = user_id);
create policy "modifier sa ligne" on dashboards for update using (auth.uid() = user_id);
