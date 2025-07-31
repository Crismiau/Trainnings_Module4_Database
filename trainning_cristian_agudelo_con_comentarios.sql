CREATE DATABASE universidad;
use universidad;

-- tabla estudiante 
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    genero VARCHAR(10),
    identificacion INT UNIQUE NOT NULL,
    carrera VARCHAR(100),
    fecha_nacimiento DATE,
    fecha_ingreso DATE NOT NULL
);

-- tabla: docentes
CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(100)  NOT NULL,
    departamento_academico VARCHAR(100),
    anios_experiencia INT CHECK (anios_experiencia >= 0)
);

-- tabla: cursos
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    creditos INT NOT NULL CHECK (creditos BETWEEN 1 AND 10),
    semestre VARCHAR(10),
    id_docente INT,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente) ON DELETE CASCADE
);

-- tabla: inscripciones
CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE NOT NULL,
	calificacion_final DECIMAL(4,2),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE
);

-- insercion de docentes
INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia)
VALUES
('maria rodriguez', 'mrodriguez@univ.edu', 'ingenieria de sistemas', 10),
('carlos perez', 'cperez@univ.edu', 'matematicas', 7),
('cristian agudelo', 'crismiau@univ.edu', 'matematicas', 9),
('Camilo foronda', 'cforonda@univ.edu', 'artes', 5),
('Camilo foronda2', 'cforonda2@univ.edu', 'artes', 5),
('lucia gomez', 'lgomez@univ.edu', 'castellano', 5);

-- insercion de cursos
INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente)
VALUES
('programacion i', 'cs101', 4, '1', 1),
('calculo diferencial', 'mat01', 3, '1', 2),
('filosofia moderna', 'fil10', 2, '2', 3),
('estructuras de datos', 'cs201', 4, '2', 1);

-- insercion de estudiantes
INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso)
VALUES
('ana torres', 'ana.torres@gmail.com', 'femenino', 1001, 'ingenieria de sistemas', '2003-05-10', '2022-01-15'),
('luis martinez', 'luis.m@gmail.com', 'masculino', 1002, 'matematicas', '2002-07-21', '2021-08-10'),
('sofia herrera', 'sofia.h@gmail.com', 'femenino', 1003, 'filosofia', '2001-12-05', '2020-01-15'),
('javier luna', 'javier.luna@gmail.com', 'masculino', 1004, 'ingenieria de sistemas', '2003-02-18', '2022-01-15'),
('camila rios', 'camila.rios@gmail.com', 'femenino', 1005, 'ingenieria de sistemas', '2004-04-12', '2023-01-10');

-- insercion de inscripciones
INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final)
VALUES
(1, 1, '2023-02-01', 4.5),
(2, 2, '2023-02-01', 3.8),
(3, 3, '2023-02-01', 4.2),
(4, 1, '2023-02-01', 4.0),
(5, 1, '2023-02-01', 3.7),
(2, 4, '2023-02-01', 4.1),
(1, 4, '2023-02-01', 4.9),
(5, 3, '2023-02-01', 3.5);


-- Obtener el listado de todos los estudiantes junto con sus inscripciones y cursos (JOIN).
SELECT *
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso;

-- Listar los cursos dictados por docentes con más de 5 años de experiencia.
SELECT 
d.id_docente,
d.nombre_completo AS nombre_docente, 
c.nombre  AS nombre_curso
FROM docentes d
JOIN cursos c ON d.id_docente = c.id_docente
WHERE anios_experiencia > 5;

-- Obtener el promedio de calificaciones por curso (GROUP BY + AVG).
SELECT 
c.nombre,
AVG(calificacion_final) AS promedio_curso
from inscripciones i
JOIN cursos c ON i.id_curso = c.id_curso
GROUP BY nombre;

-- Mostrar los estudiantes que están inscritos en más de un curso (HAVING COUNT(*) > 1).
SELECT 
i.id_estudiante, 
e.nombre_completo,
COUNT(i.id_curso) AS Cantidad_cursos
FROM inscripciones i	
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
GROUP BY i.id_estudiante, e.nombre_completo
HAVING (COUNT(*)>1);

-- Agregar una nueva columna estado_academico a la tabla estudiantes (ALTER TABLE).
ALTER TABLE estudiantes 
	ADD estado_academico ENUM('reprobado', 'aprobado', 'refuerzo');
    
SELECT estado_academico FROM estudiantes;

-- Eliminar un docente y observar el efecto en la tabla cursos (uso de ON DELETE en FK).
DELETE FROM docentes WHERE id_docente = 2;

SELECT * FROM cursos WHERE id_docente = 2;
Select * from cursos;

 -- Consultar los cursos en los que se han inscrito más de 2 estudiantes (GROUP BY + COUNT + HAVING).
SELECT 
c.id_curso,
c.nombre AS Nombre_curso,
COUNT(i.id_estudiante) AS cantidad_estudiantes_inscritos
FROM inscripciones i
JOIN cursos c ON i.id_curso = c.id_curso
GROUP BY c.id_curso, c.nombre
HAVING COUNT(i.id_estudiante) > 2;







