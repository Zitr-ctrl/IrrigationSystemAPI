create database irrigationsystem;
use irrigationsystem;

show tables;
 
show databases;

select * from user;

select * from lectura_sensor;

SELECT registro_riego.*, zona_riego.nombre
FROM registro_riego
LEFT JOIN zona_riego ON registro_riego.zona_id = zona_riego.id
WHERE zona_riego.id IS NULL;



CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  correo VARCHAR(100) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE zona_riego (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  ubicacion VARCHAR(100),
  estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

CREATE TABLE sensor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  tipo ENUM('humedad', 'ph', 'flujo', 'temperatura') NOT NULL,
  descripcion VARCHAR(100),
  zona_id INT,
  FOREIGN KEY (zona_id) REFERENCES zona_riego(id) ON DELETE SET NULL
);

CREATE TABLE lectura_sensor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  sensor_id INT NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  unidad VARCHAR(20),
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sensor_id) REFERENCES sensor(id) ON DELETE CASCADE
);

CREATE TABLE registro_riego (
  id INT PRIMARY KEY AUTO_INCREMENT,
  zona_id INT NOT NULL,
  tiempo_activacion INT NOT NULL, -- en minutos
  tiempo_bomba INT NOT NULL, -- en minutos
  usuario_id INT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (zona_id) REFERENCES zona_riego(id),
  FOREIGN KEY (usuario_id) REFERENCES user(id)
);

USE irrigationsystem;
SELECT * FROM sensor;

SELECT * FROM registro_riego;

SELECT * FROM lectura_sensor;

INSERT INTO zona_riego (nombre, descripcion, ubicacion)
VALUES ('Zona 1', 'Sector norte', 'Campo A');

-- Asume que el ID generado para la zona es 1

INSERT INTO sensor (tipo, descripcion, zona_id)
VALUES ('humedad', 'Sensor de humedad principal', 1);




