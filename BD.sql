DROP DATABASE IF EXISTS tienda;
-- Crear la base de datos
CREATE DATABASE tienda;
USE tienda;

-- Crear la tabla de productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cantidad_stock INT,
    precio DECIMAL(10, 2)
);

-- Crear la tabla de ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    cantidad INT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    en_promocion BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE log_precios (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    fecha_cambio DATETIME,
    nuevo_precio DECIMAL(10,2)
);

-- Insertar algunos productos de ejemplo
INSERT INTO productos (nombre, cantidad_stock, precio)
VALUES 
('Camiseta', 100, 15.00),
('Pantalón', 50, 25.00),
('Zapatos', 30, 50.00),
('Sombrero', 20, 10.00);

-- Insertar algunas ventas de ejemplo
INSERT INTO ventas (id_producto, cantidad) 
VALUES
(1, 3),
(2, 5),
(3, 2);
