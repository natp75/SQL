/*
1)В базе данных shop и sample присутствуют одни и те же таблицы,
учебной базы данных. Переместите запись id = 1 из таблицы shop.users
в таблицу sample.users. Используйте транзакции.
*/

START TRANSACTION;
INSERT INTO shop
SELECT * FROM les9.example where id = 1;

COMMIT;