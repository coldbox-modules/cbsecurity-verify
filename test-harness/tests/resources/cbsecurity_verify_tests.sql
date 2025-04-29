CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `email`, `password`) VALUES
(1, 'john@example.com', '$2a$12$KlwjZtwn5P/ZTsTpwu//XuapsxAjiYfXnLv3Rnx6K7dfLKtF.n29q');