-- =============================================================================
-- V2__schema_tablas.sql
-- Definición estructural de tablas relacionales, FK e Índices
-- =============================================================================

CREATE TABLE organizaciones (
    id_organizacion      INT          PRIMARY KEY AUTO_INCREMENT,
    nombre_organizacion  VARCHAR(150) NOT NULL,
    id_tipo_organizacion TINYINT      NOT NULL,
    partido_politico     VARCHAR(100) NULL,
    localidad            VARCHAR(150) NOT NULL,
    contrato_inicio      DATE         NOT NULL,
    contrato_fin         DATE         NULL,
    contrato_activo      BOOLEAN      DEFAULT TRUE,
    configuracion        JSON         NULL,
    fecha_registro       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    id_registrado_por    INT          NULL,
    FOREIGN KEY (id_tipo_organizacion) REFERENCES cat_tipo_organizacion(id_tipo),
    INDEX idx_org_activa (contrato_activo)
) ENGINE=InnoDB;

CREATE TABLE roles (
    id_rol       INT          PRIMARY KEY AUTO_INCREMENT,
    nombre_rol   VARCHAR(50)  UNIQUE NOT NULL,
    descripcion  VARCHAR(255) NULL,
    nivel_acceso TINYINT      NOT NULL CHECK (nivel_acceso BETWEEN 1 AND 10),
    permisos     JSON         NULL
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id_usuario                 INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion            INT          NOT NULL,
    nombre_usuario             VARCHAR(30)  UNIQUE NOT NULL,
    correo_electronico         VARCHAR(100) UNIQUE NOT NULL,
    contrasena_hash            VARCHAR(255) NOT NULL,
    nombre_completo            VARCHAR(150) NOT NULL,
    telefono                   VARCHAR(10)  NULL,
    id_rol                     INT          NOT NULL,
    activo                     BOOLEAN      DEFAULT TRUE,
    fecha_registro             TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso              TIMESTAMP    NULL,
    intentos_fallidos          TINYINT      DEFAULT 0,
    bloqueado_hasta            TIMESTAMP    NULL,
    requiere_cambio_contrasena BOOLEAN      DEFAULT FALSE,
    fecha_cambio_contrasena    TIMESTAMP    NULL,
    CONSTRAINT chk_usuario_correo CHECK (correo_electronico REGEXP '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'),
    CONSTRAINT chk_usuario_telefono CHECK (telefono IS NULL OR telefono REGEXP '^[0-9]{10}$'),
    FOREIGN KEY (id_organizacion) REFERENCES organizaciones(id_organizacion),
    FOREIGN KEY (id_rol)          REFERENCES roles(id_rol),
    INDEX idx_usuario_org    (id_organizacion),
    INDEX idx_usuario_activo (activo)
) ENGINE=InnoDB;

ALTER TABLE organizaciones
    ADD CONSTRAINT fk_org_registrado_por
    FOREIGN KEY (id_registrado_por) REFERENCES usuarios(id_usuario);

CREATE TABLE secciones (
    id_seccion       INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion  INT          NOT NULL,
    numero_seccion   VARCHAR(10)  NOT NULL,
    comunidad        VARCHAR(100) NOT NULL,
    municipio        VARCHAR(100) NULL,
    distrito_local   VARCHAR(10)  NULL,
    distrito_federal VARCHAR(10)  NULL,
    activo           BOOLEAN      DEFAULT TRUE,
    fecha_registro   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_organizacion) REFERENCES organizaciones(id_organizacion),
    UNIQUE KEY uk_seccion_org (id_organizacion, numero_seccion),
    INDEX idx_seccion_comunidad (comunidad)
) ENGINE=InnoDB;

