-- Migración de ejemplo: Agregar campo phone_number a users
-- Autor: Sistema  
-- Fecha: 2025-12-23
-- Descripción: Ejemplo de cómo agregar una columna nueva

-- NOTA: Esta migración está comentada por defecto
-- Descomenta las líneas siguientes cuando quieras agregar este campo

-- ALTER TABLE users 
-- ADD COLUMN phone_number VARCHAR(20);

-- COMMENT ON COLUMN users.phone_number IS 'Número de teléfono del usuario';

-- Después de ejecutar esta migración, actualiza la entidad User.java:
-- private String phoneNumber;
