package mx.sige.backend.repository;

import mx.sige.backend.model.AsignacionSeccion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AsignacionRepository extends JpaRepository<AsignacionSeccion, Integer> {
    Optional<AsignacionSeccion> findByIdPromotorAndIdSeccionAndActivoTrue(Integer idPromotor, Integer idSeccion);

    List<AsignacionSeccion> findByIdPromotor(Integer idPromotor);
}