CREATE TABLE ciudadanos (
    id_ciudadano           INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion        INT          NOT NULL,
    nombre                 VARCHAR(50)  NOT NULL,
    apellido_paterno       VARCHAR(50)  NOT NULL,
    apellido_materno       VARCHAR(50)  NULL,
    fecha_nacimiento       DATE         NULL,
    curp                   CHAR(18)     NULL,
    telefono_principal     VARCHAR(10)  NOT NULL,
    telefono_secundario    VARCHAR(10)  NULL,
    correo_electronico     VARCHAR(100) NULL,
    id_seccion             INT          NULL,
    consentimiento         BOOLEAN      DEFAULT FALSE,
    fecha_consentimiento   TIMESTAMP    NULL,
    id_medio_contacto      TINYINT      NOT NULL DEFAULT 5,
    horario_contacto       VARCHAR(50)  NULL,
    nivel_privacidad_datos TINYINT      NOT NULL DEFAULT 3 CHECK (nivel_privacidad_datos BETWEEN 1 AND 10),
    activo                 BOOLEAN      DEFAULT TRUE,
    fecha_registro         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion    TIMESTAMP    NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_ciudadano_tel_principal CHECK (telefono_principal REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_ciudadano_tel_secundario CHECK (telefono_secundario IS NULL OR telefono_secundario REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_ciudadano_correo CHECK (correo_electronico IS NULL OR correo_electronico REGEXP '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'),
    CONSTRAINT chk_ciudadano_curp CHECK (curp IS NULL OR curp REGEXP '^[A-Z]{4}[0-9]{6}[A-Z0-9]{8}$'),
    FOREIGN KEY (id_organizacion)   REFERENCES organizaciones(id_organizacion),
    FOREIGN KEY (id_seccion)        REFERENCES secciones(id_seccion),
    FOREIGN KEY (id_medio_contacto) REFERENCES cat_medio_contacto(id_medio),
    INDEX idx_ciudadano_org      (id_organizacion),
    INDEX idx_ciudadano_telefono (telefono_principal),
    INDEX idx_ciudadano_nombre   (nombre, apellido_paterno)
) ENGINE=InnoDB;

CREATE TABLE domicilios (
    id_domicilio         INT          PRIMARY KEY AUTO_INCREMENT,
    id_ciudadano         INT          NOT NULL,
    calle                VARCHAR(150) NULL,
    numero_exterior      VARCHAR(10)  NULL,
    numero_interior      VARCHAR(10)  NULL,
    colonia              VARCHAR(100) NULL,
    codigo_postal        CHAR(5)      NULL,
    referencia_domicilio TEXT         NULL,
    activo               BOOLEAN      DEFAULT TRUE,
    fecha_inicio         DATE         NOT NULL,
    fecha_fin            DATE         NULL,
    id_registrado_por    INT          NULL,
    fecha_registro       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_domicilio_cp CHECK (codigo_postal IS NULL OR codigo_postal REGEXP '^[0-9]{5}$'),
    FOREIGN KEY (id_ciudadano)      REFERENCES ciudadanos(id_ciudadano) ON DELETE CASCADE,
    FOREIGN KEY (id_registrado_por) REFERENCES usuarios(id_usuario),
    INDEX idx_domicilio_ciudadano (id_ciudadano),
    INDEX idx_domicilio_activo    (activo)
) ENGINE=InnoDB;

CREATE TABLE etiquetas (
    id_etiqueta     INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion INT          NOT NULL,
    nombre_etiqueta VARCHAR(50)  NOT NULL,
    descripcion     VARCHAR(255) NULL,
    color           VARCHAR(7)   NULL,
    activo          BOOLEAN      DEFAULT TRUE,
    CONSTRAINT chk_etiqueta_color CHECK (color IS NULL OR color REGEXP '^#[0-9A-Fa-f]{6}$'),
    FOREIGN KEY (id_organizacion) REFERENCES organizaciones(id_organizacion),
    UNIQUE KEY uk_etiqueta_org (id_organizacion, nombre_etiqueta)
) ENGINE=InnoDB;

CREATE TABLE ciudadano_etiquetas (
    id_ciudadano     INT       NOT NULL,
    id_etiqueta      INT       NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_asignado_por  INT       NULL,
    PRIMARY KEY (id_ciudadano, id_etiqueta),
    FOREIGN KEY (id_ciudadano)    REFERENCES ciudadanos(id_ciudadano) ON DELETE CASCADE,
    FOREIGN KEY (id_etiqueta)     REFERENCES etiquetas(id_etiqueta),
    FOREIGN KEY (id_asignado_por) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE promotores (
    id_promotor            INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion        INT          NOT NULL,
    id_usuario             INT          UNIQUE NULL,
    nombre                 VARCHAR(50)  NOT NULL,
    apellido_paterno       VARCHAR(50)  NOT NULL,
    apellido_materno       VARCHAR(50)  NULL,
    telefono               VARCHAR(10)  NOT NULL,
    correo_electronico     VARCHAR(100) UNIQUE NULL,
    fecha_ingreso          DATE         NOT NULL,
    id_estatus             TINYINT      NOT NULL DEFAULT 1,
    carga_maxima_contactos SMALLINT     DEFAULT 100,
    activo                 BOOLEAN      NOT NULL DEFAULT TRUE,
    notas_internas         TEXT         NULL,
    fecha_registro         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_promotor_telefono CHECK (telefono REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_promotor_correo CHECK (correo_electronico IS NULL OR correo_electronico REGEXP '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'),
    FOREIGN KEY (id_organizacion) REFERENCES organizaciones(id_organizacion),
    FOREIGN KEY (id_usuario)      REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_estatus)      REFERENCES cat_estatus_promotor(id_estatus),
    INDEX idx_promotor_org     (id_organizacion),
    INDEX idx_promotor_estatus (id_estatus)
) ENGINE=InnoDB;

CREATE TABLE asignacion_secciones_promotores (
    id_asignacion   INT       PRIMARY KEY AUTO_INCREMENT,
    id_promotor     INT       NOT NULL,
    id_seccion      INT       NOT NULL,
    fecha_inicio    DATE      NOT NULL,
    fecha_fin       DATE      NULL,
    activo          BOOLEAN   DEFAULT TRUE,
    motivo          TEXT      NULL,
    id_asignado_por INT       NOT NULL,
    fecha_registro  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_promotor)     REFERENCES promotores(id_promotor),
    FOREIGN KEY (id_seccion)      REFERENCES secciones(id_seccion),
    FOREIGN KEY (id_asignado_por) REFERENCES usuarios(id_usuario),
    UNIQUE KEY uk_asignacion_activa (id_promotor, id_seccion, activo)
) ENGINE=InnoDB;

CREATE TABLE ciudadano_promotor (
    id_relacion       INT       PRIMARY KEY AUTO_INCREMENT,
    id_ciudadano      INT       NOT NULL,
    id_promotor       INT       NOT NULL,
    id_tipo_vinculo   TINYINT   NOT NULL,
    es_principal      BOOLEAN   DEFAULT FALSE,
    fecha_inicio      DATE      NOT NULL,
    fecha_fin         DATE      NULL,
    motivo            TEXT      NULL,
    id_autorizado_por INT       NULL,
    activo            BOOLEAN   DEFAULT TRUE,
    fecha_registro    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ciudadano)      REFERENCES ciudadanos(id_ciudadano),
    FOREIGN KEY (id_promotor)       REFERENCES promotores(id_promotor),
    FOREIGN KEY (id_tipo_vinculo)   REFERENCES cat_tipo_vinculo(id_tipo),
    FOREIGN KEY (id_autorizado_por) REFERENCES usuarios(id_usuario),
    INDEX idx_relacion_activa (activo)
) ENGINE=InnoDB;

CREATE TABLE acciones_comunitarias (
    id_accion             INT          PRIMARY KEY AUTO_INCREMENT,
    id_organizacion       INT          NOT NULL,
    nombre                VARCHAR(200) NOT NULL,
    descripcion           TEXT         NULL,
    tipo                  VARCHAR(50)  NULL,
    fecha_inicio          DATE         NULL,
    fecha_fin             DATE         NULL,
    id_responsable        INT          NULL,
    id_estatus_accion     TINYINT      NOT NULL DEFAULT 1,
    notas_administrativas TEXT         NULL,
    fecha_registro        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    id_registrado_por     INT          NULL,
    FOREIGN KEY (id_organizacion)   REFERENCES organizaciones(id_organizacion),
    FOREIGN KEY (id_responsable)    REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_registrado_por) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_estatus_accion) REFERENCES cat_estatus_accion(id_estatus),
    INDEX idx_accion_org     (id_organizacion),
    INDEX idx_accion_estatus (id_estatus_accion)
) ENGINE=InnoDB;

