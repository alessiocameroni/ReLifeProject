CREATE DATABASE IF NOT EXISTS dbReLife
	CHARACTER SET = 'utf8'
	COLLATE = 'utf8_unicode_ci';

USE dbReLife;

DROP TABLE IF EXISTS siteComment;

CREATE TABLE siteComment (
    codice INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    ora TIME NOT NULL,
    codiceUtente VARCHAR(20),
    codicePost INT,
    FOREIGN KEY (codiceUtente) REFERENCES siteUser(username),
    FOREIGN KEY (codicePost) REFERENCES sitePost(codice)
);

DROP PROCEDURE IF EXISTS addComment;
DELIMITER //
CREATE PROCEDURE addComment (
    param_codice INT,
    param_data DATE,
    param_ora TIME,
    param_codiceUtente VARCHAR(20),
    param_codicePost INT
)

DETERMINISTIC
BEGIN
    INSERT INTO siteComment(codice, data, ora, codiceUtente, codicePost)
    VALUES(param_codice, param_data, param_ora, param_codiceUtente, param_codicePost) ;
END //
DELIMITER ;