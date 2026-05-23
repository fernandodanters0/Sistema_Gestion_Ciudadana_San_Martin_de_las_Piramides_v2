# SIGE — Backend (Sistema Integral de Gestión Electoral)

Este repositorio contiene la API REST core de **SIGE**, un sistema artesanal y de alto rendimiento diseñado para la gestión ciudadana, coordinación de promotores en campo, asignaciones territoriales y seguimiento de actividades electorales.

## Tecnologias presentes en el proyecto

* **Java 21** (JDK 21)
* **Spring Boot 3.2.5**
* **Spring Data JPA** & **Hibernate 6** (Capa de Persistencia Nativa)
* **Flyway Database Migrations** (Control de versiones de base de datos)
* **MySQL 8.x / 9.x** (Motor Relacional)
* **Springdoc-openapi / Swagger UI** (Documentación interactiva de endpoints)

---

## 📁 Estructura del Proyecto

La arquitectura del software sigue un diseño multicapa desacoplado de forma manual y limpia:

```text
src/main/java/mx/sige/backend/
├── Main.java               # Clase principal de arranque de Spring Boot
├── controller/             # Endpoints REST expuestos (Auth, Ciudadanos, Promotores, etc.)
├── dto/                    # Objetos de Transferencia de Datos (Request payloads y validaciones)
├── model/                  # Entidades de persistencia Jakarta/JPA (Mapeo físico a MySQL)
├── repository/             # Interfaces Spring Data JPA con consultas personalizadas (@Query)
└── response/               # Clase envolvente unificada genérica ApiResponse<T>
