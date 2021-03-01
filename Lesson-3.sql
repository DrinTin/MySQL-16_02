CREATE SCHEMA IF NOT EXISTS `vk1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `vk1` ;

-- -----------------------------------------------------
-- создаем таблицу паролей
-- это необходимо чтобы обезапасить пользователя, так как при получении доступа к таблице users
-- у злоумышлеников есть возможность получить контроль над учетной записью.
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`password` ;

CREATE TABLE IF NOT EXISTS `vk1`.`password` (
  `password_hash` CHAR(65) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_password_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_password_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Создаем таблицу пользователей (1)
-- по хорошему стоит вынести телефон и почту в отдельную таблицу 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`user` ;

CREATE TABLE IF NOT EXISTS `vk1`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(245) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  `phone` BIGINT NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу сообществ (3)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`community` ;

CREATE TABLE IF NOT EXISTS `vk1`.`community` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  `text` TEXT CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `admin_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_community_user1_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `fk_community_user1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу дружды (4)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`friend_request` ;

CREATE TABLE IF NOT EXISTS `vk1`.`friend_request` (
  `from_user_id` INT UNSIGNED NOT NULL,
  `to_user_id` INT UNSIGNED NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '-1 - отказ\\n0 - запрос\\n1 - дружба',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`from_user_id`, `to_user_id`),
  INDEX `fk_friend_request_user1_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `fk_friend_request_user2_idx` (`to_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_friend_request_user1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk1`.`user` (`id`),
  CONSTRAINT `fk_friend_request_user2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу типов медиафайлов (5)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`media_type` ;

CREATE TABLE IF NOT EXISTS `vk1`.`media_type` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу медиа (6)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`media` ;

CREATE TABLE IF NOT EXISTS `vk1`.`media` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_type_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `url` VARCHAR(45) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `blob` BLOB NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_media_media_type1_idx` (`media_type_id` ASC) VISIBLE,
  INDEX `fk_media_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_type1`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `vk1`.`media_type` (`id`),
  CONSTRAINT `fk_media_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу сообщений (7)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`message` ;

CREATE TABLE IF NOT EXISTS `vk1`.`message` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` INT UNSIGNED NOT NULL,
  `to_user_id` INT UNSIGNED NOT NULL,
  `text` TEXT CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `media_id` INT UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_message_user1_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `fk_message_user2_idx` (`to_user_id` ASC) VISIBLE,
  INDEX `fk_message_media1_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_message_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk1`.`media` (`id`),
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk1`.`user` (`id`),
  CONSTRAINT `fk_message_user2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу постов (8)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`post` ;

CREATE TABLE IF NOT EXISTS `vk1`.`post` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `community_id` INT UNSIGNED NULL DEFAULT NULL,
  `text` TEXT CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `media_id` INT UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_post_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_post_community1_idx` (`community_id` ASC) VISIBLE,
  INDEX `fk_post_media1_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk1`.`community` (`id`),
  CONSTRAINT `fk_post_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk1`.`media` (`id`),
  CONSTRAINT `fk_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу профилей (9)
-- адрес изменил на страну и город, так как нам не нужно знать точный адрес пользователя, 
-- страна и город смогут помочь в поиске.
-- Также имя и фамилию перенес из пользователей в профили
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`profile` ;

CREATE TABLE IF NOT EXISTS `vk1`.`profile` (
  `user_id` INT UNSIGNED NOT NULL,
  `firstname` VARCHAR(245) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  `lastname` VARCHAR(245) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  `gender` SET('m', 'f', 'x') NOT NULL,
  `birthday` DATE NOT NULL,
  `country` VARCHAR(245) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `city` VARCHAR(245) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NULL DEFAULT NULL,
  `photo_id` INT UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_profile_media1_idx` (`photo_id` ASC) VISIBLE,
  CONSTRAINT `fk_profile_media1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `vk1`.`media` (`id`),
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу сообществ пользователя (10)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`user_community` ;

CREATE TABLE IF NOT EXISTS `vk1`.`user_community` (
  `community_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`community_id`, `user_id`),
  INDEX `fk_user_community_community1_idx` (`community_id` ASC) VISIBLE,
  INDEX `fk_user_community_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_community_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk1`.`community` (`id`),
  CONSTRAINT `fk_user_community_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- создаем таблицу лайков (11)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vk1`.`likes` ;

CREATE TABLE IF NOT EXISTS `vk1`.`likes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` INT UNSIGNED NULL DEFAULT NULL,
  `user_id` INT UNSIGNED NULL DEFAULT NULL,
  `like_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_likes_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_likes_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_likes_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `vk1`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_likes_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk1`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


