-- Create database
CREATE DATABASE IF NOT EXISTS react_chat_db;
USE react_chat_db;


-- Create users table
CREATE TABLE IF NOT EXISTS `users` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `username`   VARCHAR(255) NOT NULL UNIQUE,
  `password`   VARCHAR(255) NOT NULL,
  `is_admin`   BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Create jwt_refresh_tokens table
CREATE TABLE IF NOT EXISTS `jwt_refresh_tokens` (
  `id`            INT AUTO_INCREMENT PRIMARY KEY,
  `user_id`       INT UNSIGNED NOT NULL,
  `refresh_token` TEXT NOT NULL,
  `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY `fk_refresh_tokens_user_id` (`user_id`) 
    REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);


-- Create conversation table
CREATE TABLE IF NOT EXISTS `conversations` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `title`      VARCHAR(255) NOT NULL UNIQUE,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Create junction table between users and conversations
CREATE TABLE IF NOT EXISTS `users_conversations` (
  `user_id` INT UNSIGNED NOT NULL,
  `conversation_id` INT UNSIGNED NOT NULL,

  PRIMARY KEY (`user_id`, `conversation_id`),

  CONSTRAINT `Constr_users_conversations_user_fk`
    FOREIGN KEY `user_fk` (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT `Constr_users_conversations_conversation_fk`
    FOREIGN KEY `conversation_fk` (`conversation_id`) REFERENCES `conversations` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);


-- create messages table

-- NOTE: in private conversation between 2 users,
-- add sender_id and receiver_id columns

CREATE TABLE IF NOT EXISTS `messages` (
  `id`               INT AUTO_INCREMENT PRIMARY KEY,
  `user_id`          INT UNSIGNED NOT NULL,
  `conversation_id`  INT UNSIGNED NOT NULL,
  `text`             TEXT NOT NULL,
  `created_at`       DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY `fk_messages_user_id` (`user_id`) 
    REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,

  FOREIGN KEY `fk_messages_conversation_id` (`conversation_id`)
    REFERENCES `conversations` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);


-- find all users for a given conversation
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS find_conversation_users(IN conversationId INT UNSIGNED)
BEGIN
  SELECT 
    users.* FROM users 
  JOIN 
    users_conversations ON users.id = users_conversations.user_id 
  WHERE 
    users_conversations.conversation_id = conversationId;
END $$
DELIMITER ;


-- find all conversations for a given user
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS find_user_conversations(IN userId INT UNSIGNED)
BEGIN
  SELECT 
    conversations.* FROM conversations
  JOIN 
    users_conversations ON conversations.id = users_conversations.conversation_id
  WHERE 
    users_conversations.user_id = userId;
END $$
DELIMITER ;


-- insert some data
-- INSERT INTO users (username, password) 
-- VALUES ('john_doe', 'pass1'), 
--        ('alice_jay', 'pass2'), 
--        ('bob_arch', 'pass3');
-- 
-- INSERT INTO conversations (title)
-- VALUES ('General'), 
--        ('Development'), 
--        ('MySQL');
-- 
-- INSERT INTO users_conversations (user_id, conversation_id) 
-- VALUES (1, 1), (1, 2),
--        (2, 1), (2, 2), (2, 3),
--        (3, 1), (3, 3);

