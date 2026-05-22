package mx.sige.backend.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "seguimiento_actividades")
public class Actividad {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idActividad;
    private Integer idCiudadano;
    private Integer idPromotor;

    private Byte idTipoActividad;

    private String titulo;
    private String descripcion;
    private LocalDate fechaProgramada;

    private Byte idResultadoActividad = 1;

    private String observacionesResultado;

    // Getters y Setters 
    public Integer getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(Integer idActividad) {
        this.idActividad = idActividad;
    }

    public Integer getIdCiudadano() {
        return idCiudadano;
    }

    public void setIdCiudadano(Integer idCiudadano) {
        this.idCiudadano = idCiudadano;
    }

    public Integer getIdPromotor() {
        return idPromotor;
    }

    public void setIdPromotor(Integer idPromotor) {
        this.idPromotor = idPromotor;
    }

    public Byte getIdTipoActividad() {
        return idTipoActividad;
    }

    public void setIdTipoActividad(Byte idTipoActividad) {
        this.idTipoActividad = idTipoActividad;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDate getFechaProgramada() {
        return fechaProgramada;
    }

    public void setFechaProgramada(LocalDate fechaProgramada) {
        this.fechaProgramada = fechaProgramada;
    }

    public Byte getIdResultadoActividad() {
        return idResultadoActividad;
    }

    public void setIdResultadoActividad(Byte idResultadoActividad) {
        this.idResultadoActividad = idResultadoActividad;
    }

    public String getObservacionesResultado() {
        return observacionesResultado;
    }

    public void setObservacionesResultado(String observacionesResultado) {
        this.observacionesResultado = observacionesResultado;
    }
}