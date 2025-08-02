CREATE DATABASE red_social;
USE red_social;

-- Tabla: users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL  , 
    role VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: follows
CREATE TABLE follows (
    following_user_id INT,
    followed_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (following_user_id, followed_user_id),
    FOREIGN KEY (following_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabla: posts
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    body TEXT,
    user_id INT NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- Insertar usuarios
INSERT INTO users (username, role, created_at) VALUES
('alice', 'admin', '2025-07-01 10:00:00'),
('bob', 'user', '2025-07-02 11:30:00'),
('carol', 'moderator', '2025-07-03 09:15:00'),
('sofia_g', 'user', '2025-07-04 14:45:00'),
('eve', 'user', '2025-07-05 08:00:00');

-- Relaciones de seguimiento
INSERT INTO follows (following_user_id, followed_user_id, created_at) VALUES
(2, 1, '2025-07-06 10:00:00'),  -- Bob sigue a Alice
(3, 1, '2025-07-06 10:05:00'),  -- Carol sigue a Alice
(4, 2, '2025-07-06 10:10:00'),  -- Dave sigue a Bob
(5, 3, '2025-07-06 10:15:00'),  -- Eve sigue a Carol
(2, 4, '2025-07-06 10:20:00');  -- Bob sigue a Dave

-- Publicaciones
INSERT INTO posts (title, body, user_id, status, created_at) VALUES
('Bienvenidos a mi perfil', 'Hola a todos, soy Alice y me encanta programar.', 1, 'publicado', '2025-07-07 09:00:00'),
('Primer post', 'Este es mi primer post en la red social.', 2, 'publicado', '2025-07-07 09:30:00'),
('Moderando contenido', 'Estoy revisando algunos posts para asegurar calidad.', 3, 'borrador', '2025-07-07 10:00:00'),
('¿Alguien juega ajedrez?', 'Busco con quién practicar ajedrez online.', 4, 'publicado', '2025-07-07 11:00:00'),
('Tips de productividad', 'Aquí les dejo algunos consejos para organizar el día.', 5, 'publicado', '2025-07-07 11:30:00'),
('test', 'Busco con quién practicar ajedrez online.', 4, 'publicado', '2025-07-07 11:00:00'),
('holi', 'Busco con quién practicar ajedrez online.', 4, 'publicado', '2025-07-07 11:00:00');



-- 1. Listar todos los usuarios registrados.
SELECT * FROM users;

-- 2. Ver todos los posts publicados por el usuario con username = 'sofia_g'.
SELECT * 
FROM posts -- Consulta facil 
WHERE user_id = 4;

SELECT
	u.id,
	u.username,  -- consulta más avanzada 
    p.title,
    p.body 
FROM users u
JOIN posts p ON u.id = p.user_id
WHERE username LIKE "SOFI%%";


-- 3. Mostrar todos los usuarios con rol 'admin'.
SELECT * FROM users WHERE role = "admin";


-- 4. Ver todos los posts con estado 'publicado'.
SELECT * 
FROM posts 
WHERE status = "publicado" ;

-- 5. Mostrar los nombres de los usuarios que están siendo seguidos.
SELECT DISTINCT
f.followed_user_id AS id_usuario_seguido,
u.username AS usuarios_seguidos
FROM users u
JOIN follows f ON u.id = f.followed_user_id;
 
 -- 6. Consultar el número total de usuarios.
 SELECT COUNT(id) AS total_usuarios
 FROM users;
 
 -- 7. Mostrar los títulos de los posts creados hoy.
 SELECT 
p.title AS titulo_del_titulo,
p.created_at AS fecha_post
FROM posts p
WHERE created_at > "2025-07-07";

-- 8. Obtener el nombre del autor y título de cada post.
SELECT 
u.username AS autor_titulo,
p.title AS titulo_post
FROM users u
JOIN posts p ON u.id = p.user_id;

-- 9. Listar los usuarios junto con la cantidad de seguidores que tienen.
SELECT 
u.username AS nombre_usuarios,
COUNT(f.followed_user_id) AS cantidad_followers
FROM users u 
JOIN follows f ON u.id = f.followed_user_id 
GROUP BY u.username, u.id
ORDER BY cantidad_followers DESC;

-- 10. Mostrar los usuarios que no han publicado ningún post.
SELECT 
u.username,
p.title,
p.body
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE p.id IS NULL;

-- 11. Mostrar los posts junto con el número de palabras en el contenido (body).
SELECT 
p.id,
p.title,
p.body,
(length(body)) AS numero_palabras_body
FROM posts p
ORDER BY numero_palabras_body DESC;

-- 12. Consultar cuántos usuarios hay por tipo de rol.
SELECT 
u.role AS rol_usuario,
COUNT(u.id) AS cantidad_usuarios
FROM users u
GROUP BY ROLE;


-- 13. Obtener la fecha y el autor del post más reciente.
SELECT 
u.username,
p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.created_at = (SELECT MAX(created_at) FROM posts);

-- 14. Mostrar los usuarios que siguen a más de 3 personas.
SELECT 
u.username,
COUNT(f.following_user_id) AS personas_que_sigue
FROM users u
JOIN follows f ON u.id = f.following_user_id
GROUP BY u.username
HAVING COUNT(f.following_user_id) > 3; 

			 -- EN ESTA CONSULTA NO VA A MOSTRAR A NADIE ya que no hay un usuario con más de 3 personas seguidas, en cambio
			 -- si lo hacemos que la condición sea mayor o igual a 2 si aparecera
 SELECT 
 u.username,
 COUNT(f.following_user_id) AS personas_que_sigue
 FROM users u 
 JOIN follows f ON u.id = f.following_user_id
 GROUP BY u.username
 HAVING personas_que_sigue >= 2; -- Aqui hice algo interesante, y fue que defini algo como una función ya que la "variable" 
 -- personas_que_sigue tiene adentro una funcion de count, asi que en vez de colocar nuevamente la misma función, llame la variable y realice
 -- la condicion.

-- 15. Consultar los 5 posts más antiguos con estado 'borrador'.
UPDATE posts SET status = "borrador" WHERE id = 2; -- aqui lo que hice fue cambiar algunos estados de posts que yo solo tenia un dato en estatus "borrador"
UPDATE posts SET status = "borrador" WHERE id = 7;
UPDATE posts SET status = "borrador" WHERE id = 9;

SELECT * FROM posts; -- confirmo los datos en estatus "borrador"

SELECT 
p.id,
p.title,
p.body,
p.status,
p.created_at
FROM posts p
WHERE p.status = "borrador"
ORDER BY created_at ASC;

-- 16. Mostrar los usuarios con más de 2 posts publicados en estado 'publicado'.
SELECT 
u.username,
COUNT(p.id) AS cantidad_publicado 
FROM users u
JOIN posts p ON u.id = p.user_id
WHERE p.status = "publicado"
GROUP BY username
HAVING cantidad_publicado >= 1; -- Aqui decidi colocar >= 1 ya que en mis registro no tengo usuarios 
--                                 que hayan hechos mas de dos publicaciones es tado publicado

-- 17. Listar usuarios que no siguen a nadie pero sí tienen seguidores.
SELECT 
u.username
FROM users u
LEFT JOIN follows f1 ON u.id = f1.following_user_id
LEFT JOIN follows f2 ON u.id = f2.followed_user_id
GROUP BY u.id, u.username
HAVING COUNT(f1.followed_user_id) = 0
AND	COUNT(f2.following_user_id) > 0;

-- 18. Mostrar usuarios que tienen posts pero nunca han seguido a nadie.

SELECT 
u.username
FROM users u 
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN follows f ON p.user_id = f.following_user_id
GROUP BY u.id, u.username
HAVING COUNT(p.id) > 0
AND COUNT(f.followed_user_id) = 0;

-- 19 Mostrar pares de usuarios que se siguen mutuamente.
SELECT 
    u1.username AS usuario_1,
    u2.username AS usuario_2
FROM follows f1
JOIN follows f2 ON f1.following_user_id = f2.followed_user_id
               AND f1.followed_user_id = f2.following_user_id
JOIN users u1 ON u1.id = f1.following_user_id
JOIN users u2 ON u2.id = f1.followed_user_id
WHERE u1.id < u2.id;  -- evita duplicados: muestra A-B pero no B-A

-- 20. Eliminar todos los posts en estado 'borrador' de usuarios con rol 'guest'.
DELETE p
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.status = 'borrador'
  AND u.role = 'guest';
  
  
-- ----------------------------------------------------------------------------------------------------------------------------
-- ignora esto, aqui lo que hice fue añadir un nuevo tipo de dato a mi tabla, ya que no queria que fueran usuarios diferentes |
ALTER TABLE users                                                                                                          -- |                                        
MODIFY COLUMN username VARCHAR(30) UNIQUE NOT NULL;                                                                        -- |
-- -------------------------------------------------------------------------------------------------------------------------- |