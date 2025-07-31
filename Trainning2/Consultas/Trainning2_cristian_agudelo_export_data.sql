-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: universidad
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `id_curso` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `creditos` int NOT NULL,
  `semestre` varchar(10) DEFAULT NULL,
  `id_docente` int DEFAULT NULL,
  PRIMARY KEY (`id_curso`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_docente` (`id_docente`),
  CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`id_docente`) REFERENCES `docentes` (`id_docente`) ON DELETE CASCADE,
  CONSTRAINT `cursos_chk_1` CHECK ((`creditos` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

LOCK TABLES `cursos` WRITE;
/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
INSERT INTO `cursos` VALUES (1,'programacion i','cs101',4,'1',1),(3,'filosofia moderna','fil10',2,'2',3),(4,'estructuras de datos','cs201',4,'2',1);
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docentes`
--

DROP TABLE IF EXISTS `docentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docentes` (
  `id_docente` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(100) NOT NULL,
  `correo_institucional` varchar(100) NOT NULL,
  `departamento_academico` varchar(100) DEFAULT NULL,
  `anios_experiencia` int DEFAULT NULL,
  PRIMARY KEY (`id_docente`),
  CONSTRAINT `docentes_chk_1` CHECK ((`anios_experiencia` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docentes`
--

LOCK TABLES `docentes` WRITE;
/*!40000 ALTER TABLE `docentes` DISABLE KEYS */;
INSERT INTO `docentes` VALUES (1,'maria rodriguez','mrodriguez@univ.edu','ingenieria de sistemas',10),(3,'cristian agudelo','crismiau@univ.edu','matematicas',9),(4,'Camilo foronda','cforonda@univ.edu','artes',5),(5,'Camilo foronda2','cforonda2@univ.edu','artes',5),(6,'lucia gomez','lgomez@univ.edu','castellano',5);
/*!40000 ALTER TABLE `docentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id_estudiante` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(100) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `genero` varchar(10) DEFAULT NULL,
  `identificacion` int NOT NULL,
  `carrera` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado_academico` enum('reprobado','aprobado','refuerzo') DEFAULT NULL,
  PRIMARY KEY (`id_estudiante`),
  UNIQUE KEY `correo_electronico` (`correo_electronico`),
  UNIQUE KEY `identificacion` (`identificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
INSERT INTO `estudiantes` VALUES (1,'ana torres','ana.torres@gmail.com','femenino',1001,'ingenieria de sistemas','2003-05-10','2022-01-15',NULL),(2,'luis martinez','luis.m@gmail.com','masculino',1002,'matematicas','2002-07-21','2021-08-10',NULL),(3,'sofia herrera','sofia.h@gmail.com','femenino',1003,'filosofia','2001-12-05','2020-01-15',NULL),(4,'javier luna','javier.luna@gmail.com','masculino',1004,'ingenieria de sistemas','2003-02-18','2022-01-15',NULL),(5,'camila rios','camila.rios@gmail.com','femenino',1005,'ingenieria de sistemas','2004-04-12','2023-01-10',NULL);
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripciones`
--

DROP TABLE IF EXISTS `inscripciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones` (
  `id_inscripcion` int NOT NULL AUTO_INCREMENT,
  `id_estudiante` int DEFAULT NULL,
  `id_curso` int DEFAULT NULL,
  `fecha_inscripcion` date NOT NULL,
  `calificacion_final` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id_inscripcion`),
  KEY `id_estudiante` (`id_estudiante`),
  KEY `id_curso` (`id_curso`),
  CONSTRAINT `inscripciones_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE,
  CONSTRAINT `inscripciones_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones`
--

LOCK TABLES `inscripciones` WRITE;
/*!40000 ALTER TABLE `inscripciones` DISABLE KEYS */;
INSERT INTO `inscripciones` VALUES (1,1,1,'2023-02-01',4.50),(3,3,3,'2023-02-01',3.80),(4,4,1,'2023-02-01',4.00),(5,5,1,'2023-02-01',4.50),(6,2,4,'2023-02-01',4.10),(7,1,4,'2023-02-01',4.90),(8,5,3,'2023-02-01',6.00);
/*!40000 ALTER TABLE `inscripciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_historial_academico`
--

DROP TABLE IF EXISTS `vista_historial_academico`;
/*!50001 DROP VIEW IF EXISTS `vista_historial_academico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_historial_academico` AS SELECT 
 1 AS `Nombre_estudiante`,
 1 AS `nombre_curso`,
 1 AS `Nombre_docente`,
 1 AS `Nombre_semestre`,
 1 AS `Calificacion_final`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_historial_academico`
--

/*!50001 DROP VIEW IF EXISTS `vista_historial_academico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_historial_academico` AS select `e`.`nombre_completo` AS `Nombre_estudiante`,`c`.`nombre` AS `nombre_curso`,`d`.`nombre_completo` AS `Nombre_docente`,`c`.`semestre` AS `Nombre_semestre`,`i`.`calificacion_final` AS `Calificacion_final` from (((`inscripciones` `i` join `estudiantes` `e` on((`i`.`id_estudiante` = `e`.`id_estudiante`))) join `cursos` `c` on((`i`.`id_curso` = `c`.`id_curso`))) join `docentes` `d` on((`c`.`id_docente` = `d`.`id_docente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-31 17:36:20
