/*
 1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи
 в таблицах users, catalogs и products в таблицу logs помещается время
 и дата создания записи, название таблицы, идентификатор
 первичного ключа и содержимое поля name.
 */


use les10;


DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    -- id SERIAL PRIMARY KEY,
                      created_at DATETIME NOT NULL,
                      nametable VARCHAR(50) NOT NULL,
                      id BIGINT NOT NULL,
                      value VARCHAR(50) NOT NULL
) ENGINE = ARCHIVE;
DROP TRIGGER IF EXISTS user_trigger;


DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` TRIGGER `user_trigger` AFTER INSERT ON users FOR EACH ROW BEGIN
    INSERT INTO logs (created_at, nametable, id, value)
    VALUES (NOW(), 'users', NEW.id, NEW.lastname);
END$$
DELIMITER ;

-- добавляем

INSERT INTO users (firstname , lastname)
VALUES ('Nikita', 'Razlivanov');









/*
 2) (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */



use les10;

DROP TABLE IF EXISTS usersmilion;
CREATE TABLE usersmilion (
                             id SERIAL PRIMARY KEY,
                             name VARCHAR(255)
);



DROP PROCEDURE IF EXISTS les9.sp_millionusers;

DELIMITER $$
$$
CREATE PROCEDURE les9.sp_millionusers(countfor_add INT, OUT result_for_admin VARCHAR(50))
BEGIN
    DECLARE i int DEFAULT 0;
    DECLARE `_rollback` BIT DEFAULT 0;
    DECLARE code varchar(100);
    DECLARE error_string varchar(100);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        begin
            SET `_rollback` = 1;
            GET stacked DIAGNOSTICS CONDITION 1
                code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
            set result_for_admin := concat('Error occured. Code: ', code, '. Text: ', error_string);
        end;
    start TRANSACTION;
    WHILE i < countfor_add DO
            INSERT INTO usersmilion (name) VALUES (concat('user_name_', i));
            set i = i + 1;

        END WHILE;
    IF `_rollback` THEN
        ROLLBACK;
    ELSE
        set result_for_admin := 'ok';
        COMMIT;
    END IF;

END $$
DELIMITER ;



select * from usersmilion;

call les9.sp_millionusers(10, @res);

SELECT @res;