CREATE TABLE participacion_acciones (
    id_participacion    INT       PRIMARY KEY AUTO_INCREMENT,
    id_accion           INT       NOT NULL,
    id_ciudadano        INT       NOT NULL,
    fecha_participacion DATE      NOT NULL,
    confirmado          BOOLEAN   DEFAULT FALSE,
    observaciones       TEXT      NULL,
    id_registrado_por   INT       NULL,
    fecha_registro      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_accion)         REFERENCES acciones_comunitarias(id_accion),
    FOREIGN KEY (id_ciudadano)      REFERENCES ciudadanos(id_ciudadano),
    FOREIGN KEY (id_registrado_por) REFERENCES usuarios(id_usuario),
    UNIQUE KEY uk_participacion (id_accion, id_ciudadano)
) ENGINE=InnoDB;

CREATE TABLE seguimiento_actividades (
    id_actividad            INT          PRIMARY KEY AUTO_INCREMENT,
    id_ciudadano            INT          NULL,
    id_promotor             INT          NOT NULL,
    id_tipo_actividad       TINYINT      NOT NULL,
    titulo                  VARCHAR(200) NOT NULL,
    descripcion             TEXT         NULL,
    fecha_programada        DATE         NOT NULL,
    hora_programada         TIME         NULL,
    fecha_realizacion       DATE         NULL,
    id_resultado_actividad  TINYINT      NOT NULL DEFAULT 1,
    observaciones_resultado TEXT         NULL,
    reagendada_para         DATE         NULL,
    fecha_registro          TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    id_registrado_por       INT          NULL,
    FOREIGN KEY (id_ciudadano)           REFERENCES ciudadanos(id_ciudadano),
    FOREIGN KEY (id_promotor)            REFERENCES promotores(id_promotor),
    FOREIGN KEY (id_tipo_actividad)      REFERENCES cat_tipo_actividad(id_tipo),
    FOREIGN KEY (id_resultado_actividad) REFERENCES cat_resultado_actividad(id_resultado),
    FOREIGN KEY (id_registrado_por)      REFERENCES usuarios(id_usuario),
    INDEX idx_actividad_fecha     (fecha_programada),
    INDEX idx_actividad_promotor  (id_promotor),
    INDEX idx_actividad_resultado (id_resultado_actividad)
) ENGINE=InnoDB;

