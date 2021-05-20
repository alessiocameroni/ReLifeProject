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
    codiceUtente VARCHAR(20),
    FOREIGN KEY (codiceUtente) REFERENCES siteUser(username)
);

DROP PROCEDURE IF EXISTS addPost;
DELIMITER //
CREATE PROCEDURE addPost (
    param_codice INT,
    param_data DATE,
    param_ora TIME,
    param_fileImmagine LONGBLOB,
    param_codiceUtente VARCHAR(20)
)

DETERMINISTIC
BEGIN
    INSERT INTO sitePost(codice, data, ora, param_fileImmagine, codiceUtente)
    VALUES(param_codice, param_data, param_ora, param_fileImmagine, param_codiceUtente) ;
END //
DELIMITER ;