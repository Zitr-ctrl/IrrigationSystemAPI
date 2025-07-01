-- Base de datos (si no existe)
CREATE DATABASE IF NOT EXISTS irrigationsystem1;
USE irrigationsystem1;

-- Tabla de usuarios
CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  correo VARCHAR(100) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de zonas de riego
CREATE TABLE maceta (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_maceta VARCHAR(100),
  nombre_planta VARCHAR(100) NOT NULL,
  tamaño_maceta TEXT,
  estado ENUM('activo', 'inactivo') DEFAULT 'activo',
  humedad_minima DECIMAL(5,2) DEFAULT 50.0
);

-- Tabla de sensores
CREATE TABLE sensor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  tipo ENUM('humedad', 'ph', 'flujo', 'temperatura') NOT NULL,
  descripcion VARCHAR(100),
  maceta_id INT,
  FOREIGN KEY (maceta_id) REFERENCES maceta(id) ON DELETE SET NULL
);

-- Tabla de registros de riego (cabecera del evento)
CREATE TABLE registro_riego (
  id INT PRIMARY KEY AUTO_INCREMENT,
  maceta_id INT NOT NULL,
  bomba_estado ENUM('ON','OFF') DEFAULT 'OFF',
  usuario_id INT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (maceta_id) REFERENCES maceta(id),
  FOREIGN KEY (usuario_id) REFERENCES user(id)
);

-- Tabla de lecturas de sensores (detalle por sensor)
CREATE TABLE lectura_sensor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  sensor_id INT NOT NULL,
  registro_id INT,
  valor DECIMAL(10,2) NOT NULL,
  unidad VARCHAR(20),
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sensor_id) REFERENCES sensor(id) ON DELETE CASCADE,
  FOREIGN KEY (registro_id) REFERENCES registro_riego(id) ON DELETE CASCADE
);

select * from maceta;

INSERT INTO maceta (nombre_maceta, nombre_planta, tamaño_maceta, estado, humedad_minima)
VALUES ('Maceta 3', 'Lechuga', 'Mediana', 'activo', 30.0);

INSERT INTO sensor (tipo, descripcion, maceta_id)
VALUES
('humedad', 'Sensor Humedad 1', 2),
('humedad', 'Sensor Humedad 2', 2),
('humedad', 'Sensor Humedad 3', 3);


SELECT * FROM registro_riego ORDER BY id DESC LIMIT 5;

