-- =====================================================
-- PELIKANO PUNTOS — Setup Supabase
-- Ejecutar en: Supabase > SQL Editor > New query
-- =====================================================

-- 1. CREAR TABLAS
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS clients (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text UNIQUE NOT NULL,
  total      numeric DEFAULT 0,
  redeemed   numeric DEFAULT 0,
  pts4       numeric DEFAULT 0,
  pts8       numeric DEFAULT 0,
  units4     numeric DEFAULT 0,
  units8     numeric DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS import_history (
  id               uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  file_name        text,
  sales_date       text,
  points_added     numeric DEFAULT 0,
  lines_processed  integer DEFAULT 0,
  lines_skipped    integer DEFAULT 0,
  clients_updated  integer DEFAULT 0,
  created_at       timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS redemptions (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  client_name text NOT NULL,
  prize_id    integer,
  prize_name  text,
  prize_emoji text,
  qty         integer DEFAULT 1,
  cost        numeric DEFAULT 0,
  pts_after   numeric DEFAULT 0,
  created_at  timestamptz DEFAULT now()
);

-- 2. HABILITAR RLS (Row Level Security)
-- -------------------------------------------------------
ALTER TABLE clients        ENABLE ROW LEVEL SECURITY;
ALTER TABLE import_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE redemptions    ENABLE ROW LEVEL SECURITY;

-- 3. POLITICAS DE ACCESO
-- Permite que la clave anon (publica) pueda leer y escribir
-- -------------------------------------------------------
DROP POLICY IF EXISTS "anon_all_clients"        ON clients;
DROP POLICY IF EXISTS "anon_all_import_history" ON import_history;
DROP POLICY IF EXISTS "anon_all_redemptions"    ON redemptions;

CREATE POLICY "anon_all_clients"
  ON clients FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "anon_all_import_history"
  ON import_history FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "anon_all_redemptions"
  ON redemptions FOR ALL TO anon USING (true) WITH CHECK (true);
