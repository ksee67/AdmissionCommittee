-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: AdmissionCommittee22
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abiturient`
--

DROP TABLE IF EXISTS `abiturient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abiturient` (
  `ID_Abiturient` int NOT NULL AUTO_INCREMENT,
  `Surname` varchar(50) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Date_of_Birth` date NOT NULL,
  `Login` varchar(50) NOT NULL,
  `Password` longtext NOT NULL,
  `Post_ID` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`ID_Abiturient`),
  UNIQUE KEY `Login` (`Login`),
  KEY `Post_ID` (`Post_ID`),
  CONSTRAINT `abiturient_ibfk_1` FOREIGN KEY (`Post_ID`) REFERENCES `post` (`ID_Post`),
  CONSTRAINT `CHK_Login_Length_Format_Ab` CHECK (((length(`Login`) >= 5) and (locate(_utf8mb4'@',`Login`) > 0) and (locate(_utf8mb4'.',substr(`Login`,(locate(_utf8mb4'@',`Login`) + 1))) > 0))),
  CONSTRAINT `CHK_Password_Length_Ab` CHECK ((length(`Password`) between 5 and 255))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abiturient`
--

LOCK TABLES `abiturient` WRITE;
/*!40000 ALTER TABLE `abiturient` DISABLE KEYS */;
INSERT INTO `abiturient` VALUES (1,'Иванов','Иван','Иванович','2000-01-15','ivan123@mail.ru','Pass123a!',3),(2,'Петров','Петр','Петрович','2004-05-22','petr456@mail.ru','Pass456f!',3),(3,'Сидорова','Ксения','Ивановна','2002-08-10','kscerus@mail.ru','Pass789y!',3),(4,'Козлов','Алексей','Сергеевич','2006-03-30','alex123@mail.ru','Pass987!y',3),(5,'Никитина','Екатерина','Александровна','2007-11-05','ekaterina456@mail.ru','Pass!654y',3),(6,'Васнецов','Дмитрий','Владимирович','2001-06-18','dmitry789@mail.ru','Pass!321h',3),(7,'Андреева','Анна','Алексеевна','2008-09-12','anna123@mail.ru','Pass789k!',3),(8,'Григорьев','Сергей','Игоревич','2003-02-25','sergei456@mail.ru','Pass15!9n',3),(9,'Жуков','Павел','Николаевич','2006-07-03','pavel789@mail.ru','$2b$10$v4wuWpvLeGtqaY82RMfuTeGIXrsaiTDq0VulglH5b60XPOGi2w4tm',3),(10,'Кузнецова','Ольга','Владимировна','2007-12-08','olga123@mail.ru','Pass!852i',3);
/*!40000 ALTER TABLE `abiturient` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_Abiturient` BEFORE INSERT ON `abiturient` FOR EACH ROW BEGIN
    IF NEW.Date_of_Birth >= CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Дата рождения не может быть в будущем';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CountAbiturients` AFTER INSERT ON `abiturient` FOR EACH ROW BEGIN
    DECLARE totalAbiturients INT;
    SELECT COUNT(*) INTO totalAbiturients FROM Abiturient;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrator` (
  `ID_Administrator` int NOT NULL AUTO_INCREMENT,
  `Surname` varchar(50) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Date_of_Birth` date NOT NULL,
  `Login` varchar(50) NOT NULL,
  `Password` longtext NOT NULL,
  `Post_ID` int NOT NULL,
  PRIMARY KEY (`ID_Administrator`),
  UNIQUE KEY `Login` (`Login`),
  KEY `Post_ID` (`Post_ID`),
  CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`Post_ID`) REFERENCES `post` (`ID_Post`),
  CONSTRAINT `CHK_Login_Length_Format_Ad` CHECK (((length(`Login`) >= 5) and (locate(_utf8mb4'@',`Login`) > 0) and (locate(_utf8mb4'.',substr(`Login`,(locate(_utf8mb4'@',`Login`) + 1))) > 0))),
  CONSTRAINT `CHK_Password_Length_Ad` CHECK ((length(`Password`) between 5 and 255))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

