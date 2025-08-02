CREATE DATABASE IF NOT EXISTS el_dorado;
USE el_dorado;

-- tabla: aeropuerto
CREATE TABLE aeropuerto (
    id_aeropuerto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(30) NOT NULL
);

-- tabla: avion
CREATE TABLE avion (
    id_avion INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(30) NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    id_aeropuerto INT,
    FOREIGN KEY (id_aeropuerto) REFERENCES aeropuerto(id_aeropuerto)
);

-- tabla: empleado
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(30) NOT NULL,
    cargo ENUM('Piloto', 'Copiloto', 'Azafata', 'Mantenimiento', 'Administrativo') NOT NULL,
    id_aeropuerto INT,
    FOREIGN KEY (id_aeropuerto) REFERENCES aeropuerto(id_aeropuerto)
);

-- Tabla: pasajero
CREATE TABLE pasajero (
    id_pasajero INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(50) NOT NULL,
    documento VARCHAR(30) UNIQUE NOT NULL,
    nacionalidad VARCHAR(30) NOT NULL
);

-- Tabla: vuelo
CREATE TABLE vuelo (
    id_vuelo INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    origen VARCHAR(20) NOT NULL,
    destino VARCHAR(30) NOT NULL,
    id_avion INT,
    id_piloto INT,
    FOREIGN KEY (id_avion) REFERENCES avion(id_avion),
    FOREIGN KEY (id_piloto) REFERENCES empleado(id_empleado)
);

-- Tabla: reserva
CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    asiento VARCHAR(10) NOT NULL,
    estado ENUM('confirmada', 'cancelada', 'pendiente') NOT NULL,
    id_pasajero INT,
    id_vuelo INT,
    FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero),
    FOREIGN KEY (id_vuelo) REFERENCES vuelo(id_vuelo)
);

INSERT INTO aeropuerto (nombre, ciudad, pais) VALUES
('El Dorado', 'Bogotá', 'Colombia'),
('JFK', 'Nueva York', 'EEUU'),
('Heathrow', 'Londres', 'Reino Unido'),
('Barajas', 'Madrid', 'España'),
('Charles de Gaulle', 'París', 'Francia'),
('Ezeiza', 'Buenos Aires', 'Argentina'),
('Haneda', 'Tokio', 'Japón'),
('Frankfurt', 'Frankfurt', 'Alemania'),
('Guarulhos', 'São Paulo', 'Brasil'),
('Benito Juárez', 'Ciudad de México', 'México');

-- Insertar en avion
INSERT INTO avion (modelo, capacidad, id_aeropuerto) VALUES
('Boeing 737', 180, 1),
('Airbus A320', 160, 2),
('Boeing 777', 300, 3),
('Airbus A380', 500, 4),
('Embraer E190', 100, 5),
('Boeing 787', 250, 6),
('Airbus A330', 270, 7),
('Boeing 767', 210, 8),
('CRJ 900', 90, 9),
('Boeing 747', 400, 10);

-- Insertar en empleado
INSERT INTO empleado (nombre_completo, cargo, id_aeropuerto) VALUES
('Carlos Gómez', 'Piloto', 1),
('Laura Martínez', 'Azafata', 2),
('James Smith', 'Piloto', 3),
('Emily Johnson', 'Administrativo', 4),
('David Brown', 'Mantenimiento', 5),
('Lucía Méndez', 'Azafata', 6),
('Pedro Ramírez', 'Copiloto', 7),
('Maria López', 'Piloto', 8),
('John Carter', 'Mantenimiento', 9),
('Andrea Torres', 'Administrativo', 10);

-- Insertar en pasajero
INSERT INTO pasajero (nombre_completo, documento, nacionalidad) VALUES
('Ana Torres', 'CC102030', 'Colombiana'),
('John Doe', 'PP998877', 'Estadounidense'),
('Luis Pérez', 'CC112233', 'Colombiano'),
('Sarah Connor', 'PP778899', 'Británica'),
('Tomás Mejía', 'CC223344', 'Mexicano'),
('Elena García', 'CC334455', 'Española'),
('Michael Scott', 'PP445566', 'Estadounidense'),
('Raúl Jiménez', 'CC556677', 'Mexicano'),
('Sakura Tanaka', 'PP667788', 'Japonesa'),
('Lucas Silva', 'PP778899A', 'Brasileño');

-- Insertar en vuelo
INSERT INTO vuelo (fecha, origen, destino, id_avion, id_piloto) VALUES
('2025-08-05', 'Bogotá', 'Nueva York', 1, 1),
('2025-08-06', 'Nueva York', 'Londres', 2, 3),
('2025-08-07', 'Londres', 'Madrid', 3, 3),
('2025-08-08', 'Madrid', 'París', 4, 1),
('2025-08-09', 'París', 'Buenos Aires', 5, 3),
('2025-08-10', 'Buenos Aires', 'Tokio', 6, 1),
('2025-08-11', 'Tokio', 'Frankfurt', 7, 8),
('2025-08-12', 'Frankfurt', 'São Paulo', 8, 8),
('2025-08-13', 'São Paulo', 'Ciudad de México', 9, 1),
('2025-08-14', 'Ciudad de México', 'Bogotá', 10, 8);

