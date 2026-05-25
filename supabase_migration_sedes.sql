-- =====================================================
-- MIGRACIÓN: Agregar columna SEDE
-- Ejecutar en: Supabase > SQL Editor
-- =====================================================

-- 1. Agregar columna sede a la tabla clients
ALTER TABLE clients ADD COLUMN IF NOT EXISTS sede text NOT NULL DEFAULT 'sin sede';

-- 2. Reemplazar la restricción UNIQUE de solo "name"
--    por una UNIQUE compuesta (name + sede)
--    (permite que el mismo cliente exista en ambas sedes)
ALTER TABLE clients DROP CONSTRAINT IF EXISTS clients_name_key;
ALTER TABLE clients ADD CONSTRAINT clients_name_sede_key UNIQUE (name, sede);

-- 3. Agregar columna sede a la tabla redemptions
ALTER TABLE redemptions ADD COLUMN IF NOT EXISTS sede text DEFAULT 'sin sede';
