package mx.sige.backend.dto;

public class DashboardMetricas {
    private long totalCiudadanos;
    private long totalPromotores;
    private long promotoresActivos;

    public DashboardMetricas(long totalCiudadanos, long totalPromotores, long promotoresActivos) {
        this.totalCiudadanos = totalCiudadanos;
        this.totalPromotores = totalPromotores;
        this.promotoresActivos = promotoresActivos;
    }

    public long getTotalCiudadanos() {
        return totalCiudadanos;
    }

    public long getTotalPromotores() {
        return totalPromotores;
    }

    public long getPromotoresActivos() {
        return promotoresActivos;
    }
}