CREATE TABLE bitacora (
    id_bitacora    INT         PRIMARY KEY AUTO_INCREMENT,
    id_usuario     INT         NOT NULL,
    accion         VARCHAR(50) NOT NULL,
    tabla_afectada VARCHAR(50) NULL,
    id_registro    INT         NULL,
    datos_previos  JSON        NULL,
    datos_nuevos   JSON        NULL,
    direccion_ip   VARCHAR(45) NULL,
    agente_usuario TEXT        NULL,
    fecha          TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    INDEX idx_bitacora_usuario (id_usuario),
    INDEX idx_bitacora_fecha   (fecha),
    INDEX idx_bitacora_tabla   (tabla_afectada)
) ENGINE=InnoDB;

CREATE TABLE notificaciones (
    id_notificacion    INT       PRIMARY KEY AUTO_INCREMENT,
    id_usuario_destino INT       NOT NULL,
    id_tipo_notif      TINYINT   NOT NULL,
    mensaje            TEXT      NOT NULL,
    leido              BOOLEAN   DEFAULT FALSE,
    fecha_leido        TIMESTAMP NULL,
    fecha_notificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario_destino) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_notif)      REFERENCES cat_tipo_notificacion(id_tipo),
    INDEX idx_notificacion_usuario (id_usuario_destino),
    INDEX idx_notificacion_leido   (leido)
) ENGINE=InnoDB;

CREATE TABLE sesiones_activas (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    dispositivo VARCHAR(255),
    fecha_creacion DATETIME NOT NULL,
    fecha_expiracion DATETIME NOT NULL
) ENGINE=InnoDB;