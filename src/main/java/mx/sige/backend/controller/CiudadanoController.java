package mx.sige.backend.controller;

import jakarta.validation.Valid;
import mx.sige.backend.dto.ApiResponse;
import mx.sige.backend.model.Ciudadano;
import mx.sige.backend.repository.CiudadanoRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ciudadanos")
public class CiudadanoController {

    private final CiudadanoRepository repository;

    public CiudadanoController(CiudadanoRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Ciudadano>>> listar(
            @RequestParam Integer idOrganizacion,
            @RequestParam(required = false) String busqueda) {

        List<Ciudadano> lista;

        if (busqueda == null || busqueda.isBlank()) {
            lista = repository.findByIdOrganizacionAndActivoTrue(idOrganizacion);
        } else if (busqueda.matches("\\d+")) {
            Integer idEspecifico = Integer.parseInt(busqueda);
            lista = repository.findByIdCiudadanoAndIdOrganizacionAndActivoTrue(idEspecifico, idOrganizacion)
                    .map(List::of)
                    .orElse(List.of());
        } else {
            lista = repository.buscarPorNombre(idOrganizacion, busqueda);
        }

        return ResponseEntity.ok(new ApiResponse<>(true, "Ciudadanos obtenidos", lista));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Ciudadano>> registrar(@Valid @RequestBody Ciudadano ciudadano) {
        Ciudadano guardado = repository.save(ciudadano);
        return ResponseEntity.ok(new ApiResponse<>(true, "Ciudadano creado con éxito", guardado));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Ciudadano>> actualizar(@PathVariable Integer id,
            @Valid @RequestBody Ciudadano datos) {
        return repository.findById(id).map(c -> {
            c.setNombre(datos.getNombre());
            c.setApellidoPaterno(datos.getApellidoPaterno());
            c.setApellidoMaterno(datos.getApellidoMaterno());
            c.setTelefonoPrincipal(datos.getTelefonoPrincipal());
            c.setCorreoElectronico(datos.getCorreoElectronico());
            c.setConsentimiento(datos.getConsentimiento());
            Ciudadano act = repository.save(c);
            return ResponseEntity.ok(new ApiResponse<>(true, "Ciudadano actualizado", act));
        }).orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/activo")
    public ResponseEntity<ApiResponse<Ciudadano>> cambiarEstatus(@PathVariable Integer id,
            @RequestParam Boolean activo) {
        return repository.findById(id).map(c -> {
            c.setActivo(activo);
            repository.save(c);
            return ResponseEntity.ok(new ApiResponse<>(true, "Estatus actualizado", c));
        }).orElse(ResponseEntity.notFound().build());
    }
}