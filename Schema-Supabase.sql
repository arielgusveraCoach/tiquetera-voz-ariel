-- =====================================================================
-- TIQUETERA ARIEL - ESQUEMA SUPABASE (POSTGRESQL)
-- Uso 100 % personal (sin login / sin Supabase Auth)
-- 
-- Instrucciones:
-- 1. Entrá a https://supabase.com y abrí tu proyecto.
-- 2. Menú lateral: SQL Editor > New query.
-- 3. Pegá todo este script y hacé clic en "Run".
-- =====================================================================

-- 1. Crear tabla tickets con constraint de unicidad en número
create table if not exists public.tickets (
  id bigint generated always as identity primary key,
  numero text not null,
  fecha date not null,
  hora time not null,
  quien text,
  equipo text,
  motivo text,
  diagnostico text default 'A constatar',
  estado text default 'Pendiente' check (estado in ('Pendiente','En curso','Resuelto')),
  prioridad text default 'Media' check (prioridad in ('Baja','Media','Alta','Urgente')),
  relato text,
  creado_en timestamptz default now(),
  -- Evita números duplicados
  constraint tickets_numero_unique unique (numero)
);

-- 2. Índice de rendimiento para ordenamiento rápido por fecha de creación
create index if not exists idx_tickets_creado_en on public.tickets (creado_en desc);
create index if not exists idx_tickets_numero on public.tickets (numero);

-- 3. Activar Row Level Security (RLS)
alter table public.tickets enable row level security;

-- 4. Políticas de acceso directo para uso personal con la anon / publishable key
-- Permite SELECT, INSERT, UPDATE y DELETE directos desde la app web/PWA
-- sin requerir pantalla de login ni usuarios registrados en Supabase Auth.
drop policy if exists "Lectura publica tickets" on public.tickets;
drop policy if exists "Crear tickets" on public.tickets;
drop policy if exists "Actualizar tickets" on public.tickets;
drop policy if exists "Borrar tickets" on public.tickets;

create policy "Lectura publica tickets" on public.tickets
  for select using (true);

create policy "Crear tickets" on public.tickets
  for insert with check (true);

create policy "Actualizar tickets" on public.tickets
  for update using (true) with check (true);

create policy "Borrar tickets" on public.tickets
  for delete using (true);

-- 5. Registro inicial de ejemplo (T-001) si no existe
insert into public.tickets (numero, fecha, hora, quien, equipo, motivo, diagnostico, estado, prioridad, relato)
values (
  'T-001',
  '2026-11-19',
  '15:11',
  'Sucursal La 13',
  'Lunix',
  'Chequeo / mantenimiento de Lunix, apagaron equipos para testear reinicio',
  'A constatar',
  'Pendiente',
  'Media',
  'Hola desde la sucursal 13 están haciendo chequeo los chicos de Lunix y por ese motivo apagaron los equipos y te estamos testeando que al reiniciarlos ya levantó todo, están haciendo una tarea de mantenimiento'
)
on conflict (numero) do nothing;

-- 6. Verificación final de registros
select numero, fecha, hora, quien, equipo, estado, creado_en from public.tickets order by creado_en desc;
