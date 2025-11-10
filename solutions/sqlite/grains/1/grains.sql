UPDATE "grains"
SET result =
    CASE task
        -- 1. Calcula los granos en una casilla específica (2^(n-1))
        WHEN 'single-square' THEN POWER(2, square - 1)
        
        -- 2. Calcula el total de granos en todo el tablero (2^64 - 1)
        WHEN 'total' THEN POWER(2, 64) - 1
        
        -- Si hay otras tareas, no actualiza el resultado o lo deja en 0
        ELSE 0
    END;