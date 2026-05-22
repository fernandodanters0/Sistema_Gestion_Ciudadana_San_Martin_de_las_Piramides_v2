package mx.sige.backend.repository;

import mx.sige.backend.model.Ciudadano;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface CiudadanoRepository extends JpaRepository<Ciudadano, Integer> {
    List<Ciudadano> findByIdOrganizacionAndActivoTrue(Integer idOrganizacion);

    @Query("SELECT c FROM Ciudadano c WHERE c.idOrganizacion = :idOrg AND c.activo = true AND " +
            "(LOWER(c.nombre) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(c.apellidoPaterno) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<Ciudadano> buscarPorNombre(@Param("idOrg") Integer idOrg, @Param("query") String query);

    long countByIdOrganizacion(Integer idOrganizacion);

    Optional<Ciudadano> findByIdCiudadanoAndIdOrganizacionAndActivoTrue(Integer idCiudadano, Integer idOrganizacion);
}