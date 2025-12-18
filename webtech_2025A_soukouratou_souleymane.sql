-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 18, 2025 at 01:50 PM
-- Server version: 8.0.44-0ubuntu0.24.04.2
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `webtech_2025A_soukouratou_souleymane`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('SuperAdmin','Finance','Reviewer') COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password_hash`, `role`, `is_active`, `created_at`) VALUES
(7, 'karim', '$2y$10$qhBfYgkZsToRhyateDy.L.kGeoQo9ddBatz/XkjHPAFt23oFdl97W', 'SuperAdmin', 1, '2025-12-16 21:31:57');

-- --------------------------------------------------------

--
-- Table structure for table `bank_details`
--

CREATE TABLE `bank_details` (
  `id` int NOT NULL,
  `student_id` int NOT NULL,
  `bank_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `account_number` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Store encrypted bank account number',
  `iban` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0' COMMENT 'Admin approval required before payment',
  `last_updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bank_details`
--

INSERT INTO `bank_details` (`id`, `student_id`, `bank_name`, `account_number`, `iban`, `is_verified`, `last_updated`) VALUES
(1, 2, 'Ecobank', '123456789', NULL, 1, '2025-12-09 23:49:30'),
(14, 6, 'Ecobank', '99001122', 'NE12345678901', 1, '2025-12-18 11:39:11'),
(15, 7, 'Bank of Africa', '99001133', 'NE12345678902', 1, '2025-12-18 11:39:11'),
(16, 8, 'SONIBANK', '99001144', 'NE12345678903', 1, '2025-12-18 11:30:49'),
(17, 9, 'B_ORABANK', '99001155', 'NE12345678904', 1, '2025-12-18 11:39:11'),
(18, 10, 'Ecobank', '99001166', 'NE12345678905', 1, '2025-12-18 11:39:11'),
(19, 11, 'SONIBANK', '99001177', 'NE12345678906', 1, '2025-12-18 11:39:11'),
(20, 12, 'Bank of Africa', '99001188', 'NE12345678907', 1, '2025-12-18 11:39:11'),
(21, 13, 'B_ORABANK', '99001199', 'NE12345678908', 1, '2025-12-18 11:39:11'),
(22, 14, 'Ecobank', '99001100', 'NE12345678909', 1, '2025-12-18 11:39:11'),
(23, 15, 'SONIBANK', '99001111', 'NE12345678910', 1, '2025-12-18 11:39:11'),
(24, 18, 'BIN', '123456789', '', 0, '2025-12-18 13:38:54');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int NOT NULL,
  `student_id` int NOT NULL,
  `type` enum('SMS','EMAIL','IN_APP') COLLATE utf8mb4_general_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Summary of the notification content',
  `message` text COLLATE utf8mb4_general_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Secure, random token',
  `expires_at` datetime NOT NULL COMMENT 'Token must expire quickly (e.g., 30 mins)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_role` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'To check against students or admins table'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `user_id`, `token`, `expires_at`, `created_at`, `user_role`) VALUES
(1, 1, '98781d272efd7172f3653270308736e2a0bdb44f2aaa9e9481bc85399c743e10', '2025-12-16 20:56:35', '2025-12-16 19:26:35', 'admin'),
(3, 2, 'd27914cda06820fbddc3a5d1f1594bbe9e3fc091e5014ede4fba46270b21a911', '2025-12-16 22:07:08', '2025-12-16 20:37:08', 'student');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int NOT NULL,
  `student_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_month` date NOT NULL,
  `status` enum('Pending','Scheduled','Paid','Failed','Returned') COLLATE utf8mb4_general_ci NOT NULL,
  `disbursement_date` datetime DEFAULT NULL,
  `transaction_ref` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `admin_user_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `student_id`, `amount`, `payment_month`, `status`, `disbursement_date`, `transaction_ref`, `admin_user_id`, `created_at`) VALUES
(1, 2, 300.00, '0000-00-00', 'Scheduled', '2025-12-10 01:08:24', NULL, NULL, '2025-12-10 01:04:43'),
(2, 6, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(3, 7, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(4, 8, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(5, 9, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(6, 10, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(7, 11, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(8, 12, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(9, 13, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(10, 14, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11'),
(11, 15, 300000.00, '2025-12-01', 'Scheduled', '2025-12-18 11:53:26', NULL, 7, '2025-12-18 11:39:11');

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `id` int NOT NULL,
  `program_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `university_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int NOT NULL,
  `student_id` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `program_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `university_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=Inactive, 1=Active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_id`, `first_name`, `last_name`, `email`, `password_hash`, `phone`, `program_name`, `university_name`, `is_active`, `created_at`) VALUES
