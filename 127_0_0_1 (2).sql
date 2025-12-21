-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 21, 2025 at 06:08 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `coffee_shop`
--
CREATE DATABASE IF NOT EXISTS `coffee_shop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `coffee_shop`;

-- --------------------------------------------------------

--
-- Table structure for table `checkout_history`
--

CREATE TABLE `checkout_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `total` double DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkout_history`
--

INSERT INTO `checkout_history` (`id`, `user_id`, `total`, `created_at`) VALUES
(1, 9, 22000, '2025-12-20 14:57:40'),
(2, 9, 80000, '2025-12-20 14:58:22'),
(3, 9, 129000, '2025-12-20 14:59:22'),
(4, 9, 25000, '2025-12-20 15:01:58'),
(5, 9, 20000, '2025-12-20 15:04:03'),
(6, 9, 20000, '2025-12-20 15:19:07'),
(7, 9, 74000, '2025-12-20 15:19:32'),
(8, 9, 32000, '2025-12-20 21:29:22'),
(9, 9, 20000, '2025-12-20 21:29:46'),
(10, 9, 94000, '2025-12-20 21:31:10'),
(11, 9, 94000, '2025-12-21 10:21:49'),
(12, 9, 25000, '2025-12-21 10:29:41');

-- --------------------------------------------------------

--
-- Table structure for table `checkout_items`
--

CREATE TABLE `checkout_items` (
  `id` int(11) NOT NULL,
  `history_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `price` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkout_items`
--

INSERT INTO `checkout_items` (`id`, `history_id`, `product_name`, `price`) VALUES
(1, 1, 'Americano', 22000),
(2, 2, 'Macchiato', 24000),
(3, 2, 'Iced Coffee', 26000),
(4, 2, 'Mocha', 30000),
(5, 3, 'Latte', 25000),
(6, 3, 'Cappuccino', 27000),
(7, 3, 'Flat White', 28000),
(8, 3, 'Iced Coffee', 26000),
(9, 3, 'Chai Latte', 23000),
(10, 4, 'Latte', 25000),
(11, 5, 'Espresso', 20000),
(12, 6, 'Espresso', 20000),
(13, 7, 'Cappuccino', 27000),
(14, 7, 'Americano', 22000),
(15, 7, 'Latte', 25000),
(16, 8, 'Frappuccino', 32000),
(17, 9, 'Espresso', 20000),
(18, 10, 'Latte', 25000),
(19, 10, 'Americano', 22000),
(20, 10, 'Macchiato', 24000),
(21, 10, 'Chai Latte', 23000),
(22, 11, 'Latte', 25000),
(23, 11, 'Espresso', 20000),
(24, 11, 'Cappuccino', 27000),
(25, 11, 'Americano', 22000),
(26, 12, 'Latte', 25000);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image`) VALUES
(1, 'Espresso', 'Strong black coffee', 20000.00, 'https://tse2.mm.bing.net/th/id/OIP.QvfUfKJod9afTA_aPHYrgAHaFb?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
(2, 'Latte', 'Coffee with milk', 25000.00, 'https://tse3.mm.bing.net/th/id/OIP.RiTs2B-5Zm2RTcQuEHuIjQHaHa?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
(3, 'Cappuccino', 'Coffee with foam', 27000.00, 'https://tse2.mm.bing.net/th/id/OIP.ghWt4ZPEQFDTgK623CScvwHaE8?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
(4, 'Americano', 'Espresso with hot water', 22000.00, 'https://eatthinkbemerry.com/wp-content/uploads/2023/04/What-Is-An-Americano-1.jpg'),
(5, 'Mocha', 'Coffee with chocolate and milk', 30000.00, 'https://assets.simpleviewinc.com/simpleview/image/upload/c_limit,q_75,w_1200/v1/crm/hamilton/thumbnail_Just-love-coffee-latte_91000229-5056-A36A-08B2E7AF8BBF2297-90ffff835056a36_910002e1-5056-a36a-080d30b3a197649c.jpg'),
(6, 'Flat White', 'Smooth espresso with microfoam', 28000.00, 'https://www.foodandwine.com/thmb/xQZv2CX6FO5331PYK7uGPF1we9Q=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Partners-Flat-White-FT-BLOG0523-b11f6273c2d84462954c2163d6a1076d.jpg'),
(7, 'Macchiato', 'Espresso with a dash of milk', 24000.00, 'https://tse1.mm.bing.net/th/id/OIP.uC9RcV3lK1I1X2INid7e3AHaEO?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
(8, 'Iced Coffee', 'Cold brewed coffee with ice', 26000.00, 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8aWNlZCUyMGNvZmZlZXxlbnwwfHwwfHx8MA%3D%3D'),
(9, 'Matcha Latte', 'Green tea with milk', 25000.00, 'https://tse1.mm.bing.net/th/id/OIP.-7M-6ALDHGAYoYD4HtLuXgHaJM?cb=ucfimg2&ucfimg=1&w=1221&h=1515&rs=1&pid=ImgDetMain&o=7&rm=3'),
(10, 'Chai Latte', 'Spiced tea with milk', 23000.00, 'https://midwestniceblog.com/wp-content/uploads/2022/09/chai-tea-latte-recipe-683x1024.jpg'),
(11, 'Hot Chocolate', 'Rich chocolate drink', 22000.00, 'https://www.prettyopinionated.com/wp-content/uploads/2023/11/classic-hot-chocolate.jpg'),
(12, 'Caramel Latte', 'Latte with caramel syrup', 28000.00, 'https://www.julieseatsandtreats.com/wp-content/uploads/2021/06/Caramel-Latte-4-of-6-750x1128.jpg'),
(13, 'Vanilla Latte', 'Latte with vanilla syrup', 28000.00, 'https://tse3.mm.bing.net/th/id/OIP.LiNijiIrhI6GAS_wOhF9awHaLG?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
(14, 'Affogato', 'Espresso poured over ice cream', 35000.00, 'https://img.freepik.com/premium-photo/affogato-coffee-with-ice-cream-black-white-background_972841-165.jpg'),
(15, 'Frappuccino', 'Blended coffee with ice and milk', 32000.00, 'https://minichef.net/wp-content/uploads/2020/05/frappuccino.jpg'),
(16, 'Matcha Strawberry', 'Green tea with strawberry flavor and milk', 27000.00, 'https://thewillowskitchen.com/wp-content/uploads/2022/07/iced-strawberry-matcha-01-1170x1755.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `photo_path`, `created_at`) VALUES
(7, 'Andi@gmail.com', '$2y$10$raGqE6jnBS4pRucq5lb7tuNbIxPOyBlr7L8lTpEVGTPd3efUGiySu', 'uploads/profile/profile_7.jpg', '2025-12-20 04:22:33'),
(8, 'Beni@gmail.com', '$2y$10$kZICS3NnmayFk1Px.b65Ze4BpegWIb85.o5TUD/H7BPYTFGLTmaUW', 'uploads/profile/profile_8.jpg', '2025-12-20 04:23:26'),
(9, 'Cici@gmail.com', '$2y$10$E3B4uJYxHcIjdfpe5tkXReslHuxO.db4DbT8.DFbV/kKFGUiho35i', 'uploads/profile/profile_9.jpg', '2025-12-20 04:26:10'),
(10, 'Doni@gmail.com', '$2y$10$MhBeW5xtUpmhIBDkrqWDPO0lYDKCbA0A3jo17nCAZ4gDGOL.B6X3m', 'uploads/profile/profile_10.jpg', '2025-12-21 02:35:32'),
(11, 'fedriko@gmail.com', '$2y$10$VQD.c6bikLRHr5FWfV5pvufloXex7Y/KhrDTMQ4Tzu8Qiy8NdKOp6', 'uploads/profile/profile_11.jpg', '2025-12-21 02:37:48');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `checkout_history`
--
ALTER TABLE `checkout_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `checkout_items`
--
ALTER TABLE `checkout_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `checkout_history`
--
ALTER TABLE `checkout_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `checkout_items`
--
ALTER TABLE `checkout_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
