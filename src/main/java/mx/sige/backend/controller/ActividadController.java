package mx.sige.backend.controller;

import mx.sige.backend.dto.ApiResponse;
import mx.sige.backend.model.Actividad;
import mx.sige.backend.repository.ActividadRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/actividades")
public class ActividadController {

    private final ActividadRepository repository;

    public ActividadController(ActividadRepository repository) {
        this.repository = repository;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Actividad>> registrar(@RequestBody Actividad actividad) {
        return ResponseEntity.ok(new ApiResponse<>(true, "Actividad de campo agendada", repository.save(actividad)));
    }

    @GetMapping("/promotor/{id}")
    public ResponseEntity<ApiResponse<List<Actividad>>> porPromotor(@PathVariable Integer id) {
        return ResponseEntity.ok(new ApiResponse<>(true, "Actividades del promotor", repository.findByIdPromotor(id)));
    }

    @GetMapping("/ciudadano/{id}")
    public ResponseEntity<ApiResponse<List<Actividad>>> porCiudadano(@PathVariable Integer id) {
        return ResponseEntity.ok(new ApiResponse<>(true, "Historial del ciudadano", repository.findByIdCiudadano(id)));
    }

    @GetMapping("/pendientes")
    public ResponseEntity<ApiResponse<List<Actividad>>> listarPendientes() {
        return ResponseEntity.ok(new ApiResponse<>(true, "Actividades pendientes obtenidas",
                repository.findByIdResultadoActividad((byte) 1)));
    }

    @PatchMapping("/{id}/resultado")
    public ResponseEntity<ApiResponse<Actividad>> resolverActividad(
            @PathVariable Integer id,
            @RequestBody Actividad datosResultado) {
        return repository.findById(id).map(act -> {
            act.setIdResultadoActividad(datosResultado.getIdResultadoActividad());
            act.setObservacionesResultado(datosResultado.getObservacionesResultado());
            return ResponseEntity
                    .ok(new ApiResponse<>(true, "Resultado de actividad actualizado con éxito", repository.save(act)));
        }).orElse(ResponseEntity.notFound().build());
    }
}