-- Insertar en reserva
INSERT INTO reserva (asiento, estado, id_pasajero, id_vuelo) VALUES
('12A', 'confirmada', 1, 1),
('14B', 'pendiente', 2, 2),
('18C', 'cancelada', 3, 3),
('20D', 'confirmada', 4, 4),
('22E', 'pendiente', 5, 5),
('24F', 'confirmada', 6, 6),
('26G', 'cancelada', 7, 7),
('28H', 'confirmada', 8, 8),
('30A', 'pendiente', 9, 9),
('32B', 'confirmada', 10, 10);

-- A) Consultas de agregación 
-- SUM: Total de pasajeros por vuelo (1 fila por vuelo)
SELECT r.id_vuelo, SUM(1) AS total_pasajeros
FROM reserva r
GROUP BY r.id_vuelo;

-- AVG: Promedio de capacidad de los aviones
SELECT AVG(capacidad) AS promedio_capacidad
FROM avion;

-- MIN: Fecha del vuelo más antiguo
SELECT MIN(fecha) AS vuelo_mas_antiguo
FROM vuelo;

-- MAX: Último vuelo registrado
SELECT MAX(fecha) AS vuelo_mas_reciente
FROM vuelo;

-- COUNT: Total de reservas por pasajero
SELECT id_pasajero, COUNT(*) AS total_reservas
FROM reserva
GROUP BY id_pasajero;


-- B) Consultas de agregación con GROUP BY y HAVING
-- Total de empleados por cargo
SELECT cargo, COUNT(*) AS total_empleados
FROM empleado
GROUP BY cargo;

-- Total de vuelos por origen
SELECT origen, COUNT(*) AS total_vuelos
FROM vuelo
GROUP BY origen;

-- Cantidad de pasajeros por nacionalidad (solo si son más de 2)
SELECT nacionalidad, COUNT(*) AS cantidad
FROM pasajero
GROUP BY nacionalidad
HAVING COUNT(*) > 2;


-- C) Consultas de agregación con JOIN
-- Nacionalidades únicas en la tabla de pasajeros
SELECT DISTINCT nacionalidad
FROM pasajero;

-- Modelos únicos de aviones
SELECT DISTINCT modelo
FROM avion;

-- Ciudades únicas donde hay un aeropuerto
SELECT DISTINCT ciudad
FROM aeropuerto;


-- D) Consultas de agregación con subconsultas
-- Pasajeros que han tomado vuelos desde un aeropuerto específico (ej. Bogotá)
SELECT DISTINCT p.*
FROM pasajero p
JOIN reserva r ON p.id_pasajero = r.id_pasajero
JOIN vuelo v ON r.id_vuelo = v.id_vuelo
WHERE v.origen = 'Bogotá';

-- Vuelos que han sido realizados por aviones con capacidad mayor al promedio
SELECT *
FROM vuelo
WHERE id_avion IN (
    SELECT id_avion FROM avion
    WHERE capacidad > (SELECT AVG(capacidad) FROM avion)
);

-- Empleados que trabajan en aeropuertos donde hay más de 2 aviones
SELECT *
FROM empleado
WHERE id_aeropuerto IN (
    SELECT id_aeropuerto
    FROM avion
    GROUP BY id_aeropuerto
    HAVING COUNT(*) > 2
);



-- E) Consultas de agregación con funciones de ventana
-- 1. Vuelos con info del avión y piloto
SELECT v.id_vuelo, v.fecha, a.modelo, e.nombre_completo AS piloto
FROM vuelo v
JOIN avion a ON v.id_avion = a.id_avion
JOIN empleado e ON v.id_piloto = e.id_empleado;

-- 2. Reservas con info del pasajero y vuelo
SELECT r.id_reserva, p.nombre_completo, v.fecha, v.destino
FROM reserva r
JOIN pasajero p ON r.id_pasajero = p.id_pasajero
JOIN vuelo v ON r.id_vuelo = v.id_vuelo;

-- 3. Empleados con su aeropuerto
SELECT e.nombre_completo, e.cargo, a.nombre AS aeropuerto
FROM empleado e
JOIN aeropuerto a ON e.id_aeropuerto = a.id_aeropuerto;


-- F) Consultas de agregación con LEFT JOIN y RIGHT JOIN
-- 1. Todos los aviones, tengan o no vuelos
SELECT a.id_avion, a.modelo, v.id_vuelo
FROM avion a
LEFT JOIN vuelo v ON a.id_avion = v.id_avion;

-- 2. Todos los pasajeros, tengan o no reservas
SELECT p.nombre_completo, r.id_reserva
FROM pasajero p
LEFT JOIN reserva r ON p.id_pasajero = r.id_pasajero;

-- 3. Todos los empleados, aunque no sean pilotos en un vuelo
SELECT e.nombre_completo, v.id_vuelo
FROM empleado e
LEFT JOIN vuelo v ON e.id_empleado = v.id_piloto;



-- G) Consultas de agregación con RIGHT JOIN
-- 1. Mostrar vuelos aunque no tengan reservas
SELECT r.id_reserva, v.id_vuelo, v.fecha
FROM reserva r
RIGHT JOIN vuelo v ON r.id_vuelo = v.id_vuelo;

-- 2. Aeropuertos aunque no tengan empleados
SELECT e.id_empleado, a.nombre AS aeropuerto
FROM empleado e
RIGHT JOIN aeropuerto a ON e.id_aeropuerto = a.id_aeropuerto;

-- 3. Todos los pilotos aunque no tengan vuelos


	SELECT e.nombre_completo AS piloto, v.id_vuelo
	FROM vuelo v
	RIGHT JOIN empleado e ON v.id_piloto = e.id_empleado
	WHERE e.cargo = 'Piloto';
