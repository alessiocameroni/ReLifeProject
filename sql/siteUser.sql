CREATE DATABASE IF NOT EXISTS dbReLife
	CHARACTER SET = 'utf8'
	COLLATE = 'utf8_unicode_ci';

USE dbReLife;

DROP TABLE IF EXISTS siteUser;

CREATE TABLE siteUser (
    username VARCHAR(20) PRIMARY KEY,
    salt VARCHAR(32) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    luogo VARCHAR(50) NOT NULL
);

DROP PROCEDURE IF EXISTS addUser;
DELIMITER //
CREATE PROCEDURE addUser(
    param_username VARCHAR(20),
    param_password VARCHAR(20),
    param_nome VARCHAR(50),
    param_cognome VARCHAR(50),
    param_luogo VARCHAR(50)
)

DETERMINISTIC
BEGIN
	SET @s = MD5(RAND());
 	SET @h = SHA2(CONCAT(@s, param_password), 256);
    INSERT INTO siteUser(username, salt, password_hash, nome, cognome, luogo)
    VALUES (param_username, @s, @h, param_nome, param_cognome, param_luogo);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS siteUser_change_pwd;
DELIMITER //
CREATE PROCEDURE siteUser_change_pwd
(
    param_username VARCHAR(20),
    param_password VARCHAR(20)
)

DETERMINISTIC
BEGIN
	SET @s = MD5(RAND());
 	SET @h = SHA2(CONCAT(@s, param_password), 256);
    UPDATE siteUser
        SET salt = @s
        ,   password_hash = @h
        WHERE username = param_username;
END //
DELIMITER ;