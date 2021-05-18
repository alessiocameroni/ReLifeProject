CREATE DATABASE IF NOT EXISTS dbReLife
	CHARACTER SET = 'utf8'
	COLLATE = 'utf8_unicode_ci';

USE dbReLife;

DROP TABLE IF EXISTS siteEmployee;

CREATE TABLE siteEmployee
(
    codice INT PRIMARY KEY AUTO_INCREMENT,
    cognome VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL
);

DROP PROCEDURE IF EXISTS addEmployee;
DELIMITER //
CREATE PROCEDURE addEmployee(
    param_cognome VARCHAR(50),
    param_nome VARCHAR(50)
)

DETERMINISTIC
BEGIN
    INSERT INTO siteEmployee(cognome, nome)
    VALUES(param_cognome, param_nome) ;
END //
DELIMITER ;