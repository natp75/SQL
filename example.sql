/*Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.*/
CREATE DATABASE example;
USE example;
CREATE TABLE IF NOT EXISTS users (
	id  INT PRIMARY KEY,
    name VARCHAR(255)
);
 /*Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.*/
 CREATE DATABASE sample;
 mysqldump example > dump.SQL
 mysql sample < dump.SQL
