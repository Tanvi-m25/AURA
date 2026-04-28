SET sql_require_primary_key = 0;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: aura_db
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `performed_by` varchar(100) NOT NULL,
  `old_value` text,
  `new_value` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(300) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_application` (`application_id`),
  KEY `idx_audit_created` (`created_at`),
  KEY `idx_audit_action` (`action`),
  CONSTRAINT `fk_audit_application` FOREIGN KEY (`application_id`) REFERENCES `loan_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,1,'LOAN_REVIEW','amit.sharma@aurabank.com',NULL,'SUBMITTED','10.0.1.15','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(2,1,'STATUS_CHANGE','amit.sharma@aurabank.com','SUBMITTED','UNDER_REVIEW','10.0.1.15','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(3,1,'RISK_ASSESSMENT_RUN','AI_ENGINE',NULL,'Score: 18.50','10.0.5.200','AURA-RM-v3.1','2026-04-15 00:02:43'),(4,1,'STATUS_CHANGE','amit.sharma@aurabank.com','UNDER_REVIEW','APPROVED','10.0.1.15','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(5,1,'DISBURSEMENT','amit.sharma@aurabank.com','APPROVED','DISBURSED','10.0.1.15','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(6,2,'APPLICATION_CREATED','priya.nair@aurabank.com',NULL,'SUBMITTED','10.0.2.30','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(7,2,'STATUS_CHANGE','priya.nair@aurabank.com','SUBMITTED','APPROVED','10.0.2.30','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(8,5,'APPLICATION_CREATED','ananya.deshmukh@aurabank.com',NULL,'SUBMITTED','10.0.3.45','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(9,5,'RISK_ASSESSMENT_RUN','AI_ENGINE',NULL,'Score: 22.10','10.0.5.200','AURA-RM-v3.1','2026-04-15 00:02:43'),(10,5,'STATUS_CHANGE','ananya.deshmukh@aurabank.com','SUBMITTED','APPROVED','10.0.3.45','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(11,5,'TERMS_REVISED','sneha.patil@aurabank.com','240000000.00','235000000.00','10.0.4.12','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(12,5,'DISBURSEMENT','ananya.deshmukh@aurabank.com','APPROVED','DISBURSED','10.0.3.45','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(13,6,'APPLICATION_CREATED','priya.nair@aurabank.com',NULL,'SUBMITTED','10.0.2.30','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(14,6,'RISK_ASSESSMENT_RUN','AI_ENGINE',NULL,'Score: 72.50','10.0.5.200','AURA-RM-v3.1','2026-04-15 00:02:43'),(15,6,'STATUS_CHANGE','priya.nair@aurabank.com','UNDER_REVIEW','REJECTED','10.0.2.30','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(16,8,'APPLICATION_CREATED','vikram.singh@aurabank.com',NULL,'SUBMITTED','10.0.6.78','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(17,8,'STATUS_CHANGE','vikram.singh@aurabank.com','SUBMITTED','REJECTED','10.0.6.78','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(18,10,'APPLICATION_CREATED','amit.sharma@aurabank.com',NULL,'SUBMITTED','10.0.1.15','Mozilla/5.0 AuraPortal/3.2','2026-04-15 00:02:43'),(19,10,'STATUS_CHANGE','amit.sharma@aurabank.com','SUBMITTED','DISBURSED','10.0.1.15','Mozilla/5.0 AuraPortal/3.2','2026-04-15 00:02:43'),(20,15,'STATUS_CHANGE','sneha.patil@aurabank.com','SUBMITTED','CANCELLED','10.0.4.12','Mozilla/5.0 AuraPortal/3.1','2026-04-15 00:02:43'),(21,23,'APPLICATION_CREATED','SYSTEM',NULL,'SUBMITTED',NULL,NULL,'2026-04-15 01:45:01'),(23,32,'APPLICATION_CREATED','SYSTEM',NULL,'SUBMITTED',NULL,NULL,'2026-04-15 01:58:36'),(24,32,'APPLICATION_CREATED','SYSTEM',NULL,'SUBMITTED',NULL,NULL,'2026-04-15 01:58:36'),(25,9,'STATUS_CHANGE','SYSTEM',NULL,'APPROVED',NULL,NULL,'2026-04-15 02:16:26'),(26,9,'STATUS_CHANGE','SYSTEM',NULL,'APPROVED',NULL,NULL,'2026-04-15 02:16:54'),(27,9,'STATUS_CHANGE','SYSTEM',NULL,'APPROVED',NULL,NULL,'2026-04-15 02:18:01'),(28,9,'STATUS_CHANGE','SYSTEM',NULL,'APPROVED',NULL,NULL,'2026-04-15 02:19:17'),(29,32,'STATUS_CHANGE','amit.sharma@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 12:14:56'),(30,23,'STATUS_CHANGE','amit.sharma@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 12:14:58'),(31,3,'STATUS_CHANGE','amit.sharma@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 12:16:15'),(32,11,'STATUS_CHANGE','priya.nair@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 20:51:59'),(33,2,'STATUS_CHANGE','priya.nair@aurabank.com',NULL,'REJECTED',NULL,NULL,'2026-04-26 21:28:55'),(34,2,'STATUS_CHANGE','priya.nair@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 21:29:05'),(35,5,'STATUS_CHANGE','priya.nair@aurabank.com',NULL,'APPROVED',NULL,NULL,'2026-04-26 21:39:43');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(200) NOT NULL,
  `registration_no` varchar(50) NOT NULL,
  `industry` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'India',
  `pincode` varchar(10) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `annual_revenue` decimal(18,2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `registration_no` (`registration_no`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'Tata Steel Ltd.','U27100MH2001PLC123456','Manufacturing','10 Bombay House, Homi Mody St','Mumbai','Maharashtra','India','400001','finance@tatasteel.com','+91-22-66658282',1520000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(2,'Infosys Technologies','U72200KA1981PLC234567','IT Services','Electronics City Phase 1','Bengaluru','Karnataka','India','560100','loans@infosys.com','+91-80-28520261',1670000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(3,'Reliance Industries','L17110MH1973PLC345678','Conglomerate','Maker Chambers IV, Nariman Pt','Mumbai','Maharashtra','India','400021','treasury@ril.com','+91-22-35553000',8900000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(4,'Sunrise Agritech Pvt Ltd','U01400TG2015PTC456789','Agriculture','45 Farm Road, Kompally','Hyderabad','Telangana','India','500014','contact@sunriseagri.in','+91-40-29801234',85000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(5,'GreenBuild Constructions','U45200KA2018PTC567890','Construction','12 Outer Ring Rd, Marathahalli','Bengaluru','Karnataka','India','560037','info@greenbuild.co.in','+91-80-41234567',320000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(6,'MedLife Pharmaceuticals','U24230GJ2010PLC678901','Pharmaceuticals','88 GIDC Estate, Ankleshwar','Bharuch','Gujarat','India','393002','corporate@medlifepharma.com','+91-2646-220100',410000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(7,'QuickMove Logistics','U63000DL2016PTC789012','Logistics','Plot 9, Mahipalpur Extn','New Delhi','Delhi','India','110037','finance@quickmove.in','+91-11-46123456',190000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(8,'BrightStar EdTech','U80900MH2019PTC890123','Education','2nd Floor, Bandra Kurla Complex','Mumbai','Maharashtra','India','400051','admin@brightstar.edu.in','+91-22-26543210',55000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(9,'CoastalFoods India','U15400KL2012PLC901234','Food Processing','27 Seafood Park, Aroor','Alappuzha','Kerala','India','688534','accounts@coastalfoods.in','+91-477-2870123',230000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(10,'NexGen Renewable Energy','U40100RJ2017PTC012345','Renewable Energy','Solar Park Rd, Bhadla','Jodhpur','Rajasthan','India','342602','cfo@nexgenrenew.com','+91-291-2554321',540000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(11,'PrimeTex Garments','U17200TN2014PTC113456','Textiles','14 Apparel Park, Perundurai','Erode','Tamil Nadu','India','638052','director@primetex.co.in','+91-4294-230567',175000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(12,'SilverLine Auto Components','U34300PN2009PLC224567','Automotive','A-22 Chakan MIDC','Pune','Maharashtra','India','410501','purchase@silverlineauto.com','+91-2135-672345',680000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(13,'CloudNine Hospitality','U55100GA2020PTC335678','Hospitality','78 Beach Rd, Candolim','North Goa','Goa','India','403515','reservations@cloudnine.in','+91-832-2489012',92000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(14,'DataMesh Analytics','U72300KA2021PTC446789','Analytics','5th Floor, HSR Layout','Bengaluru','Karnataka','India','560102','hello@datamesh.ai','+91-80-49876543',30000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43'),(15,'AquaPure Water Solutions','U36999MP2019PTC557890','Water Treatment','Industrial Area, Mandideep','Bhopal','Madhya Pradesh','India','462046','sales@aquapure.co.in','+91-755-4023456',45000000.00,'2026-04-15 00:02:43','2026-04-15 00:02:43');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_1nf_violation`
--

DROP TABLE IF EXISTS `company_1nf_violation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_1nf_violation` (
  `company_id` int DEFAULT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `phones` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_1nf_violation`
--

LOCK TABLES `company_1nf_violation` WRITE;
/*!40000 ALTER TABLE `company_1nf_violation` DISABLE KEYS */;
INSERT INTO `company_1nf_violation` VALUES (1,'Tata Steel Ltd.','+91-22-66658282, +91-22-66658285'),(2,'Infosys Technologies','+91-80-28520261, +91-80-28520262'),(3,'Reliance Industries','+91-22-35553000, +91-22-35553001');
/*!40000 ALTER TABLE `company_1nf_violation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_certification`
--

DROP TABLE IF EXISTS `company_certification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_certification` (
  `company_id` int DEFAULT NULL,
  `certification` varchar(50) DEFAULT NULL,
  `issued_year` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_certification`
--

LOCK TABLES `company_certification` WRITE;
/*!40000 ALTER TABLE `company_certification` DISABLE KEYS */;
INSERT INTO `company_certification` VALUES (1,'ISO 9001',2018),(1,'ISO 14001',2020),(3,'ISO 9001',2015),(3,'ISO 50001',2022);
/*!40000 ALTER TABLE `company_certification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_multi_4nf`
--

DROP TABLE IF EXISTS `company_multi_4nf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_multi_4nf` (
  `company_id` int DEFAULT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `certification` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_multi_4nf`
--

LOCK TABLES `company_multi_4nf` WRITE;
/*!40000 ALTER TABLE `company_multi_4nf` DISABLE KEYS */;
INSERT INTO `company_multi_4nf` VALUES (1,'Tata Steel Ltd.','+91-22-66658282','ISO 9001'),(1,'Tata Steel Ltd.','+91-22-66658282','ISO 14001'),(1,'Tata Steel Ltd.','+91-22-66658285','ISO 9001'),(1,'Tata Steel Ltd.','+91-22-66658285','ISO 14001'),(3,'Reliance Industries','+91-22-35553000','ISO 9001'),(3,'Reliance Industries','+91-22-35553000','ISO 50001');
/*!40000 ALTER TABLE `company_multi_4nf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_phone_1nf`
--

DROP TABLE IF EXISTS `company_phone_1nf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_phone_1nf` (
  `company_id` int DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `phone_type` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_phone_1nf`
--

LOCK TABLES `company_phone_1nf` WRITE;
/*!40000 ALTER TABLE `company_phone_1nf` DISABLE KEYS */;
INSERT INTO `company_phone_1nf` VALUES (1,'+91-22-66658282','Primary'),(1,'+91-22-66658285','Secondary'),(2,'+91-80-28520261','Primary'),(2,'+91-80-28520262','Secondary'),(3,'+91-22-35553000','Primary'),(3,'+91-22-35553001','Secondary');
/*!40000 ALTER TABLE `company_phone_1nf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `high_risk_loans`
--

DROP TABLE IF EXISTS `high_risk_loans`;
/*!50001 DROP VIEW IF EXISTS `high_risk_loans`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `high_risk_loans` AS SELECT 
 1 AS `application_id`,
 1 AS `application_number`,
 1 AS `company_name`,
 1 AS `requested_amount`,
 1 AS `officer_name`,
 1 AS `risk_score`,
 1 AS `risk_category`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `loan_application`
--

DROP TABLE IF EXISTS `loan_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_application` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `application_number` varchar(30) NOT NULL,
  `company_id` int NOT NULL,
  `officer_id` int NOT NULL,
  `loan_type` varchar(50) NOT NULL,
  `requested_amount` decimal(18,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'INR',
  `purpose` varchar(500) NOT NULL,
  `application_date` date NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'SUBMITTED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `application_number` (`application_number`),
  KEY `idx_app_company` (`company_id`),
  KEY `idx_app_officer` (`officer_id`),
  KEY `idx_app_status` (`status`),
  KEY `idx_app_date` (`application_date`),
  CONSTRAINT `fk_app_company` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_app_officer` FOREIGN KEY (`officer_id`) REFERENCES `loan_officer` (`officer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_app_status` CHECK ((`status` in (_utf8mb4'SUBMITTED',_utf8mb4'UNDER_REVIEW',_utf8mb4'RISK_ASSESSMENT',_utf8mb4'APPROVED',_utf8mb4'REJECTED',_utf8mb4'DISBURSED',_utf8mb4'CLOSED',_utf8mb4'CANCELLED'))),
  CONSTRAINT `chk_requested_amount` CHECK ((`requested_amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_application`
--

LOCK TABLES `loan_application` WRITE;
/*!40000 ALTER TABLE `loan_application` DISABLE KEYS */;
INSERT INTO `loan_application` VALUES (1,'AURA-2025-00001',1,1,'Term Loan',7500000.00,'INR','Expansion of Kalinganagar steel plant','2025-01-10','DISBURSED','2026-04-15 00:02:43','2026-04-15 02:15:12'),(2,'AURA-2025-00002',2,2,'Working Capital',120000000.00,'INR','Working capital for FY26 onshore projects','2025-01-18','RISK_ASSESSMENT','2026-04-15 00:02:43','2026-04-26 21:29:13'),(3,'AURA-2025-00003',3,1,'Term Loan',2000000000.00,'INR','Green hydrogen project financing','2025-02-05','APPROVED','2026-04-15 00:02:43','2026-04-26 12:16:15'),(4,'AURA-2025-00004',4,5,'Equipment Finance',15000000.00,'INR','Purchase of cold storage units for farm produce','2025-02-12','APPROVED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(5,'AURA-2025-00005',5,6,'Project Finance',250000000.00,'INR','Affordable housing project in Whitefield','2025-02-20','APPROVED','2026-04-15 00:02:43','2026-04-26 21:39:43'),(6,'AURA-2025-00006',6,2,'Term Loan',80000000.00,'INR','New API manufacturing facility','2025-03-01','RISK_ASSESSMENT','2026-04-15 00:02:43','2026-04-26 21:39:48'),(7,'AURA-2025-00007',7,8,'Working Capital',30000000.00,'INR','Fleet expansion ΓÇö 50 new trucks','2025-03-10','APPROVED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(8,'AURA-2025-00008',8,5,'Working Capital',10000000.00,'INR','Content development and marketing spend','2025-03-15','REJECTED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(9,'AURA-2025-00009',9,4,'Equipment Finance',45000000.00,'INR','Automated prawn processing line','2025-03-22','APPROVED','2026-04-15 00:02:43','2026-04-15 02:16:26'),(10,'AURA-2025-00010',10,1,'Project Finance',600000000.00,'INR','200 MW solar park phase-II','2025-04-02','DISBURSED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(11,'AURA-2025-00011',11,8,'Working Capital',25000000.00,'INR','Raw material procurement for monsoon season','2025-04-10','APPROVED','2026-04-15 00:02:43','2026-04-26 20:51:59'),(12,'AURA-2025-00012',12,6,'Term Loan',150000000.00,'INR','New forging and machining center','2025-04-18','APPROVED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(13,'AURA-2025-00013',1,3,'Working Capital',200000000.00,'INR','Import of coking coal ΓÇö Q3 requirement','2025-05-01','UNDER_REVIEW','2026-04-15 00:02:43','2026-04-15 00:02:43'),(14,'AURA-2025-00014',3,1,'Equipment Finance',350000000.00,'INR','Jamnagar refinery upgrade ΓÇö catalytic units','2025-05-08','APPROVED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(15,'AURA-2025-00015',5,4,'Working Capital',40000000.00,'INR','Labour and material costs ΓÇö ongoing project','2025-05-15','CANCELLED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(16,'AURA-2025-00016',7,10,'Equipment Finance',12000000.00,'INR','GPS tracking and cold-chain retrofit','2025-05-22','RISK_ASSESSMENT','2026-04-15 00:02:43','2026-04-15 00:02:43'),(17,'AURA-2025-00017',9,2,'Term Loan',70000000.00,'INR','Seafood export-oriented cold storage','2025-06-01','SUBMITTED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(18,'AURA-2025-00018',10,7,'Working Capital',90000000.00,'INR','O&M expenses for existing 150 MW wind farm','2025-06-10','APPROVED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(19,'AURA-2025-00019',4,5,'Working Capital',8000000.00,'INR','Seasonal crop financing ΓÇö Rabi 2026','2025-06-18','SUBMITTED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(20,'AURA-2025-00020',12,3,'Project Finance',400000000.00,'INR','EV component manufacturing greenfield plant','2025-06-25','UNDER_REVIEW','2026-04-15 00:02:43','2026-04-15 00:02:43'),(21,'TEST-POS-001',1,1,'Term Loan',500000.00,'INR','Valid insert test','2026-04-15','SUBMITTED','2026-04-15 00:02:43','2026-04-15 00:02:43'),(23,'AURA-2025-021',13,3,'TERM_LOAN',8500000.00,'INR','Hotel expansion in Bengaluru','2026-04-15','APPROVED','2026-04-15 01:45:01','2026-04-26 12:14:58'),(32,'AURA-2025-023',13,3,'TERM_LOAN',8500000.00,'INR','Hotel expansion in Bengaluru','2026-04-15','RISK_ASSESSMENT','2026-04-15 01:58:36','2026-04-26 21:08:01');
/*!40000 ALTER TABLE `loan_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_master_unf`
--

DROP TABLE IF EXISTS `loan_master_unf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_master_unf` (
  `application_id` int NOT NULL DEFAULT '0',
  `company_name` varchar(200) NOT NULL,
  `industry` varchar(100) NOT NULL,
  `annual_revenue` decimal(18,2) DEFAULT NULL,
  `officer_name` varchar(201) DEFAULT NULL,
  `department` varchar(100) NOT NULL,
  `loan_type` varchar(50) NOT NULL,
  `requested_amount` decimal(18,2) NOT NULL,
  `risk_score` decimal(5,2),
  `risk_category` varchar(20),
  `interest_rate` decimal(5,2),
  `decision` varchar(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_master_unf`
--

LOCK TABLES `loan_master_unf` WRITE;
/*!40000 ALTER TABLE `loan_master_unf` DISABLE KEYS */;
INSERT INTO `loan_master_unf` VALUES (1,'Tata Steel Ltd.','Manufacturing',1520000000.00,'Amit Sharma','Corporate Lending','Term Loan',500000000.00,18.50,'LOW',9.25,'APPROVED'),(1,'Tata Steel Ltd.','Manufacturing',1520000000.00,'Amit Sharma','Corporate Lending','Term Loan',500000000.00,18.50,'LOW',9.00,'APPROVED'),(2,'Infosys Technologies','IT Services',1670000000.00,'Priya Nair','SME Lending','Working Capital',120000000.00,25.00,'LOW',10.50,'APPROVED'),(2,'Infosys Technologies','IT Services',1670000000.00,'Priya Nair','SME Lending','Working Capital',120000000.00,25.00,'LOW',10.25,'APPROVED'),(3,'Reliance Industries','Conglomerate',8900000000.00,'Amit Sharma','Corporate Lending','Term Loan',2000000000.00,42.30,'MEDIUM',NULL,NULL),(4,'Sunrise Agritech Pvt Ltd','Agriculture',85000000.00,'Vikram Singh','SME Lending','Equipment Finance',15000000.00,30.00,'MEDIUM',11.00,'APPROVED'),(5,'GreenBuild Constructions','Construction',320000000.00,'Ananya Deshmukh','Corporate Lending','Project Finance',250000000.00,22.10,'LOW',9.75,'APPROVED'),(5,'GreenBuild Constructions','Construction',320000000.00,'Ananya Deshmukh','Corporate Lending','Project Finance',250000000.00,22.10,'LOW',9.50,'APPROVED'),(6,'MedLife Pharmaceuticals','Pharmaceuticals',410000000.00,'Priya Nair','SME Lending','Term Loan',80000000.00,72.50,'HIGH',NULL,'REJECTED'),(7,'QuickMove Logistics','Logistics',190000000.00,'Meera Kulkarni','SME Lending','Working Capital',30000000.00,28.70,'LOW',10.75,'APPROVED'),(8,'BrightStar EdTech','Education',55000000.00,'Vikram Singh','SME Lending','Working Capital',10000000.00,78.00,'HIGH',NULL,'REJECTED'),(9,'CoastalFoods India','Food Processing',230000000.00,'Sneha Patil','Corporate Lending','Equipment Finance',45000000.00,48.60,'MEDIUM',NULL,NULL),(10,'NexGen Renewable Energy','Renewable Energy',540000000.00,'Amit Sharma','Corporate Lending','Project Finance',600000000.00,15.20,'LOW',8.90,'APPROVED'),(12,'SilverLine Auto Components','Automotive',680000000.00,'Ananya Deshmukh','Corporate Lending','Term Loan',150000000.00,35.40,'MEDIUM',9.50,'APPROVED'),(13,'Tata Steel Ltd.','Manufacturing',1520000000.00,'Rajesh Iyer','Risk & Compliance','Working Capital',200000000.00,40.00,'MEDIUM',NULL,NULL),(14,'Reliance Industries','Conglomerate',8900000000.00,'Amit Sharma','Corporate Lending','Equipment Finance',350000000.00,20.80,'LOW',9.00,'APPROVED'),(16,'QuickMove Logistics','Logistics',190000000.00,'Divya Reddy','SME Lending','Equipment Finance',12000000.00,55.30,'HIGH',NULL,NULL),(18,'NexGen Renewable Energy','Renewable Energy',540000000.00,'Karthik Rajan','Risk & Compliance','Working Capital',90000000.00,24.00,'LOW',10.25,'APPROVED'),(20,'SilverLine Auto Components','Automotive',680000000.00,'Rajesh Iyer','Risk & Compliance','Project Finance',400000000.00,38.90,'MEDIUM',NULL,NULL),(21,'Tata Steel Ltd.','Manufacturing',1520000000.00,'Amit Sharma','Corporate Lending','Term Loan',500000.00,45.00,'MEDIUM',NULL,NULL);
/*!40000 ALTER TABLE `loan_master_unf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_officer`
--

DROP TABLE IF EXISTS `loan_officer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_officer` (
  `officer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `employee_code` varchar(30) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `department` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_hash` varchar(255) DEFAULT 'admin123',
  PRIMARY KEY (`officer_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_officer`
--

LOCK TABLES `loan_officer` WRITE;
/*!40000 ALTER TABLE `loan_officer` DISABLE KEYS */;
INSERT INTO `loan_officer` VALUES (1,'Amit','Sharma','EMP-1001','amit.sharma@aurabank.com','+91-9876500001','Corporate Lending','Senior Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(2,'Priya','Nair','EMP-1002','priya.nair@aurabank.com','+91-9876500002','SME Lending','Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(3,'Rajesh','Iyer','EMP-1003','rajesh.iyer@aurabank.com','+91-9876500003','Risk & Compliance','Assistant Vice President',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(4,'Sneha','Patil','EMP-1004','sneha.patil@aurabank.com','+91-9876500004','Corporate Lending','Deputy Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(5,'Vikram','Singh','EMP-1005','vikram.singh@aurabank.com','+91-9876500005','SME Lending','Senior Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(6,'Ananya','Deshmukh','EMP-1006','ananya.deshmukh@aurabank.com','+91-9876500006','Corporate Lending','Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(7,'Karthik','Rajan','EMP-1007','karthik.rajan@aurabank.com','+91-9876500007','Risk & Compliance','Vice President',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(8,'Meera','Kulkarni','EMP-1008','meera.kulkarni@aurabank.com','+91-9876500008','SME Lending','Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(9,'Arjun','Menon','EMP-1009','arjun.menon@aurabank.com','+91-9876500009','Corporate Lending','Senior Manager',0,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123'),(10,'Divya','Reddy','EMP-1010','divya.reddy@aurabank.com','+91-9876500010','SME Lending','Deputy Manager',1,'2026-04-15 00:02:43','2026-04-15 00:02:43','admin123');
/*!40000 ALTER TABLE `loan_officer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_outcome`
--

DROP TABLE IF EXISTS `loan_outcome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_outcome` (
  `outcome_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `decision` varchar(20) NOT NULL,
  `decision_date` date NOT NULL,
  `disbursed_amount` decimal(18,2) DEFAULT NULL,
  `disbursement_date` date DEFAULT NULL,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `decision_by` int DEFAULT NULL,
  `remarks` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`outcome_id`),
  UNIQUE KEY `application_id` (`application_id`),
  KEY `fk_outcome_decision_by` (`decision_by`),
  CONSTRAINT `fk_outcome_application` FOREIGN KEY (`application_id`) REFERENCES `loan_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_outcome_decision_by` FOREIGN KEY (`decision_by`) REFERENCES `loan_officer` (`officer_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_decision` CHECK ((`decision` in (_utf8mb4'APPROVED',_utf8mb4'REJECTED',_utf8mb4'DEFERRED',_utf8mb4'CANCELLED')))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_outcome`
--

LOCK TABLES `loan_outcome` WRITE;
/*!40000 ALTER TABLE `loan_outcome` DISABLE KEYS */;
INSERT INTO `loan_outcome` VALUES (1,1,'APPROVED','2025-01-25',480000000.00,'2025-02-01',NULL,1,'All conditions met. Disbursed in two tranches.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(2,2,'APPROVED','2025-02-01',NULL,NULL,NULL,2,'Approved; disbursement pending documentation.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(3,4,'APPROVED','2025-03-01',14000000.00,'2025-03-10',NULL,5,'Equipment vendor confirmed; single-tranche disbursement.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(4,5,'APPROVED','2025-03-05',235000000.00,'2025-03-15',NULL,6,'Disbursed after RERA registration confirmed.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(5,6,'REJECTED','2025-03-12',NULL,NULL,'Poor cash-flow position; high DTI at 55.8%; regulatory compliance pending.',2,'Risk committee unanimous on rejection.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(6,7,'APPROVED','2025-03-20',28000000.00,'2025-03-28',NULL,8,'Fleet purchase orders verified; funds released.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(7,8,'REJECTED','2025-03-25',NULL,NULL,'Pre-revenue company; insufficient collateral; cash runway below threshold.',5,'Advised to re-apply after Series A funding.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(8,10,'APPROVED','2025-04-15',580000000.00,'2025-04-25',NULL,1,'PPA-backed project finance; disbursed per milestone schedule.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(9,12,'APPROVED','2025-05-01',NULL,NULL,NULL,6,'Approved; awaiting site-readiness certificate for disbursement.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(10,14,'APPROVED','2025-05-18',340000000.00,'2025-05-25',NULL,1,'Sponsor guarantee received; phased disbursement initiated.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(11,15,'CANCELLED','2025-05-20',NULL,NULL,'Company withdrew application citing internal fund availability.',4,'No charges applied as per cancellation policy.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(12,18,'APPROVED','2025-06-18',85000000.00,'2025-06-22',NULL,7,'O&M track record verified; single-tranche release.','2026-04-15 00:02:43','2026-04-15 00:02:43'),(13,9,'APPROVED','2026-04-15',NULL,NULL,NULL,5,'Risk score within acceptable range','2026-04-15 02:19:17','2026-04-15 02:19:17');
/*!40000 ALTER TABLE `loan_outcome` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_terms`
--

DROP TABLE IF EXISTS `loan_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_terms` (
  `terms_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `approved_amount` decimal(18,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `tenure_months` int NOT NULL,
  `repayment_frequency` varchar(20) NOT NULL DEFAULT 'MONTHLY',
  `collateral_required` tinyint(1) NOT NULL DEFAULT '0',
  `collateral_details` varchar(500) DEFAULT NULL,
  `processing_fee` decimal(18,2) NOT NULL DEFAULT '0.00',
  `insurance_required` tinyint(1) NOT NULL DEFAULT '0',
  `terms_generated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_by` int DEFAULT NULL,
  PRIMARY KEY (`terms_id`),
  KEY `fk_terms_approved_by` (`approved_by`),
  KEY `idx_terms_application` (`application_id`),
  CONSTRAINT `fk_terms_application` FOREIGN KEY (`application_id`) REFERENCES `loan_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_terms_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `loan_officer` (`officer_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_approved_amount` CHECK ((`approved_amount` > 0)),
  CONSTRAINT `chk_interest_rate` CHECK ((`interest_rate` >= 0)),
  CONSTRAINT `chk_repay_freq` CHECK ((`repayment_frequency` in (_utf8mb4'MONTHLY',_utf8mb4'QUARTERLY',_utf8mb4'HALF_YEARLY',_utf8mb4'YEARLY'))),
  CONSTRAINT `chk_tenure` CHECK ((`tenure_months` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_terms`
--

LOCK TABLES `loan_terms` WRITE;
/*!40000 ALTER TABLE `loan_terms` DISABLE KEYS */;
INSERT INTO `loan_terms` VALUES (1,1,480000000.00,9.25,84,'MONTHLY',1,'Hypothecation of plant & machinery at Kalinganagar',4800000.00,1,'2026-04-15 00:02:43',1),(2,2,120000000.00,10.50,12,'QUARTERLY',0,NULL,1200000.00,0,'2026-04-15 00:02:43',2),(3,4,14000000.00,11.00,60,'MONTHLY',1,'Equipment purchased to serve as collateral',140000.00,1,'2026-04-15 00:02:43',5),(4,5,240000000.00,9.75,120,'MONTHLY',1,'Mortgage on project land at Whitefield Survey #224',2400000.00,1,'2026-04-15 00:02:43',6),(5,7,28000000.00,10.75,36,'MONTHLY',1,'Hypothecation of 50 new commercial vehicles',280000.00,1,'2026-04-15 00:02:43',8),(6,10,580000000.00,8.90,180,'HALF_YEARLY',1,'Solar park assets + SECI PPA assignment',5800000.00,1,'2026-04-15 00:02:43',1),(7,12,140000000.00,9.50,72,'MONTHLY',1,'Hypothecation of CNC machines and forging presses',1400000.00,1,'2026-04-15 00:02:43',6),(8,14,340000000.00,9.00,96,'QUARTERLY',1,'Refinery equipment and land mortgage at Jamnagar',3400000.00,1,'2026-04-15 00:02:43',1),(9,18,85000000.00,10.25,12,'MONTHLY',0,NULL,850000.00,0,'2026-04-15 00:02:43',7),(10,1,480000000.00,9.00,96,'MONTHLY',1,'Hypothecation of plant & machinery at Kalinganagar',4800000.00,1,'2026-04-15 00:02:43',3),(11,5,235000000.00,9.50,120,'MONTHLY',1,'Mortgage on project land at Whitefield Survey #224',2350000.00,1,'2026-04-15 00:02:43',4),(12,2,115000000.00,10.25,12,'QUARTERLY',0,NULL,1150000.00,0,'2026-04-15 00:02:43',2),(13,9,4750000.00,9.25,60,'MONTHLY',0,NULL,5000.00,0,'2026-04-15 02:18:01',5),(14,9,4750000.00,9.25,60,'MONTHLY',0,NULL,5000.00,0,'2026-04-15 02:19:17',5);
/*!40000 ALTER TABLE `loan_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `officer_company_loantype`
--

DROP TABLE IF EXISTS `officer_company_loantype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `officer_company_loantype` (
  `officer_id` int NOT NULL,
  `company_id` int NOT NULL,
  `loan_type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `officer_company_loantype`
--

LOCK TABLES `officer_company_loantype` WRITE;
/*!40000 ALTER TABLE `officer_company_loantype` DISABLE KEYS */;
INSERT INTO `officer_company_loantype` VALUES (1,1,'Term Loan'),(1,3,'Equipment Finance'),(1,3,'Term Loan'),(1,10,'Project Finance'),(2,2,'Working Capital'),(2,6,'Term Loan'),(2,9,'Term Loan'),(3,1,'Working Capital'),(3,12,'Project Finance'),(4,5,'Working Capital'),(4,9,'Equipment Finance'),(5,4,'Equipment Finance'),(5,4,'Working Capital'),(5,8,'Working Capital'),(6,5,'Project Finance'),(6,12,'Term Loan'),(7,10,'Working Capital'),(8,7,'Working Capital'),(8,11,'Working Capital'),(10,7,'Equipment Finance');
/*!40000 ALTER TABLE `officer_company_loantype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `officer_performance_summary`
--

DROP TABLE IF EXISTS `officer_performance_summary`;
/*!50001 DROP VIEW IF EXISTS `officer_performance_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `officer_performance_summary` AS SELECT 
 1 AS `officer_id`,
 1 AS `officer_name`,
 1 AS `designation`,
 1 AS `total_loans`,
 1 AS `avg_risk_score`,
 1 AS `rejections`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pending_loan_dashboard`
--

DROP TABLE IF EXISTS `pending_loan_dashboard`;
/*!50001 DROP VIEW IF EXISTS `pending_loan_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pending_loan_dashboard` AS SELECT 
 1 AS `application_id`,
 1 AS `application_number`,
 1 AS `company_name`,
 1 AS `annual_revenue`,
 1 AS `requested_amount`,
 1 AS `application_date`,
 1 AS `days_pending`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `risk_assessment`
--

DROP TABLE IF EXISTS `risk_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `risk_assessment` (
  `assessment_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `risk_score` decimal(5,2) NOT NULL,
  `risk_category` varchar(20) NOT NULL,
  `assessment_date` date NOT NULL,
  `model_version` varchar(30) NOT NULL,
  `credit_score` int DEFAULT NULL,
  `debt_to_income` decimal(5,2) DEFAULT NULL,
  `default_probability` decimal(5,4) DEFAULT NULL,
  `remarks` text,
  `assessed_by` varchar(100) NOT NULL DEFAULT 'AI_ENGINE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`assessment_id`),
  KEY `idx_risk_application` (`application_id`),
  KEY `idx_risk_category` (`risk_category`),
  CONSTRAINT `fk_risk_application` FOREIGN KEY (`application_id`) REFERENCES `loan_application` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_risk_category` CHECK ((`risk_category` in (_utf8mb4'LOW',_utf8mb4'MEDIUM',_utf8mb4'HIGH',_utf8mb4'VERY_HIGH',_utf8mb4'CRITICAL'))),
  CONSTRAINT `chk_risk_score` CHECK ((`risk_score` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_assessment`
--

LOCK TABLES `risk_assessment` WRITE;
/*!40000 ALTER TABLE `risk_assessment` DISABLE KEYS */;
INSERT INTO `risk_assessment` VALUES (1,1,18.50,'LOW','2025-01-12','AURA-RM-v3.1',810,22.40,0.0120,'Strong balance sheet, consistent cash flows for 10 yrs.','AI_ENGINE','2026-04-15 00:02:43'),(2,2,25.00,'LOW','2025-01-20','AURA-RM-v3.1',790,18.60,0.0180,'Excellent revenue visibility; low leverage ratio.','AI_ENGINE','2026-04-15 00:02:43'),(3,3,42.30,'MEDIUM','2025-02-08','AURA-RM-v3.1',760,35.10,0.0450,'Large exposure; project viability under review.','AI_ENGINE','2026-04-15 00:02:43'),(4,4,30.00,'LOW','2025-02-14','AURA-RM-v3.1',680,40.20,0.0380,'Agri sector cyclicality noted; adequate collateral offered.','AI_ENGINE','2026-04-15 00:02:43'),(5,5,22.10,'LOW','2025-02-22','AURA-RM-v3.1',750,28.50,0.0200,'Govt affordable housing scheme backing; strong pre-sales.','AI_ENGINE','2026-04-15 00:02:43'),(6,6,72.50,'HIGH','2025-03-03','AURA-RM-v3.1',580,55.80,0.0920,'Negative cash flow last 2 quarters; regulatory delays.','AI_ENGINE','2026-04-15 00:02:43'),(7,7,28.70,'LOW','2025-03-12','AURA-RM-v3.1',720,30.00,0.0250,'Stable contracts with e-commerce clients; good fleet utilisation.','AI_ENGINE','2026-04-15 00:02:43'),(8,8,78.00,'VERY_HIGH','2025-03-17','AURA-RM-v3.1',540,62.40,0.1150,'Pre-revenue stage; cash runway < 6 months.','AI_ENGINE','2026-04-15 00:02:43'),(9,9,48.60,'MEDIUM','2025-03-25','AURA-RM-v3.2',690,38.90,0.0510,'Seasonal revenue; export demand softening in EU market.','AI_ENGINE','2026-04-15 00:02:43'),(10,10,15.20,'LOW','2025-04-04','AURA-RM-v3.2',830,16.30,0.0095,'PPA signed with SECI for 25 yrs; strong sponsor.','AI_ENGINE','2026-04-15 00:02:43'),(11,12,35.40,'MEDIUM','2025-04-20','AURA-RM-v3.2',710,33.70,0.0340,'Healthy order book; minor concern on capex timeline.','AI_ENGINE','2026-04-15 00:02:43'),(12,13,40.00,'MEDIUM','2025-05-03','AURA-RM-v3.2',800,25.00,0.0290,'Commodity price volatility flagged; hedging in place.','AI_ENGINE','2026-04-15 00:02:43'),(13,14,20.80,'LOW','2025-05-10','AURA-RM-v3.2',820,19.50,0.0140,'Blue-chip sponsor; robust project IRR above 18%.','AI_ENGINE','2026-04-15 00:02:43'),(14,16,55.30,'MEDIUM','2025-05-24','AURA-RM-v3.2',650,45.60,0.0670,'Small fleet; single-client dependency risk.','AI_ENGINE','2026-04-15 00:02:43'),(15,18,24.00,'LOW','2025-06-12','AURA-RM-v3.2',780,21.80,0.0160,'Proven track record in renewables O&M.','AI_ENGINE','2026-04-15 00:02:43'),(16,20,38.90,'MEDIUM','2025-06-27','AURA-RM-v3.2',700,37.20,0.0420,'Greenfield risk; however, strong OEM partnerships.','AI_ENGINE','2026-04-15 00:02:43'),(17,3,39.00,'MEDIUM','2025-02-15','AURA-RM-v3.1',760,34.00,0.0400,'Revised after additional financial disclosures; moderate risk.','Rajesh Iyer','2026-04-15 00:02:43'),(18,6,74.80,'HIGH','2025-03-08','AURA-RM-v3.1',580,56.20,0.0950,'Manual review confirms high risk; recommend rejection.','Karthik Rajan','2026-04-15 00:02:43'),(19,9,46.00,'MEDIUM','2025-03-30','AURA-RM-v3.2',695,37.50,0.0480,'Updated with latest export order confirmations.','Priya Nair','2026-04-15 00:02:43'),(20,16,52.10,'MEDIUM','2025-05-28','AURA-RM-v3.2',655,44.80,0.0640,'Slight improvement after new contract signed, still high.','Vikram Singh','2026-04-15 00:02:43'),(21,21,45.00,'MEDIUM','2026-04-15','AURA-RM-v3.2',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-15 00:02:43'),(22,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:08:01'),(23,2,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:28:52'),(24,2,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:29:03'),(25,2,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:29:13'),(26,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:31:29'),(27,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:33:32'),(28,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:33:35'),(29,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:35:00'),(30,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:35:07'),(31,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:36:51'),(32,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:36:53'),(33,5,65.00,'HIGH','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:36:54'),(34,6,35.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:39:48'),(35,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:40:13'),(36,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:40:17'),(37,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:40:19'),(38,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:40:20'),(39,32,20.00,'LOW','2026-04-26','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-26 21:40:21'),(40,32,20.00,'LOW','2026-04-27','AURA-v1.0',NULL,NULL,NULL,NULL,'AI_ENGINE','2026-04-27 00:15:57');
/*!40000 ALTER TABLE `risk_assessment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_band`
--

DROP TABLE IF EXISTS `risk_band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `risk_band` (
  `band_id` int NOT NULL AUTO_INCREMENT,
  `risk_category` varchar(20) NOT NULL,
  `min_score` decimal(5,2) NOT NULL,
  `max_score` decimal(5,2) NOT NULL,
  PRIMARY KEY (`band_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_band`
--

LOCK TABLES `risk_band` WRITE;
/*!40000 ALTER TABLE `risk_band` DISABLE KEYS */;
INSERT INTO `risk_band` VALUES (1,'LOW',0.00,34.99),(2,'MEDIUM',35.00,59.99),(3,'HIGH',60.00,74.99),(4,'VERY_HIGH',75.00,89.99),(5,'CRITICAL',90.00,100.00);
/*!40000 ALTER TABLE `risk_band` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `high_risk_loans`
--

/*!50001 DROP VIEW IF EXISTS `high_risk_loans`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */

/*!50001 VIEW `high_risk_loans` AS select `la`.`application_id` AS `application_id`,`la`.`application_number` AS `application_number`,`c`.`company_name` AS `company_name`,`la`.`requested_amount` AS `requested_amount`,concat(`lo`.`first_name`,' ',`lo`.`last_name`) AS `officer_name`,`ra`.`risk_score` AS `risk_score`,`ra`.`risk_category` AS `risk_category` from (((`loan_application` `la` join `company` `c` on((`la`.`company_id` = `c`.`company_id`))) join `loan_officer` `lo` on((`la`.`officer_id` = `lo`.`officer_id`))) join `risk_assessment` `ra` on((`la`.`application_id` = `ra`.`application_id`))) where (`ra`.`risk_category` = 'HIGH') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `officer_performance_summary`
--

/*!50001 DROP VIEW IF EXISTS `officer_performance_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */

/*!50001 VIEW `officer_performance_summary` AS select `lo`.`officer_id` AS `officer_id`,concat(`lo`.`first_name`,' ',`lo`.`last_name`) AS `officer_name`,`lo`.`designation` AS `designation`,count(distinct `la`.`application_id`) AS `total_loans`,round(avg(`ra`.`risk_score`),2) AS `avg_risk_score`,sum((case when (`lout`.`decision` = 'REJECTED') then 1 else 0 end)) AS `rejections` from (((`loan_officer` `lo` left join `loan_application` `la` on((`lo`.`officer_id` = `la`.`officer_id`))) left join `risk_assessment` `ra` on((`la`.`application_id` = `ra`.`application_id`))) left join `loan_outcome` `lout` on((`la`.`application_id` = `lout`.`application_id`))) group by `lo`.`officer_id`,`lo`.`first_name`,`lo`.`last_name`,`lo`.`designation` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_loan_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `pending_loan_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */

/*!50001 VIEW `pending_loan_dashboard` AS select `la`.`application_id` AS `application_id`,`la`.`application_number` AS `application_number`,`c`.`company_name` AS `company_name`,`c`.`annual_revenue` AS `annual_revenue`,`la`.`requested_amount` AS `requested_amount`,`la`.`application_date` AS `application_date`,(to_days(curdate()) - to_days(`la`.`application_date`)) AS `days_pending` from (`loan_application` `la` join `company` `c` on((`la`.`company_id` = `c`.`company_id`))) where (`la`.`status` in ('SUBMITTED','UNDER_REVIEW','RISK_ASSESSMENT')) order by (to_days(curdate()) - to_days(`la`.`application_date`)) desc */;
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

-- Dump completed on 2026-04-28 20:20:25

