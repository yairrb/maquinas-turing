CREATE
    OR REPLACE FUNCTION ejecutar_prueba_1(cinta TEXT) RETURNS SETOF traza_ejecucion AS
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
       ('X'),
       ('B');


INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento)
VALUES ('q0', '0', 'q1', 'B', 'R'),
       ('q0', '1', 'q2', 'B', 'R'),
       ('q0', 'B', 'qf', 'B', 'S'),
       ('q1', '0', 'q3', '0', 'R'),
       ('q1', '1', 'q3', '1', 'R'),
       ('q1', 'B', 'qf', 'B', 'S'),
       ('q2', '0', 'q4', '0', 'R'),
       ('q2', '1', 'q4', '1', 'R'),
       ('q2', 'B', 'qf', 'B', 'S'),
       ('q3', '0', 'q3', '0', 'R'),
       ('q3', '1', 'q3', '1', 'R'),
       ('q3', 'B', 'q5', 'B', 'L'),
       ('q4', '0', 'q4', '0', 'R'),
       ('q4', '1', 'q4', '1', 'R'),
       ('q4', 'B', 'q6', 'B', 'L'),
       ('q5', '0', 'q7', 'B', 'L'),
       ('q6', '1', 'q7', 'B', 'L'),
       ('q7', '0', 'q7', '0', 'L'),
       ('q7', '1', 'q7', '1', 'L'),
       ('q7', 'B', 'q0', 'B', 'R');


-- Ejemplo de uso de la funcion para iniciar la simulacion
SELECT *
FROM ejecutar_prueba_1('10101B');
