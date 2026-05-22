DROP TRIGGER IF EXISTS trg_valida_promotor_principal;
DROP TRIGGER IF EXISTS trg_valida_promotor_principal_upd;

DELIMITER //

CREATE TRIGGER trg_valida_promotor_principal
    BEFORE INSERT ON ciudadano_promotor
    FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    IF NEW.es_principal = TRUE AND NEW.activo = TRUE THEN
        SELECT COUNT(*) INTO v_count
        FROM ciudadano_promotor
        WHERE id_ciudadano = NEW.id_ciudadano
          AND es_principal = TRUE
          AND activo       = TRUE;

        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El ciudadano ya cuenta con un promotor principal activo.';
        END IF;
    END IF;
END //

CREATE TRIGGER trg_valida_promotor_principal_upd
    BEFORE UPDATE ON ciudadano_promotor
    FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    IF NEW.es_principal = TRUE AND NEW.activo = TRUE THEN
        SELECT COUNT(*) INTO v_count
        FROM ciudadano_promotor
        WHERE id_ciudadano = NEW.id_ciudadano
          AND es_principal = TRUE
          AND activo       = TRUE
          AND id_relacion != NEW.id_relacion;

        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El ciudadano ya cuenta con un promotor principal activo.';
        END IF;
    END IF;
END //

DELIMITER ;