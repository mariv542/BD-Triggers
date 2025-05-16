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

-- Ver producto con precio > $40
SELECT id_producto, nombre, precio FROM productos WHERE precio > 40;

-- Insertar venta para este producto
INSERT INTO ventas (id_producto, cantidad) VALUES (3, 1);  -- Zapatos ($50)

-- Verificar aumento de precio
SELECT id_producto, nombre, precio FROM productos WHERE id_producto = 3;

---------------------------------------------------------------------------------------------
--Prueba 4

-- Ver producto a modificar
SELECT id_producto, nombre, precio FROM productos WHERE id_producto = 1;

-- Actualizar precio (debe activar el trigger)
UPDATE productos SET precio = 17.50 WHERE id_producto = 1;

-- Verificar registro en log_precios
SELECT * FROM log_precios WHERE id_producto = 1;

-- Actualizar otro campo sin cambiar precio (no debe activar registro)
UPDATE productos SET nombre = 'Camiseta deportiva' WHERE id_producto = 1;

-- Verificar que no hay nuevo registro en log_precios
SELECT * FROM log_precios WHERE id_producto = 1;

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
