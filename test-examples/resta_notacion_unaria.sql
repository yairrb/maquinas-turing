CREATE
    OR REPLACE FUNCTION ejecutar_resta_unaria(cinta TEXT) RETURNS SETOF traza_ejecucion AS
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
       ('-'),
       ('#');

INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento)
VALUES ('q0', '1', 'q0', '1', 'R'),
       ('q0', '-', 'q1', '-', 'R'),
       ('q0', '#', 'q0', '#', 'R'),
       ('q1', '1', 'q1', '1', 'R'),
       ('q1', '#', 'q2', '#', 'L'),
       ('q2', '1', 'q3', '#', 'L'),
       ('q2', '-', 'q6', '#', 'L'),
       ('q3', '1', 'q3', '1', 'L'),
       ('q3', '#', 'q4', '#', 'R'),
       ('q3', '-', 'q3', '-', 'L'),
       ('q4', '1', 'q0', '#', 'R'),
       ('q4', '-', 'q5', '1', 'L'),
       ('q5', '#', 'q6', '-', 'L'),
       ('q6', '1', 'q6', '1', 'L'),
       ('q6', '#', 'qf', '#', 'R');


-- Ejemplo de uso de la funcion para iniciar la simulacion
SELECT *
FROM ejecutar_resta_unaria('#11111-1111111#');