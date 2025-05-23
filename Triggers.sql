--1.	Crear un trigger que actualice el stock de un producto después de realizar una venta.
	--Descripción: Cada vez que se registre una venta en la tabla ventas, el stock de 
    --             productos en la tabla productos debe disminuir según la cantidad vendida.
	--Tipo de Trigger: AFTER INSERT

--TRG_tabla_evento_momento_ajustestock

DELIMITER //
CREATE TRIGGER TGR_ventas_INSERT_AFTER_actualizar_stock
AFTER INSERT
ON ventas FOR EACH ROW 
BEGIN
    UPDATE productos
    SET cantidad_stock = cantidad_stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS TGR_ventas_INSERT_AFTER_actualizar_stock;

--2.	Crear un trigger que no permita realizar una venta si no hay suficiente stock.
    --Descripción: Si alguien intenta vender más unidades de un producto de las que están 
    --             disponibles en el stock, se debe evitar que la venta se registre.
    --Tipo de Trigger: BEFORE INSERT

DELIMITER //
CREATE TRIGGER TGR_ventas_BEFORE_INSERT_validar_stock
BEFORE INSERT
ON ventas FOR EACH ROW 
BEGIN
    DECLARE stock_actual INT;

    -- Obtener el stock actual del producto
    SELECT cantidad_stock INTO stock_actual
    FROM productos
    WHERE id_producto = NEW.id_producto;

    -- Verificar si hay suficiente stock
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No hay suficiente stock para realizar la venta.';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS TGR_ventas_BEFORE_INSERT_validar_stock;

--3.	Crear un trigger que actualice el precio del producto cuando se realice una venta.
    --Descripción: Cada vez que se registre una venta, si el precio del producto es superior
    --             a $40, su precio debe aumentar un 5%.
    --Tipo de Trigger: AFTER INSERT

DELIMITER //
CREATE TRIGGER TGR_ventas_AFTER_INSERT_aumentar_precio
AFTER INSERT
ON ventas FOR EACH ROW 
BEGIN
    DECLARE precio_actual DECIMAL(10,2);

    -- Obtiene el precio actual del producto
    SELECT precio INTO precio_actual
    FROM productos
    WHERE id_producto = NEW.id_producto;

    -- Si el precio es mayor a 40, actualizarlo con un incremento del 5%
    IF precio_actual > 40 THEN
        UPDATE productos
        SET precio = precio_actual * 1.05
        WHERE id_producto = NEW.id_producto; 
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS TGR_productos_AFTER_INSERT_aumentar_precio;

--4.	Crear un trigger que registre en una tabla de logs cada vez que se actualice el precio 
--      de un producto.
    --Descripción: Si el precio de un producto cambia, debe guardarse un registro de ese cambio
    --             en una tabla de logs llamada log_precios con la fecha del cambio y el nuevo precio.
    --Tipo de Trigger: AFTER UPDATE

-- ojito creacion de tabla log_precios
DELIMITER //
CREATE TRIGGER TGR_productos_AFTER_UPDATE_log_precios
AFTER UPDATE
ON productos FOR EACH ROW 
BEGIN
    -- Solo registrar si el precio cambió
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO log_precios (id_producto, fecha_cambio, nuevo_precio)
        VALUES (NEW.id_producto, NOW(), NEW.precio);
    END IF;
END//
DELIMITER ;

DROP TRIGGER TGR_productos_AFTER_UPDATE_log_precios;

--5.	Crear un trigger que actualice el stock después de eliminar una venta.
    --Descripción: Si una venta es eliminada de la tabla ventas, el stock del producto debe 
    --             incrementarse en la cantidad de productos que se habían vendido en esa transacción.
    --Tipo de Trigger: AFTER DELETE

DELIMITER //
CREATE TRIGGER TGR_ventas_AFTER_DELETE_actualizarStock_restaurar_stock
AFTER DELETE
ON ventas FOR EACH ROW 
BEGIN
    UPDATE productos
    SET cantidad_stock = cantidad_stock + OLD.cantidad
    WHERE id_producto = OLD.id_producto;
END//
DELIMITER ;

DROP TRIGGER TGR_productos_AFTER_DELETE_actualizarStock_restaurar_stock;

--6.	Crear un trigger que no permita eliminar productos si el stock es mayor a cero.
    --Descripción: Si el stock de un producto es mayor que cero, no se debe permitir eliminar ese
    --             producto de la tabla productos.
    --Tipo de Trigger: BEFORE DELETE

DELIMITER //
CREATE TRIGGER TGR_productos_BEFORE_DELETE_bloquear_si_tiene_stock
BEFORE DELETE
ON productos FOR EACH ROW 
BEGIN
    IF OLD.cantidad_stock > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el producto porque aún tiene stock disponible.';
    END IF;
END //    
DELIMITER ;

DROP TRIGGER TGR_productos_BEFORE_DELETE_bloquear_si_tiene_stock;

