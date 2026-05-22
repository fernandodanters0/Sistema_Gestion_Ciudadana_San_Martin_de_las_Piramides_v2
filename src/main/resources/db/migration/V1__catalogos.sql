-- =============================================================================
-- V1__catalogos.sql
-- =============================================================================
CREATE TABLE cat_tipo_organizacion (
    id_tipo   TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave     VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta  VARCHAR(100) NOT NULL,
    orden     TINYINT      DEFAULT 0,
    activo    BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_tipo_organizacion (clave, etiqueta, orden) VALUES
    ('PARTIDO',    'Partido Político',  1),
    ('ASOC_CIVIL', 'Asociación Civil',  2),
    ('MOVIMIENTO', 'Movimiento Social', 3),
    ('OTRO',       'Otro',             99);

CREATE TABLE cat_estatus_promotor (
    id_estatus  TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave       VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta    VARCHAR(60)  NOT NULL,
    orden       TINYINT      DEFAULT 0,
    activo      BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_estatus_promotor (clave, etiqueta, orden) VALUES
    ('ACTIVO',     'Activo',     1),
    ('INACTIVO',   'Inactivo',   2),
    ('SUSPENDIDO', 'Suspendido', 3);

CREATE TABLE cat_tipo_vinculo (
    id_tipo   TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave     VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta  VARCHAR(60)  NOT NULL,
    orden     TINYINT      DEFAULT 0,
    activo    BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_tipo_vinculo (clave, etiqueta, orden) VALUES
    ('AMIGO',    'Amigo',    1),
    ('FAMILIAR', 'Familiar', 2),
    ('CONOCIDO', 'Conocido', 3),
    ('VECINO',   'Vecino',   4),
    ('OTRO',     'Otro',    99);

CREATE TABLE cat_medio_contacto (
    id_medio  TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave     VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta  VARCHAR(60)  NOT NULL,
    orden     TINYINT      DEFAULT 0,
    activo    BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_medio_contacto (clave, etiqueta, orden) VALUES
    ('TELEFONO',   'Teléfono',   1),
    ('WHATSAPP',   'WhatsApp',   2),
    ('EMAIL',      'Email',      3),
    ('VISITA',     'Visita',     4),
    ('INDISTINTO', 'Indistinto', 5);

CREATE TABLE cat_tipo_actividad (
    id_tipo   TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave     VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta  VARCHAR(60)  NOT NULL,
    orden     TINYINT      DEFAULT 0,
    activo    BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_tipo_actividad (clave, etiqueta, orden) VALUES
    ('VISITA',         'Visita',               1),
    ('LLAMADA',        'Llamada',              2),
    ('WHATSAPP',       'WhatsApp',             3),
    ('REUNION',        'Reunión',              4),
    ('EVENTO',         'Evento',               5),
    ('ADMINISTRATIVA', 'Tarea administrativa', 6);

CREATE TABLE cat_resultado_actividad (
    id_resultado  TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave         VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta      VARCHAR(60)  NOT NULL,
    orden         TINYINT      DEFAULT 0,
    activo        BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_resultado_actividad (clave, etiqueta, orden) VALUES
    ('PENDIENTE',     'Pendiente',     1),
    ('EXITOSA',       'Exitosa',       2),
    ('NO_CONTACTADO', 'No contactado', 3),
    ('RECHAZADA',     'Rechazada',     4),
    ('REAGENDADA',    'Reagendada',    5);

CREATE TABLE cat_estatus_accion (
    id_estatus  TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave       VARCHAR(30)  UNIQUE NOT NULL,
    etiqueta    VARCHAR(60)  NOT NULL,
    orden       TINYINT      DEFAULT 0,
    activo      BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_estatus_accion (clave, etiqueta, orden) VALUES
    ('PENDIENTE',  'Pendiente',  1),
    ('EN_PROCESO', 'En proceso', 2),
    ('CONCLUIDA',  'Concluida',  3),
    ('CANCELADA',  'Cancelada',  4);

CREATE TABLE cat_tipo_notificacion (
    id_tipo   TINYINT      PRIMARY KEY AUTO_INCREMENT,
    clave     VARCHAR(40)  UNIQUE NOT NULL,
    etiqueta  VARCHAR(80)  NOT NULL,
    orden     TINYINT      DEFAULT 0,
    activo    BOOLEAN      DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO cat_tipo_notificacion (clave, etiqueta, orden) VALUES
    ('BAJA_ACTIVIDAD',      'Baja actividad',          1),
    ('SIN_SEGUIMIENTO',     'Sección sin seguimiento', 2),
    ('TAREA_PENDIENTE',     'Tarea pendiente',         3),
    ('CARGA_MAX_ALCANZADA', 'Carga máxima alcanzada',  4),
    ('SISTEMA',             'Sistema',                 5);