(2, '30832027', 'Soukouratou', 'Karim', 'soukourasouleymane@gmail.com', '$2y$10$rUmftxTJGycqGeCzEBoZh.uv.EZpT.ey3CShJrk6NHOsCQymvAzCq', '+22780884753', 'Computer Science', 'African Development University', 1, '2025-12-09 23:47:52'),
(6, '30802027', 'Ramatou', 'AMIDOU', 'ramatou@gmail.com', '$2y$10$8TsIUCgYy74AJ1lexDuwFOSIQ33JO6Yo5szLR739c0I1zSmyD1Fqe', '+22780884750', NULL, 'University of Niamey', 1, '2025-12-17 21:35:45'),
(7, 'STU001', 'Amadou', 'Sani', 'amadou.s@example.com', '$2y$10$0mxGHy6zYfREuzk6FhGulurkKQcn9jRezuHjAuNo/arpfEImHqIu6', '+2279000000', 'Economics', 'African Development University', 1, '2025-12-18 10:27:02'),
(8, 'STU002', 'Fatima', 'Oumarou', 'fatima.o@example1.com', '$2y$10$YBlbq5j4vEhn8HoIXRBWZ.HbEUydfPxUMrvw07hK7YvVpdP4wjfRK', '+22790000002', 'Computer Science', 'African Development University', 1, '2025-12-18 10:27:02'),
(9, 'STU003', 'Ibrahim', 'Moussa', 'ibrahim.m@example.com', '$2y$10$fakesalt3', '+22790000003', 'Law', 'Niamey Institute of Tech', 1, '2025-12-18 10:27:02'),
(10, 'STU004', 'Zainab', 'Abdou', 'zainab.a@example.com', '$2y$10$fakesalt4', '+22790000004', 'Marketing', 'African Development University', 1, '2025-12-18 10:27:02'),
(11, 'STU005', 'Ousmane', 'Bako', 'ousmane.b@example.com', '$2y$10$3fIR1Q35BgYZ4gykR/J2qesrce4gjYGy23Td4paXVtrIEkEpFMlSa', '+22790000000', 'Data Science', 'African Development University', 1, '2025-12-18 10:27:02'),
(12, 'STU006', 'Mariama', 'Issa', 'mariama.i@example.com', '$2y$10$4t3NgwmJYpoKZjv4j3nVNe4qCewvjECkd4Pb0zdvieKvJBLu6HYhW', '+22790000006', 'Nursing', 'Niamey Institute of Tech', 1, '2025-12-18 10:27:02'),
(13, 'STU007', 'Abdoulaye', 'Garba', 'abdoulaye.g@example.com', '$2y$10$fakesalt7', '+22790000007', 'Software Engineering', 'Niamey Institute of Tech', 0, '2025-12-18 10:27:02'),
(14, 'STU008', 'Rahamatou', 'Salifou', 'rahamatou.s@example.com', '$2y$10$fakesalt8', '+22790000008', 'Accounting', 'African Development University', 0, '2025-12-18 10:27:02'),
(15, 'STU009', 'Hamidou', 'Adamou', 'hamidou.a@example.com', '$2y$10$fakesalt9', '+22790000009', 'Public Admin', 'African Development University', 0, '2025-12-18 10:27:02'),
(16, 'STU010', 'Aichatou', 'Djibo', 'aichatou.d@example.com', '$2y$10$fakesalt10', '+22790000010', 'Business IT', 'Niamey Institute of Tech', 1, '2025-12-18 10:27:02'),
(17, '3078', 'souk', 'souley', 'souk@gmail.com', '$2y$10$w8pb9o0UOnUFLJHsNznDnOCjU0vPntHmfGqgElYkLqFKsIK6jeRrm', '+22793545243', 'Droit', 'UAT', 0, '2025-12-18 12:44:33'),
(18, '3098', 'hi', 'nana', 'nana@gmail.com', '$2y$10$s35DNfPfFb72OalgndfdvuLLb3TNzTTu3jMjLP1Ld9ByuuIMQX.aW', '+22790000088', 'BA', 'UAT', 1, '2025-12-18 13:35:42');

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int NOT NULL,
  `student_id` int NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('Open','In_Progress','Resolved','Closed') COLLATE utf8mb4_general_ci DEFAULT 'Open',
  `priority` enum('Low','Medium','High','Urgent') COLLATE utf8mb4_general_ci DEFAULT 'Medium',
  `assigned_to_admin_id` int DEFAULT NULL COMMENT 'Which admin user is handling this ticket',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `bank_details`
--
ALTER TABLE `bank_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_ref` (`transaction_ref`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `admin_user_id` (`admin_user_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `assigned_to_admin_id` (`assigned_to_admin_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `bank_details`
--
ALTER TABLE `bank_details`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bank_details`
--
ALTER TABLE `bank_details`
  ADD CONSTRAINT `bank_details_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`admin_user_id`) REFERENCES `admin_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`assigned_to_admin_id`) REFERENCES `admin_users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
