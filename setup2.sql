-- ATUALIZAÇÃO: categorias editáveis. Corre no Supabase: SQL Editor → New query → Run
create table if not exists categories(
  id bigint generated always as identity primary key,
  name text not null unique,
  title text,
  sort int default 0,
  active boolean default true
);
alter table categories enable row level security;
drop policy if exists "ler categorias" on categories;
drop policy if exists "admin categorias" on categories;
create policy "ler categorias" on categories for select using (true);
create policy "admin categorias" on categories for all to authenticated using (true) with check (true);
-- cria uma categoria por cada categoria que já usas nos produtos
insert into categories(name,sort)
select category,(row_number() over (order by min(created_at)))::int from products group by category
on conflict (name) do nothing;
