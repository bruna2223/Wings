-- Corre este ficheiro no Supabase: SQL Editor → New query → Run
create table if not exists products(
  id bigint generated always as identity primary key,
  name text not null,
  variant text,
  price numeric(10,2) not null,
  old_price numeric(10,2),
  category text not null,
  color_a text default '#23272c',
  color_b text default '#3a4047',
  sizes text[] default '{}',
  out_sizes text[] default '{}',
  tag text,
  img text,
  img2 text,
  active boolean default true,
  sort int default 0,
  created_at timestamptz default now()
);
create table if not exists settings(key text primary key, value text);

alter table products enable row level security;
alter table settings enable row level security;
create policy "ler produtos" on products for select using (true);
create policy "admin produtos" on products for all to authenticated using (true) with check (true);
create policy "ler definicoes" on settings for select using (true);
create policy "admin definicoes" on settings for all to authenticated using (true) with check (true);

-- Pasta pública para as fotos
insert into storage.buckets(id,name,public) values('products','products',true) on conflict do nothing;
create policy "ler imagens" on storage.objects for select using (bucket_id='products');
create policy "admin imagens" on storage.objects for all to authenticated using (bucket_id='products') with check (bucket_id='products');

-- Exemplos (podes apagar no admin)
insert into products(name,variant,price,category,color_a,color_b,sizes,tag) values
('Casaco Puffer','Preto',179,'Casacos','#23272c','#3a4047','{S,M,L,XL}','Novo'),
('Hoodie Essential','Cinza',89,'Hoodies','#a3a8ae','#bfc3c8','{XS,S,M,L,XL}',null),
('Mala Barrel','Castanho',149,'Acessórios','#5a4636','#745b48','{Único}',null),
('Camisola de Malha','Marfim',109,'Mulher','#d9d2c4','#ebe5d8','{XS,S,M,L}','Novo');
insert into settings(key,value) values
('brand','A TUA MARCA'),('heroSmall','Coleção FW26 · 02'),('heroTitle','Novidades de outono'),
('freeShip','109'),('email','loja@exemplo.pt'),
('marquee',E'Portes grátis a partir de 109 €\nTrocas e devoluções em 30 dias'),
('stores',E'Lisboa|Rua Exemplo, 10 · Seg–Sáb 10–20\nPorto|Rua Exemplo, 25 · Seg–Sáb 10–20')
on conflict (key) do nothing;