-- Subconsultas y funciones
-- Obtener los estudiantes cuya calificación promedio es superior al promedio general (AVG() + subconsulta).
SELECT 
e.id_estudiante,
e.nombre_completo,
AVG(i.calificacion_final) AS promedio_estudiante
FROM estudiantes e 
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING AVG(i.calificacion_final) > (
 SELECT AVG(calificacion_final)
 FROM inscripciones 
 WHERE calificacion_final IS NOT NULL
 );
 
 -- Mostrar los nombres de las carreras con estudiantes inscritos en cursos del semestre 2 o posterior (IN o EXISTS).
 SELECT
 e.carrera
 FROM estudiantes e
 WHERE e.id_studiante IN ( -- aqui Usamos el IN para verificar si hay datos en la subconsulta para validarlo con la consulta grande, si si hay los seleccionamos y los traemos a la consulta
 SELECT i.id_studiante
 FROM inscripciones i
 JOIN cursos c ON i.id_curso = c.id_curso --
 WHERE CAST(c.semestre AS UNSIGNED) >= 2 --  Aqui hacemos la condicion para verificar si hay estudiantes inscritos a cursos con el semetre mayor o igual a 2, si la condición se cumple entonces se unen con el join
 ); --  Este ejercicio fue muy interesante ya que la función CAST se usa en el estandar ASIN SQL-92, donde fue agregada en 1992 junto con los joins y demás funciones, (me investigue muy afondo este estandar)

-- Utiliza funciones como ROUND, SUM, MAX, MIN y COUNT para explorar distintos indicadores del sistema.
SELECT SUM(anios_experiencia) FROM docentes; -- Vemos que la suma total de experiencia de todos los docentes es de 34 años
SELECT ROUND(AVG(anios_experiencia)) FROM docentes; -- El promedio rendondeado de la colummna años de experiencia es de 7

-- consulta donde me muestre los años de experiencia de los docnetes mayores al promedio 
SELECT AVG(anios_experiencia) FROM docentes; -- CON ESTA CONSULTA ESTAMOS VIENDO QUE EL PROMEDIO DE LOS AÑOS ES DE 6,8 SIN REDONDEAR

SELECT 
id_docente,
nombre_completo, 
anios_experiencia
FROM docentes
WHERE anios_experiencia > ( -- EN ESTE WHERE LO QUE HACEMOS ES QUE SOLO MUESTRE LOS DOCENTES QUE TIENEN LOS AÑOS DE EXPERIENCIAS MAYOR AL PROMEDIO GENERAL QUE EN ESTE CCASO EL PROMEDIO GENERAL ES (6,8)
SELECT AVG(anios_experiencia) -- AQUI HACEMOS UNA SUBCONSULTA DONDE HACEMOS EL PROMEDIO DE LOS AÑOS QUE ES: 6,8
FROM docentes
);
SELECT nombre_completo, anios_experiencia FROM docentes;

-- CONSULTA DONDE SOLO SE MUESTREN LOS ESTUDIANTES CON LA CALIFICACION MAYOR AL PROMEDIO GENERAL
SELECT 
e.nombre_completo,
ROUND(i.calificacion_final)
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
WHERE i.calificacion_final > (
SELECT AVG(calificacion_final)
FROM inscripciones);

-- QUIENES FUERON LAS PERSONAS EN SACAR LA MAYOR CALIFICACION POR CURSO INSCRITO
SELECT
 e.nombre_completo, 
i.calificacion_final AS mejor_calificacion,
c.nombre AS curso_donde_se_saco_mejor_nota
FROM inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
WHERE (i.id_estudiante, i.calificacion_final) IN (
SELECT 
	id_estudiante, 
	MAX(calificacion_final)
FROM inscripciones 
GROUP BY id_estudiante)
ORDER BY calificacion_final DESC;


-- Crear una vista
-- Crea una vista llamada vista_historial_academico que muestre: 
CREATE VIEW vista_historial_academico AS
SELECT e.nombre_completo AS Nombre_estudiante,
c.nombre AS nombre_curso,
d.nombre_completo AS Nombre_docente,
c.semestre  AS Nombre_semestre,
i.calificacion_final AS Calificacion_final
FROM inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
JOIN docentes d ON c.id_docente = d.id_docente;

SELECT * FROM vista_historial_academico;	




-- Control de acceso y transacciones
   --  Asigna permisos de solo lectura a un rol llamado revisor_academico sobre la vista vista_historial_academico (GRANT SELECT)./li>
   GRANT SELECT ON vista_historial_academico TO revisor_academico;
   
   -- Revoca los permisos de modificación de datos sobre la tabla inscripciones a este rol (REVOKE).
   REVOKE INSERT, UPDATE, DELETE ON inscripciones FROM revisor_academico; 
   
   
	-- Simula una operación de actualización de calificaciones usando BEGIN, SAVEPOINT, ROLLBACK y COMMIT.
    BEGIN;
    
    UPDATE inscripciones
    SET calificacion_final = 4.5
    WHERE id_inscripcion = 5;
    
    SAVEPOINT cambio1;
    
    ALTER TABLE inscripciones
    MODIFY calificacion_final DECIMAL(3,2) CHECK (calificacion_final BETWEEN 0.0 AND 0.5); -- AQUI HICE UNA ALTERACION A LA COLUMMNA DE calificaciones para que 
    -- tuviera un rango de calificaciones, para asi poder ejecutar la consulta de abajo (va a dar error, pero es bueno ver "que pasaria si...")
	-- SI EJECUTAS ESTO va a dar error, ya que estamos violando una ley de SQL
    
    UPDATE inscripciones
    SET calificacion_final = 6.0
    WHERE id_inscripcion = 8; -- AQUI ESTO SALE ERROR
    
    ROLLBACK TO SAVEPOINT cambio1;
    -- y aqui cuando nos sale error, volvemos al savepoint donde estabamos antes, es como en minecraft: mueres y reapareces en el spawnpoint
    
    UPDATE inscripciones 
	SET calificacion_final = 3.8
	WHERE id_inscripcion = 3;	
-- Hacemos nuestra ultima modificacion ya para hacer cambios y salir del ambiente efimero 

    COMMIT; -- mandamos cambios y salimos del ambiente 

    
