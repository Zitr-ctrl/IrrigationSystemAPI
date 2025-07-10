create database irrigationsystem2;
use irrigationsystem2;

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

-- Tabla de zonas de riego (macetas)
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

-- Tabla de registros de riego (solo estado de bomba)
CREATE TABLE registro_riego (
  id INT PRIMARY KEY AUTO_INCREMENT,
  bomba_estado ENUM('ON','OFF') DEFAULT 'OFF',
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de lecturas de sensores (detalle por sensor y por evento de riego)
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

INSERT INTO maceta (nombre_maceta, nombre_planta, tamaño_maceta, estado, humedad_minima)
VALUES ('Maceta 3', 'pimiento', 'mediana', 'activo', 41.0);

INSERT INTO sensor (tipo, descripcion, maceta_id)
VALUES
('humedad', 'Sensor Humedad 1', 2),
('humedad', 'Sensor Humedad 2', 2),
('humedad', 'Sensor Humedad 3', 3);

select * from maceta; 
SELECT * FROM registro_riego ORDER BY id DESC LIMIT 5;
SELECT * FROM lectura_sensor ORDER BY id DESC LIMIT 10;
select * from sensor;

UPDATE sensor SET maceta_id = 1 WHERE id = 1;
UPDATE sensor SET maceta_id = 2 WHERE id = 2;
UPDATE sensor SET maceta_id = 3 WHERE id = 3;


