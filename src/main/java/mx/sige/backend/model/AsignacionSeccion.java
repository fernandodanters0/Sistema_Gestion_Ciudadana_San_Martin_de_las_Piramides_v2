package mx.sige.backend.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "asignacion_secciones_promotores")
public class AsignacionSeccion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idAsignacion;
    private Integer idPromotor;
    private Integer idSeccion;
    private LocalDate fechaInicio;
    private Boolean activo = true;
    private String motivo;

    private Integer idAsignadoPor;

    // Getters y Setters
    public Integer getIdAsignacion() {
        return idAsignacion;
    }

    public void setIdAsignacion(Integer idAsignacion) {
        this.idAsignacion = idAsignacion;
    }

    public Integer getIdPromotor() {
        return idPromotor;
    }

    public void setIdPromotor(Integer idPromotor) {
        this.idPromotor = idPromotor;
    }

    public Integer getIdSeccion() {
        return idSeccion;
    }

    public void setIdSeccion(Integer idSeccion) {
        this.idSeccion = idSeccion;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public Integer getIdAsignadoPor() {
        return idAsignadoPor;
    }

    public void setIdAsignadoPor(Integer idAsignadoPor) {
        this.idAsignadoPor = idAsignadoPor;
    }
}