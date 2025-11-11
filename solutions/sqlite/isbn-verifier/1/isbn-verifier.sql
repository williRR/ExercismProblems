WITH pre_limpieza AS (
    SELECT
        T.isbn AS id,
        REPLACE(T.isbn, '-', '') AS ISBN_LIMPIO
    FROM "isbn-verifier" AS T
)
, SUMATORIA AS (
    SELECT
        P.id, 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 1, 1) AS INTEGER) * 10
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 2, 1) AS INTEGER) * 9
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 3, 1) AS INTEGER) * 8
        ) +
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 4, 1) AS INTEGER) * 7
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 5, 1) AS INTEGER) * 6
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 6, 1) AS INTEGER) * 5
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 7, 1) AS INTEGER) * 4
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 8, 1) AS INTEGER) * 3
        ) + 
        (
            CAST(SUBSTR(P.ISBN_LIMPIO, 9, 1) AS INTEGER) * 2
        ) + 
        (
            CASE 
                WHEN SUBSTR(P.ISBN_LIMPIO, 10, 1) = 'X' THEN 10 
                ELSE CAST(SUBSTR(P.ISBN_LIMPIO, 10, 1) AS INTEGER)
            END * 1
        ) AS SUMA_PONDERADA
    FROM pre_limpieza AS P
)
, VALIDACION_FINAL AS (
    SELECT
        S.id,
        S.SUMA_PONDERADA,
        T.ISBN_LIMPIO,
        CASE
            WHEN LENGTH(T.ISBN_LIMPIO) <> 10 THEN 0
            WHEN SUBSTR(T.ISBN_LIMPIO, 1, 9) GLOB '*[^0-9]*' THEN 0 
            WHEN SUBSTR(T.ISBN_LIMPIO, 10, 1) GLOB '*[^0-9X]*' THEN 0 
            WHEN MOD(S.SUMA_PONDERADA, 11) = 0 THEN 1 
            ELSE 0 
        END AS IS_VALID
    FROM SUMATORIA AS S
    JOIN pre_limpieza AS T ON S.id = T.id
)

UPDATE "isbn-verifier"
SET result = (  
    SELECT
        V.IS_VALID
    FROM VALIDACION_FINAL AS V
    WHERE V.id = "isbn-verifier".isbn
); 