package mx.sige.backend.repository;

import mx.sige.backend.model.Actividad;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ActividadRepository extends JpaRepository<Actividad, Integer> {
    List<Actividad> findByIdPromotor(Integer idPromotor);

    List<Actividad> findByIdCiudadano(Integer idCiudadano);

    List<Actividad> findByIdResultadoActividad(Byte idResultadoActividad);
}