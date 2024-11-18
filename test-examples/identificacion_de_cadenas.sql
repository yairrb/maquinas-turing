CREATE
    OR REPLACE FUNCTION identificacion_cadenas(cinta TEXT) RETURNS SETOF traza_ejecucion AS
$$
BEGIN
    PERFORM
        simuladorMT(cinta);
    RETURN QUERY SELECT * FROM traza_ejecucion;
END;
$$
    LANGUAGE plpgsql;

-- Ejemplo de transiciones para la MT
TRUNCATE TABLE programa;
TRUNCATE TABLE alfabeto;

-- Insertar los caracteres
INSERT INTO alfabeto (caracter)
VALUES ('0'),
       ('1'),
       ('X'),
       ('Y'),
       ('B');

INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento)
VALUES
    ('q0', '0', 'q1', 'X', 'R'),
    ('q0', 'Y', 'q3', 'Y', 'R'),
    ('q1', '0', 'q1', '0', 'R'),
    ('q1', '1', 'q2', 'Y', 'L'),
    ('q1', 'Y', 'q1', 'Y', 'R'),
    ('q2', '0', 'q2', '0', 'L'),
    ('q2', 'X', 'q0', 'X', 'R'),
    ('q2', 'Y', 'q2', 'Y', 'L'),
    ('q3', 'Y', 'q3', 'Y', 'R'),
    ('q3', 'B', 'qf', 'B', 'R');

-- Ejemplo de uso de la funcion para iniciar la simulacion
SELECT *
FROM identificacion_cadenas('00111B');
