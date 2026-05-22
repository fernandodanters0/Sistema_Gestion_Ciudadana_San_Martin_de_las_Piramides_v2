package mx.sige.backend.response;

import java.util.Map;

public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private Map<String, String> errores;

    public ApiResponse(boolean success, String message, T data) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.errores = null;
    }

    public ApiResponse(boolean success, String message, T data, Map<String, String> errores) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.errores = errores;
    }

    // Getters y Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public Map<String, String> getErrores() {
        return errores;
    }

    public void setErrores(Map<String, String> errores) {
        this.errores = errores;
    }
}