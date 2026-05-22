package mx.sige.backend.controller;

import mx.sige.backend.dto.ApiResponse;
import mx.sige.backend.dto.DashboardMetrics;
import mx.sige.backend.repository.CiudadanoRepository;
import mx.sige.backend.repository.PromotorRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DashboardController {

    private final CiudadanoRepository ciudadanoRepo;
    private final PromotorRepository promotorRepo;

    public DashboardController(CiudadanoRepository ciudadanoRepo, PromotorRepository promotorRepo) {
        this.ciudadanoRepo = ciudadanoRepo;
        this.promotorRepo = promotorRepo;
    }

    @GetMapping("/api/dashboard")
    public ResponseEntity<ApiResponse<DashboardMetrics>> obtenerMetricas(@RequestParam Integer idOrganizacion) {
        long ciudadanos = ciudadanoRepo.countByIdOrganizacion(idOrganizacion);
        long promotores = promotorRepo.findByIdOrganizacion(idOrganizacion).size();
        long activos = promotorRepo.countByIdOrganizacionAndIdEstatus(idOrganizacion, (byte) 1);
        DashboardMetrics metrics = new DashboardMetrics(ciudadanos, promotores, activos);
        return ResponseEntity.ok(new ApiResponse<>(true, "Métricas del dashboard", metrics));
    }
}