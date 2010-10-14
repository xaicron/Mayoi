DROP DATABASE IF EXISTS mayoi;
CREATE DATABASE mayoi;

use mayoi;

CREATE TABLE `user_data` (
    `id` bigint PRIMARY KEY,
    `name` char(24) NOT NULL,
    `disabled`  tinyint(4) NOT NULL DEFAULT 0,
    `created_on` int(10) NOT NULL,
    `updated_on` int(10) NOT NULL,
    INDEX index_name (name),
    INDEX index_created_on (created_on)
) ENGINE=inno_db, DEFAULT CHARACTER SET 'utf8';

CREATE TABLE `following` (
    `user_id` bigint NOT NULL,
    `target_id` bigint NOT NULL,
    `disabled`  tinyint(4) NOT NULL DEFAULT 0,
    `created_on` int(10) NOT NULL,
    `updated_on` int(10) NOT NULL,
    UNIQUE KEY index_following (`target_id`,`user_id`),
    INDEX index_user_id_created_on (`user_id`, `created_on`)
) ENGINE=inno_db;

CREATE TABLE `tweet` (
    `id` bigint PRIMARY KEY,
    `user_id` bigint NOT NULL,
    `tweet` char(140) NOT NULL,
    `is_public` tinyint(4) NOT NULL DEFAULT 1,
    `disabled` tinyint(4) NOT NULL DEFAULT 0,
    `created_on` int(10) NOT NULL,
    `updated_on` int(10) NOT NULL,
    INDEX index_user_id (user_id),
    INDEX index_user_id_created_on (user_id, created_on),
    INDEX index_user_id_is_public (user_id, is_public)
) ENGINE=inno_db, DEFAULT CHARACTER SET 'utf8';

CREATE TABLE `seq_user_data` (
    `id` bigint PRIMARY KEY
) ENGINE=inno_db;

CREATE TABLE `seq_tweet` (
    `id` bigint PRIMARY KEY
) ENGINE=inno_db;

DELIMITER //
CREATE PROCEDURE `disable_all_following` ( IN a_user_id BIGINT )
    BEGIN
        UPDATE following SET disabled = 1 WHERE user_id = a_user_id;
    END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `disable_all_tweet` ( IN a_user_id BIGINT )
    BEGIN
        UPDATE tweet SET disabled = 1 WHERE user_id = a_user_id;
    END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `disable_all_user_data_on_disabled_user_data` AFTER UPDATE ON `user_data`
    FOR EACH ROW BEGIN
        IF ( NEW.disabled <> 0 ) THEN
            CALL disable_all_following( NEW.id );
            CALL disable_all_tweet( NEW.id );
        END IF;
    END;
//
DELIMITER ;
