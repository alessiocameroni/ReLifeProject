CREATE DATABASE IF NOT EXISTS dbReLife
	CHARACTER SET = 'utf8'
	COLLATE = 'utf8_unicode_ci';

USE dbReLife;

DROP TABLE IF EXISTS sitePost;

CREATE TABLE sitePost (
    codice INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    ora TIME NOT NULL,
    fileImmagine LONGBLOB NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    codiceUtente VARCHAR(20),
    FOREIGN KEY (codiceUtente) REFERENCES siteUser(username)
);

DROP PROCEDURE IF EXISTS addPost;
DELIMITER //
CREATE PROCEDURE addPost (
    param_data DATE,
    param_ora TIME,
    param_fileImmagine LONGBLOB,
    param_tipo VARCHAR(30),
    param_codiceUtente VARCHAR(20)
)

DETERMINISTIC
BEGIN
    INSERT INTO sitePost(data, ora, fileImmagine, tipo, codiceUtente)
    VALUES(param_data, param_ora, param_fileImmagine, param_tipo, param_codiceUtente) ;
END //
DELIMITER ;