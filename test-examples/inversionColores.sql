CREATE OR REPLACE FUNCTION ejecutar_inversionColores(cinta TEXT) RETURNS SETOF traza_ejecucion AS
$$
BEGIN
    PERFORM simuladorMT(cinta);
    RETURN QUERY SELECT * FROM traza_ejecucion;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de transiciones para la MT
TRUNCATE TABLE programa;
TRUNCATE TABLE alfabeto;

-- Insertar los caracteres validos
INSERT INTO alfabeto (caracter)
VALUES ('W'),
       ('N'),
       ('R'),
       ('G'),
       ('B'),
       ('_');


INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento)
VALUES ('q0', 'W', 'q0', 'N', 'R'),
       ('q0', 'N', 'q0', 'N', 'R'),
       ('q0', 'R', 'q0', 'R', 'R'),
       ('q0', 'G', 'q0', 'G', 'R'),
       ('q0', 'B', 'q0', 'B', 'R'),
       ('q0', '_', 'qf', '_', 'S');

-- Ejemplo de uso de la funcion para iniciar la simulacion
SELECT *
FROM ejecutar_inversionColores('WWNRGB_W');
