CREATE
    OR REPLACE FUNCTION ejecutar_ordenamiento_simbolos(cinta TEXT) RETURNS SETOF traza_ejecucion AS
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

INSERT INTO alfabeto (caracter)
VALUES ('1'),
       ('0'),
       ('B');


INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento)
VALUES ('q0', '0', 'q0', '0', 'R'),
       ('q0', '1', 'q1', '1', 'R'),
       ('q0', 'B', 'q0', 'B', 'R'),
       ('q1', '1', 'q1', '1', 'R'),
       ('q1', '0', 'q2', '1', 'L'),
       ('q1', 'B', 'qf', 'B', 'R'),
       ('q2', '1', 'q2', '1', 'L'),
       ('q2', 'B', 'q4', 'B', 'R'),
       ('q2', '0', 'q3', '0', 'R'),
       ('q3', '1', 'q1', '0', 'R'),
       ('q4', '1', 'q0', '0', 'R'),
       ('q4', 'B', 'qf', 'B', 'S');


-- Ejemplo de uso de la funcion para iniciar la simulacion
SELECT *
FROM ejecutar_ordenamiento_simbolos('B1101001B');