LOCK TABLES `administrator` WRITE;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES (1,'Ефремов','Виктор','Степанович','1999-01-15','viktor2@mail.ru','gjEss123a!',1),(2,'Исаева','Наталья','Петровна','1998-05-22','natalyw3@mail.ru','Pas456f!',1),(3,'Димидова','Анастасия','Павловна','1978-02-26','anastas123@mail.ru','Pass!852i',1),(4,'Иванов','Александр','Сергеевич','1985-07-10','alex_ivanov@mail.ru','Pass123!',2),(5,'Петров','Екатерина','Дмитриевна','1992-11-28','katya_petrov@mail.ru','K@tPetr789',2),(6,'Смирнов','Дмитрий','Александрович','1990-04-15','dmitry_smirv@mail.ru','Sm!rnov45',2),(7,'Кузнецов','Марина','Андреевна','1988-09-03','marina_kuznt@mail.ru','M@r!nKuz72',2);
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_Administrator` BEFORE INSERT ON `administrator` FOR EACH ROW BEGIN
    IF NEW.Date_of_Birth >= CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Дата рождения не может быть в будущем';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CountRegisteredUsersAfterInsert` AFTER INSERT ON `administrator` FOR EACH ROW BEGIN
    DECLARE totalUsers INT;
    SELECT COUNT(*) INTO totalUsers FROM Administrator;
    SELECT COUNT(*) INTO totalUsers FROM Abiturient;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CountRegisteredUsers` AFTER INSERT ON `administrator` FOR EACH ROW BEGIN
    DECLARE totalUsers INT;
    SELECT COUNT(*) INTO totalUsers FROM Administrator;
    SELECT COUNT(*) INTO totalUsers FROM Abiturient;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `application_count`
--

DROP TABLE IF EXISTS `application_count`;
/*!50001 DROP VIEW IF EXISTS `application_count`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `application_count` AS SELECT 
 1 AS `Programs_ID`,
 1 AS `Total_Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `Application_ID` int NOT NULL AUTO_INCREMENT,
  `Submission_Date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Average_Student_Grade` decimal(5,2) DEFAULT NULL,
  `Discount` enum('Есть','Нет') DEFAULT 'Нет',
  `Original_Document` enum('Есть','Нет') DEFAULT 'Нет',
  `Abiturient_ID` int DEFAULT NULL,
  `Status_ID` int DEFAULT NULL,
  `Programs_ID` int DEFAULT NULL,
  PRIMARY KEY (`Application_ID`),
  KEY `Abiturient_ID` (`Abiturient_ID`),
  KEY `Status_ID` (`Status_ID`),
  KEY `Programs_ID` (`Programs_ID`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`Abiturient_ID`) REFERENCES `abiturient` (`ID_Abiturient`),
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`ID_Status`),
  CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`Programs_ID`) REFERENCES `programs` (`ID_Program`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,'2024-05-04 10:31:46',5.00,'Нет','Нет',5,4,1),(2,'2024-05-04 10:31:46',4.75,'Нет','Нет',1,4,1),(3,'2024-05-04 10:31:46',4.23,'Нет','Нет',2,4,2),(4,'2024-05-04 10:31:46',4.90,'Нет','Нет',3,4,1),(5,'2024-05-04 10:31:46',3.44,'Нет','Нет',4,4,3);
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `SetDefaultStatus` BEFORE INSERT ON `applications` FOR EACH ROW BEGIN
    SET NEW.Status_ID = IFNULL(NEW.Status_ID, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `ID_Class` int NOT NULL AUTO_INCREMENT,
  `Class_Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Class`),
  CONSTRAINT `class_chk_1` CHECK ((`Class_Name` in (_utf8mb4'На базе 11-го',_utf8mb4'На базе 9-го')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1,'На базе 9-го'),(2,'На базе 11-го');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directionofspecialization`
--

DROP TABLE IF EXISTS `directionofspecialization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directionofspecialization` (
  `ID_Direction` int NOT NULL AUTO_INCREMENT,
  `Direction_Code` varchar(10) NOT NULL,
  `Direction_Name` varchar(100) NOT NULL,
  PRIMARY KEY (`ID_Direction`),
  UNIQUE KEY `Direction_Code` (`Direction_Code`),
  UNIQUE KEY `Direction_Name` (`Direction_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directionofspecialization`
--

LOCK TABLES `directionofspecialization` WRITE;
/*!40000 ALTER TABLE `directionofspecialization` DISABLE KEYS */;
INSERT INTO `directionofspecialization` VALUES (1,'54.03.01','Дизайн'),(2,'09.02.00','Прикладная информатика'),(3,'40.03.01','Юриспруденция'),(4,'19.03.04','Технология продукции и организации общественного питания');
/*!40000 ALTER TABLE `directionofspecialization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_form`
--

DROP TABLE IF EXISTS `education_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education_form` (
  `ID_Education_Form` int NOT NULL AUTO_INCREMENT,
  `Form_Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Education_Form`),
  CONSTRAINT `education_form_chk_1` CHECK ((`Form_Name` in (_utf8mb4'Внебюджетная',_utf8mb4'Бюджетная')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education_form`
--

LOCK TABLES `education_form` WRITE;
/*!40000 ALTER TABLE `education_form` DISABLE KEYS */;
INSERT INTO `education_form` VALUES (1,'Внебюджетная'),(2,'Бюджетная');
/*!40000 ALTER TABLE `education_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailaddresses`
--

DROP TABLE IF EXISTS `emailaddresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emailaddresses` (
  `ID_Email` int NOT NULL AUTO_INCREMENT,
  `EmailAddress` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_Email`),
  UNIQUE KEY `EmailAddress` (`EmailAddress`),
  CONSTRAINT `CHK_Email_Address_Format` CHECK (((length(`EmailAddress`) >= 5) and (locate(_utf8mb4'@',`EmailAddress`) > 0) and (locate(_utf8mb4'.',substr(`EmailAddress`,(locate(_utf8mb4'@',`EmailAddress`) + 1))) > 0)))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailaddresses`
--

LOCK TABLES `emailaddresses` WRITE;
/*!40000 ALTER TABLE `emailaddresses` DISABLE KEYS */;
INSERT INTO `emailaddresses` VALUES (1,'kscerus@mail.ru');
/*!40000 ALTER TABLE `emailaddresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `passing_grades`
--

DROP TABLE IF EXISTS `passing_grades`;
/*!50001 DROP VIEW IF EXISTS `passing_grades`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `passing_grades` AS SELECT 
 1 AS `Programs_ID`,
 1 AS `Available_Seats`,
 1 AS `Passing_Grade`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `personal_data`
--

DROP TABLE IF EXISTS `personal_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_data` (
  `ID_Personal_Data` int NOT NULL AUTO_INCREMENT,
  `Gender` varchar(1) NOT NULL,
  `Phone_Number` varchar(16) NOT NULL,
  `Series` varchar(255) NOT NULL,
  `Number` varchar(255) NOT NULL,
  `Subdivision_Code` varchar(255) NOT NULL,
  `Issued_By` varchar(255) NOT NULL,
  `Date_of_Issue` date NOT NULL,
  `Actual_Residence_Address` varchar(255) NOT NULL,
  `Registration_Address` varchar(255) NOT NULL,
  `SNILS` varchar(255) NOT NULL,
  `Abiturient_ID` int NOT NULL,
  `Photo_certificate` varchar(255) NOT NULL,
  `Photo_passport` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_Personal_Data`),
  UNIQUE KEY `Phone_Number` (`Phone_Number`),
  UNIQUE KEY `SNILS` (`SNILS`),
  KEY `Abiturient_ID` (`Abiturient_ID`),
  CONSTRAINT `personal_data_ibfk_1` FOREIGN KEY (`Abiturient_ID`) REFERENCES `abiturient` (`ID_Abiturient`),
  CONSTRAINT `CHK_Phone_number` CHECK (((`Phone_number` like _utf8mb4'+7(%') and (`Phone_number` like _utf8mb4'%)___-__-__'))),
  CONSTRAINT `personal_data_chk_1` CHECK ((`Gender` in (_utf8mb4'М',_utf8mb4'Ж')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_data`
--

LOCK TABLES `personal_data` WRITE;
/*!40000 ALTER TABLE `personal_data` DISABLE KEYS */;
INSERT INTO `personal_data` VALUES (1,'М','+7(987)654-32-10','1234','56789','123456','ОВД г. Москва','2020-05-15','ул. Пушкина, д. 10','ул. Лермонтова, д. 5','12345678901',4,'аттестат','мое фото'),(2,'Ж','+7(999)123-45-67','5678','98765','654321','ОВД г. Санкт-Петербург','2019-10-20','пр. Невский, д. 20','ул. Гоголя, д. 15','98765432109',5,'аттестат','мое фото'),(3,'Ж','+7(926)111-22-33','4321','98765','111222','ОВД г. Казань','2015-08-05','ул. Спортивная, д. 15','ул. Гагарина, д. 7','98765432101',2,'аттестат','мое фото'),(4,'М','+7(965)555-44-33','8765','12345','555444','ОВД г. Екатеринбург','2012-03-12','пр. Ленина, д. 30','ул. Пушкина, д. 12','12345678902',3,'аттестат','мое фото'),(5,'Ж','+7(925)777-88-99','9876','54321','777888','ОВД г. Новосибирск','2018-06-28','ул. Кирова, д. 5','пр. Октябрьский, д. 17','98765432100',1,'аттестат','мое фото');
/*!40000 ALTER TABLE `personal_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `unique_series_number` BEFORE INSERT ON `personal_data` FOR EACH ROW BEGIN
    IF NEW.Series IS NOT NULL AND NEW.Number IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM Personal_Data
            WHERE Series = NEW.Series AND Number = NEW.Number
        ) THEN
            SET NEW.Series = NULL; 
            SET NEW.Number = NULL; 
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Комбинация серии и номера паспорта должны быть уникальными';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_date_of_issue` BEFORE INSERT ON `personal_data` FOR EACH ROW BEGIN
    IF NEW.Date_of_Issue > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Дата выдачи не может быть больше текущей даты';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `places`
--

DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `places` (
  `ID_Place` int NOT NULL AUTO_INCREMENT,
  `Available_Seats` int NOT NULL,
  `Programs_ID` int NOT NULL,
  PRIMARY KEY (`ID_Place`),
  KEY `FK_Places_Programs` (`Programs_ID`),
  CONSTRAINT `FK_Places_Programs` FOREIGN KEY (`Programs_ID`) REFERENCES `programs` (`ID_Program`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `places`
--

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` VALUES (1,5,1),(2,10,2),(3,5,3),(4,25,4),(5,20,5),(6,25,6),(7,15,7),(8,10,8),(9,15,9),(10,10,10),(11,20,11),(12,10,12),(13,5,13),(14,25,14),(15,15,15),(16,10,16),(17,15,17),(18,20,18),(19,20,19),(20,10,20),(21,15,21);
/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post` (
  `ID_Post` int NOT NULL AUTO_INCREMENT,
  `Post_name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Post`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,'Администратор'),(2,'Секретарь приемной комиссии'),(3,'Абитуриент');
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `ID_Program` int NOT NULL AUTO_INCREMENT,
  `Photo_URL` varchar(255) DEFAULT NULL,
  `Education_Form_ID` int NOT NULL,
  `Class_ID` int NOT NULL,
  `Specialization_ID` int NOT NULL,
  PRIMARY KEY (`ID_Program`),
  KEY `FK_Programs_Education_Form` (`Education_Form_ID`),
  KEY `FK_Programs_Class` (`Class_ID`),
  KEY `FK_Programs_Specialization` (`Specialization_ID`),
  CONSTRAINT `FK_Programs_Class` FOREIGN KEY (`Class_ID`) REFERENCES `class` (`ID_Class`),
  CONSTRAINT `FK_Programs_Education_Form` FOREIGN KEY (`Education_Form_ID`) REFERENCES `education_form` (`ID_Education_Form`),
  CONSTRAINT `FK_Programs_Specialization` FOREIGN KEY (`Specialization_ID`) REFERENCES `specialization` (`ID_Specialization`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'https://static.tildacdn.com/tild6432-3035-4535-a364-303366656436/scale_1200-1-2.jpg',2,1,1),(2,'https://abrakadabra.fun/uploads/posts/2022-02/1644201390_1-abrakadabra-fun-p-arkhitektor-prezentatsiya-2.jpg',1,2,2),(3,'https://abrakadabra.fun/uploads/posts/2022-02/1644201390_1-abrakadabra-fun-p-arkhitektor-prezentatsiya-2.jpg',2,1,2),(4,'https://ostrovrusa.ru/wp-content/uploads/2021/12/blobid1638023117252.jpg',2,1,3),(5,'https://ostrovrusa.ru/wp-content/uploads/2021/12/blobid1638023117252.jpg',1,2,3),(6,'https://architecture-and-design.ru/wp-content/uploads/e/a/c/eacd44dfc6ea95e82195950dbbd051d5.jpeg',2,1,4),(7,'https://architecture-and-design.ru/wp-content/uploads/e/a/c/eacd44dfc6ea95e82195950dbbd051d5.jpeg',1,2,4),(8,'https://mgutm.ru/wp-content/uploads/img/np/college/090205-prikladnaya-informatika.jpg',2,1,5),(9,'https://mgutm.ru/wp-content/uploads/img/np/college/090205-prikladnaya-informatika.jpg',1,2,5),(10,'https://itspectr.ru/wp-content/uploads/2021/09/aks1.jpg',2,1,6),(11,'https://itspectr.ru/wp-content/uploads/2021/09/aks1.jpg',1,2,6),(12,'https://kamensk-uralyskiy.myguru.ru/img/cke/Master-remontiruet-PK-v-ofise.jpg',2,1,7),(13,'https://kamensk-uralyskiy.myguru.ru/img/cke/Master-remontiruet-PK-v-ofise.jpg',1,2,7),(14,'https://cdn-ru.bitrix24.ru/b13797914/landing/3fd/3fdccf2ec2625a6d2d87429a6ac3f7d1/EaKEstDVAAIwU4e.jpg-large_1x.jpg',2,1,8),(15,'https://cdn-ru.bitrix24.ru/b13797914/landing/3fd/3fdccf2ec2625a6d2d87429a6ac3f7d1/EaKEstDVAAIwU4e.jpg-large_1x.jpg',1,2,8),(16,'https://clever-lady.ru/wp-content/uploads/2023/11/285dcc7a1ffa2d82446b21ba475333fd.jpg',2,1,9),(17,'https://clever-lady.ru/wp-content/uploads/2023/11/285dcc7a1ffa2d82446b21ba475333fd.jpg',1,2,9),(18,'https://gamebomb.ru/files/galleries/001/f/fa/419114.jpg',2,1,10),(19,'https://gamebomb.ru/files/galleries/001/f/fa/419114.jpg',1,2,10),(20,'https://do.ssau.ru/gos/pluginfile.php/21101/course/overviewfiles/608c2f443cdba866621589.jpg',2,1,11),(21,'https://do.ssau.ru/gos/pluginfile.php/21101/course/overviewfiles/608c2f443cdba866621589.jpg',1,2,11);
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `sorted_grades`
--

DROP TABLE IF EXISTS `sorted_grades`;
/*!50001 DROP VIEW IF EXISTS `sorted_grades`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sorted_grades` AS SELECT 
 1 AS `Average_Student_Grade`,
 1 AS `Programs_ID`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `specialization`
--

DROP TABLE IF EXISTS `specialization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialization` (
  `ID_Specialization` int NOT NULL AUTO_INCREMENT,
  `Specialty_Code` varchar(8) NOT NULL,
  `Specialty_Name` varchar(100) NOT NULL,
  `Qualification_Name` varchar(100) NOT NULL,
  `Description` varchar(5000) NOT NULL,
  `Training_Duration` varchar(20) NOT NULL,
  `Direction_ID` int NOT NULL,
  PRIMARY KEY (`ID_Specialization`),
  UNIQUE KEY `Specialty_Code` (`Specialty_Code`),
  UNIQUE KEY `Specialty_Name` (`Specialty_Name`),
  KEY `FK_Specialization_Direction` (`Direction_ID`),
  CONSTRAINT `FK_Specialization_Direction` FOREIGN KEY (`Direction_ID`) REFERENCES `specialization` (`ID_Specialization`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialization`
--

LOCK TABLES `specialization` WRITE;
/*!40000 ALTER TABLE `specialization` DISABLE KEYS */;
INSERT INTO `specialization` VALUES (1,'54.01.00','Изобразительное и прикладные виды искусств','Специалист по изобразительному искусству','Изучение различных техник искусства, создание произведений в различных стилях и направлениях. Работа с различными материалами и технологиями.','4 года',1),(2,'07.02.01','Архитектура','Архитектор','Проектирование и планирование архитектурных объектов. Изучение строительных технологий, материалов и дизайна. Работа с профессиональными программами.','5 лет',1),(3,'54.01.20','Графический дизайнер','Графический дизайнер','Разработка графических концепций и дизайна. Использование графических программ и технологий. Создание дизайна для печати и цифровых медиа.','3,5 года',1),(4,'54.02.01','Дизайн (по отраслям)','Дизайнер по отраслям','Разработка дизайна в специфических отраслях. Изучение требований и особенностей конкретной отрасли. Применение творческих решений.','4 года',1),(5,'09.02.00','Информатика и вычислительная техника и управления','Инженер по информатике и вычислительной технике','Разработка программного обеспечения, управление информационными системами, обслуживание компьютерной техники.','4 года',2),(6,'09.02.06','Сетевое и системное администрирование','Системный администратор','Настройка и обслуживание компьютерных сетей, серверов, обеспечение безопасности информации. Решение проблем сетевого взаимодействия.','3,5 года',2),(7,'09.02.01','Компьютерные системы и комплексы','Системный инженер','Проектирование и разработка компьютерных систем и комплексов. Изучение аппаратных и программных решений для компьютерных технологий.','4 года',2),(8,'09.02.07','Информационные системы и программирование','Программист','Разработка программных продуктов, программирование на различных языках. Анализ и оптимизация информационных систем.','4 года',2),(9,'40.02.01','Право и организация социального обеспечения','Юрист по социальному обеспечению','Изучение законодательства, организация социального обеспечения. Правовая поддержка и консультирование граждан.','4 года',3),(10,'40.02.02','Правоохранительная деятельность','Сотрудник правоохранительных органов','Обучение методам борьбы с преступностью, охрана общественного порядка, расследование преступлений. Защита прав и законных интересов.','5 лет',3),(11,'40.02.04','Юриспруденция','Юрист','Изучение юридических дисциплин, подготовка к профессиональной практике. Правовое консультирование и защита интересов в суде.','4 года',3),(12,'19.01.18','Аппаратчик-оператор производства продуктов питания из растительного сырья','Аппаратчик-оператор','Управление процессами производства пищевых продуктов из растительного сырья. Обеспечение качества и безопасности продукции.','3,5 года',4),(13,'19.02.00','Промышленная экология и биотехнологии','Специалист по промышленной экологии и биотехнологиям','Исследование и внедрение экологически чистых технологий. Работа с биотехнологическими процессами в промышленности.','4 года',4);
/*!40000 ALTER TABLE `specialization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `ID_Status` int NOT NULL AUTO_INCREMENT,
  `Status_Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Status`),
  CONSTRAINT `status_chk_1` CHECK ((`Status_Name` in (_utf8mb4'Поступил',_utf8mb4'Не проходит',_utf8mb4'Проходит',_utf8mb4'Отказ',_utf8mb4'На рассмотрении')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'Поступил'),(2,'Не проходит'),(3,'Проходит'),(4,'На рассмотрении'),(5,'Отказ');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tokens`
--

DROP TABLE IF EXISTS `user_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_tokens` (
  `ID_token` int NOT NULL AUTO_INCREMENT,
  `Abiturient_ID` int DEFAULT NULL,
  `Admin_ID` int DEFAULT NULL,
  `access_token` text,
  `refresh_token` text,
  PRIMARY KEY (`ID_token`),
  KEY `Admin_ID` (`Admin_ID`),
  KEY `Abiturient_ID` (`Abiturient_ID`),
  CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`Admin_ID`) REFERENCES `administrator` (`ID_Administrator`),
  CONSTRAINT `user_tokens_ibfk_2` FOREIGN KEY (`Abiturient_ID`) REFERENCES `abiturient` (`ID_Abiturient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tokens`
--

LOCK TABLES `user_tokens` WRITE;
/*!40000 ALTER TABLE `user_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `application_count`
--

/*!50001 DROP VIEW IF EXISTS `application_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `application_count` AS select `applications`.`Programs_ID` AS `Programs_ID`,count(0) AS `Total_Count` from `applications` group by `applications`.`Programs_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `passing_grades`
--

/*!50001 DROP VIEW IF EXISTS `passing_grades`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `passing_grades` AS select `places`.`Programs_ID` AS `Programs_ID`,`places`.`Available_Seats` AS `Available_Seats`,`sorted_grades`.`Average_Student_Grade` AS `Passing_Grade` from (`places` join (select row_number() OVER (PARTITION BY `applications`.`Programs_ID` ORDER BY `applications`.`Average_Student_Grade` desc )  AS `RowNum`,`applications`.`Average_Student_Grade` AS `Average_Student_Grade`,`applications`.`Programs_ID` AS `Programs_ID` from `applications`) `sorted_grades` on((`places`.`Programs_ID` = `sorted_grades`.`Programs_ID`))) where (`places`.`Available_Seats` = `sorted_grades`.`RowNum`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sorted_grades`
--

/*!50001 DROP VIEW IF EXISTS `sorted_grades`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sorted_grades` AS select `applications`.`Average_Student_Grade` AS `Average_Student_Grade`,`applications`.`Programs_ID` AS `Programs_ID` from `applications` order by `applications`.`Programs_ID`,`applications`.`Average_Student_Grade` desc */;
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

-- Dump completed on 2024-05-04 13:46:29
