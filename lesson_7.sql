/*1) Составьте список пользователей users, которые осуществили хотя
бы один заказ orders в интернет магазине.*/

use lesson6;
SELECT login, name, `password`, is_admin
from users
where name in (select buyer from orders where buyer = name GROUP by buyer)

/* JOIN */

SELECT
    users.id, users.name
FROM
    users AS users
        JOIN
    orders AS orders
    ON
            users.name = orders.buyer


/*2) Выведите список товаров products и разделов catalogs,
который соответствует товару. */
SELECT
    id,
    name,
    price,
    (SELECT name FROM catalogs WHERE id = products.catalog_id) AS catalogs
FROM
    products;

/* 2 var*/

SELECT
    products.id,
    products.name,
    products.price,
    (SELECT
         catalogs.name FROM catalogs WHERE catalogs.id = products.catalog_id) AS catalogs
FROM
    products;


/* JOIN */


SELECT
    p.id,
    p.name,
    p.price,
    c.name as catalogs
FROM
    products AS p
        LEFT JOIN
    catalogs AS c
ON
        p.catalog_id = c.id;



/*