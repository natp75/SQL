/*
 1) БД для интернет-магазина одежды. Так же в ней можно регистрировать пользователей
    у них возможен свой счет в магазине для покупки товаров
    , а так же возможность делать заказы и просматривать свои
 */
DROP DATABASE IF EXISTS mydb_shop;
CREATE DATABASE mydb_shop;
USE mydb_shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL,
    name VARCHAR(100) COMMENT 'Имя и Фамилия зарегистрированного пользователя',
    email VARCHAR(100) UNIQUE NOT NULL ,
    phone BIGINT UNSIGNED UNIQUE NOT NULL,
    gender CHAR(1), -- m , f
    birthday DATE,
    is_admin BIT DEFAULT 0,
    created_at DATETIME DEFAULT NOW()
) COMMENT 'Таблица зарег покупателей';


DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
    id SERIAL,
    name VARCHAR(128) UNIQUE NOT NULL
) COMMENT 'Названия брендов';


DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    id SERIAL,
    name VARCHAR(128) NOT NULL,
    discount TINYINT DEFAULT 0,
    alias_name VARCHAR(128)
) COMMENT 'Таблица категорий товара';


DROP TABLE IF EXISTS product_type;
CREATE TABLE product_type (
    id SERIAL,
    name VARCHAR(128) NOT NULL UNIQUE
) COMMENT 'Типы товаров';


DROP TABLE IF EXISTS country_of_manufacture;
CREATE TABLE country_of_manufacture (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    name VARCHAR(100) UNIQUE NOT NULL
) COMMENT 'Страны производитель';


DROP TABLE IF EXISTS products;
CREATE TABLE products (
      id SERIAL,
      name VARCHAR(200) NOT NULL,
      brand_id BIGINT UNSIGNED NOT NULL,
      product_type_id BIGINT UNSIGNED NOT NULL,
      category_id BIGINT UNSIGNED NOT NULL,
      price DECIMAL(10,2) NOT NULL,
      article VARCHAR(128) DEFAULT NULL,
      discount TINYINT DEFAULT 0,
      INDEX (price, brand_id, product_type_id, category_id,discount),
      FOREIGN KEY (brand_id) REFERENCES brands(id),
      FOREIGN KEY (product_type_id) REFERENCES product_type(id),
      FOREIGN KEY (category_id) REFERENCES categories(id)
) COMMENT 'Таблица товаров';


DROP TABLE IF EXISTS products_media;
CREATE TABLE products_media (
    id SERIAL,
    product_media_id BIGINT UNSIGNED NOT NULL,
    `desc` TEXT,
    img_file BLOB,
    metadata JSON,
    made_in INT UNSIGNED NOT NULL,
    FOREIGN KEY (product_media_id) REFERENCES products(id)
                            ON UPDATE CASCADE
                            ON DELETE RESTRICT ,
    FOREIGN KEY (made_in) REFERENCES country_of_manufacture(id)
) COMMENT 'Описание товара';


DROP TABLE IF EXISTS sizes;
CREATE TABLE sizes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
) COMMENT 'Таблица размеров';


DROP TABLE IF EXISTS products_sizes;
CREATE TABLE products_sizes (
                       product_id BIGINT UNSIGNED NOT NULL,
                       size_id INT UNSIGNED NOT NULL,
                       count INT,
                       PRIMARY KEY (product_id, size_id),
                       FOREIGN KEY (product_id) REFERENCES products(id),
                       FOREIGN KEY (size_id) REFERENCES sizes(id)
) COMMENT 'Таблица размера конкретного товара и его кол-во';


DROP TABLE IF EXISTS product_rating;
CREATE TABLE product_rating (
    id SERIAL,
    product_id_rating BIGINT UNSIGNED NOT NULL,
    stars ENUM('0', '1', '2', '3', '4', '5') DEFAULT '0',
    FOREIGN KEY (product_id_rating) REFERENCES products(id)
) COMMENT 'Рейтинг товара';


DROP TABLE IF EXISTS product_comments;
CREATE TABLE product_comments (
    id SERIAL,
    product_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    useful INT DEFAULT 0,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW(),
    INDEX (created_at, useful),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'Комментарии товара';


DROP TABLE IF EXISTS user_bank_account;
CREATE TABLE user_bank_account (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    money DECIMAL(15,2) DEFAULT 0 NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'Денежные сред-ва юзера на сайте';


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id SERIAL,
    buyer BIGINT UNSIGNED NOT NULL,
    status ENUM('Принят', 'Оплачен', 'Отправлен', 'Доставлен') DEFAULT 'Принят',
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW(),
    INDEX (status, created_at, updated_at, buyer),
    FOREIGN KEY (buyer) REFERENCES users(id)
) COMMENT 'Таблица всех заказов';

DROP TABLE IF EXISTS order_products;
CREATE TABLE order_products (
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    count INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) COMMENT 'Таблица заказа и количество одного товара в нем';







SELECT
    name,
    (SELECT name from brands b2 WHERE products.brand_id = b2.id) as `brand`,
    (SELECT name FROM product_type pt WHERE products.product_type_id = pt.id) as `Тип товара`,
    (SELECT name FROM categories c2 WHERE products.category_id = c2.id) as `Категория`,
    price
from products
-- ;


-- Если пользователь выбрал фильтры какие-то то такой вложенный запрос будет
-- нужно добавить фильтрацию по бренду и типу товара
WHERE products.brand_id = (SELECT id from brands b3 WHERE name = 'Tommy Hilfiger') and
        products.product_type_id = (SELECT id from product_type pt2 WHERE name = 'Рубашки')
ORDER BY price;