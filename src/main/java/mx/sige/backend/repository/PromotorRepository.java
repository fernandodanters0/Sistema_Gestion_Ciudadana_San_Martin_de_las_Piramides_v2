package mx.sige.backend.repository;

import mx.sige.backend.model.Promotor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PromotorRepository extends JpaRepository<Promotor, Integer> {
    List<Promotor> findByIdOrganizacion(Integer idOrganizacion);

    long countByIdOrganizacionAndIdEstatus(Integer idOrg, Byte idEstatus);
}