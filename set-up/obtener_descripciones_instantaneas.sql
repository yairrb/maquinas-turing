CREATE OR REPLACE FUNCTION obtener_descripciones_instantaneas()
    RETURNS TABLE
            (
                estado_actual    VARCHAR(255),
                cinta_actual     TEXT,
                posicion_cabezal INT,
                estado_siguiente VARCHAR(255),
                cinta_siguiente  TEXT,
                movimiento       CHAR(1),
                es_final         BOOLEAN
            )
AS
$$
BEGIN
    -- recuperar toda la traza
    RETURN QUERY
        SELECT t.estado_actual, t.cinta_actual, t.posicion_cabezal, t.estado_siguiente, t.cinta_siguiente, t.movimiento, t.es_final
        FROM traza_ejecucion as t; --todo: chequear el ordern. Tendria que agregar un id o step-number en la traza
END;
$$ LANGUAGE plpgsql;
