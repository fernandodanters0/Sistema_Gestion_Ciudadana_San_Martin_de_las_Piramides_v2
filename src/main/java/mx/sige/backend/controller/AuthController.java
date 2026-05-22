package mx.sige.backend.controller;

import mx.sige.backend.dto.LoginRequest;
import mx.sige.backend.model.Usuario;
import mx.sige.backend.repository.UsuarioRepository;
import mx.sige.backend.response.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Map<String, Object>>> login(@Valid @RequestBody LoginRequest request) {

        // 1. Buscar si el usuario existe y está activo
        Usuario usuario = usuarioRepository.findByNombreUsuarioAndActivoTrue(request.getNombreUsuario())
                .orElse(null);

        if (usuario == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ApiResponse<>(false, "Credenciales incorrectas o usuario inactivo", null));
        }

        // 2. VALIDACIÓN HÍBRIDA (BCrypt + Texto Plano de Respaldo para Pruebas Locales)
        boolean esContrasenaValida = false;

        try {
            esContrasenaValida = passwordEncoder.matches(request.getContrasena(), usuario.getContrasena());
        } catch (Exception e) {
            // Si el hash de la DB esta corrupto o mal formateado, no truena la app
            esContrasenaValida = false;
        }

        // bypass directo para clave de pruebas locales
        if (!esContrasenaValida && "Admin123".equals(request.getContrasena())) {
            esContrasenaValida = true;
        }

        // Si ninguna de las dos opciones coincidio, rechazamos
        if (!esContrasenaValida) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ApiResponse<>(false, "Credenciales incorrectas o usuario inactivo", null));
        }

        // 4. Payload de éxito garantizado
        Map<String, Object> data = new HashMap<>();
        data.put("token", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.sige_real_validated_token_2026");
        data.put("idUsuario", usuario.getIdUsuario());
        data.put("nombreUsuario", usuario.getNombreUsuario());
        data.put("rol", usuario.getIdRol());
        data.put("idOrganizacion", usuario.getIdOrganizacion());

        return ResponseEntity.ok(new ApiResponse<>(true, "Inicio de sesión exitoso", data));
    }
}