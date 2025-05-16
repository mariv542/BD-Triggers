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

-- Ver stock actual y ventas existentes
SELECT p.id_producto, p.nombre, p.cantidad_stock, v.id_venta, v.cantidad
FROM productos p
JOIN ventas v ON p.id_producto = v.id_producto;

-- Eliminar una venta (debe activar el trigger)
DELETE FROM ventas WHERE id_venta = 1;  -- Ajusta el ID según tus datos

-- Verificar aumento de stock
SELECT id_producto, nombre, cantidad_stock 
FROM productos 
WHERE id_producto = 1;

---------------------------------------------------------------------------------------------
--Prueba 6

-- Ver productos con stock
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE cantidad_stock > 0;

-- Intentar eliminar producto con stock (debe fallar)
DELETE FROM productos WHERE id_producto = 1;

-- Verificar que sigue existiendo
SELECT id_producto FROM productos WHERE id_producto = 1;

-- Actualizar stock a cero
UPDATE productos SET cantidad_stock = 0 WHERE id_producto = 1;

-- Intentar eliminar nuevamente (debe permitirlo)
DELETE FROM ventas WHERE id_producto = 1;
DELETE FROM productos WHERE id_producto = 1;

-- Verificar que fue eliminado
SELECT id_producto FROM productos WHERE id_producto = 1;

---------------------------------------------------------------------------------------------
--Prueba 7

-- Ver productos con poco stock
SELECT id_producto, nombre, cantidad_stock 
FROM productos 
WHERE cantidad_stock < 10;

-- Intentar vender más unidades de las disponibles
-- (Mostrará advertencia)
INSERT INTO ventas (id_producto, cantidad) 
VALUES (2, 100);  -- Ajustar ID según tus datos

-- Verificar que la venta se creó a pesar de la advertencia
SELECT * FROM ventas ORDER BY id_venta DESC LIMIT 1;

---------------------------------------------------------------------------------------------
--Prueba 8

-- Preparar prueba: reducir stock a cantidad mínima
UPDATE productos SET cantidad_stock = 2 WHERE id_producto = 4; -- Sombrero

-- Verificar estado antes
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE id_producto = 4;

-- Realizar venta que agotará el producto
INSERT INTO ventas (id_producto, cantidad) VALUES (4, 2);

-- Verificar mensaje de advertencia
-- Verificar que el stock quedó en 0
SELECT id_producto, nombre, cantidad_stock FROM productos WHERE id_producto = 4;

---------------------------------------------------------------------------------------------
--Prueba 9

-- Caso 1: Precio baja de $5 (debe activar promoción)
-- Actualizar un producto para probar
UPDATE productos SET precio = 4.99 WHERE id_producto = 4;

-- Verificar warnings
SHOW WARNINGS;

---------------------------------------------------------------------------------------------
--Prueba 10
