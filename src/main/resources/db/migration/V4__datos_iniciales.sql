-- =============================================================================
-- V4__datos_iniciales.sql
-- Datos base del sistema: roles · organización inicial · usuarios del sistema
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE usuarios;
TRUNCATE TABLE organizaciones;
TRUNCATE TABLE roles;
TRUNCATE TABLE promotores;
TRUNCATE TABLE ciudadanos;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- Roles
-- -----------------------------------------------------------------------------

INSERT INTO roles (nombre_rol, descripcion, nivel_acceso, permisos) VALUES
    ('Administrador Sistema',      'Acceso total al sistema',                        10, '{"todo": true}'),
    ('Coordinador General',        'Gestión de organizaciones y supervisión',          8, '{"organizaciones": "all", "usuarios": "all"}'),
    ('Administrador Organización', 'Administración de una organización específica',    7, '{"organizacion": "admin"}'),
    ('Coordinador',                'Coordinación de promotores y seguimiento',         5, '{"promotores": "all", "seguimiento": "all"}'),
    ('Promotor',                   'Gestión de ciudadanos y actividades',              3, '{"ciudadanos": "crud", "actividades": "crud"}'),
    ('Consultor',                  'Solo consulta de información',                     1, '{"read": "all"}');

-- -----------------------------------------------------------------------------
-- Organización inicial
-- -----------------------------------------------------------------------------

INSERT INTO organizaciones (nombre_organizacion, id_tipo_organizacion, localidad, contrato_inicio, contrato_activo) VALUES
    ('Organización Principal', 1, 'Ciudad de México', '2024-01-01', TRUE);

-- -----------------------------------------------------------------------------
-- Usuarios del sistema
-- NOTA: Todos los usuarios de sistema usan ahora el hash de 'Admin123'
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Usuarios del sistema
-- NOTA: Todos los usuarios usan ahora el hash certificado de 'Admin123'
-- -----------------------------------------------------------------------------

INSERT INTO usuarios (
    id_organizacion, nombre_usuario, correo_electronico,
    contrasena_hash, nombre_completo, id_rol,
    activo, requiere_cambio_contrasena
) VALUES
    (1, 'superadmin',  'admin@sige.local',         '$2a$10$7zB350A5YjS8e1XbK3qYI.bWqZ4xZ3lHhVjD8y5C7Gv9fHj7rW2.', 'Super Administrador',    1, TRUE, TRUE),
    (1, 'coord_gral',  'coord@sige.local',          '$2a$10$7zB350A5YjS8e1XbK3qYI.bWqZ4xZ3lHhVjD8y5C7Gv9fHj7rW2.', 'Coordinador General',    2, TRUE, TRUE),
    (1, 'admin_org',   'admin.org@sige.local',      '$2a$10$7zB350A5YjS8e1XbK3qYI.bWqZ4xZ3lHhVjD8y5C7Gv9fHj7rW2.', 'Administrador de Org.',  3, TRUE, TRUE);
    
-- Vincular la organización con el usuario que la registró
UPDATE organizaciones
   SET id_registrado_por = (SELECT id_usuario FROM usuarios WHERE nombre_usuario = 'superadmin')
 WHERE id_organizacion = 1;

-- -----------------------------------------------------------------------------
-- Secciones Geográficas
-- -----------------------------------------------------------------------------

INSERT INTO secciones (id_organizacion, numero_seccion, comunidad, municipio, activo) VALUES
    (1, '0101', 'Col. Centro',      'Zumpango', TRUE),
    (1, '0102', 'Col. San Juan',    'Zumpango', TRUE),
    (1, '0103', 'Col. Las Flores',  'Zumpango', TRUE),
    (1, '0104', 'Col. El Mirador',  'Zumpango', TRUE);
    
-- -----------------------------------------------------------------------------
-- Datos de prueba: Ciudadanos
-- -----------------------------------------------------------------------------

INSERT INTO ciudadanos (
    id_organizacion, nombre, apellido_paterno, apellido_materno,
    fecha_nacimiento, telefono_principal, correo_electronico,
    id_seccion, consentimiento, id_medio_contacto, nivel_privacidad_datos, activo
) VALUES
    (1, 'Juan',    'García',    'López',    '1990-05-15', '5512345601', 'juan.garcia@gmail.com',     1, TRUE,  1, 3, TRUE),
    (1, 'María',   'Hernández', 'Torres',   '1985-08-22', '5512345602', 'maria.hernandez@gmail.com', 1, TRUE,  2, 3, TRUE),
    (1, 'Carlos',  'Martínez',  'Ruiz',     '1992-03-10', '5512345603', NULL,                        2, FALSE, 5, 3, TRUE),
    (1, 'Ana',     'López',     'Sánchez',  '1988-11-30', '5512345604', 'ana.lopez@hotmail.com',     2, TRUE,  3, 3, TRUE),
    (1, 'Pedro',   'Ramírez',   'González', '1995-07-04', '5512345605', NULL,                        3, FALSE, 4, 3, TRUE),
    (1, 'Laura',   'Torres',    'Jiménez',  '1993-01-18', '5512345606', 'laura.torres@gmail.com',    3, TRUE,  2, 3, TRUE),
    (1, 'Roberto', 'Flores',    'Morales',  '1987-09-25', '5512345607', NULL,                        4, FALSE, 5, 5, TRUE),
    (1, 'Sandra',  'Díaz',      'Vargas',   '1991-12-08', '5512345608', 'sandra.diaz@gmail.com',     4, TRUE,  1, 3, TRUE);

-- -----------------------------------------------------------------------------
-- Datos de prueba: Promotores
-- -----------------------------------------------------------------------------

INSERT INTO promotores (
    id_organizacion, nombre, apellido_paterno, apellido_materno,
    telefono, correo_electronico, fecha_ingreso, id_estatus, carga_maxima_contactos
) VALUES
    (1, 'Luis',     'Mendoza', 'Castro',  '5598765401', 'luis.mendoza@sige.local',    '2024-01-15', 1, 100),
    (1, 'Carmen',   'Reyes',   'Medina',  '5598765402', 'carmen.reyes@sige.local',    '2024-02-01', 1,  80),
    (1, 'Miguel',   'Vargas',  'Ortiz',   '5598765403', 'miguel.vargas@sige.local',   '2024-03-10', 1, 120),
    (1, 'Patricia', 'Guzmán',  'Navarro', '5598765404', 'patricia.guzman@sige.local', '2024-01-20', 2, 100);