--7.	Crear un trigger que registre un mensaje en la consola cuando se intente realizar una venta 
--      de un producto que no está en stock.
    --Descripción: Si un producto no tiene stock y se intenta registrar una venta, se debe imprimir
    --             un mensaje de advertencia.
    --Tipo de Trigger: BEFORE INSERT

DELIMITER //
CREATE TRIGGER TGR_ventas_BEFORE_INSERT_advertencia_insuficiente
BEFORE INSERT
ON ventas FOR EACH ROW 
BEGIN
    DECLARE stock_disponible INT;
    DECLARE nombre_producto VARCHAR(255);

    -- Obtener stock y nombre del producto
    SELECT p.cantidad_stock, p.nombre INTO stock_disponible, nombre_producto
    FROM productos p
    WHERE p.id_producto = NEW.id_producto;

    -- Verificar stock insuficiente
    IF stock_disponible < NEW.cantidad THEN
        SIGNAL SQLSTATE '01000' -- Código para warning (no error)
        SET MESSAGE_TEXT = 'Advertencia: Stock insuficiente para la venta';
    END IF;
END//
DELIMITER ;

DROP TRIGGER TGR_productos_BEFORE_INSERT_advertencia_insuficiente;

--8.	Crear un trigger que registre un mensaje cuando el stock de un producto alcance cero.
    --Descripción: Si el stock de un producto llega a cero después de una venta, se debe imprimir 
    --             un mensaje indicando que el producto está agotado.
    --Tipo de Trigger: AFTER INSERT

DELIMITER //
CREATE TRIGGER TGR_ventas_AFTER_INSERT_notificar_agotado
AFTER INSERT
ON ventas FOR EACH ROW 
BEGIN
    DECLARE stock_actual INT;
    DECLARE nombre_producto VARCHAR(100);

    -- Obtener stock y nombre actual del producto
    SELECT p.cantidad_stock, p.nombre INTO stock_actual, nombre_producto
    FROM productos p
    WHERE p.id_producto = NEW.id_producto;

    -- Si el stock llegó a cero, lanzar advertencia
    IF stock_actual = 0 THEN
        SIGNAL SQLSTATE '45000' -- Código para warning (no error)
        SET MESSAGE_TEXT = 'Atención: El producto se a agotado despues de la venta';
    END IF;
END//
DELIMITER ;

DROP TRIGGER TGR_ventas_AFTER_INSERT_notificar_agotado;

--9.	Crear un trigger que, si el precio de un producto baja por debajo de $5, lo marque como 
--      "en promoción".
    --Descripción: Si el precio de un producto se reduce por debajo de $5, debe añadirse un 
    --             campo "en_promocion" en la tabla productos y actualizarlo a TRUE.
    --Tipo de Trigger: AFTER UPDATE

DELIMITER //
CREATE TRIGGER TGR_productos_AFTER_UPDATE_marcar_promocion
AFTER UPDATE
ON productos FOR EACH ROW
BEGIN
    -- Verificar si el precio bajó de $5 y cambió realmente
    IF NEW.precio < 5 AND NEW.precio < OLD.precio THEN
        SIGNAL SQLSTATE '01000' 
        SET MESSAGE_TEXT = '¡Oferta! Producto con descuento ';
    END IF;
END//
DELIMITER ;

DROP TRIGGER TGR_productos_AFTER_UPDATE_marcar_promocion;

--10.	 Crear un trigger que, después de insertar una venta, calcule el total de la venta y 
--       lo registre en una tabla total_ventas.
    --Descripción: Después de insertar una venta, se debe calcular el total de la venta 
    --             (cantidad * precio) y registrar esa información en una nueva tabla llamada total_ventas con la fecha de la venta.
    --Tipo de Trigger: AFTER INSERT
 
DELIMITER //
CREATE TRIGGER TGR_ventas_AFTER_INSERT_calcular_total
AFTER INSERT
ON ventas FOR EACH ROW 
BEGIN
    DECLARE precio_unitario DECIMAL(10,2);
    DECLARE nombre_producto VARCHAR(100);
    DECLARE total DECIMAL(10,2);

    -- Obtener precio y nombre del producto
    SELECT p.precio, p.nombre INTO precio_unitario, nombre_producto
    FROM productos p
    WHERE p.id_producto = NEW.id_producto;

    -- Calcular el total
    SET total = precio_unitario * NEW.cantidad;

    -- Insertar en total_ventas (usando LAST_INSERT_ID() por si acaso)
    INSERT INTO total_ventas (id_venta, id_producto, nombre_producto, total, fecha)
    VALUES (NEW.id_venta, NEW.id_producto, nombre_producto, total, NEW.fecha_venta);
END//
DELIMITER ;

-- Para eliminar el trigger (forma correcta)
DROP TRIGGER IF EXISTS TGR_ventas_AFTER_INSERT_calcular_total;

