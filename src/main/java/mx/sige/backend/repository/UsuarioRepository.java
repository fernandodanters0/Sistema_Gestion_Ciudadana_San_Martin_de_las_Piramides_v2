package mx.sige.backend.repository;

import mx.sige.backend.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByNombreUsuarioAndActivoTrue(String nombreUsuario);
}