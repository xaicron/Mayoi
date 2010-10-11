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

CREATE TABLE `friend` (
    `user_id` bigint PRIMARY KEY,
    `target_id` bigint NOT NULL,
    `disabled`  tinyint(4) NOT NULL DEFAULT 0,
    `created_on` int(10) NOT NULL,
    `updated_on` int(10) NOT NULL,
    INDEX index_target_id (target_id)
) ENGINE=inno_db;

CREATE TABLE `tweet` (
    `id` bigint PRIMARY KEY,
    `user_id` bigint NOT NULL,
    `tweet` char(140) NOT NULL,
    `is_public` tinyint(4) DEFAULT 1,
    `created_on` int(10) NOT NULL,
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
