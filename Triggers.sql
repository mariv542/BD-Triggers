--1.	Crear un trigger que actualice el stock de un producto después de realizar una venta.
	--Descripción: Cada vez que se registre una venta en la tabla ventas, el stock de 
    --             productos en la tabla productos debe disminuir según la cantidad vendida.
	--Tipo de Trigger: AFTER INSERT

--TRG_tabla_evento_momento_ajustestock

DELIMITER//
CREATE TRIGGER TGR_productos_INSERT_AFTER
AFTER INSERT
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_INSERT_AFTER

--2.	Crear un trigger que no permita realizar una venta si no hay suficiente stock.
    --Descripción: Si alguien intenta vender más unidades de un producto de las que están 
    --             disponibles en el stock, se debe evitar que la venta se registre.
    --Tipo de Trigger: BEFORE INSERT

DELIMITER//
CREATE TRIGGER TGR_productos_BEFORE_INSERT
BEFORE INSERT
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_BEFORE_INSERT

--3.	Crear un trigger que actualice el precio del producto cuando se realice una venta.
    --Descripción: Cada vez que se registre una venta, si el precio del producto es superior
    --             a $40, su precio debe aumentar un 5%.
    --Tipo de Trigger: AFTER INSERT

DELIMITER//
CREATE TRIGGER TGR_productos_AFTER_INSERT
AFTER INSERT
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_AFTER_INSERT

--4.	Crear un trigger que registre en una tabla de logs cada vez que se actualice el precio 
--      de un producto.
    --Descripción: Si el precio de un producto cambia, debe guardarse un registro de ese cambio
    --             en una tabla de logs llamada log_precios con la fecha del cambio y el nuevo precio.
    --Tipo de Trigger: AFTER UPDATE

-- ojito creacion de tabla log_precios
DELIMITER//
CREATE TRIGGER TGR_logPrecios_AFTER_UPDATE_crearTabla
AFTER UPDATE
ON log_precios FOR EACH ROW 

END;

DROP TRIGGER TGR_log_precios_AFTER_UPDATE

--5.	Crear un trigger que actualice el stock después de eliminar una venta.
    --Descripción: Si una venta es eliminada de la tabla ventas, el stock del producto debe 
    --             incrementarse en la cantidad de productos que se habían vendido en esa transacción.
    --Tipo de Trigger: AFTER DELETE

DELIMITER//
CREATE TRIGGER TGR_productos_AFTER_DELETE_actualizarStock_ventaEliminada
AFTER DELETE
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_AFTER_DELETE_actualizarStock_ventaEliminada

--6.	Crear un trigger que no permita eliminar productos si el stock es mayor a cero.
    --Descripción: Si el stock de un producto es mayor que cero, no se debe permitir eliminar ese
    --             producto de la tabla productos.
    --Tipo de Trigger: BEFORE DELETE

DELIMITER//
CREATE TRIGGER TGR_productos_BEFORE_DELETE_elimiarPRoductos_stockMayor0
BEFORE DELETE
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_BEFORE_DELETE_elimiarPRoductos_stockMayor0

--7.	Crear un trigger que registre un mensaje en la consola cuando se intente realizar una venta 
--      de un producto que no está en stock.
    --Descripción: Si un producto no tiene stock y se intenta registrar una venta, se debe imprimir
    --             un mensaje de advertencia.
    --Tipo de Trigger: BEFORE INSERT

DELIMITER//
CREATE TRIGGER TGR_productos_BEFORE_INSERT_mensajeAdvertencia_insuficiente
BEFORE INSERT
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_BEFORE_INSERT_mensajeAdvertencia_insuficiente

--8.	Crear un trigger que registre un mensaje cuando el stock de un producto alcance cero.
    --Descripción: Si el stock de un producto llega a cero después de una venta, se debe imprimir 
    --             un mensaje indicando que el producto está agotado.
    --Tipo de Trigger: AFTER INSERT

DELIMITER//
CREATE TRIGGER TGR_productos_AFTER_INSERT_mensajeAdvertensia_agotado
AFTER INSERT
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_AFTER_INSERT_mensajeAdvertensia_agotado

--9.	Crear un trigger que, si el precio de un producto baja por debajo de $5, lo marque como 
--      "en promoción".
    --Descripción: Si el precio de un producto se reduce por debajo de $5, debe añadirse un 
    --             campo "en_promocion" en la tabla productos y actualizarlo a TRUE.
    --Tipo de Trigger: AFTER UPDATE

DELIMITER//
CREATE TRIGGER TGR_productos_AFTER_UPDATE_crearCampo
AFTER UPDATE
ON productos FOR EACH ROW 

END;

DROP TRIGGER TGR_productos_AFTER_UPDATE_crearCampo

--10.	 Crear un trigger que, después de insertar una venta, calcule el total de la venta y 
--       lo registre en una tabla total_ventas.
    --Descripción: Después de insertar una venta, se debe calcular el total de la venta 
    --             (cantidad * precio) y registrar esa información en una nueva tabla llamada total_ventas con la fecha de la venta.
    --Tipo de Trigger: AFTER INSERT

DELIMITER//
CREATE TRIGGER TGR_ventas_AFTER_INSERT_crearTabla
AFTER INSERT
ON ventas FOR EACH ROW 

END;

DROP TRIGGER TGR_ventas_AFTER_INSERT_crearTabla
