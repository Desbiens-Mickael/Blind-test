-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Jeu 26 Octobre 2017 à 13:53
-- Version du serveur :  5.7.19-0ubuntu0.16.04.1
-- Version de PHP :  7.0.22-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET GLOBAL time_zone = "+02:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `simple-mvc`
--

-- --------------------------------------------------------
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- --------------------------------------------------------

--
-- Structure de la table `track`
--

--


/* PENSER A FAIRE UN INSERT POUR LA TABLE category */
/* ET AJOUTER : CONSTRAINT fk_track_category FOREIGN KEY (category_id) REFERENCES category(id) */

-- --------------------------------------------------------

--
-- Structure de la table `category`
--
DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `image` varchar(255),
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `category`
--

INSERT INTO `category` (`id`, `name`, `image`) VALUES
(1, 'Anime', 'anime.jpeg'),
(2, 'Pop', 'photo-pop.jpeg'),
(3, 'Années 80', 'photo-80.jpeg'),
(4, 'Meme Song', 'meme.png');

 -- --------------------------------------------------------

--
-- Structure de la table `user`
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `nickname` varchar(80) NOT NULL,
  `image` varchar(255) DEFAULT 'perso.png',
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- supprime la table quizz_session si elle existe
DROP TABLE IF EXISTS `quizz_session`;

-- Structure de la table `quizz_session`
--
CREATE TABLE `quizz_session` (
    `id` int NOT NULL AUTO_INCREMENT,
    `startedAt` datetime DEFAULT NULL,
    `endedAt` datetime DEFAULT NULL,
    `user_id` int DEFAULT NULL,
    `score` int DEFAULT 0,
    `category_id` int DEFAULT NULL,
    PRIMARY KEY(`id`),
    CONSTRAINT fk_quizz_session_user
    FOREIGN KEY (user_id)
    REFERENCES user (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Structure de la table `track`
DROP TABLE IF EXISTS `track`;

CREATE TABLE `track` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(80) NOT NULL,
    `artist` varchar(80) NOT NULL,
    `path` varchar(255) NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY(`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Structure de la table `play`
DROP TABLE IF EXISTS `play`;

CREATE TABLE `play` (
    `id` int NOT NULL AUTO_INCREMENT,
    `quizz_session_id` int NOT NULL,
    `answer_id` int NOT NULL,
    PRIMARY KEY(`id`)
);

-- Structure de la table `answer`
DROP TABLE IF EXISTS `answer`;

CREATE TABLE `answer` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(150) NOT NULL,
    `track_id` int NOT NULL,
    PRIMARY KEY(`id`)
);

--
--
-- Foreign Key Constraint pour les tables :
--

ALTER TABLE `play`
ADD CONSTRAINT fk_play_answer FOREIGN KEY (answer_id) REFERENCES answer (id);

ALTER TABLE `play`
ADD CONSTRAINT fk_play_quizz_session FOREIGN KEY (quizz_session_id) REFERENCES quizz_session (id);

ALTER TABLE `track`
ADD CONSTRAINT fk_track_category FOREIGN KEY (category_id) REFERENCES category (id);

ALTER TABLE `answer`
ADD CONSTRAINT fk_answer_track FOREIGN KEY (track_id) REFERENCES track (id) ON DELETE CASCADE;
