package mx.sige.backend.controller;

import mx.sige.backend.response.ApiResponse;
import mx.sige.backend.model.AsignacionSeccion;
import mx.sige.backend.model.Promotor;
import mx.sige.backend.repository.AsignacionRepository;
import mx.sige.backend.repository.PromotorRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class OperacionesController {

    private final PromotorRepository promotorRepo;
    private final AsignacionRepository asignacionRepo;

    public OperacionesController(PromotorRepository promotorRepo, AsignacionRepository asignacionRepo) {
        this.promotorRepo = promotorRepo;
        this.asignacionRepo = asignacionRepo;
    }

    @GetMapping("/promotores")
    public ResponseEntity<ApiResponse<List<Promotor>>> listarPromotores(@RequestParam Integer idOrganizacion) {
        return ResponseEntity
                .ok(new ApiResponse<>(true, "Promotores obtenidos", promotorRepo.findByIdOrganizacion(idOrganizacion)));
    }

    @PostMapping("/promotores")
    public ResponseEntity<ApiResponse<Promotor>> crearPromotor(@RequestBody Promotor p) {
        return ResponseEntity.ok(new ApiResponse<>(true, "Promotor creado", promotorRepo.save(p)));
    }

    @PostMapping("/asignaciones")
    public ResponseEntity<ApiResponse<AsignacionSeccion>> asignarSeccion(@RequestBody AsignacionSeccion asignacion) {
        if (asignacionRepo
                .findByIdPromotorAndIdSeccionAndActivoTrue(asignacion.getIdPromotor(), asignacion.getIdSeccion())
                .isPresent()) {
            throw new IllegalArgumentException("El promotor ya tiene una asignación activa en esa sección");
        }
        return ResponseEntity.ok(new ApiResponse<>(true, "Asignación creada", asignacionRepo.save(asignacion)));
    }

    @GetMapping("/asignaciones/promotor/{id}")
    public ResponseEntity<ApiResponse<List<AsignacionSeccion>>> listarPorPromotor(@PathVariable Integer id) {
        return ResponseEntity
                .ok(new ApiResponse<>(true, "Historial de asignaciones obtenido", asignacionRepo.findByIdPromotor(id)));
    }
}