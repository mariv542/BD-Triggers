--Prueba 1

-- Verifica el stock de antes
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE id_producto = 1;

-- Inserta una nueva venta
INSERT INTO ventas (id_producto, cantidad) VALUES (1, 2);

-- Verifica el stock después
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE id_producto = 1;

--------------------------------------------------------------------------------------------
--Prueba 2

-- Verificar stock actual
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE id_producto = 1;

-- Intentar vender más unidades de las disponibles (debe fallar)
INSERT INTO ventas (id_producto, cantidad) VALUES (1, 1000);

-- Verificar que no se insertó la venta
SELECT * FROM ventas WHERE id_producto = 1 AND cantidad = 1000;

---------------------------------------------------------------------------------------------
--Prueba 3

---------------------------------------------------------------------------------------------
--Prueba 4

---------------------------------------------------------------------------------------------
--Prueba 5

---------------------------------------------------------------------------------------------
--Prueba 6

---------------------------------------------------------------------------------------------
--Prueba 7

---------------------------------------------------------------------------------------------
--Prueba 8

---------------------------------------------------------------------------------------------
--Prueba 9

---------------------------------------------------------------------------------------------
--Prueba 10
