CREATE DATABASE  IF NOT EXISTS `evidenta_participare_cursuri_online` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `evidenta_participare_cursuri_online`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: evidenta_participare_cursuri_online
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `cursuri`
--

DROP TABLE IF EXISTS `cursuri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursuri` (
  `ID_Curs` int NOT NULL AUTO_INCREMENT,
  `ID_Instructor` int NOT NULL,
  `Denumire` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descriere` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Data_Incepere` date NOT NULL,
  `Data_Incheiere` date NOT NULL,
  PRIMARY KEY (`ID_Curs`),
  UNIQUE KEY `Denumire` (`Denumire`),
  KEY `ID_Instructor` (`ID_Instructor`),
  CONSTRAINT `cursuri_ibfk_1` FOREIGN KEY (`ID_Instructor`) REFERENCES `instructori` (`ID_Instructor`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursuri`
--

LOCK TABLES `cursuri` WRITE;
/*!40000 ALTER TABLE `cursuri` DISABLE KEYS */;
INSERT INTO `cursuri` VALUES (1,1,'Python','Introductory Python courses can cover everything from the fundamental programming principles to advanced data structures and algorithms. Learn more about this popular coding language and its many uses.','2023-10-09','2023-11-13'),(2,2,'C Programming','C programming is used to develop software applications and operating systems. Learn C programming online with courses to build your skills and advance your career.','2023-10-11','2023-11-15'),(3,1,'Django','Django is a web framework that makes web development in Python easier. Learning it can be a pathway to creating new websites, products, and innovations. Learn how an online Django course can help build your professional skills.','2023-11-20','2023-12-11'),(4,3,'HTML','HTML is the basis for web pages. And while coding and programming languages vary, understanding HTML is essential for a front-end developer. Take HTML courses online to learn the skills front-end developers need.','2023-10-09','2023-11-13'),(5,4,'Java','Are you looking to go from a Java novice to a skilled programmer? Our online Java programming offerings can help professionals build their programming skills and learn specialized applications of Java.','2023-11-22','2023-12-20'),(6,3,'JavaScript','JavaScript can be an entry point into coding and an accessible programming language to learn. Whether you choose an online JavaScript course or a JavaScript certification, you can learn the basics of powering dynamic, interactive user experiences.','2023-11-22','2023-12-20'),(7,5,'Machine Learning','Gain a better understanding of machine learning with online college courses and tutorials.','2023-10-11','2023-11-15'),(8,5,'Artificial Intelligence','Artificial intelligence (AI) is used for everything from predicting what you will type to providing care for people experiencing a mental health crisis. Explore how to learn this important tool with online AI courses delivered through our site.','2023-11-20','2023-12-18');
/*!40000 ALTER TABLE `cursuri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examen_final`
--

DROP TABLE IF EXISTS `examen_final`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examen_final` (
  `ID_Examen_Final` int NOT NULL AUTO_INCREMENT,
  `ID_Curs` int NOT NULL,
  `Tip_Examen` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Data_Sustinerii` date NOT NULL,
  `Durata` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Punctaj_Minim` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Examen_Final`),
  KEY `ID_Curs` (`ID_Curs`),
  CONSTRAINT `examen_final_ibfk_1` FOREIGN KEY (`ID_Curs`) REFERENCES `cursuri` (`ID_Curs`),
  CONSTRAINT `examen_final_chk_1` CHECK ((`Tip_Examen` in (_utf8mb4'Teoretic',_utf8mb4'Practic')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examen_final`
--

LOCK TABLES `examen_final` WRITE;
/*!40000 ALTER TABLE `examen_final` DISABLE KEYS */;
INSERT INTO `examen_final` VALUES (1,1,'Practic','2023-11-11','2h','60'),(2,2,'Practic','2023-11-14','1h30','75'),(3,3,'Practic','2023-12-17','2h','50'),(4,4,'Teoretic','2023-11-11','1h','45'),(5,5,'Practic','2023-12-18','2h','70'),(6,6,'Teoretic','2023-12-19','1h30','55'),(7,7,'Teoretic','2023-11-14','1h','50'),(8,8,'Teoretic','2023-12-17','1h30','60');
/*!40000 ALTER TABLE `examen_final` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructori`
--

DROP TABLE IF EXISTS `instructori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructori` (
  `ID_Instructor` int NOT NULL AUTO_INCREMENT,
  `Nume` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'F',
  `Data_Nastere` date DEFAULT NULL,
  `Date_Contact` char(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Specializare` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Instructor`),
  UNIQUE KEY `Date_Contact` (`Date_Contact`),
  CONSTRAINT `instructori_chk_1` CHECK ((`Sex` in (_utf8mb4'F',_utf8mb4'M')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructori`
--

LOCK TABLES `instructori` WRITE;
/*!40000 ALTER TABLE `instructori` DISABLE KEYS */;
INSERT INTO `instructori` VALUES (1,'Jose Portilla','M','1993-12-20','+40 756 434 768','Python, Data Science, Web Development (inclusiv Django)'),(2,'David J. Malan','M','1978-05-17','+40 798 234 975','Computer Science, Programare (C, Python, JavaScript etc.)'),(3,'Andrei Neagoie','M','1985-08-16','+40 713 455 223','JavaScript, HTML, CSS, Web Development'),(4,'Ellen Spertus','F','1998-07-21','+40 756 892 334','Computer Science, Java'),(5,'Daphne Koller','F','1973-04-06','+40 737 383 294','Machine Learning, Neural Networks, Data Science');
/*!40000 ALTER TABLE `instructori` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lectii`
--

DROP TABLE IF EXISTS `lectii`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lectii` (
  `ID_Lectie` int NOT NULL AUTO_INCREMENT,
  `ID_Curs` int NOT NULL,
  `Titlu_Lectie` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Descriere` varchar(3000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Durata` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Lectie`),
  KEY `ID_Curs` (`ID_Curs`),
  KEY `IX_LECTII` (`ID_Lectie`),
  CONSTRAINT `lectii_ibfk_1` FOREIGN KEY (`ID_Curs`) REFERENCES `cursuri` (`ID_Curs`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lectii`
--

LOCK TABLES `lectii` WRITE;
/*!40000 ALTER TABLE `lectii` DISABLE KEYS */;
INSERT INTO `lectii` VALUES (1,1,'Introduction to Python Basics','Covers Python syntax, variables, data types, basic operations, and simple scripts.','60min'),(2,1,'Working with Data in Python',' Explores data structures (lists, tuples, dictionaries), file handling, and input/output operations.','90min'),(3,1,'Object-Oriented Programming (OOP) and Libraries','Introduces OOP concepts (classes, objects, inheritance) and basic usage of libraries like NumPy and Matplotlib.','75min'),(4,1,'Advanced Python Concepts: Generators and Decorators','Exploring advanced Python features like generators and decorators for efficient and clean code.','90min'),(5,2,'Introduction to C Programming and Basics','Introduces C language fundamentals, including syntax, variables, data types, and basic operations.','60min'),(6,2,'Control Structures and Functions in C','Covers control flow structures (if, switch, loops) and function creation, arguments, and return types.','75min'),(7,2,'Arrays, Pointers, and Memory Management','Explores arrays, pointers, dynamic memory allocation, and their usage in C programming.','75min'),(8,2,'File Handling and Advanced Topics in C',NULL,'90mn'),(9,3,'Introduction to Django and Web Development Basics',NULL,'60min'),(10,3,'Django Models and ORM (Object-Relational Mapping)','Covers creating models, database relationships, querying data using Django\'s ORM, and migrations.','90min'),(11,3,'Authentication, Security, and Deployment in Django','Covers user authentication, authorization, securing views, and deploying a Django application.','75min'),(12,4,'Introduction to HTML and Basic Structure','Introduces HTML, its purpose, syntax, basic structure, tags, and elements.','60min'),(13,4,'HTML Text Formatting and Document Structure','Covers text formatting tags, lists, links, semantic elements, and structuring a webpage.','60min'),(14,4,'Working with Images, Tables, and Forms in HTML','Explores image tags, table creation, form elements, and input validation in HTML.','75min'),(15,4,'HTML5, Multimedia, and Responsive Design','Covers HTML5 elements, audio/video tags, responsive design principles, and basic CSS usage.','90min'),(16,5,'Introduction to Java Basics',NULL,'60min'),(17,5,'Control Flow and Object-Oriented Programming (OOP) in Java','Covers if statements, loops, classes, objects, inheritance, polymorphism, and encapsulation in Java.','60min'),(18,5,'Java Collections and Exception Handling','Explores Java collections framework (lists, maps, sets), handling exceptions, and error management.','75min'),(19,5,'File Handling, Multithreading, and Basic Networking in Java',NULL,'75min'),(20,5,'Java GUI Development using Swing or JavaFX','Introduces building graphical user interfaces (GUIs) in Java using Swing or JavaFX, covering components, event handling, and basic UI design principles.','90min'),(21,5,'Advanced Java Concepts: Generics and Lambda Expressions','Explores advanced Java features such as generics for type safety and lambda expressions for functional programming.','90min'),(22,6,'Introduction to JavaScript Basics',NULL,'60min'),(23,6,'Arrays, Objects, and Functions in JavaScript',NULL,'75min'),(24,6,'Working with APIs and Fetch in JavaScript','Covers making API requests using Fetch, handling responses, and working with external data sources.','75min'),(25,6,'DOM Manipulation and Event Handling','Explores manipulating the Document Object Model (DOM), handling events, and interacting with HTML elements dynamically.','90min'),(26,7,'Introduction to Machine Learning','Provides an overview of machine learning concepts, types of machine learning (supervised, unsupervised, reinforcement learning), and basic terminology.','75min'),(27,7,'Supervised Learning: Regression and Classification','Focuses on regression (linear regression, polynomial regression) and classification (logistic regression, decision trees) algorithms, evaluation metrics, and applications.','75min'),(28,7,'Neural Networks and Deep Learning','Covers neural network basics, deep learning architectures (CNNs, RNNs), training models, and their applications in various domains.','90min'),(29,8,'Introduction to Artificial Intelligence',NULL,'60min'),(30,8,'Machine Learning Algorithms and Techniques','Covers various machine learning algorithms (supervised, unsupervised, reinforcement learning), optimization, and model evaluation methods.','75min'),(31,8,'Natural Language Processing (NLP) and Text Analytics','Explores NLP techniques, sentiment analysis, text classification, and language generation using AI.','75min'),(32,8,'Computer Vision and Image Recognition',NULL,'90min'),(33,8,'Reinforcement Learning and Applications','Focuses on reinforcement learning concepts, algorithms (such as Q-learning, Deep Q Networks), and real-world applications in robotics, gaming, and control systems.','90min');
/*!40000 ALTER TABLE `lectii` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participare_cursuri`
--

DROP TABLE IF EXISTS `participare_cursuri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participare_cursuri` (
  `ID_Participare` int NOT NULL AUTO_INCREMENT,
  `ID_Curs` int NOT NULL,
  `ID_Student` int NOT NULL,
  `Stare_Prezenta` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Data_Prezenta` date NOT NULL,
  `Motiv_Absenta` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID_Participare`),
  KEY `ID_Curs` (`ID_Curs`),
  KEY `ID_Student` (`ID_Student`),
  CONSTRAINT `participare_cursuri_ibfk_1` FOREIGN KEY (`ID_Curs`) REFERENCES `cursuri` (`ID_Curs`),
  CONSTRAINT `participare_cursuri_ibfk_2` FOREIGN KEY (`ID_Student`) REFERENCES `studenti` (`ID_Student`),
  CONSTRAINT `participare_cursuri_chk_1` CHECK ((`Stare_Prezenta` in (_utf8mb4'Prezent',_utf8mb4'Absent',_utf8mb4'Intarziat',_utf8mb4'Motivat')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participare_cursuri`
--

LOCK TABLES `participare_cursuri` WRITE;
/*!40000 ALTER TABLE `participare_cursuri` DISABLE KEYS */;
INSERT INTO `participare_cursuri` VALUES (1,1,1,'Prezent','2023-10-16',NULL),(2,1,5,'Absent','2023-10-16','Health Issue'),(3,2,4,'Intarziat','2023-10-18',NULL),(4,2,7,'Absent','2023-10-18','Family Emergency'),(5,2,10,'Prezent','2023-10-18',NULL),(6,4,3,'Prezent','2023-10-09',NULL),(7,4,12,'Absent','2023-10-09','Medical Appointment'),(8,4,10,'Motivat','2023-10-09',NULL),(9,7,6,'Prezent','2023-10-25',NULL),(10,7,2,'Absent','2023-10-25','Unexpected Personal Matter');
/*!40000 ALTER TABLE `participare_cursuri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `studenti`
--

DROP TABLE IF EXISTS `studenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `studenti` (
  `ID_Student` int NOT NULL AUTO_INCREMENT,
  `Nume` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Adresa` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'F',
  `Data_Nastere` date DEFAULT NULL,
  `Date_Contact` char(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_Student`),
  UNIQUE KEY `Date_Contact` (`Date_Contact`),
  CONSTRAINT `studenti_chk_1` CHECK ((`Sex` in (_utf8mb4'F',_utf8mb4'M')))
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studenti`
--

LOCK TABLES `studenti` WRITE;
/*!40000 ALTER TABLE `studenti` DISABLE KEYS */;
INSERT INTO `studenti` VALUES (1,'Andrei Dumitrescu','Strada Avram Iancu 9, Sibiu, Romania, 550001','M','1998-03-15','+40 755 487 475'),(2,'Ana Radu','Strada Republicii 31, Constanța, Romania, 900001','F','1998-12-03','+40 754 293 034'),(3,'Adrian Patel','456 Pine Street, Sunnyvale, Fantasy Heights, FH 54321','M','1999-02-28','+40 734 293 329'),(4,'Maya Singh','678 Willow Lane, Moonlight Terrace, Enchanted Valley, EV 13579','F','1993-12-18','+40 764 129 348'),(5,'Bianca Fischer','1234 Elm Street, Willowdale, Fiction City, FC 56789','F','1997-05-04','+40 765 389 298'),(6,'Marius Preda','Piața Mare 22, Târgu Mureș, Romania, 540001','M','2001-08-20','+40 747 109 217'),(7,'Bogdan Vasilescu','Strada Portului 10, Tulcea, Romania, 820003','M','2002-09-05','+40 791 723 938'),(8,'Ioana Marinescu','Bulevardul Unirii 17, Oradea, Romania, 410001','F','1995-11-10','+40 737 298 376'),(9,'Lucas Costa','890 Oak Lane, Cedarville, Dreamland, DL 67890','M','2002-02-05','+40 734 293 387'),(10,'Alexandra Brooks','789 Birch Road, Lakeside, Wonderland, WL 98765','F','1998-05-18','+40 746 287 733'),(11,'Raluca Stanescu','Calea Moșilor 5, Galați, Romania, 800001','F','2000-10-25','+40 737 827 387'),(12,'Andreea Gheorghe','Piața Libertății 7, Cluj-Napoca, Romania, 400001','F','1997-04-07','+40 767 281 983'),(13,'Popescu Ion','avram, tulcea, romania, 364843','F','2003-05-14','+40 783 349 384'),(14,'Popescu Ion','','M','1900-01-01',''),(16,'Popescu Ionut','splaiul independentei','M','2002-06-14','+40 722 483 293'),(18,'Popescu Ionut','splaiul independentei','M','2003-05-18','+40 722 977 644'),(23,'xxxx','xx, xx, xxx','M','2000-02-20','+40 700 000 000'),(26,'alexia','asd','M','2003-05-14','+40 773 478 287'),(32,'ergte','ertetet','M','2002-05-12','+40723086084');
/*!40000 ALTER TABLE `studenti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `ID_User` int NOT NULL,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Password` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID_User`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'alexia','alexia1');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'evidenta_participare_cursuri_online'
--

--
-- Dumping routines for database 'evidenta_participare_cursuri_online'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-17 14:43:24
