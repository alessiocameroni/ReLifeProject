CREATE DATABASE IF NOT EXISTS db11448
	CHARACTER SET = 'utf8'
	COLLATE = 'utf8_unicode_ci';

USE db11448;

DROP TABLE IF EXISTS siteComment;

CREATE TABLE siteComment (
    codice INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    ora TIME NOT NULL,
    testo VARCHAR(140) NOT NULL,
    codiceUtente VARCHAR(20),
    codicePost INT,
    FOREIGN KEY (codiceUtente) REFERENCES siteUser(username) ON DELETE CASCADE,
    FOREIGN KEY (codicePost) REFERENCES sitePost(codice) ON DELETE CASCADE
);

DROP PROCEDURE IF EXISTS addComment;
DELIMITER //
CREATE PROCEDURE addComment (
    param_data DATE,
    param_ora TIME,
    param_testo VARCHAR(140),
    param_codiceUtente VARCHAR(20),
    param_codicePost INT
)

DETERMINISTIC
BEGIN
    INSERT INTO siteComment(data, ora, testo, codiceUtente, codicePost)
    VALUES(param_data, param_ora, param_testo, param_codiceUtente, param_codicePost) ;
END //
DELIMITER ;