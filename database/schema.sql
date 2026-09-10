-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: co
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `Customer_ID` int NOT NULL,
  `Email_Address` varchar(255) NOT NULL,
  `Full_Name` varchar(150) NOT NULL,
  PRIMARY KEY (`Customer_ID`),
  UNIQUE KEY `Email_Address` (`Email_Address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `Inventory_Id` int NOT NULL,
  `Store_Id` int NOT NULL,
  `Product_Id` int NOT NULL,
  `Product_Inventory` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`Inventory_Id`),
  UNIQUE KEY `idx_store_product` (`Store_Id`,`Product_Id`),
  KEY `Product_Id` (`Product_Id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`Store_Id`) REFERENCES `stores` (`Store_Id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`Product_Id`) REFERENCES `products` (`Product_Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `Order_Id` int NOT NULL,
  `Line_Item_Id` int NOT NULL,
  `Product_Id` int NOT NULL,
  `Unit_Price` decimal(10,2) NOT NULL,
  `Quantity` int NOT NULL,
  `Shipment_Id` int DEFAULT NULL,
  PRIMARY KEY (`Order_Id`,`Line_Item_Id`),
  KEY `Product_Id` (`Product_Id`),
  KEY `Shipment_Id` (`Shipment_Id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`Order_Id`) REFERENCES `orders` (`Order_Id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`Product_Id`) REFERENCES `products` (`Product_Id`) ON DELETE RESTRICT,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`Shipment_Id`) REFERENCES `shipments` (`Shipment_Id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `Order_Id` int NOT NULL,
  `Order_Tms` timestamp(6) NOT NULL,
  `Customer_ID` int NOT NULL,
  `Order_Status` varchar(50) NOT NULL,
  `Store_Id` int NOT NULL,
  PRIMARY KEY (`Order_Id`),
  KEY `Customer_ID` (`Customer_ID`),
  KEY `Store_Id` (`Store_Id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `customers` (`Customer_ID`) ON DELETE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`Store_Id`) REFERENCES `stores` (`Store_Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `Product_Id` int NOT NULL,
  `Product_Name` varchar(150) NOT NULL,
  `Unit_Price` decimal(10,2) NOT NULL,
  `Product_Details` text,
  `Product_Image` blob,
  `Image_Mime_Type` varchar(50) DEFAULT NULL,
  `Image_Filename` varchar(150) DEFAULT NULL,
  `Image_Charset` varchar(50) DEFAULT NULL,
  `Image_Last_Updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Product_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipments` (
  `Shipment_Id` int NOT NULL,
  `Store_Id` int DEFAULT NULL,
  `Customer_Id` int DEFAULT NULL,
  `Delivery_Address` text NOT NULL,
  `Shipment_Status` varchar(50) NOT NULL,
  PRIMARY KEY (`Shipment_Id`),
  KEY `Store_Id` (`Store_Id`),
  KEY `Customer_Id` (`Customer_Id`),
  CONSTRAINT `shipments_ibfk_1` FOREIGN KEY (`Store_Id`) REFERENCES `stores` (`Store_Id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_ibfk_2` FOREIGN KEY (`Customer_Id`) REFERENCES `customers` (`Customer_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stores`
--

DROP TABLE IF EXISTS `stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stores` (
  `Store_Id` int NOT NULL,
  `Store_Name` varchar(150) NOT NULL,
  `Web_Address` varchar(255) DEFAULT NULL,
  `Physical_Address` text,
  `Latitude` decimal(10,6) DEFAULT NULL,
  `Longitude` decimal(10,6) DEFAULT NULL,
  `Logo` blob,
  `Logo_Mime_Type` varchar(50) DEFAULT NULL,
  `Logo_Filename` varchar(150) DEFAULT NULL,
  `Logo_Charset` varchar(50) DEFAULT NULL,
  `Logo_Last_Updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Store_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-10 13:58:55
