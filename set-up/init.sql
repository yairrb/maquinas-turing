-- Tabla alfabeto para definir los caracteres validos
CREATE TABLE IF NOT EXISTS alfabeto
(
    caracter CHAR(1) PRIMARY KEY
);

-- Tabla programa para almacenar las transiciones de la MT
CREATE TABLE IF NOT EXISTS programa
(
    estado_origen   VARCHAR(255) NOT NULL,
    caracter_origen CHAR(1)      NOT NULL,
    estado_nuevo    VARCHAR(255) NOT NULL,
    caracter_nuevo  CHAR(1)      NOT NULL,
    desplazamiento  CHAR(1) CHECK (desplazamiento IN ('L', 'R', 'S')),
    PRIMARY KEY (estado_origen, caracter_origen)
);

-- Tabla traza_ejecucion para almacenar cada paso de la simulacion
CREATE TABLE IF NOT EXISTS traza_ejecucion
(
    id               SERIAL PRIMARY KEY,
    estado_actual    VARCHAR(255) NOT NULL,
    cinta_actual     TEXT         NOT NULL,
    posicion_cabezal INT          NOT NULL,
    estado_siguiente VARCHAR(255),
    cinta_siguiente  TEXT         NOT NULL,
    movimiento       CHAR(1),
    es_final         BOOLEAN      NOT NULL
);

-- Simulacion de la Máquina de Turing
CREATE OR REPLACE FUNCTION simuladorMT(input_string TEXT) RETURNS VOID AS
$$
DECLARE
    estado_actual      VARCHAR(255) := 'q0'; -- Estado inicial asumido, siempre q0
    caracter_actual    CHAR(1);
    siguiente_estado   VARCHAR(255);
    siguiente_caracter CHAR(1);
    mover              CHAR(1);
    posicion_cabezal   INT          := 1; -- el cabezal arranca siempre en la posicion 1
    cinta              TEXT         := input_string;
    termino_ejecucion  BOOLEAN      := FALSE;
BEGIN
    -- Check para asegurar que el input no contenga caracteres que no pertenezcan al alfabeto
    IF EXISTS (SELECT 1
               FROM unnest(string_to_array(cinta, NULL)) c
               WHERE NOT EXISTS (SELECT 1 FROM alfabeto WHERE caracter = c)) THEN
        RAISE EXCEPTION 'El input contiene caracteres no validos segun el alfabeto definido';
    END IF;

    -- Limpiar la tabla traza_ejecucion antes iniciar la simulacion
    TRUNCATE traza_ejecucion;

    -- Insertar el estado inicial en la tabla traza
    INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente,
                                 movimiento, es_final)
    VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, FALSE);

    -- main de la simulacion
    WHILE NOT termino_ejecucion
        LOOP
            -- Obtener el simbolo actual segun el cabezal
            caracter_actual := SUBSTRING(cinta FROM posicion_cabezal FOR 1);

            -- Buscamos la que se debe hacer segun el estado actual y el caracter actual
            SELECT p.estado_nuevo, p.caracter_nuevo, p.desplazamiento
            INTO siguiente_estado, siguiente_caracter, mover
            FROM programa p
            WHERE p.estado_origen = estado_actual
              AND p.caracter_origen = caracter_actual;

            -- Si no hay una accion definida, detenemos la maquina
            IF NOT FOUND THEN
                termino_ejecucion := TRUE;
                -- Marcar si es el estado final o no
                IF estado_actual = 'qf' THEN
                    INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente,
                                                 cinta_siguiente, movimiento, es_final)
                    VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, TRUE);
                ELSE
                    INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente,
                                                 cinta_siguiente, movimiento, es_final)
                    VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, FALSE);
                END IF;
                EXIT;
            END IF;

            -- Actualizar la cinta
            cinta := OVERLAY(cinta PLACING siguiente_caracter FROM posicion_cabezal FOR 1);

            -- Actualizar la posicion del cabezal
            IF mover = 'R' THEN
                posicion_cabezal := posicion_cabezal + 1;
            ELSIF mover = 'L' THEN
                posicion_cabezal := posicion_cabezal - 1;
            END IF;

            -- Guardar el movimiento en la traza
            INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente,
                                         cinta_siguiente, movimiento, es_final)
            VALUES (estado_actual, cinta, posicion_cabezal, siguiente_estado, cinta, mover, FALSE);

            -- Actualizar el estado actual al siguiente estado
            estado_actual := siguiente_estado;
        END LOOP;
END;
$$ LANGUAGE plpgsql;
